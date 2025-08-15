# Response Time Alert Email Template

## Email Template

**Subject:** Response Time Alert: [API_NAME] - Average Response Time Exceeding 2500ms

---

Hi [TEAM_NAME],

We've received a Response Time alert for **[API_NAME]** indicating performance degradation that requires investigation.

## 🚨 Alert Details
- **API Affected:** [API_NAME]
- **Current Response Time:** [CURRENT_AVG_RESPONSE_TIME]ms (Target: <2000ms)
- **Alert Threshold:** 2500ms average response time
- **Environment:** [PROD/NONPROD]
- **Alert Time:** [TIMESTAMP]
- **Duration:** [HOW_LONG_ACTIVE]

## 📊 Initial Investigation Queries

Please run these Splunk searches to assess the scope and identify the root cause:

### 1. Current Response Time Assessment
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" 
[API_NAME OR service="[API_NAME]" OR endpoint="*[API_NAME]*"] earliest=-30m
| bin _time span=5m
| stats avg(time_to_serve_request) as avg_response_time, count as transaction_count by _time
| where avg_response_time >= 2500
| sort _time
```

### 2. Request Method Performance Breakdown
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod"
[API_NAME OR service="[API_NAME]" OR endpoint="*[API_NAME]*"] earliest=-30m
| stats avg(time_to_serve_request) as avg_response_time, 
        count as request_count, 
        max(time_to_serve_request) as max_response_time by request_method
| sort -avg_response_time
```

### 3. Performance Distribution Analysis
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod"
[API_NAME OR service="[API_NAME]" OR endpoint="*[API_NAME]*"] earliest=-30m
| stats count as request_count, 
        avg(time_to_serve_request) as avg_response, 
        p50(time_to_serve_request) as median_response,
        p95(time_to_serve_request) as p95_response, 
        max(time_to_serve_request) as max_response
```

## 🔍 Investigation Priorities

Based on historical data, please investigate in this order:

**1. Database Performance (40% of cases)**
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* catalog_name="i-prod" [API_NAME OR service="[API_NAME]"] earliest=-1h
| join global_transaction_id [search index="database" earliest=-1h]
| stats avg(time_to_serve_request) as api_response_time, 
        avg(db_query_time) as db_response_time by _time span=10m
| eval correlation=if(db_response_time>1000 AND api_response_time>2500,"HIGH_CORRELATION","NORMAL")
```

**2. DataPower Gateway Performance (25% of cases)**
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:system" 
earliest=-30m (CPU OR Memory OR "Connection") [API_NAME OR service="[API_NAME]"]
| stats avg(cpu_usage) as avg_cpu, 
        max(memory_usage) as max_memory, 
        avg(active_connections) as avg_connections by host
| where avg_cpu > 80 OR max_memory > 85 OR avg_connections > 1000
```

**3. Recent Configuration Changes (12% of cases)**
```splunk
index="deployment" OR index="config_changes" earliest=-4h 
(datapower OR apic OR "i-prod") [API_NAME OR service="[API_NAME]"]
| join service [search index="app_plat" OR index="app_plat_nonprod" 
  sourcetype="ibm:datapower:apic:v10" global_transaction_id=* catalog_name="i-prod" 
  [API_NAME OR service="[API_NAME]"] earliest=-1h 
  | stats avg(time_to_serve_request) as current_response by service 
  | where current_response > 2500]
| sort -change_time
```

## 📋 Next Steps

1. **Run the investigation queries above** to identify the scope and potential cause
2. **Check your recent deployments** and configuration changes for [API_NAME]
3. **Review application logs** for any errors or performance issues
4. **Reply to this email** with your findings within **30 minutes**

## 🆘 When to Contact SRE

Contact @sre-oncall in Slack if you find:
- **DataPower gateway issues** requiring infrastructure analysis
- **Network connectivity problems** affecting multiple services
- **Infrastructure-level** resource constraints
- **No clear application-level cause** after investigation

## 📈 Verification Query

Once you believe the issue is resolved, use this query to confirm:
```splunk
index="app_plat" OR index="app_plat_nonprod" sourcetype="ibm:datapower:apic:v10" 
global_transaction_id=* request_method!="OPTIONS" catalog_name="i-prod" 
[API_NAME OR service="[API_NAME]" OR endpoint="*[API_NAME]*"] earliest=-30m
| bin _time span=5m
| stats avg(time_to_serve_request) as avg_response_time by _time
| eval status=case(avg_response_time>2500,"STILL_DEGRADED",
                  avg_response_time>2000,"ELEVATED",
                  1=1,"BACK_TO_NORMAL")
| sort _time
```

## 🔗 Resources

- **Troubleshooting Runbook:** [Link to Response Time Runbook]
- **DataPower Dashboard:** [Link to Splunk Dashboard]
- **SRE On-Call:** @sre-oncall

Please investigate promptly and keep us updated on your findings.

Thanks,  
SRE Team

---

## Usage Instructions

### Before Sending:
1. **Replace [API_NAME]** with the actual API name from the alert
2. **Replace [TEAM_NAME]** with the owning team name
3. **Replace [CURRENT_AVG_RESPONSE_TIME]** with actual value from alert
4. **Replace [TIMESTAMP]** with alert firing time
5. **Replace [HOW_LONG_ACTIVE]** with duration alert has been active
6. **Replace [PROD/NONPROD]** based on affected environment

### Query Customization:
- The queries include `[API_NAME OR service="[API_NAME]" OR endpoint="*[API_NAME]*"]` to scope results
- Adjust the search terms based on how your API names appear in the logs
- Modify time ranges (`earliest=-30m`, etc.) if needed for the specific situation

### Team-Specific Modifications:
- **Update contact information** (@sre-oncall, team handles)
- **Adjust investigation priorities** if your historical data differs
- **Add team-specific resources** or dashboard links
- **Modify escalation criteria** based on your team's preferences