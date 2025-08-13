# SRE Runbook: No Successful Transactions Alert Triage

## Overview
This runbook is for **SRE team use only** when receiving "No Successful Transactions" alerts from Splunk. This is a **CRITICAL P1** alert indicating complete platform failure. SRE must take immediate action and coordinate emergency response.

### Alert Details
- **Alert Name**: No Successful Transactions
- **Source**: Splunk Email Alert
- **Trigger Condition**: Zero HTTP 200 status codes in 15-minute period
- **Severity**: **AUTOMATIC P1** - Complete service outage
- **SLO Impact**: Complete SLO breach - 0% availability
- **Business Impact**: **CRITICAL** - Complete customer service unavailability

---

## EMERGENCY RESPONSE (0-5 minutes)

### 1. Immediate Alert Processing
- [ ] **AUTOMATIC P1 ESCALATION** - This alert bypasses normal triage
- [ ] Call app dev team lead immediately (don't use email)
- [ ] Post emergency status in `#incident-response` Slack channel:
  ```
  🚨 P1 EMERGENCY: Complete Platform Outage
  Alert: No Successful Transactions (15+ minutes)
  Status: INVESTIGATING - ALL HANDS
  IC: @your-name
  Next update: 10 minutes
  ```

### 2. Emergency Assessment (2-3 minutes max)
- [ ] **Verify alert legitimacy**: Check Splunk for any 200 responses in last 15 minutes
- [ ] **Scope determination**: Single environment or multi-environment failure
- [ ] **Infrastructure quick check**: AWS health dashboard, load balancer status
- [ ] **Traffic verification**: Are requests still coming in but all failing?

### 3. Immediate Escalation Actions
- [ ] **Declare P1 incident** and assign Incident Commander role to self
- [ ] **Call primary app dev lead** and secondary if no answer within 2 minutes
- [ ] **Notify management chain** immediately
- [ ] **Prepare for customer communications** (status page, support team alert)

---

## Emergency Phone Numbers

### IMMEDIATE CONTACT (Call, don't text/email)
| **Role** | **Primary Phone** | **Secondary Phone** | **Backup Contact** |
|----------|------------------|--------------------|--------------------|
| App Dev Team A Lead | [PHONE-NUMBER] | [BACKUP-PHONE] | @appdev-senior-a |
| App Dev Team B Lead | [PHONE-NUMBER] | [BACKUP-PHONE] | @appdev-senior-b |
| Platform Manager | [PHONE-NUMBER] | [BACKUP-PHONE] | @platform-director |
| SRE Manager | [PHONE-NUMBER] | [BACKUP-PHONE] | @senior-sre-lead |

---

## Emergency Context Gathering (5-10 minutes)

### Critical Infrastructure Checks
Run these immediately while on phone with app dev team:

#### Verify Complete Outage
```splunk
# Confirm zero successful transactions
index=apiconnect earliest=-15m status=200
| stats count
| eval outage_confirmed=if(count=0,"YES - COMPLETE OUTAGE","NO - Partial service")
```

#### Traffic Pattern Analysis
```splunk
# Are requests still coming in?
index=apiconnect earliest=-15m
| bin _time span=5m
| stats count as total_requests, count(eval(status=200)) as success_count, count(eval(status>=400)) as error_count by _time
| eval pattern=case(total_requests=0,"NO_TRAFFIC",success_count=0 AND error_count>0,"TRAFFIC_ALL_FAILING",1=1,"PARTIAL_SUCCESS")
```

#### Error Pattern for Root Cause Hints
```splunk
# What errors are we seeing instead of 200s?
index=apiconnect earliest=-15m status!=200
| stats count by status, api_endpoint
| sort -count
| head 10
```

### Infrastructure Status (Parallel to Splunk checks)
- [ ] **AWS Load Balancer**: All target groups healthy?
- [ ] **EKS Cluster**: All nodes and pods running?
- [ ] **Database**: Primary and replica connectivity
- [ ] **DNS/Networking**: Basic connectivity tests
- [ ] **Recent Changes**: Any deployments or infrastructure changes in last 2 hours

---

## Emergency Email Template

**ONLY use after verbal contact established - this supplements, doesn't replace phone calls**

```
Subject: [P1 EMERGENCY] IBM API Connect: COMPLETE PLATFORM OUTAGE

EMERGENCY - ALL HANDS REQUIRED

🚨 **CRITICAL OUTAGE**: Zero successful transactions detected for 15+ minutes

📞 **Emergency Bridge**: [CONFERENCE_BRIDGE_NUMBER]
🎯 **Incident Commander**: @your-name
⏰ **Outage Duration**: [MINUTES] minutes and counting

📊 **Outage Details**:
- Alert Time: [TIMESTAMP_FROM_SPLUNK]
- Affected Services: ALL IBM API Connect services
- Environment: [ENVIRONMENT_FROM_ALERT]
- Success Rate: 0% (normally >99.9%)
- Traffic Status: [STILL_RECEIVING/NO_TRAFFIC/ALL_ERRORS]

🔥 **Immediate Actions Required**:
1. Join emergency bridge immediately
2. Check application service health
3. Verify database connectivity
4. Review recent deployments/changes

📈 **Error Pattern**:
- Primary Error Codes: [TOP_ERROR_CODES]
- Traffic Volume: [REQUESTS_STILL_COMING_IN]
- Infrastructure: [LOAD_BALANCER/EKS/DATABASE_STATUS]

⚠️ **Customer Impact**: 
- Complete service unavailability
- All API calls failing
- Immediate SLA breach

🔗 **Emergency Guide**: https://github.com/your-org/infrastructure-wiki/wiki/App-Dev-Complete-Outage-Emergency-Response

**This is a P1 emergency. Drop all other work.**

SRE Incident Commander: @your-name
```

---

## Incident Commander Responsibilities

### During Complete Outage (First 30 minutes)
- [ ] **Maintain emergency bridge**: Keep all responders connected
- [ ] **Coordinate investigation**: Don't let teams work in isolation
- [ ] **Manage communications**: Updates every 10 minutes to stakeholders
- [ ] **Make escalation decisions**: Additional resources, vendor support
- [ ] **Customer communication**: Coordinate with support/marketing teams
- [ ] **Document timeline**: Critical for post-mortem and legal requirements

### Communication Cadence
- **0-10 min**: Initial emergency response, team assembly
- **10-20 min**: First substantial update on root cause investigation
- **20-30 min**: Progress update and resource escalation decisions
- **Every 15 min thereafter**: Regular stakeholder updates until resolution

---

## Infrastructure Emergency Actions

### SRE Emergency Powers
For complete outages, SRE has authority to:
- [ ] **Scale infrastructure immediately** without approval
- [ ] **Restart services** in emergency recovery attempts
- [ ] **Implement traffic routing** to backup regions/environments
- [ ] **Contact AWS support** for Premium Support emergency escalation
- [ ] **Execute disaster recovery procedures** if primary region failed

### Emergency Infrastructure Checks
```bash
# EKS Cluster Health
kubectl get nodes
kubectl get pods -n ibm-apiconnect --field-selector=status.phase!=Running

# Load Balancer Status
aws elbv2 describe-target-health --target-group-arn [TARGET_GROUP_ARN]

# Database Connectivity
kubectl exec -it [DB_POD] -n ibm-apiconnect -- mysql -u [USER] -p[PASS] -e "SELECT 1"

# DNS Resolution
nslookup api.your-domain.com
dig api.your-domain.com
```

### Emergency Recovery Actions
```bash
# Emergency service restart (if app team approves)
kubectl rollout restart deployment/api-gateway -n ibm-apiconnect
kubectl rollout restart deployment/api-management -n ibm-apiconnect

# Emergency scaling (double capacity immediately)
kubectl scale deployment api-gateway --replicas=10 -n ibm-apiconnect

# Emergency traffic routing (if multi-region)
# Update DNS to point to backup region
aws route53 change-resource-record-sets --hosted-zone-id [ZONE] --change-batch file://emergency-failover.json
```

---

## Vendor Emergency Escalation

### AWS Premium Support Emergency
- **Support Case**: Create "Business-critical system down" case immediately
- **Phone**: [AWS_PREMIUM_SUPPORT_NUMBER]
- **Severity**: Production system impaired/down
- **Services**: EKS, ALB, RDS, Route53

### Third-Party Vendor Emergency
| **Vendor** | **Emergency Contact** | **Service** | **When to Call** |
|------------|----------------------|-------------|------------------|
| Dynatrace | [EMERGENCY_NUMBER] | Monitoring | If monitoring completely dark |
| Splunk | [EMERGENCY_NUMBER] | Logging | If alert system compromised |
| [CDN_PROVIDER] | [EMERGENCY_NUMBER] | CDN | If CDN causing complete failure |

---

## Customer Communication Coordination

### Immediate (5-10 minutes)
- [ ] **Alert support team**: Mass customer inquiries incoming
- [ ] **Status page update**: Post "Investigating major service disruption"
- [ ] **Internal stakeholders**: Notify executive team of P1 outage

### Ongoing (Every 15-30 minutes)
- [ ] **Status page updates**: Progress on investigation and ETA
- [ ] **Support team briefings**: Talking points for customer inquiries
- [ ] **Executive updates**: Business impact and recovery timeline

### Sample Status Page Message
```
🔴 INVESTIGATING: We are currently investigating reports of service disruption affecting all API services. Our engineering team is actively working to identify the cause and restore service. We will provide updates every 15 minutes.

Next update: [TIME + 15 minutes]
```

---

## Team Contacts & Emergency Procedures

### SRE Emergency Contacts
| **Role** | **Primary** | **Phone** | **Escalation** |
|----------|-------------|-----------|----------------|
| SRE On-Call | @sre-oncall | [PHONE] | 24/7 availability |
| Senior SRE | @senior-sre-lead | [PHONE] | Any complete outage |
| SRE Manager | @sre-manager | [PHONE] | >30 min outage |
| Platform Director | @platform-director | [PHONE] | >1 hour outage |

### Emergency Bridges
- **Primary**: [CONFERENCE_BRIDGE_NUMBER]
- **Backup**: [BACKUP_BRIDGE_NUMBER]
- **Zoom**: [ZOOM_EMERGENCY_ROOM_LINK]

### Emergency Decision Authority
For complete outages exceeding 30 minutes:
- **SRE Manager**: Infrastructure changes, vendor escalation
- **Platform Director**: Resource allocation, external communications
- **Engineering Director**: Cross-team coordination, customer communications

---

## Recovery Verification

### Success Criteria for "All Clear"
- [ ] **HTTP 200 responses**: Consistent 200s for 15+ minutes
- [ ] **Error rate**: <0.1% sustained
- [ ] **Response times**: <200ms 95th percentile
- [ ] **All endpoints**: Every critical API endpoint responding
- [ ] **Sustained recovery**: 30+ minutes of normal operation

### Recovery Verification Queries
```splunk
# Confirm sustained recovery
index=apiconnect earliest=-30m
| bin _time span=5m
| stats count as total, count(eval(status=200)) as success, count(eval(status>=400)) as errors by _time
| eval success_rate=round((success/total)*100,1)
| eval recovery_status=case(success_rate>=99.9,"RECOVERED",success_rate>=95,"PARTIAL_RECOVERY",success_rate<95,"STILL_DEGRADED")
```

---

## Post-Recovery Actions

### Immediate (0-30 minutes after recovery)
- [ ] **All-clear communications**: Status page, support team, stakeholders
- [ ] **Service verification**: Run automated health checks on all endpoints
- [ ] **Performance validation**: Confirm response times and error rates normal
- [ ] **Customer communication**: Recovery announcement with brief explanation

### Follow-up (30 minutes - 2 hours)
- [ ] **Post-mortem scheduling**: Must be scheduled within 24 hours for complete outages
- [ ] **Timeline documentation**: Detailed incident timeline for analysis
- [ ] **Customer impact assessment**: Calculate downtime and affected customers
- [ ] **Stakeholder debrief**: Executive summary of cause and prevention measures

---

## Complete Outage Patterns

### Historical Root Causes (Complete Outages)
| **Root Cause** | **Frequency** | **Detection Method** | **Typical Duration** |
|----------------|---------------|---------------------|---------------------|
| Database failure | 35% | All services can't connect to DB | 15-45 minutes |
| Load balancer misconfiguration | 25% | All traffic routing fails | 5-20 minutes |
| Network/DNS failure | 20% | Services unreachable | 10-60 minutes |
| Deployment gone wrong | 15% | Bad deploy breaks all services | 10-30 minutes |
| Infrastructure cascade failure | 5% | Multiple components fail together | 30-120 minutes |

### Emergency Recovery Patterns
- **Database failure**: Failover to replica, restart primary
- **Load balancer**: Revert configuration, restart load balancer
- **Network/DNS**: Emergency DNS switching, network reconfiguration  
- **Bad deployment**: Emergency rollback to last known good version
- **Cascade failure**: Systematic service restart, infrastructure scaling

---

## Legal and Compliance

### Documentation Requirements
- [ ] **Precise timeline**: Legal may need exact outage duration
- [ ] **Customer impact**: Number of affected customers and requests
- [ ] **Root cause**: Technical explanation for compliance/audits
- [ ] **Recovery actions**: All steps taken documented with timestamps

### SLA Breach Handling
- [ ] **Calculate downtime**: Exact minutes of complete unavailability
- [ ] **Customer credits**: Coordinate with legal/finance for SLA credits
- [ ] **Compliance reporting**: Notify compliance team of major outage
- [ ] **Regulatory notifications**: Some industries require incident reporting

---

## Runbook Maintenance

### Emergency Contact Updates
- **Weekly**: Verify all emergency phone numbers are current
- **Monthly**: Test emergency bridges and communication channels
- **Quarterly**: Review and drill complete outage response procedures

### Version History
| **Version** | **Date** | **Author** | **Changes** |
|-------------|----------|------------|-------------|
| 1.0 | 2024-08-12 | @sre-lead | Initial emergency response runbook for complete outages |

---

*This runbook is for EMERGENCY P1 situations only. Complete platform outages require immediate escalation and all-hands response. Do not delay - every minute of outage has significant business impact.*