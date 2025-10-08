# ServiceNow Incident Tasks

## Overview

Incident Tasks in ServiceNow provide a structured workflow for managing complex incidents requiring multiple team members or sequential action items. Tasks ensure accountability, enable parallel work streams, and provide audit trails for post-incident reviews.

---

## When to Use Incident Tasks

### **Use Tasks For:**
- **Multi-team coordination** - Requires input from Network, Database, Security, or other teams
- **Complex incidents** - Multiple investigation paths or remediation steps
- **P1/P2 incidents** - Critical incidents requiring structured response
- **Incidents requiring approval** - Change implementation during incident resolution
- **Parallel workstreams** - Multiple SREs working different aspects simultaneously

### **Don't Use Tasks For:**
- Simple, single-person fixes (use work notes instead)
- P3/P4 incidents with straightforward resolution
- Routine operational tasks (use Change Requests or RITMs)

---

## Task Lifecycle

'''
Created → Assigned → Work In Progress → Closed Complete/Incomplete
'''

| State | Description | Actions Required |
|-------|-------------|------------------|
| **Created** | Task generated, awaiting assignment | Assignment group reviews and assigns |
| **Assigned** | Individual assigned, not started | Assignee acknowledges and begins work |
| **Work in Progress** | Active work occurring | Regular updates in task notes |
| **Closed Complete** | Task finished successfully | Document outcome and findings |
| **Closed Incomplete** | Task cannot be completed | Document blockers and escalate |

---

## Creating Incident Tasks

### **Automatic Task Creation**
Tasks are auto-generated for P1 incidents via Dynatrace integration:
- **Initial Assessment Task** - Assigned to on-call SRE
- **Communication Task** - Assigned to Incident Commander (if escalated)

### **Manual Task Creation**

1. **Navigate to Incident Record**
   - Open incident from queue or search

2. **Create Task**
   - Related Links → Create Task
   - OR Configuration → Related Lists → Tasks → New

3. **Required Fields**
   '''
   Short Description: [Specific, actionable task title]
   Assignment Group: [Target team - API Connect SRE, DBA, Network, etc.]
   Priority: [Inherit from parent incident or override]
   Description: [Detailed context, expected outcome, dependencies]
   Parent Incident: [Auto-populated]
   '''

4. **Optional Fields**
   - **Assigned To** - Specific individual (leave blank for group assignment)
   - **Due Date** - Critical for time-sensitive tasks
   - **Configuration Item** - Link affected CI if known

### **Task Naming Best Practices**

**Good Examples:**
- "Investigate API Gateway pod restarts in PROD namespace"
- "Validate RDS connection pool settings for apic-db-prod"
- "Review Splunk logs for authentication failures 14:00-14:30 UTC"
- "Implement rate limiting on /api/v1/orders endpoint"

**Poor Examples:**
- "Check logs" (too vague)
- "Fix the issue" (not actionable)
- "Help needed" (no context)

---

## Working with Tasks

### **As Task Assignee**

1. **Acknowledge Assignment**
   - Change state to "Work in Progress"
   - Add initial work note with ETA

2. **Document Progress**
   - Update work notes every 15-30 minutes for P1/P2
   - Include findings, actions taken, blockers
   - Use technical detail - this is for SRE consumption

3. **Escalate if Blocked**
   - Update task with blocker details
   - Notify Incident Commander via work note mention
   - Do not leave task idle without explanation

4. **Close Task**
   - **Closed Complete**: Document resolution and evidence
   - **Closed Incomplete**: Explain why task cannot be completed, provide recommendations

### **Task Update Template**

'''
[HH:MM UTC] - [Your Name]
Status: [In Progress/Blocked/Completed]
Actions Taken:
- [Action 1]
- [Action 2]

Findings:
- [Finding 1]
- [Finding 2]

Next Steps:
- [Step 1]
- [Step 2]

Blockers: [None / List blockers]
ETA: [Completion estimate]
'''

---

## Task Assignment Groups

| Group | Responsibilities | SLA |
|-------|------------------|-----|
| **API Connect SRE** | APIC platform, K8s, EKS, AWS infrastructure | 15 min (P1) |
| **Database Team** | RDS, ElastiCache, connection issues | 30 min (P1) |
| **Network Team** | Load balancers, DNS, connectivity | 30 min (P1) |
| **Security Team** | Certificate issues, authentication, authorization | 1 hour (P1) |
| **Application Team** | API logic, custom code issues | 2 hours (P1) |

---

## Incident Commander Task Orchestration

### **Task Creation Strategy**

**Sequential Tasks** - Use when tasks have dependencies
'''
Task 1: Identify root cause → Task 2: Implement fix → Task 3: Validate resolution
'''

**Parallel Tasks** - Use for independent investigation paths
'''
Task 1: Check Gateway logs (SRE)
Task 2: Review DB performance (DBA)
Task 3: Analyze network traffic (Network)
All running simultaneously
'''

### **Monitoring Task Progress**

1. **Tasks List View**
   - Incident → Related Lists → Tasks
   - Shows all tasks, states, assignees

2. **Key Indicators**
   - Tasks "Assigned" > 15 minutes (P1) → Follow up
   - Tasks "Work in Progress" with no updates → Check in
   - Tasks "Closed Incomplete" → Reassess approach

3. **Communication**
   - Update Microsoft Teams incident channel with task status
   - Mention task assignees for urgent follow-up
   - Summarize task outcomes in incident work notes

---

## Integration with Dynatrace

### **Automated Task Creation**

Dynatrace problem notifications trigger ServiceNow incidents with pre-configured tasks:

| Dynatrace Problem Type | Auto-Generated Tasks |
|------------------------|----------------------|
| **Service Unavailable** | 1. Validate pod health<br>2. Check recent deployments<br>3. Review error logs |
| **Response Time Degradation** | 1. Analyze APM traces<br>2. Check DB query performance<br>3. Review resource utilization |
| **High Error Rate** | 1. Identify error patterns in Splunk<br>2. Check API Gateway configs<br>3. Validate backend services |

### **Task Enrichment**

Tasks include Dynatrace problem links in description:
- Root cause analysis link
- Service flow visualization
- Related events timeline

---

## Best Practices

### **Do:**
- ✅ Create tasks proactively for known workstreams
- ✅ Keep task scope narrow and specific
- ✅ Update tasks frequently with technical detail
- ✅ Close tasks promptly with clear outcomes
- ✅ Use tasks to preserve institutional knowledge
- ✅ Link relevant runbooks in task descriptions

### **Don't:**
- ❌ Create tasks for every minor action
- ❌ Leave tasks assigned without updates
- ❌ Use vague descriptions or generic titles
- ❌ Close tasks without documenting findings
- ❌ Forget to update parent incident when all tasks complete

---

## Reporting and Metrics

### **Task Metrics for Post-Incident Review**

- **Task Creation Time** - How quickly was work decomposed?
- **Time to Assignment** - Were groups responsive?
- **Task Completion Time** - Identify bottlenecks
- **Tasks Closed Incomplete** - Scope issues or blockers?
- **Task Update Frequency** - Communication effectiveness

### **Access Task Reports**

ServiceNow → Reports → Incident Management → Task Performance
- Filter by assignment group, date range, incident priority

---

## Common Task Scenarios

### **Scenario 1: Multi-Environment Issue**

Create environment-specific tasks:
- Task 1: Investigate PROD API Gateway (Priority: Critical)
- Task 2: Compare QA configuration (Priority: High)
- Task 3: Review recent PROD changes (Priority: High)

### **Scenario 2: External Vendor Involvement**

- Task 1: Engage IBM Support (SRE opens case)
- Task 2: Provide diagnostics to vendor (SRE gathers data)
- Task 3: Implement vendor recommendation (SRE executes)

### **Scenario 3: Emergency Change Required**

- Task 1: Draft emergency change request
- Task 2: Obtain CAB approval (includes approval workflow)
- Task 3: Execute change
- Task 4: Validate change effectiveness

---

## Quick Reference

### **Task State Shortcuts**

'''
Created → Assigned: Right-click task → Assign to me
Assigned → WIP: Edit task → State = Work in Progress
WIP → Closed: Edit task → State = Closed Complete → Closure notes
'''

### **Useful Filters**

'''
My Open Tasks: Assigned to = [me] AND State != Closed
Team Tasks: Assignment Group = API Connect SRE AND State != Closed
Overdue Tasks: Due Date < Today AND State != Closed
P1 Tasks: Parent Incident.Priority = 1 - Critical
'''

### **Related Documentation**

- [Main Runbook](link-to-main-runbook) - Overview of operational procedures
- [Incident Response Process](link-to-incident-response) - Full incident management workflow
- [ServiceNow User Guide](link-to-snow-guide) - Platform navigation and features
- [Dynatrace Integration](link-to-dynatrace) - Alert-to-task automation details

---

## Support

**Questions about Incident Tasks?**
- Slack: #api-connect-sre
- Email: api-connect-sre@company.com
- ServiceNow: Contact SRE team via assignment

**ServiceNow Platform Issues?**
- IT Service Desk: [link-to-service-desk]
- Phone: xxx-xxx-xxxx