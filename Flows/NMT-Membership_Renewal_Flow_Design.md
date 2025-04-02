---
title: "Nonprofit Membership Tracking - Membership Renewal Flow Design"
project: "Nonprofit Membership Tracking"
type: "Flow"
phase: "Design"
status: "Draft"
version: "1.0"
created: "2025-04-05"
updated: "2025-04-05"
author: "Flow Design Team"
---

# Membership Renewal Flow Design

## Flow Overview

The Membership Renewal Flow automates the process of renewing existing memberships, including notification scheduling, renewal options presentation, payment processing, and membership record updates. This flow can be triggered from multiple entry points:

1. Auto-launched from a scheduled process (for notification generation)
2. Screen Flow - Staff-assisted renewal (call center or in-person)
3. Quick Action - From Membership record when manually processing a renewal
4. Member Portal - Self-service renewal by members (if implemented)

## Flow Metadata

- **API Name**: NMT_Membership_Renewal_Flow
- **Type**: Screen Flow & Auto-launched Flow (dual-purpose)
- **Description**: Handles membership renewal process
- **Runtime**: User or System (depending on context)
- **Protection**: Protected to prevent modification

## Flow Diagram

```
START
  │
  ▼
GET INPUT VARIABLES
  │
  ▼
DECISION: Trigger Type
  │
  ├─► Notification         ├─► Self-Service      ├─► Staff-Assisted
  │       │                │       │             │       │
  │       ▼                │       ▼             │       ▼
  │   GET EXPIRING MEMBRS  │  LOAD MEMBERSHIP    │  LOAD MEMBERSHIP
  │       │                │       │             │       │
  │       ▼                │       ▼             │       ▼
  │  CALC. TIME REMAINING  │  DISPLAY MEMBERSHIP │  DISPLAY MEMBERSHIP 
  │       │                │  DETAILS            │  DETAILS
  │       ▼                │       │             │       │
  │  CREATE NOTIFICATIONS  │       ▼             │       ▼
  │       │                │  MEMBERSHIP LEVEL   │  MEMBERSHIP LEVEL
  │                        │  OPTIONS            │  OPTIONS
  │                        │       │             │       │
  │                        │       ▼             │       ▼
  │                        │  PAYMENT OPTIONS    │  PAYMENT OPTIONS
  │                        │       │             │       │
  └────────────────────────┘       ▼             │       ▼
                               PROCESS PAYMENT    │  PROCESS PAYMENT
                                    │             │       │
                                    └─────────────┘       │
                                           │              │
                                           ▼              │
                                    CREATE RENEWAL RECORD │
                                           │              │
                                           ▼              │
                                    UPDATE MEMBERSHIP     │
                                           │              │
                                           ▼              │
                                    SEND CONFIRMATION     │
                                           │              │
                                           └──────────────┘
                                                  │
                                                  ▼
                                                 END
```

## Flow Elements in Detail

### 1. Input Variables

| Variable Name | Data Type | Description | Required |
|---------------|-----------|-------------|----------|
| membershipId | Id | Existing membership ID | No |
| triggerType | Text | Notification/Self-Service/Staff-Assisted | Yes |
| contactId | Id | Member contact ID | No |
| accountId | Id | Member account ID (for org memberships) | No |

### 2. Decision: Trigger Type

**Logic**: 
- If triggerType = "Notification" → Generate renewal notices
- If triggerType = "Self-Service" → Process member-initiated renewal
- If triggerType = "Staff-Assisted" → Process staff-assisted renewal

### 3. Notification Branch

#### 3.1 Get Expiring Memberships

**Operations**:
- Query for memberships where End Date is within configured window
- Filter by notification preference (email, text, both)
- Group by days remaining until expiration (60, 30, 14, 7)

#### 3.2 Calculate Time Remaining

**Formula**:
```
(Membership__c.End_Date__c - TODAY())
```

**Logic**:
- Group memberships by notification thresholds
- Set notification type based on days remaining

#### 3.3 Create Notifications

**Operations**:
- For each membership:
  - Generate appropriate notification based on days remaining
  - Create Task for membership team if configured
  - Record notification in Activity History

### 4. Self-Service Branch

#### 4.1 Load Membership

**Operations**:
- Query for membership record and related data
- Get current membership level, status, and end date
- Check eligibility for renewal (not too early, not expired too long)

#### 4.2 Display Membership Details

**Elements**:
- Current membership details (level, benefits, dates)
- Current status and expiration date
- Membership history summary
- Confirmation of intent to renew

#### 4.3 Membership Level Options

**Elements**:
- Current level (pre-selected)
- Available upgrade/downgrade options
- Level benefits comparison
- Term options (if applicable)

**Logic**:
- Filter available levels based on membership type (individual/org)
- Calculate pricing for each level

#### 4.4 Payment Options

**Elements**:
- Calculated renewal amount
- Payment method options
- Credit card form (if applicable)
- Invoice request option (if applicable)
- Terms and conditions

### 5. Staff-Assisted Branch

**Similar to Self-Service branch with additional options**:
- Override pricing options
- Apply special discounts
- Set custom renewal date
- Add internal notes
- Skip payment processing if needed

### 6. Process Payment

**Logic**:
- If paymentMethod = "Credit Card": Process payment
- If paymentMethod = "Invoice": Set paymentStatus = "Pending"
- If paymentMethod = "Waived": Set paymentStatus = "Paid", duesAmount = 0

**Error Handling**:
- Catch payment failures and provide retry option
- Log payment attempts

### 7. Create Renewal Record

**Record Creation**:
- New Membership_History__c record
- Store previous and new membership details
- Record renewal date and method
- Store payment information

### 8. Update Membership

**Operations**:
- Update Membership Start/End Dates
- Update Status = "Active"
- Update Payment Status based on payment processing
- Update Last Renewal Date
- Update Membership Level (if changed)

### 9. Send Confirmation

**Operations**:
- Generate confirmation email/text based on preferences
- Include renewal details and receipt
- Add calendar invite for next renewal (optional)
- Notify membership team of successful renewal

## Key Variables and Formulas

### Variables

| Variable Name | Data Type | Initial Value | Description |
|---------------|-----------|--------------|-------------|
| membershipId | Id | null | Membership record ID |
| membershipLevel | Text | null | Current/new membership level |
| renewalAmount | Currency | 0 | Calculated renewal fee |
| paymentStatus | Text | "Pending" | Status of payment |
| renewalDate | Date | TODAY() | Date of renewal transaction |
| newEndDate | Date | null | New calculated end date |
| membershipChanged | Boolean | false | Whether level was changed |

### Key Formulas

**Renewal Amount Calculation**:
```
IF(
    Apply_Discount__c,
    Membership_Level__r.Annual_Fee__c * (1 - Discount_Percentage__c/100),
    Membership_Level__r.Annual_Fee__c
)
```

**New End Date Calculation**:
```
IF(
    Custom_End_Date__c != null,
    Custom_End_Date__c,
    IF(
        End_Date__c > TODAY(),
        ADDMONTHS(End_Date__c, Membership_Level__r.Duration_Months__c),
        ADDMONTHS(TODAY(), Membership_Level__r.Duration_Months__c)
    )
)
```

## Implementation Considerations

1. **Notification Schedule**:
   - Default reminders at 60, 30, 14, and 7 days before expiration
   - Configurable through Custom Settings
   - Option for admin to customize notification text

2. **Renewal Eligibility Rules**:
   - Renewals permitted starting 60 days before expiration
   - Grace period of 30 days after expiration
   - Different rules for different membership levels
   
3. **Prorated Renewals**:
   - Option to calculate prorated amounts for early renewals
   - Support for partial year renewals (configurable)
   
4. **Multiple Renewal Option**:
   - Support for multi-year renewals with appropriate pricing
   - Option to auto-apply multi-year discounts

5. **Edge Cases**:
   - Handling membership level changes during renewal
   - Process for handling expired memberships beyond grace period
   - Special approval handling for certain level changes

## Testing Scenarios

1. Standard renewal of active membership
2. Early renewal (more than 30 days before expiration)
3. Late renewal (within grace period)
4. Very late renewal (after grace period)
5. Renewal with membership level change
6. Renewal with failed payment
7. Renewal with invoice request
8. Discount or promo code application
9. Multi-year renewal

## Related Configurations

- **Custom Metadata Types**: Renewal notification templates
- **Process Builder**: Post-renewal follow-up processes
- **Custom Settings**: Notification schedules and renewal windows
- **Permission Sets**: Access controls for renewal overrides

## Future Enhancements

1. **Auto-Renewal Support**:
   - Save payment method for automatic processing
   - Pre-renewal notification with opt-out option
   - Automatic retry for failed payments

2. **Membership Bundle Renewals**:
   - Support for renewing multiple related memberships
   - Household/family renewal options
   - Organizational membership with multiple contacts

3. **Advanced Pricing**:
   - Dynamic pricing based on member attributes
   - Loyalty discounts for long-term members
   - Bundle discounts for multiple services 