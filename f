All 18 User Stories - Concise Version

Story 1: Perform Critical User Journey Path Mapping
User Story:
As an SRE, I want to map critical user journeys through IBM API Connect, so that I can define meaningful SLIs based on actual user experience.
Acceptance Criteria:

Identify 3-5 critical journeys: API invocation, API publishing, Portal onboarding, Analytics ingestion, Troubleshooting
For each journey document: user steps, components involved, dependencies, failure modes, success criteria
Create architecture diagrams showing component flows
Map to infrastructure: EKS Gateway, DataPower, Manager, Portal, Analytics, PostgreSQL
Identify single points of failure
Document current failure rates from incident history
Prioritize by user impact × frequency
Deliverable: Journey map document with diagrams


Story 2: Review Existing Dynatrace Alerts & Thresholds
User Story:
As an SRE, I want to audit existing Dynatrace alerts, so that I can identify noise, duplicates, and non-actionable alerts.
Acceptance Criteria:

Create alert inventory with 30-day firing history: name, component, trigger, severity, frequency
Calculate metrics: alerts per shift, true positive rate, MTTA, MTTR
Categorize: symptom vs cause-based, actionable vs informational, high-confidence vs noisy
Identify: top 10 noisiest alerts, top 5 lowest actionability, duplicates, missing runbooks
Document overlap with dpmon/Mainview alerts
Survey on-call team (80% response rate): trusted alerts, ignored alerts, improvement priorities
Deliverable: Alert audit spreadsheet


Story 3: Create Alert Fatigue Reduction Plan
User Story:
As an SRE, I want a plan to reduce alert fatigue, so that on-call receives fewer, actionable alerts.
Acceptance Criteria:

Define targets: <5 pages per shift, >80% actionable rate, <10% false positives
Identify alerts for deletion (minimum 20): noise, duplicates, informational
Identify alerts for consolidation: multiple alerts for same issue
Design multi-burn-rate alerting: fast burn (page), medium burn (business hours), slow burn (ticket)
Define aggregation rules: alert once per condition, not per event
Require runbooks for all retained critical alerts
Create 6-8 week phased rollout timeline
Document DataPower alert consolidation across dpmon/Mainview/Dynatrace
Deliverable: Approved reduction plan with timeline


Story 4: Define SLIs & SLOs for API Gateway (Runtime)
User Story:
As an SRE, I want to define SLIs and SLOs for API Gateway, so that we have measurable reliability targets and error budgets.
Acceptance Criteria:

Define availability SLI: (successful requests / total requests) × 100, success = 2xx/4xx, failure = 5xx
Define latency SLI: P95 and P99 response time for successful requests
Define uptime SLI: synthetic health check success rate (every 60s)
Set SLO targets: 99.5% availability (216 min/month), P95 <500ms, P99 <2s, 99.9% synthetic uptime
Document measurement: Dynatrace APM for EKS, Splunk for DataPower, 30-day rolling window
Calculate error budget: 0.5% = 216 min/month, ~7 min/day
Define burn rate thresholds: fast (>2% in 1hr), medium (>5% in 6hr), slow (>10% in 3d)
Document rationale for targets and trade-offs
Deliverable: SLI/SLO definition with queries and error budgets


Story 5: Define SLIs & SLOs for API Manager (Publishing Pipeline)
User Story:
As an SRE, I want to define SLIs and SLOs for API Manager, so that we ensure reliable API publishing for developers.
Acceptance Criteria:

Define publish success SLI: (successful publishes / total attempts) × 100
Define publish latency SLI: P95 time from request to Gateway availability
Define Gateway sync SLI: (successful syncs / total sync attempts) × 100
Set SLO targets: 99.0% publish success, P95 <60s latency, 99.5% sync success
Document measurement: API Manager audit logs in Splunk
Calculate error budgets for publishing operations
Define success vs failure: user errors don't count, system errors count
Document developer impact of violations
Deliverable: SLI/SLO definition with queries and error budgets


Story 6: Define SLIs & SLOs for Developer Portal
User Story:
As an SRE, I want to define SLIs and SLOs for Developer Portal, so that we ensure reliable self-service for API consumers.
Acceptance Criteria:

Define availability SLI: (successful page loads / total requests) × 100
Define signup success SLI: account creation and API key generation success rate
Define latency SLI: P95 page load time
Set SLO targets: 99.0% availability, 95.0% signup success, P95 <3s load time
Document measurement: Dynatrace RUM or Synthetic, Portal logs in Splunk
Calculate error budgets: 1% availability = 7.2 hrs/month
Define critical vs non-critical functions: only critical count toward SLO
Document business impact of Portal downtime
Deliverable: SLI/SLO definition with queries and error budgets


Story 7: Define SLIs & SLOs for Analytics Service
User Story:
As an SRE, I want to define SLIs and SLOs for Analytics, so that we ensure timely and complete API usage data.
Acceptance Criteria:

Define freshness SLI: P95 time from transaction to data availability in Analytics
Define completeness SLI: (transactions in Analytics / transactions in Gateway logs) × 100
Define query performance SLI: P95 dashboard load and query execution time
Set SLO targets: P95 <5 min freshness, 99.9% completeness, P95 <10s query time
Document measurement: compare Gateway logs to Analytics DB, reconciliation job
Calculate error budgets: 0.1% completeness = strict for billing/compliance
Document why Analytics matters: billing, compliance, troubleshooting, business decisions
Document impact of failures on business and operations
Deliverable: SLI/SLO definition with queries and error budgets


Story 8: Rightsize Dynatrace Alerts After Review
User Story:
As an SRE, I want to implement alert improvements, so that we eliminate noise and focus on user impact.
Acceptance Criteria:

Delete minimum 10 low-value alerts identified in audit
Implement aggregation: alert once per condition, not per event
Adjust thresholds: symptom-based over cause-based (e.g., "error rate >1% for 5+ min" vs "any 5xx")
Add/update runbooks for all critical alerts (minimum 15 runbooks)
Configure alert suppression during deployment windows
Update ServiceNow deduplication for related alerts
Validate in non-prod first with failure simulation
Measure improvement: 40% reduction in pages per shift within 2 weeks
Deliverable: Updated alert config and improvement metrics


Story 9: Implement SLO-Based Alerting (Multi-Burn-Rate Alerts)
User Story:
As an SRE, I want multi-burn-rate alerting for SLO violations, so that we get fast notification while reducing false positives.
Acceptance Criteria:

Design strategy: fast burn (>2% budget in 1hr, page), medium burn (>5% in 6hr, business hours page/ticket), slow burn (>10% in 3d, ticket)
Implement fast burn alerts for critical SLOs: Gateway availability, latency, Analytics completeness
Implement slow burn alerts with forecast: "budget exhausted in X days"
Replace threshold alerts with burn rate alerts where applicable
Configure alert metadata: affected SLO, compliance %, budget remaining, burn rate, dashboard link
Implement suppression: no dupes if multiple thresholds trigger
Test with historical incident data
Create SLO violation response runbooks
Rollout phases: shadow mode → slow burn → fast burn → deprecate old alerts
Deliverable: SLO-based alerts operational, runbooks created, team trained


Story 10: Implement Synthetic Monitoring in Production
User Story:
As an SRE, I want synthetic monitoring for critical journeys, so that we detect issues before users are impacted.
Acceptance Criteria:

Gateway health check: GET /health every 60s, page if 3 consecutive failures
OAuth token generation: POST /oauth/token every 5min, page if 2 consecutive failures
Critical API e2e: realistic transaction every 5min, page if 3 failures OR latency >2s
Portal availability: home page load every 5min, ticket if 5 consecutive failures
Manager console: login page every 10min, business hours ticket only
DataPower legacy APIs: every 3min, page if 2 consecutive failures
Configure multi-region probes if applicable (minimum 2 locations)
Alert routing: critical → page, degraded → ticket, Portal/Manager → business hours only
Validate in non-prod first
Create Synthetic Monitoring dashboard: success rates, current status, latency trends
Deliverable: All monitors operational, dashboard created, alerts configured


Story 11: Create SLO Dashboard in Dynatrace
User Story:
As an SRE, I want a unified SLO dashboard, so that we can visualize error budget and communicate reliability status.
Acceptance Criteria:

Executive section: overall health, compliance %, error budget remaining, burn rate, forecast days to exhaustion
Service sections: Gateway, Manager, Portal, Analytics with current SLIs, targets, compliance status, error budget %
Historical trends: 30-day and 90-day compliance graphs, error budget consumption over time
Incident correlation: markers on timeline showing incidents and SLO impact, links to ServiceNow
Drill-down: click widgets to navigate to detailed traces/metrics, Splunk queries, runbooks
Color coding: green (>25% budget), yellow (<20% budget), red (violating)
Forecast widget: time to exhaustion at current burn rate
Mobile-friendly responsive view
Present to team and iterate on feedback
Deliverable: Production dashboard accessible to team and stakeholders


Story 12: Implement Unified Observability Correlation (Trace/Correlation IDs)
User Story:
As an SRE, I want correlation IDs across all components and tools, so that I can trace requests end-to-end and reduce MTTR.
Acceptance Criteria:

Implement X-Request-ID propagation: Gateway → Manager → Analytics → Backend → Portal
Gateway generates unique trace ID if not provided by client (UUID format)
Log trace IDs in all Splunk logs (structured JSON with "trace_id" field)
Configure Dynatrace to capture X-Request-ID and enable search
Add ServiceNow custom fields: "Dynatrace Trace URL", "Splunk Query Link"
Automate linking: alerts auto-populate ServiceNow with Dynatrace/Splunk URLs
Create investigation runbook: get trace ID → search Dynatrace → search Splunk → correlate
Validate e2e: test request appears in Gateway logs, backend logs, Dynatrace traces, Analytics
Test during simulated incident: verify <30s to pivot from alert → trace → logs
Handle DataPower: configure MPGW to log X-Request-ID, document dpmon workaround if logs not in Splunk
Train team on using correlation IDs
Deliverable: Correlation operational, automated ServiceNow linking, runbook, team trained


Story 13: Create Documentation for Log Coverage
User Story:
As an SRE, I want a log coverage audit, so that I can identify and prioritize gaps for faster incident resolution.
Acceptance Criteria:

Create matrix: Component | Access Logs | Error Logs | App Logs | Destination | Retention | Structured | Gaps
Audit: Gateway (EKS), Gateway (DataPower), Manager, Portal, Analytics, PostgreSQL
Prioritize gaps by component criticality, incident frequency, compliance needs
Identify top 3-5 critical gaps with impact, remediation approach, effort estimate, cost
Document DataPower gap: likely not in Splunk, syslog forwarding or dpmon export needed
Recommend standardization: JSON structured logging with trace IDs
Document retention recommendations: critical (90d), supporting (30-60d), infrastructure (30d)
Estimate effort and Splunk license impact for gap closure
Create prioritized improvement backlog
Deliverable: 1-2 page summary with gap analysis and recommendations


Story 14: Create Documentation for Legacy DataPower Observability Stack
User Story:
As an SRE, I want documentation of DataPower monitoring (dpmon, Mainview), so that new team members understand the legacy tooling.
Acceptance Criteria:

Architecture diagram: DataPower → dpmon → Mainview → ServiceNow → Teams
Document tool capabilities: dpmon (real-time metrics, crypto, firmware, MPGW), Mainview (trends, capacity)
Document data retention: dpmon (real-time + X history), Mainview (X months/years), appliance logs (7d)
Create metrics reference table: Metric | Tool | Threshold | Meaning | Runbook Link
Document alert routing and severity mapping
Document gaps: no distributed tracing, logs not in Splunk, alert overlap, no correlation IDs, no synthetic monitoring
Document access methods and permissions
Common troubleshooting workflows: high CPU, crypto failures, connection pool exhaustion, transaction errors
If applicable: migration timeline and observability deprecation plan
Timebox to 2-3 days max, focus on operational essentials
Deliverable: 2-page quick reference with diagram, metrics table, troubleshooting workflows


Story 15: Create Alert for PostgreSQL Storage Availability
User Story:
As an SRE, I want multi-layered storage alerting, so that we detect user impact first and have lead time for capacity expansion.
Acceptance Criteria:

Layer 1 - Symptom: "Database Query Latency Degraded" if P95 >500ms for 10+ min → Page
Layer 2 - Predictive: "Storage <20% Free" with forecast "90% full in X days" → Ticket
Layer 3 - Critical: "Storage <10% Free" → Page + executive escalation
Create capacity dashboard: current usage, 30-day growth, forecast exhaustion date, storage vs latency correlation
Document runbooks: symptom response, predictive response, critical response
If AWS RDS/EBS: document auto-scaling config, set max limits, alert when approaching max
Document capacity planning process: weekly review, monthly forecast, quarterly planning
Test alerts in non-prod: fill disk to trigger thresholds, verify firing and routing
Implement monitoring for related metrics: disk I/O, checkpoint duration, WAL size, temp files, vacuum status
Deliverable: Three-layer alerting operational, capacity dashboard, runbooks, automation documented


Story 16: Create AWS Config Rule Implementation Plan
User Story:
As an SRE, I want a plan for AWS Config rules, so that we prevent misconfigurations that cause outages.
Acceptance Criteria:

Define reliability rules: rds-multi-az, elb-cross-zone-lb, eks-supported-version, ec2-in-vpc, ebs-snapshots
Define security rules: encrypted-volumes, vpc-sg-authorized-ports, iam-password-policy, s3-no-public-read, kms-cmk-not-deleted
Define APIC custom rules: resource tagging (Environment, Component, Owner), network isolation, resource limits
Design remediation workflow: Config violation → SNS → Lambda → ServiceNow ticket
Categorize by approach: auto-remediate (tags, logging), manual review (security groups, networking), alert only (multi-AZ, upgrades)
Define phases: Phase 1 audit mode (weeks 1-2), Phase 2 alerts (weeks 3-4), Phase 3 auto-remediation (weeks 5-6), Phase 4 ongoing review
Document remediation procedures for each rule
Estimate costs: Config service, Lambda execution, engineering effort (2-3 weeks total)
Create compliance dashboard concept: compliance %, by rule, by service, trends, top violators
Document exceptions process and integration with existing workflows
Define success metrics: >95% compliance in 6 months, <5 days MTTR for violations
Deliverable: Approved plan with rules, remediation procedures, timeline, cost estimates


Story 17: Implement AWS Config Rules
User Story:
As an SRE, I want to deploy AWS Config rules, so that we auto-detect and remediate configuration drift.
Acceptance Criteria:

Deploy rules using IaC (Terraform/CloudFormation), version controlled, code reviewed
Configure Config service: enable in all regions, S3 for snapshots, IAM roles, all resource types
Deploy managed rules: all from implementation plan
Deploy custom rules: tagging enforcement, APIC-specific rules
Configure SNS topic for violations, subscribe ServiceNow
Integrate ServiceNow: auto-create tickets with resource details, violation details, remediation guidance, priority routing
Implement auto-remediation Lambdas: add tags, enable encryption (new volumes only), enable logging
Create Config compliance dashboard: score, by rule, by resource type, trends, non-compliant list
Configure alert suppression for expected violations, document with justification
Document runbooks for each rule, link in ServiceNow tickets
Validate in non-prod: deploy, generate test violations, verify detection/notification/tickets/remediation
Deploy to prod phased: audit mode → alerts → auto-remediation, monitor each phase 1-2 weeks
Monitor costs: Config, SNS, Lambda, alert if exceeds budget
Schedule monthly compliance review meeting
Create reporting: weekly automated email, monthly detailed report, quarterly executive summary
Deliverable: Config rules operational, ServiceNow integration working, auto-remediation enabled, compliance dashboard, monthly reviews


Story 18: Create Splunk Dashboard to Track ClickOps
User Story:
As an SRE, I want to track manual infrastructure changes (ClickOps), so that I can identify automation opportunities and reduce toil.
Acceptance Criteria:

Configure data sources: AWS CloudTrail, API Manager audit logs, DataPower audit logs, ServiceNow change records
Create queries for manual infrastructure changes: EKS modifications, security groups, RDS parameters, EBS operations, IAM changes (filter out terraform/CI-CD)
Create queries for APIC console changes: manual API publishes, rate limits, OAuth configs, certificate uploads
Create queries for DataPower changes: domain config, policy edits, cert rotation, firmware updates
Build dashboard panels:

Manual changes per week (trend line, goal: decreasing)
Change volume by component (pie/bar chart)
Changes by time of day (heatmap: business hours vs on-call)
Change types (config, hotfix, scaling, security, certs)
Top operators (table, not for blame, for process improvement)
Automation candidates (table: operation, frequency, time savings, ROI)


Implement drill-down: click count → detailed changes, click operator → their changes, click component → filter dashboard
Create automation priority scoring: ROI = (frequency × time) / automation effort, rank high/medium/low
Add trend analysis: baseline, goal (50% reduction in 2 quarters), progress tracker, forecast
Create alerts for patterns: volume increasing, high on-call changes, same operation >5 times/week → Ticket for review
Document top 5-10 automation opportunities: current process, frequency, proposed approach, effort, savings, owner
Create automation backlog in Rally: stories for top opportunities, prioritized by ROI
Schedule monthly ClickOps review: review dashboard, discuss progress, identify new opportunities, celebrate wins
Set measurable goals: 50% reduction overall, zero manual cert rotations, <5 manual EKS scaling/month, rate limits via self-service
Deliverable: Dashboard operational, top 5 automation opportunities identified and prioritized, monthly review established, goal tracking active

