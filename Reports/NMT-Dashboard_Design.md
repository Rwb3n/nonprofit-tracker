---
Title: Nonprofit Membership Tracking - Dashboard Design
Project: Nonprofit Membership Tracking
Phase: Build
Status: In Progress
Last Updated: 2025-03-31
---

# Membership Tracking Dashboard Design

## Overview

This document outlines the design of dashboards and reports for the Nonprofit Membership Tracking system. These dashboards are intended to provide stakeholders with clear visibility into membership metrics, trends, and engagement patterns.

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

## Dashboard #1: Membership Overview

**Purpose**: Provide executive leadership with a high-level view of membership health and trends

**Components**:

1. **Membership Growth Chart**
   - Type: Line chart
   - Metrics: Total active memberships over time
   - Filters: Date range, membership type, membership level
   - Source Report: "Membership Growth Trend"

2. **Membership by Type**
   - Type: Donut chart
   - Metrics: Individual vs. Organizational membership breakdown
   - Filters: Active status
   - Source Report: "Membership Type Distribution"

3. **Membership by Level**
   - Type: Horizontal bar chart
   - Metrics: Count of members by membership level
   - Filters: Active status, membership type
   - Source Report: "Membership Level Distribution"

4. **Revenue by Level**
   - Type: Vertical bar chart
   - Metrics: Total dues collected by membership level
   - Filters: Date range, payment status
   - Source Report: "Membership Revenue by Level"

5. **Renewal Rate Gauge**
   - Type: Gauge chart
   - Metrics: Percentage of eligible renewals completed
   - Filters: Date range (current quarter/year)
   - Source Report: "Membership Renewal Rate"

6. **Key Metrics Table**
   - Type: Table
   - Metrics: 
     - Total active members
     - New members (current month/quarter)
     - Lapsed members (current month/quarter)
     - Net growth rate
     - Average membership duration
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
   - Fields: Name, Email, Join Date, Level, Payment Status
   - Filters: Join date = Current week
   - Source Report: "Recent New Members"

2. **Renewals Due Soon**
   - Type: List view with conditional highlighting
   - Fields: Name, End Date, Days Remaining, Level, Auto-renew
   - Filters: End date next 60 days, sorted by soonest
   - Source Report: "Upcoming Membership Renewals"

3. **Recently Lapsed Members**
   - Type: List view
   - Fields: Name, End Date, Level, Membership Duration, Last Contact Date
   - Filters: Status = "Expired", End date last 30 days
   - Source Report: "Recently Lapsed Members"

4. **Payment Status Tracker**
   - Type: Funnel chart
   - Metrics: Count of members by payment status
   - Stages: Invoiced → Partial → Paid
   - Filters: Current year
   - Source Report: "Membership Payment Status"

5. **Daily Activity Log**
   - Type: Timeline
   - Metrics: New members, renewals, and cancellations
   - Filters: Last 14 days
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

1. **Event Participation by Member Type**
   - Type: Vertical bar chart
   - Metrics: Average events attended by membership level
   - Filters: Date range, event type
   - Source Report: "Member Event Participation"

2. **Upgrade Opportunities**
   - Type: List view
   - Fields: Name, Current Level, Membership Duration, Event Count, Last Donation
   - Filters: Membership Duration > 1 year, sorted by engagement score
   - Source Report: "Membership Upgrade Candidates"

3. **Engagement Heat Map**
   - Type: Matrix
   - Metrics: Members grouped by level (rows) and engagement score (columns)
   - Filters: Active members only
   - Source Report: "Member Engagement Matrix"

4. **Membership Source Analysis**
   - Type: Pie chart
   - Metrics: Members by referral source
   - Filters: Join date range
   - Source Report: "Membership Acquisition Sources"

5. **Membership Journey Funnel**
   - Type: Funnel chart
   - Metrics: Progression through membership levels
   - Stages: Bronze → Silver → Gold → Platinum
   - Filters: Members with level changes only
   - Source Report: "Membership Level Progression"

**Layout Preview**:
```
┌────────────────────────────┬───────────────────────────────────────────────┐
│                            │                                               │
│   Event Participation      │              Engagement Heat Map              │
│   by Member Type           │                                               │
│                            │                                               │
│                            │                                               │
├────────────────────────────┼───────────────────────┬───────────────────────┤
│                            │                       │                       │
│  Membership Source Analysis│ Membership Journey    │ Upgrade Opportunities │
│                            │ Funnel                │                       │
│                            │                       │                       │
└────────────────────────────┴───────────────────────┴───────────────────────┘
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
     - Formula field for renewal percentage

5. **Recently Lapsed Members**
   - Report Type: Memberships with Contacts
   - Format: Tabular
   - Filters:
     - Status = "Expired"
     - End Date = Last 30 days
   - Fields:
     - Contact Name, Email, Phone
     - Membership End Date, Level, Duration
     - Last Contact Date

### Operational Reports

6. **Upcoming Membership Renewals**
   - Report Type: Memberships with Contacts
   - Format: Tabular
   - Filters:
     - Status = "Active"
     - End Date NEXT 60 DAYS
   - Fields:
     - Contact Name, Email, Phone
     - Membership End Date, Level, Auto-renew
     - Formula field for Days Remaining

7. **Membership Payment Status**
   - Report Type: Memberships
   - Format: Summary
   - Groupings: Payment Status
   - Filters: Start Date = Current Year
   - Summary Fields:
     - COUNT of Membership records
     - SUM of Dues Amount

8. **Member Event Participation**
   - Report Type: Member Event Participation with Memberships
   - Format: Summary
   - Groupings: 
     - Rows: Membership Level
     - Columns: Event Date (by month)
   - Summary Fields:
     - COUNT of Event Participation records
     - AVERAGE of Participation records per member

## Implementation Notes

1. **Dynamic Dashboard Configuration**:
   - Each dashboard should be configured with a dynamic running user
   - Folder permissions set to ensure appropriate access control

2. **Scheduled Refreshes**:
   - Executive dashboard: Refreshed weekly on Monday mornings
   - Operations dashboard: Refreshed daily at 7 AM
   - Engagement dashboard: Refreshed weekly on Wednesday mornings

3. **Dashboard Subscriptions**:
   - Executive team: Monthly email subscription
   - Membership team: Weekly email subscription
   - Development team: Weekly email subscription

4. **Mobile Optimization**:
   - All dashboards configured for mobile viewing
   - Key metrics component prioritized in mobile layout

5. **Custom Report Types Required**:
   - "Memberships with Membership History"
   - "Member Event Participation with Memberships"
   - "Memberships with Contacts and Accounts"

## Future Enhancements

1. **Predictive Analytics Components**:
   - Renewal likelihood scoring
   - Upgrade propensity model
   - Lapse risk indicators

2. **Einstein Analytics Integration**:
   - Advanced segmentation of membership base
   - Pattern detection in engagement behaviors
   - Natural language querying of membership data

3. **External Community Dashboard**:
   - Member-facing dashboard showing individual engagement
   - Gamification elements for event participation
   - Personalized renewal notifications 