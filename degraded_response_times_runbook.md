# SRE Runbook: Degraded Response Times Alert Triage

## Overview
This runbook is for **SRE team use only** when receiving "Degraded Response Times" alerts from Splunk. The SRE role is to triage the alert, gather context, and notify the appropriate app dev teams with actionable information.

### Alert Details
- **Alert Name**: Degraded Response Times
- **Source**: Splunk Email Alert
- **SLO Impact**: API Response Time SLI (Target: 95th percentile < 200ms)
- **Business Impact**: User experience degradation, potential SLA violations

---

## SRE Triage Process (0-10 minutes)

### 1. Alert Processing
- [ ] Receive Splunk email alert
- [ ] Extract key details from alert:
  - Timestamp and duration
  - Affected services/endpoints
  - Environment scope (LAB/INT/QA/PROD)
  - Current metrics vs thresholds

### 2. Severity Assessment
Use this decision tree:
- **> 500ms response time**: Escalate to P1, call app dev lead directly
- **200-500ms response time**: Continue as P2, send email notification
- **< 200ms but trending up**: Monitor for 15 minutes, may be false positive

### 3. Context Gathering
Run these quick checks to provide context to app teams:
- [ ] Check for correlated alerts in monitoring systems
- [ ] Verify which app dev team owns the affected service
- [ ] Note any recent infrastructure changes or AWS service issues

---

## Email Template for App Dev Teams

Copy and customize this template when forwarding alerts:

```
Subject: [ALERT - P2] IBM API Connect: Degraded Response Times - [SERVICE_NAME]

Hi [APP_DEV_TEAM],

We've detected degraded response times on IBM API Connect services. Please investigate using the linked guide.

🔗 **Investigation Guide**: https://github.com/your-org/infrastructure-wiki/wiki/App-Dev-Degraded-Response-Times-Investigation

📊 **Alert Details**:
- Alert Time: [TIMESTAMP_FROM_SPLUNK]
- Affected Service: [SERVICE_NAME_FROM_ALERT]
- Environment: [ENVIRONMENT_FROM_ALERT]
- Current Response Time: [95TH_PERCENTILE_FROM_ALERT]
- Alert Threshold Exceeded: 200ms (95th percentile)
- Duration: [HOW_LONG_ALERT_ACTIVE]

⏰ **SLA Impact**: 
- Current error budget consumption: [CALCULATE_IF_AVAILABLE]
- Estimated time to SLA breach: [ESTIMATE_IF_TRENDING_CONTINUES]

🔍 **Infrastructure Context** (if relevant):
- Recent AWS service events: [CHECK_AWS_HEALTH_DASHBOARD]
- Infrastructure changes in last 4 hours: [NONE/DESCRIBE]
- Cross-environment impact: [SINGLE_ENV/MULTIPLE_ENVS]

Please acknowledge receipt and provide ETA for initial assessment within 30 minutes.

**Need SRE assistance?** Reply to this email or contact @sre-oncall in Slack.

Thanks,
SRE Team
```

---

## SRE Monitoring During Investigation

While app dev teams investigate, SRE should monitor:

### Continuous Monitoring Tasks
- [ ] **Alert Progression**: Track if metrics are improving or worsening
- [ ] **Scope Expansion**: Monitor for additional services becoming affected  
- [ ] **Cross-Environment**: Check if issue spreads to other environments
- [ ] **Customer Impact**: Watch for support tickets or complaints
- [ ] **Infrastructure Stability**: Ensure underlying AWS/K8s platform stable

### Monitoring Queries for SRE
```splunk
# Overall service health trending - run every 15 minutes
index=apiconnect earliest=-2h
| bin _time span=5m
| stats avg(response_time) as avg_resp, p95(response_time) as p95_resp by _time
| eval health_status=case(p95_resp>500,"CRITICAL",p95_resp>200,"DEGRADED",1=1,"HEALTHY")
| sort _time

# Error budget consumption calculation
index=apiconnect earliest=-30d
| stats count as total_requests, count(eval(status>=400)) as error_requests
| eval error_rate=(error_requests/total_requests)*100
| eval budget_consumed=round((error_rate/0.1)*100,2)
```

---

## Escalation Procedures

### When to Escalate to P1
- Response times > 500ms sustained for > 10 minutes
- Multiple environments affected simultaneously
- No app dev team response within 30 minutes
- Customer escalations received via support channels
- SLA breach imminent (< 30 minutes to budget exhaustion)

### P1 Escalation Process
1. **Immediate**: Call app dev lead directly (don't wait for email response)
2. **Incident Commander**: SRE becomes incident commander for P1s
3. **Communication**: Start incident bridge, update stakeholders every 15 minutes
4. **Documentation**: Switch to P1 incident tracking procedures

### Escalation Contacts
| **Escalation Level** | **Contact** | **When to Escalate** |
|---------------------|-------------|---------------------|
| App Dev Team A Lead | @appdev-lead-a | Team A services affected |
| App Dev Team B Lead | @appdev-lead-b | Team B services affected |
| Senior SRE | @senior-sre-lead | P1 declaration or no team response |
| Platform Manager | @platform-manager | Multi-environment impact |
| Product Owner | @product-owner | Confirmed customer impact |

---

## SRE Support Guidelines

### When App Dev Teams Should Contact SRE
- Infrastructure-level issues suspected (AWS, Kubernetes, networking)
- Cross-environment correlation analysis needed
- Help with Splunk query creation or data interpretation
- Vendor escalation required (AWS support, Dynatrace)

### SRE Assistance Available
1. **Infrastructure Analysis**: AWS CloudWatch, EKS cluster health, network issues
2. **Historical Context**: Pattern recognition from previous incidents  
3. **Splunk Query Support**: Custom searches for specific investigation needs
4. **Vendor Escalation**: AWS support cases, third-party service issues
5. **Cross-Team Coordination**: When multiple teams/services involved

### Infrastructure Context to Provide
When app teams request SRE assistance, check and share:
- [ ] Recent AWS service disruptions or maintenance windows
- [ ] Kubernetes cluster events from last 4 hours
- [ ] Network/load balancer configuration changes  
- [ ] Any infrastructure monitoring alerts or anomalies
- [ ] Cross-environment pattern analysis

---

## Handoff and Follow-up

### Successful Handoff Criteria
- [ ] App dev team acknowledges receipt within 30 minutes
- [ ] Team provides initial assessment ETA
- [ ] Investigation guide link confirmed working
- [ ] Any infrastructure context shared if relevant

### SRE Follow-up Tasks
- [ ] Monitor alert status for resolution
- [ ] Update incident tracking system
- [ ] Schedule post-mortem if P1 or >30 minute resolution
- [ ] Document any new patterns or lessons learned

### When to Close SRE Involvement
- App dev team confirms resolution and alert clears
- SLO metrics return to normal ranges (<200ms p95)
- No further SRE assistance requested
- Incident closed in tracking system

---

## Team Contacts & Tools

### SRE Team Contacts
| **Role** | **Primary** | **Backup** | **Hours** |
|----------|-------------|------------|-----------|
| SRE On-Call | @sre-oncall | @sre-backup | 24/7 |
| Senior SRE | @senior-sre-lead | @sre-manager | Business hours |
| SRE Manager | @sre-manager | @platform-director | Escalation only |

### App Dev Team Mapping
| **Service Pattern** | **Owning Team** | **Primary Contact** |
|-------------------|-----------------|-------------------|
| *api-gateway* | App Dev Team A | @appdev-lead-a |
| *portal* | App Dev Team B | @appdev-lead-b |
| *management* | App Dev Team A | @appdev-lead-a |
| *analytics* | App Dev Team B | @appdev-lead-b |

### Quick Links
- [Splunk Alert Dashboard](https://your-splunk.com/alerts)
- [AWS Service Health](https://health.aws.amazon.com/health/home)
- [SRE Incident Tracking](https://your-incident-system.com)
- [App Dev Investigation Guide](https://github.com/your-org/infrastructure-wiki/wiki/App-Dev-Degraded-Response-Times-Investigation)

---

## Runbook Maintenance

### Review Schedule
- **Weekly**: Update contact information and team mappings
- **Monthly**: Review escalation thresholds and email template effectiveness
- **Post-Incident**: Update based on lessons learned and feedback

### Version History
| **Version** | **Date** | **Author** | **Changes** |
|-------------|----------|------------|-------------|
| 1.0 | 2024-08-12 | @sre-lead | Initial SRE-focused runbook |

---

*This runbook is for SRE team internal use only. The corresponding App Dev Investigation Guide should be shared with application development teams.*