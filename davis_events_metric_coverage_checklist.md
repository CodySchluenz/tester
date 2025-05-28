# APIC Davis Events & Metric Coverage Validation Checklist

## Quick Reference: Davis Problem Categories for APIC

| Davis Event Type | APIC Components | Expected Alert Routing | Validation Method |
|------------------|-----------------|----------------------|-------------------|
| Slowdown | Gateway Services, Management API, Portal UI | API Team → Platform Team escalation | Generate load, verify detection |
| Error Rate Increase | Gateway, Analytics Ingestion, Portal | API Team (Gateway), Data Team (Analytics) | Inject errors, check routing |
| Resource Saturation | All Kubernetes workloads | Platform Team | Stress test resources |
| Service Unavailable | All APIC services | Immediate → On-call engineer | Scale down services |
| Database Performance | PostgreSQL instances | DBA Team → Platform Team | Database load testing |

---

## Davis Event Validation Matrix

### Slowdown Events

| Component | Resource to Monitor | Current Coverage | Alert Routing | Test Method | Status | Notes |
|-----------|-------------------|------------------|---------------|-------------|---------|-------|
| **Management API** | `management-server` service | ☐ Yes ☐ No | Team: _______ | Load test mgmt endpoints | ☐ Pass ☐ Fail | Response time threshold: ___ms |
| **Gateway DataPower** | `datapower-gateway` process group | ☐ Yes ☐ No | Team: _______ | API traffic spike | ☐ Pass ☐ Fail | P95 latency threshold: ___ms |
| **Portal UI** | `portal-www` service | ☐ Yes ☐ No | Team: _______ | Portal user journey test | ☐ Pass ☐ Fail | Page load threshold: ___ms |
| **Analytics Processing** | `analytics-ingestion` service | ☐ Yes ☐ No | Team: _______ | Analytics queue backup | ☐ Pass ☐ Fail | Processing delay threshold: ___s |
| **Database Queries** | PostgreSQL process groups | ☐ Yes ☐ No | Team: _______ | Database query load | ☐ Pass ☐ Fail | Query time threshold: ___ms |

### Error Rate Increase Events

| Component | Resource to Monitor | Current Coverage | Alert Routing | Test Method | Status | Notes |
|-----------|-------------------|------------------|---------------|-------------|---------|-------|
| **Gateway API Calls** | Gateway service error rate | ☐ Yes ☐ No | Team: _______ | Return 500 errors | ☐ Pass ☐ Fail | Error rate threshold: ___%  |
| **Management Operations** | Management API error rate | ☐ Yes ☐ No | Team: _______ | Invalid API operations | ☐ Pass ☐ Fail | Error rate threshold: ___% |
| **Portal User Actions** | Portal service error rate | ☐ Yes ☐ No | Team: _______ | Portal login failures | ☐ Pass ☐ Fail | Error rate threshold: ___% |
| **Analytics Ingestion** | Analytics error rate | ☐ Yes ☐ No | Team: _______ | Malformed data injection | ☐ Pass ☐ Fail | Error rate threshold: ___% |
| **Database Connections** | PostgreSQL connection errors | ☐ Yes ☐ No | Team: _______ | Connection pool exhaustion | ☐ Pass ☐ Fail | Connection error threshold: ___% |

### Resource Saturation Events

| Resource Type | APIC Components Affected | Current Coverage | Alert Routing | Test Method | Status | Notes |
|---------------|-------------------------|------------------|---------------|-------------|---------|-------|
| **CPU Saturation** | All APIC pods | ☐ Yes ☐ No | Team: _______ | CPU stress test | ☐ Pass ☐ Fail | CPU threshold: ___%  |
| **Memory Saturation** | All APIC pods | ☐ Yes ☐ No | Team: _______ | Memory pressure test | ☐ Pass ☐ Fail | Memory threshold: ___% |
| **Disk Space** | PostgreSQL StatefulSets | ☐ Yes ☐ No | Team: _______ | Disk fill simulation | ☐ Pass ☐ Fail | Disk threshold: ___% (IBM rec: 85%) |
| **Network Saturation** | Gateway pods | ☐ Yes ☐ No | Team: _______ | High traffic volume | ☐ Pass ☐ Fail | Network utilization threshold: ___% |

### Service Unavailability Events

| Service | Custom Resource | Current Coverage | Alert Routing | Test Method | Status | Notes |
|---------|----------------|------------------|---------------|-------------|---------|-------|
| **Management Cluster** | ManagementCluster CR | ☐ Yes ☐ No | Team: _______ | Scale management to 0 | ☐ Pass ☐ Fail | CR condition monitoring |
| **Gateway Cluster** | GatewayCluster CR | ☐ Yes ☐ No | Team: _______ | Scale gateway to 0 | ☐ Pass ☐ Fail | CR condition monitoring |
| **Analytics Cluster** | AnalyticsCluster CR | ☐ Yes ☐ No | Team: _______ | Scale analytics to 0 | ☐ Pass ☐ Fail | CR condition monitoring |
| **Portal Cluster** | PortalCluster CR | ☐ Yes ☐ No | Team: _______ | Scale portal to 0 | ☐ Pass ☐ Fail | CR condition monitoring |
| **PostgreSQL** | PostgreSQL StatefulSet | ☐ Yes ☐ No | Team: _______ | Database pod failure | ☐ Pass ☐ Fail | Database availability monitoring |

---

## Davis AI Configuration Validation

### Problem Detection Settings

| Setting | Current Value | Recommended Value | Status | Action Required |
|---------|---------------|-------------------|---------|----------------|
| **Automatic problem detection** | ☐ Enabled ☐ Disabled | Enabled | ☐ OK ☐ Fix | ________________ |
| **Service availability** | Detection: ☐ Auto ☐ Manual | Auto | ☐ OK ☐ Fix | ________________ |
| **Response time degradation** | Sensitivity: _______ | Medium-High | ☐ OK ☐ Fix | ________________ |
| **Error rate increase** | Sensitivity: _______ | Medium | ☐ OK ☐ Fix | ________________ |
| **Resource saturation** | Detection: ☐ Enabled ☐ Disabled | Enabled | ☐ OK ☐ Fix | ________________ |

### APIC-Specific Metric Coverage

| Metric Category | Specific Metrics | Coverage Status | Alert Threshold | Team Assignment |
|----------------|------------------|-----------------|-----------------|----------------|
| **API Gateway Performance** | Response time, Throughput, Error rate | ☐ Complete ☐ Partial ☐ Missing | RT: ___ms, Errors: ___% | __________ |
| **Management API Health** | Response time, Success rate, Operation count | ☐ Complete ☐ Partial ☐ Missing | RT: ___ms, Success: ___% | __________ |
| **Database Performance** | Query time, Connection count, Disk usage | ☐ Complete ☐ Partial ☐ Missing | Query: ___ms, Disk: ___% | __________ |
| **Portal User Experience** | Page load time, User actions, JavaScript errors | ☐ Complete ☐ Partial ☐ Missing | Load: ___ms, JS errors: ___ | __________ |
| **Analytics Processing** | Ingestion rate, Processing latency, Queue depth | ☐ Complete ☐ Partial ☐ Missing | Latency: ___s, Queue: ___ | __________ |
| **Kubernetes Resources** | Pod restarts, Resource utilization, Network I/O | ☐ Complete ☐ Partial ☐ Missing | CPU: ___%, Memory: ___% | __________ |

---

## Alert Routing Validation

### Team Assignment Matrix

| Problem Type | Primary Team | Secondary Team | Escalation Path | Test Status |
|--------------|--------------|----------------|-----------------|-------------|
| **Gateway slowdown/errors** | API Team | Platform Team | On-call → Manager | ☐ Tested ☐ Failed |
| **Management issues** | Platform Team | API Team | On-call → Manager | ☐ Tested ☐ Failed |
| **Database problems** | DBA Team | Platform Team | DBA → Platform → Manager | ☐ Tested ☐ Failed |
| **Portal issues** | DevEx Team | Platform Team | DevEx → Platform → Manager | ☐ Tested ☐ Failed |
| **Infrastructure saturation** | Platform Team | SRE Team | Platform → SRE → Manager | ☐ Tested ☐ Failed |
| **Analytics processing** | Data Team | Platform Team | Data → Platform → Manager | ☐ Tested ☐ Failed |

### Notification Channel Validation

| Channel Type | Teams Using | Test Method | Status | Issues Found |
|--------------|-------------|-------------|---------|--------------|
| **Email** | All teams | Send test problem | ☐ Pass ☐ Fail | _____________ |
| **Slack/Teams** | Dev teams | Webhook test | ☐ Pass ☐ Fail | _____________ |
| **PagerDuty** | On-call teams | Alert test | ☐ Pass ☐ Fail | _____________ |
| **ServiceNow** | Platform team | Ticket creation test | ☐ Pass ☐ Fail | _____________ |

---

## Quick Davis Problem Simulation Tests

### 15-Minute Validation Tests

| Test Name | Steps | Expected Davis Behavior | Pass/Fail | Notes |
|-----------|-------|-------------------------|-----------|-------|
| **Gateway Slowdown** | 1. Generate 2x normal traffic<br>2. Monitor response times<br>3. Wait for Davis detection | Davis should detect slowdown within 3-5 minutes and create problem | ☐ Pass ☐ Fail | Detection time: ___min |
| **Management API Errors** | 1. Make invalid API calls<br>2. Increase error rate to 5%<br>3. Monitor Davis problems | Davis should detect error rate increase and correlate to management service | ☐ Pass ☐ Fail | Detection time: ___min |
| **Database Saturation** | 1. Run heavy database queries<br>2. Monitor CPU/memory usage<br>3. Check Davis correlation | Davis should detect resource saturation and link to affected APIC services | ☐ Pass ☐ Fail | Correlation accuracy: ___% |
| **Portal Unavailability** | 1. Scale portal deployment to 0<br>2. Monitor synthetic monitors<br>3. Check problem creation | Davis should create availability problem and show impact on user experience | ☐ Pass ☐ Fail | Impact analysis: ☐ Good ☐ Poor |

---

## Critical Gap Checklist

### High-Risk Gaps to Verify

☐ **Custom Resource health monitoring** - Davis problems when CRs show "Reconciling" or "Failed"  
☐ **Cross-service impact detection** - Database issues correctly identified as root cause for app slowdowns  
☐ **Cascade failure prevention** - Analytics failures don't trigger false gateway alerts  
☐ **Certificate expiration detection** - Proactive alerts before cert expiry affects services  
☐ **Network partition detection** - Inter-service communication failures properly detected  
☐ **Silent failure detection** - Services that fail without immediate user impact (analytics, backups)  

### Validation Summary

**Total Tests Planned**: ______  
**Tests Passed**: ______  
**Critical Issues Found**: ______  
**Alert Routing Issues**: ______  
**Metric Coverage Gaps**: ______  

**Overall Davis AI Effectiveness**: ☐ Excellent ☐ Good ☐ Needs Improvement ☐ Poor

**Next Review Date**: ________________  
**Responsible Team**: ________________