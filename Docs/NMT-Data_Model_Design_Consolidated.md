---
title: "Nonprofit Membership Tracking - Data Model Design"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Active"
version: "1.2"
created: "2025-03-26"
updated: "2025-04-09"
author: "Documentation Team"
---

# Nonprofit Membership Tracking - Data Model Design

## Overview

This document outlines the comprehensive data model design for the Nonprofit Membership Tracking system built on Salesforce NPSP. The system aims to track:

- Membership categories and levels
- Membership lifecycle (application, approval, renewal)
- Member engagement and participation
- Membership dues and payments

*Note: This document reflects design decisions made up to the version indicated. A locked version `NMT-Data_Model_Design_Consolidated_v_1_locked.md` captures the state prior to the event participation refactoring audit.*

## Design Principles

The data model follows these key principles:

1. **Integration with NPSP**: Utilize and extend NPSP's data structure rather than replacing it
2. **Separation of Concerns**: Keep membership data distinct but connected to constituent records
3. **Historical Tracking**: Maintain history of changes for audit and analysis purposes
4. **Flexibility**: Support both individual and organizational memberships
5. **Scalability**: Design for growth in membership volume and complexity

## Entity Relationship Diagram

*Note: The ASCII ERD below reflects the initial design. Refer to the Mermaid ERD generated on 2025-04-09 for the revised structure focusing on `Member Event Participation`.*
```
Contact (1) ◄─────── (n) Membership (n) ─────► (n) Event
    ▲                    │       ▲                     
    │                    │       │                     
    │                    │       │                     
Account (1) ◄────────┘       │                     
                             │                     
            Membership Level (1) ◄───┘                 
                             ▲                         
                             │                         
                             │                         
                    Membership History (n)              
```

## Object Details

### Standard Objects Used

#### Contact (Standard Salesforce/NPSP)
Primary record for individual constituent information. Extended with membership-specific fields.

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

**Purpose**: Junction object to track individual participation in events. The `Contact` is the primary link representing the participant. Links to `Membership` and `Account` are optional, providing context for how the Contact participated (e.g., via an individual membership, representing an organization).

**Relationships**:
- Contact (Lookup): Required link to the participating Contact.
- Event (Lookup): Required link to the associated Event.
- Membership (Lookup): Optional link if participation is associated with a specific Membership record.
- Account (Lookup): Optional link if participation represents an Organization.

**Key Fields**:

| Field Name        | Type               | Description                              | Required |
| ----------------- | ------------------ | ---------------------------------------- | -------- |
| Participation ID  | Auto Number        | Unique identifier (MEP-XXXXX)            | Yes      |
| Contact           | Lookup(Contact)    | Required: Who participated               | Yes      |
| Event             | Lookup(Event)      | Required: Associated event               | Yes      |
| Membership        | Lookup(Membership) | Optional: Associated membership          | No       |
| Account           | Lookup(Account)    | Optional: Associated Organization        | No       |
| Registration Date | Date               | When member registered                   | Yes      |
| Attendance Status | Picklist           | Registered, Attended, No-Show, Cancelled | Yes      |
| Feedback Score    | Number(1-5)        | Member satisfaction rating               | No       |
| Feedback Comments | Long Text Area     | Member feedback                          | No       |


**Validation Rules**:
- Registration Date must be before Event Date
- Feedback Score must be between 1-5 if provided
- *New Rule:* If `Membership__c` is populated and `Membership__r.Contact__c` is not null, then `Contact__c` must equal `Membership__r.Contact__c` (Ensures consistency for individual memberships).

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

| Field Name                         | Type                 | Description                           | Required |
| ---------------------------------- | -------------------- | ------------------------------------- | -------- |
| Is Member                          | Formula (Boolean)    | Whether contact has active membership | N/A      |
| Current Membership                 | Lookup(Membership)   | Most recent membership record         | No       |
| Membership Status                  | Formula (Text)       | Displays current status               | N/A      |
| Days Until Renewal                 | Formula (Number)     | Days until membership expires         | N/A      |
| Membership Since                   | Formula (Date)       | Original join date                    | N/A      |
| Total Membership Years             | Formula (Number)     | Cumulative years as member            | N/A      |
| Engagement Score                   | Number               | Calculated member engagement rating   | No       |
| `Updated`==Last Event Attended==   | *formula* - > Date   | Most recent event participation       | N/A      |
| `Updated`==Events Attended (YTD)== | *formula* - > Number | Count of events this year             | N/A      |

### Account (Standard Object)

| Field Name                | Type               | Description                           | Required |
| ------------------------- | ------------------ | ------------------------------------- | -------- |
| Is Org Member             | Formula (Boolean)  | Whether account has active membership | N/A      |
| Current Membership        | Lookup(Membership) | Most recent membership record         | No       |
| Membership Status         | Formula (Text)     | Displays current status               | N/A      |
| Days Until Renewal        | Formula (Number)   | Days until membership expires         | N/A      |
| Membership Since          | Formula (Date)     | Original join date                    | N/A      |
| Total Membership Years    | Formula (Number)   | Cumulative years as member            | N/A      |
| `TBI`==Member Contacts==  | Roll-Up Summary    | Count of contacts with memberships    | N/A      |

## Formula Fields

### Is Member (Contact)
*NEW (2025-04-02):*
```
IF(ISPICKVAL(Current_Membership__r.Status__c, 'Active'), true, false)
```
*OLD:*
```
IF(Current_Membership__r.Status__c = 'Active', true, false)
```

### Membership Status (Contact)

*NEW (2025-04-02):*
``IF (Current_Membership__c = null, 'Non-Member', TEXT(Current_Membership__r.Status__c))``
*OLD:*
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
ROUND(
  IF(Membership_Since__c = null, 0,
     (TODAY() - Membership_Since__c) / 365), 1)
```

### Is Org Member (Account)
*NEW (2025-04-02):*
```
IF(ISPICKVAL(Current_Membership__r.Status__c, 'Active'), true, false)
```
*OLD:*
```
IF(Current_Membership__r.Status__c = 'Active', true, false)
```

### Membership Status (Account)

*NEW (2025-04-02):*
``IF (Current_Membership__c = null, 'Non-Member', TEXT(Current_Membership__r.Status__c))``
*OLD:*
```
IF(Current_Membership__c = null, 'Non-Member', Current_Membership__r.Status__c)
```

### Days Until Renewal (Account)
```
IF(Current_Membership__c = null, null, 
   Current_Membership__r.End_Date__c - TODAY())
```

### Total Membership Years (Account)
```
ROUND(
  IF(Membership_Since__c = null, 0,
     (TODAY() - Membership_Since__c) / 365), 1)
```


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

## Implementation Notes

1. **Triggers and Automation**:
   - Create Membership History records when status changes
   - Update Contact/Account fields when membership changes
   - Calculate renewal dates and send notifications
   - Membership renewal reminders (60, 30, 14, 7 days before expiration)
   - Automated status changes when membership expires
   - Onboarding welcome process for new members

2. **Field-level Security Considerations**:
   - Payment information visible only to Finance roles
   - Member notes visible only to Member Services roles

3. **Implementation Approach**:
   - Begin with Membership Level object as foundation
   - Next implement Membership object with basic fields
   - Add related objects (History, Event, Participation) after core functionality
   - Complete with formula fields and roll-ups

4. **Future Extensions** (beyond scope of current project):
   - Payment integration for automatic processing
   - Member portal for self-service
   - Additional engagement tracking methods
   - Advanced segmentation capabilities

5. **Performance Considerations**:
   - Monitor roll-up summary field impact on large orgs
   - Consider indexing heavily queried fields
   - Be mindful of formula field complexity

6. **NPSP Integration Notes**:
   - Leverage NPSP Household model for family memberships
   - Use NPSP relationship fields for organizational contacts
   - Consider NPSP Affiliations for organizational relationships

7.  **Event Participation Refactoring (2025-04-09)**: The data model for `Member Event Participation` was revised to make `Contact__c` the required lookup, resolving ambiguity and supporting non-member/organizational participation tracking more effectively. The corresponding automation is shifted towards a modular flow design invoking an Apex service layer for transactional integrity. See `Apex/NMT-Event_Registration_Apex_Service_Design.md`.

## Integration Points

1. **Payment Processing**:
   - Integration with payment processor for dues collection
   - Real-time payment status updates
   - Failed payment handling and retry logic

2. **Email Marketing**:
   - Segment members by level and status
   - Trigger communications based on status changes
   - Event invitations based on membership level

3. **Event Management**:
   - Registration processing
   - Attendance tracking
   - Post-event engagement updates

## Related Documents

- [Membership Onboarding Flow Design](NMT-Membership_Onboarding_Flow_Design.md)
- [Membership Renewal Flow Design](NMT-Membership_Renewal_Flow_Design.md)
- [Payment Status Handling Flow Design](NMT-Payment_Status_Handling_Flow_Design.md)
- [Event Participation Flow Design](NMT-Event_Participation_Flow_Design.md)
- [Dashboard Design](NMT-Dashboard_Design.md) 