# Incident Response Roles

**Last Updated:** January 2025 | **Owner:** SRE Team

---

## Table of Contents
- [Role Overview](#role-overview)
- [Incident Commander](#incident-commander) (Coming Soon)
- [Communications Lead & Scribe](#communications-lead--scribe)
- [API Enablement Team](#api-enablement-team) (Coming Soon)
- [Platform Team](#platform-team) (Coming Soon)
- [Cross-Team Coordination](#cross-team-coordination) (Coming Soon)

---

## Role Overview

Not every incident needs all roles. Small incidents may only require an Operations Lead. Larger incidents require dedicated roles to coordinate response effectively.

**Role assignment by severity:**
- **SEV-3:** Operations Lead only (person responding to incident)
- **SEV-2:** Operations Lead + Incident Commander (if >1 hour or complex)
- **SEV-1:** All roles (IC, Operations Lead, Communications Lead & Scribe)

**Multiple Operations Leads:**
For incidents affecting multiple teams or platforms, each team may have their own Operations Lead:
- **Platform Team Operations Lead:** Handles EKS, API Connect platform, DataPower infrastructure
- **API Enablement Team Operations Lead:** Handles API-specific issues, policies, consumer impacts
- Both Operations Leads coordinate with single Incident Commander
- Each focuses on their domain while sharing findings

**Role interactions:**
- Incident Commander coordinates overall response and makes decisions
- Operations Lead(s) perform technical investigation and remediation
- Communications Lead & Scribe handles stakeholder updates and timeline documentation
- Team-specific roles (Platform, API Enablement) provide specialized expertise

---

## Incident Commander

(Coming Soon)

---

## Communications Lead & Scribe

This is a combined role. We do not split Communications Lead and Scribe into separate people. Communication templates enable one person to handle both stakeholder updates and timeline documentation efficiently.

### Role Purpose

Manage all internal and external communications during the incident while documenting the incident timeline for postmortem. This role is assigned for all SEV-1 incidents, extended SEV-2 incidents (>1 hour), and SEV-3 incidents if someone is available (helpful for timeline documentation but not required).

### What This Role Does

As Communications Lead, you manage stakeholder communication throughout the incident. Identify who needs updates based on severity and send regular status updates without blocking technical response. Use communication templates to send updates quickly and consistently - templates enable rapid communication without sacrificing quality, allowing one person to handle both communications and documentation. Update status pages when needed and coordinate with customer support teams if external customers are affected. Keep stakeholders informed without overwhelming them, communicate uncertainty honestly without speculation, and get approval for external communications from management before sending.

As Scribe, you document the incident timeline in real-time. Capture all significant events with timestamps: when incident detected, when roles assigned, actions taken and their results, key decisions and rationale, who was contacted or escalated to, and communications sent to stakeholders. This documentation feeds directly into the postmortem - the more accurate your timeline, the better the postmortem and resulting improvements.

This role does not perform technical investigation, execute remediation actions, make technical decisions, direct the technical response (that's the Incident Commander's job), or make decisions about incident severity or resolution. Focus on communication and documentation, not technical work.

### Stakeholder Identification

For SEV-1 incidents, notify immediately: internal engineering teams (Platform, API Enablement, affected service owners), engineering management (Manager, Director), customer support team, SRM team (for business-critical services), and executive leadership (if high business impact).

For SEV-2 incidents, notify based on duration: internal engineering teams (immediate), Engineering Manager (after 1 hour), and customer support (if customer-facing impact).

For SEV-3 incidents, use minimal communication - internal team only. Update in team channel when resolved.

### Communication Channels

Use Microsoft Teams incident channels as primary internal communication. Email for management updates. Engineering teams use #platform-team, #api-enablement-team, #sre-team channels. For external communication, use status page updates (if applicable), customer support coordination, and executive summaries (email or Teams DM to leadership).

### Update Frequency

For SEV-1, send status updates every 30 minutes minimum, even if status is "still investigating." Include: current status, actions being taken, next steps, and ETA for next update.

For SEV-2, send status updates every 60 minutes minimum with similar content. Reduce frequency once service is mitigated.

For SEV-3, send updates as needed - typically just initial notification and resolution notice.

### Communication Templates

Use standardized templates for consistency and speed. Templates enable rapid communication without sacrificing quality, allowing you to handle both stakeholder updates and timeline documentation efficiently.

**Template Repository:** [Incident Communication Templates](/wiki/Incident-Communication-Templates)

**Available templates:**
- **Internal stakeholders:** Initial notification, status updates (investigating, mitigating), mitigated notification, resolved notification
- **Executive & leadership:** Status updates during incidents, post-incident summaries
- **Tips and best practices:** How to communicate clearly, handle uncertainty, tailor messages to different audiences

All templates are copy-paste ready with examples. The repository includes detailed guidance on when and how to use each template.

### Timeline Documentation

Capture these events with UTC timestamps: when incident detected (alert time or customer report), when ServiceNow incident created, when on-call acknowledged, when incident channel created, when roles assigned, each investigation step taken (checked Dynatrace, reviewed Splunk, examined metrics), findings from each investigation, decisions made and their rationale, actions executed (commands run, configs changed, deployments) and their results, who was contacted for help and when, when backup on-call or management engaged, status updates sent (copy message or summarize), and key milestones like when root cause identified, when mitigation started, when service mitigated, when service fully resolved, and when incident closed.

**Example timeline entries:**
```
2025-01-15 14:30 UTC - Dynatrace alert fired: API Gateway high latency
2025-01-15 14:32 UTC - ServiceNow incident INC-123456 created
2025-01-15 14:33 UTC - John Smith acknowledged, reviewing dashboards
2025-01-15 14:35 UTC - Incident channel created: #incident-2025-01-15-api-latency
2025-01-15 14:36 UTC - IC: John Smith, Ops Lead: Jane Doe, Comms/Scribe: Bob Johnson
2025-01-15 14:40 UTC - Ops Lead checked Dynatrace: p95 latency 8s (normal: 500ms)
2025-01-15 14:42 UTC - Ops Lead reviewed recent changes: deployment v2.3.4 at 14:15 UTC
2025-01-15 14:45 UTC - Decision: Rollback to v2.3.3 (IC approval)
2025-01-15 14:47 UTC - Ops Lead executed: kubectl rollout undo deployment/api-gateway
2025-01-15 14:53 UTC - Rollback complete, new pods running v2.3.3
2025-01-15 14:55 UTC - Status update sent to stakeholders
2025-01-15 15:00 UTC - Metrics improving: p95 latency 600ms
2025-01-15 15:10 UTC - Service stable: p95 latency 500ms, error rate 0.3%
2025-01-15 15:15 UTC - Marked as MITIGATED
2025-01-15 15:45 UTC - Continued stability confirmed
2025-01-15 15:50 UTC - Marked as RESOLVED
```

### Where to Document

Document in ServiceNow incident work notes as your primary location. Use "Additional comments" or work notes field and add timestamps for each entry. Update as events happen. You can also use a shared Google Doc or Teams file as backup if ServiceNow is slow or you need collaborative editing, then copy to ServiceNow work notes afterward. Don't rely on Teams channel messages alone - they're too hard to extract for timeline later and get buried in conversation. Use Teams for coordination, ServiceNow for official record.

### Handoff to Postmortem Author

At end of incident, hand off documentation to postmortem author (usually Incident Commander or Operations Lead). Provide complete timeline with timestamps, link to ServiceNow incident with work notes, any shared docs or notes created, list of key participants and their roles, and links to relevant dashboards or logs. Brief the postmortem author by walking through the timeline, highlighting key decision points, noting anything unclear or missing, and identifying what went well versus what needs improvement.

### Tips for Effective Communication

Be clear and concise. Lead with impact, then technical details. Use simple language and avoid jargon when communicating to non-technical stakeholders. Use bullet points for scannability.

Communicate uncertainty honestly. Only communicate facts you know. If you don't know something, say so. Don't guess at root cause until confirmed.

Set expectations. Always include when next update will be sent. If you miss an update time, acknowledge it. Under-promise, over-deliver on ETAs.

Stay calm and professional. Even during high-pressure SEV-1 incidents, maintain professional tone. Avoid emotional language. Focus on facts and actions.

### Related Documentation

- [Incident Communication Templates](/wiki/Incident-Communication-Templates) - All communication templates with examples
- [Incident Response Overview](/wiki/Incident-Response-Overview) - Full incident process
- [ServiceNow Incident Documentation](/wiki/ServiceNow-Incident-Documentation) - Timeline documentation guide
- [Postmortem Process](/wiki/Postmortem-Process) - What happens with your timeline documentation

---

## API Enablement Team

(Coming Soon)

---

## Platform Team

(Coming Soon)

---

## Cross-Team Coordination

(Coming Soon)

---

**Location:** `github.com/the-hartford/cto_esb_apic_wiki/wiki/Incident-Response-Roles`  
**Maintained by:** SRE Team | **Review:** Quarterly