/* 
 * DEPRECATED: This file will be deleted after review.
 * Content is being merged into Reports/NMT-Dashboard_Design.md as part of the documentation consistency initiative.
 * Please refer to Reports/NMT-Dashboard_Design.md for the most up-to-date dashboard documentation.
 */

---
Title: Nonprofit Membership Tracking - Dashboard Component Specifications
Project: Nonprofit Membership Tracking
Phase: Design
Status: Draft
Last Updated: 2025-03-26
---

# Membership Dashboard Component Specifications

## Overview

The Membership Dashboard provides nonprofit staff with a comprehensive view of membership data, trends, and insights. This central hub enables quick assessment of membership health, identification of renewal opportunities, and tracking of key performance indicators. The dashboard is designed to support strategic decision-making and daily membership operations.

## Dashboard Organization

The dashboard is organized into multiple sections, each focusing on a specific aspect of membership management:

1. **Membership Overview** - Current membership status and high-level metrics
2. **Acquisition & Retention** - New member growth and retention analysis
3. **Renewal Management** - Upcoming renewals and renewal performance
4. **Member Engagement** - Event participation and engagement metrics
5. **Financial Performance** - Revenue tracking and financial metrics

## User Personas & Access

| Persona | Dashboard Access | Description |
|---------|------------------|-------------|
| **Executive Director** | Full access, executive view | High-level metrics, trends, financial summaries |
| **Membership Manager** | Full access | Detailed membership data, action items, renewal tracking |
| **Development Staff** | Partial access | Acquisition metrics, financial data |
| **Program Staff** | Partial access | Engagement metrics, event participation |
| **Finance Staff** | Partial access | Financial metrics, revenue tracking |

## Key Dashboard Components

### 1. Membership Overview Section

#### 1.1 Key Metrics Component

**Type**: Metric cards with trend indicators
**Refresh Rate**: Daily
**Data Source**: Membership object

**Metrics Displayed**:
- Total active members
- YTD membership growth (%)
- Current renewal rate (%)
- Average membership tenure
- Lapsed members count

**Visual Elements**:
- Numeric values with up/down indicators
- Spark line for 12-month trend
- Color-coding based on performance thresholds

**Interactions**:
- Click-through to detailed report
- Hover for additional context/calculation method

#### 1.2 Member Distribution by Type Chart

**Type**: Donut chart
**Refresh Rate**: Daily
**Data Source**: Membership and Membership Level objects

**Data Dimensions**:
- Segmentation by membership level
- Color-coding by membership type

**Interactions**:
- Click segment to filter dashboard
- Hover for segment details (count, percentage)

#### 1.3 Membership Trend Chart

**Type**: Line chart
**Refresh Rate**: Monthly
**Data Source**: Membership object (with date tracking)

**Data Dimensions**:
- X-axis: Last 24 months
- Y-axis: Member count
- Lines for: Total members, New members, Renewed members, Lapsed members

**Interactions**:
- Toggle visibility of individual lines
- Zoom to specific date ranges
- Hover for point-in-time values

### 2. Acquisition & Retention Section

#### 2.1 New Member Acquisition Chart

**Type**: Column chart
**Refresh Rate**: Monthly
**Data Source**: Membership object (with join date)

**Data Dimensions**:
- X-axis: Last 12 months
- Y-axis: New member count
- Segments: Membership levels (stacked)

**Interactions**:
- Compare to previous year (toggle overlay)
- Drill down to source of acquisition

#### 2.2 Member Source Analysis

**Type**: Funnel or horizontal bar chart
**Refresh Rate**: Quarterly
**Data Source**: Membership object (Join Method field)

**Data Dimensions**:
- Membership acquisition sources
- Count and percentage per source

**Interactions**:
- Filter by date range
- Drill down to detailed source report

#### 2.3 Retention Rate Metrics

**Type**: Gauges with historical comparison
**Refresh Rate**: Monthly
**Data Source**: Calculated field based on Membership History

**Metrics Displayed**:
- Overall retention rate
- First-year retention rate
- Multi-year retention rate

**Visual Elements**:
- Gauge showing current rate vs. target
- Year-over-year comparison indicator
- Color coding based on thresholds

### 3. Renewal Management Section

#### 3.1 Upcoming Renewals Component

**Type**: Table with action buttons
**Refresh Rate**: Daily
**Data Source**: Membership object (filtered by end date)

**Data Columns**:
- Member name (with link to record)
- Membership level
- Expiration date
- Days remaining
- Previous renewal history indicator
- Status of renewal outreach

**Interactions**:
- Filter by timeframe (30/60/90 days)
- Sort by any column
- Direct action buttons (send reminder, mark contacted)

#### 3.2 Renewal Performance Chart

**Type**: Combination chart (column + line)
**Refresh Rate**: Monthly
**Data Source**: Membership History object

**Data Dimensions**:
- X-axis: Last 12 months
- Y-axis 1: Number of renewals due
- Y-axis 2: Renewal rate percentage

**Visual Elements**:
- Columns showing renewals due
- Line showing renewal rate
- Target renewal rate indicator

**Interactions**:
- Segment by membership level
- Compare to previous year
- Drill down to specific month

#### 3.3 Lapsed Member Recovery Component

**Type**: KPI metrics with supporting list
**Refresh Rate**: Monthly
**Data Source**: Membership object (lapsed status)

**Metrics Displayed**:
- Recently lapsed members (last 90 days)
- Lapsed member recovery rate
- Average time to recovery

**Supporting Data**:
- List of recently recovered members
- List of high-priority lapsed members for outreach

### 4. Member Engagement Section

#### 4.1 Event Participation Chart

**Type**: Heat map calendar
**Refresh Rate**: Event-driven
**Data Source**: Event and Member Event Participation objects

**Data Dimensions**:
- X-axis: Calendar dates
- Y-axis: Event types
- Color intensity: Participation level

**Interactions**:
- Click event for participant details
- Filter by event type or date range
- Toggle between absolute count and percentage views

#### 4.2 Member Engagement Score Distribution

**Type**: Histogram
**Refresh Rate**: Monthly
**Data Source**: Calculated engagement score field

**Data Dimensions**:
- X-axis: Engagement score ranges
- Y-axis: Member count
- Segments: Membership levels or duration brackets

**Visual Elements**:
- Distribution curve overlay
- Threshold indicators for engagement levels
- Average score indicator

**Interactions**:
- Compare distributions across membership levels
- Drill down to member list by engagement score range

#### 4.3 Top Engaged Members Component

**Type**: Scrolling table
**Refresh Rate**: Monthly
**Data Source**: Calculated engagement score field

**Data Columns**:
- Member name
- Membership level
- Engagement score
- Recent activities
- Membership tenure

**Interactions**:
- Filter by various criteria
- Export to outreach list
- Direct link to member record

### 5. Financial Performance Section

#### 5.1 Membership Revenue Chart

**Type**: Stacked column chart
**Refresh Rate**: Monthly
**Data Source**: Membership and Payment objects

**Data Dimensions**:
- X-axis: Months (current fiscal year)
- Y-axis: Revenue amount
- Segments: Membership levels

**Visual Elements**:
- Target line overlay
- Previous year comparison
- YTD total

**Interactions**:
- Toggle between monthly and cumulative views
- Drill down to detailed revenue report
- Filter by membership level

#### 5.2 Revenue Forecast Component

**Type**: Line chart with projection
**Refresh Rate**: Monthly
**Data Source**: Membership object (renewal dates + dues)

**Data Dimensions**:
- X-axis: Next 12 months
- Y-axis: Projected revenue
- Segments: Confirmed vs. projected renewals

**Visual Elements**:
- Solid line for confirmed revenue
- Dashed line for projected revenue
- Confidence interval shading

**Interactions**:
- Adjust renewal rate assumptions
- Toggle between monthly and cumulative views
- Drill down to renewal detail

## Dashboard Filters and Controls

### Global Filters

These filters apply to all dashboard components simultaneously:

1. **Date Range Filter**
   - Quick selections: Current month, quarter, year, fiscal year
   - Custom date range picker with comparison option

2. **Membership Level Filter**
   - Multi-select checkboxes for all membership levels
   - "Select All" and "Clear All" options

3. **Membership Type Filter**
   - Individual vs. Organizational membership toggle

4. **Member Tenure Filter**
   - Ranges: <1 year, 1-2 years, 3-5 years, 5+ years
   - Range slider option

### Component-Specific Controls

Each component may have additional controls specific to its functionality:

1. **View Toggle**: Switch between different visualizations of the same data
2. **Metric Selector**: Choose primary metrics for certain components
3. **Data Granularity**: Adjust time increments (daily, weekly, monthly)
4. **Comparison Options**: Select baseline for comparisons (previous period, target)

## Dashboard Layout and Responsiveness

### Desktop Layout

The desktop view is organized into a three-column grid layout:

```
┌───────────────┬───────────────┬───────────────┐
│ Global        │ Key Metrics   │ Member        │
│ Filters       │ Component     │ Distribution  │
│               │               │ Chart         │
├───────────────┴───────────────┴───────────────┤
│                                               │
│            Membership Trend Chart             │
│                                               │
├───────────┬─────────────────────┬─────────────┤
│ New Member│ Retention Rate      │ Member      │
│ Acquisition│ Metrics            │ Source      │
│ Chart     │                     │ Analysis    │
├───────────┴─────────────────────┼─────────────┤
│ Upcoming Renewals Component     │ Renewal     │
│                                 │ Performance │
│                                 │ Chart       │
├─────────────────────────────────┴─────────────┤
│                                               │
│            Event Participation Chart          │
│                                               │
├───────────────┬───────────────┬───────────────┤
│ Engagement    │ Top Engaged   │ Lapsed Member │
│ Score         │ Members       │ Recovery      │
│ Distribution  │ Component     │ Component     │
├───────────────┴───────────────┴───────────────┤
│                                               │
│            Membership Revenue Chart           │
│                                               │
├───────────────────────────┬───────────────────┤
│ Revenue Forecast Component│ Financial KPIs    │
│                           │                   │
└───────────────────────────┴───────────────────┘
```

### Mobile Responsiveness

For mobile devices, the components will stack vertically in order of importance:

1. Key Metrics Component
2. Member Distribution Chart
3. Upcoming Renewals Component
4. Membership Trend Chart (simplified view)
5. New Member Acquisition Chart
6. Retention Rate Metrics
7. Remaining components (scrollable)

## Data Refresh and Performance

### Refresh Schedule

- **Real-time updates**: Member count metrics, upcoming renewals
- **Daily updates**: Event participation, engagement scores
- **Monthly updates**: Trend charts, revenue projections
- **Manual refresh option**: For on-demand updates

### Performance Optimization

- Pre-calculated aggregate records for historical trends
- Data volume management through filtering and aggregation
- Progressive loading of dashboard components
- Caching of non-real-time components

## Technical Implementation

### Built With

- Lightning Dashboard framework
- Lightning Web Components for custom visualizations
- Salesforce Report data sources
- Custom rollup summary fields for aggregated metrics

### Required Custom Fields

1. **On Membership Object**:
   - Engagement_Score__c (Formula, Number)
   - Days_Until_Renewal__c (Formula, Number)
   - Renewal_Probability__c (Percent)

2. **On Contact/Account**:
   - Membership_Tenure__c (Formula, Number)
   - Lifetime_Value__c (Currency)
   - Last_Event_Date__c (Date)

### Dependent Reports

1. Membership Status Report
2. New Member Acquisition Report
3. Renewal Performance Report
4. Member Engagement Report
5. Membership Revenue Report

## Accessibility Considerations

The dashboard adheres to WCAG 2.1 AA standards:

1. **Color considerations**:
   - All information conveyed by color is also available through text
   - Color contrast ratios meet minimum 4.5:1 requirement
   - Colorblind-friendly palette

2. **Screen reader support**:
   - All charts include alternative text descriptions
   - Table data includes proper headers and row labels
   - Interactive elements have appropriate ARIA labels

3. **Keyboard navigation**:
   - All interactive elements are keyboard accessible
   - Logical tab order throughout the dashboard
   - Keyboard shortcuts for common actions

## Testing Requirements

### Functional Testing

- Verify all filters correctly update all relevant components
- Confirm calculations match expected results
- Test drill-down and click-through functionality
- Verify date arithmetic for renewals and projections

### Cross-Browser/Device Testing

- Test on standard Salesforce supported browsers
- Verify mobile responsiveness on iOS and Android devices
- Test on both Lightning Experience and Salesforce Mobile App

### Performance Testing

- Load time under 3 seconds for initial dashboard
- Filter response time under 1 second
- Data accuracy verification against source reports

## Future Enhancements (Phase 2)

The following features are planned for future iterations:

1. **Predictive Analytics**:
   - Churn prediction indicators for at-risk members
   - Renewal probability scores
   - Engagement trend predictions

2. **Advanced Segmentation**:
   - Geographic heat maps of membership distribution
   - Demographic analysis components
   - Interest and participation correlation analysis

3. **External Benchmarking**:
   - Industry standard comparisons
   - Peer organization anonymized metrics
   - Historical organizational benchmarks

4. **Actionable Intelligence**:
   - AI-powered recommendations for engagement strategies
   - Automated member segment identification
   - Optimized outreach timing suggestions

## Documentation and Training

### For Dashboard Administrators

- Dashboard configuration guide
- Customization options documentation
- Calculation methodologies reference
- Troubleshooting procedures

### For End Users

- Interactive walkthrough tutorial
- Metric definition guide
- Common use case examples
- FAQ document
- Quick reference card 