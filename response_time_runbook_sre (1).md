# Splunk Alert Troubleshooting Runbook Template (Simplified)

*This template creates standalone, informational troubleshooting guides for Splunk alerts. Copy this template and customize for each specific alert.*

---

# SRE Runbook: [ALERT_NAME] Alert - Troubleshooting Guide

## Overview
This runbook helps you troubleshoot "[ALERT_NAME]" alerts from Splunk. Use this when you need to understand and fix [PROBLEM_TYPE] with [TECHNOLOGY/SYSTEM].

### Alert Details
- **Alert Name**: [ALERT_NAME]
- **Source**: Splunk Alert
- **What triggers it**: [TRIGGER_CONDITION_PLAIN_LANGUAGE]
- **Data Source**: [INDEX_NAMES] indexes, sourcetype [SOURCETYPE]
- **What it covers**: [SCOPE_DESCRIPTION]
- **What we want**: [TARGET_PERFORMANCE_SIMPLE]
- **Why it matters**: [CUSTOMER_IMPACT_SIMPLE]

---

## Understanding the Alert

### The Alert Query
The alert fires when this Splunk query finds problems:
```splunk
[ACTUAL_ALERT_QUERY]
```

### What the Numbers Mean
- **[NORMAL_RANGE]**: Everything is fine
- **[DEGRADED_RANGE]**: [DESCRIPTION] is getting bad
- **[SEVERE_RANGE]**: [DESCRIPTION] is really bad  
- **[CRITICAL_RANGE]**: [DESCRIPTION] is terrible, customers are definitely noticing

---

## Start Here - Basic Analysis

### Step 1: [FIRST_ANALYSIS_STEP]
```splunk
[FIRST_QUERY_TO_RUN]
```

### Step 2: [SECOND_ANALYSIS_STEP]
```splunk
[SECOND_QUERY_TO_RUN]
```

### Step 3: [THIRD_ANALYSIS_STEP]
```splunk
[THIRD_QUERY_TO_RUN]
```

---

## Common Causes and How to Check for Them

### Most Common: [CAUSE_1_NAME] ([PERCENTAGE]% of the time)

**What it looks like**: [SYMPTOM_DESCRIPTION]

**How to check**:
```splunk
[INVESTIGATION_QUERY_1]
```

**What to look for**:
- [INDICATOR_1]
- [INDICATOR_2]
- [INDICATOR_3]
- [INDICATOR_4]
- [INDICATOR_5]

**How it usually gets fixed**:
- [RESOLUTION_1]
- [RESOLUTION_2]
- [RESOLUTION_3]
- [RESOLUTION_4]

### Second Most Common: [CAUSE_2_NAME] ([PERCENTAGE]% of the time)

**What it looks like**: [SYMPTOM_DESCRIPTION]

**How to check**:
```splunk
[INVESTIGATION_QUERY_2]
```

**What to look for**:
- [INDICATOR_1]
- [INDICATOR_2]
- [INDICATOR_3]
- [INDICATOR_4]
- [INDICATOR_5]

**How it usually gets fixed**:
- [RESOLUTION_1]
- [RESOLUTION_2]
- [RESOLUTION_3]
- [RESOLUTION_4]

### [CAUSE_3_NAME] ([PERCENTAGE]% of the time)

**What it looks like**: [SYMPTOM_DESCRIPTION]

**How to check**:
```splunk
[INVESTIGATION_QUERY_3]
```

**What to look for**:
- [INDICATOR_1]
- [INDICATOR_2]
- [INDICATOR_3]
- [INDICATOR_4]

**How it usually gets fixed**:
- [RESOLUTION_1]
- [RESOLUTION_2]
- [RESOLUTION_3]

### [CAUSE_4_NAME] ([PERCENTAGE]% of the time)

**What it looks like**: [SYMPTOM_DESCRIPTION]

**How to check**:
```splunk
[INVESTIGATION_QUERY_4]
```

**What to look for**:
- [INDICATOR_1]
- [INDICATOR_2]
- [INDICATOR_3]
- [INDICATOR_4]

**How it usually gets fixed**:
- [RESOLUTION_1]
- [RESOLUTION_2]
- [RESOLUTION_3]

### [CAUSE_5_NAME] ([PERCENTAGE]% of the time)

**What it looks like**: [SYMPTOM_DESCRIPTION]

**How to check**:
```splunk
[INVESTIGATION_QUERY_5]
```

**What to look for**:
- [INDICATOR_1]
- [INDICATOR_2]
- [INDICATOR_3]

**How it usually gets fixed**:
- [RESOLUTION_1]
- [RESOLUTION_2]
- [RESOLUTION_3]

---

## Additional Analysis You Can Do

### [ADDITIONAL_ANALYSIS_1_NAME]
```splunk
[ADDITIONAL_QUERY_1]
```

### [ADDITIONAL_ANALYSIS_2_NAME]
```splunk
[ADDITIONAL_QUERY_2]
```

### [ADDITIONAL_ANALYSIS_3_NAME]
```splunk
[ADDITIONAL_QUERY_3]
```

---

## Checking if the Problem is Fixed

### [VERIFICATION_CHECK_1_NAME]
```splunk
[VERIFICATION_QUERY_1]
```

### [VERIFICATION_CHECK_2_NAME]
```splunk
[VERIFICATION_QUERY_2]
```

---

## Team Contacts

### Who to Call for Different Problems
| **Team** | **Contact** | **When to Call Them** |
|----------|-------------|----------------------|
| [TEAM_1] | [CONTACT_1] | [RESPONSIBILITY_1] |
| [TEAM_2] | [CONTACT_2] | [RESPONSIBILITY_2] |
| [TEAM_3] | [CONTACT_3] | [RESPONSIBILITY_3] |
| [TEAM_4] | [CONTACT_4] | [RESPONSIBILITY_4] |

---

*This runbook helps you understand and fix [TECHNOLOGY] [PROBLEM_TYPE] using Splunk queries and analysis. Use it as a reference when [ALERT_TYPE] alerts fire.*

---

## Template Usage Instructions

### For Each New Splunk Alert Runbook:

1. **Copy this template** and replace all [BRACKETED_PLACEHOLDERS]
2. **Customize the 5 common causes** based on historical data for that alert type
3. **Update Splunk queries** with the specific indexes, sourcetypes, and fields for your alert
4. **Add real percentages** for how often each cause occurs (if known)
5. **Include actual resolution steps** that your teams use
6. **Update team contact information** for the specific alert type

### Placeholder Reference Guide:

#### **Basic Alert Information:**
- `[ALERT_NAME]` - Name of the Splunk alert
- `[PROBLEM_TYPE]` - Type of problem (performance, errors, outages, etc.)
- `[TECHNOLOGY/SYSTEM]` - Technology affected (DataPower, database, network, etc.)
- `[TRIGGER_CONDITION_PLAIN_LANGUAGE]` - Simple explanation of what triggers the alert
- `[INDEX_NAMES]` - Splunk indexes used by the alert
- `[SOURCETYPE]` - Splunk sourcetype for the alert data
- `[SCOPE_DESCRIPTION]` - What the alert covers (which services, environments, etc.)
- `[TARGET_PERFORMANCE_SIMPLE]` - What good performance looks like
- `[CUSTOMER_IMPACT_SIMPLE]` - Why customers care about this alert

#### **Performance Thresholds:**
- `[NORMAL_RANGE]` - Values that indicate everything is fine
- `[DEGRADED_RANGE]` - Values that indicate problems are starting
- `[SEVERE_RANGE]` - Values that indicate serious problems
- `[CRITICAL_RANGE]` - Values that indicate critical problems

#### **Analysis Steps:**
- `[FIRST_ANALYSIS_STEP]` - First thing to check when alert fires
- `[SECOND_ANALYSIS_STEP]` - Second investigation step
- `[THIRD_ANALYSIS_STEP]` - Third investigation step
- `[FIRST_QUERY_TO_RUN]` - Most important Splunk query to run first
- `[SECOND_QUERY_TO_RUN]` - Second most important query
- `[THIRD_QUERY_TO_RUN]` - Third query for scope assessment

#### **Root Causes (repeat for each cause):**
- `[CAUSE_X_NAME]` - Name of the root cause
- `[PERCENTAGE]` - How often this cause occurs
- `[SYMPTOM_DESCRIPTION]` - What this problem looks like
- `[INVESTIGATION_QUERY_X]` - Splunk query to check for this cause
- `[INDICATOR_X]` - Things to look for that indicate this cause
- `[RESOLUTION_X]` - How this cause typically gets fixed

#### **Additional Analysis:**
- `[ADDITIONAL_ANALYSIS_X_NAME]` - Name of optional analysis
- `[ADDITIONAL_QUERY_X]` - Splunk query for deeper investigation

#### **Verification:**
- `[VERIFICATION_CHECK_X_NAME]` - Name of verification step
- `[VERIFICATION_QUERY_X]` - Query to confirm the problem is fixed

#### **Team Contacts:**
- `[TEAM_X]` - Team name
- `[CONTACT_X]` - Team contact information
- `[RESPONSIBILITY_X]` - When to contact this team

### Template Customization Guidelines:

#### **Language Style:**
- Use **simple, conversational language**
- Avoid technical jargon when possible
- Use **"What it looks like"** instead of "Symptoms"
- Use **"How it usually gets fixed"** instead of "Resolution"
- Use **"What to look for"** instead of "Investigation areas"

#### **Structure Requirements:**
- **Always start with 3 basic analysis steps**
- **Always include 5 common causes** (adjust if you have fewer)
- **Order causes by frequency** (most common first)
- **Include percentages** if you have historical data
- **Focus only on Splunk analysis** - no infrastructure commands

#### **Query Guidelines:**
- **Use actual field names** from your Splunk data
- **Include time ranges** (earliest=-30m, etc.)
- **Add helpful comments** in queries
- **Test all queries** before including in runbook

#### **Team Contact Guidelines:**
- **Update contact information** regularly
- **Be specific about responsibilities** 
- **Include primary and backup contacts** if needed
- **Match teams to actual alert ownership**

### Example Alert Types This Template Works For:
- **Response Time alerts** (performance degradation)
- **Error Rate alerts** (high error percentages)
- **Transaction Volume alerts** (traffic spikes or drops)
- **Availability alerts** (service outages)
- **Security alerts** (authentication failures, suspicious activity)
- **Resource alerts** (CPU, memory, disk usage)

### Template Maintenance:
- **Update template** when you discover better troubleshooting approaches
- **Version control** template changes
- **Review existing runbooks** against current template periodically
- **Train teams** on template usage and customization

*This template ensures all Splunk alert runbooks follow the same simple, practical format while allowing full customization for each specific alert type.*