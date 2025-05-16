# API Connect Access Management

## Overview

Access management for API Connect follows a defense-in-depth approach, combining multiple authentication and authorization mechanisms across different layers of the platform. This document provides a comprehensive guide for managing access securely.

## Authentication Methods

### Platform Authentication

| Interface | Method | Provider | MFA Required |
|-----------|--------|----------|-------------|
| Management UI | SAML | Okta | Yes |
| Developer Portal | OAuth 2.0 / OIDC | Okta | Self-service with approval |
| Gateway Admin | Certificate-based | Internal PKI | N/A |
| Kubernetes | OIDC | Okta | Yes |
| AWS Console | SAML Federation | Okta | Yes |
| Jenkins | LDAP | Active Directory | Yes |

### API Authentication

| Type | Use Case | Implementation | Management |
|------|----------|----------------|------------|
| API Key | Simple API access | Developer Portal | Self-service with approval |
| OAuth 2.0 | Secure app access | API Connect OAuth Provider | Self-service with approval |
| JWT | Microservice-to-microservice | Custom JWT issuer | Platform team |
| Mutual TLS | High-security backends | Certificate-based | Security team |
| HMAC | Legacy systems | Custom signature validation | Limited use cases |

## Environment Configuration

| Authentication Aspect | Development | Testing | Staging | Production | DR |
|-----------------------|-------------|---------|---------|------------|------------|
| MFA Enforcement | Optional | Required for admin | Required | Required | Required |
| Session Timeout | 24 hours | 12 hours | 8 hours | 4 hours | 4 hours |
| Failed Login Lockout | 10 attempts | 5 attempts | 5 attempts | 3 attempts | 3 attempts |
| IP Restrictions | None | None | Limited | Strict | Strict |
| Certificate Lifespan | 1 year | 1 year | 90 days | 90 days | 90 days |

## Authorization Models

### API Connect RBAC Model

| Role | Permissions | Assignable To |
|------|-------------|--------------|
| Administrator | All operations | Platform team only |
| Operator | Runtime management, no configuration | SRE team |
| Developer | Create and test APIs, no publishing | Development teams |
| API Administrator | Create, test, and publish APIs | API product owners |
| Consumer Organization Owner | Manage users and app registrations | External partners |
| Viewer | View resources only | Auditors, support staff |

### Kubernetes RBAC

| Role | Namespace Scope | Permissions | Users |
|------|-----------------|-------------|-------|
| cluster-admin | Cluster-wide | Full control | Platform admins only |
| admin | api-connect | Full namespace control | SRE team |
| edit | api-connect | Modify resources | DevOps team |
| view | api-connect | Read-only access | Development team |
| custom:jenkins | api-connect | Deployment permissions | Jenkins service account |

### AWS IAM

| Role | Permissions | Access Method | MFA Required |
|------|-------------|---------------|--------------|
| AdminRole | Full AWS access | SAML federation | Yes |
| PowerUserRole | Most services, no IAM | SAML federation | Yes |
| ReadOnlyRole | Read-only to all services | SAML federation | Yes |
| DeploymentRole | Specific deployment permissions | AssumeRole from Jenkins | N/A (service) |
| MonitoringRole | CloudWatch, X-Ray access | AssumeRole from monitoring | N/A (service) |

## Service Accounts

### Application Service Accounts

| Service Account | Purpose | Auth Method | Rotation |
|-----------------|---------|------------|----------|
| jenkins-deployer | CI/CD deployment | Certificate | 90 days |
| monitoring-service | Metrics collection | OAuth client | 180 days |
| backup-service | Automated backups | IAM role | 180 days |
| dr-sync | DR replication | Certificate | 90 days |
| test-automation | Automated testing | OAuth client | 180 days |

### Kubernetes Service Accounts

| Service Account | Namespace | Purpose | Permissions | Token Rotation |
|-----------------|-----------|---------|------------|----------------|
| api-gateway | api-connect | Gateway operations | Limited to gateway resources | 90 days |
| api-manager | api-connect | Management operations | Admin within namespace | 90 days |
| prometheus | monitoring | Metrics scraping | Read-only to specific resources | 90 days |
| fluentd | logging | Log collection | Log access only | 90 days |
| argocd | argocd | GitOps deployment | Deploy permissions | 30 days |

## Network Access Controls

### Network Segmentation

| Zone | Purpose | Access Restrictions | Inspection |
|------|---------|---------------------|------------|
| Public DMZ | External-facing services | Restricted by AWS WAF | Deep packet inspection |
| API Service Zone | API Gateway runtime | Internal only + ALB | TLS inspection |
| Management Zone | Admin components | VPN access only | TLS inspection |
| Database Zone | Data storage | API/Management zones only | Flow logs |
| Kubernetes Control | EKS control plane | Restricted CIDR ranges | Flow logs |

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

## Access Monitoring

| Event Type | Monitoring Tool | Alert Threshold | Response |
|------------|----------------|-----------------|----------|
| Failed Logins | Splunk | 5 in 5 minutes | Security team notification |
| Privileged Access | Splunk | Any usage | Logging and review |
| After-hours Access | Splunk | Any unusual time | Security team notification |
| Inactive Account Usage | Splunk | Any usage | Immediate investigation |
| Service Account Misuse | Splunk | Usage pattern change | Security team notification |

## Access Request Process

1. Request submission via [Access Management Portal](https://access.your-company.com)
2. Approvals:
   - Manager approval for all access
   - Security team approval for elevated access
   - Product owner approval for API publishing rights 
3. Automated provisioning via Okta
4. Quarterly access reviews

## References

- [Architecture](../Architecture) - Platform architecture
- [Runbook](../Runbook) - Operational procedures
- [SDLC](../SDLC) - Development processes
- [Observability](../Observability) - Monitoring configuration
- [IBM API Connect Security Documentation](https://www.ibm.com/docs/en/api-connect/10.0.1.x?topic=security)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)