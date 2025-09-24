| **Escalate SRM engagement issue to senior leadership due to systematic unresponsiveness** | [Senior Management] | [Date + 7 days] | Critical | Open |
| **Document SRM team engagement failures and impact on organizational learning** | [Team Manager] | [Date + 14 days] | High | Open |
| **Establish alternative post-incident review process when enterprise PRB fails** | [Team Manager] | [Date + 21 days] | High | Open |# Post-Mortem Report: Enterprise Splunk Outage Impact on IBM API Connect Operations

## Executive Summary
- **Incident Date**: [Insert Date and Time]
- **Duration**: 8 hours (Splunk outage duration)
- **Impact Level**: P2 (Monitoring and observability degradation)
- **Affected Systems**: IBM API Connect monitoring and logging capabilities
- **Business Impact**: Reduced visibility into API performance, delayed incident detection capabilities
- **Root Cause**: Enterprise Splunk infrastructure failure resulting in complete loss of logging and monitoring data for IBM API Connect platform

## Incident Overview

### What Happened
The enterprise Splunk team experienced a critical infrastructure outage lasting 7 hours and 15 minutes (3:00 AM - 10:15 AM) caused by HEC (HTTP Event Collector) token misconfiguration. Firehose HEC tokens with indexer acknowledgment (usack) enabled were incorrectly used by non-firehose clients, leading to indexer queue overload, 503 server busy errors, and complete halt in AWS VPC flow log ingestion. The IBM API Connect team first became aware of the issue through automated Splunk connectivity alerts that triggered every 15 minutes starting at 3:00 AM. During the morning standup at 8:00 AM, the team discussed the missing Splunk data and initiated independent troubleshooting efforts.

Andre, Mike, and the incident reporter began parallel investigations, including opening support tickets with IBM and AWS to rule out platform-specific issues. During troubleshooting, the team discovered a critical configuration gap: a 50GB Splunk message queue was enabled in the LAB environment but not in production. This resulted in complete data loss during the outage period, as messages had no buffer to hold them while Splunk was unavailable.

The team was unaware that an enterprise-wide Splunk outage was occurring until Andre's manager Cindy received a leadership-only email from the SRM team at 10:00 AM stating the issue was resolved. The team later learned that the primary communication method for Splunk outages is a red banner on the Splunk webpage - a method that was ineffective since the service was completely unavailable.

### Impact Assessment
- **Customer Impact**: 
  - No direct customer-facing service disruption
  - Potential delayed response to any API issues during the outage window
  - Reduced ability to proactively identify performance degradations

- **Business Impact**: 
  - Temporary suspension of SLA monitoring for API Connect services
  - Delayed incident detection and response capabilities
  - Inability to generate standard operational reports
  - Risk exposure due to monitoring blind spots

- **System Impact**: 
  - Complete loss of centralized log aggregation for API Gateway, Manager, and Analytics
  - **Critical Data Loss**: All Splunk logs during 7+ hour outage period permanently lost due to missing production queue configuration
  - Loss of real-time dashboards and alerting capabilities
  - Inability to perform log-based troubleshooting and forensic analysis for outage period
  - Degraded capacity planning and performance trending capabilities

## Timeline

| Time (EST) | Event | Actions Taken |
|------------|-------|---------------|
| 03:00 | Splunk outage begins (HEC token misconfiguration) | API Connect team begins receiving Splunk connectivity alerts every 15 minutes |
| 03:00-08:00 | Continuous alerting period | Team received automated alerts indicating no successful transactions hitting Splunk index |
| 08:00 | Morning standup meeting | Team discussed missing Splunk data and initiated investigation |
| 08:07 | **Incorrect communication sent** | Mike sent email to team distribution lists claiming analytics issue was resolved after service recycling |
| 08:15 | Investigation continued | Andre, Mike, and [Reporter] began troubleshooting despite "resolved" communication |
| 08:30 | External support engaged | Andre opened tickets with IBM Support and AWS to rule out platform issues |
| 09:00 | IBM queue issue identified | Discovered 50GB Splunk queue not enabled in production (only in LAB) |
| 09:20 | **Correction communication sent** | [Reporter] sent email clarifying that incident was still active and affecting team |
| 09:30 | Data loss confirmed | Realized all Splunk data during outage was lost due to missing queue configuration |
| 10:00 | Leadership notification received | Cindy (Andre's manager) received SRM email stating Splunk issue resolved |
| 10:15 | Splunk services restored | API Connect team verified log ingestion resumption |
| 12:30 | Official incident summary distributed | SRM team sent detailed incident summary to LOB leadership (not operational teams) |
| Post-incident | **Leadership communication gap identified** | Discovered Jenn (manager) failed to cascade SRM notifications to operational team |
| Post-incident | Follow-up attempts begin | Multiple attempts to schedule PRB (Post-incident Review Board) meeting with SRM team |
| 8/25 | **SRM PRB meeting cancelled** | SRM team cancelled scheduled PRB meeting due to being "busy" |
| 8/27 | **Internal post-mortem initiated** | Cody scheduled internal team post-mortem meeting with Andre and Mike for 10:30 AM |
| 8/29 | **SRM PRB rescheduled and cancelled again** | Second PRB meeting (11:30 AM) cancelled by SRM team for same reason |
| 8/29 | **Direct SRM engagement attempt** | Cody messaged Michael Hayes (SRM) asking when PRB would occur; promised for 9/15 |
| 9/15 | **Follow-up email sent** | Cody sent email to SRM and Splunk support teams requesting meeting coordination |
| 9/16 | **SRM acknowledgment** | Michael Hayes replied stating he was "working on it" and "hasn't forgotten about us" |
| 9/17 | **Splunk team meeting held** | Successful meeting at 2:00 PM to understand Splunk team communication processes |
| 9/19 | **Second follow-up attempt** | Cody sent follow-up email due to lack of response; received no reply |
| 9/19+ | **Escalation to product owner** | Issue escalated to Rob (Product Owner) who has not yet escalated the SRM request |
| Current | **SRM engagement remains unresolved** | No successful PRB meeting or process discussion with SRM team achieved |

## Root Cause Analysis

### Immediate Cause
Enterprise Splunk infrastructure failure resulting in complete service unavailability across The Hartford enterprise environment.

### Root Cause
[To be provided by Enterprise Splunk team's post-mortem] - The API Connect team was a downstream consumer of the failed service rather than the root cause owner.

### Contributing Factors

#### Technical Factors
- **Configuration Parity Gap**: Critical 50GB Splunk message queue enabled in LAB environment but missing in production
- **Data Loss Architecture**: No buffering mechanism to preserve logs during Splunk unavailability in production environment
- **Single Point of Failure**: Heavy reliance on Splunk as the primary logging and monitoring solution for IBM API Connect platform
- **Monitoring Architecture**: Lack of redundant monitoring systems or failover capabilities
- **Alerting Dependencies**: Critical alerts configured exclusively through Splunk with no backup alerting mechanisms
- **Alert Frequency Mismatch**: API Connect team's 15-minute health checks vs. Splunk team's 4-hour monitoring interval

#### Process Factors
- **Leadership Communication Failure**: Manager (Jenn) failed to cascade SRM incident notifications to operational team as required by established process
- **Incorrect Incident Communication**: Premature and inaccurate "resolved" communication sent to multiple distribution lists during active incident
- **Incident Tracking Errors**: Incorrect INC number referenced in team communications, with failed attempt to link to primary Splunk incident
- **Communication Protocols**: No proactive notification process for enterprise-wide outages affecting downstream teams
- **Incident Correction Process**: Required manual correction communication to clarify misleading incident status updates
- **Documentation Gaps**: Absence of documented procedures for operating during extended monitoring platform outages
- **Configuration Management**: Lack of environment parity validation between LAB and production configurations
- **Post-Incident Coordination**: Significant delays (1+ month) in accessing enterprise incident response team (SRM) for process understanding

#### Organizational Factors
- **Leadership Accountability Gap**: Manager (Jenn) did not fulfill established responsibility to cascade SRM notifications to operational teams
- **Information Distribution**: Official incident summaries (12:30 PM) sent only to LOB leadership, not operational teams managing active incidents
- **SRM Team Accessibility Crisis**: Systematic pattern of SRM team unavailability preventing post-incident learning and process improvement
- **PRB Process Failure**: Post-incident Review Board meetings cancelled twice (8/25, 8/29) due to SRM team being "busy"
- **Unresponsive Communication**: SRM team (Michael Hayes) failed to respond to multiple follow-up attempts (9/15, 9/19 emails)
- **Escalation Process Gaps**: Product Owner escalation ineffective in securing necessary SRM team engagement
- **Cross-Team Communication**: Inadequate communication channels between IBM API Connect team, Enterprise Splunk team, and SRM team
- **Incident Management Training**: Team members unaware of enterprise outage communication methods and escalation procedures
- **Communication Chain Dependencies**: Over-reliance on single point of failure (manager) for critical operational communications
- **Resource Allocation**: Limited investment in monitoring redundancy and resilience initiatives
- **Governance**: Lack of enterprise-wide standards for critical monitoring dependencies and backup requirements

## What Went Well

- **Early Detection**: Automated 15-minute health checks successfully detected Splunk connectivity issues within minutes of outage start
- **Team Coordination**: Effective coordination during standup meeting led to immediate investigation initiation
- **Parallel Investigation**: Multiple team members (Andre, Mike, Cody) conducting independent troubleshooting efforts
- **Due Diligence**: Comprehensive investigation including external support tickets with IBM and AWS to rule out platform issues
- **Service Continuity**: Core IBM API Connect services remained fully operational throughout the outage
- **Root Cause Discovery**: Successfully identified IBM queue configuration gap during investigation
- **Proactive Team Leadership**: Cody took initiative to schedule internal post-mortem (8/27) when enterprise PRB process failed
- **Alternative Engagement Success**: Successful post-incident meeting with Splunk team (9/17) to establish future communication protocols
- **Learning Mindset**: Team actively sought to understand enterprise processes and improve coordination
- **Communication Correction**: Quick correction of misleading incident status (9:20 AM) to prevent continued misinformation
- **Persistent Follow-up**: Continued attempts to engage SRM team despite repeated cancellations and non-responses

## What Went Wrong

- **Complete Data Loss**: Permanent loss of 7+ hours of Splunk log data due to missing production queue configuration
- **Leadership Communication Breakdown**: Manager (Jenn) failed to cascade critical SRM incident notifications to operational team
- **Misleading Incident Communication**: Premature "resolved" communication sent at 8:07 AM claiming analytics was fixed when incident was still active
- **Incident Tracking Confusion**: Incorrect INC number referenced in communications, failed linking attempt to primary Splunk incident
- **Required Incident Correction**: Manual correction communication needed at 9:20 AM to clarify ongoing incident status
- **Information Distribution Gap**: Official incident summary (12:30 PM) provided only to leadership while operational teams remained uninformed
- **Technical Misunderstanding**: Service recycling appeared to resolve issue but only cleared stuck data temporarily, masking ongoing problem
- **Environment Parity**: Critical configuration differences between LAB and production environments
- **Wasted Investigation Effort**: Significant time spent investigating non-existent IBM/AWS issues due to lack of enterprise outage awareness
- **Alert Frequency Gap**: Enterprise Splunk monitoring (4-hour intervals) insufficient compared to consumer team needs (15-minute checks)
- **SRM Team Engagement Failure**: Systematic inability to engage SRM team for post-incident learning despite multiple cancellations and unresponsive communications
- **PRB Process Breakdown**: Post-incident Review Board meetings cancelled twice due to SRM team availability, preventing formal incident review
- **Escalation Process Ineffectiveness**: Product Owner escalation failed to secure necessary SRM team engagement for process improvement
- **Learning Opportunity Loss**: Inability to conduct formal PRB resulted in missed organizational learning and process improvement opportunities

## Action Items

| Action | Owner | Due Date | Priority | Status |
|--------|-------|----------|----------|---------|
| **CRITICAL: Enable 50GB Splunk message queue in production environment** | [SRE Lead] | [Date + 7 days] | Critical | Open |
| **Address leadership communication failure with Jenn regarding SRM notification cascade responsibilities** | [Senior Management] | [Date + 3 days] | Critical | Open |
| **Establish incident communication verification process to prevent premature "resolved" notifications** | [Team Manager] | [Date + 14 days] | High | Open |
| **Create incident communication template with verification checkpoints** | [Documentation Owner] | [Date + 14 days] | High | Open |
| **Validate environment parity between LAB and production configurations** | [SRE Engineer] | [Date + 14 days] | High | Open |
| **Implement direct SRM notification process for operational teams (bypass single point of failure)** | [Team Manager] | [Date + 21 days] | High | Open |
| **Document correct incident tracking and linking procedures** | [Documentation Owner] | [Date + 14 days] | High | Open |
| **Request inclusion in enterprise outage notification distribution list (direct to operational teams)** | [Team Manager] | [Date + 7 days] | High | Open |
| **Create backup alerting through IBM API Connect native alerts** | [SRE Engineer] | [Date + 21 days] | High | Open |
| **Establish communication protocol for incident status corrections** | [Team Manager] | [Date + 14 days] | Medium | Open |
| **Implement secondary monitoring solution independent of Splunk** | [SRE Lead] | [Date + 45 days] | Medium | Open |
| **Establish regular communication cadence with Enterprise Splunk team** | [Technical Lead] | [Date + 30 days] | Medium | Open |
| **Create runbook for operations during enterprise infrastructure outages** | [Documentation Owner] | [Date + 21 days] | Medium | Open |
| **Conduct training on enterprise incident management and communication procedures** | [Team Manager] | [Date + 30 days] | Medium | Open |
| **Review and align monitoring alert frequencies across enterprise dependencies** | [SRE Team] | [Date + 30 days] | Medium | Open |
| **Conduct environment parity audit across all critical configurations** | [SRE Engineer] | [Date + 45 days] | Medium | Open |

## Lessons Learned

### Technical Lessons
1. **Environment Parity is Critical**: Configuration differences between LAB and production can result in catastrophic data loss during infrastructure outages
2. **Queue Buffering Essential**: Production systems require proper message buffering to prevent data loss during downstream service outages
3. **Monitoring Dependencies**: Critical systems require multiple, independent monitoring solutions to avoid single points of failure
4. **Service Recycling Misleading**: Apparent issue resolution (clearing stuck data) can mask underlying problems and lead to false confidence

### Process Lessons
1. **Communication Verification Required**: Incident status communications must be thoroughly verified before distribution to prevent misinformation
2. **Leadership Accountability**: Established communication cascade processes must be enforced and monitored for compliance
3. **Incident Tracking Accuracy**: Proper incident correlation and tracking is essential for effective enterprise incident management
4. **Correction Protocols Needed**: Clear processes for correcting misleading communications during active incidents
5. **Direct Operational Communication**: Operational teams need direct access to enterprise incident information, not just leadership-filtered updates

### Organizational Lessons
1. **Enterprise Team Accountability**: Critical enterprise support teams (SRM) must be held accountable for post-incident engagement and organizational learning
2. **Alternative Learning Processes**: When enterprise post-incident processes fail, teams must establish their own learning mechanisms
3. **Escalation Effectiveness**: Current escalation processes through Product Owners may be insufficient for securing enterprise team engagement
4. **Communication Dependency Risk**: Single points of failure in communication chains (managers, SRM contacts) create systemic vulnerabilities
5. **Persistent Engagement Required**: Successful cross-team relationships require persistent effort and multiple touchpoints, as demonstrated with Splunk team success vs. SRM failure
6. **Leadership Intervention Necessity**: Some organizational dysfunction requires senior leadership intervention to resolve systemic issues

## Follow-Up Actions

### Short Term (Next 30 Days)
- Implement immediate backup alerting mechanisms
- Document alternative monitoring procedures
- Create monitoring dependency risk assessment

### Medium Term (30-90 Days)
- Deploy secondary monitoring solution
- Establish regular testing of monitoring failover procedures
- Update incident response documentation

### Long Term (90+ Days)
- Complete monitoring resilience architecture review
- Implement comprehensive monitoring redundancy
- Establish monitoring dependency governance process

## Appendices

### Appendix A: Affected Systems
- IBM API Connect Gateway (DataPower)
- IBM API Connect Manager
- IBM API Connect Analytics
- Custom API monitoring dashboards
- API performance trending reports

### Appendix B: Alternative Monitoring Tools Used
- IBM API Connect Manager UI health status
- DataPower web interface system status
- Manual API endpoint health checks
- Infrastructure monitoring (outside Splunk)

### Appendix C: Communication Timeline
[Include copies of stakeholder notifications and updates]

### Appendix D: SRM Incident Summary (12:30 PM Distribution)

**Official SRM Incident Summary - Distributed to LOB Leadership Only**

**Incident Summary**: Splunk HEC Tokens - AWS VPC flow logs were not getting ingested into Splunk.

**Current Status as of 12:30 PM**: Service was restored after all 54 indexers were restarted and the Splunk vendor confirmed that all the logs were ingested. The incident was caused by a misconfiguration. The firehose HEC tokens with indexer acknowledgment (usack) enabled were used by non-firehose clients. This led to indexer queue overload, resulting in 503 server busy errors and a halt in AWS VPC flow log ingestion.

**Next Steps**: System health and alerts to be monitored by Splunk vendor and HIG Splunk team until permanent fix. Create new HEC tokens without indexer acknowledgment for non-firehose sources. Provide status updates and documentation for leadership approval. Submit and expedite change control for token updates. Coordinate post-change validation and monitoring.

**Business Impacts**: AWS VPC flow logs were not ingested into Splunk, resulting in missing network traffic data for monitoring and analysis. Security monitoring was at risk due to the absence of VPC flow logs, affecting the ability to implement security rules and alerts.

**Data Loss Clarification**: SRM team reported "no data loss occurred as logs reside on S3 and can be reingested" - this applies only to AWS VPC flow logs, not consumer applications like IBM API Connect.

### Appendix E: Communication Timeline Analysis

**8:07 AM - Incorrect Team Communication (Mike)**
- **Recipients**: @EA APICOE and @EMI Platform Admin - APIC distribution lists
- **Content**: "It appears analytics stopped working at 3am this morning the prod APIC cluster. The platform team recycled the service and analytics is now functioning"
- **Issues**: Premature resolution claim, incorrect INC reference, failed attempt to link to primary Splunk incident

**9:20 AM - Correction Communication (Cody)**
- **Recipients**: Same distribution lists
- **Content**: Clarification that previous communication was incorrect and incident was still active
- **Purpose**: Prevent continued misinformation and reset incident status expectations

**12:30 PM - Official SRM Summary**
- **Recipients**: LOB Leadership only (not operational teams)
- **Issue**: Critical incident information not distributed to teams managing active response

---

**Report Prepared By**: [Your Name], Senior SRE - IBM API Connect Team  
**Report Date**: [Current Date]  
**Next Review Date**: [Date + 30 days] (for action item progress review)

**Post-Mortem Session Attendees**: [List attendees from post-mortem meeting]

---

*This post-mortem follows The Hartford's incident management standards and contributes to the continuous improvement of our IBM API Connect platform reliability and observability practices.*