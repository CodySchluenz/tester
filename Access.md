# API Connect Access Management

This page documents the access management policies, procedures, and configurations for the IBM API Connect platform deployed on AWS EKS.

## Overview

Access management for API Connect follows a defense-in-depth approach, combining multiple authentication and authorization mechanisms across different layers of the platform. This document provides a comprehensive guide for managing access securely.

### Access Management Principles

- **Least Privilege**: Users and systems are granted minimum access required for their role
- **Defense in Depth**: Multiple security controls at different layers
- **Segregation of Duties**: Critical operations require multiple approvers
- **Just-in-Time Access**: Elevated privileges granted only when needed
- **Comprehensive Auditing**: All access events are logged and monitored

## Authentication Methods

API Connect implements multiple authentication methods across different components and interfaces:

### Platform Authentication

| Interface | Authentication Method | Provider | Requirements |
|-----------|------------------------|----------|--------------|
| Management UI | SAML | Corporate SSO (Okta) | MFA Required |
| Developer Portal | OAuth 2.0 / OpenID Connect | Okta | Self-service registration with approval |
| Gateway Admin | Certificate-based | Internal PKI | Managed certificates |
| Kubernetes | OIDC | Corporate SSO (Okta) | Role-based with MFA |
| AWS Console | SAML Federation | Corporate SSO (Okta) | MFA Required |
| Jenkins | LDAP | Active Directory | MFA Required |

### API Authentication

| Auth Type | Use Case | Implementation | Management |
|-----------|----------|----------------|------------|
| API Key | Simple API access | Managed in Developer Portal | Self-service with approval |
| OAuth 2.0 | Secure application access | IBM API Connect OAuth Provider | Self-service with approval |
| JWT | Microservice-to-microservice | Custom JWT issuer | Managed by platform team |
| Mutual TLS | High-security backends | Certificate-based | Managed by security team |
| HMAC | Legacy systems | Custom signature validation | Limited use cases |

### Environment Comparison

| Authentication Aspect | Development | Testing | Staging | Production | DR |
|-----------------------|-------------|---------|---------|------------|------------|
| MFA Enforcement | Optional | Required for admin | Required | Required | Required |
| Session Timeout | 24 hours | 12 hours | 8 hours | 4 hours | 4 hours |
| Failed Login Lockout | 10 attempts | 5 attempts | 5 attempts | 3 attempts | 3 attempts |
| IP Restrictions | None | None | Limited | Strict | Strict |
| Certificate Lifespan | 1 year | 1 year | 90 days | 90 days | 90 days |

## Authorization Models

### API Connect RBAC Model

API Connect uses a role-based access control (RBAC) model with the following built-in roles:

| Role | Description | Permissions | Assignable To |
|------|-------------|-------------|--------------|
| Administrator | Full platform control | All operations | Platform team only |
| Operator | Platform operations | Runtime management, no configuration | SRE team |
| Developer | API creation | Create and test APIs, no publishing | Development teams |
| API Administrator | API lifecycle management | Create, test, and publish APIs | API product owners |
| Consumer Organization Owner | Manage developer organization | Manage users and app registrations | External partners |
| Viewer | Read-only access | View resources only | Auditors, support staff |

### Custom Roles

In addition to the built-in roles, custom roles have been created for specific needs:

| Role | Description | Permissions | Assignable To |
|------|-------------|-------------|--------------|
| Security Auditor | Security review | View resources, security policies | Security team |
| API Publisher | Publishing authority | Create, test, publish, but not delete | Release managers |
| Portal Administrator | Developer portal management | Full control of portal only | Portal team |
| Analytics Viewer | View API analytics | View analytics data only | Business analysts |

### Kubernetes RBAC

Access to the Kubernetes cluster is managed through RBAC:

| Role | Namespace Scope | Permissions | Users |
|------|-----------------|-------------|-------|
| cluster-admin | Cluster-wide | Full control | Platform admins only |
| admin | api-connect | Full namespace control | SRE team |
| edit | api-connect | Modify resources | DevOps team |
| view | api-connect | Read-only access | Development team |
| custom:jenkins | api-connect | Deployment permissions | Jenkins service account |

### AWS IAM

AWS access is managed through IAM roles with SAML federation:

| Role | Permissions | Access Method | MFA Required |
|------|-------------|---------------|--------------|
| AdminRole | Full AWS access | SAML federation | Yes |
| PowerUserRole | Most services, no IAM | SAML federation | Yes |
| ReadOnlyRole | Read-only to all services | SAML federation | Yes |
| DeploymentRole | Specific deployment permissions | AssumeRole from Jenkins | N/A (service) |
| MonitoringRole | CloudWatch, X-Ray access | AssumeRole from monitoring | N/A (service) |

## User Management

### User Provisioning

| User Type | Provisioning Process | Approval Required | Deprovisioning |
|-----------|----------------------|-------------------|----------------|
| Employees | HR system → Okta → API Connect | Role-based approval | Automated on termination |
| Contractors | Contractor system → Okta → API Connect | Manager + Security | Expiration date enforced |
| Partners | Self-registration → Approval workflow | API product owner | Manual or inactivity (90 days) |
| Customers | Self-registration → Email verification | None (email verification) | Inactivity (1 year) |

### Access Request Procedure

1. **Request Submission**:
   - Employee accesses [Access Management Portal](https://access.your-company.com)
   - Selects API Connect role and justification
   - Submits request with business purpose

2. **Approval Workflow**:
   - Manager approval required for all access
   - Security team approval for elevated access
   - Product owner approval for API publishing rights

3. **Provisioning**:
   - Approved requests automatically provisioned via Okta
   - User notified via email with access instructions
   - Training requirements identified if applicable

4. **Verification**:
   - Periodic access reviews (quarterly)
   - Automated anomaly detection
   - Usage monitoring and inactive account detection

### Access Review Process

| Review Type | Frequency | Reviewers | Actions |
|------------|-----------|-----------|---------|
| User Access Review | Quarterly | Managers, Security | Revoke unnecessary access |
| Privileged Access Review | Monthly | Security team | Verify continued need |
| Service Account Review | Quarterly | SRE team, Security | Rotate credentials if needed |
| External User Review | Semi-annually | API product owners | Remove inactive users |
| Entitlement Review | Annually | Security team | Update role definitions |

## Service Accounts

### Application Service Accounts

| Service Account | Purpose | Auth Method | Management | Rotation |
|-----------------|---------|------------|------------|----------|
| jenkins-deployer | CI/CD deployment | Certificate | SRE team | 90 days |
| monitoring-service | Metrics collection | OAuth client | SRE team | 180 days |
| backup-service | Automated backups | IAM role | SRE team | 180 days |
| dr-sync | DR replication | Certificate | SRE team | 90 days |
| test-automation | Automated testing | OAuth client | QA team | 180 days |

### Kubernetes Service Accounts

| Service Account | Namespace | Purpose | Permissions | Token Rotation |
|-----------------|-----------|---------|------------|----------------|
| api-gateway | api-connect | Gateway operations | Limited to gateway resources | 90 days |
| api-manager | api-connect | Management operations | Admin within namespace | 90 days |
| prometheus | monitoring | Metrics scraping | Read-only to specific resources | 90 days |
| fluentd | logging | Log collection | Log access only | 90 days |
| argocd | argocd | GitOps deployment | Deploy permissions | 30 days |

### Service Account Management

Service account credentials are managed securely:

1. **Storage**:
   - Kubernetes secrets for k8s service accounts
   - AWS Secrets Manager for application credentials
   - HashiCorp Vault for certificate private keys

2. **Rotation Process**:
   - Automated rotation via Jenkins pipeline
   - Scheduled based on rotation policy
   - Zero-downtime credential rotation

3. **Monitoring**:
   - All service account usage is logged
   - Alerts for unusual service account activity
   - Failed authentication attempts monitored

## Environment-Specific Access Controls

### Development Environment

- **Purpose**: Active development and testing
- **Access Model**: Broader access for development team
- **Special Considerations**:
  - Developers have elevated privileges
  - Service account credentials have longer lifetimes
  - Relaxed network policies

### Testing Environment

- **Purpose**: QA and automated testing
- **Access Model**: Testing team and CI/CD pipeline access
- **Special Considerations**:
  - Test automation service accounts
  - Integration test users with predefined roles
  - QA team has elevated access for test validation

### Staging Environment

- **Purpose**: Pre-production validation
- **Access Model**: Limited to release and SRE teams
- **Special Considerations**:
  - Production-like security controls
  - Temporary access for UAT
  - All production security monitoring enabled

### Production Environment

- **Purpose**: Business-critical operations
- **Access Model**: Highly restricted access
- **Special Considerations**:
  - Just-in-time privileged access
  - All changes through approved pipelines
  - Full audit logging and monitoring
  - Break-glass emergency access procedure

### DR Environment

- **Purpose**: Disaster recovery
- **Access Model**: Restricted to SRE team
- **Special Considerations**:
  - Emergency access procedures
  - Activated only during DR scenarios
  - Synchronized access control with production

## Network Access Controls

### Network Segmentation

| Zone | Purpose | Access Restrictions | Inspection |
|------|---------|---------------------|------------|
| Public DMZ | External-facing services | Restricted by AWS WAF | Deep packet inspection |
| API Service Zone | API Gateway runtime | Internal only + ALB | TLS inspection |
| Management Zone | Admin components | VPN access only | TLS inspection |
| Database Zone | Data storage | API/Management zones only | Flow logs |
| Kubernetes Control | EKS control plane | Restricted CIDR ranges | Flow logs |

### Firewall Rules

| Source | Destination | Ports | Protocol | Purpose |
|--------|-------------|-------|----------|---------|
| Internet | ALB | 443 | HTTPS | API access |
| VPN | Management Zone | 443 | HTTPS | Admin access |
| Management Zone | API Service Zone | 9443 | HTTPS | API management |
| API Service Zone | Database Zone | 5432 | PostgreSQL | Data access |
| Bastion Host | All Zones | 22 | SSH | Emergency access |

### AWS Security Groups

| Security Group | Purpose | Inbound Rules | Outbound Rules |
|----------------|---------|---------------|----------------|
| alb-sg | Load balancer traffic | 80, 443 from internet | All to API-SG |
| api-sg | API Gateway traffic | 9443 from ALB-SG | DB, monitoring ports |
| mgmt-sg | Management components | 443 from VPN CIDR | DB, API, monitoring ports |
| db-sg | Database access | 5432 from API-SG, MGMT-SG | None |
| monitoring-sg | Monitoring components | Custom ports from all internal | HTTPS to internet |

## Secrets Management

### Secrets Storage Solutions

| Secret Type | Storage Solution | Access Method | Backup Strategy |
|-------------|------------------|---------------|-----------------|
| API Credentials | AWS Secrets Manager | IAM roles | Cross-region replication |
| TLS Certificates | AWS Certificate Manager | IAM roles | Cross-region replication |
| Database Credentials | AWS Secrets Manager | IAM roles | Cross-region replication |
| Encryption Keys | AWS KMS | IAM roles | Cross-region replication |
| OAuth Client Secrets | API Connect internal DB | API Connect RBAC | Database backup |
| SSH Keys | HashiCorp Vault | Vault authentication | Multiple replicas |

### Encryption Standards

| Data Type | Encryption Standard | Key Management | Rotation |
|-----------|---------------------|----------------|----------|
| Data at Rest | AES-256 | AWS KMS | Annual |
| Data in Transit | TLS 1.2+ | ACM | 90 days |
| Secrets | AES-256 | AWS KMS | Annual |
| Databases | AES-256 | AWS KMS | Annual |
| Backups | AES-256 | AWS KMS | Annual |

## Monitoring and Alerting

### Access Monitoring

| Event Type | Monitoring Tool | Alert Threshold | Response |
|------------|----------------|-----------------|----------|
| Failed Logins | Splunk | 5 in 5 minutes | Security team notification |
| Privileged Access | Splunk | Any usage | Logging and review |
| After-hours Access | Splunk | Any unusual time | Security team notification |
| Inactive Account Usage | Splunk | Any usage | Immediate investigation |
| Service Account Misuse | Splunk | Usage pattern change | Security team notification |

### Security Alerting

Critical security alerts are routed to:

1. **Security Team**: Via PagerDuty for immediate response
2. **SRE Team**: Via Slack for operational awareness
3. **Management**: Daily summary reports
4. **SIEM System**: For correlation with other security events

## Access Request Forms

### API Connect Access Request

Access to API Connect can be requested through the [Access Management Portal](https://access.your-company.com) by providing:

1. **User Information**:
   - Name and email
   - Department and manager
   - Job role and function

2. **Access Requirements**:
   - Environment(s) needed
   - Role(s) requested
   - Justification for access

3. **Approval Workflow**:
   - Manager approval
   - API Platform team approval
   - Security team approval (for elevated access)

4. **Duration**:
   - Permanent or temporary access
   - End date for temporary access
   - Review date for permanent access

### AWS Access Request

AWS access follows a similar process with additional scrutiny:

1. **User Information**: Standard user details
2. **AWS Role Requested**: Based on job requirements
3. **Resources Needed**: Specific services and resources
4. **Business Justification**: Clear business need
5. **Approval Requirements**: Manager and security approval

## References

- [Runbook](../Runbook) - Operational procedures including security incidents
- [Architecture](../Architecture) - Platform architecture and security design
- [SDLC](../SDLC) - Development processes and security integration
- [Observability](../Observability) - Monitoring and alerting configuration
- [IBM API Connect Security Documentation](https://www.ibm.com/docs/en/api-connect/10.0.1.x?topic=security)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
