# API Connect Team Onboarding Guide

Welcome to the API Connect SRE team! This guide will help you get all necessary access, tools, and setup completed to effectively support our IBM API Connect platform. Complete all sections that apply to your role.

## Onboarding Checklist

Use this checklist to track your progress through the onboarding process:

### Week 1: Basic Setup
- [ ] Complete HR/IT security training requirements
- [ ] Obtain laptop and basic access
- [ ] Set up core communication tools
- [ ] Request initial access permissions
- [ ] Complete required security training

### Week 2: Platform Access
- [ ] Obtain AWS console access
- [ ] Set up kubectl and EKS access
- [ ] Configure monitoring tool access
- [ ] Set up development environment access
- [ ] Complete API Connect overview training

### Week 3: Advanced Tools
- [ ] Set up advanced monitoring and alerting
- [ ] Configure CI/CD pipeline access
- [ ] Complete shadowing with experienced team member
- [ ] Review platform documentation
- [ ] Complete first week on-call shadow

### Week 4: Full Integration
- [ ] Independent troubleshooting exercises
- [ ] Complete all outstanding access requests
- [ ] Final review with team lead
- [ ] Begin taking on production responsibilities

## Required Access and Permissions

### Active Directory Groups

Request membership to the following AD groups through your manager or IT:

| AD Group | Purpose | Required For |
|----------|---------|--------------|
| `API-Connect-SRE` | Core SRE team access | All team members |
| `API-Connect-Admins` | Administrative access to API Connect | Senior SREs |
| `AWS-API-Connect-PowerUsers` | AWS console access | All team members |
| `EKS-API-Connect-Operators` | Kubernetes cluster access | All team members |
| `ServiceNow-API-Connect` | ServiceNow ticket access | All team members |
| `Splunk-API-Connect-Users` | Splunk log access | All team members |
| `Dynatrace-API-Connect-Users` | Dynatrace monitoring access | All team members |
| `Jenkins-API-Connect-Users` | CI/CD pipeline access | All team members |
| `GitHub-Enterprise-API-Team` | Code repository access | All team members |

### SAML/SSO Applications

Ensure you have access to these SAML applications through corporate SSO:

| Application | Purpose | Access URL |
|-------------|---------|------------|
| AWS Console | AWS infrastructure management | https://your-org.awsapps.com/start |
| Dynatrace | Application performance monitoring | https://your-tenant.dynatrace.com |
| Splunk | Log analysis and search | https://splunk.your-company.com |
| ServiceNow | Incident and change management | https://your-instance.service-now.com |
| Jenkins | CI/CD pipeline management | https://jenkins.your-company.com |
| GitHub Enterprise | Source code management | https://github.your-company.com |

## Required Software and Tools

### Development Environment Setup

#### Essential Command Line Tools

Install these tools on your workstation:

'''bash
# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# jq for JSON processing
sudo apt install jq

# yq for YAML processing
sudo snap install yq
'''

#### Container and Development Tools

'''bash
# Docker
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER

# Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# VS Code with extensions
sudo snap install code --classic
# Install extensions: Kubernetes, AWS Toolkit, Docker
'''

#### Monitoring and Troubleshooting Tools

'''bash
# PostgreSQL client tools
sudo apt install postgresql-client

# Network troubleshooting
sudo apt install net-tools dnsutils curl wget telnet

# Performance monitoring
sudo apt install htop iotop

# Text processing
sudo apt install vim nano grep sed awk
'''

### Browser Extensions

Install these browser extensions for enhanced productivity:

| Extension | Purpose | Browser |
|-----------|---------|---------|
| AWS Extend Switch Roles | Quick AWS account switching | Chrome/Firefox |
| JSON Formatter | Format JSON responses | Chrome/Firefox |
| Dynatrace Browser Extension | Enhanced Dynatrace integration | Chrome |
| LastPass/1Password | Password management | Chrome/Firefox |

### Desktop Applications

Install these applications:

| Application | Purpose | Download Link |
|-------------|---------|---------------|
| Microsoft Teams | Communication and collaboration | Microsoft Store |
| Slack (if used) | Team communication | https://slack.com/downloads |
| Postman | API testing | https://www.postman.com/downloads/ |
| DBeaver | Database management | https://dbeaver.io/download/ |
| JMeter | Performance testing | https://jmeter.apache.org/download_jmeter.cgi |

## Platform-Specific Setup

### AWS Configuration

1. **Configure AWS CLI:**
   '''bash
   aws configure sso
   # Follow prompts to set up SSO
   
   # Test access
   aws sts get-caller-identity
   aws eks list-clusters --region us-east-1
   '''

2. **Set up AWS profiles in ~/.aws/config:**
   '''ini
   [profile api-connect-prod]
   sso_start_url = https://your-org.awsapps.com/start
   sso_region = us-east-1
   sso_account_id = 123456789012
   sso_role_name = API-Connect-PowerUser
   region = us-east-1
   
   [profile api-connect-staging]
   sso_start_url = https://your-org.awsapps.com/start
   sso_region = us-east-1
   sso_account_id = 123456789013
   sso_role_name = API-Connect-PowerUser
   region = us-east-1
   '''

### Kubernetes (EKS) Setup

1. **Configure kubectl for each environment:**
   '''bash
   # Production
   aws eks update-kubeconfig --region us-east-1 --name api-connect-prod-cluster --profile api-connect-prod
   
   # Staging
   aws eks update-kubeconfig --region us-east-1 --name api-connect-staging-cluster --profile api-connect-staging
   
   # Verify access
   kubectl get nodes
   kubectl get pods -n api-connect
   '''

2. **Set up kubectl contexts:**
   '''bash
   # Rename contexts for clarity
   kubectl config rename-context arn:aws:eks:us-east-1:123456789012:cluster/api-connect-prod-cluster prod
   kubectl config rename-context arn:aws:eks:us-east-1:123456789013:cluster/api-connect-staging-cluster staging
   
   # View contexts
   kubectl config get-contexts
   
   # Switch contexts
   kubectl config use-context prod
   '''

### Monitoring Tools Setup

#### Dynatrace Access

1. **Log in to Dynatrace:** https://your-tenant.dynatrace.com
2. **Request API token** from team lead for automation scripts
3. **Bookmark key dashboards:**
   - [API Connect Overview](https://your-tenant.dynatrace.com/api-connect-overview)
   - [Gateway Performance](https://your-tenant.dynatrace.com/gateway-performance)
   - [SLO Dashboard](https://your-tenant.dynatrace.com/slo-dashboard)

#### Splunk Access

1. **Log in to Splunk:** https://splunk.your-company.com
2. **Install Splunk apps:**
   - API Connect Dashboard App
   - AWS Add-on for Splunk
3. **Bookmark useful searches:**
   - Gateway error analysis
   - Authentication failure tracking
   - Performance monitoring queries

### ServiceNow Configuration

1. **Log in to ServiceNow:** https://your-instance.service-now.com
2. **Set up personal preferences:**
   - Notification settings
   - Dashboard customization
   - Favorite filters
3. **Request assignment to API Connect assignment group**

### Jenkins Access

1. **Log in to Jenkins:** https://jenkins.your-company.com
2. **Request access to API Connect job folders**
3. **Set up Jenkins CLI** (optional):
   '''bash
   # Download Jenkins CLI
   wget https://jenkins.your-company.com/jnlpJars/jenkins-cli.jar
   
   # Configure alias
   echo 'alias jenkins-cli="java -jar ~/jenkins-cli.jar -s https://jenkins.your-company.com -auth username:api-token"' >> ~/.bashrc
   '''

## Communication Setup

### Microsoft Teams

1. **Join required Teams channels:**
   - API Connect SRE Team (primary team communication)
   - API Connect Alerts (monitoring alerts)
   - API Connect Changes (change notifications)
   - Platform Engineering (broader platform discussions)

2. **Configure notification settings:**
   - Enable notifications for @mentions and keywords
   - Set quiet hours appropriately
   - Configure mobile app notifications

3. **Install Teams mobile app** for on-call availability

### Contact Information

Add these contacts to your phone and Teams:

| Role | Name | Phone | Teams |
|------|------|-------|-------|
| SRE Team Lead | [Name] | [Phone] | @[username] |
| Senior SRE | [Name] | [Phone] | @[username] |
| Platform Engineering Manager | [Name] | [Phone] | @[username] |
| On-Call Coordinator | [Name] | [Phone] | @[username] |

### Emergency Contacts

For critical incidents outside business hours:

| Escalation Level | Contact Method | Expected Response |
|------------------|----------------|-------------------|
| Primary On-Call | PagerDuty alert | 15 minutes |
| Secondary On-Call | PagerDuty alert | 30 minutes |
| Team Lead | Phone call | 45 minutes |
| Engineering Manager | Phone call | 1 hour |

## Learning Resources

### Required Reading

Complete these in your first two weeks:

1. **Platform Documentation (this wiki):**
   - [Main Runbook](Main-Runbook) - Platform overview
   - [Architecture](Architecture) - System design
   - [Observability](Observability) - Monitoring overview
   - [Operations Runbook](Operations-Runbook) - Daily operations

2. **External Documentation:**
   - [IBM API Connect Documentation](https://www.ibm.com/docs/en/api-connect)
   - [AWS EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
   - [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)

### Training Modules

Complete these training modules (links provided by team lead):

| Module | Duration | Priority | Provider |
|--------|----------|----------|----------|
| API Connect Overview | 2 hours | High | Internal |
| AWS EKS Fundamentals | 4 hours | High | AWS Training |
| Kubernetes Operations | 6 hours | High | Linux Academy |
| Dynatrace Fundamentals | 2 hours | Medium | Dynatrace University |
| Splunk Search Fundamentals | 3 hours | Medium | Splunk Education |
| ServiceNow ITSM Basics | 2 hours | Low | ServiceNow |

### Hands-On Exercises

Work through these exercises with a mentor:

1. **Week 1: Basic Operations**
   - Check platform health using dashboards
   - Review recent alerts and incidents
   - Practice kubectl basic commands
   - Navigate Splunk for log analysis

2. **Week 2: Troubleshooting**
   - Investigate a simulated gateway issue
   - Practice database connectivity troubleshooting
   - Work through a certificate renewal scenario
   - Complete a performance analysis exercise

3. **Week 3: Incident Response**
   - Shadow during incident response
   - Practice escalation procedures
   - Complete post-incident review process
   - Learn change management procedures

## Role-Specific Setup

### SRE Engineers

Additional setup for SRE role:

1. **PagerDuty Access:**
   - Request PagerDuty account
   - Configure mobile app
   - Set up on-call schedule integration

2. **Advanced Monitoring:**
   - Set up personal dashboards in Dynatrace
   - Configure custom Splunk alerts
   - Set up AWS CloudWatch custom dashboards

3. **Automation Tools:**
   - Clone automation scripts repository
   - Set up local automation environment
   - Configure personal automation credentials

### Senior SREs

Additional setup for senior SRE role:

1. **Administrative Access:**
   - Request elevated AWS permissions
   - API Connect administrative access
   - Jenkins administrative access

2. **Change Management:**
   - ServiceNow CAB member access
   - Change approval permissions
   - Emergency change authority

### Team Leads

Additional setup for team lead role:

1. **Management Tools:**
   - Access to team productivity metrics
   - Budget and cost management tools
   - Performance review systems

2. **Vendor Relations:**
   - IBM Support portal access
   - AWS Enterprise Support contact
   - Vendor escalation contacts

## Security Requirements

### Security Training

Complete these security requirements in your first week:

1. **Corporate Security Training** (mandatory)
2. **Cloud Security Fundamentals**
3. **Incident Response Training**
4. **Data Protection and Privacy Training**

### Security Best Practices

Follow these security practices:

1. **Access Management:**
   - Use corporate SSO for all applications
   - Enable MFA on all accounts
   - Use principle of least privilege
   - Regularly review and rotate credentials

2. **Development Security:**
   - Never commit secrets to repositories
   - Use secure credential storage (AWS Secrets Manager, etc.)
   - Follow secure coding practices
   - Regularly update dependencies and tools

3. **Operational Security:**
   - Use jump boxes for production access
   - Log all administrative activities
   - Follow change management procedures
   - Report security incidents immediately

## Validation and Sign-off

### Self-Validation Checklist

Before considering onboarding complete, verify you can:

- [ ] Log into all required systems and applications
- [ ] Access production and non-production environments
- [ ] View monitoring dashboards and understand key metrics
- [ ] Execute basic troubleshooting commands
- [ ] Create and update ServiceNow tickets
- [ ] Navigate the platform documentation
- [ ] Contact appropriate team members and escalation paths
- [ ] Follow emergency procedures

### Team Lead Sign-off

Schedule a sign-off meeting with your team lead to review:

1. **Access Verification:**
   - Demonstrate access to all required systems
   - Show understanding of security requirements
   - Confirm emergency contact information

2. **Knowledge Assessment:**
   - Explain platform architecture at high level
   - Demonstrate basic troubleshooting skills
   - Show understanding of team processes

3. **Readiness for Production:**
   - Complete first incident shadow
   - Demonstrate change management understanding
   - Show readiness for on-call rotation

### Ongoing Development

After initial onboarding, continue learning through:

1. **Monthly Team Training Sessions**
2. **Vendor-Provided Training Opportunities**
3. **Conference Attendance (as approved)**
4. **Cross-Training with Other Teams**
5. **Professional Certification Programs**

## Getting Help

### During Onboarding

| Issue Type | Contact | Method |
|------------|---------|--------|
| Access Problems | IT Service Desk | ServiceNow ticket |
| Tool Setup | Team Lead | Microsoft Teams |
| Training Questions | Assigned Mentor | Direct message |
| General Questions | Team Channel | Microsoft Teams |

### After Onboarding

- **Daily Questions:** Ask in team Teams channel
- **Technical Issues:** Create ServiceNow ticket
- **Urgent Issues:** Contact on-call engineer
- **Process Questions:** Contact team lead

Remember: There are no stupid questions during onboarding. Ask for help when needed!

## Onboarding Timeline

### Week 1 Goals
- Complete all access requests
- Set up basic development environment
- Complete security training
- Begin reading platform documentation

### Week 2 Goals
- Complete tool configuration
- Begin hands-on exercises with mentor
- Attend team meetings as observer
- Complete required training modules

### Week 3 Goals
- Begin independent troubleshooting exercises
- Shadow incident response
- Complete change management training
- Review platform runbooks

### Week 4 Goals
- Complete validation checklist
- Get team lead sign-off
- Begin taking on production responsibilities
- Schedule first on-call shadow

Welcome to the team! We're excited to have you join us in supporting our critical API Connect platform.