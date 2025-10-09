Incident Response Overview Page (7 Stories)
US-IR-WIKI-001: Create Incident Response Overview Wiki
As a new engineer joining the operations team,
I want a comprehensive incident response overview page on our wiki,
So that I can quickly understand our end-to-end incident response process before going on-call.
Acceptance Criteria:

Page created at github.com/the-hartford/cto_esb_apic_wiki/wiki/Incident-Response-Overview
Section 1: Introduction & Philosophy (blameless culture, user-centric focus, continuous improvement)
Section 2: End-to-End Process Flow (Mermaid diagram showing detection → postmortem)
Section 9: Quick Reference (severity & response time SLA table, tool links, emergency contacts)
Section 10: Getting Started (onboarding path for new on-call engineers)
Section 11: Related Documentation (links to all 6 IR wiki pages: Roles, On-Call Guide, Metrics, Observability Stack, Runbooks, Postmortem Process)
Wiki home page updated with Incident Response navigation section including:

Links to all IR pages
"New to on-call? Start here" pointer to On-Call Guide
Emergency resources (severity guide, quick reference, problem dashboard link)


Mobile-friendly formatting with clear headers
Page linked from wiki home page navigation sidebar
2 team members review and approve

Story Points: 13

US-IR-WIKI-002: Define Incident Severity Definitions
As an engineer detecting an anomaly,
I want clear, objective criteria for classifying incident severity,
So that I can make quick and correct severity assessments without second-guessing.
Acceptance Criteria:

Section 3 created in /wiki/Incident-Response-Overview
Severity table with three levels:

SEV-1 (Critical): Complete outage, data loss, security breach - Response: 15 min - Examples: All APIs down, database corruption, security breach
SEV-2 (Major): Significant degradation, subset affected - Response: 30 min - Examples: High latency >5s, elevated errors >5%, single API unavailable
SEV-3 (Minor): Minor issues, minimal impact - Response: Next business day - Examples: Single non-critical API slow, monitoring gaps


Customer impact descriptions for each severity
Response time SLAs by severity (moved to Quick Reference section)
Decision tree or flowchart for severity classification
Edge cases documented (performance degradation, partial outage, off-hours)
When to escalate severity during incidents
Real-world examples from API Connect and DataPower environment
Mobile-friendly table format

Story Points: 3

US-IR-WIKI-003: Define Incident Detection and Alerting Process
As an on-call engineer,
I want documentation on how our alerting system works and what alerts require action,
So that I can distinguish between actionable alerts and noise.
Acceptance Criteria:

Section 4 created in /wiki/Incident-Response-Overview
Monitoring stack overview table:

API Connect (EKS): Dynatrace (APM, tracing) + Splunk (logs)
DataPower (Legacy): MainView + DPMON + Splunk (logs)
Infrastructure: AWS CloudWatch + Kubernetes metrics + Dynatrace


Four golden signals explained:

Latency: API response times (p50, p95, p99)
Traffic: Requests per second, API calls by consumer
Errors: HTTP 5xx rates, failed transactions, policy failures
Saturation: CPU/memory usage, connection pools, disk space, rate limits


Alert sources documented (Dynatrace, Splunk, MainView, DPMON, CloudWatch, Kubernetes, PagerDuty)
When to declare an incident vs create a ticket (decision criteria)
Link to /wiki/Observability-Stack for detailed tool documentation
Link to /wiki/Runbooks for response procedures
Link to Problem Dashboard in Splunk

Story Points: 5

US-IR-WIKI-004: Define Incident Declaration Process
As a first responder,
I want step-by-step procedures for declaring an incident,
So that I can quickly mobilize response without missing critical steps.
Acceptance Criteria:

Section 5 created in /wiki/Incident-Response-Overview
Step-by-step declaration checklist:

Assess severity (30 seconds) - reference severity table
Create incident in tool (1 minute) - tool-specific instructions with screenshots
Create communication channel (1 minute) - Slack/Teams channel naming convention
Page appropriate teams (automatic) - who gets paged by severity table
Send initial notification (2 minutes) - template provided


Required incident fields explained:

Title (brief description)
Severity (SEV-1, SEV-2, SEV-3)
Affected Services (API Connect, DataPower, specific APIs)
Customer Impact (what users are experiencing)
Environment (Production, Staging, etc.)


Incident naming conventions with good/bad examples
Initial notification template (copy-paste ready)
Link to incident management tool
When NOT to declare an incident (guidance)

Story Points: 5

US-IR-WIKI-005: Define Incident Resolution Criteria
As an Incident Commander,
I want objective criteria for declaring incidents mitigated and resolved,
So that I don't prematurely close incidents or keep them open unnecessarily.
Acceptance Criteria:

Section 6 created in /wiki/Incident-Response-Overview
Mitigated definition:

Users can complete critical workflows
Service functional (may have degraded performance)
No data loss occurring
Immediate pain point addressed
Root cause may not be understood
Temporary fix may be in place


Resolved definition:

All SLIs within normal thresholds
All health checks passing
Error rates back to baseline
Latency within SLO targets
User flows tested and confirmed
Monitoring shows stability (1-2 hour observation period)
Root cause identified or understood


Verification checklist for resolved state (Dynatrace, Splunk, synthetic monitors, manual testing)
Examples for common incident types (rollback, failover, scaling)
When to reopen incidents (within 24 hours, same symptoms)
When to create new incident (>24 hours passed, different root cause)

Story Points: 3

US-IR-WIKI-006: Define Incident Escalation Process
As an Incident Commander,
I want clear escalation paths and criteria,
So that I know when and how to get additional help during incidents.
Acceptance Criteria:

Section 7 created in /wiki/Incident-Response-Overview
Escalation decision criteria:

Time-based (SEV-1 >30 min, SEV-2 >1 hour without progress)
Complexity-based (requires specialized expertise)
Customer impact-based (high-profile customers affected)


Technical escalation paths documented:

Service owners by component (API Connect, DataPower, specific APIs)
Architecture team (for design/platform decisions)
Platform team vs API Enablement team responsibilities
Vendor support (IBM API Connect, AWS Premium Support)


Management escalation thresholds:

Manager: SEV-1 immediate, SEV-2 after 1 hour
Director/VP: SEV-1 lasting >1 hour


Emergency contact information or link to contact directory
How to request additional responders
After-hours escalation considerations
When to involve SRM team (cross-team coordination)

Story Points: 5

US-IR-WIKI-007: Define Incident Change Management Process
As an Incident Commander,
I want clear guidelines for when and how to implement emergency changes during incidents,
So that I can balance urgency with proper change control.
Acceptance Criteria:

Section 8 created in /wiki/Incident-Response-Overview
Emergency change definition:

Changes made during active incidents to restore service
Bypasses normal change approval process
Requires post-incident review and documentation


Standard vs emergency change comparison table
Approval authority by severity and environment:

SEV-1 Production: Incident Commander decision, notify management
SEV-2 Production: Incident Commander + Manager approval
Non-production: Incident Commander decision


Required documentation during emergency changes:

What change was made (specific actions)
Why it was necessary (business justification)
Who approved and executed
When it was implemented (timestamp)


Rollback procedures and criteria:

When to roll back (change doesn't resolve issue, makes things worse)
How to execute rollback safely
Verification steps post-rollback


Post-incident change review process
Integration with existing change management tools/processes
Compliance and audit considerations

Story Points: 5

Incident Response Roles Page (5 Stories)
US-IR-WIKI-008: Define Incident Commander Role Guide
As someone assigned as Incident Commander,
I want comprehensive documentation of my role and responsibilities,
So that I can effectively lead incident response.
Acceptance Criteria:

Page created at github.com/the-hartford/cto_esb_apic_wiki/wiki/Incident-Response-Roles
Section 1: Role Overview created with:

When roles are assigned (SEV-1: all roles, SEV-2: IC + Ops Lead minimum, SEV-3: Ops Lead only)
Not every incident needs all roles
Role interaction diagram or description
How roles are assigned (automatic vs manual)


Section 2: Incident Commander role guide created with:

Role purpose: Overall coordination, decision-making, stakeholder management
What IC does: Assign roles, run incident bridge, communicate status, make escalation decisions, declare mitigated/resolved
What IC does NOT do: Hands-on technical work, detailed troubleshooting
Key responsibilities by incident phase (declaration, investigation, mitigation, resolution, postmortem assignment)
Decision-making authority and boundaries
Communication cadence by severity:

SEV-1: Status updates every 30 minutes
SEV-2: Status updates every 60 minutes


How to run incident bridges/calls effectively
Handoff procedures for incidents lasting >4 hours
Common scenarios and decision frameworks
Checklist from declaration to closure


Communication templates included:

Initial notification (incident declared)
Status update (investigation in progress)
Mitigated notification
Resolved notification


Examples of good vs poor IC execution
3 experienced ICs review and approve

Story Points: 13

US-IR-WIKI-009: Define Communications Lead & Scribe Role Guide
As a Communications Lead & Scribe during an incident,
I want clear documentation of my combined responsibilities,
So that I can effectively manage stakeholder communications and document the incident timeline.
Acceptance Criteria:

Section 3 created in /wiki/Incident-Response-Roles
Combined role explanation:

Primary responsibility: Communications
Secondary responsibility: Documentation
When to split roles (large SEV-1 incidents with >5 responders)
Prioritization: Communication takes precedence during active response


Communications Lead responsibilities:

Stakeholder identification by severity:

SEV-1: Internal teams, executives, customer support, potentially customers/partners
SEV-2: Internal teams, customer support, management after 1 hour
SEV-3: Minimal communication, internal team only


Communication channels (Slack, email, status page, Teams)
Update frequency by severity (aligned with IC communication cadence)
Status page update procedures (when to update, what to include, approval needed)
How to communicate uncertainty without speculation
Approval requirements for external communication


Scribe responsibilities:

What to document:

Timeline of events with UTC timestamps
Actions taken and their outcomes
Key decisions and rationale
System state observations
People involved and their roles
Communications sent


Where to document (incident tool, shared doc)
Level of detail needed (high during active response, can be cleaned up later)
Timestamp best practices
Handoff to postmortem author
Example timeline format


Communication templates (copy-paste ready):

Initial notification: "🚨 INCIDENT DECLARED - SEV-X - [brief description] - Impact: [user impact] - Next update in [timeframe]"
Status update: "📊 STATUS UPDATE - INC-[ID] - [time elapsed] - Current status: [investigation/mitigation] - Impact: [unchanged/improving/worsening] - Next steps: [actions] - Next update: [timeframe]"
Mitigated: "✅ SERVICE RESTORED - INC-[ID] - Service is functional, monitoring for stability - Investigation continuing - Root cause: [if known]"
Resolved: "✅ INCIDENT RESOLVED - INC-[ID] - Total duration: [time] - All systems normal - Root cause: [summary] - Postmortem to follow"
Executive summary template (for leadership)
Customer communication template (if applicable)


When to escalate communication needs to IC
Link to incident management tool for documentation
2 team members review and approve

Story Points: 8

US-IR-WIKI-010: Define API Enablement Team Role Guide
As a member of the API Enablement team,
I want clear documentation of my responsibilities during incidents,
So that I know when and how to engage during API-related incidents.
Acceptance Criteria:

Section 4 created in /wiki/Incident-Response-Roles
Team scope defined:

API product ownership and support
Specific API functionality and business logic
API consumer relationships and contracts
API policy configuration


When team is engaged:

API-specific issues (single API or API product affected)
Policy execution failures
Consumer-specific impacts (authentication, authorization, rate limiting)
API contract or integration issues
API-level performance problems (not platform-wide)


Responsibilities during incidents:

Provide API product expertise and context
Assist with root cause analysis for API-specific issues
Coordinate with API consumers (partners, internal teams)
Validate API functionality and business logic
Recommend API-specific remediations (policy changes, configuration updates)
Support testing of API fixes


Tools and access requirements:

API Connect management console
API analytics and monitoring dashboards (Dynatrace, Splunk)
Consumer management tools
API documentation and contracts


Escalation criteria:

When to escalate to Architecture team (design issues, major API changes needed)
When to escalate to Product team (business impact decisions, customer communications)
When to involve Platform team (infrastructure or platform-level issues)


Example scenarios:

Scenario 1: Single API returning high error rates → API Enablement investigates policy and backend integration
Scenario 2: Consumer authentication failures → API Enablement reviews consumer credentials and security policies
Scenario 3: Rate limit exceeded causing consumer impact → API Enablement evaluates rate limit policies and consumer usage patterns
Scenario 4: API latency issues isolated to specific endpoint → API Enablement analyzes endpoint logic and backend dependencies


On-call rotation responsibilities (if applicable)
Relationship to Platform team clarified (API Enablement = API logic, Platform = infrastructure)
2 API Enablement team members review and approve

Story Points: 5

US-IR-WIKI-011: Define Platform Team Role Guide
As a member of the Platform team,
I want documentation of my responsibilities during incidents,
So that I know when and how to engage for platform-level issues.
Acceptance Criteria:

Section 5 created in /wiki/Incident-Response-Roles
Team scope defined:

EKS infrastructure and Kubernetes platform
API Connect platform components (gateway, manager, portal, analytics)
DataPower appliances and infrastructure
Supporting infrastructure (databases, load balancers, networking)
Platform-wide performance and availability


When team is engaged:

Platform failures (API Connect components unavailable)
Infrastructure issues (EKS nodes, networking, storage)
Cross-API impacts (multiple APIs affected simultaneously)
DataPower appliance issues
Capacity and scaling issues
Database or data layer problems
Platform-wide performance degradation


Responsibilities during incidents:

Infrastructure diagnostics and remediation
Platform component troubleshooting (API Connect, DataPower)
Capacity and scaling decisions
Kubernetes/EKS administration and recovery
Coordinate with API Enablement for API-specific context
Infrastructure change execution (scaling, failover, restarts)
Vendor engagement (AWS support, IBM support)


Tools and access requirements:

AWS Console (EKS, EC2, RDS, CloudWatch)
Kubernetes CLI and dashboards
API Connect platform administration
DataPower administration console
MainView and DPMON (DataPower monitoring)
Infrastructure monitoring (Dynatrace, Splunk, CloudWatch)


Escalation paths:

AWS Premium Support (infrastructure issues beyond team capability)
IBM API Connect Support (platform bugs, configuration issues)
Architecture team (design decisions, major platform changes)


Example scenarios:

Scenario 1: API Connect gateway pods crashing → Platform team investigates pod health, resource constraints, restarts pods
Scenario 2: EKS node failure causing pod disruptions → Platform team drains and replaces unhealthy node
Scenario 3: DataPower cluster failover needed → Platform team executes failover procedure, validates cluster health
Scenario 4: Database connection pool exhaustion → Platform team scales database, adjusts connection pool settings
Scenario 5: Multiple APIs experiencing high latency → Platform team investigates infrastructure saturation, scales resources


On-call rotation responsibilities
Relationship to API Enablement team clarified (Platform = infrastructure, API Enablement = API logic)
2 Platform team members review and approve

Story Points: 5

US-IR-WIKI-012: Define Cross-Team Incident Response Process
As an Incident Commander managing complex incidents,
I want documented procedures for coordinating across API Enablement and Platform teams,
So that multi-team incidents are handled efficiently without confusion.
Acceptance Criteria:

Section 6 created in /wiki/Incident-Response-Roles
When cross-team coordination is needed:

Issues spanning API and infrastructure (requires both team expertise)
Incidents affecting multiple teams' areas of responsibility
SRM team involvement required (business-critical services, high customer impact)
Complex root cause requiring multiple perspectives


Communication structure for multi-team incidents:

Single incident channel for all responders
Single Incident Commander (not multiple ICs)
Multiple Operations Leads (one per team: Platform Ops Lead, API Enablement Ops Lead)
Clear role boundaries and coordination


How multiple Operations Leads coordinate:

Each Ops Lead focuses on their team's domain
Regular sync points during investigation (every 15-30 min)
Share findings and collaborate on root cause analysis
Coordinate remediation actions that span teams
Avoid duplicating effort or working at cross-purposes


When SRM team is involved:

SRM engagement criteria (business-critical services, regulatory implications, high-profile customers)
SRM role during incidents (business impact assessment, customer communication coordination, executive updates)
How SRM interfaces with technical response (through IC, not directly with Ops Leads)


Service ownership matrix:

Platform team: EKS infrastructure, API Connect platform components, DataPower appliances, databases, networking
API Enablement team: API products, API policies, consumer relationships, API-specific configurations
Shared ownership: Performance issues (both teams), capacity planning (both teams), deployments (coordinated)


Handoff procedures between teams:

When Platform identifies API-specific root cause → handoff to API Enablement
When API Enablement identifies infrastructure root cause → handoff to Platform
Documentation during handoff (findings, actions taken, next steps)


Escalation paths for cross-team decisions:

Technical conflicts or disagreements → escalate to Architecture team
Resource prioritization conflicts → escalate to Engineering Manager/Director
Customer impact decisions → escalate to Product/SRM


Sub-incident creation for parallel work:

When to create sub-incidents (large incidents with multiple workstreams)
How to track sub-incidents and their relationship to parent incident
Coordination between sub-incident responders


Example cross-team scenarios:

Scenario 1: Platform identifies EKS node issue causing pod restarts, API Enablement handles customer communication about affected APIs
Scenario 2: API Enablement identifies problematic API consuming excessive resources, Platform scales infrastructure while API team investigates API logic
Scenario 3: DataPower failure requires Platform failover execution and API Enablement validation of API traffic routing


Link back to Escalation Procedures in Incident-Response-Overview
2 team members (one from each team) review and approve

Story Points: 8

On-Call Guide Page (2 Stories)
US-IR-WIKI-013: Define On-Call Process & Expectations
As an on-call engineer,
I want clear documentation of my on-call responsibilities and what's expected,
So that I know how to fulfill my on-call duties and understand the philosophy behind sustainable on-call practices.
Acceptance Criteria:

Page created at github.com/the-hartford/cto_esb_apic_wiki/wiki/On-Call-Guide
Section 1: On-Call Philosophy created with:

Sustainable on-call practices (rotation length, break periods, respite time)
Work-life balance principles (on-call is a team responsibility, not individual burden)
Team support and psychological safety (asking for help is expected and encouraged)
Continuous improvement of on-call experience (reducing toil, improving runbooks, alert tuning)
Health and wellness considerations (don't respond if impaired, take breaks during long incidents, escalate if overwhelmed)


Section 2: On-Call Process & Expectations created with:

On-call schedule and rotation:

Rotation length (weekly, bi-weekly, etc.)
Primary and backup on-call
Follow-the-sun coverage (if applicable)


Response time SLAs by severity:

SEV-1: Acknowledge within 15 minutes, begin response immediately
SEV-2: Acknowledge within 30 minutes, begin response within 1 hour
SEV-3: Respond during next business day


What to do when receiving an alert:

Step 1: Acknowledge alert within SLA
Step 2: Assess severity using severity definitions (link to Overview page)
Step 3: Declare incident if needed (link to declaration process)
Step 4: Begin investigation or escalate if unsure


Escalation when unsure:

Don't hesitate to escalate or ask for help
It's better to involve others early than struggle alone
Backup on-call and team leads are there to support


Handoff procedures to next on-call:

Synchronous handoff (call or meeting preferred)
Document any ongoing issues or context
Share lessons learned or gotchas from shift


After-hours expectations:

Response required for SEV-1 and SEV-2
SEV-3 can wait until next business day
Comp time or time-off policies for after-hours work


How to swap shifts:

Find coverage and notify team
Update on-call schedule in PagerDuty/tool
Document swap in team channel


Compensation and time-off policies:

On-call stipend or additional pay
Comp time after incident response
Time off after particularly difficult on-call shifts


When you can't fulfill on-call duties:

Illness, family emergency, travel issues
Notify backup immediately
Update schedule and team communication




Link to /wiki/Incident-Response-Overview for severity definitions
Link to incident management tool and on-call schedule
VPN and remote access requirements documented
2 experienced on-call engineers review and approve

Story Points: 8

US-IR-WIKI-014: Define On-Call Onboarding Process & Checklist
As a new engineer preparing for on-call,
I want a comprehensive onboarding checklist,
So that I'm fully prepared before my first on-call shift.
Acceptance Criteria:

Section 3 created in /wiki/On-Call-Guide
Onboarding timeline documented: 2-4 weeks before first solo on-call shift
Prerequisites section:

System architecture understanding (completed architecture overview training)
Service ownership knowledge (understand which services we own and support)
Completed incident response training (read Overview, Roles, On-Call Guide)
Familiarity with common failure modes and troubleshooting approaches


Access verification checklist:

✅ Dynatrace (API Connect monitoring and distributed tracing)
✅ Splunk (log search and analysis)
✅ MainView (DataPower middleware monitoring)
✅ DPMON (DataPower appliance metrics)
✅ AWS Console (EKS, EC2, RDS, CloudWatch)
✅ Kubernetes CLI and dashboard access
✅ API Connect management console
✅ Incident management tool (PagerDuty/ServiceNow)
✅ Communication channels (Slack/Teams incident channels)
✅ VPN and remote access configured and tested
✅ PagerDuty/alerting app installed and notification preferences set


Required training modules:

Incident Response Process (this wiki)
Monitoring tools overview (Dynatrace, Splunk, MainView, DPMON)
Common runbook walkthrough (top 5 most frequent incidents)
Service architecture deep dive


Shadow shift requirements:

Observe 2-3 incidents (as shadow, not primary responder)
Shadow experienced on-call engineer for at least one full shift
Participate in incident but let experienced engineer lead
Ask questions and take notes
Review incidents afterward with mentor


Practice exercises recommended:

Participate in game day exercise (simulated incident)
Walk through common troubleshooting scenarios with team
Practice using runbooks in non-production environment
Simulate paging and incident declaration in test environment


Runbook familiarization:

Read top 10 most frequently used runbooks
Understand where runbooks are located and how to search
Practice executing at least 3 runbooks in non-prod


Knowledge validation:

Can explain severity classifications
Can navigate to key monitoring dashboards
Can execute incident declaration process
Knows when and how to escalate
Understands role responsibilities


Sign-off process:

Checklist completion verified by manager or mentor
Final review meeting with experienced on-call engineer
Manager approval required before first solo on-call shift
Backup on-call assigned for first 1-2 shifts (extra safety net)


Links to resources:

Link to /wiki/Incident-Response-Overview
Link to /wiki/Incident-Response-Roles
Link to /wiki/Observability-Stack
Link to /wiki/Runbooks
Link to on-call schedule (PagerDuty)
Link to training materials and architecture docs


Checklist available as copy-paste template or downloadable format for tracking
2 team members (including at least one who recently completed onboarding) review and approve

Story Points: 5

Incident Metrics Page (2 Stories)
US-IR-WIKI-015: Define Incident Metrics & KPIs
As an SRE lead or engineering manager,
I want documentation of our incident metrics, KPIs, and operational dashboards,
So that I can track our incident response effectiveness and identify improvement areas.
Acceptance Criteria:

Page created at github.com/the-hartford/cto_esb_apic_wiki/wiki/Incident-Metrics-and-Improvement
Section 1: Key Metrics & KPIs created with:

MTTD (Mean Time To Detect):

Definition: Time from when issue begins to when alert fires or incident is detected
Target: <5 minutes for critical issues
How calculated: Incident start time (from logs/monitoring) - Alert timestamp
Why it matters: Faster detection = faster response and less customer impact


MTTA (Mean Time To Acknowledge):

Definition: Time from alert firing to on-call engineer acknowledging
Target: SEV-1 <15 min, SEV-2 <30 min
How calculated: Alert timestamp - Acknowledgment timestamp
Why it matters: Measures on-call responsiveness


MTTR (Mean Time To Recovery):

Definition: Time from incident detection to service fully restored
Target: SEV-1 <2 hours, SEV-2 <4 hours
How calculated: Incident declared timestamp - Resolved timestamp
Why it matters: Primary measure of incident response effectiveness


Incident Frequency:

By service (API Connect vs DataPower)
By severity (SEV-1, SEV-2, SEV-3 counts)
By root cause category (deployment, infrastructure, configuration, code bug, external dependency)
Trend over time (improving or worsening)


Error Budget Consumption Rate:

Percentage of monthly error budget consumed by incidents
Burn rate trend (accelerating or steady)
Per-service error budget tracking


On-Call Load:

Pages per on-call shift (average and distribution)
Incidents per week/month
After-hours pages (measuring disruption)
On-call burnout indicators


Postmortem Completion Rate:

Percentage of SEV-1 incidents with completed postmortem
Percentage of SEV-2 incidents with completed postmortem
Time to postmortem completion (target: <5 business days)


Action Item Completion Rate:

Percentage of postmortem action items completed
Time-to-completion for action items (target: <30 days for critical items)
Overdue action items count




Section 2: Dashboards & Reporting created with:

SLO Dashboard (Dynatrace):

Purpose: Monitor service health and error budget status
What it shows: SLO compliance %, error budget remaining, burn rate trends
Who uses it: Product managers, SRE leads, engineering leadership
When to use: Weekly reviews, PI planning, reliability discussions
Access link: [Dynatrace SLO Dashboard URL]


Problem Dashboard (Splunk):

Purpose: Real-time view of active system issues
What it shows: Active incidents, error rate trends, top failing APIs/services, recent deployments, alert status
Who uses it: On-call engineers, incident responders, NOC
When to use: During incident response, shift handoffs, daily health checks
Access link: [Splunk Problem Dashboard URL]


ClickOps Dashboard (Splunk):

Purpose: Track manual operations and identify automation opportunities
What it shows: Manual changes (AWS Console logins, manual configs, emergency access), frequency of ClickOps by user/type, automation candidates
Who uses it: SRE leads, automation engineers, engineering managers
When to use: Monthly operational reviews, automation planning, toil reduction initiatives
Access link: [Splunk ClickOps Dashboard URL]


Incident Dashboard (ServiceNow):

Purpose: Incident process compliance and historical analysis
What it shows: Incident SLA breaches (MTTA, MTTR), incident task SLA breaches, current open incidents, historical incident trends, potentially related incidents, open PRBs (Problem Records)
Who uses it: Incident managers, SRE leads, process improvement team
When to use: Weekly incident reviews, quarterly incident retrospectives, process improvement planning
Access link: [ServiceNow Incident Dashboard URL]




Target values or benchmarks documented for each metric
Review cadence defined:

Daily: Problem Dashboard health check


RetryCSContinue
Weekly: Incident metrics review, action item progress
Monthly: Trend analysis, ClickOps review, automation planning
Quarterly: Deep dive retrospectives, process improvements
How metrics inform decision-making:

High MTTR → invest in better runbooks and automation
High incident frequency for specific service → targeted reliability improvements
Error budget exhaustion → feature freeze, focus on reliability
High on-call load → alert tuning, automation, additional staffing
Low postmortem completion → process enforcement, dedicated time allocation


Dashboard screenshots or example views included for each
2 team members review and approve

Story Points: 8

US-IR-WIKI-016: Define Error Budget Reconciliation Process
As a Product Manager or SRE,
I want a documented process for calculating incident impact on error budgets and our continuous improvement practices,
So that I can make informed decisions about feature velocity vs reliability investments.
Acceptance Criteria:

Section 3: Error Budget Management created in /wiki/Incident-Metrics-and-Improvement
Error budget concept explained:

Definition: Allowable amount of unreliability before violating SLO
Formula: Error Budget = 100% - SLO target
Example: 99.9% SLO = 0.1% error budget = 43.2 minutes downtime per month
Purpose: Balance innovation velocity with reliability


How incidents consume error budget:

Calculation methodology: (Incident duration × scope) / total time
Full outage example: 30 min complete outage = 30 min of monthly budget consumed
Partial outage example: 2 hour incident affecting 25% of users = 30 min equivalent budget consumed
Error rate based: 1% error rate for 1 hour = proportional budget consumption


Reconciliation frequency and process:

Weekly review: Check error budget status for all critical services
Monthly reconciliation: Calculate total budget consumed, remaining budget
Who performs: SRE + Product Manager collaboration
Where documented: Incident Dashboard (ServiceNow), SLO Dashboard (Dynatrace)


Per-service error budget tracking:

Each critical API/service has separate error budget
Track budget consumption by service over rolling 30-day window
Identify services consistently consuming high error budget
Prioritize reliability work based on budget consumption patterns


Policy actions at different error budget levels:

Budget healthy (>25% remaining): Normal feature release velocity, standard deployment cadence
Budget at risk (10-25% remaining): Increase code review rigor, enhanced testing, limit deployment frequency, weekly check-ins
Budget exhausted (<10% remaining): Feature freeze (except critical fixes), focus on reliability improvements, daily incident reviews, mandatory postmortems for all incidents, no deployments without engineering director approval


Integration with postmortem process:

Every postmortem documents error budget impact
Link to /wiki/Postmortem-Process for postmortem procedures
Error budget consumption tracked as action item metric
Large budget consumers trigger immediate improvement initiatives


Error budget policy communication:

How policy is communicated to engineering teams
Escalation path when approaching budget exhaustion
How to request policy exceptions (rare, requires executive approval)


Dashboard or spreadsheet template for tracking (link to tools)
Example calculations with real incident scenarios
Section 4: Continuous Improvement Process created with:

Weekly incident reviews:

All incidents from past week reviewed
Quick triage: themes, patterns, immediate action items
Attendees: SRE team, incident responders
Duration: 30-60 minutes
Output: Action items assigned, trends identified


Monthly trend analysis:

Review incident metrics (MTTR, frequency, root causes)
Identify recurring issues or patterns
ClickOps review and automation candidates
Error budget consumption by service
On-call load and alert fatigue assessment
Attendees: SRE leads, engineering managers
Duration: 1-2 hours
Output: Monthly trends report, prioritized improvement backlog


Quarterly deep dives:

In-depth analysis of major incidents from quarter
Thematic postmortem (common root causes across incidents)
Effectiveness of previous quarter's action items
Error budget policy effectiveness review
Process improvements identified
Attendees: Engineering team, product managers, leadership
Duration: 2-3 hours
Output: Quarterly incident report, reliability roadmap updates


Annual retrospective:

Year-over-year metrics comparison
Incident trends analysis (improving or worsening)
Celebrate wins and improvements
Major reliability investments planned
On-call experience feedback and improvements
Attendees: Full engineering organization
Duration: Half-day workshop
Output: Annual reliability report, next year's reliability goals


How insights drive roadmap priorities:

High-frequency incident types → automation projects
Recurring root causes → architectural improvements
Error budget exhaustion → reliability sprints
High MTTR for specific issues → runbook improvements, training
Alert fatigue → alert tuning initiatives
ClickOps patterns → automation and self-service tooling




Link to /wiki/Postmortem-Process for learning from individual incidents
Link to action item tracking system (Rally, Jira)
Meeting cadence and attendee list documented
Templates for weekly/monthly/quarterly reviews
2 team members review and approve

Story Points: 8

Observability Stack Page (1 Story)
US-IR-WIKI-017: Define Incident Response Tools and Techniques
As an engineer investigating an incident,
I want updated documentation of our monitoring tools with any gaps filled,
So that I know which tool to use for different diagnostic scenarios and can navigate between them effectively.
Acceptance Criteria:

Existing page at github.com/the-hartford/cto_esb_apic_wiki/wiki/Observability-Stack reviewed and updated
Ensure all 6 sections are complete and current:

Section 1: Monitoring Stack Overview (tool comparison, when to use each tool, coverage by platform)
Section 2: Dynatrace (API Connect/EKS monitoring, distributed tracing, dashboards, navigation)
Section 3: Splunk (log collection, search techniques, common queries)
Section 4: MainView (DataPower middleware monitoring, key views)
Section 5: DPMON (DataPower appliance metrics, performance monitoring)
Section 6: Tool Integration & Correlation (how tools work together, correlation IDs)


Add missing content identified during review:

Any new dashboards created since last update
Updated access URLs or authentication methods
New monitoring capabilities or features
Common troubleshooting scenarios not yet documented
Tool integration patterns between Dynatrace and Splunk


Add link to /wiki/Incident-Response-Overview in Section 6 (four golden signals context)
Ensure consistency with incident response process:

Tools mentioned in detection/alerting align with this page
Investigation techniques reference specific tool capabilities
Runbooks reference correct tool navigation paths


Tool comparison matrix includes:

Which tool for latency investigation (Dynatrace service flow, Splunk transaction logs)
Which tool for error spike analysis (Dynatrace error analysis, Splunk error log aggregation)
Which tool for capacity issues (Dynatrace infrastructure monitoring, CloudWatch metrics)
Which tool for DataPower issues (MainView for transactions, DPMON for appliance health)


Common troubleshooting scenarios with tool workflows:

Scenario 1: High API latency → Start with Dynatrace service flow, drill into slow component, check Splunk for errors
Scenario 2: Error rate spike → Check Dynatrace for error patterns, search Splunk logs with correlation IDs, identify root cause
Scenario 3: DataPower transaction failures → MainView for transaction visibility, DPMON for appliance health, Splunk for detailed logs
Scenario 4: Pod crashes → Kubernetes events, Dynatrace infrastructure monitoring, Splunk for pod logs


Screenshots updated if UI has changed
Dead links removed or updated
2 engineers (one familiar with each stack) review and approve updates

Story Points: 5

Runbooks Page (1 Story)
US-IR-WIKI-018: Define Incident Runbook Utilization Process
As an operations engineer responding to an incident,
I want a centralized runbook page with standards and links to all existing runbooks,
So that I can quickly find and execute the correct remediation procedures.
Acceptance Criteria:

Page created at github.com/the-hartford/cto_esb_apic_wiki/wiki/Runbooks (if doesn't exist) or existing page updated
Section 1: Runbook Standards & Template created with:

Runbook template structure:

Title: Clear, descriptive name
Problem symptoms: What alerts or issues trigger use of this runbook
Prerequisites: Required access, tools, knowledge
Diagnostic steps: How to confirm the problem (with expected outputs)
Remediation actions: Step-by-step procedures (with commands, screenshots)
Verification steps: How to confirm issue is resolved
Rollback procedures: How to undo changes if remediation fails
Escalation criteria: When to escalate and to whom
Related runbooks: Links to related procedures
Last updated: Date and author


Writing guidelines for clear runbooks:

Use imperative mood ("Check the logs" not "You should check the logs")
Include exact commands with placeholders (e.g., kubectl get pods -n <namespace>)
Show expected outputs vs error outputs
Include screenshots for UI-based procedures
Test runbooks in non-prod before publishing
Keep runbooks focused (one problem, one runbook)


Maintenance process:

Quarterly review of all runbooks (scheduled process)
Update after each incident if runbook was insufficient
Version control recommended (wiki history or git)
Runbook ownership assigned (team or individual)
Deprecation process for obsolete runbooks


When to create new runbooks:

Problem occurs multiple times (2-3 incidents of same type)
Complex procedure requiring multiple steps
Procedure requires specialized knowledge
High-risk operations (deployments, failovers)
After postmortems identify missing runbook coverage




Section 2: API Connect Runbooks created with:

List of existing API Connect runbooks with links:

Restart API Connect Gateway Pods
Rollback API Connect Deployment
Scale API Connect Pods (Gateway, Manager, Portal)
Emergency Certificate Renewal
API Policy Troubleshooting
API Connect Database Connection Issues
Cache Invalidation Procedure
Rate Limit Configuration Update
Consumer Authentication Issues
API Connect Manager Unresponsive


Each runbook link includes:

Brief description (one sentence)
Common symptoms/when to use
Estimated execution time
Link to actual runbook (in runbook repository, wiki, or documentation system)


Placeholder for "Coming Soon" runbooks if any are identified but not yet created


Section 3: DataPower Runbooks created with:

List of existing DataPower runbooks with links:

DataPower Failover Procedure (HA cluster)
Restart DataPower Service/Domain
DataPower Configuration Rollback
DataPower Firmware Upgrade Issues
Crypto/SSL Certificate Troubleshooting
DataPower Performance Tuning
Transaction Processing Backup/Congestion
DataPower Memory Issues
DataPower Connection Pool Exhaustion
DataPower Log Analysis


Same format as API Connect section (description, symptoms, time, link)


Section 4: Infrastructure Runbooks created with:

List of existing infrastructure runbooks with links:

Scale EKS Node Group
Investigate EKS Node NotReady State
PostgreSQL Storage Expansion (API Connect databases)
Network Troubleshooting (connectivity issues)
AWS Load Balancer Issues
DNS Resolution Problems
EKS Control Plane Issues
Persistent Volume Issues
Container Image Pull Failures
VPC/Network Security Group Issues


Same format as previous sections


Section 5: Runbook Index created with:

Searchable/filterable table of all runbooks:

Columns: Runbook Name | Service/Component | Common Symptoms | Last Updated | Owner | Link
Sortable by name, component, or date
Filterable by service (API Connect, DataPower, Infrastructure, Database, Networking)


Tag-based organization (optional):

Tags: #deployment, #scaling, #failover, #performance, #security, #networking
Allows searching by tag


Most frequently used runbooks highlighted (based on incident data)
Recently updated runbooks flagged


Instructions on how to create new runbooks:

Where to create (wiki page, documentation system, git repository)
PR/review process required
Template to use (link to Section 1)
Who can approve (team lead, subject matter expert)
How to request new runbook (create ticket, post in team channel)


Instructions on runbook maintenance:

Quarterly review process documented
How to suggest updates (edit wiki, submit PR, create ticket)
How to report outdated runbooks
Who maintains runbook index (SRE team, rotating ownership)


Mobile-friendly formatting (runbooks accessed during on-call)
Links from other pages validated:

/wiki/Incident-Response-Overview section 4 links here
/wiki/Incident-Response-Roles references runbook usage
Alert descriptions can link to specific runbooks


3 engineers review (covering API Connect, DataPower, Infrastructure) and approve

Story Points: 13

Postmortem Page (2 Stories)
US-IR-WIKI-019: Define Post Mortem Process
As an engineer,
I want clarity on when and how to write postmortems,
So that I understand my postmortem obligations and can contribute to organizational learning.
Acceptance Criteria:

Existing page at github.com/the-hartford/cto_esb_apic_wiki/wiki/Postmortem-Process confirmed to include:

When postmortems are required (always SEV-1, usually SEV-2, optional SEV-3)
Postmortem template with all required sections
Timeline for completion (draft within 5 business days, review within 10 days)
Who writes postmortem (typically Incident Commander or Operations Lead)
Review and approval process
Blameless culture principles
Publication and archiving procedures


Verify postmortem template includes:

Executive summary (2-3 sentences)
What happened (timeline of events)
Customer impact (quantified: users affected, duration, error rate)
Root cause analysis (five whys technique)
What went well (positive aspects of response)
What went wrong (areas for improvement)
Action items (SMART: Specific, Measurable, Assigned, Realistic, Time-bound)
Lessons learned (broader insights for organization)


Blameless culture section emphasizes:

Focus on systems, not individuals
Avoid blame-oriented language (detect and flag phrases like "X failed to...")
Ask "how did the system allow this?" not "who caused this?"
Psychological safety for honest discussion
Incidents are learning opportunities


Review meeting facilitation guidance:

Schedule postmortem review within 10 business days
Invite incident participants, stakeholders, and interested engineers
Review draft postmortem collaboratively
Encourage contributions and alternative perspectives
Focus discussion on improvements, not blame


Where to publish postmortems:

Internal wiki or documentation system
Accessible to all engineers
Searchable by service, root cause, date
Link from incident ticket


If any gaps found, update page to include missing content
Ensure page is complete and current for reference by engineers
2 team members review and approve

Story Points: 3

US-IR-WIKI-020: Define Post Mortem Action Item Process
As a postmortem author,
I want clear guidance on creating, tracking, and completing postmortem action items,
So that incidents lead to concrete improvements and links to related incident response documentation.
Acceptance Criteria:

Existing page at github.com/the-hartford/cto_esb_apic_wiki/wiki/Postmortem-Process updated with:

Related Documentation section added (if not already present):

Link to /wiki/Incident-Response-Overview (for process context, severity definitions, incident flow)
Link to /wiki/Incident-Metrics-and-Improvement (for error budget reconciliation, action item tracking metrics, continuous improvement process)


Action item section verified/enhanced to include:

Characteristics of good action items (SMART criteria):

Specific: Clear, concrete action (not vague like "improve monitoring")
Measurable: Observable completion criteria
Assigned: Named owner who is accountable
Realistic: Achievable with available resources and time
Time-bound: Due date specified (typically 2-4 weeks for critical, 1-2 months for non-critical)


Examples of well-written vs poorly-written action items:

❌ Poor: "Improve API monitoring" (too vague, no owner, no deadline)
✅ Good: "Add Dynatrace alert for Orders API p95 latency >2s - Owner: Jane Smith - Due: 2 weeks"
❌ Poor: "Fix the deployment process" (too broad, unclear scope)
✅ Good: "Implement canary deployment for API gateway with 10% traffic rollout - Owner: Platform Team - Due: 4 weeks"


Prioritization framework (impact vs effort):

High impact + Low effort = Do first (quick wins)
High impact + High effort = Plan and resource properly (major improvements)
Low impact + Low effort = Do when time allows (nice to haves)
Low impact + High effort = Question if worth doing (avoid if possible)
Prioritize based on: error budget impact, incident frequency, customer pain, blast radius


How to assign owners and get commitment:

Assign owners during postmortem review meeting
Confirm owner acceptance (don't assign without asking)
Owner should be person with capability to execute, not just manager
For team-based work, assign specific team lead as accountable owner
Document owner name explicitly in action item


Where to track action items:

Rally (preferred) - create user stories or tasks
Jira or other project tracking system
Link action items from postmortem document to tracking system tickets
Action items visible in team backlog and sprint planning


Follow-up cadence:

Weekly reviews: Check action item progress in team standup or incident review
Monthly reports: Report on action item completion rates, overdue items
Postmortem owner responsibilities: Follow up with action item owners, escalate blockers


Escalation for overdue items:

1 week overdue: Reminder to owner, offer help with blockers
2 weeks overdue: Escalate to team lead or manager
1 month overdue: Engineering manager escalation, reprioritize or reassign


When action items can be closed:

Definition of done: Action is fully implemented, tested, and deployed to production
Verification: Confirm action addresses root cause (won't prevent all future incidents, but reduces likelihood or impact)
Documentation: Related runbooks, docs, or monitoring updated
Demo or evidence of completion (screenshot, dashboard, PR link)


Metrics tracked:

Action item completion rate (% of items completed within due date)
Time-to-completion (average days from creation to closure)
Overdue action items count (aging report)
Action items per postmortem (trend over time)
Effectiveness: Did action items prevent incident recurrence?


Integration with sprint planning:

Action items added to team backlog
High-priority items pulled into current or next sprint
Critical action items (SEV-1 postmortems) may interrupt sprint
Action item work counts toward velocity
Balance feature work with reliability improvements


Link to /wiki/Incident-Metrics-and-Improvement for:

Action item completion tracking dashboard
How action items feed into continuous improvement process
Error budget impact driving action item prioritization






Ensure error budget impact section references Error Budget Management in Metrics page
Template or example provided for tracking action items
2 team members review and approve updates

Story Points: 5

Supporting Story (1 Story)
US-IR-WIKI-021: Explore Teams Channel Integrations for Incident Response
As an incident responder,
I want to explore and document Microsoft Teams integrations for incident management,
So that incident information flows seamlessly into our collaboration platform and we can recommend which integrations to implement.
Acceptance Criteria:

Research Microsoft Teams integration options for incident response:

Automatic channel creation for new incidents
Alert notifications posted to Teams channels (from Dynatrace, Splunk, PagerDuty)
Status updates from incident management tool → Teams
Bot commands for incident actions (declare, update status, assign roles)
Integration with PagerDuty, ServiceNow, or other incident management tools


Proof of concept (POC) for 2-3 promising integrations:

POC 1: Incident declaration creates dedicated Teams channel automatically
POC 2: Dynatrace problem notifications post to Teams channel
POC 3: Splunk alerts post to Teams incident channel
Document POC setup, configuration, and testing results


Document for each integration explored:

What it does (functionality and features)
Configuration requirements (permissions, API keys, webhook setup)
Limitations or constraints (rate limits, data format restrictions, costs)
User experience (screenshots, workflow examples)
Security considerations (authentication, data sensitivity)


Cost analysis:

Licensing requirements (any premium Teams features needed?)
Third-party integration costs (connectors, middleware, SaaS tools)
Development/maintenance effort required


Recommendations documented:

Which integrations to implement (prioritized list)
Which integrations to avoid (and why)
Implementation effort estimates
Expected benefits (reduced context switching, faster response, better visibility)


Decision captured:

Recommended integrations with business justification
Next steps for implementation (if approved)
Where to track implementation work (Rally stories)


Findings documented in wiki:

Create documentation page: /wiki/Teams-Integrations-for-Incident-Response OR
Add section to /wiki/Incident-Response-Tools-and-Integrations
Include POC results, configuration guides, recommendations


Presentation to team:

Demo POC integrations to team
Gather feedback and preferences
Discuss implementation priorities
Document team decision


2 team members review research and recommendations

Story Points: 8

📊 Story Summary
Total Stories: 21
Total Story Points: 141
By Epic:
Incident Response Overview: 7 stories, 44 points
Incident Response Roles: 5 stories, 39 points
On-Call Guide: 2 stories, 13 points
Incident Metrics: 2 stories, 16 points
Observability Stack: 1 story, 5 points
Runbooks: 1 story, 13 points
Postmortem: 2 stories, 8 points
Supporting: 1 story, 8 points
Recommended PI Breakdown:
PI 1 - Foundation (44-50 points):

US-IR-WIKI-001: Create Incident Response Overview Wiki (13)
US-IR-WIKI-002: Define Incident Severity Definitions (3)
US-IR-WIKI-003: Define Incident Detection and Alerting (5)
US-IR-WIKI-004: Define Incident Declaration (5)
US-IR-WIKI-005: Define Incident Resolution Criteria (3)
US-IR-WIKI-008: Define Incident Commander Role Guide (13)
US-IR-WIKI-013: Define On-Call Process & Expectations (8)

PI 2 - Enhancement (45-50 points):

US-IR-WIKI-006: Define Incident Escalation (5)
US-IR-WIKI-007: Define Emergency Change Management (5)
US-IR-WIKI-009: Define Communications Lead & Scribe (8)
US-IR-WIKI-010: Define API Enablement Team Role (5)
US-IR-WIKI-011: Define Platform Team Role (5)
US-IR-WIKI-012: Define Cross-Team Coordination (8)
US-IR-WIKI-014: Define On-Call Onboarding (5)
US-IR-WIKI-015: Define Incident Metrics & KPIs (8)

PI 3 - Completion (45-50 points):

US-IR-WIKI-016: Define Error Budget Reconciliation (8)
US-IR-WIKI-017: Define Incident Response Tools (5)
US-IR-WIKI-018: Define Runbook Utilization (13)
US-IR-WIKI-019: Define Post Mortem Process (3)
US-IR-WIKI-020: Define Post Mortem Action Items (5)
US-IR-WIKI-021: Explore Teams Integrations (8)
