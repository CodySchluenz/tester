/wiki/Incident-Response-Overview
├── 1. Introduction & Philosophy
├── 2. End-to-End Process Flow
├── 3. Incident Severity Definitions
├── 4. Incident Detection & Alerting
│   ├── → /wiki/Observability-Stack
│   └── → /wiki/Runbooks
├── 5. Incident Declaration Process
├── 6. Incident Resolution Criteria
├── 7. Escalation Procedures
├── 8. Emergency Change Management
├── 9. Quick Reference
│   ├── Severity & Response Time SLA Table
│   ├── Tool Links
│   └── Emergency Contacts
├── 10. Getting Started
└── 11. Related Documentation
    ├── → /wiki/Incident-Response-Roles
    ├── → /wiki/On-Call-Guide
    ├── → /wiki/Postmortem-Process
    ├── → /wiki/Incident-Metrics-and-Improvement
    ├── → /wiki/Observability-Stack
    └── → /wiki/Runbooks

/wiki/Incident-Response-Roles
├── 1. Role Overview
├── 2. Incident Commander
├── 3. Communications Lead & Scribe
├── 4. API Enablement Team
├── 5. Platform Team
└── 6. Cross-Team Coordination (SRM)
    └── → /wiki/Incident-Response-Overview (escalation)

/wiki/On-Call-Guide
├── 1. On-Call Philosophy
├── 2. On-Call Process & Expectations
│   └── → /wiki/Incident-Response-Overview (severity & SLAs)
└── 3. On-Call Onboarding Checklist
    ├── → /wiki/Incident-Response-Overview
    ├── → /wiki/Incident-Response-Roles
    └── → /wiki/Observability-Stack

/wiki/Incident-Metrics-and-Improvement
├── 1. Key Metrics & KPIs
│   ├── MTTD, MTTA, MTTR definitions
│   ├── Incident frequency
│   ├── Error budget consumption
│   ├── On-call load
│   └── Postmortem/action item completion
├── 2. Dashboards & Reporting
│   ├── SLO Dashboard (Dynatrace) - Service health & error budgets
│   ├── Problem Dashboard (Splunk) - Real-time system issues
│   ├── ClickOps Dashboard (Splunk) - Manual operations tracking
│   └── Incident Dashboard (ServiceNow) - SLA breaches, current/historical incidents, related incidents, open PRBs
├── 3. Error Budget Management
│   └── → /wiki/Postmortem-Process
└── 4. Continuous Improvement Process
    └── → /wiki/Postmortem-Process

/wiki/Observability-Stack
├── 1. Monitoring Stack Overview
├── 2. Dynatrace (API Connect/EKS)
├── 3. Splunk (Logs)
├── 4. MainView (DataPower Middleware)
├── 5. DPMON (DataPower Appliances)
└── 6. Tool Integration & Correlation
    └── → /wiki/Incident-Response-Overview (golden signals)

/wiki/Runbooks
├── 1. Runbook Standards & Template
├── 2. API Connect Runbooks
├── 3. DataPower Runbooks
├── 4. Infrastructure Runbooks
└── 5. Runbook Index (searchable)

/wiki/Postmortem-Process
└── Links back to:
    ├── → /wiki/Incident-Response-Overview
    └── → /wiki/Incident-Metrics-and-Improvement
