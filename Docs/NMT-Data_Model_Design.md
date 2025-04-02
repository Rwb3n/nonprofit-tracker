/* 
 * DEPRECATED: This file will be deleted after review.
 * Content is being merged into NMT-Data_Model_Design_Consolidated.md as part of the documentation consistency initiative.
 * Please refer to Docs/NMT-Data_Model_Design_Consolidated.md for the most up-to-date data model documentation.
 */

---
Title: Nonprofit Membership Tracking - Data Model Design
Project: Nonprofit Membership Tracking
Phase: Design
Status: Draft
Last Updated: 2025-03-26
---

# Nonprofit Membership Tracking - Data Model Design

## Overview

This document outlines the data model design for the Nonprofit Membership Tracking system. The design leverages standard Salesforce and NPSP objects where possible and introduces custom objects to handle membership-specific functionality.

## Design Principles

The data model follows these key principles:

1. **Integration with NPSP**: Utilize and extend NPSP's data structure rather than replacing it
2. **Separation of Concerns**: Keep membership data distinct but connected to constituent records
3. **Historical Tracking**: Maintain history of changes for audit and analysis purposes
4. **Flexibility**: Support both individual and organizational memberships
5. **Scalability**: Design for growth in membership volume and complexity

## Entity Relationship Diagram

```
                   ┌───────────────┐
                   │ Membership    │
                   │ Level         │
                   └───────┬───────┘
                           │
                           │
┌───────────┐       ┌──────▼──────┐       ┌───────────┐
│           │       │             │       │           │
│ Contact   │◄──────┤ Membership  ├───────► Event     │
│           │       │             │       │           │
└─────┬─────┘       └──────┬──────┘       └───────────┘
      │                    │
      │                    │
┌─────▼─────┐       ┌──────▼──────┐
│           │       │             │
│ Account   │       │ Membership  │
│           │       │ History     │
└───────────┘       │             │
                    └─────────────┘
```

## Object Details

### Standard Objects Used

#### Contact (Standard Salesforce/NPSP)
Primary record for individual constituent information. Will be extended with membership-specific fields.

#### Account (Standard Salesforce/NPSP)
Primary record for organizational information. Used for organizational memberships.

### Custom Objects

#### 1. Membership (Custom Object)

**Purpose**: Central object for tracking membership status and details.

**Relationships**:
- Contact (Lookup): Individual member
- Account (Lookup): Organizational member
- Membership Level (Lookup): Level of membership
- Membership History (Master-Detail): Historical changes

**Key Fields**:

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Name | Auto Number | Unique identifier (MEM-XXXXX) | Yes |
| Contact | Lookup(Contact) | Individual member (if applicable) | No* |
| Account | Lookup(Account) | Organizational member (if applicable) | No* |
| Membership Level | Lookup(Membership Level) | Current level of membership | Yes |
| Start Date | Date | When membership becomes active | Yes |
| End Date | Date | When membership expires | Yes |
| Status | Picklist | Active, Pending, Expired, Cancelled | Yes |
| Renewal Type | Picklist | Manual, Automatic | Yes |
| Join Method | Picklist | Online, In-person, Phone, Referral | Yes |
| Last Renewal Date | Date | Most recent renewal date | No |
| Dues Amount | Currency | Amount paid for membership | Yes |
| Payment Status | Picklist | Paid, Pending, Overdue | Yes |
| Auto-Renew | Checkbox | Whether membership should auto-renew | No |
| Member Since | Date | Original join date (consistent across renewals) | Yes |
| Referral Source | Text | How member learned about organization | No |
| Special Notes | Long Text Area | Additional member information | No |
| Previous Level | Lookup(Membership Level) | Level before most recent change | No |

*Either Contact OR Account must be populated

**Validation Rules**:
- Either Contact OR Account must be populated, but not both
- End Date must be after Start Date
- Status must be consistent with dates (e.g., Active status requires End Date in future)

**Record Types**:
- Individual Membership
- Organizational Membership

#### 2. Membership Level (Custom Object)

**Purpose**: Catalog of available membership types and benefits.

**Relationships**:
- Membership (Child Relationship): Memberships at this level

**Key Fields**:

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Name | Text | Level name (e.g., "Bronze", "Silver", "Gold") | Yes |
| Annual Fee | Currency | Standard yearly dues amount | Yes |
| Description | Rich Text | Detailed level description | Yes |
| Benefits | Rich Text | List of membership benefits | Yes |
| Requires Approval | Checkbox | Whether admin approval is required | Yes |
| Duration (Months) | Number | Standard term length | Yes |
| Available To | Picklist | Individuals, Organizations, Both | Yes |
| Display Order | Number | Sequence for display in forms | Yes |
| Active | Checkbox | Whether level is currently offered | Yes |
| Grace Period (Days) | Number | Days after expiration before status change | Yes |

**Validation Rules**:
- Annual Fee must be >= 0
- Duration must be > 0
- Display Order must be unique

#### 3. Membership History (Custom Object)

**Purpose**: Tracks historical changes to memberships.

**Relationships**:
- Membership (Master-Detail): Associated membership record

**Key Fields**:

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Membership | Master-Detail(Membership) | Associated membership record | Yes |
| Change Date | Date/Time | When change occurred | Yes |
| Previous Status | Picklist | Prior membership status | No |
| New Status | Picklist | Updated membership status | No |
| Previous Level | Lookup(Membership Level) | Prior membership level | No |
| New Level | Lookup(Membership Level) | Updated membership level | No |
| Change Reason | Text | Why change occurred | No |
| Changed By | Lookup(User) | Who processed the change | Yes |

**Validation Rules**:
- At least one change field (Status or Level) must be populated

#### 4. Member Event Participation (Custom Object)

**Purpose**: Junction object to track member participation in events.

**Relationships**:
- Membership (Lookup): Participating membership
- Event (Lookup): Associated event

**Key Fields**:

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Membership | Lookup(Membership) | Associated membership | Yes |
| Event | Lookup(Event) | Associated event | Yes |
| Registration Date | Date | When member registered | Yes |
| Attendance Status | Picklist | Registered, Attended, No-Show, Cancelled | Yes |
| Feedback Score | Number(1-5) | Member satisfaction rating | No |
| Feedback Comments | Long Text Area | Member feedback | No |

**Validation Rules**:
- Registration Date must be before Event Date
- Feedback Score must be between 1-5 if provided

#### 5. Event (Custom Object)

**Purpose**: Catalog of member events and activities.

**Relationships**:
- Member Event Participation (Child): Participation records

**Key Fields**:

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Name | Text | Event name | Yes |
| Event Date | Date | When event occurs | Yes |
| Description | Rich Text | Event details | Yes |
| Location | Text | Event location | Yes |
| Event Type | Picklist | Workshop, Social, Meeting, etc. | Yes |
| Max Participants | Number | Attendance limit | No |
| Member Only | Checkbox | Whether restricted to members | Yes |
| Required Level | Lookup(Membership Level) | Minimum membership level | No |
| Registration Deadline | Date | Last day to register | No |
| Event Status | Picklist | Planned, Active, Completed, Cancelled | Yes |

**Validation Rules**:
- Registration Deadline must be before Event Date
- Required Level must be populated if Member Only is checked

## Custom Fields on Standard Objects

### Contact (Standard Object)

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Is Member | Formula (Boolean) | Whether contact has active membership | N/A |
| Current Membership | Lookup(Membership) | Most recent membership record | No |
| Membership Status | Formula (Text) | Displays current status | N/A |
| Days Until Renewal | Formula (Number) | Days until membership expires | N/A |
| Membership Since | Formula (Date) | Original join date | N/A |
| Total Membership Years | Formula (Number) | Cumulative years as member | N/A |
| Engagement Score | Number | Calculated member engagement rating | No |
| Last Event Attended | Formula (Date) | Most recent event participation | N/A |
| Events Attended (YTD) | Roll-Up Summary | Count of events this year | N/A |

### Account (Standard Object)

| Field Name | Type | Description | Required |
|------------|------|-------------|----------|
| Is Org Member | Formula (Boolean) | Whether account has active membership | N/A |
| Current Membership | Lookup(Membership) | Most recent membership record | No |
| Membership Status | Formula (Text) | Displays current status | N/A |
| Days Until Renewal | Formula (Number) | Days until membership expires | N/A |
| Membership Since | Formula (Date) | Original join date | N/A |
| Total Membership Years | Formula (Number) | Cumulative years as member | N/A |
| Member Contacts | Roll-Up Summary | Count of contacts with memberships | N/A |

## Formula Fields

### Is Member (Contact)
```
IF(Current_Membership__r.Status__c = 'Active', true, false)
```

### Membership Status (Contact)
```
IF(Current_Membership__c = null, 'Non-Member', Current_Membership__r.Status__c)
```

### Days Until Renewal (Contact)
```
IF(Current_Membership__c = null, null, 
   Current_Membership__r.End_Date__c - TODAY())
```

### Total Membership Years (Contact)
```
IF(Membership_Since__c = null, 0,
   ROUND((TODAY() - Membership_Since__c) / 365, 1))
```

## Roll-Up Summary Fields

### Events Attended (YTD) (Contact)
Count of Member Event Participation records where:
- Attendance Status = 'Attended'
- Event Date = THIS_YEAR

### Member Contacts (Account)
Count of Contact records where:
- Contact.Is_Member__c = true
- Contact.AccountId = Account.Id

## Automation Requirements

The data model will require these automation components:

1. **Membership Record Trigger/Flow**: 
   - Updates Contact/Account Current_Membership field when Membership status changes
   - Creates Membership History records when status or level changes
   - Calculates End Date based on Start Date and Level Duration

2. **Renewal Date Calculation**:
   - Formula to calculate End Date based on membership level duration
   - Flow to handle prorated membership periods

3. **Status Transitions**:
   - Automatic transition from Active to Expired when End Date passes
   - Respect Grace Period setting from Membership Level

4. **Event Participation Tracking**:
   - Update engagement scores based on attendance
   - Roll-up statistics to the Membership record

## Data Migration Considerations

For a real implementation (not part of this demo project), these data migration considerations would apply:

1. **Existing Member Data**:
   - Import from existing spreadsheets/systems
   - Create historical records for accurate membership duration calculations
   - Backfill participation records if available

2. **Duplicate Management**:
   - Implement matching rules to prevent duplicates during import
   - Handle merged contact records appropriately

## Security Model

### Object-Level Security

| Object | Admin | Membership Coordinator | Development Staff | Executive |
|--------|-------|------------------------|-------------------|-----------|
| Membership | CRUD | CRUD | Read, Update | Read |
| Membership Level | CRUD | Read | Read | Read |
| Membership History | CRUD | Read | Read | Read |
| Member Event Participation | CRUD | CRUD | Read | Read |
| Event | CRUD | CRUD | Read | Read |

### Field-Level Security

| Field | Admin | Membership Coordinator | Development Staff | Executive |
|-------|-------|------------------------|-------------------|-----------|
| Payment Information | Visible | Visible | Not Visible | Not Visible |
| Dues Amount | Visible | Visible | Visible | Visible |
| Special Notes | Visible | Visible | Visible | Not Visible |
| Internal Fields | Visible | Not Visible | Not Visible | Not Visible |

## Notes and Considerations

1. **Implementation Approach**:
   - Begin with Membership Level object as foundation
   - Next implement Membership object with basic fields
   - Add related objects (History, Event, Participation) after core functionality
   - Complete with formula fields and roll-ups

2. **Future Extensions** (beyond scope of current project):
   - Payment integration for automatic processing
   - Member portal for self-service
   - Additional engagement tracking methods
   - Advanced segmentation capabilities

3. **Performance Considerations**:
   - Monitor roll-up summary field impact on large orgs
   - Consider indexing heavily queried fields
   - Be mindful of formula field complexity

4. **NPSP Integration Notes**:
   - Leverage NPSP Household model for family memberships
   - Use NPSP relationship fields for organizational contacts
   - Consider NPSP Affiliations for organizational relationships 