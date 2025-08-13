# SRE Runbook: Success to Failure Ratio Alert Triage

## Overview
This runbook is for **SRE team use only** when receiving "Success to Failure Ratio" alerts from Splunk. The SRE role is to triage the alert, gather context, and notify the appropriate app dev teams with actionable information.

### Alert Details
- **Alert Name**: Success to Failure Ratio
- **Source**: Splunk Email Alert
- **Trigger Condition**: API error rate ≥15% sustained over 15-minute period
- **SLO Impact**: Error Rate SLI (Target: <0.1% error rate)
- **Business Impact**: Service degradation, potential customer impact, SLA violations

---

## SRE Triage Process (0-10 minutes)

### 1. Alert Processing
- [ ] Receive Splunk email alert
- [ ] Extract key details from alert:
  - Timestamp and duration of high error rate
  - Affected APIs/endpoints showing errors
  - Environment scope (LAB/INT/QA/PROD)
  - Current error rate percentage vs 15% threshold
  - Total request volume during period

### 2. Severity Assessment
Use this decision tree:
- **>50% error rate**: Escalate to P1, call app dev lead directly
- **25-50% error rate**: Escalate to P1, urgent email notification
- **15-25% error rate**: Continue as P2, standard email notification
- **<15% but alert still active**: Monitor for 10 minutes, may be transient spike

### 3. Context Gathering
Run these quick checks to provide context to app teams:
- [ ] Check for correlated alerts (response time, infrastructure)
- [ ] Verify which app dev team owns the affected APIs
- [ ] Note any recent deployments or infrastructure changes
- [ ] Check if error pattern is isolated or widespread

---

## Email Template for App Dev Teams

Copy and customize this template when forwarding alerts:

```
Subject: [ALERT - P2] IBM API Connect: High Error Rate Detected - [API_NAME]

Hi [APP_DEV_TEAM],

We've detected a significant increase in API error rates exceeding our SLO threshold. Please investigate using the linked guide.

🔗 **Investigation Guide**: https://github.com/your-org/infrastructure-wiki/wiki/App-Dev-Error-Rate-Investigation

📊 **Alert Details**:
- Alert Time: [TIMESTAMP_FROM_SPLUNK]
- Affected API/Endpoint: [API_NAME_FROM_ALERT]
- Environment: [ENVIRONMENT_FROM_ALERT]
- Current Error Rate: [ERROR_RATE_PERCENTAGE]% (Threshold: 15%)
- Alert Duration: [HOW_LONG_ALERT_ACTIVE]
- Request Volume: [TOTAL_REQUESTS_IN_PERIOD]

⚠️ **Error Pattern**:
- Error Types: [TOP_ERROR_CODES_FROM_ALERT]
- Peak Error Rate: [HIGHEST_PERCENTAGE_SEEN]
- Trend: [INCREASING/STABLE/DECREASING]

⏰ **SLA Impact**: 
- Current error budget consumption: [CALCULATE_IF_AVAILABLE]
- Monthly error budget at risk: [PERCENTAGE_OF_MONTHLY_BUDGET]

🔍 **Infrastructure Context** (if relevant):
- Recent deployments: [NONE/DESCRIBE_RECENT_CHANGES]
- Correlated alerts: [RESPONSE_TIME/INFRASTRUCTURE_ALERTS]
- Cross-environment impact: [SINGLE_ENV/MULTIPLE_ENVS]
- Infrastructure events: [CHECK_AWS_HEALTH_DASHBOARD]

Please acknowledge receipt and provide ETA for initial assessment within 30 minutes.

**Need SRE assistance?** Reply to this email or contact @sre-oncall in Slack.

Thanks,
SRE Team
```

---

## SRE Monitoring During Investigation

While app dev teams investigate, SRE should monitor:

### Continuous Monitoring Tasks
- [ ] **Error Rate Progression**: Track if error percentage is increasing or stabilizing
- [ ] **Scope Expansion**: Monitor for additional APIs becoming affected  
- [ ] **Request Volume Impact**: Check if high error rate is affecting overall throughput
- [ ] **Customer Impact**: Watch for support tickets or user complaints
- [ ] **Infrastructure Correlation**: Monitor for related infrastructure alerts

### Monitoring Queries for SRE
```splunk
# Current error rate trending - run every 10 minutes
index=apiconnect earliest=-1h
| bin _time span=5m
| stats count as total_requests, count(eval(status>=400)) as error_requests by _time, api_name
| eval error_rate=round((error_requests/total_requests)*100,2)
| eval status=case(error_rate>=50,"CRITICAL",error_rate>=25,"SEVERE",error_rate>=15,"DEGRADED",1=1,"NORMAL")
| sort _time

# Error type breakdown for context
index=apiconnect earliest=-30m status>=400
| stats count by status, api_name
| sort -count
| head 10

# Request volume comparison
index=apiconnect earliest=-2h
| bin _time span=15m
| stats count as requests, count(eval(status>=400)) as errors by _time
| eval error_rate=round((errors/requests)*100,2)
| eval volume_change=if(_time>=relative_time(now(),"-30m"), "current", "baseline")
```

---

## Escalation Procedures

### When to Escalate to P1
- Error rate > 50% sustained for > 5 minutes
- Error rate > 25% sustained for > 15 minutes  
- Multiple critical APIs affected simultaneously
- Complete API unavailability (100% error rate)
- No app dev team response within 30 minutes
- Customer escalations received via support channels

### P1 Escalation Process
1. **Immediate**: Call app dev lead directly (don't wait for email response)
2. **Incident Commander**: SRE becomes incident commander for P1s
3. **Communication**: Start incident bridge, update stakeholders every 10 minutes
4. **Documentation**: Switch to P1 incident tracking procedures

### Escalation Contacts
| **Escalation Level** | **Contact** | **When to Escalate** |
|---------------------|-------------|---------------------|
| App Dev Team A Lead | @appdev-lead-a | Team A APIs affected |
| App Dev Team B Lead | @appdev-lead-b | Team B APIs affected |
| Senior SRE | @senior-sre-lead | P1 declaration or no team response |
| Platform Manager | @platform-manager | Multi-environment impact |
| Product Owner | @product-owner | Confirmed customer impact |

---

## SRE Support Guidelines

### When App Dev Teams Should Contact SRE
- Infrastructure-level issues suspected (load balancer, AWS services)
- Cross-API correlation analysis needed
- Help with Splunk query creation for error analysis
- Vendor escalation required (AWS support, third-party services)
- Network or DNS issues suspected

### SRE Assistance Available
1. **Infrastructure Analysis**: Load balancer health, AWS service status, network issues
2. **Historical Context**: Pattern recognition from previous error rate incidents
3. **Cross-API Analysis**: Identifying if errors span multiple services or teams
4. **Splunk Query Support**: Custom searches for specific error investigation needs
5. **Vendor Coordination**: AWS support cases, CDN issues, external dependencies

### Infrastructure Context to Provide
When app teams request SRE assistance, check and share:
- [ ] Load balancer error rates and health check status
- [ ] AWS service disruptions or elevated error rates
- [ ] DNS resolution issues or CDN problems
- [ ] Recent network configuration changes
- [ ] Cross-environment error pattern analysis
- [ ] Third-party service status pages and incidents

---

## Handoff and Follow-up

### Successful Handoff Criteria
- [ ] App dev team acknowledges receipt within 30 minutes
- [ ] Team provides initial assessment ETA
- [ ] Investigation guide link confirmed working
- [ ] Any infrastructure context shared if relevant
- [ ] Error pattern and scope clearly communicated

### SRE Follow-up Tasks
- [ ] Monitor alert status for resolution (error rate < 15%)
- [ ] Update incident tracking system
- [ ] Schedule post-mortem if P1 or >30 minute resolution
- [ ] Document any new error patterns or lessons learned

### When to Close SRE Involvement
- App dev team confirms resolution and error rate < 0.1%
- Alert clears in Splunk consistently for 30+ minutes
- SLO metrics return to normal ranges
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

### App Dev Team Mapping by API Pattern
| **API/Service Pattern** | **Owning Team** | **Primary Contact** |
|------------------------|-----------------|-------------------|
| */gateway/* | App Dev Team A | @appdev-lead-a |
| */portal/* | App Dev Team B | @appdev-lead-b |
| */management/* | App Dev Team A | @appdev-lead-a |
| */analytics/* | App Dev Team B | @appdev-lead-b |
| */oauth/* | Platform Team | @platform-lead |

### Quick Links
- [Splunk Error Rate Dashboard](https://your-splunk.com/dashboard/error-rates)
- [AWS Load Balancer Health](https://console.aws.amazon.com/ec2/v2/home#LoadBalancers)
- [AWS Service Health](https://health.aws.amazon.com/health/home)
- [SRE Incident Tracking](https://your-incident-system.com)
- [App Dev Error Investigation Guide](https://github.com/your-org/infrastructure-wiki/wiki/App-Dev-Error-Rate-Investigation)

---

## Common Error Rate Patterns

### Pattern Recognition for Context
- **Deployment-Related**: Sharp spike in 500 errors immediately after deployment
- **Dependency Failure**: High rate of 502/503 errors indicating downstream issues
- **Authentication Issues**: Spike in 401/403 errors suggesting auth service problems
- **Rate Limiting**: 429 errors indicating traffic spike or DDoS
- **Database Issues**: 500 errors with database connection error patterns
- **Configuration Problems**: Mixed error types after configuration changes

### Typical Resolution Times by Pattern
| **Error Pattern** | **Common Cause** | **Typical Resolution** |
|------------------|------------------|----------------------|
| Post-deployment spike | Bad deployment | 10-20 min (rollback) |
| Dependency 502/503 | External service down | 15-60 min (vendor dependent) |
| Auth 401/403 spike | Auth service issue | 5-30 min (service restart) |
| Database 500s | DB connection/performance | 10-45 min (DB team involvement) |
| Configuration errors | Config mistake | 15-30 min (config revert) |
| Rate limiting 429s | Traffic spike/attack | 5-15 min (scaling/blocking) |

---

## Runbook Maintenance

### Review Schedule
- **Weekly**: Update contact information and team mappings
- **Monthly**: Review escalation thresholds and email template effectiveness
- **Post-Incident**: Update based on lessons learned and feedback from error rate incidents

### Version History
| **Version** | **Date** | **Author** | **Changes** |
|-------------|----------|------------|-------------|
| 1.0 | 2024-08-12 | @sre-lead | Initial SRE-focused runbook for error rate alerts |

---

*This runbook is for SRE team internal use only. The corresponding App Dev Error Rate Investigation Guide should be shared with application development teams.*