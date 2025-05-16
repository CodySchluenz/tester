# API Connect Gateway Runbook

This runbook provides detailed troubleshooting steps and operational procedures for the IBM API Connect Gateway component (DataPower Gateway) deployed on AWS EKS.

# Gateway Pod Startup Failure Runbook

## Overview
**Description:** Gateway pods fail to start up properly  
**Severity:** P1  
**Components Affected:** Gateway pods, EKS  
**Owner:** SRE Team

## Symptoms
- Pods stuck in `Pending` or `ContainerCreating` state
- Gateway endpoints return 503 errors
- User reports API unavailability

## Impact
- **User Impact:** API calls fail, client applications non-functional
- **Business Impact:** Direct revenue impact, customer dissatisfaction
- **Scope:** Widespread, all API consumers affected

## Diagnosis

### Check 1: Pod Status
```
# Check pod status
kubectl get pods -n api-connect -l app=gateway

# Expected output
NAME                   READY   STATUS    RESTARTS   AGE
gateway-0              0/1     Pending   0          5m
```

### Check 2: Pod Events
```
# Check pod events
kubectl describe pod -n api-connect gateway-0

# What to look for
- FailedScheduling events
- Image pull errors
- Volume mount issues
```

### Check 3: Node Resources
```
# Check node resource availability
kubectl describe nodes | grep -A 5 "Allocated resources"
kubectl top nodes
```

## Resolution

### Solution 1: Insufficient Resources
1. Identify resource constraints
   ```
   kubectl top nodes
   ```
2. Scale up node group if needed
   ```
   aws eks update-nodegroup-config --cluster-name api-connect-cluster --nodegroup-name gateway-nodes --scaling-config desiredSize=5,minSize=3,maxSize=10 --region us-east-1
   ```
3. Verify pod scheduling
   ```
   kubectl get pods -n api-connect -l app=gateway -w
   ```

### Solution 2: Image Pull Issues
1. Verify registry credentials
   ```
   kubectl get secret -n api-connect registry-credentials
   ```
2. Update image pull secret if needed
   ```
   kubectl create secret docker-registry registry-credentials \
     --docker-server=your-registry.example.com \
     --docker-username=your-username \
     --docker-password=your-password \
     -n api-connect \
     --dry-run=client -o yaml | kubectl apply -f -
   ```
3. Delete pod to trigger recreation
   ```
   kubectl delete pod -n api-connect gateway-0
   ```

## Verification
```
# Verify gateway pods are running
kubectl get pods -n api-connect -l app=gateway

# Expected output
NAME                   READY   STATUS    RESTARTS   AGE
gateway-0              1/1     Running   0          2m
gateway-1              1/1     Running   0          5m
gateway-2              1/1     Running   0          7m
```

## Prevention
- Implement HPA for gateway pods
- Configure resource quotas appropriately
- Set up alerts for node resource usage >70%

## Related Documentation
- [Gateway Architecture](Architecture.md#gateway-architecture)
- [Kubernetes Resource Management](Infrastructure-Runbook.md#resource-management)

---

# [Issue Name] Runbook

## Overview
**Description:** [Brief description of the issue]  
**Severity:** [P1/P2/P3/P4]  
**Components Affected:** [List affected components]  
**Owner:** [Team responsible]

## Symptoms
- [Symptom 1]
- [Symptom 2]
- [Symptom 3]

## Impact
- **User Impact:** [Description of user experience]
- **Business Impact:** [Description of business impact]
- **Scope:** [Limited/Widespread]

## Diagnosis

### Prerequisites
- [Required access/permissions]
- [Required tools]

### Check 1: [Brief description]
```
# Command to check status
[command]

# Expected output
[output]
```

### Check 2: [Brief description]
```
# Command to check logs
[command]

# What to look for
[pattern or error message]
```

### Check 3: [Brief description]
```
# Command to check configuration
[command]
```

## Resolution

### Solution 1: [Brief description]
1. [Step 1]
   ```
   [command if applicable]
   ```
2. [Step 2]
   ```
   [command if applicable]
   ```
3. [Step 3]

### Solution 2: [Brief description]
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Verification
```
# Commands to verify resolution
[command]

# Expected output
[output]
```

## Prevention
- [Preventive measure 1]
- [Preventive measure 2]

## Related Documentation
- [Link to relevant documentation]
- [Link to related runbooks]
