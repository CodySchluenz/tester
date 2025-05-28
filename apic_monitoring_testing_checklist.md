# IBM APIC EKS Monitoring & Alerting Testing Checklist

## How to Use This Checklist

This checklist is designed as your systematic guide through testing your IBM APIC monitoring setup. Each section builds on the previous one, so I recommend working through them in order. The estimated times will help you plan your testing sessions, and the "Why This Matters" explanations will help you understand the reasoning behind each step.

**Before you begin:** Set aside dedicated time blocks for this testing. Monitoring validation requires focus and attention to detail. Plan for approximately 6-8 hours total, spread across multiple sessions.

---

## Phase 1: Foundation - Understanding Your Current Landscape
*Estimated time: 45 minutes*

The goal of this phase is to build a complete picture of what you currently have before you start testing. Think of this as creating a map before you begin your journey.

### Pre-Testing Inventory and Setup

□ **Document your APIC deployment details**
   - [ ] Record your EKS cluster name: ________________
   - [ ] List all APIC-related namespaces: ________________
   - [ ] Note your Dynatrace environment URL: ________________
   - [ ] Identify your AWS CloudWatch region: ________________
   
   *Why this matters: Having these details documented saves time during testing and ensures you're looking in the right places.*

□ **Verify access to monitoring tools**
   - [ ] Confirm Dynatrace access with admin privileges
   - [ ] Verify AWS CloudWatch access for your EKS cluster
   - [ ] Test that you can view Kubernetes resources in both tools
   
   *Success criteria: You can navigate to your EKS cluster in both Dynatrace and CloudWatch without errors.*

□ **Create your testing environment baseline**
   - [ ] Take screenshots of current alert counts in Dynatrace
   - [ ] Document current system load and performance metrics
   - [ ] Note any existing alerts or issues before testing begins
   
   *Why this matters: You need to distinguish between existing issues and problems caused by your testing.*

□ **Identify your testing windows**
   - [ ] Coordinate with teams for low-traffic periods
   - [ ] Plan testing sessions when you can safely trigger alerts
   - [ ] Ensure you have rollback procedures ready
   
   *Success criteria: You have specific time windows planned and team approval for testing activities.*

---

## Phase 2: Custom Resource Health Validation
*Estimated time: 30 minutes*

This phase focuses on the "DNA" of your APIC deployment - the Custom Resources that define your system's intended state. Understanding these is crucial because they often reveal problems before traditional monitoring does.

### Understanding Your APIC Custom Resource Hierarchy

□ **Locate and examine the parent APIConnect resource**
   - [ ] Navigate to Dynatrace → Infrastructure → Kubernetes → [Your Cluster] → Custom Resources
   - [ ] Find the APIConnect Custom Resource (usually one main resource)
   - [ ] Record its current status and conditions: ________________
   - [ ] Take screenshot of the "Conditions" section
   
   *Success criteria: You can find the main APIConnect CR and its status shows "Ready: True"*

□ **Inventory all APIC subsystem Custom Resources**
   - [ ] Locate ManagementCluster Custom Resource
     - Status: ________________ 
     - Last transition time: ________________
   - [ ] Locate GatewayCluster Custom Resource
     - Status: ________________
     - Last transition time: ________________
   - [ ] Locate AnalyticsCluster Custom Resource
     - Status: ________________
     - Last transition time: ________________
   - [ ] Locate PortalCluster Custom Resource
     - Status: ________________
     - Last transition time: ________________
   
   *Why this matters: Each subsystem CR tells you whether that component is maintaining its desired state. Problems here often indicate issues before they affect users.*

□ **Verify Custom Resource monitoring coverage**
   - [ ] Check if alerts exist for APIConnect CR status changes
   - [ ] Verify alerts for each subsystem CR condition changes
   - [ ] Document any Custom Resources without monitoring: ________________
   
   *Success criteria: Every critical Custom Resource has alert rules that trigger when conditions change from "Ready: True" to any other state.*

---

## Phase 3: Management Subsystem Deep Dive
*Estimated time: 45 minutes*

The Management subsystem is the control center of your APIC deployment. Problems here affect your ability to manage APIs and can cascade to other subsystems.

### Kubernetes Workload Analysis

□ **Identify Management subsystem components in Dynatrace**
   - [ ] Navigate to Infrastructure → Kubernetes → [Cluster] → Find management namespace
   - [ ] Locate these key deployments and record their status:
     - [ ] management-server: Pods running ___/___
     - [ ] ui (or management-ui): Pods running ___/___
     - [ ] juhu: Pods running ___/___
     - [ ] turnstile: Pods running ___/___
   
   *Why this matters: These are the core services that handle API lifecycle management and administrative functions.*

□ **Verify endpoint monitoring coverage**
   - [ ] Check monitoring for: `https://<mgmt-hostname>/health`
   - [ ] Check monitoring for: `https://<mgmt-hostname>/admin`
   - [ ] Check monitoring for: `https://<mgmt-hostname>/api/cloud/health`
   - [ ] Verify synthetic monitors exist for management portal login flow
   
   *Success criteria: Each critical endpoint has either synthetic monitoring or service-level monitoring in place.*

### Management Subsystem Alert Testing

□ **Test management API performance alerts**
   - [ ] Note baseline response time for management API: ______ ms
   - [ ] Document current error rate: ______ %
   - [ ] Plan controlled performance degradation test
   - [ ] Execute test and verify alerts trigger within expected timeframe
   - [ ] Confirm alerts route to correct team (Platform/API team)
   - [ ] Restore normal conditions and verify recovery alerts
   
   *Success criteria: Performance alerts trigger within 5 minutes of threshold breach and route to appropriate team.*

□ **Test management subsystem availability alerts**
   - [ ] Plan controlled availability test (scale down one management pod)
   - [ ] Execute test and monitor Custom Resource status changes
   - [ ] Verify availability alerts trigger
   - [ ] Check that alerts include context about affected functionality
   - [ ] Restore service and confirm recovery
   
   *Why this matters: Availability issues in management affect your ability to publish APIs and manage the platform.*

---

## Phase 4: Gateway Subsystem Deep Dive  
*Estimated time: 60 minutes*

The Gateway subsystem handles all customer-facing API traffic. This is where user-impacting issues first appear, making comprehensive monitoring crucial.

### Gateway Component Discovery

□ **Map Gateway infrastructure in Dynatrace**
   - [ ] Locate gateway namespace and record key deployments:
     - [ ] datapower-gateway: Pods running ___/___
     - [ ] gateway-peering: Pods running ___/___
     - [ ] rate-limit: Pods running ___/___
   - [ ] Navigate to Technologies → Processes and find DataPower processes
   - [ ] Record DataPower process group names: ________________
   
   *Why this matters: DataPower gateways have unique monitoring characteristics - they run multiple internal processes that need individual attention.*

□ **Analyze Gateway service flow**
   - [ ] Navigate to Applications & Microservices → Services
   - [ ] Find your main gateway service
   - [ ] Click "Service flow" and document the complete request path
   - [ ] Identify all dependencies shown in the service flow
   - [ ] Note any services in the flow that lack monitoring
   
   *Success criteria: You can trace a complete API request path from external source through gateway to backend services.*

### Gateway Performance and Error Testing

□ **Test Gateway latency alerts**
   - [ ] Document baseline gateway response time: ______ ms (p95)
   - [ ] Note current traffic volume: ______ requests/minute
   - [ ] Plan load test to increase latency beyond threshold
   - [ ] Execute test and verify latency alerts trigger
   - [ ] Confirm alerts include service flow context
   - [ ] Check that gateway auto-scaling triggers if configured
   
   *Success criteria: Latency alerts trigger when p95 response time exceeds threshold for configured duration.*

□ **Test Gateway error rate monitoring**
   - [ ] Record current error rate: ______ %
   - [ ] Plan controlled error injection (return 500 status codes)
   - [ ] Execute error injection and monitor error rate climb
   - [ ] Verify error rate alerts trigger at configured threshold
   - [ ] Check that alerts identify specific APIs or endpoints affected
   - [ ] Confirm alerts route to API team, not infrastructure team
   
   *Why this matters: Error rate alerts need to distinguish between infrastructure problems and API-specific issues for proper team routing.*

□ **Test Gateway rate limiting alerts**
   - [ ] Document configured rate limits for key APIs
   - [ ] Generate traffic to exceed rate limits
   - [ ] Verify rate limiting enforcement triggers
   - [ ] Check that rate limiting alerts fire appropriately
   - [ ] Confirm blocked requests don't trigger false error alerts
   
   *Success criteria: Rate limiting works correctly and generates appropriate alerts without causing false positives.*

---

## Phase 5: Analytics Subsystem Validation
*Estimated time: 40 minutes*

The Analytics subsystem is often overlooked in monitoring, but failures here can result in lost business intelligence data and compliance issues.

### Analytics Component Mapping

□ **Locate Analytics infrastructure**
   - [ ] Find analytics namespace in Dynatrace Kubernetes view
   - [ ] Document analytics components:
     - [ ] analytics-ingestion: Pods running ___/___
     - [ ] analytics-storage: Pods running ___/___
     - [ ] analytics-proxy: Pods running ___/___
     - [ ] coordinating-service: Pods running ___/___
   
   *Why this matters: Analytics has a complex data flow that can fail at multiple points, and each component serves a specific function.*

□ **Trace Analytics data flow**
   - [ ] Navigate to Services view and locate analytics services
   - [ ] Follow service flow from gateway → analytics-ingestion → analytics-storage
   - [ ] Document response times at each step: ________________
   - [ ] Identify any gaps in the monitoring chain
   
   *Success criteria: You can trace the complete analytics data path and verify monitoring coverage at each step.*

### Analytics Health Testing

□ **Test Analytics ingestion monitoring**
   - [ ] Monitor analytics ingestion queue depth
   - [ ] Note baseline processing time: ______ ms
   - [ ] Generate high-volume API traffic to stress ingestion
   - [ ] Verify ingestion backlog alerts trigger appropriately
   - [ ] Check that processing time alerts work correctly
   
   *Why this matters: Ingestion problems often manifest as gradual degradation rather than immediate failure.*

□ **Test Analytics storage monitoring**
   - [ ] Check analytics storage disk utilization: ______ %
   - [ ] Verify storage performance monitoring is in place
   - [ ] Test storage capacity alerts if possible
   - [ ] Confirm analytics query performance monitoring
   
   *Success criteria: Storage monitoring alerts before capacity issues affect analytics processing.*

---

## Phase 6: Portal Subsystem Validation
*Estimated time: 35 minutes*

The Portal subsystem provides the developer experience. Issues here affect API adoption and developer satisfaction.

### Portal Component Analysis

□ **Map Portal infrastructure**
   - [ ] Locate portal namespace and components:
     - [ ] portal-admin: Pods running ___/___
     - [ ] portal-www: Pods running ___/___
     - [ ] portal-db: Pods running ___/___
     - [ ] portal-nginx: Pods running ___/___
   
□ **Verify Portal user experience monitoring**
   - [ ] Check if Real User Monitoring (RUM) is enabled for portal URLs
   - [ ] Navigate to Frontend → Web applications in Dynatrace
   - [ ] Verify portal domain appears with user experience data
   - [ ] Document key user experience metrics: ________________
   
   *Why this matters: Portal performance directly affects developer experience and API adoption rates.*

### Portal Experience Testing

□ **Test Portal availability and performance**
   - [ ] Verify portal health endpoint monitoring
   - [ ] Test portal login flow monitoring
   - [ ] Check API catalog accessibility monitoring
   - [ ] Verify portal search functionality monitoring
   
   *Success criteria: All critical portal user journeys have monitoring coverage.*

□ **Test Portal error and performance alerts**
   - [ ] Document baseline portal response times
   - [ ] Test portal performance degradation alerts
   - [ ] Verify portal error rate monitoring
   - [ ] Check that portal alerts route to Developer Experience team
   
---

## Phase 7: PostgreSQL Database Deep Dive
*Estimated time: 45 minutes*

Database health is fundamental to APIC operation. The IBM documentation specifically emphasizes PostgreSQL disk monitoring, making this a critical focus area.

### Database Infrastructure Mapping

□ **Locate PostgreSQL instances in monitoring**
   - [ ] Navigate to Technologies → Databases in Dynatrace
   - [ ] Find PostgreSQL instances for each subsystem:
     - [ ] Management PostgreSQL: Instance name ________________
     - [ ] Portal PostgreSQL: Instance name ________________
     - [ ] Additional instances: ________________
   - [ ] Record current connection counts for each instance
   
   *Why this matters: Each APIC subsystem typically has its own PostgreSQL instance with different performance characteristics.*

□ **Map PostgreSQL StatefulSets in Kubernetes**
   - [ ] Find PostgreSQL StatefulSets (not Deployments) in Dynatrace
   - [ ] Record StatefulSet names: ________________
   - [ ] Document persistent volume usage for each database
   - [ ] Note which nodes are running PostgreSQL pods
   
   *Success criteria: You can identify all PostgreSQL instances and their persistent storage.*

### Critical Database Monitoring Tests

□ **Test PostgreSQL disk usage monitoring (Critical per IBM docs)**
   - [ ] Current disk usage for each database: ______ %
   - [ ] Verify warning alerts are configured at 80% disk usage
   - [ ] Verify critical alerts are configured at 85% disk usage
   - [ ] Test alert routing to DBA/Platform team
   - [ ] If possible, safely test disk pressure to verify alerts
   
   *Why this matters: IBM specifically warns that PostgreSQL disk issues can cause catastrophic APIC failures.*

□ **Test database performance monitoring**
   - [ ] Document baseline query response times: ______ ms
   - [ ] Verify connection pool monitoring is in place
   - [ ] Check Write-Ahead Log (WAL) monitoring
   - [ ] Test database slowness alerts if possible
   
   *Success criteria: Database performance issues are detected before they affect APIC operations.*

□ **Test database connection monitoring**
   - [ ] Record current connection pool utilization: ______ %
   - [ ] Verify connection exhaustion alerts exist
   - [ ] Test connection timeout monitoring
   - [ ] Check that database connectivity issues trigger appropriate alerts
   
---

## Phase 8: Cross-Subsystem Dependency Testing
*Estimated time: 50 minutes*

This is where many monitoring gaps are discovered. APIC subsystems are interdependent, and failures often cascade in unexpected ways.

### Dependency Relationship Validation

□ **Test Management-to-Gateway dependency**
   - [ ] Plan controlled Management subsystem slowdown
   - [ ] Monitor how Gateway performance is affected
   - [ ] Verify that alerts provide context about root cause
   - [ ] Check that Gateway teams receive appropriate information
   
   *Why this matters: Gateway authentication depends on Management subsystem, and slowdowns can cascade.*

□ **Test Database impact on all subsystems**
   - [ ] Plan controlled database latency increase
   - [ ] Monitor how each subsystem responds to database slowness
   - [ ] Verify that alerts distinguish between database issues and application issues
   - [ ] Check alert correlation and root cause analysis
   
   *Success criteria: Database performance issues are correctly identified as root cause rather than blamed on dependent services.*

□ **Test Analytics-Gateway relationship**
   - [ ] Monitor whether Analytics processing delays affect Gateway performance
   - [ ] Verify that Analytics failures don't trigger false Gateway alerts
   - [ ] Check that Analytics data loss is detected independently
   
### Network and Certificate Dependencies

□ **Test inter-subsystem network monitoring**
   - [ ] Verify monitoring of network connectivity between subsystems
   - [ ] Check that network latency increases are detected
   - [ ] Test network partition detection if possible
   
□ **Test certificate expiration monitoring**
   - [ ] Inventory all certificates used by APIC subsystems
   - [ ] Verify 30-day expiration warnings exist
   - [ ] Check 7-day critical alerts are configured
   - [ ] Test certificate renewal workflow monitoring
   
   *Why this matters: Certificate expiration can cause sudden, complete service failures.*

---

## Phase 9: Alert Flow and Team Routing Validation  
*Estimated time: 40 minutes*

Having the right monitoring is only half the battle - alerts must reach the right people with the right context at the right time.

### Alert Routing Verification

□ **Map alert routing to teams**
   - [ ] Infrastructure alerts → Platform/SRE team ✓
   - [ ] API Gateway alerts → API team ✓
   - [ ] Portal alerts → Developer Experience team ✓
   - [ ] Database alerts → DBA/Platform team ✓
   - [ ] Security alerts → Security Operations team ✓
   
□ **Test alert delivery mechanisms**
   - [ ] Verify email delivery for all alert types
   - [ ] Test Slack/Teams integration for real-time alerts
   - [ ] Check PagerDuty integration for critical alerts
   - [ ] Verify incident ticket creation in ServiceNow/JIRA
   
   *Success criteria: Test alerts reach intended recipients within configured timeframes.*

### Alert Context and Escalation Testing

□ **Verify alert context quality**
   - [ ] Test alerts include relevant dashboard links
   - [ ] Check that alerts contain runbook references
   - [ ] Verify alerts include service flow context where applicable
   - [ ] Confirm alerts distinguish between symptoms and root causes
   
□ **Test alert escalation procedures**
   - [ ] Verify escalation triggers when primary on-call doesn't respond
   - [ ] Test different escalation paths for different alert severities
   - [ ] Check weekend/off-hours alert routing
   
   *Why this matters: Poorly contextualized alerts slow down incident response and can lead to incorrect troubleshooting.*

---

## Phase 10: Monitoring Gap Prevention and Documentation
*Estimated time: 30 minutes*

The final phase focuses on ensuring your hard work doesn't decay over time and that future changes maintain monitoring coverage.

### Gap Prevention Systems

□ **Create ongoing gap detection processes**
   - [ ] Document procedure for monitoring new APIC deployments
   - [ ] Create checklist for new component monitoring requirements
   - [ ] Set up regular monitoring coverage audits
   
□ **Document your testing findings**
   - [ ] Create summary of gaps found during testing: ________________
   - [ ] Document remediation actions taken: ________________
   - [ ] Create recommendations for future improvements: ________________
   
### Knowledge Transfer and Maintenance

□ **Update team documentation**
   - [ ] Update runbooks with current monitoring locations
   - [ ] Document Custom Resource monitoring procedures
   - [ ] Create troubleshooting guides based on testing insights
   
□ **Schedule regular validation**
   - [ ] Plan quarterly monitoring effectiveness reviews
   - [ ] Schedule annual comprehensive testing cycles
   - [ ] Create process for validating monitoring after APIC upgrades
   
   *Success criteria: Future team members can understand and maintain your monitoring setup.*

---

## Testing Completion Summary

### Final Validation Checklist

□ **All critical endpoints have monitoring coverage**
□ **All Custom Resources have health monitoring**
□ **All alert thresholds have been tested and validated**
□ **All alert routing has been verified to reach correct teams**
□ **All cross-subsystem dependencies are monitored**
□ **All teams understand their alert responsibilities**
□ **Documentation is updated and accessible**
□ **Regular maintenance processes are scheduled**

### Key Metrics Achieved

- **Monitoring Coverage**: ______ % of critical components monitored
- **Alert Accuracy**: ______ % of test alerts triggered correctly
- **Response Time**: Average time from issue to alert: ______ minutes
- **Team Satisfaction**: ______ % of teams confident in alert routing

**Total Testing Time Invested**: ______ hours
**Major Gaps Discovered**: ______ 
**Gaps Remediated**: ______
**Next Review Date**: ________________

---

*Congratulations! You've completed a comprehensive validation of your IBM APIC monitoring and alerting setup. This systematic approach has given you confidence that your monitoring will catch issues before they impact users and route alerts to the right teams for quick resolution.*