# Post-Mortem Process

## Overview

Post-mortems are a critical component of our SRE practice for IBM API Connect. They help us learn from incidents, improve our systems, and prevent future issues through blameless analysis and systematic improvement.

---

## When to Conduct a Post-Mortem

### Required Post-Mortems (SEV-1/SEV-2 equivalent)
- **P1 incidents** (SEV-1 equivalent - critical business impact)
- **P2 incidents** (SEV-2 equivalent - significant service degradation)
- **SLO breaches** that consume >10% of monthly error budget
- **Customer-impacting incidents** with external complaints
- **Multi-environment incidents** affecting multiple stages

### Optional Post-Mortems
- **Interesting near-misses** that could have been major incidents
- **Process failures** even if no service impact occurred
- **Learning opportunities** where significant insights were gained

---

## Post-Mortem Process (Aligned with PagerDuty Best Practices)

### 1. Owner Designation (Immediately after incident)
- **Incident Commander** designates post-mortem owner during or immediately after incident resolution
- **Owner notification** via Slack or direct communication
- **Owner responsibilities** include investigation, documentation, meeting coordination, and follow-up actions

### 2. Initial Setup (Within 24 hours)
- **Schedule post-mortem meeting**:
  - **P1 incidents**: Within 3 calendar days
  - **P2 incidents**: Within 5 business days
- **Create post-mortem document** using template below
- **Add to shared calendar**: "Incident Postmortem Meetings"

### 3. Investigation and Writing Phase (Days 1-5)
- **Timeline focus**: Start with detailed timeline as main priority
- **Data collection**: Gather logs, metrics, Slack conversations, call recordings
- **Evidence linking**: For each timeline item, include links to metrics, dashboards, logs
- **Impact analysis**: Customer impact, service degradation metrics, business impact
- **Root cause analysis**: What happened and why it happened
- **External communication**: Draft customer-facing message (if applicable)

### 4. Internal Review (24 hours before meeting)
- **Slack review**: Post link to post-mortem for team feedback on style and content
- **Pre-meeting refinement**: Address feedback to avoid wasted meeting time
- **Status update**: Change status from "Draft" to "In Review"

### 5. Post-Mortem Meeting (15-30 minutes)
- **Incident Commander facilitates** meeting
- **Owner presents** content and walks through findings
- **Team discussion** focuses on agreement on facts and follow-up actions
- **Status update**: Change to "Reviewed" after meeting

### 6. Follow-up Actions
- **Create action items** in JIRA/tracking system with severity tags
- **Focus on P0/P1 actions** that prevent recurrence or improve response
- **Internal communication**: Email stakeholders with results and learnings
- **Status update**: Change to "Closed" when all communications complete

---

## Owner Responsibilities (Aligned with PagerDuty Process)

As the designated post-mortem owner, you are responsible for:

### Before the Meeting
- [ ] **Schedule post-mortem meeting** on shared calendar within required timeframe
- [ ] **Investigate the incident** thoroughly, pulling in other teams as needed
- [ ] **Populate the post-mortem** with detailed timeline and analysis
- [ ] **Create follow-up tickets** in tracking system (creation only, not resolution)
- [ ] **Review content** with appropriate parties 24 hours before meeting
- [ ] **Post for internal review** in Slack for feedback on content and style

### During the Meeting
- [ ] **Present findings** and walk through the post-mortem content
- [ ] **Facilitate discussion** on timeline agreement and action items
- [ ] **Document any additional insights** or disagreements that arise

### After the Meeting
- [ ] **Finalize action items** with proper priority and ownership
- [ ] **Communicate results** internally via email to stakeholders
- [ ] **Update status** to "Reviewed" then "Closed" when complete

---

## Post-Mortem Status Tracking

| Status | Description | Next Actions |
|--------|-------------|--------------|
| **Draft** | Content is being actively worked on | Complete investigation and timeline |
| **In Review** | Ready for team review before meeting | Schedule and conduct post-mortem meeting |
| **Reviewed** | Meeting completed, content agreed upon | Create action items, send communications |
| **Closed** | All actions complete, no further work needed | Archive and track action item progress |

---

## Post-Mortem Meeting Guidelines

### Meeting Duration: 15-30 minutes
*Goal: Finalize agreement on facts, analysis, and recommended actions*

### Required Attendees
- **Incident Commander** (meeting facilitator)
- **Post-mortem Owner** (content presenter)
- **Service Owners** for affected systems
- **Key Engineers/Responders** involved in incident response
- **Engineering Manager** for impacted systems
- **Product Manager** for impacted systems

### Optional Attendees
- **Customer Liaison** (P1 incidents only)
- **SRE Manager** (multi-team incidents)
- **Architecture Team** (design-related incidents)

### Meeting Agenda
1. **Timeline Recap** (5-10 minutes)
   - Walk through incident timeline
   - Confirm everyone agrees on sequence of events
   - Clarify any unusual or complex aspects

2. **Detection Analysis** (5 minutes)
   - Could this have been caught earlier?
   - Did it show up in canary deployments?
   - Could tests or staging have detected it?
   - Were monitoring gaps identified?

3. **Customer Impact Review** (3-5 minutes)
   - Review customer feedback or complaints
   - Discuss business impact assessment
   - Validate impact metrics and measurements

4. **Action Items Discussion** (5-10 minutes)
   - Review proposed follow-up actions
   - Prioritize based on impact and effort
   - Assign owners and timelines
   - Focus on P0/P1 priority items only

---

---

## POST-MORTEM TEMPLATE

*Copy everything below this line for your post-mortem*

---

# Post-Mortem: [Incident Title]

**Date**: [YYYY-MM-DD]  
**Incident ID**: [INC-XXXXXX]  
**Status**: [Draft/In Review/Reviewed/Closed]  
**Owner**: [Post-mortem owner name/team]  
**Incident Commander**: [IC name during incident]  
**Severity**: [P1/P2 (SEV-1/SEV-2 equivalent)]

---

## Executive Summary

**One-line summary**: [Brief description of what happened and impact]

**Total Duration**: [Time from incident start to full resolution]  
**Detection Time**: [Time from incident start to detection]  
**Resolution Time**: [Time from detection to resolution]  
**Customer Impact**: [Description of customer/business impact]  
**Root Cause**: [Single sentence describing the fundamental cause]

---

## Incident Overview

### Services Affected
- **Primary**: [IBM API Connect services directly impacted]
- **Secondary**: [Downstream/dependent services affected]
- **Environments**: [LAB/INT/QA/PROD - list all affected]

### Impact Summary
- **SLO Breach**: [Yes/No - if yes, which SLOs and by how much]
- **Error Budget Consumed**: [X% of monthly budget]
- **API Response Time**: [Peak: XXXms vs target 200ms]
- **Error Rate**: [Peak: X.X% vs target <0.1%]
- **Affected Customers**: [Number or percentage if known]
- **Business Impact**: [Revenue/operations impact if applicable]

---

## Detailed Timeline

*Focus on key status changes and responder actions. Include data source links for each entry.*

| Time (EST) | Event | Data Source | Responder |
|------------|-------|-------------|-----------|
| HH:MM | **Incident begins**: [What actually started failing] | [Link to metrics/logs] | - |
| HH:MM | **Detection**: [How discovered - alert, user report, etc.] | [Link to Splunk alert] | SRE |
| HH:MM | **Initial response**: [First actions taken] | [Slack thread link] | @person |
| HH:MM | **Team notification**: [App dev team alerted] | [Email/Slack evidence] | SRE |
| HH:MM | **Investigation start**: [Team begins diagnosis] | [Slack/logs] | App Dev |
| HH:MM | **Hypothesis X**: [Initial theory investigated] | [Query/log link] | @person |
| HH:MM | **Key finding**: [Critical discovery made] | [Evidence link] | @person |
| HH:MM | **Escalation**: [If P1 declared or additional help] | [Notification evidence] | IC |
| HH:MM | **Root cause identified**: [Definitive cause found] | [Supporting evidence] | @person |
| HH:MM | **Fix implemented**: [Specific action taken] | [Deployment/change record] | @person |
| HH:MM | **Partial recovery**: [Some services restored] | [Metrics link] | - |
| HH:MM | **Full resolution**: [All services normal] | [Dashboard link] | @person |
| HH:MM | **Incident closed**: [Officially resolved] | [Ticket closure] | IC |

### Supporting Evidence Links
*For each timeline entry, include links to:*
- Splunk queries showing the issue
- Dynatrace dashboards with metrics
- Slack conversation threads
- Command outputs or deployment records
- Any third-party status pages referenced

## Detection Analysis

### How Was This Detected?
[Describe the detection method - alert, user report, monitoring dashboard, etc.]

### Could This Have Been Detected Earlier?
- **Canary Deployments**: [Did issue show up in canary? If not, why not?]
- **Testing Environment**: [Could staging/QA have caught this?]
- **Monitoring Gaps**: [What monitoring could have detected this sooner?]
- **Early Warning Signs**: [Were there indicators we missed?]

### Detection Effectiveness
- **Time to Detection**: [How long from incident start to detection]
- **Detection Method**: [Alert/Manual/User Report - was this optimal?]
- **Alert Quality**: [Was alert clear and actionable?]

---

## Root Cause Analysis

### What Happened
[Detailed technical explanation of the root cause with supporting evidence]

### Why It Happened  
[Contributing factors and conditions that led to this situation]

### Why It Wasn't Caught Earlier
[Analysis of process and system gaps that allowed this to reach production]

### How It Was Fixed
[Technical details of the resolution with links to changes made]

---

## Customer Impact Assessment

### Impact Metrics
```
Peak API response time: XXXms (target: <200ms)
Peak error rate: X.XX% (target: <0.1%)
Total affected requests: XXXXX
Duration of degradation: XX minutes
Affected customer percentage: XX%
```

### Customer Communication
- **External Message Required**: [Yes/No]
- **Customer Complaints**: [Number and summary of complaints received]
- **Support Ticket Volume**: [Increase in support requests during incident]

### External Message (if applicable)
*Draft message for customer communication:*

```
Subject: [Service] Incident - [Date] - Resolution Update

We experienced a service degradation with [specific service] between [time] and [time] EST on [date]. 

During this time, customers may have experienced [specific impact description]. The issue was caused by [high-level technical explanation] and has been fully resolved.

We have implemented [prevention measures] to prevent similar issues in the future.

We apologize for any inconvenience this may have caused.

[Company] Engineering Team
```

*Note: Avoid using "outage" unless it was a complete service failure. Use "incident" or "service degradation" instead.*

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

## Action Items

*Focus on P0/P1 priority items that prevent recurrence or improve incident response*

### Immediate Actions (P0 - Complete within 1 week)
| Action | Owner | Due Date | JIRA Ticket | Status |
|--------|-------|----------|-------------|---------|
| [Critical fix to prevent recurrence] | @owner | YYYY-MM-DD | [TICKET-123] | Open/In Progress/Done |
| [Essential monitoring improvement] | @owner | YYYY-MM-DD | [TICKET-124] | Open/In Progress/Done |

### High Priority Actions (P1 - Complete within 1 month)  
| Action | Owner | Due Date | JIRA Ticket | Status |
|--------|-------|----------|-------------|---------|
| [Important process improvement] | @owner | YYYY-MM-DD | [TICKET-125] | Open/In Progress/Done |
| [Significant tool enhancement] | @owner | YYYY-MM-DD | [TICKET-126] | Open/In Progress/Done |

### Follow-up Items for Discussion
*Items requiring further analysis before creating tickets*
- [Topic requiring team discussion before implementation]
- [Architectural decision needed before proceeding]

---

## Supporting Data and Evidence

### Commands and Queries Used During Investigation
```splunk
# Response time analysis during incident
index=apiconnect source="*api-gateway*" earliest=[incident_start] latest=[incident_end]
| bin _time span=5m
| stats p95(response_time) as p95_resp by _time

# Error rate correlation  
index=apiconnect source="*api-gateway*" earliest=[incident_start] latest=[incident_end]
| stats count as total, count(eval(status>=400)) as errors by _time
| eval error_rate=round((errors/total)*100,2)
```

### Key Log Excerpts
```
[2024-08-12 14:23:15] ERROR ApiGateway: Connection pool exhausted, rejecting requests
[2024-08-12 14:23:16] WARN ApiGateway: Response time degradation detected: 450ms average
[2024-08-12 14:25:30] INFO ApiGateway: Connection pool expanded, performance recovering
```

### Incident Call Recording
- **Recording Link**: [Link to recorded incident response call]
- **Key Participants**: [List of primary responders on call]
- **Duration**: [Length of incident response call]

### Related Dashboards and Metrics
- [Dynatrace Service Dashboard - Incident Timeframe](dashboard-link)
- [Splunk Performance Dashboard](dashboard-link)  
- [AWS CloudWatch Metrics](dashboard-link)
- [Error Rate Trending](dashboard-link)

---

## Internal Communication Record

### Slack Coordination
- **Primary Channel**: [#incident-response thread link]
- **Team Channels**: [Links to relevant team channel discussions]
- **Key Decisions**: [Important decisions made during incident response]

### Notification Timeline
| Time | Action | Recipients |
|------|--------|------------|
| HH:MM | Initial SRE alert | @sre-oncall |
| HH:MM | App team notification | @app-dev-team-x |
| HH:MM | Management notification | @engineering-manager |
| HH:MM | Customer support alert | @support-team |

---

## What Went Well

### Effective Response Elements
- [Things that worked well during incident response]
- [Good communication or decision-making examples]
- [Tools or procedures that helped resolution]
- [Team coordination successes]

### Process Strengths to Maintain
- [Capabilities or processes that should be preserved and built upon]
- [Response procedures that worked as designed]

---

## What Could Be Improved

### Response Process Issues
- [Communication gaps or delays]
- [Tool limitations that slowed response]
- [Process breakdowns or confusion]
- [Knowledge gaps that impacted resolution speed]

### System and Monitoring Gaps
- [Detection blind spots]
- [Alert threshold issues]  
- [Monitoring gaps that delayed identification]
- [Infrastructure limitations]

---

*This post-mortem follows the blameless post-mortem principles. The focus is on learning and improvement, not individual fault assignment.*

---

*End of Template - Copy everything above this line*

---

## Post-Mortem Best Practices (PagerDuty Aligned)

### Writing Guidelines
- **Timeline is priority**: Start with timeline as the main focus, add analysis later
- **Link everything**: Every timeline entry should have supporting evidence links
- **Be factual and blameless**: Focus on systems and processes, not individual actions
- **Include data sources**: Show how conclusions were reached with specific queries/tools
- **External message review**: Draft customer communication for review during meeting

### PagerDuty-Inspired Best Practices
- **Don't say "outage"**: Use "incident" or "service degradation" unless it was a total outage
- **Focus on customer impact**: Always include customer perspective and experience
- **Evidence-based**: Every claim should be backed by logs, metrics, or data
- **Actionable outcomes**: Create tickets for P0/P1 items, avoid creating too many low-priority actions
- **Internal learning**: Send email summary to stakeholders highlighting key learnings

### Common Mistakes to Avoid
- **Skipping timeline links**: Every timeline entry needs supporting evidence
- **Being too detailed**: Focus on key status changes and responder actions
- **Creating too many tickets**: Only create P0/P1 action items with clear ROI
- **Rushing the process**: Take time to get facts right before the meeting
- **Missing the meeting**: Post-mortem meetings are crucial for team alignment

### Review Checklist
- [ ] Timeline includes data source links for each entry
- [ ] Root cause analysis is technically accurate and evidence-based
- [ ] Customer impact is clearly quantified and described
- [ ] Action items are prioritized (P0/P1 only) with clear owners
- [ ] External message drafted (if customer communication needed)
- [ ] Internal Slack review completed 24 hours before meeting
- [ ] All required attendees invited to post-mortem meeting

---

## Post-Mortem Meeting Facilitation

### Incident Commander Responsibilities
- **Facilitate the meeting**: Keep discussion on track and focused
- **Manage time**: Ensure 15-30 minute duration is maintained
- **Guide discussion**: Use agenda to cover all required topics
- **Resolve disagreements**: Help team reach consensus on facts and actions

### Owner Responsibilities During Meeting
- **Present timeline**: Walk through incident chronology
- **Explain analysis**: Share root cause findings and evidence
- **Review action items**: Discuss proposed follow-up actions
- **Answer questions**: Clarify any aspects of the investigation

### Team Discussion Guidelines
- **Focus on facts**: Stick to what happened, not who was involved
- **Challenge assumptions**: Ensure analysis is sound and evidence-based
- **Prioritize actions**: Discuss ROI and impact of proposed improvements
- **Share perspectives**: Include different viewpoints from various team members failures, not individual mistakes
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

## Post-Mortem Archive and Tracking

### Completed Post-Mortems
*Recent post-mortems organized by quarter for trend analysis*

#### Q1 2025
- [Post-Mortem-2025-01-15-API-Gateway-Memory-Leak](./Post-Mortem-2025-01-15-API-Gateway-Memory-Leak) - P1 - 45 min
- [Post-Mortem-2025-02-03-Database-Connection-Pool](./Post-Mortem-2025-02-03-Database-Connection-Pool) - P2 - 25 min
- [Post-Mortem-2025-02-28-Load-Balancer-Configuration](./Post-Mortem-2025-02-28-Load-Balancer-Configuration) - P2 - 15 min

#### Q4 2024
- [Quarterly Trend Analysis Q4 2024](./Quarterly-Post-Mortem-Analysis-Q4-2024)

### Action Item Tracking
- [Post-Mortem Action Items Dashboard](https://your-jira.com/dashboard/postmortem-actions)
- [Monthly Action Item Review](./Monthly-Action-Item-Review)

---

## Quarterly Trend Analysis

### Key Metrics to Track
- **Total incidents requiring post-mortems** (P1/P2)
- **Average time to detection** across all incidents
- **Average time to resolution** by incident type
- **Most common root causes** (deployment, infrastructure, dependencies)
- **Action item completion rate** and effectiveness
- **Repeat incident patterns** indicating systemic issues

### Quarterly Review Process
1. **Analyze patterns**: Look for recurring themes across post-mortems
2. **Evaluate action items**: Assess completion and effectiveness of previous actions
3. **Update processes**: Refine post-mortem process based on learnings
4. **Share insights**: Present findings to engineering leadership
5. **Plan improvements**: Identify systemic improvements needed

---

## Communication Templates

### Internal Stakeholder Email Template
```
Subject: Post-Mortem Complete: [Incident Title] - Key Learnings

Hi Team,

We've completed the post-mortem for the [incident type] incident that occurred on [date]. Here are the key learnings:

**What Happened**: [One sentence summary]

**Root Cause**: [Brief technical explanation]

**Customer Impact**: [Duration and scope of impact]

**Key Actions**: 
- [Primary prevention action with owner]
- [Secondary improvement with owner]
- [Process enhancement with owner]

**Full Post-Mortem**: [Link to complete document]

The most important takeaway is [key lesson learned]. We've created [X] action items to prevent similar issues and improve our response process.

Thanks to everyone involved in the response and analysis.

[Your Name]
Post-Mortem Owner
```

### Slack Announcement Template
```
📋 **Post-Mortem Complete**: [Incident Title]

🗓️ **Incident Date**: [Date]
⏱️ **Duration**: [Total time]
🎯 **Root Cause**: [Brief explanation]

**Key Learnings**:
• [Learning 1]
• [Learning 2]
• [Learning 3]

**Action Items**: [X] created, focusing on [primary improvement area]

**Full Details**: [Link to post-mortem]

Thanks to @incident-responders for their work on this analysis! 🙏
```

---

## Integration with Existing Processes

### Runbook Updates
When post-mortems identify process improvements:
- Update [SRE Degraded Response Times Runbook](./SRE-Runbook-Degraded-Response-Times)
- Enhance [App Dev Investigation Guide](./App-Dev-Investigation-Guide-Degraded-Response-Times)
- Revise escalation procedures if communication gaps found

### Monitoring Enhancements
Post-mortem findings should drive:
- New Splunk alerts or threshold adjustments
- Dynatrace dashboard improvements
- SLO definition refinements
- Error budget policy updates

### Training and Knowledge Sharing
- Monthly engineering all-hands post-mortem highlight
- New team member onboarding includes recent post-mortem review
- Quarterly "lessons learned" sessions with key findings
- Runbook and documentation updates based on gaps identified

---

## Related Documentation

### Incident Response Process
- [SRE Runbook: Degraded Response Times](./SRE-Runbook-Degraded-Response-Times)
- [App Dev Investigation Guide](./App-Dev-Investigation-Guide-Degraded-Response-Times)
- [Incident Response Process Overview](./Incident-Response-Process)
- [Escalation Procedures and Contacts](./Escalation-Procedures)

### SRE Practice Documentation
- [SLO Definitions and Targets](./SLO-Definitions-API-Connect)
- [Error Budget Policies](./Error-Budget-Policies)
- [Monitoring and Alerting Standards](./Monitoring-Standards)
- [Change Management Process](./Change-Management-Process)

### Architecture and Systems
- [IBM API Connect Architecture Overview](./Architecture-API-Connect-Overview)
- [Infrastructure as Code Documentation](./Infrastructure-as-Code)
- [CI/CD Pipeline Documentation](./CICD-Pipeline-Documentation)

---

## External Resources

### Industry Best Practices
- [PagerDuty Post-Mortem Process](https://response.pagerduty.com/after/post_mortem_process/) - Original inspiration
- [Google SRE Workbook - Postmortem Culture](https://sre.google/workbook/postmortem-culture/)
- [Atlassian Incident Handbook](https://www.atlassian.com/incident-management/handbook)

### Training Resources
- [Blameless Post-Mortem Training](https://training.company.com/blameless-postmortems)
- [Incident Command Training](https://training.company.com/incident-command)

---

## Contact Information

### Post-Mortem Process Questions
- **SRE Team Lead**: @sre-lead - Process guidance and training
- **Platform Manager**: @platform-manager - Escalation and resource allocation
- **Senior SRE**: @senior-sre - Technical review and mentoring

### Technical and Tool Support
- **Splunk Admin**: @splunk-admin - Query help and dashboard creation
- **Dynatrace Admin**: @dynatrace-admin - Monitoring configuration
- **JIRA Admin**: @jira-admin - Ticket creation and tracking setup

### Executive Communication
- **Engineering Director**: @eng-director - High-impact incident communication
- **Product Leadership**: @product-leadership - Customer impact and business context

---

## Continuous Improvement

### Monthly Process Review
- Review post-mortem completion times and quality
- Analyze action item completion rates
- Gather feedback from post-mortem owners and participants
- Update templates and processes based on learnings

### Quarterly Effectiveness Assessment
- Measure impact of implemented action items
- Track reduction in similar incident types
- Evaluate detection and response time improvements
- Assess team satisfaction with post-mortem process

### Annual Process Evolution
- Benchmark against industry best practices
- Major template updates based on accumulated learnings
- Training program refinements
- Tool and integration improvements

---

*Page maintained by: SRE Team | Last updated: 2024-08-12*  
*Process version: 2.0 (PagerDuty-aligned) | Previous version: [Link to changelog]*

*This page follows the blameless post-mortem principles established by PagerDuty and adapted for IBM API Connect SRE practices.*