# AWS Console Davis AI Event Validation Test Methods for IBM APIC EKS

## Test 1: Monitoring Unavailable Events

### Test Method 1.1: CloudWatch Agent Disruption via Systems Manager
**Objective**: Simulate monitoring agent disconnection through AWS console interfaces

**AWS Console Navigation Path**:
1. **AWS Systems Manager Console** → **Fleet Manager** → **Managed Instances**
2. Select target EKS worker nodes running APIC pods
3. **Actions** → **Start session** → **Session Manager**

**Technical Execution Steps**:
```bash
# Within Session Manager terminal:
sudo systemctl stop amazon-cloudwatch-agent
sudo systemctl disable amazon-cloudwatch-agent
sudo pkill -f cloudwatch-agent
```

**CloudWatch Validation**:
1. **CloudWatch Console** → **Insights** → **Container Insights**
2. Navigate to **EKS Clusters** → Select cluster → **Nodes** tab
3. Verify nodes show "No data available" status
4. **Metrics** → **Custom Namespaces** → Confirm missing CWAgent metrics

### Test Method 1.2: EKS Node Network Security Group Modification
**AWS Console Navigation Path**:
1. **EKS Console** → **Clusters** → Select APIC cluster → **Compute** tab
2. **Node Groups** → Select node group → **Details** → **Remote Access Security Group**
3. **EC2 Console** → **Security Groups** → Select node security group

**Security Group Rule Modification**:
1. **Inbound Rules** → **Edit inbound rules**
2. **Delete** all rules allowing CloudWatch agent communication (ports 443, 80)
3. **Outbound Rules** → **Edit outbound rules** 
4. **Delete** rules for `*.monitoring.*.amazonaws.com` destinations
5. **Save rules**

**Expected AWS Behavior**:
- **CloudWatch Container Insights**: Node monitoring status → "Disconnected"
- **EKS Console**: Node health checks begin failing within 2-3 minutes
- **Systems Manager**: Managed instance status → "Connection Lost"

---

## Test 2: Availability Events

### Test Method 2.1: EKS Deployment Scaling via Console
**AWS Console Navigation Path**:
1. **EKS Console** → **Clusters** → Select APIC cluster → **Workloads** tab
2. **Deployments** → Filter by namespace `apic`
3. Select `apic-gateway` deployment

**Scaling Operations**:
1. **Actions** → **Edit** → **Desired replicas**
2. Set **Replica count** to `0`
3. **Update deployment**
4. **Pods** tab → Confirm all pods terminating/terminated

**CloudWatch Validation Path**:
1. **CloudWatch Console** → **Container Insights** → **EKS Clusters**
2. Select cluster → **Services** tab → Filter `apic-gateway`
3. **Service Map** → Verify service shows "Unavailable" status
4. **Alarms** → Check for triggered availability alarms

### Test Method 2.2: Application Load Balancer Target Group Manipulation
**AWS Console Navigation Path**:
1. **EC2 Console** → **Load Balancers** → **Application Load Balancers**
2. Select ALB for APIC services → **Listeners** tab
3. **View/edit rules** for APIC target groups

**Target Group Deregistration**:
1. **Target Groups** → Select `apic-management-tg`
2. **Targets** tab → **Registered targets**
3. Select all healthy targets → **Actions** → **Deregister targets**
4. **Health checks** → Modify **Health check path** to `/nonexistent`
5. **Save changes**

**Expected AWS Behavior**:
- **ALB Target Group**: All targets → "Unhealthy" status
- **CloudWatch Metrics**: `TargetResponseTime` → No data points
- **Route 53 Health Checks**: Associated health checks fail

---

## Test 3: Error Events

### Test Method 3.1: CloudWatch Synthetics Canary Error Configuration
**AWS Console Navigation Path**:
1. **CloudWatch Console** → **Synthetics** → **Canaries**
2. Select existing APIC endpoint canaries or **Create canary**
3. **Configuration** → **Script editor**

**Error Injection Script Modification**:
```javascript
// Modify canary script to expect errors
const synthetics = require('Synthetics');
const log = require('SyntheticsLogger');

const checkAPICEndpoint = async function () {
    // Temporarily point to error-generating endpoint
    let requestOptionsStep1 = {
        hostname: 'httpbin.org',
        method: 'GET',
        path: '/status/500',  // Always returns 500 error
        port: '443',
        protocol: 'https:',
    };
    
    let stepConfig1 = {
        includeRequestHeaders: true,
        includeResponseHeaders: true,
        restrictedHeaders: [],
        includeRequestBody: true,
        includeResponseBody: true
    };
    
    await synthetics.executeHttpStep('checkStep1', requestOptionsStep1, null, stepConfig1);
};

exports.handler = async () => {
    return await synthetics.executeStep('checkAPICEndpoint', checkAPICEndpoint);
};
```

**Canary Configuration Update**:
1. **Schedule** → Set to run every 1 minute
2. **Failure retention** → 30 days
3. **Success retention** → 2 days
4. **Update canary**

### Test Method 3.2: Systems Manager Parameter Store Error Configuration
**AWS Console Navigation Path**:
1. **Systems Manager Console** → **Parameter Store**
2. **Create parameter** or modify existing APIC configuration parameters

**Error-Inducing Parameter Modifications**:
1. **Parameter name**: `/apic/database/connection-string`
2. **Value**: Modify to invalid database endpoint
   ```
   # Original: postgresql://user:pass@postgres.apic.svc:5432/apicdb
   # Modified: postgresql://user:wrongpass@invalid-host:5432/apicdb
   ```
3. **Parameter name**: `/apic/gateway/upstream-timeout`
4. **Value**: Set to `1` (1ms timeout to force errors)
5. **Create/Update parameters**

**Application Configuration Restart**:
1. **EKS Console** → **Workloads** → **Deployments**
2. Select APIC deployments → **Actions** → **Restart rollout**
3. Monitor pod restart and error propagation

**Expected AWS Behavior**:
- **CloudWatch Logs**: Increased error log entries
- **X-Ray Service Map**: Error traces and elevated error percentages
- **CloudWatch Metrics**: Custom error rate metrics exceed thresholds

---

## Test 4: Resource Events

### Test Method 4.1: EKS Node CPU Stress via Systems Manager
**AWS Console Navigation Path**:
1. **Systems Manager Console** → **Run Command**
2. **AWS-RunShellScript** document selection
3. **Targets** → **Choose instances manually** → Select EKS worker nodes

**CPU Stress Command Configuration**:
```bash
# Install stress-ng if not present
sudo yum install -y stress-ng || sudo apt-get install -y stress-ng

# Generate 95% CPU load for 10 minutes
nohup stress-ng --cpu $(nproc) --cpu-load 95 --timeout 600s > /tmp/cpu-stress.log 2>&1 &

# Monitor CPU utilization
top -b -n 1 | head -10
```

**CloudWatch Monitoring Validation**:
1. **CloudWatch Console** → **Metrics** → **EC2** → **Per-Instance Metrics**
2. Select **CPUUtilization** metric for target instances
3. Set **Period** to 1-minute → **Statistic** to Average
4. **Container Insights** → **EKS Clusters** → **Nodes** → CPU utilization graphs

### Test Method 4.2: EKS Memory Pressure via Systems Manager
**AWS Console Navigation Path**:
1. **Systems Manager Console** → **Run Command**
2. **Command document** → **AWS-RunShellScript**
3. **Instance selection** → Target EKS nodes running APIC analytics pods

**Memory Stress Execution**:
```bash
# Calculate 90% of available memory
AVAILABLE_MEM=$(free -m | awk 'NR==2{printf "%.0f", $7*0.90}')

# Generate memory pressure with page faults
nohup stress-ng --vm 4 --vm-bytes ${AVAILABLE_MEM}M --vm-method flip --timeout 600s > /tmp/mem-stress.log 2>&1 &

# Monitor memory utilization
free -m && cat /proc/vmstat | grep pgfault
```

**CloudWatch Container Insights Validation**:
1. **Container Insights** → **Performance monitoring** → **EKS Clusters**
2. Select cluster → **Nodes** tab → **Memory utilization** widget
3. **Pods** tab → Filter by `apic-analytics` → Memory metrics
4. **Metrics** → **Container Insights** → **MemoryUtilization** by pod

### Test Method 4.3: EBS Volume Space Saturation
**AWS Console Navigation Path**:
1. **EC2 Console** → **Volumes** → Identify EBS volumes attached to EKS nodes
2. **Systems Manager Console** → **Session Manager** → Start session on target node

**Disk Saturation Procedure**:
```bash
# Identify mount points for APIC persistent volumes
df -h | grep -E '/var/lib/kubelet/pods'

# Fill disk to 95% capacity on PostgreSQL volume
MOUNT_POINT="/var/lib/kubelet/pods/[postgres-pod-id]/volumes"
AVAILABLE_GB=$(df -BG $MOUNT_POINT | tail -1 | awk '{printf "%.0f", $4*0.95}' | sed 's/G//')

# Create large file to consume space
nohup dd if=/dev/zero of=$MOUNT_POINT/test-fill.dat bs=1G count=$AVAILABLE_GB > /tmp/disk-fill.log 2>&1 &

# Monitor disk usage
watch -n 10 'df -h'
```

**CloudWatch Storage Monitoring**:
1. **CloudWatch Console** → **Metrics** → **EBS** → **Per-Volume Metrics**
2. Select **VolumeQueueLength** and **VolumeTotalReadTime** metrics
3. **Container Insights** → **Storage** → **Persistent Volume** utilization
4. **Alarms** → Check for EBS volume utilization alarms

**Expected AWS Behavior**:
- **EKS Console**: Pod events show disk pressure warnings
- **CloudWatch Container Insights**: Storage metrics exceed 90% threshold
- **EBS Metrics**: Increased queue length and I/O wait times

---

## Test 5: Slowdown Events

### Test Method 5.1: Network Latency via VPC Network ACLs
**AWS Console Navigation Path**:
1. **VPC Console** → **Network ACLs**
2. Select Network ACL associated with EKS subnets
3. **Inbound Rules** and **Outbound Rules** tabs

**Network ACL Modification for Latency Simulation**:
1. **Edit inbound rules** → **Add rule**
2. **Rule number**: 90 (higher than existing allow rules)
3. **Type**: All Traffic → **Protocol**: All → **Port range**: All
4. **Source**: Subnet CIDR → **Allow/Deny**: Allow
5. **Edit outbound rules** → Mirror inbound configuration
6. This creates processing overhead, indirectly increasing latency

**Alternative: Transit Gateway Route Table Modification**:
1. **VPC Console** → **Transit Gateways** → **Transit Gateway Route Tables**
2. **Routes** tab → **Create route** to indirect path
3. Add circuitous routing through additional availability zones

### Test Method 5.2: RDS Performance Degradation
**AWS Console Navigation Path** (if using RDS for PostgreSQL):
1. **RDS Console** → **Databases** → Select APIC PostgreSQL instance
2. **Configuration** tab → **DB parameter group**
3. **Parameter groups** → **Create parameter group** or **Edit existing**

**Performance-Impacting Parameter Changes**:
1. **shared_buffers** → Reduce from default to `128MB`
2. **effective_cache_size** → Reduce to `256MB` 
3. **work_mem** → Reduce to `1MB`
4. **max_connections** → Reduce to `10`
5. **checkpoint_completion_target** → Set to `0.1`
6. **Apply immediately** → **Yes**

**RDS Monitoring Validation**:
1. **CloudWatch Console** → **RDS** → **Per-DB Instance Metrics**
2. Monitor **DatabaseConnections**, **ReadLatency**, **WriteLatency**
3. **Performance Insights** → **Database load** and **Top SQL**
4. **RDS Events** → Check for parameter group modification events

### Test Method 5.3: Application Load Balancer Target Response Simulation
**AWS Console Navigation Path**:
1. **EC2 Console** → **Load Balancers** → Select APIC ALB
2. **Listeners** → **View/edit rules** → **Edit rules**

**Response Delay Rule Configuration**:
1. **Insert Rule** → **Add condition**
2. **Condition type** → **Path** → **Path is** → `/api/*`
3. **Add action** → **Fixed response**
4. **Response code** → `200`
5. **Response body** → Large JSON payload (10MB+)
6. **Content type** → `application/json`
7. **Save** rule with highest priority

**CloudWatch ALB Metrics Monitoring**:
1. **CloudWatch Console** → **Metrics** → **ApplicationELB**
2. **Per Application Load Balancer Metrics** → **TargetResponseTime**
3. **Per Target Group Metrics** → **TargetResponseTime** by target group
4. Set **Period** to 1-minute intervals for granular monitoring

### Test Method 5.4: Auto Scaling Group Capacity Reduction
**AWS Console Navigation Path**:
1. **EC2 Console** → **Auto Scaling Groups**
2. Select EKS node group Auto Scaling Group
3. **Details** tab → **Group details** → **Edit**

**Capacity Constraint Configuration**:
1. **Desired capacity** → Reduce from current to 50% (e.g., 6 → 3)
2. **Maximum capacity** → Set equal to new desired capacity
3. **Update** Auto Scaling Group
4. Monitor instance termination in **Activity** tab

**Expected AWS Behavior**:
- **EKS Console**: Node pressure and pod scheduling delays
- **CloudWatch Container Insights**: Increased resource contention metrics
- **Application Load Balancer**: Higher target response times due to resource constraints

---

## Comprehensive AWS Console Validation Framework

### CloudWatch Dashboard Configuration
**Dashboard Creation Path**:
1. **CloudWatch Console** → **Dashboards** → **Create dashboard**
2. **Dashboard name** → `APIC-Davis-AI-Validation`
3. **Add widget** → Configure the following widgets:

**Widget Configurations**:
1. **EKS Cluster Metrics**:
   - Metric: `AWS/EKS` namespace
   - Dimensions: `cluster-name`
   - Metrics: `cluster_failed_request_count`, `cluster_request_total`

2. **Container Insights Metrics**:
   - Metric: `AWS/ContainerInsights` namespace  
   - Dimensions: `ClusterName`, `Namespace`, `ServiceName`
   - Metrics: `pod_cpu_utilization`, `pod_memory_utilization`

3. **Application Load Balancer Metrics**:
   - Metric: `AWS/ApplicationELB` namespace
   - Dimensions: `LoadBalancer`, `TargetGroup`
   - Metrics: `TargetResponseTime`, `HTTPCode_Target_5XX_Count`

### X-Ray Service Map Validation
**X-Ray Console Navigation**:
1. **X-Ray Console** → **Service map**
2. **Time range** → **Last 5 minutes** (during active testing)
3. **Service map view** → Identify APIC service nodes
4. **Response time analysis** → Click individual service nodes
5. **Traces** → **View traces** → Filter by error status or high latency

### Systems Manager Compliance Validation
**Compliance Dashboard Path**:
1. **Systems Manager Console** → **Compliance**
2. **Compliance summary** → Filter by **Resource type** → `AWS::EC2::Instance`
3. **Compliance details** → Verify EKS node compliance status
4. **Association compliance** → Check for monitoring agent associations

### EventBridge Rule Validation
**EventBridge Console Configuration**:
1. **EventBridge Console** → **Rules** → **Create rule**
2. **Event pattern** → **Custom patterns**
3. **Event pattern JSON**:
```json
{
  "source": ["aws.ecs", "aws.eks"],
  "detail-type": ["ECS Container Instance State Change", "EKS Pod State Change"],
  "detail": {
    "lastStatus": ["STOPPED", "FAILED"]
  }
}
```
4. **Targets** → **CloudWatch Logs** → Create log group for event tracking

This comprehensive AWS console methodology provides equivalent validation capabilities to kubectl-based testing while leveraging native AWS monitoring and management interfaces for Davis AI event validation across all five event categories.