# Comprehensive Testing Guide for Existing IBM APIC EKS Monitoring & Alerting

## Understanding the Foundation: How APIC Components Appear in Monitoring

Before we dive into testing, it's crucial to understand how your IBM APIC deployment manifests in your monitoring tools. Think of this like learning to read a map before you start navigating - you need to know what landmarks to look for and how they're represented.

## Deep Dive: IBM APIC Subsystems and Their Monitoring Footprints

### Management Subsystem - The Control Center

The Management subsystem acts as the brain of your APIC deployment, handling API lifecycle management and administrative functions. Here's exactly what you need to monitor and where to find it:

**Primary Endpoints to Monitor:**
```
Management API Health: https://<mgmt-cluster-hostname>/health
Management UI Portal: https://<mgmt-cluster-hostname>/admin
API Manager Health: https://<mgmt-cluster-hostname>/api/cloud/health
User Registry Status: https://<mgmt-cluster-hostname>/api/user-registries/health
OAuth Provider: https://<mgmt-cluster-hostname>/api/oauth-providers/health
```

**How This Appears in Dynatrace:**

When you navigate to Dynatrace, here's your step-by-step path to find Management subsystem components:

1. **Finding the Kubernetes Workloads:**
   - Go to Infrastructure → Kubernetes → Your EKS cluster name
   - Look for namespace typically named `apic-management` or similar
   - You'll see these key deployments:
     - `management-server` (the core management API)
     - `ui` (the administrative interface)
     - `juhu` (user interface backend services)
     - `turnstile` (authentication service)

2. **Locating Custom Resources in Dynatrace:**
   
   This is where many people get confused, so let me explain the relationship between Kubernetes Custom Resources and how Dynatrace sees them:

   **In the Kubernetes section of Dynatrace:**
   - Navigate to Infrastructure → Kubernetes → Your cluster → Custom Resources
   - Look specifically for these APIC Custom Resource types:
     - `ManagementCluster` - This represents your entire management subsystem
     - `ManagementEndpoint` - Individual service endpoints
     - `ManagementBackup` - Backup configuration status
   
   **What you'll see in the Dynatrace interface:**
   - Each Custom Resource appears as a separate entity
   - Click on any `ManagementCluster` CR to see its health status
   - The "Properties" tab shows the CR's current state (Ready, Pending, Failed)
   - The "Events" tab shows recent state changes and error conditions

3. **Service-Level Monitoring:**
   - Navigate to Applications & Microservices → Services
   - Filter by namespace containing "management"
   - Key services to locate:
     - `management-server` (appears as HTTP service)
     - `management-ui` (web application service)
     - `management-postgres` (database connection service)

**Critical Metrics for Management Subsystem:**
- Pod restart count (should be 0 for stable operations)
- API response time (baseline typically 200-500ms)
- Authentication success rate (should be >99%)
- Configuration sync status (check CR conditions)

### Gateway Subsystem - The Traffic Director

The Gateway subsystem handles all API traffic routing and enforcement. Understanding its monitoring footprint is crucial because this is where your customer-facing issues will first appear.

**Primary Endpoints to Monitor:**
```
Gateway Status: https://<gateway-hostname>/status
Gateway Health: https://<gateway-hostname>/health
API Invocation: https://<gateway-hostname>/api/health
Rate Limiting Status: https://<gateway-hostname>/rate-limit/health
Security Policies: https://<gateway-hostname>/security/health
```

**Deep Dive into Gateway Monitoring in Dynatrace:**

1. **Kubernetes Workload Identification:**
   - Infrastructure → Kubernetes → Cluster → Look for `apic-gateway` namespace
   - Key deployments you'll find:
     - `datapower-gateway` (the main traffic processing engine)
     - `gateway-peering` (handles cluster communication)
     - `rate-limit` (traffic throttling service)

2. **Understanding DataPower Gateway Monitoring:**
   
   Here's where it gets interesting - DataPower gateways have unique monitoring characteristics:
   
   **In Dynatrace Services view:**
   - The DataPower gateway appears as both a Kubernetes service AND as individual process groups
   - Navigate to Technologies → Processes and process groups
   - Look for processes named `datapower` or `dp-*`
   - Each gateway pod runs multiple internal processes that Dynatrace monitors separately

3. **Custom Resources for Gateway:**
   - `GatewayCluster` - Overall gateway cluster health
   - `GatewayService` - Individual gateway service definitions
   - `APIConnect` - The main APIC installation CR (this is the parent of all subsystems)

**Gateway-Specific Dynatrace Locations:**

To find gateway performance data:
- Applications & Microservices → Services → Filter by "gateway"
- Look at the service flow diagram - you should see traffic flowing from external sources through the gateway to backend services
- Check the "Response time" and "Failure rate" tabs for each gateway service

### Analytics Subsystem - The Data Intelligence Layer

The Analytics subsystem processes API usage data and generates reports. Its monitoring is often overlooked but critical for business intelligence.

**Primary Endpoints to Monitor:**
```
Analytics Health: https://<analytics-hostname>/health
Analytics API: https://<analytics-hostname>/api/health
Ingestion Status: https://<analytics-hostname>/analytics/ingestion/health
Processing Queue: https://<analytics-hostname>/analytics/processing/health
Storage Health: https://<analytics-hostname>/analytics/storage/health
```

**Finding Analytics in Dynatrace:**

1. **Kubernetes Components:**
   - Namespace: typically `apic-analytics`
   - Key deployments:
     - `analytics-ingestion` (data intake service)
     - `analytics-storage` (data persistence layer)
     - `analytics-proxy` (API interface)
     - `coordinating-service` (workflow orchestration)

2. **Analytics Custom Resources:**
   - `AnalyticsCluster` - Main analytics cluster status
   - `AnalyticsEndpoint` - Service endpoint configurations
   - Navigate to these through Infrastructure → Kubernetes → Custom Resources

3. **Data Flow Monitoring:**
   
   Understanding analytics data flow is crucial for effective monitoring:
   - Raw API data comes from Gateway subsystem
   - Gets processed by ingestion services
   - Stored in analytics storage (usually Elasticsearch)
   - Served through analytics proxy for reporting

   **In Dynatrace, track this flow:**
   - Services view: Look for services with "analytics" in the name
   - Follow the service flow from `gateway` → `analytics-ingestion` → `analytics-storage`
   - Monitor each hop for latency and error rates

### Developer Portal Subsystem - The Developer Experience Layer

The Developer Portal provides the interface for API consumers to discover and subscribe to APIs.

**Primary Endpoints to Monitor:**
```
Portal Health: https://<portal-hostname>/health
Portal API: https://<portal-hostname>/api/health
User Management: https://<portal-hostname>/user/health
API Catalog: https://<portal-hostname>/catalog/health
Documentation: https://<portal-hostname>/docs/health
```

**Portal Monitoring in Dynatrace:**

1. **Kubernetes Structure:**
   - Namespace: `apic-portal` or similar
   - Key components:
     - `portal-admin` (administrative backend)
     - `portal-www` (public-facing website)
     - `portal-db` (portal database connection)
     - `portal-nginx` (web server/proxy)

2. **Portal Custom Resources:**
   - `PortalCluster` - Overall portal health
   - `PortalService` - Individual portal service configurations

3. **User Experience Monitoring:**
   
   For the portal, user experience is paramount. Here's how to monitor it effectively:
   - Real User Monitoring (RUM): Check if RUM is enabled for portal URLs
   - Navigate to Frontend → Web applications
   - Look for your portal domain - this shows actual user experience data
   - Monitor page load times, JavaScript errors, and user actions

### PostgreSQL Database - The Persistent Data Layer

PostgreSQL serves as the backbone for most APIC subsystems, storing configuration, user data, and operational state.

**Database Endpoints and Health Checks:**
```
Primary Database Health: Direct connection to PostgreSQL port 5432
Replication Status: Check slave lag and replication health
Connection Pool: Monitor active/idle connections
WAL Status: Write-Ahead Log disk usage and archiving
```

**Finding PostgreSQL in Dynatrace:**

1. **Database Technology View:**
   - Navigate to Technologies → Databases
   - Look for PostgreSQL instances - they'll be named with your cluster/namespace identifiers
   - Each APIC subsystem typically has its own database instance

2. **Kubernetes Database Pods:**
   - Infrastructure → Kubernetes → Look for StatefulSets (not Deployments)
   - PostgreSQL runs as StatefulSets for data persistence
   - Names typically like `management-postgres-cluster`, `portal-postgres-cluster`

3. **Database Metrics Deep Dive:**
   
   **Understanding PostgreSQL monitoring in Dynatrace:**
   - Database connections view shows active connection count
   - Response time shows query performance
   - **Critical for APIC:** Monitor disk space usage - this is where the IBM documentation specifically warns about disk pressure

   **Disk Usage Monitoring (Critical for IBM APIC):**
   - Navigate to Infrastructure → Hosts
   - Find the nodes running PostgreSQL pods
   - Check disk usage for the persistent volume mounts
   - **Key threshold:** IBM recommends alerting at 85% disk usage

## Advanced Dynatrace Navigation for APIC Testing

### Understanding the Relationship Between Components

Think of your APIC deployment like a city with different districts (subsystems), and Dynatrace is your comprehensive city monitoring system. Here's how to navigate efficiently:

**The Top-Down Approach:**
1. Start at Infrastructure → Kubernetes → Your EKS cluster
2. This gives you the "city overview" - overall cluster health
3. Drill down to namespaces (districts)
4. Then to individual workloads (buildings)
5. Finally to processes and services (individual systems)

**The Service Flow Approach:**
1. Applications & Microservices → Services
2. Find your main API gateway service
3. Click on it and select "Service flow"
4. This shows you the entire request path through your APIC deployment
5. Use this to understand dependencies and identify monitoring gaps

### Testing Your Existing Alerts: Step-by-Step Methodology

Now that you understand where everything lives, let's test your existing alerting systematically:

**Phase 1: Alert Inventory and Mapping**

1. **Catalog Existing Alerts:**
   - Settings → Alerting → Problem alerting profiles
   - Document each profile and its target audience
   - Note which APIC components each profile covers

2. **Map Alerts to Components:**
   Create a mapping like this for each subsystem:
   - Management subsystem → Which alerts cover it?
   - Gateway subsystem → Which performance thresholds?
   - Analytics subsystem → What failure conditions trigger alerts?
   - Portal subsystem → User experience alerts configured?
   - PostgreSQL → Disk, performance, connection alerts?

**Phase 2: Controlled Alert Testing**

**For Management Subsystem Testing:**
1. Navigate to your Management Custom Resource in Dynatrace
2. Note the current health status
3. **Testing approach:** Scale down the management deployment temporarily
   - This simulates a component failure
   - Monitor how quickly alerts trigger
   - Verify correct team receives notifications
   - Scale back up and confirm recovery alerts

**For Gateway Performance Testing:**
1. Find your gateway service in the Services view
2. Note baseline response times and throughput
3. **Testing approach:** Generate controlled load
   - Use existing load testing tools to increase traffic
   - Monitor response time alerts
   - Verify rate limiting alerts if traffic exceeds thresholds
   - Test error rate alerts by introducing failing requests

**For Database Testing (Critical for APIC):**
1. Navigate to your PostgreSQL database instances
2. Check current disk usage levels
3. **Testing approach:** Simulate disk pressure
   - Create temporary large files in PostgreSQL data directory
   - Monitor disk usage alerts as they approach 85% threshold
   - Verify alerts escalate appropriately
   - Clean up test files and confirm alert recovery

**Phase 3: End-to-End Alert Flow Validation**

**Understanding Alert Correlation:**
APIC components are interdependent. When testing, pay attention to how alerts correlate:
- Gateway issues might trigger database connection alerts
- Management subsystem problems can cascade to portal issues
- Analytics ingestion failures might indicate gateway problems

**Testing Correlation Logic:**
1. Trigger a controlled failure in one subsystem
2. Monitor how other subsystem alerts respond
3. Verify that related alerts are properly correlated in Dynatrace
4. Ensure teams receive context about root cause vs. symptoms

## Practical Testing Scenarios

Let me provide you with specific, actionable test scenarios:

**Scenario 1: Management API Latency Test**
```
Objective: Verify management API performance alerts work correctly

Steps:
1. Locate management-server service in Dynatrace Services view
2. Note current response time baseline (typically 200-500ms)
3. Introduce controlled latency using traffic shaping or resource constraints
4. Monitor Services → management-server → Response Time tab
5. Verify alert triggers when response time exceeds threshold
6. Check that alert includes service flow context
7. Restore normal conditions and verify recovery alert
```

**Scenario 2: Gateway Error Rate Test**
```
Objective: Test gateway error rate alerting and team routing

Steps:
1. Navigate to gateway service in Dynatrace
2. Check current error rate (should be <1% typically)
3. Introduce failing API calls (return 500 errors)
4. Watch error rate climb in real-time
5. Verify error rate alert triggers at configured threshold
6. Confirm alert routes to API team, not platform team
7. Check that alert includes affected API details
```

**Scenario 3: Database Disk Pressure Test**
```
Objective: Validate PostgreSQL disk usage alerts (critical per IBM docs)

Steps:
1. Find PostgreSQL StatefulSet in Kubernetes view
2. Navigate to the underlying host
3. Check current disk usage on PostgreSQL persistent volumes
4. Simulate disk pressure by creating large temporary files
5. Monitor disk usage climbing toward 85% threshold
6. Verify warning alert at 80%, critical alert at 85%
7. Check that DBA team receives immediate notification
8. Clean up and verify recovery
```

This deep dive should give you the detailed understanding you need to effectively test your existing APIC monitoring. Each subsystem has its unique monitoring fingerprint in Dynatrace, and understanding these patterns will help you identify any gaps and validate that your alerts work as intended.

Would you like me to elaborate on any specific subsystem or dive deeper into particular testing scenarios?