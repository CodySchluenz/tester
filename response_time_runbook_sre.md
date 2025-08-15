# SRE Runbook: Response Time Alert - Troubleshooting Guide

## Overview
This runbook helps you troubleshoot "Response Time" alerts from Splunk. Use this when you need to understand and fix performance problems with IBM DataPower APIC.

### Alert Details
- **Alert Name**: Response Time
- **Source**: Splunk Alert
- **What triggers it**: Average response time goes over 2500ms for DataPower APIC transactions
- **Data Source**: `app_plat` and `app_plat_nonprod` indexes, sourcetype `ibm:datapower:apic:v10`
- **What it covers**: i-prod catalog transactions (skips OPTIONS requests)
- **What we want**: Under 2000ms average response time
- **Why it matters**: When this fires, customers are experiencing slow performance

---

## Understanding the Alert

### The Alert Query
The alert fires when this Splunk query finds problems:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" 
| stats avg(time_to_serve_request) as avg_response_time 
| where avg_response_time > 2500
```

### What the Numbers Mean
- **Under 2000ms**: Everything is fine
- **2500-3500ms**: Performance is getting bad
- **3500-5000ms**: Performance is really bad  
- **Over 5000ms**: Performance is terrible, customers are definitely noticing

---

## Start Here - Basic Analysis

### Step 1: See How Bad It Is Right Now
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
| bin _time span=5m
| stats avg(time_to_serve_request) as avg_response_time, count as transaction_count by _time
| where avg_response_time >= 2500
| sort _time
```

### Step 2: Get the Full Picture of Performance
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
| stats count as request_count, 
        avg(time_to_serve_request) as avg_response, 
        p50(time_to_serve_request) as median_response,
        p95(time_to_serve_request) as p95_response, 
        max(time_to_serve_request) as max_response
```

### Step 3: See Which Request Types Are Slow
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
| stats avg(time_to_serve_request) as avg_response_time, 
        count as request_count, 
        max(time_to_serve_request) as max_response_time by request_method
| sort -avg_response_time
```

---

## Common Causes and How to Check for Them

### Most Common: Database Problems (40% of the time)

**What it looks like**: Response times get slower gradually across all types of requests

**How to check**:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* catalog_name="i-prod" earliest=-1h
| join global_transaction_id [search index="database" earliest=-1h]
| stats avg(time_to_serve_request) as api_response_time, 
        avg(db_query_time) as db_response_time by _time span=10m
| eval correlation=if(db_response_time>1000 AND api_response_time>2500,"HIGH_CORRELATION","NORMAL")
```

**What to look for**:
- Database CPU or memory usage is high
- Slow queries showing up in database logs
- Database connection pools getting full
- Database maintenance running
- Database locks or deadlocks happening

**How it usually gets fixed**:
- Make database queries faster
- Add more database connections
- Give the database more resources
- Fix slow queries

### Second Most Common: DataPower Gateway Problems (25% of the time)

**What it looks like**: Response times spike suddenly and DataPower is using lots of resources

**How to check**:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:system" 
earliest=-30m (CPU OR Memory OR "Connection")
| stats avg(cpu_usage) as avg_cpu, 
        max(memory_usage) as max_memory, 
        avg(active_connections) as avg_connections by host
| where avg_cpu > 80 OR max_memory > 85 OR avg_connections > 1000
```

**What to look for**:
- DataPower CPU usage over 80%
- DataPower memory usage over 85%
- Too many active connections
- Recent changes to DataPower policies or config
- SSL certificate problems
- Error messages in DataPower logs

**How it usually gets fixed**:
- Restart DataPower gateway
- Undo recent configuration changes
- Give DataPower more resources
- Fix SSL certificate issues
- Optimize DataPower policies

### Network Problems (15% of the time)

**What it looks like**: Response times increase consistently, often with timeouts

**How to check**:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* catalog_name="i-prod" earliest=-30m
| eval network_time=time_to_serve_request-backend_processing_time
| stats avg(network_time) as avg_network_latency, 
        max(network_time) as max_network_latency by backend_host
| where avg_network_latency > 500
| sort -avg_network_latency
```

**What to look for**:
- Network connectivity problems between DataPower and backend services
- DNS resolution taking too long
- Load balancer having issues
- High latency between different zones or regions
- Firewall rules blocking or slowing traffic

**How it usually gets fixed**:
- Fix DNS problems
- Adjust load balancer settings
- Fix network routing
- Update firewall rules
- Scale up infrastructure

### Recent Changes (12% of the time)

**What it looks like**: Response times suddenly get bad right after someone made changes

**How to check**:
```splunk
index="deployment" OR index="config_changes" earliest=-4h 
(datapower OR apic OR "i-prod")
| join service [search index="app_plat" OR index="app_plat_nonprod" 
  sourcetype="ibm:datapower:apic:v10" global_transaction_id=* catalog_name="i-prod" 
  earliest=-1h | stats avg(time_to_serve_request) as current_response by service 
  | where current_response > 2500]
| sort -change_time
```

**What to look for**:
- Recent DataPower policy changes
- APIC catalog configuration changes
- SSL certificate updates
- Backend service changes
- Rate limiting changes

**How it usually gets fixed**:
- Roll back the recent changes
- Fix the configuration that's causing problems
- Update SSL certificates properly
- Fix endpoint or routing changes

### Backend Service Problems (8% of the time)

**What it looks like**: Specific endpoints or backend services are slow

**How to check**:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* catalog_name="i-prod" earliest=-30m
| stats avg(time_to_serve_request) as avg_response, 
        count as request_count,
        p95(time_to_serve_request) as p95_response by backend_service_url
| where avg_response > 2000
| sort -avg_response
```

**What to look for**:
- Backend services having health problems
- Downstream databases or caches having issues
- External services being slow or down
- Backend services running out of resources
- Third-party APIs rate limiting or failing

**How it usually gets fixed**:
- Scale up or restart backend services
- Fix cache problems
- Work with external service providers
- Give backend services more resources

---

## Additional Analysis You Can Do

### Compare to Normal Performance
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" 
earliest=-7d latest=-6d
| stats avg(time_to_serve_request) as baseline_avg
| appendcols [search index="app_plat" OR index="app_plat_nonprod" 
  sourcetype="ibm:datapower:apic:v10" global_transaction_id=* 
  request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
  | stats avg(time_to_serve_request) as current_avg]
| eval performance_degradation=round(((current_avg-baseline_avg)/baseline_avg)*100,1)
```

### See if High Traffic is Causing the Problem
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-2h
| bin _time span=15m
| stats count as transactions, 
        avg(time_to_serve_request) as avg_response_time by _time
| eval volume_category=case(transactions>1000,"HIGH_VOLUME",
                           transactions>500,"MEDIUM_VOLUME",
                           1=1,"LOW_VOLUME")
```

### Check if Errors and Slow Performance are Related
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* catalog_name="i-prod" earliest=-1h
| bin _time span=10m
| stats avg(time_to_serve_request) as avg_response_time,
        count(eval(response_code>=400)) as error_count,
        count as total_count by _time
| eval error_rate=round((error_count/total_count)*100,2)
| eval correlation=case(avg_response_time>2500 AND error_rate>5,"HIGH_CORRELATION",
                       avg_response_time>2500 AND error_rate>1,"MODERATE_CORRELATION",
                       1=1,"LOW_CORRELATION")
```

---

## Checking if the Problem is Fixed

### Make Sure Response Times are Back to Normal
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
| bin _time span=5m
| stats avg(time_to_serve_request) as avg_response_time, 
        count as transaction_count by _time
| eval status=case(avg_response_time>2500,"STILL_BAD",
                  avg_response_time>2000,"GETTING_BETTER",
                  1=1,"BACK_TO_NORMAL")
| sort _time
```

### Make Sure the Fix is Stable
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" earliest=-30m
| stats avg(time_to_serve_request) as avg_response_time,
        p95(time_to_serve_request) as p95_response_time,
        max(time_to_serve_request) as max_response_time
| eval recovery_status=case(avg_response_time<2000 AND p95_response_time<3000,"STABLE_RECOVERY",
                           avg_response_time<2500,"PARTIAL_RECOVERY",
                           1=1,"STILL_HAVING_PROBLEMS")
```

---

## Team Contacts

### Who to Call for Different Problems
| **Team** | **Contact** | **When to Call Them** |
|----------|-------------|----------------------|
| DataPower Team | @datapower-team | DataPower gateway problems, SSL issues, policy problems |
| Database Team | @database-team | Database slow, connection problems, query issues |
| Network Team | @network-team | Connectivity problems, DNS issues, load balancer problems |
| Backend Development | @backend-dev-team | Backend service problems, API issues |

---

*This runbook helps you understand and fix DataPower response time problems using Splunk queries and analysis. Use it as a reference when performance alerts fire.*