# Post-Mortem Process

## Overview

Post-mortems are a critical component of our SRE practice for IBM API Connect. They help us learn from incidents, improve our systems, and prevent future issues through blameless analysis and systematic improvement.

---

## When to Conduct a Post-Mortem

### Required Post-Mortems
- **P1 incidents** (any severity level that required escalation)
- **Incidents lasting >30 minutes** regardless of severity
- **SLO breaches** that consume >10% of monthly error budget
- **Customer-impacting incidents** with external complaints
- **Multi-environment incidents** affecting multiple stages

### Optional Post-Mortems
- **Interesting near-misses** that could have been major incidents
- **Process failures** even if no service impact occurred
- **Learning opportunities** where significant insights were gained

---

## Post-Mortem Process

### 1. Initiation (Within 24 hours of resolution)
- **SRE Team** creates post-mortem document from template
- **Incident Owner** (usually App Dev lead) assigned as author
- **Timeline**: Must be completed within 1 week of incident

### 2. Writing Phase (Days 1-5)
- Author completes all sections using template
- Gather evidence: logs, metrics, screenshots, chat transcripts
- Interview involved team members for complete timeline
- Focus on facts, not blame

### 3. Review Phase (Days 5-7)
- **Technical Review**: Senior engineer reviews for accuracy
- **Process Review**: SRE manager reviews response procedures  
- **Business Review**: Product owner reviews impact assessment

### 4. Team Discussion (Week 2)
- Schedule 60-minute team meeting to discuss findings
- Focus on lessons learned and improvement actions
- Assign owners and due dates for action items

### 5. Follow-up (Ongoing)
- Track action item completion monthly
- Review effectiveness of implemented changes
- Update runbooks and procedures based on learnings

---

## Post-Mortem Template

Use this template for all post-mortems. Copy the content below and create a new wiki page for each incident.

### Template Usage Instructions
1. **Copy the template** from the section below
2. **Create new wiki page** named: `Post-Mortem-YYYY-MM-DD-Incident-Brief-Description`
3. **Replace all bracketed placeholders** with actual incident details
4. **Complete all sections** - don't skip any, mark N/A if not applicable
5. **Include supporting evidence** - logs, screenshots, metrics
6. **Schedule review meetings** once draft is complete

---

## POST-MORTEM TEMPLATE

*Copy everything below this line for your post-mortem*

---

# Post-Mortem: [Incident Title]

**Date**: [YYYY-MM-DD]  
**Incident ID**: [INC-XXXXXX]  
**Author**: [Name/Team]  
**Reviewers**: [Names of reviewers]  
**Status**: [Draft/Under Review/Final]

---

## Executive Summary

**One-line summary**: [Brief description of what happened and impact]

**Duration**: [Total time from detection to resolution]  
**Severity**: [P1/P2/P3]  
**User Impact**: [Description of customer/business impact]  
**Root Cause**: [Single sentence describing the fundamental cause]

---

## Incident Overview

### Services Affected
- **Primary**: [IBM API Connect services directly impacted]
- **Secondary**: [Downstream/dependent services affected]
- **Environments**: [LAB/INT/QA/PROD - list all affected]

### Timeline Summary
| Time (EST) | Event | Owner |
|------------|-------|-------|
| HH:MM | [Incident began] | - |
| HH:MM | [Detection/Alert fired] | SRE |
| HH:MM | [Investigation started] | App Dev |
| HH:MM | [Root cause identified] | App Dev |
| HH:MM | [Fix implemented] | App Dev |
| HH:MM | [Service restored] | App Dev |
| HH:MM | [Incident closed] | SRE |

### Impact Metrics
- **SLO Breach**: [Yes/No - if yes, which SLOs and by how much]
- **Error Budget Consumed**: [X% of monthly budget]
- **API Response Time**: [Peak degradation: XXXms vs target 200ms]
- **Error Rate**: [Peak error rate: X% vs target <0.1%]
- **User Experience**: [Describe impact on end users]
- **Business Impact**: [Revenue/operations impact if applicable]

---

## Detailed Timeline

*Use 24-hour format (EST) with precise timestamps*

### Day 1 - [Date]

**HH:MM - Incident Begin**
- [Describe what actually started going wrong, even if not detected yet]
- [Include any preceding conditions or changes]

**HH:MM - Detection** 
- [How was the incident detected - alert, user report, monitoring]
- [Splunk alert: "Degraded Response Times" triggered]
- [SRE on-call: @person-name notified via email]

**HH:MM - Initial Response**
- [SRE actions: alert triage, team notification]
- [Email sent to App Dev Team X using runbook template]
- [App Dev Team acknowledgment and assignment]

**HH:MM - Investigation Phase**
- [App Dev actions: running Splunk searches, checking logs]
- [Initial hypotheses and areas investigated]
- [SRE support provided: infrastructure context, etc.]

**HH:MM - Escalation** *(if applicable)*
- [Reason for escalation: P1 declaration, no progress, etc.]
- [Additional teams/people brought in]
- [Incident commander assigned]

**HH:MM - Root Cause Discovery**
- [Specific finding that identified the root cause]
- [Evidence that confirmed this was the issue]

**HH:MM - Fix Implementation**
- [Exact actions taken to resolve the issue]
- [Commands run, configurations changed, deployments made]

**HH:MM - Verification**
- [How resolution was confirmed]
- [Metrics checked, tests performed]

**HH:MM - Resolution**
- [Service confirmed fully restored]
- [Alerts cleared, SLOs back to normal]
- [All-clear communicated]

---

## Root Cause Analysis

### What Happened
[Detailed technical explanation of the root cause]

### Why It Happened
[Contributing factors that led to this situation]

### How It Was Fixed
[Technical details of the resolution]

### Why It Wasn't Caught Earlier
[Analysis of detection gaps and why monitoring didn't prevent this]

---

## Contributing Factors

### Technical Factors
- [ ] **Code/Application**: [Recent deployment, bug, configuration]
- [ ] **Infrastructure**: [AWS service, Kubernetes, networking]
- [ ] **Dependencies**: [External service, database, cache]
- [ ] **Monitoring**: [Alert gaps, threshold issues, blind spots]

### Process Factors  
- [ ] **Change Management**: [Inadequate testing, rushed deployment]
- [ ] **Communication**: [Poor handoffs, unclear procedures]
- [ ] **Documentation**: [Outdated runbooks, missing procedures]
- [ ] **Training**: [Knowledge gaps, unfamiliar procedures]

### Organizational Factors
- [ ] **Team Structure**: [On-call coverage, expertise gaps]
- [ ] **Tooling**: [Inadequate tools, access issues]
- [ ] **Prioritization**: [Competing priorities, technical debt]

---

## What Went Well

### Positive Aspects
- [Things that worked well during the incident response]
- [Effective communication, good decision making, fast resolution]
- [Tools that helped, procedures that worked]

### Strengths to Maintain
- [Processes or capabilities to preserve and build upon]

---

## What Went Poorly

### Issues Identified
- [Things that slowed down resolution or made the incident worse]
- [Communication gaps, tool failures, process breakdowns]

### Areas for Improvement
- [Specific capabilities or processes that need enhancement]

---

## Action Items

### Immediate Actions (Complete within 1 week)
| Action | Owner | Due Date | Status |
|--------|-------|----------|---------|
| [Specific action to prevent recurrence] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [Monitoring/alerting improvement] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [Documentation update] | @owner | YYYY-MM-DD | Open/In Progress/Done |

### Short-term Actions (Complete within 1 month)
| Action | Owner | Due Date | Status |
|--------|-------|----------|---------|
| [Process improvement] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [Tool enhancement] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [Training/knowledge sharing] | @owner | YYYY-MM-DD | Open/In Progress/Done |

### Long-term Actions (Complete within 1 quarter)
| Action | Owner | Due Date | Status |
|--------|-------|----------|---------|
| [Architectural change] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [Infrastructure improvement] | @owner | YYYY-MM-DD | Open/In Progress/Done |
| [SRE practice enhancement] | @owner | YYYY-MM-DD | Open/In Progress/Done |

---

## Prevention Measures

### Monitoring Improvements
- **New Alerts**: [Specific alerts to add or modify]
- **SLO Updates**: [Changes to SLO definitions or thresholds]
- **Dashboard Enhancements**: [New metrics or visualizations needed]

### Process Improvements  
- **Runbook Updates**: [Changes to incident response procedures]
- **Testing Procedures**: [Enhanced testing before deployments]
- **Change Management**: [Improved approval/rollback processes]

### Technical Improvements
- **Architecture Changes**: [Design improvements to prevent recurrence]
- **Automation**: [Automated responses or remediation]
- **Resilience**: [Circuit breakers, fallbacks, redundancy]

---

## Lessons Learned

### Key Takeaways
1. [Most important lesson learned from this incident]
2. [Secondary lesson about process, technology, or communication]
3. [Insight about team capabilities or gaps]

### Knowledge Sharing
- **Team Presentation**: [Schedule team discussion of findings]
- **Documentation Updates**: [Runbooks, procedures, architecture docs to update]
- **Training Needs**: [Skills or knowledge gaps to address]

---

## SLO and Error Budget Impact

### SLO Performance
| SLO | Target | Actual During Incident | Impact |
|-----|--------|----------------------|---------|
| API Response Time (p95) | <200ms | XXXms | Breached for XXmin |
| API Availability | 99.9% | XX.X% | Breached/Within target |
| Error Rate | <0.1% | X.X% | Breached/Within target |

### Error Budget Analysis
- **Monthly Budget Consumed**: [X% of total monthly budget]
- **Budget Remaining**: [X% remaining for rest of month]
- **Burn Rate**: [How quickly budget was consumed during incident]
- **Recovery Time**: [Time needed to return to normal burn rate]

---

## Communication Assessment

### Internal Communication
- **SRE → App Dev Handoff**: [How well did the email/runbook process work?]
- **Escalation Process**: [Was escalation timely and effective?]
- **Status Updates**: [Were stakeholders kept informed appropriately?]

### External Communication
- **Customer Notification**: [Were customers informed if needed?]
- **Status Page Updates**: [Were public status pages updated?]
- **Support Team Coordination**: [Did support teams have needed information?]

---

## Related Incidents

### Previous Similar Incidents
- [INC-XXXXX]: [Date] - [Brief description and relationship]
- [INC-XXXXX]: [Date] - [Brief description and relationship]

### Pattern Analysis
- [Are there recurring themes or patterns?]
- [Is this part of a larger systemic issue?]

---

## Metrics and Data

### Response Time Metrics
```
Peak response time: XXXms
Average response time during incident: XXXms
Time to detection: XX minutes
Time to resolution: XX minutes
```

### Error Rate Data
```
Peak error rate: X.XX%
Total failed requests: XXXXX
Most affected endpoints: [list top 3]
```

### Recovery Metrics
```
Time to first fix attempt: XX minutes
Time to successful resolution: XX minutes
Time to full service restoration: XX minutes
```

---

## Supporting Evidence

### Splunk Queries Used
```splunk
# Response time analysis during incident
index=apiconnect source="*api-gateway*" earliest=[start_time] latest=[end_time]
| bin _time span=5m
| stats p95(response_time) as p95_resp by _time
```

### Relevant Log Excerpts
```
[Timestamp] ERROR: [Key error message that helped identify issue]
[Timestamp] WARN: [Warning that preceded the incident]
```

### Screenshots/Dashboards
- [Link to saved dashboard screenshots]
- [Alert notification screenshots]
- [Metrics graphs during incident timeframe]

---

## Review and Approval

### Review Process
- **Technical Review**: [Senior engineer/architect review completed]
- **Process Review**: [SRE manager review of response procedures]
- **Business Review**: [Product owner review of impact assessment]

### Approvals
| Reviewer | Role | Date | Status |
|----------|------|------|--------|
| @reviewer1 | Senior SRE | YYYY-MM-DD | Approved/Pending |
| @reviewer2 | App Dev Lead | YYYY-MM-DD | Approved/Pending |
| @reviewer3 | Platform Manager | YYYY-MM-DD | Approved/Pending |

---

## Distribution List

### Required Recipients
- SRE Team (@sre-team)
- App Development Teams (@app-teams)
- Platform Engineering (@platform-engineering)
- Product Management (@product-management)

### Optional Recipients
- Executive Leadership (for P1 incidents)
- Customer Support Team
- Technical Writing Team

---

**Post-Mortem Meeting**: [Date/Time scheduled for team discussion]  
**Follow-up Review**: [Date scheduled to review action item progress]  
**Document Location**: [Link to this post-mortem in wiki/documentation system]

---

*This post-mortem follows the blameless post-mortem principles. The focus is on learning and improvement, not individual fault assignment.*

---

*End of Template - Copy everything above this line*

---

## Post-Mortem Best Practices

### Writing Guidelines
- **Be factual**: Stick to objective facts, avoid speculation
- **Include timestamps**: Use precise times for all timeline events
- **Provide evidence**: Link to logs, screenshots, metrics that support findings
- **Focus on systems**: Emphasize system failures, not individual mistakes
- **Be thorough**: Include all relevant details, even if they seem minor

### Common Mistakes to Avoid
- **Rushing the timeline**: Take time to get the sequence of events correct
- **Assigning blame**: Focus on process and system improvements, not fault
- **Skipping sections**: Complete all sections even if marking some as N/A
- **Vague action items**: Make actions specific, measurable, and time-bound
- **Missing follow-up**: Ensure action items have clear owners and deadlines

### Review Checklist
- [ ] All timeline events have precise timestamps
- [ ] Root cause analysis is technically accurate
- [ ] Action items are specific and assigned to owners
- [ ] Supporting evidence (logs, metrics) is included
- [ ] All reviewers have approved the document
- [ ] Team discussion meeting is scheduled

---

## Post-Mortem Archive

### Recent Post-Mortems
*Links to recent post-mortems will be added here*

### Quarterly Review
- **Q4 2024**: [Link to quarterly trends analysis]
- **Q3 2024**: [Link to quarterly trends analysis]

---

## Related Documentation

- [SRE Runbook: Degraded Response Times](./SRE-Runbook-Degraded-Response-Times)
- [App Dev Investigation Guide](./App-Dev-Investigation-Guide-Degraded-Response-Times)
- [Incident Response Process](./Incident-Response-Process)
- [SLO Definitions](./SLO-Definitions-API-Connect)
- [Escalation Procedures](./Escalation-Procedures)

---

## Contact Information

### Post-Mortem Process Questions
- **SRE Team Lead**: @sre-lead
- **Platform Manager**: @platform-manager

### Technical Questions
- **Senior SRE**: @senior-sre
- **Architecture Team**: @architecture-team

---

*Page maintained by: SRE Team | Last updated: 2024-08-12*