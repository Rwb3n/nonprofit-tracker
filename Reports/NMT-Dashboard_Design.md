---
title: "Nonprofit Membership Tracking - Dashboard Design"
project: "Nonprofit Membership Tracking"
type: "Report"
phase: "Design"
status: "Active"
version: "1.1"
created: "2025-03-29"
updated: "2025-04-07"
author: "Analytics Team"
---

# Membership Tracking Dashboard Design

## Overview

This document outlines the comprehensive design of dashboards and reports for the Nonprofit Membership Tracking system. These dashboards are intended to provide stakeholders with clear visibility into membership metrics, trends, and engagement patterns. The design includes both high-level structure and detailed component specifications to guide implementation.

## Dashboard Organization

The dashboard system is organized into multiple sections, each focusing on a specific aspect of membership management:

1. **Membership Overview** - Current membership status and high-level metrics
2. **Membership Operations** - Day-to-day management tools and alerts
3. **Member Engagement** - Event participation and engagement metrics
4. **Financial Performance** - Revenue tracking and financial metrics
5. **Acquisition & Retention** - New member growth and retention analysis

## Dashboard Audiences

The dashboards are designed for three primary audience groups:

1. **Executive Leadership**
   - Focus: Overall membership health and financial trends
   - Refresh Cadence: Monthly/Quarterly
   - Key Metrics: Revenue, growth, retention

2. **Membership Team**
   - Focus: Day-to-day membership operations
   - Refresh Cadence: Daily/Weekly
   - Key Metrics: New members, renewals due, recent activity

3. **Development/Fundraising Team**
   - Focus: Member engagement and giving patterns
   - Refresh Cadence: Weekly/Monthly
   - Key Metrics: Membership level distribution, upgrade opportunities, event participation

## User Personas & Access

| Persona | Dashboard Access | Description |
|---------|------------------|-------------|
| **Executive Director** | Full access, executive view | High-level metrics, trends, financial summaries |
| **Membership Manager** | Full access | Detailed membership data, action items, renewal tracking |
| **Development Staff** | Partial access | Acquisition metrics, financial data |
| **Program Staff** | Partial access | Engagement metrics, event participation |
| **Finance Staff** | Partial access | Financial metrics, revenue tracking |

## Dashboard #1: Membership Overview

**Purpose**: Provide executive leadership with a high-level view of membership health and trends

**Components**:

1. **Membership Growth Chart**
   - Type: Line chart
   - Refresh Rate: Monthly
   - Data Source: Membership object (with date tracking)
   - Metrics: Total active memberships over time
   - Data Dimensions:
     - X-axis: Last 24 months
     - Y-axis: Member count
     - Lines for: Total members, New members, Renewed members, Lapsed members
   - Filters: Date range, membership type, membership level
   - Interactions:
     - Toggle visibility of individual lines
     - Zoom to specific date ranges
     - Hover for point-in-time values
   - Source Report: "Membership Growth Trend"

2. **Membership by Type**
   - Type: Donut chart
   - Refresh Rate: Daily
   - Data Source: Membership and Membership Level objects
   - Metrics: Individual vs. Organizational membership breakdown
   - Data Dimensions:
     - Segmentation by membership type
     - Color-coding by membership category
   - Filters: Active status
   - Interactions:
     - Click segment to filter dashboard
     - Hover for segment details (count, percentage)
   - Source Report: "Membership Type Distribution"

3. **Membership by Level**
   - Type: Horizontal bar chart
   - Refresh Rate: Daily
   - Data Source: Membership and Membership Level objects
   - Metrics: Count of members by membership level
   - Data Dimensions:
     - Segmentation by membership level
     - Color-coding by tier
   - Filters: Active status, membership type
   - Interactions:
     - Click bar to filter dashboard
     - Sort by count or alphabetically
   - Source Report: "Membership Level Distribution"

4. **Revenue by Level**
   - Type: Vertical bar chart
   - Refresh Rate: Monthly
   - Data Source: Membership object (with payment data)
   - Metrics: Total dues collected by membership level
   - Data Dimensions:
     - X-axis: Membership levels
     - Y-axis: Revenue amount
   - Filters: Date range, payment status
   - Interactions:
     - Compare to previous period
     - Show as percentage of total
   - Source Report: "Membership Revenue by Level"

5. **Renewal Rate Gauge**
   - Type: Gauge chart
   - Refresh Rate: Monthly
   - Data Source: Calculated field based on Membership History
   - Metrics: Percentage of eligible renewals completed
   - Visual Elements:
     - Gauge showing current rate vs. target
     - Year-over-year comparison indicator
     - Color coding based on thresholds
   - Filters: Date range (current quarter/year)
   - Source Report: "Membership Renewal Rate"

6. **Key Metrics Table**
   - Type: Table
   - Refresh Rate: Daily
   - Data Source: Membership object
   - Metrics: 
     - Total active members
     - New members (current month/quarter)
     - Lapsed members (current month/quarter)
     - Net growth rate
     - Average membership duration
   - Visual Elements:
     - Numeric values with up/down indicators
     - Percent change vs. previous period
     - Color-coding based on performance thresholds
   - Filters: Date range
   - Source Report: "Membership Key Metrics"

**Layout Preview**:
```
┌─────────────────────────────────┬─────────────────────┬─────────────────────┐
│                                 │                     │                     │
│       Membership Growth         │  Membership by Type │ Membership by Level │
│                                 │                     │                     │
├─────────────────────────────────┼─────────────────────┴─────────────────────┤
│                                 │                                           │
│       Revenue by Level          │          Renewal Rate Gauge               │
│                                 │                                           │
├─────────────────────────────────┴───────────────────────────────────────────┤
│                                                                             │
│                             Key Metrics Table                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Dashboard #2: Membership Operations

**Purpose**: Support the membership team's daily operations and identify members needing attention

**Components**:

1. **New Members This Week**
   - Type: List view
   - Refresh Rate: Daily
   - Data Source: Membership object (filtered by join date)
   - Fields: Name, Email, Join Date, Level, Payment Status
   - Data Dimensions:
     - Sortable columns
     - Clickable links to member records
   - Filters: Join date = Current week
   - Interactions:
     - Direct action buttons (send welcome, verify)
     - Export to CSV
   - Source Report: "Recent New Members"

2. **Renewals Due Soon**
   - Type: List view with conditional highlighting
   - Refresh Rate: Daily
   - Data Source: Membership object (filtered by end date)
   - Fields: Name, End Date, Days Remaining, Level, Auto-renew
   - Visual Elements:
     - Color-coding based on urgency
     - Icons for auto-renew status
   - Filters: End date next 60 days, sorted by soonest
   - Interactions:
     - Filter by timeframe (30/60/90 days)
     - Direct action buttons (send reminder, mark contacted)
   - Source Report: "Upcoming Membership Renewals"

3. **Recently Lapsed Members**
   - Type: List view
   - Refresh Rate: Daily
   - Data Source: Membership object (lapsed status)
   - Fields: Name, End Date, Level, Membership Duration, Last Contact Date
   - Data Dimensions:
     - Sortable by any column
     - Filterable by duration
   - Filters: Status = "Expired", End date last 30 days
   - Interactions:
     - One-click follow-up actions
     - Batch update capabilities
   - Source Report: "Recently Lapsed Members"

4. **Payment Status Tracker**
   - Type: Funnel chart
   - Refresh Rate: Weekly
   - Data Source: Membership object (with payment status)
   - Metrics: Count of members by payment status
   - Data Dimensions:
     - Stages: Invoiced → Partial → Paid
     - Percentage at each stage
   - Filters: Current year
   - Interactions:
     - Click to see members at each stage
     - Compare to previous period
   - Source Report: "Membership Payment Status"

5. **Daily Activity Log**
   - Type: Timeline
   - Refresh Rate: Daily
   - Data Source: Membership History object
   - Metrics: New members, renewals, and cancellations
   - Data Dimensions:
     - X-axis: Last 14 days
     - Y-axis: Activity count by type
   - Filters: Last 14 days
   - Interactions:
     - Hover for daily details
     - Click to see specific records
   - Source Report: "Membership Daily Activity"

**Layout Preview**:
```
┌────────────────────────────┬────────────────────────────┬────────────────────┐
│                            │                            │                    │
│    New Members This Week   │     Renewals Due Soon      │  Payment Status    │
│                            │                            │                    │
│                            │                            │                    │
│                            │                            │                    │
├────────────────────────────┴────────────────────────────┴────────────────────┤
│                                                                              │
│                        Recently Lapsed Members                               │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│                            Daily Activity Log                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Dashboard #3: Member Engagement

**Purpose**: Help the development team understand member engagement patterns and identify opportunities

**Components**:

1. **Event Participation Chart**
   - Type: Heat map calendar
   - Refresh Rate: Event-driven
   - Data Source: Event and Member Event Participation objects
   - Metrics: Average events attended by membership level
   - Data Dimensions:
     - X-axis: Calendar dates
     - Y-axis: Event types
     - Color intensity: Participation level
   - Filters: Date range, event type
   - Interactions:
     - Click event for participant details
     - Filter by event type or date range
     - Toggle between absolute count and percentage views
   - Source Report: "Member Event Participation"

2. **Upgrade Opportunities**
   - Type: List view
   - Refresh Rate: Monthly
   - Data Source: Membership object with engagement scoring
   - Fields: Name, Current Level, Membership Duration, Event Count, Last Donation
   - Data Dimensions:
     - Sortable columns
     - Priority indicators
   - Filters: Membership Duration > 1 year, sorted by engagement score
   - Interactions:
     - Click for detailed member profile
     - Batch action capabilities
   - Source Report: "Membership Upgrade Candidates"

3. **Member Engagement Score Distribution**
   - Type: Histogram
   - Refresh Rate: Monthly
   - Data Source: Calculated engagement score field
   - Metrics: Members grouped by level (rows) and engagement score (columns)
   - Data Dimensions:
     - X-axis: Engagement score ranges
     - Y-axis: Member count
     - Segments: Membership levels or duration brackets
   - Visual Elements:
     - Distribution curve overlay
     - Threshold indicators for engagement levels
     - Average score indicator
   - Filters: Active members only
   - Interactions:
     - Compare distributions across membership levels
     - Drill down to member list by engagement score range
   - Source Report: "Member Engagement Matrix"

4. **Membership Source Analysis**
   - Type: Pie chart
   - Refresh Rate: Quarterly
   - Data Source: Membership object (Join Method field)
   - Metrics: Members by referral source
   - Data Dimensions:
     - Membership acquisition sources
     - Count and percentage per source
   - Filters: Join date range
   - Interactions:
     - Click slice to see detailed breakdown
     - Compare across time periods
   - Source Report: "Membership Acquisition Sources"

5. **Membership Journey Funnel**
   - Type: Funnel chart
   - Refresh Rate: Quarterly
   - Data Source: Membership History object
   - Metrics: Progression through membership levels
   - Data Dimensions:
     - Stages: Bronze → Silver → Gold → Platinum
     - Conversion rates between levels
   - Filters: Members with level changes only
   - Interactions:
     - Hover for stage details
     - Click to see member list
   - Source Report: "Membership Level Progression"

**Layout Preview**:
```
┌────────────────────────────┬───────────────────────────────────────────────┐
│                            │                                               │
│   Event Participation      │         Member Engagement Score               │
│   Chart                    │         Distribution                          │
│                            │                                               │
│                            │                                               │
├────────────────────────────┼───────────────────────┬───────────────────────┤
│                            │                       │                       │
│  Membership Source Analysis│ Membership Journey    │ Upgrade Opportunities │
│                            │ Funnel                │                       │
│                            │                       │                       │
└────────────────────────────┴───────────────────────┴───────────────────────┘
```

## Dashboard #4: Financial Performance

**Purpose**: Track financial metrics related to membership dues and payments

**Components**:

1. **Revenue Trend Chart**
   - Type: Line chart
   - Refresh Rate: Monthly
   - Data Source: Membership object (with payment data)
   - Metrics: Total revenue over time
   - Data Dimensions:
     - X-axis: Last 24 months
     - Y-axis: Revenue amount
     - Lines for: Expected revenue, Actual revenue
   - Filters: Date range, membership level
   - Interactions:
     - Compare to previous year
     - Forecasting toggle
   - Source Report: "Membership Revenue Trend"

2. **Payment Status Breakdown**
   - Type: Donut chart
   - Refresh Rate: Weekly
   - Data Source: Membership object (payment status field)
   - Metrics: Members by payment status
   - Data Dimensions:
     - Segments: Paid, Partial, Pending, Overdue
     - Percentage and count for each segment
   - Filters: Current billing cycle
   - Interactions:
     - Click segment for member list
     - Compare to previous cycle
   - Source Report: "Payment Status Distribution"

3. **Revenue vs. Target**
   - Type: Progress bar chart
   - Refresh Rate: Monthly
   - Data Source: Membership object + target settings
   - Metrics: Actual vs. projected membership revenue
   - Data Dimensions:
     - Progress toward annual target
     - Monthly trajectory
   - Filters: Fiscal year
   - Visual Elements:
     - Progress indicator
     - Projected year-end based on current pace
   - Source Report: "Revenue Target Tracking"

4. **Average Membership Value**
   - Type: Vertical bar chart
   - Refresh Rate: Quarterly
   - Data Source: Membership object
   - Metrics: Average dues per member segment
   - Data Dimensions:
     - X-axis: Member segments (duration, type)
     - Y-axis: Average revenue per member
   - Filters: Member type, tenure
   - Source Report: "Member Lifetime Value Analysis"

**Layout Preview**:
```
┌─────────────────────────────────┬─────────────────────────────────┐
│                                 │                                 │
│       Revenue Trend Chart       │     Payment Status Breakdown    │
│                                 │                                 │
│                                 │                                 │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                 │
│       Revenue vs. Target        │     Average Membership Value    │
│                                 │                                 │
│                                 │                                 │
└─────────────────────────────────┴─────────────────────────────────┘
```

## Dashboard #5: Acquisition & Retention

**Purpose**: Monitor member acquisition strategies and retention efforts

**Components**:

1. **New Member Acquisition Chart**
   - Type: Column chart
   - Refresh Rate: Monthly
   - Data Source: Membership object (with join date)
   - Metrics: New member count over time
   - Data Dimensions:
     - X-axis: Last 12 months
     - Y-axis: New member count
     - Segments: Membership levels (stacked)
   - Interactions:
     - Compare to previous year (toggle overlay)
     - Drill down to source of acquisition
   - Source Report: "New Member Acquisition Trend"

2. **Retention Rate Metrics**
   - Type: Gauges with historical comparison
   - Refresh Rate: Monthly
   - Data Source: Calculated field based on Membership History
   - Metrics Displayed:
     - Overall retention rate
     - First-year retention rate
     - Multi-year retention rate
   - Visual Elements:
     - Gauge showing current rate vs. target
     - Year-over-year comparison indicator
     - Color coding based on thresholds
   - Source Report: "Membership Retention Analysis"

3. **Membership Duration Distribution**
   - Type: Horizontal bar chart
   - Refresh Rate: Quarterly
   - Data Source: Membership object (Member Since field)
   - Data Dimensions:
     - X-axis: Count of members
     - Y-axis: Duration buckets (0-1 year, 1-2 years, etc.)
   - Filters: Current membership status
   - Source Report: "Member Tenure Distribution"

4. **Lapsed Member Recovery**
   - Type: KPI metrics with supporting list
   - Refresh Rate: Monthly
   - Data Source: Membership object (lapsed status)
   - Metrics Displayed:
     - Recently lapsed members (last 90 days)
     - Lapsed member recovery rate
     - Average time to recovery
   - Supporting Data:
     - List of recently recovered members
     - List of high-priority lapsed members for outreach
   - Source Report: "Lapsed Member Recovery"

**Layout Preview**:
```
┌─────────────────────────────────┬─────────────────────────────────┐
│                                 │                                 │
│    New Member Acquisition       │     Retention Rate Metrics      │
│    Chart                        │                                 │
│                                 │                                 │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                 │
│  Membership Duration Distribution│     Lapsed Member Recovery     │
│                                 │                                 │
│                                 │                                 │
└─────────────────────────────────┴─────────────────────────────────┘
```

## Underlying Reports

### Core Reports

1. **Membership Growth Trend**
   - Report Type: Membership with date fields
   - Format: Matrix report with date grouping
   - Groupings: 
     - Rows: Join Date (by month)
     - Columns: Membership Level
   - Summary Fields:
     - COUNT of Membership records
     - Running sum option enabled

2. **Membership Level Distribution**
   - Report Type: Memberships
   - Format: Summary
   - Groupings: Membership Level
   - Filters: Status = "Active"
   - Summary Fields:
     - COUNT of Membership records
     - SUM of Dues Amount

3. **Membership Type Distribution**
   - Report Type: Memberships
   - Format: Summary
   - Groupings: Type (Individual/Organizational)
   - Filters: Status = "Active"
   - Summary Fields:
     - COUNT of Membership records

4. **Membership Renewal Rate**
   - Report Type: Memberships with date fields
   - Format: Summary
   - Filters: 
     - End Date = Previous Quarter/Year
     - Prior Status = "Active"
   - Summary Fields:
     - COUNT of Membership records where Status = "Active"
     - COUNT of Membership records (total)

5. **Member Event Participation**
   - Report Type: Member Event Participation
   - Format: Matrix
   - Groupings:
     - Rows: Membership Level
     - Columns: Event Type
   - Summary Fields:
     - COUNT of participation records
     - COUNT of unique members

6. **Membership Acquisition Sources**
   - Report Type: Memberships
   - Format: Summary
   - Groupings: Join Method
   - Filters: Join Date = Current Year
   - Summary Fields:
     - COUNT of membership records
     - PERCENTAGE of total

7. **Membership Revenue Trend**
   - Report Type: Memberships with date fields
   - Format: Summary with trend
   - Groupings: Payment Date (by month)
   - Summary Fields:
     - SUM of Dues Amount
     - Trend visualization enabled

8. **Member Engagement Matrix**
   - Report Type: Custom report type
   - Format: Matrix
   - Groupings:
     - Rows: Membership Level
     - Columns: Engagement Score (bucketed)
   - Summary Fields:
     - COUNT of members
     - AVG of engagement score

## Implementation Notes

1. **Refresh Schedules**:
   - Daily metrics: Updated through automated refresh at 6:00 AM
   - Weekly metrics: Updated Monday mornings by 8:00 AM
   - Monthly metrics: Updated on the 1st of each month

2. **User Access Control**:
   - Use Salesforce permission sets to control dashboard access
   - Create filtered dashboard views for different departments

3. **Mobile Optimization**:
   - Ensure all dashboards are mobile-responsive
   - Prioritize key metrics for mobile display

4. **Performance Considerations**:
   - Use report caching for complex reports
   - Implement efficient formulas for calculated fields
   - Consider dashboard refresh impact on system performance

## Future Enhancements

1. **Predictive Analytics**:
   - Renewal likelihood prediction
   - Churn risk identification
   - Membership level upgrade propensity

2. **Enhanced Visualizations**:
   - Geographic distribution map
   - Interactive network diagram of member connections
   - Custom engagement scoring visualization

3. **External Sharing**:
   - Board member portal with key metrics
   - Automated executive summary reports
   - Scheduled email distribution of key dashboards

## Related Documents

- [Data Model Design](NMT-Data_Model_Design_Consolidated.md)
- [Financial Reports Specifications](NMT-Financial_Reports_Specs.md)
- [Engagement Reports Specifications](NMT-Engagement_Reports_Specs.md)
- [Membership Renewal Flow Design](NMT-Membership_Renewal_Flow_Design.md) 