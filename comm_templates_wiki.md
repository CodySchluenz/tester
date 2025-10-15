# Incident Communication Templates

**Last Updated:** January 2025 | **Owner:** SRE Team

---

## Table of Contents
- [Overview](#overview)
- [Internal Stakeholder Templates](#internal-stakeholder-templates)
- [Executive & Leadership Templates](#executive--leadership-templates)
- [Tips for Effective Communication](#tips-for-effective-communication)

---

## Overview

Use these standardized templates for incident communications. Templates ensure consistency, speed up communication during high-pressure situations, and ensure critical information isn't missed.

**How to use these templates:**
1. Copy the template that matches your situation
2. Replace bracketed placeholders with actual information
3. Customize as needed for specific incident context
4. Remove any sections not applicable to your incident

**Key principles:**
- Lead with impact, then technical details
- Be clear and concise
- Set expectations for next update
- Communicate uncertainty honestly, don't speculate

---

## Internal Stakeholder Templates

Use these templates for Microsoft Teams incident channels and internal email communications.

### Initial Incident Notification

Post this when incident is first declared to notify all stakeholders.

```
🚨 INCIDENT DECLARED
Severity: SEV-X
Incident: INC-XXXXXXX
Time: YYYY-MM-DD HH:MM UTC

Summary: [Brief description of issue - one sentence]
Impact: [What users are experiencing]
Affected Services: [List services/APIs affected]
Scope: [All users / Subset of users / Specific customers / Percentage]

Response Team:
- Incident Commander: [Name]
- Operations Lead: [Name / Platform: Name, API Enablement: Name]
- Communications Lead & Scribe: [Name]

Links:
- ServiceNow: [link to incident]
- Problem Dashboard: [link]
- Dynatrace: [link to relevant service view]

Next Steps: [What we're doing - brief]
Next Update: [Timeframe - 30 min for SEV-1, 60 min for SEV-2]
```

**Example:**
```
🚨 INCIDENT DECLARED
Severity: SEV-1
Incident: INC-987654
Time: 2025-01-15 14:30 UTC

Summary: API Connect Gateway experiencing high latency causing API timeouts
Impact: All external API requests timing out. Users unable to retrieve data or submit transactions.
Affected Services: All APIs (Orders, Products, Customers, Inventory)
Scope: All external partners and customers

Response Team:
- Incident Commander: John Smith
- Operations Lead - Platform: Jane Doe
- Operations Lead - API Enablement: Bob Johnson
- Communications Lead & Scribe: Alice Williams

Links:
- ServiceNow: https://hartford.service-now.com/incident.do?sysparm_query=number=INC987654
- Problem Dashboard: https://splunk.hartford.com/problem-dashboard
- Dynatrace: https://dynatrace.hartford.com/apic/gateway-health

Next Steps: Checking recent deployments and infrastructure health
Next Update: 15:00 UTC (30 minutes)
```

---

### Status Update - Investigating

Use during active investigation when root cause is not yet known.

```
📊 STATUS UPDATE - INC-XXXXXXX
Time Elapsed: [X hours Y minutes]
Current Status: Investigating

What we know:
- [Finding 1 - what systems/metrics are showing issues]
- [Finding 2 - what we've ruled out]
- [Finding 3 - current leading theory if any]

What we're doing:
- [Current investigation action 1]
- [Current investigation action 2]
- [Who we've engaged - vendor support, additional teams]

Impact Update: [Unchanged / Improving / Worsening]
- [Specific metrics if available - error rate, latency, affected users]

Next Update: [Timeframe - HH:MM UTC]
```

**Example:**
```
📊 STATUS UPDATE - INC-987654
Time Elapsed: 30 minutes
Current Status: Investigating

What we know:
- API Gateway p95 latency at 8s (normal: 500ms)
- Error rate normal (~0.5%), but requests timing out
- Issue started at 14:15 UTC, aligns with recent deployment
- Traffic levels normal, not a capacity issue

What we're doing:
- Reviewing deployment v2.3.4 that went out at 14:10 UTC
- Checking gateway pod metrics and logs in Dynatrace
- Opened IBM Support ticket #CS12345 for assistance
- Preparing rollback plan as backup

Impact Update: Unchanged
- All external APIs still experiencing timeouts
- Approximately 2,000 failed requests since incident start

Next Update: 15:00 UTC (30 minutes)
```

---

### Status Update - Mitigating

Use when root cause is identified and mitigation is in progress.

```
📊 STATUS UPDATE - INC-XXXXXXX
Time Elapsed: [X hours Y minutes]
Current Status: Mitigation in Progress

Root Cause: [Brief explanation of what caused the issue]

Mitigation Actions:
- [Action being taken - e.g., rolling back deployment]
- [Expected impact of this action]
- [ETA for completion]

Impact Update: [Unchanged / Beginning to improve / Customers seeing improvement]
- [Specific metrics or observations]

Next Update: [Timeframe - HH:MM UTC] or when mitigation complete
```

**Example:**
```
📊 STATUS UPDATE - INC-987654
Time Elapsed: 45 minutes
Current Status: Mitigation in Progress

Root Cause: Deployment v2.3.4 introduced memory leak in gateway pods causing progressive performance degradation.

Mitigation Actions:
- Rolling back to v2.3.3 (last known good version)
- Rollback started at 15:10 UTC
- New pods currently deploying (4/10 complete)
- ETA for rollback completion: 15:20 UTC

Impact Update: Beginning to improve
- New pods showing normal latency (500ms)
- Old pods still showing high latency until replaced
- Expect full recovery within 10 minutes

Next Update: 15:25 UTC when rollback complete
```

---

### Mitigated Notification

Use when service is restored but may not be fully stable yet.

```
✅ SERVICE RESTORED
Incident: INC-XXXXXXX
Duration: [X hours Y minutes]
Status: MITIGATED

Service is functional. Monitoring for stability.

What happened: [Brief summary - 1-2 sentences]
How we fixed it: [Brief explanation of mitigation action]

Investigation Status: [Continuing to identify root cause / Root cause known, permanent fix planned]
Monitoring: Will continue monitoring for [timeframe] to ensure stability.

Postmortem: [Will be completed / Required - assigned to NAME]

Next Update: When marking as Resolved or if issues recur
```

**Example:**
```
✅ SERVICE RESTORED
Incident: INC-987654
Duration: 1 hour 15 minutes
Status: MITIGATED

Service is functional. Monitoring for stability.

What happened: Deployment v2.3.4 caused memory leak leading to high latency and timeouts.
How we fixed it: Rolled back to v2.3.3. All pods now running stable version.

Investigation Status: Root cause identified. Will analyze deployment v2.3.4 to identify specific code issue. Permanent fix will include testing improvements.
Monitoring: Continuing to monitor for 1 hour to ensure sustained stability.

Postmortem: Required (SEV-1). Assigned to John Smith. Target completion: 2025-01-20.

Next Update: 16:30 UTC when marking as Resolved, or immediately if issues recur
```

---

### Resolved Notification

Use when service is fully restored and stable.

```
✅ INCIDENT RESOLVED
Incident: INC-XXXXXXX
Total Duration: [X hours Y minutes]
Status: RESOLVED

All systems normal and stable.

Root Cause: [Summary - 2-3 sentences explaining what happened and why]

Resolution: [What was done to fix the issue]

Verification:
- [How we confirmed service is healthy]
- [Metrics showing normal operation]
- [Duration of stable operation]

Prevention: [Actions being taken to prevent recurrence]
- [Action item 1]
- [Action item 2]

Postmortem: [Link when available / Will be completed by DATE]

Thank you to all responders: [List names or teams]
```

**Example:**
```
✅ INCIDENT RESOLVED
Incident: INC-987654
Total Duration: 1 hour 45 minutes (14:30 UTC - 16:15 UTC)
Status: RESOLVED

All systems normal and stable.

Root Cause: Deployment v2.3.4 introduced a memory leak in the API Gateway connection pool management code. As pods accumulated memory, garbage collection increased, causing progressive latency degradation. Eventually pods exceeded memory limits and began timing out requests.

Resolution: Rolled back deployment to v2.3.3. All gateway pods redeployed with stable version. Service restored at 15:20 UTC. Monitored for 1 hour to confirm sustained stability.

Verification:
- API latency back to normal: p95 at 480ms, p99 at 850ms
- Error rate at baseline: 0.4%
- All synthetic monitors passing
- Stable for 1 hour with no anomalies

Prevention: Actions being taken to prevent recurrence:
- Code review of v2.3.4 changes to identify and fix memory leak
- Enhanced load testing requirements for gateway changes
- Memory profiling added to CI/CD pipeline
- Improved monitoring alerts for memory growth patterns

Postmortem: Will be completed by 2025-01-20. Assigned to John Smith.

Thank you to all responders: John Smith (IC), Jane Doe (Platform Ops Lead), Bob Johnson (API Enablement Ops Lead), Alice Williams (Comms/Scribe), and IBM Support team.
```

---

## Executive & Leadership Templates

Use these templates when communicating to Engineering Managers, Directors, VPs, or executives.

### Executive Status Update (During Incident)

Use for updates to leadership during active SEV-1 or extended SEV-2 incidents.

```
Subject: [SEV-X] Incident Update - [Brief Description]

Incident: INC-XXXXXXX
Status: [Investigating / Mitigating / Resolved]
Duration: [X hours Y minutes elapsed]

Business Impact:
- [Customer-facing impact in business terms]
- [Number/percentage of users affected]
- [Revenue or operations impact if applicable]
- [Customer escalations or complaints if any]

Current Status:
- [What we know about the problem]
- [What we're doing to fix it]
- [ETA for resolution if known]

Root Cause: [If known, explain in non-technical terms]

Next Steps:
- [Immediate actions being taken]
- [Who is working on this]

Communication:
- [Customer support has been notified / Status page updated / Customer comms sent]

Next Update: [Timeframe]

Technical Details: [Link to Teams incident channel for those who want more detail]
```

**Example:**
```
Subject: [SEV-1] Incident Update - API Gateway Outage

Incident: INC-987654
Status: Mitigating
Duration: 45 minutes elapsed

Business Impact:
- All external API requests failing - complete outage for partners and customers
- Approximately 15 customers affected (all external API consumers)
- Estimated 3,000+ failed transactions since incident start
- 4 customer escalations received by support team

Current Status:
- Identified root cause: Recent software deployment caused memory issues in API gateway
- Currently rolling back to previous version
- Expect service restoration within 10-15 minutes

Root Cause: A deployment released 20 minutes before the incident introduced a software defect that caused memory issues in our API gateway system.

Next Steps:
- Complete rollback (ETA: 10 minutes)
- Monitor for full recovery
- Analyze defective deployment to prevent similar issues

Communication:
- Customer support team notified and responding to escalations
- Status page will be updated once service is restored

Next Update: 15 minutes or when service restored

Technical Details: https://teams.microsoft.com/l/channel/incident-2025-01-15-api-latency
```

---

### Executive Summary (Post-Incident)

Send after incident is resolved to provide complete overview for leadership.

```
Subject: [SEV-X] Incident Summary - [Brief Description]

Incident: INC-XXXXXXX
Duration: [Start time] - [End time] ([Total duration])
Severity: SEV-X

SUMMARY:
[1-2 sentence overview of what happened and impact]

BUSINESS IMPACT:
- Customer Impact: [What customers experienced]
- Users Affected: [Number or percentage]
- Duration: [How long customers were impacted]
- Financial Impact: [If measurable - revenue loss, SLA credits, etc.]
- Reputational Impact: [Customer complaints, media attention, etc.]

ROOT CAUSE:
[Explanation in business terms - avoid technical jargon]
[Why it happened - process gap, oversight, known risk, etc.]

RESOLUTION:
[What we did to fix it - in simple terms]
[Why this approach was chosen]

TIMELINE:
- [HH:MM] Issue detected
- [HH:MM] Incident declared
- [HH:MM] Root cause identified
- [HH:MM] Mitigation started
- [HH:MM] Service restored
- [HH:MM] Incident resolved

PREVENTION MEASURES:
Short-term (next 2 weeks):
- [Immediate fix or process change]

Medium-term (next 1-2 months):
- [Preventive measure 1]
- [Preventive measure 2]

Long-term (next quarter):
- [Systemic improvement]

POSTMORTEM:
- Postmortem report: [Link or "will be available by DATE"]
- Owner: [Name]
- Review meeting: [Date/time if scheduled]

Questions or concerns: [Contact info]
```

**Example:**
```
Subject: [SEV-1] Incident Summary - API Gateway Outage on 2025-01-15

Incident: INC-987654
Duration: 2025-01-15 14:30 UTC - 16:15 UTC (1 hour 45 minutes)
Severity: SEV-1

SUMMARY:
A software deployment caused a memory leak in our API gateway, resulting in a complete outage of all external API services for 1 hour 45 minutes. Service was restored by rolling back the deployment.

BUSINESS IMPACT:
- Customer Impact: All external API requests failed. Customers unable to retrieve data or submit transactions.
- Users Affected: All 15 external API customers (100% of external API traffic)
- Duration: 1 hour 45 minutes of complete outage
- Financial Impact: Estimated 4,000+ failed transactions. Potential SLA credits for customers with availability guarantees.
- Reputational Impact: 6 customer escalations received. One customer threatened to evaluate alternative providers.

ROOT CAUSE:
A new software version (v2.3.4) was deployed to our API gateway at 14:10 UTC. This version contained a code defect in the connection pool management that caused a memory leak. As the gateway accumulated memory usage, performance degraded until requests began timing out completely at 14:30 UTC.

The deployment passed all automated tests, but our current test suite doesn't include sustained load testing that would have caught this memory leak pattern.

RESOLUTION:
We rolled back to the previous stable version (v2.3.3) within 45 minutes of identifying the root cause. All gateway systems were redeployed with the stable version. Service was restored at 15:20 UTC and remained stable for over 1 hour of observation before declaring the incident resolved.

TIMELINE:
- 14:10 UTC - Deployment v2.3.4 released
- 14:30 UTC - High latency and timeouts detected, incident declared
- 14:45 UTC - Root cause identified (deployment correlation)
- 15:10 UTC - Rollback initiated
- 15:20 UTC - Service restored (mitigated)
- 16:15 UTC - Incident resolved after stability confirmed

PREVENTION MEASURES:
Short-term (next 2 weeks):
- Immediate code review of v2.3.4 to identify and fix memory leak
- Deploy fixed version with enhanced testing

Medium-term (next 1-2 months):
- Implement sustained load testing (4+ hours) for all gateway deployments
- Add memory profiling to CI/CD pipeline
- Enhanced monitoring for memory growth patterns with earlier alerts

Long-term (next quarter):
- Gradual rollout process (canary deployments) for platform changes
- Automated rollback triggers based on error rates and latency
- Investment in chaos engineering and resilience testing

POSTMORTEM:
- Postmortem report: Will be available by 2025-01-20
- Owner: John Smith (Platform Team Lead)
- Review meeting: 2025-01-22 at 2:00 PM ET (all engineering invited)

Questions or concerns: Contact John Smith or reply to this email.
```

---

## Tips for Effective Communication

### Be Clear and Concise

Lead with impact, then technical details. Use simple language and avoid jargon when communicating to non-technical stakeholders. Use bullet points for scannability - executives and managers often skim.

**Good example:**
"All API requests are failing. Customers cannot retrieve data. We're rolling back a recent deployment that caused the issue. Expect recovery in 15 minutes."

**Bad example:**
"We're seeing degraded performance across the API Connect gateway pods due to elevated memory consumption causing GC pressure and eventual OOMKill events. The deployment from this morning modified the connection pool implementation which appears to have introduced a leak."

### Communicate Uncertainty Honestly

Only communicate facts you know. If you don't know something, say so. Don't guess at root cause until confirmed.

**Good example:**
"We're investigating two potential causes: recent deployment or database issue. Will update in 30 minutes with findings."

**Bad example:**
"We think maybe it's the deployment but not sure, could be other things too, hard to say right now."

### Set Expectations

Always include when next update will be sent. If you miss an update time, acknowledge it. Under-promise, over-deliver on ETAs - better to say "recovery in 30 minutes" and finish in 20 than say "10 minutes" and take 25.

### Stay Calm and Professional

Even during high-pressure SEV-1 incidents, maintain professional tone. Avoid emotional language. Focus on facts and actions. Don't use all caps (except for 🚨 INCIDENT DECLARED headers) or excessive punctuation.

### Tailor Communication to Audience

**For engineers:** Include technical details, links to dashboards, specific metrics.

**For managers:** Balance technical and business impact, focus on resolution progress.

**For executives:** Lead with business impact, keep technical details brief and in simple terms.

**For customers:** Focus entirely on their experience, avoid internal jargon, provide realistic ETAs.

---

## Related Documentation

- [Incident Response Roles - Communications Lead & Scribe](/wiki/Incident-Response-Roles#communications-lead--scribe) - Role responsibilities
- [Incident Response Overview](/wiki/Incident-Response-Overview) - Full incident process
- [ServiceNow Incident Documentation](/wiki/ServiceNow-Incident-Documentation) - Where to document timeline

---

**Location:** `github.com/the-hartford/cto_esb_apic_wiki/wiki/Incident-Communication-Templates`  
**Maintained by:** SRE Team | **Review:** Quarterly