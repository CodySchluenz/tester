# Davis AI Event Validation Test Cases for IBM APIC EKS

## Test 1: Monitoring Unavailable Events

### Test Method 1.1: OneAgent Network Isolation
```bash
# Apply network policy blocking OneAgent egress traffic
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-oneagent-egress
  namespace: apic
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: oneagent
  policyTypes:
  - Egress
  egress: []
EOF

# Wait for OneAgent disconnection
sleep 60

# Verify network policy enforcement
kubectl describe networkpolicy block-oneagent-egress -n apic
```

### Test Method 1.2: OneAgent Process Termination
```bash
# Kill OneAgent processes on target nodes
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl debug node/$NODE_NAME -it --image=ubuntu -- chroot /host bash -c "
  pkill -f oneagent
  systemctl stop oneagent
"

# Verify process termination
kubectl get pods -n dynatrace -o wide | grep $NODE_NAME
```

### Expected Detection
- **Event Type**: MONITORING_UNAVAILABLE
- **Detection Time**: 30-60 seconds
- **Davis Response**: Host monitoring state changes to "Unmonitored"

### Rollback
```bash
kubectl delete networkpolicy block-oneagent-egress -n apic
kubectl debug node/$NODE_NAME -it --image=ubuntu -- chroot /host systemctl start oneagent
```

---

## Test 2: Availability Events

### Test Method 2.1: Pod Termination with Replica Prevention
```bash
# Scale gateway deployment to zero
kubectl scale deployment apic-gateway -n apic --replicas=0

# Force delete any remaining pods
kubectl delete pods -l app=apic-gateway -n apic --force --grace-period=0

# Verify no pods running
kubectl get pods -n apic -l app=apic-gateway
```

### Test Method 2.2: Service Port Blocking
```bash
# Block ingress traffic to management service
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-management-ingress
  namespace: apic
spec:
  podSelector:
    matchLabels:
      app: apic-management
  policyTypes:
  - Ingress
  ingress: []
EOF

# Test service unavailability
curl -k https://management.${APIC_DOMAIN}/health -m 5 || echo "Service unavailable"
```

### Test Method 2.3: Process Group Failure
```bash
# Terminate main application processes
kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- \
  pkill -f "management-server"

# Prevent process restart by corrupting binary
kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- \
  mv /opt/ibm/management-server /opt/ibm/management-server.bak
```

### Expected Detection
- **Event Type**: AVAILABILITY
- **Detection Time**: 3-5 minutes
- **Davis Response**: Process unavailable, service endpoint monitoring failures

### Rollback
```bash
kubectl scale deployment apic-gateway -n apic --replicas=3
kubectl delete networkpolicy block-management-ingress -n apic
kubectl rollout restart deployment/apic-management -n apic
```

---

## Test 3: Error Events

### Test Method 3.1: HTTP 500 Error Injection
```bash
# Deploy error injection proxy
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: error-injector
  namespace: apic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: error-injector
  template:
    metadata:
      labels:
        app: error-injector
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: config
        configMap:
          name: error-injector-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: error-injector-config
  namespace: apic
data:
  default.conf: |
    server {
        listen 80;
        location / {
            return 500 "Simulated Error";
            add_header Content-Type text/plain;
        }
    }
EOF

# Route 50% of traffic through error injector
kubectl patch service apic-gateway -n apic --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/selector/error-test",
    "value": "true"
  }
]'

# Label half the gateway pods for error routing
PODS=($(kubectl get pods -n apic -l app=apic-gateway -o jsonpath='{.items[*].metadata.name}'))
for ((i=0; i<${#PODS[@]}/2; i++)); do
  kubectl label pod ${PODS[$i]} -n apic error-test=true
done
```

### Test Method 3.2: Database Connection Pool Exhaustion
```bash
# Set PostgreSQL max_connections to minimum
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  psql -U postgres -c "ALTER SYSTEM SET max_connections = 3;"

kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  psql -U postgres -c "SELECT pg_reload_conf();"

# Generate connection attempts exceeding limit
for i in {1..20}; do
  kubectl run db-conn-test-$i --image=postgres:13 -n apic --rm -it --restart=Never -- \
    psql -h postgres.apic.svc.cluster.local -U postgres -c "SELECT pg_sleep(300);" &
done
```

### Test Method 3.3: Application Exception Generation
```bash
# Modify application configuration to generate exceptions
kubectl create configmap error-config -n apic --from-literal=error_rate=0.7 --dry-run=client -o yaml | kubectl apply -f -

# Restart pods to pick up error configuration
kubectl rollout restart deployment/apic-management -n apic

# Generate requests to trigger errors
for i in {1..200}; do
  curl -k https://management.${APIC_DOMAIN}/api/catalogs -X POST \
    -H "Content-Type: application/json" \
    -d '{"invalid": "data"}' &
done
```

### Expected Detection
- **Event Type**: ERROR
- **Detection Time**: 5-10 minutes
- **Davis Response**: Error rate increase above baseline threshold

### Rollback
```bash
kubectl delete deployment error-injector -n apic
kubectl delete configmap error-injector-config -n apic
kubectl patch service apic-gateway -n apic --type='json' -p='[
  {"op": "remove", "path": "/spec/selector/error-test"}
]'
kubectl label pods -n apic -l app=apic-gateway error-test-
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  psql -U postgres -c "ALTER SYSTEM SET max_connections = 100;"
kubectl delete configmap error-config -n apic
kubectl rollout restart deployment/apic-management -n apic
```

---

## Test 4: Resource Events

### Test Method 4.1: CPU Saturation (>90% for 5+ minutes)
```bash
# Install stress-ng on target pods
kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- \
  apt-get update && apt-get install -y stress-ng

# Generate CPU load at 95% utilization
CPU_CORES=$(kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- nproc)
kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- \
  stress-ng --cpu $CPU_CORES --cpu-load 95 --timeout 600s &

# Monitor CPU utilization
kubectl top pod -n apic $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}')
```

### Test Method 4.2: Memory Saturation (>90% + page faults)
```bash
# Calculate available memory
AVAILABLE_MEM=$(kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  free -m | awk 'NR==2{printf "%.0f", $7*0.95}')

# Allocate 95% of available memory
kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  stress-ng --vm 4 --vm-bytes ${AVAILABLE_MEM}M --vm-method flip --timeout 600s &

# Generate memory pressure with page faults
kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  stress-ng --page-in --timeout 600s &
```

### Test Method 4.3: Disk Space Saturation (>95% usage)
```bash
# Identify persistent volume mount
PV_PATH=$(kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  df -h | grep -E '/var|/opt' | head -1 | awk '{print $6}')

# Fill disk to 95% capacity
AVAILABLE_SPACE=$(kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  df -m $PV_PATH | tail -1 | awk '{printf "%.0f", $4*0.95}')

kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  dd if=/dev/zero of=$PV_PATH/test-fill bs=1M count=$AVAILABLE_SPACE

# Verify disk usage
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  df -h $PV_PATH
```

### Test Method 4.4: Network Bandwidth Saturation
```bash
# Install iperf3 for network testing
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  apt-get update && apt-get install -y iperf3

# Start iperf3 server
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  iperf3 -s -D

# Generate network saturation from multiple clients
GATEWAY_POD=$(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}')
GATEWAY_IP=$(kubectl get pod $GATEWAY_POD -n apic -o jsonpath='{.status.podIP}')

for i in {1..8}; do
  kubectl run network-load-$i --image=networkstatic/iperf3 -n apic --rm -it --restart=Never -- \
    iperf3 -c $GATEWAY_IP -t 600 -P 4 &
done
```

### Expected Detection
- **Event Type**: RESOURCE
- **Detection Time**: 3-5 minutes
- **Davis Response**: Resource saturation events with threshold breaches

### Rollback
```bash
# Kill stress processes
kubectl exec -it $(kubectl get pod -n apic -l app=apic-management -o jsonpath='{.items[0].metadata.name}') -- \
  pkill stress-ng

kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  pkill stress-ng

# Remove test files
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  rm -f $PV_PATH/test-fill

# Stop network load
kubectl delete pods -n apic -l run=network-load-*
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  pkill iperf3
```

---

## Test 5: Slowdown Events

### Test Method 5.1: Network Latency Injection (500ms+)
```bash
# Apply traffic control to add latency
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  tc qdisc add dev eth0 root netem delay 500ms 100ms distribution normal

# Verify latency applied
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  tc qdisc show dev eth0
```

### Test Method 5.2: Database Query Slowdown
```bash
# Create intentionally slow queries
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  psql -U postgres -d apicdb -c "
  CREATE OR REPLACE FUNCTION slow_join_query() RETURNS TABLE(result text) AS \$\$
  BEGIN
    RETURN QUERY
    SELECT pg_sleep(3)::text ||
           (SELECT string_agg(t1.column_name || t2.column_name, ',')
            FROM information_schema.columns t1
            CROSS JOIN information_schema.columns t2
            LIMIT 1000);
  END;
  \$\$ LANGUAGE plpgsql;"

# Execute slow queries repeatedly
for i in {1..50}; do
  kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
    psql -U postgres -d apicdb -c "SELECT slow_join_query();" &
done
```

### Test Method 5.3: I/O Throttling
```bash
# Limit I/O bandwidth to 1MB/s
kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  bash -c 'echo "8:0 1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device'

kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  bash -c 'echo "8:0 1048576" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device'

# Generate I/O load to trigger throttling
kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  dd if=/dev/zero of=/tmp/io-test bs=1M count=1000 oflag=direct &
```

### Test Method 5.4: Application Thread Pool Starvation
```bash
# Reduce application thread pool size
kubectl patch deployment apic-management -n apic --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/env/-",
    "value": {
      "name": "THREAD_POOL_SIZE",
      "value": "2"
    }
  }
]'

# Force deployment restart
kubectl rollout restart deployment/apic-management -n apic

# Generate concurrent requests to exhaust thread pool
for i in {1..50}; do
  curl -k https://management.${APIC_DOMAIN}/api/catalogs \
    -H "Authorization: Bearer $TOKEN" &
done
```

### Expected Detection
- **Event Type**: SLOWDOWN
- **Detection Time**: 10-15 minutes
- **Davis Response**: Response time degradation above baseline

### Rollback
```bash
# Remove network latency
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  tc qdisc del dev eth0 root netem

# Drop database slow query function
kubectl exec -it $(kubectl get pod -n apic -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- \
  psql -U postgres -d apicdb -c "DROP FUNCTION IF EXISTS slow_join_query();"

# Remove I/O throttling
kubectl exec -it $(kubectl get pod -n apic -l app=apic-analytics -o jsonpath='{.items[0].metadata.name}') -- \
  bash -c 'echo "8:0 0" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device'

# Restore thread pool configuration
kubectl patch deployment apic-management -n apic --type='json' -p='[
  {
    "op": "remove",
    "path": "/spec/template/spec/containers/0/env/-1"
  }
]'
```

---

## Validation Commands

### Check Davis AI Problem Detection
```bash
# Query Dynatrace API for open problems
curl -X GET "https://$DYNATRACE_ENV.live.dynatrace.com/api/v2/problems" \
  -H "Authorization: Api-Token $DYNATRACE_TOKEN" \
  -G --data-urlencode "problemSelector=status(\"OPEN\")" | jq '.problems[]'

# Monitor specific event types
curl -X GET "https://$DYNATRACE_ENV.live.dynatrace.com/api/v2/problems" \
  -H "Authorization: Api-Token $DYNATRACE_TOKEN" \
  -G --data-urlencode "problemSelector=severityLevel(\"MONITORING_UNAVAILABLE\",\"AVAILABILITY\",\"ERROR\",\"RESOURCE\",\"SLOWDOWN\")"
```

### Verify Resource Metrics
```bash
# Check current resource utilization
kubectl top nodes
kubectl top pods -n apic --sort-by=cpu
kubectl top pods -n apic --sort-by=memory

# Monitor network statistics
kubectl exec -it $(kubectl get pod -n apic -l app=apic-gateway -o jsonpath='{.items[0].metadata.name}') -- \
  cat /proc/net/dev
```

### Confirm System Recovery
```bash
# Verify all pods running
kubectl get pods -n apic -o wide | grep -v Running

# Check service endpoints
kubectl get endpoints -n apic

# Test API functionality
curl -k https://management.$APIC_DOMAIN/health
curl -k https://gateway.$APIC_DOMAIN/health
curl -k https://portal.$APIC_DOMAIN/health
curl -k https://analytics.$APIC_DOMAIN/health
```