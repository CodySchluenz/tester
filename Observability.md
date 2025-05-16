# API Connect Observability

This page documents the monitoring, logging, and observability practices for our IBM API Connect platform running on AWS EKS.

## Monitoring Strategy

Our monitoring approach follows these key principles:
- Complete visibility across all platform components
- Proactive detection of issues before they impact users
- Clear ownership and escalation paths for alerts
- Comprehensive logging for troubleshooting and audit
- Metrics-driven performance analysis and capacity planning

## Monitoring Tools

### Dynatrace

Dynatrace provides our primary Application Performance Monitoring (APM) solution with full-stack visibility across our API Connect platform.

#### Dynatrace Environment

- [Dynatrace Tenant](https://your-tenant.dynatrace.com/)
- Environment: Production
- Management Zone: API-Connect

#### Key Dashboards

| Dashboard | Purpose | Link | Primary Audience |
|-----------|---------|------|-----------------|
| API Connect Overview | Platform health summary | [Dashboard Link](https://your-tenant.dynatrace.com/dashboards/api-connect-overview) | All Teams |
| Gateway Performance | Detailed gateway metrics | [Dashboard Link](https://your-tenant.dynatrace.com/dashboards/gateway-performance) | SRE Team |
| API Performance | API-level performance metrics | [Dashboard Link](https://your-tenant.dynatrace.com/dashboards/api-performance) | SRE, API Teams |
| Infrastructure Health | EKS and AWS resources | [Dashboard Link](https://your-tenant.dynatrace.com/dashboards/infra-health) | SRE Team |
| Business Impact | Business KPIs and user experience | [Dashboard Link](https://your-tenant.dynatrace.com/dashboards/business-impact) | Product, Business Teams |

#### Synthetic Monitors

| Monitor Name | Test Frequency | Type | Link |
|--------------|----------------|------|------|
| API Gateway Health | 5 minutes | HTTP | [Monitor Link](https://your-tenant.dynatrace.com/synthetics/api-gw-health) |
| OAuth Flow | 15 minutes | Browser | [Monitor Link](https://your-tenant.dynatrace.com/synthetics/oauth-flow) |
| Developer Portal | 10 minutes | Browser | [Monitor Link](https://your-tenant.dynatrace.com/synthetics/dev-portal) |
| Critical APIs | 5 minutes | HTTP | [Monitor Link](https://your-tenant.dynatrace.com/synthetics/critical-apis) |

#### Problem Detection

Dynatrace automatically detects problems using anomaly detection and configured thresholds. Problem settings are configured in:
- [Problem Detection Settings](https://your-tenant.dynatrace.com/settings/anomalydetection)
- [Alerting Profiles](https://your-tenant.dynatrace.com/settings/alertingprofiles)

### Splunk

Splunk provides our log aggregation, analysis, and search capabilities.

#### Splunk Environment

- [Splunk Instance](https://splunk.your-company.com/)
- Main Index: `api_connect`
- Retention: 30 days hot, 90 days cold

#### Key Dashboards

| Dashboard | Purpose | Link | Primary Audience |
|-----------|---------|------|-----------------|
| API Connect Overview | Log summary and error trends | [Dashboard Link](https://splunk.your-company.com/en-US/app/search/api_connect_overview) | SRE Team |
| Error Analysis | Detailed error investigation | [Dashboard Link](https://splunk.your-company.com/en-US/app/search/error_analysis) | SRE, Development |
| Security Events | Security-focused events | [Dashboard Link](https://splunk.your-company.com/en-US/app/search/security_events) | Security Team |
| Audit Trail | User and system actions | [Dashboard Link](https://splunk.your-company.com/en-US/app/search/audit_trail) | Compliance, Security |
| API Usage | API traffic and consumption | [Dashboard Link](https://splunk.your-company.com/en-US/app/search/api_usage) | Product, Business Teams |

#### Saved Searches

| Search Name | Purpose | Schedule | Link |
|-------------|---------|----------|------|
| Critical Errors | Detect critical error conditions | Every 5 min | [Search Link](https://splunk.your-company.com/en-US/app/search/saved/critical_errors) |
| Rate Limit Breaches | Monitor rate limiting | Every 15 min | [Search Link](https://splunk.your-company.com/en-US/app/search/saved/rate_limit_breaches) |
| Certificate Issues | Detect TLS/cert problems | Hourly | [Search Link](https://splunk.your-company.com/en-US/app/search/saved/certificate_issues) |
| Unusual Patterns | ML-based anomaly detection | Hourly | [Search Link](https://splunk.your-company.com/en-US/app/search/saved/unusual_patterns) |

## Log Management

### Log Sources

| Component | Log Type | Collection Method | Destination |
|-----------|----------|------------------|------------|
| API Gateway | Application Logs | Fluentd DaemonSet | Splunk `api_connect` index |
| API Gateway | Access Logs | Fluentd DaemonSet | Splunk `api_connect_access` index |
| API Manager | Application Logs | Fluentd DaemonSet | Splunk `api_connect` index |
| Developer Portal | Application Logs | Fluentd DaemonSet | Splunk `api_connect` index |
| Kubernetes | Container Logs | Fluentd DaemonSet | Splunk `kubernetes` index |
| Kubernetes | Control Plane Logs | CloudWatch | Splunk `kubernetes_control` index |
| AWS Load Balancers | Access Logs | S3 + Lambda | Splunk `aws_elb` index |
| AWS CloudTrail | API Activity | CloudTrail | Splunk `aws_cloudtrail` index |

### Log Configuration

For standardized logging across our platform, we use the following configuration:

#### API Connect Components Log Format

```yaml
# ConfigMap section for API Connect logging
logging:
  level: info  # Options: debug, info, warn, error
  format: json
  timestamp_format: iso8601
  include_correlation_id: true
  redact_sensitive_data: true
```

#### Fluentd Configuration

The Fluentd configuration is maintained in:
- [GitHub: API Connect Fluentd Config](https://github.com/your-org/api-connect-infra/tree/main/logging/fluentd)

Key customizations include:
- Kubernetes metadata enrichment
- JSON parsing for structured logs
- Field extraction for API operation data
- PII data masking

### Log Retention Policy

| Environment | Hot Storage | Warm Storage | Cold Storage |
|-------------|-------------|--------------|--------------|
| Production | 30 days | 90 days | 1 year |
| Non-Production | 15 days | 45 days | 90 days |

## Metrics & KPIs

### Platform Health Metrics

| Metric | Description | Source | Alert Threshold | Owner |
|--------|-------------|--------|----------------|-------|
| Gateway Availability | % of successful health checks | Dynatrace Synthetic | <99.9% | SRE Team |
| API Success Rate | % of API calls with 2xx/3xx status | Dynatrace | <99.5% | SRE Team |
| Avg Response Time | Average API response time | Dynatrace | >500ms | SRE Team |
| Error Rate | % of 5xx responses | Dynatrace | >1% | SRE Team |
| CPU Utilization | Node-level CPU usage | Dynatrace | >80% | SRE Team |
| Memory Utilization | Node-level memory usage | Dynatrace | >80% | SRE Team |
| Pod Restarts | Count of pod restarts | Kubernetes API | >3 in 15min | SRE Team |
| Database Connections | Number of active DB connections | RDS Metrics | >80% pool size | DBA Team |

### Business KPIs

| KPI | Description | Source | Target | Owner |
|-----|-------------|--------|--------|-------|
| API Traffic | Total API calls per minute | Dynatrace | Based on forecast | Product Team |
| Developer Portal Registrations | New developer signups | Custom Metrics | Based on targets | Product Team |
| API Onboarding Time | Time to publish new APIs | Custom Metrics | <2 days | API Team |
| API Latency | 95th percentile response time | Dynatrace | <200ms | SRE Team |
| Subscription Growth | New API subscriptions | Custom Metrics | Based on targets | Product Team |

## Alerting Configuration

### Alert Severity Levels

| Severity | Description | Response Time | Notification Method |
|----------|-------------|---------------|---------------------|
| Critical (P1) | Service unavailability, data loss risk | <15 minutes | PagerDuty, SMS, Email |
| High (P2) | Degraded performance, potential customer impact | <30 minutes | PagerDuty, Email |
| Medium (P3) | Non-customer impacting issues | <2 hours | Email, Slack |
| Low (P4) | Minor issues, informational | Next business day | Slack |

### Dynatrace Alerting Profiles

| Profile | Purpose | Configuration | Notification |
|---------|---------|--------------|--------------|
| Critical Infrastructure | Gateway, Manager service outages | [Configuration Link](https://your-tenant.dynatrace.com/settings/alertingprofiles/critical-infra) | PagerDuty |
| Performance Issues | Slow response, high resource usage | [Configuration Link](https://your-tenant.dynatrace.com/settings/alertingprofiles/performance) | Email, Slack |
| Error Spikes | Unusual error patterns | [Configuration Link](https://your-tenant.dynatrace.com/settings/alertingprofiles/error-spikes) | Email, Slack |
| Security Issues | Certificate, authentication problems | [Configuration Link](https://your-tenant.dynatrace.com/settings/alertingprofiles/security) | Email, PagerDuty |

### ServiceNow Integration

Alerts from Dynatrace and Splunk automatically create tickets in ServiceNow using these integrations:
- [Dynatrace ServiceNow Integration](https://your-tenant.dynatrace.com/settings/integration/servicenow)
- [Splunk ServiceNow Integration](https://splunk.your-company.com/en-US/app/splunk_app_for_servicenow)

Configuration details:
- Ticket Assignment Rules: [Link to Configuration](https://service-now.your-company.com/rules)
- Ticket Templates: [Link to Templates](https://service-now.your-company.com/templates)
- SLA Definitions: [Link to SLAs](https://service-now.your-company.com/slas)

## Health Checks

### API Gateway Health Checks

Internal health check endpoint: `https://api.your-domain.com/health`
External health check endpoint: `https://api.your-domain.com/public-health`

Health check configuration:
```yaml
healthcheck:
  enabled: true
  path: /health
  port: 9443
  livenessProbe:
    initialDelaySeconds: 60
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 3
  readinessProbe:
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 3
```

### Load Balancer Health Checks

AWS Application Load Balancer health checks:
- Path: `/health`
- Protocol: HTTPS
- Port: 9443
- Interval: 30 seconds
- Timeout: 5 seconds
- Healthy threshold: 2
- Unhealthy threshold: 3

### Synthetic API Tests

Critical API health verification:
- [Authentication Flow Test](https://your-tenant.dynatrace.com/synthetics/auth-flow)
- [Create API Test](https://your-tenant.dynatrace.com/synthetics/create-api)
- [Subscribe API Test](https://your-tenant.dynatrace.com/synthetics/subscribe-api)
- [Gateway Performance Test](https://your-tenant.dynatrace.com/synthetics/gateway-perf)

## Visualization & Reporting

### Executive Dashboards

Business-focused dashboards showing API platform performance:
- [API Platform KPIs](https://your-tenant.dynatrace.com/dashboards/executive-kpis)
- [Monthly Business Review](https://your-tenant.dynatrace.com/dashboards/monthly-review)

### Operational Dashboards

SRE dashboards for real-time monitoring:
- [NOC Overview](https://your-tenant.dynatrace.com/dashboards/noc-overview)
- [Incident Response](https://your-tenant.dynatrace.com/dashboards/incident-response)

### Reporting

Automated reports generated and distributed:
- Weekly Performance Report: [Configuration](https://your-tenant.dynatrace.com/settings/reports/weekly-perf)
- Monthly Capacity Planning: [Configuration](https://your-tenant.dynatrace.com/settings/reports/capacity)
- Quarterly Service Review: [Template](https://sharepoint.your-company.com/sites/sre/qsr-template)

## Runbooks & Procedures

### Monitoring System Management

- [Dynatrace Configuration Management](../../Runbook#dynatrace-configuration)
- [Splunk Maintenance](../../Runbook#splunk-maintenance)
- [Alert Tuning Process](../../Runbook#alert-tuning)
- [Dashboard Creation Guidelines](../../SDLC#monitoring-standards)

### Troubleshooting with Monitoring Tools

- [Using Splunk for Log Investigation](../../Runbook#splunk-investigation)
- [Dynatrace Problem Analysis](../../Runbook#dynatrace-problems)
- [Performance Analysis Workflow](../../Runbook#performance-analysis)
- [Root Cause Determination](../../Runbook#root-cause-analysis)

## Observability as Code

Our observability configurations are managed as code:
- [GitHub: Monitoring as Code Repo](https://github.com/your-org/monitoring-as-code)
- [Terraform Configuration for Dashboards](https://github.com/your-org/monitoring-as-code/tree/main/dashboards)
- [Alert Configuration as Code](https://github.com/your-org/monitoring-as-code/tree/main/alerts)
- [Synthetic Test Definitions](https://github.com/your-org/monitoring-as-code/tree/main/synthetic)

## SLIs/SLOs

### Service Level Indicators

| Service | SLI | Measurement Method | Current Performance |
|---------|-----|---------------------|---------------------|
| API Gateway | Availability | Synthetic tests | [SLI Dashboard](https://your-tenant.dynatrace.com/sli/gateway-availability) |
| API Gateway | Latency | API response times | [SLI Dashboard](https://your-tenant.dynatrace.com/sli/gateway-latency) |
| Developer Portal | Availability | Synthetic tests | [SLI Dashboard](https://your-tenant.dynatrace.com/sli/portal-availability) |
| API Manager | Availability | Synthetic tests | [SLI Dashboard](https://your-tenant.dynatrace.com/sli/manager-availability) |
| API Manager | Functionality | Key operation tests | [SLI Dashboard](https://your-tenant.dynatrace.com/sli/manager-functionality) |

### Service Level Objectives

| Service | SLO | Target | Measurement Window | Status |
|---------|-----|--------|---------------------|--------|
| API Gateway | Availability | 99.95% | 30-day rolling | [SLO Dashboard](https://your-tenant.dynatrace.com/slo/gateway-availability) |
| API Gateway | Latency (p95) | <300ms | 30-day rolling | [SLO Dashboard](https://your-tenant.dynatrace.com/slo/gateway-latency) |
| Developer Portal | Availability | 99.9% | 30-day rolling | [SLO Dashboard](https://your-tenant.dynatrace.com/slo/portal-availability) |
| API Manager | Availability | 99.9% | 30-day rolling | [SLO Dashboard](https://your-tenant.dynatrace.com/slo/manager-availability) |
| Overall Platform | Error Rate | <0.1% | 30-day rolling | [SLO Dashboard](https://your-tenant.dynatrace.com/slo/platform-errors) |

## References

- [Dynatrace Documentation](https://www.dynatrace.com/support/help/)
- [Splunk Documentation](https://docs.splunk.com/)
- [IBM API Connect Metrics Reference](https://www.ibm.com/docs/en/api-connect/10.0.1.x?topic=monitoring-metrics-reference)
- [EKS Monitoring Best Practices](https://aws.amazon.com/blogs/mt/best-practices-for-monitoring-amazon-eks-with-amazon-cloudwatch-container-insights/)
