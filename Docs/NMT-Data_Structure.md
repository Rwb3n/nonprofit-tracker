---
Title: Nonprofit Membership Tracking - Data Structure
Project: Nonprofit Membership Tracking
Phase: Design
Status: Completed
Last Updated: 2025-03-28
---

# Nonprofit Membership Tracking - Data Structure

## Overview

This document outlines the data structure design for the Nonprofit Membership Tracking system built on Salesforce NPSP. The system aims to track:

- Membership categories and levels
- Membership lifecycle (application, approval, renewal)
- Member engagement and participation
- Membership dues and payments

## Objects and Relationships

### Core Objects

1. **Contact** (Standard Salesforce/NPSP)
   - Primary record for individual members
   - Extended with membership-specific fields

2. **Account** (Standard Salesforce/NPSP)
   - Organizations that may have multiple member contacts
   - Used for organizational memberships

3. **Membership** (Custom Object)
   - Central object tracking membership status and details
   - Lookup to Contact (individual) OR Account (organizational)
   - Master-detail relationship with Membership History

4. **Membership Level** (Custom Object)
   - Catalog of available membership types and benefits
   - Referenced by Membership records

5. **Membership History** (Custom Object)
   - Tracks historical changes to memberships
   - Connected via master-detail to Membership

6. **Member Event Participation** (Custom Object)
   - Tracks member attendance at events
   - Junction object between Membership and Event

7. **Event** (Custom Object)
   - Catalog of member events and activities
   - Used for tracking engagement

## Entity Relationship Diagram

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

## Field Details

### Membership (Custom Object)

| Field Name | Type | Description |
|------------|------|-------------|
| Name | Auto Number | Unique identifier (MEM-XXXXX) |
| Contact | Lookup(Contact) | Individual member (if applicable) |
| Account | Lookup(Account) | Organizational member (if applicable) |
| Membership Level | Lookup(Membership Level) | Level of membership |
| Start Date | Date | When membership becomes active |
| End Date | Date | When membership expires |
| Status | Picklist | Active, Pending, Expired, Cancelled |
| Renewal Type | Picklist | Manual, Automatic |
| Join Method | Picklist | Online, In-person, Phone, Referral |
| Last Renewal Date | Date | Most recent renewal date |
| Dues Amount | Currency | Amount paid for membership |
| Payment Status | Picklist | Paid, Pending, Overdue |
| Auto-Renew | Checkbox | Whether membership should auto-renew |
| Member Since | Date | Original join date |
| Referral Source | Text | How member learned about organization |
| Special Notes | Long Text Area | Additional member information |

### Membership Level (Custom Object)

| Field Name | Type | Description |
|------------|------|-------------|
| Name | Text | Level name (e.g., "Bronze", "Silver", "Gold") |
| Annual Fee | Currency | Standard yearly dues amount |
| Description | Rich Text | Detailed level description |
| Benefits | Rich Text | List of membership benefits |
| Requires Approval | Checkbox | Whether admin approval is required |
| Duration (Months) | Number | Standard term length |
| Available To | Picklist | Individuals, Organizations, Both |
| Display Order | Number | Sequence for display in forms |
| Active | Checkbox | Whether level is currently offered |

### Membership History (Custom Object)

| Field Name | Type | Description |
|------------|------|-------------|
| Membership | Master-Detail(Membership) | Associated membership record |
| Change Date | Date/Time | When change occurred |
| Previous Status | Picklist | Prior membership status |
| New Status | Picklist | Updated membership status |
| Previous Level | Lookup(Membership Level) | Prior membership level |
| New Level | Lookup(Membership Level) | Updated membership level |
| Change Reason | Text | Why change occurred |
| Changed By | Lookup(User) | Who processed the change |

## Custom Fields on Standard Objects

### Contact (Standard Object)

| Field Name | Type | Description |
|------------|------|-------------|
| Is Member | Formula (Boolean) | Whether contact has active membership |
| Current Membership | Lookup(Membership) | Most recent membership record |
| Membership Status | Formula (Text) | Displays current status |
| Days Until Renewal | Formula (Number) | Days until membership expires |
| Membership Since | Formula (Date) | Original join date |
| Total Membership Years | Formula (Number) | Cumulative years as member |

## Implementation Notes

1. Triggers will be used to:
   - Create Membership History records when status changes
   - Update Contact/Account fields when membership changes
   - Calculate renewal dates and send notifications

2. Field-level security considerations:
   - Payment information visible only to Finance roles
   - Member notes visible only to Member Services roles

3. Process automation will include:
   - Membership renewal reminders (60, 30, 14, 7 days before expiration)
   - Automated status changes when membership expires
   - Onboarding welcome process for new members 