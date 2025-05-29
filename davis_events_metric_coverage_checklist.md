# APIC Davis Events & Metric Coverage Validation Checklist

## Environment & Cluster Information

### Cluster Details
| Field | Value |
|-------|-------|
| **Environment** | ☐ Production ☐ Staging ☐ Development ☐ UAT |
| **Cluster Name** | _________________________ |
| **EKS Version** | _________________________ |
| **Region** | _________________________ |
| **Availability Zones** | _________________________ |
| **Node Groups** | _________________________ |
| **Total Nodes** | _________________________ |
| **Total Pods (APIC)** | _________________________ |

### APIC Deployment Information
| Component | Namespace | Deployment Name | Pod Count | Node Distribution |
|-----------|-----------|----------------|-----------|------------------|
| **Management** | _________________ | _________________ | ____/____ | _________________ |
| **Gateway** | _________________ | _________________ | ____/____ | _________________ |
| **Analytics** | _________________ | _________________ | ____/____ | _________________ |
| **Portal** | _________________ | _________________ | ____/____ | _________________ |
| **PostgreSQL** | _________________ | _________________ | ____/____ | _________________ |

### Key Endpoints and URLs
| Service | Internal Endpoint | External Endpoint | Health Check URL |
|---------|------------------|-------------------|------------------|
| **Management** | _________________________ | _________________________ | _________________________ |
| **Gateway** | _________________________ | _________________________ | _________________________ |
| **Analytics** | _________________________ | _________________________ | _________________________ |
| **Portal** | _________________________ | _________________________ | _________________________ |

---

## Executive Summary for Business Teams

### Monitoring Coverage Overview
**Assessment Date**: _________________  
**Assessed By**: _________________  
**Environment**: _________________  

### Business-Critical Metrics
| Service Level Objective | Current Coverage | Target Achievement | Status |
|------------------------|------------------|-------------------|---------|
| **API Availability** | ____% monitored | 99.9% uptime | ☐ Met ☐ Risk ☐ Gap |
| **API Response Time** | ____% monitored | <500ms p95 | ☐ Met ☐ Risk ☐ Gap |
| **Developer Portal Uptime** | ____% monitored | 99.5% uptime | ☐ Met ☐ Risk ☐ Gap |
| **Time to Detect Issues** | _______ minutes | <3 minutes | ☐ Met ☐ Risk ☐ Gap |
| **Time to Alert Teams** | _______ minutes | <5 minutes | ☐ Met ☐ Risk ☐ Gap |

### Integration Health
| System | Integration Status | Data Flow Time | Business Impact |
|--------|-------------------|----------------|-----------------|
| **Splunk** | ☐ Healthy ☐ Issues | _______ minutes | Log analysis and compliance |
| **ServiceNow** | ☐ Healthy ☐ Issues | _______ minutes | Incident management |
| **PagerDuty** | ☐ Healthy ☐ Issues | _______ seconds | Critical alerting |
| **Email/Slack** | ☐ Healthy ☐ Issues | _______ seconds | Team notifications |

### Risk Assessment Summary
**High Risk Items Found**: _______  
**Medium Risk Items Found**: _______  
**Remediation Timeline**: _______  
**Business Impact**: ☐ Low ☐ Medium ☐ High  

---

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

| Component | Resource to Monitor | Current Coverage | Alert Routing | Test Method | Status | Time to Splunk | Time to ServiceNow | Notes |
|-----------|-------------------|------------------|---------------|-------------|---------|----------------|-------------------|-------|
| **Management API** | `management-server` service | ☐ Yes ☐ No | Team: _______ | Load test mgmt endpoints | ☐ Pass ☐ Fail | _____ min | _____ min | Response time threshold: ___ms |
| **Gateway DataPower** | `datapower-gateway` process group | ☐ Yes ☐ No | Team: _______ | API traffic spike | ☐ Pass ☐ Fail | _____ min | _____ min | P95 latency threshold: ___ms |
| **Portal UI** | `portal-www` service | ☐ Yes ☐ No | Team: _______ | Portal user journey test | ☐ Pass ☐ Fail | _____ min | _____ min | Page load threshold: ___ms |
| **Analytics Processing** | `analytics-ingestion` service | ☐ Yes ☐ No | Team: _______ | Analytics queue backup | ☐ Pass ☐ Fail | _____ min | _____ min | Processing delay threshold: ___s |
| **Database Queries** | PostgreSQL process groups | ☐ Yes ☐ No | Team: _______ | Database query load | ☐ Pass ☐ Fail | _____ min | _____ min | Query time threshold: ___ms |

### Error Rate Increase Events

| Component | Resource to Monitor | Current Coverage | Alert Routing | Test Method | Status | Time to Splunk | Time to ServiceNow | Notes |
|-----------|-------------------|------------------|---------------|-------------|---------|----------------|-------------------|-------|
| **Gateway API Calls** | Gateway service error rate | ☐ Yes ☐ No | Team: _______ | Return 500 errors | ☐ Pass ☐ Fail | _____ min | _____ min | Error rate threshold: ___%  |
| **Management Operations** | Management API error rate | ☐ Yes ☐ No | Team: _______ | Invalid API operations | ☐ Pass ☐ Fail | _____ min | _____ min | Error rate threshold: ___% |
| **Portal User Actions** | Portal service error rate | ☐ Yes ☐ No | Team: _______ | Portal login failures | ☐ Pass ☐ Fail | _____ min | _____ min | Error rate threshold: ___% |
| **Analytics Ingestion** | Analytics error rate | ☐ Yes ☐ No | Team: _______ | Malformed data injection | ☐ Pass ☐ Fail | _____ min | _____ min | Error rate threshold: ___% |
| **Database Connections** | PostgreSQL connection errors | ☐ Yes ☐ No | Team: _______ | Connection pool exhaustion | ☐ Pass ☐ Fail | _____ min | _____ min | Connection error threshold: ___% |

### Resource Saturation Events

| Resource Type | APIC Components Affected | Current Coverage | Alert Routing | Test Method | Status | Time to Splunk | Time to ServiceNow | Notes |
|---------------|-------------------------|------------------|---------------|-------------|---------|----------------|-------------------|-------|
| **CPU Saturation** | All APIC pods | ☐ Yes ☐ No | Team: _______ | CPU stress test | ☐ Pass ☐ Fail | _____ min | _____ min | CPU threshold: ___%  |
| **Memory Saturation** | All APIC pods | ☐ Yes ☐ No | Team: _______ | Memory pressure test | ☐ Pass ☐ Fail | _____ min | _____ min | Memory threshold: ___% |
| **Disk Space** | PostgreSQL StatefulSets | ☐ Yes ☐ No | Team: _______ | Disk fill simulation | ☐ Pass ☐ Fail | _____ min | _____ min | Disk threshold: ___% (IBM rec: 85%) |
| **Network Saturation** | Gateway pods | ☐ Yes ☐ No | Team: _______ | High traffic volume | ☐ Pass ☐ Fail | _____ min | _____ min | Network utilization threshold: ___% |

### Service Unavailability Events

| Service | Custom Resource | Current Coverage | Alert Routing | Test Method | Status | Time to Splunk | Time to ServiceNow | Notes |
|---------|----------------|------------------|---------------|-------------|---------|----------------|-------------------|-------|
| **Management Cluster** | ManagementCluster CR | ☐ Yes ☐ No | Team: _______ | Scale management to 0 | ☐ Pass ☐ Fail | _____ min | _____ min | CR condition monitoring |
| **Gateway Cluster** | GatewayCluster CR | ☐ Yes ☐ No | Team: _______ | Scale gateway to 0 | ☐ Pass ☐ Fail | _____ min | _____ min | CR condition monitoring |
| **Analytics Cluster** | AnalyticsCluster CR | ☐ Yes ☐ No | Team: _______ | Scale analytics to 0 | ☐ Pass ☐ Fail | _____ min | _____ min | CR condition monitoring |
| **Portal Cluster** | PortalCluster CR | ☐ Yes ☐ No | Team: _______ | Scale portal to 0 | ☐ Pass ☐ Fail | _____ min | _____ min | CR condition monitoring |
| **PostgreSQL** | PostgreSQL StatefulSet | ☐ Yes ☐ No | Team: _______ | Database pod failure | ☐ Pass ☐ Fail | _____ min | _____ min | Database availability monitoring |

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

| Test Name | Steps | Expected Davis Behavior | Pass/Fail | Time to Splunk | Time to ServiceNow | Notes |
|-----------|-------|-------------------------|-----------|----------------|-------------------|-------|
| **Gateway Slowdown** | 1. Generate 2x normal traffic<br>2. Monitor response times<br>3. Wait for Davis detection | Davis should detect slowdown within 3-5 minutes and create problem | ☐ Pass ☐ Fail | _____ min | _____ min | Detection time: ___min |
| **Management API Errors** | 1. Make invalid API calls<br>2. Increase error rate to 5%<br>3. Monitor Davis problems | Davis should detect error rate increase and correlate to management service | ☐ Pass ☐ Fail | _____ min | _____ min | Detection time: ___min |
| **Database Saturation** | 1. Run heavy database queries<br>2. Monitor CPU/memory usage<br>3. Check Davis correlation | Davis should detect resource saturation and link to affected APIC services | ☐ Pass ☐ Fail | _____ min | _____ min | Correlation accuracy: ___% |
| **Portal Unavailability** | 1. Scale portal deployment to 0<br>2. Monitor synthetic monitors<br>3. Check problem creation | Davis should create availability problem and show impact on user experience | ☐ Pass ☐ Fail | _____ min | _____ min | Impact analysis: ☐ Good ☐ Poor |

### Integration Performance Metrics

| Integration | Target Time | Actual Average Time | Status | Issues/Notes |
|-------------|-------------|-------------------|---------|-------------|
| **Dynatrace → Splunk** | <2 minutes | _______ minutes | ☐ Met ☐ Exceeded | _________________ |
| **Dynatrace → ServiceNow** | <3 minutes | _______ minutes | ☐ Met ☐ Exceeded | _________________ |
| **Dynatrace → PagerDuty** | <30 seconds | _______ seconds | ☐ Met ☐ Exceeded | _________________ |
| **Dynatrace → Email/Slack** | <1 minute | _______ seconds | ☐ Met ☐ Exceeded | _________________ |

---

## Business Impact Analysis

### Service Level Indicators (SLIs) Validation

| SLI | Target | Current Monitoring | Gap Analysis | Action Required |
|-----|-------|-------------------|--------------|-----------------|
| **API Gateway Availability** | 99.9% | ☐ Monitored ☐ Gap | _________________ | _________________ |
| **API Response Time** | p95 < 500ms | ☐ Monitored ☐ Gap | _________________ | _________________ |
| **Portal Availability** | 99.5% | ☐ Monitored ☐ Gap | _________________ | _________________ |
| **Time to Detection** | <3 minutes | ☐ Monitored ☐ Gap | _________________ | _________________ |
| **Time to Resolution** | <30 minutes | ☐ Monitored ☐ Gap | _________________ | _________________ |

### Cost of Downtime Analysis

| Component | Business Impact/Hour | Current Detection Time | Current Resolution Time | Risk Level |
|-----------|---------------------|----------------------|------------------------|------------|
| **API Gateway** | $_______ | _______ minutes | _______ minutes | ☐ Low ☐ Med ☐ High |
| **Management** | $_______ | _______ minutes | _______ minutes | ☐ Low ☐ Med ☐ High |
| **Portal** | $_______ | _______ minutes | _______ minutes | ☐ Low ☐ Med ☐ High |
| **Analytics** | $_______ | _______ minutes | _______ minutes | ☐ Low ☐ Med ☐ High |

### Compliance and Audit Requirements

| Requirement | Current Status | Evidence Location | Next Audit Date |
|-------------|----------------|------------------|-----------------|
| **Log Retention** | ☐ Compliant ☐ Risk | Splunk: _______ days | _________________ |
| **Incident Response** | ☐ Compliant ☐ Risk | ServiceNow: _______ SLA | _________________ |
| **Monitoring Coverage** | ☐ Compliant ☐ Risk | Dynatrace: _______% | _________________ |
| **Change Management** | ☐ Compliant ☐ Risk | Process: _________________ | _________________ |

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

**Environment**: _________________  
**Assessment Date**: _________________  
**Assessment Duration**: _______ hours  
**Assessor**: _________________  
**Review Board**: _________________  

### Technical Metrics
**Total Tests Planned**: ______  
**Tests Passed**: ______  
**Critical Issues Found**: ______  
**Alert Routing Issues**: ______  
**Metric Coverage Gaps**: ______  

### Business Metrics
**Service Level Objectives Met**: ______/______  
**Average Detection Time**: _______ minutes  
**Average Alert Propagation Time**: _______ minutes  
**Integration Health Score**: _______% 
**Compliance Status**: ☐ Full ☐ Partial ☐ Non-Compliant  

### Financial Impact
**Estimated Risk Reduction**: $_______/month  
**Cost of Undetected Outages**: $_______/hour  
**Monitoring ROI**: _______%  

### Overall Assessment
**Davis AI Effectiveness**: ☐ Excellent ☐ Good ☐ Needs Improvement ☐ Poor  
**Business Risk Level**: ☐ Low ☐ Medium ☐ High ☐ Critical  
**Recommendation**: ☐ Production Ready ☐ Minor Fixes Needed ☐ Major Remediation Required  

### Action Items for Business Review

| Priority | Action Item | Responsible Team | Target Date | Business Impact |
|----------|-------------|------------------|-------------|-----------------|
| **High** | _________________ | _________________ | _______ | _________________ |
| **High** | _________________ | _________________ | _______ | _________________ |
| **Medium** | _________________ | _________________ | _______ | _________________ |
| **Medium** | _________________ | _________________ | _______ | _________________ |
| **Low** | _________________ | _________________ | _______ | _________________ |

### Sign-off

**Technical Lead**: _________________ Date: _______  
**Business Owner**: _________________ Date: _______  
**Compliance Officer**: _________________ Date: _______  

**Next Review Date**: _________________  
**Review Frequency**: ☐ Monthly ☐ Quarterly ☐ Semi-Annual ☐ Annual