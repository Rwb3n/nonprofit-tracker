---
title: "Nonprofit Membership Tracking - Event Participation Flow Design"
project: "Nonprofit Membership Tracking"
type: "Flow Design"
phase: "Design"
status: "Active"
version: "1.0"
created: "2025-04-06"
updated: "2025-04-07"
author: "Flow Design Team"
---

# Nonprofit Membership Tracking - Event Participation Flow Design

## Overview

The Event Participation Flow manages the end-to-end process of registering members for events, tracking their participation, and updating engagement metrics based on attendance. This flow enables nonprofit organizations to efficiently manage event registrations, send automated communications to participants, process event-related payments when applicable, and generate comprehensive participation reports that enhance member engagement tracking.

## Flow Metadata

- **API Name**: NMT_Event_Participation_Flow
- **Type**: Screen Flow & Auto-launched Flow (dual-purpose)
- **Description**: Manages event registration, participation tracking, and engagement calculations
- **Runtime**: User (for staff usage) or System (for portal/API integration)
- **Protection**: Protected to prevent modification
- **Categories**: Registration, Participation, Engagement, Events

## Flow Diagram

```
START
  │
  ▼
GET INPUT VARIABLES ─────────────────────────────────────┐
  │                                                      │
  ▼                                                      │
DETERMINE REGISTRATION TYPE                              │
  │                                                      │
  ├─► Member Registration                                │
  │       │                                              │
  │       ▼                                              │
  │   VALIDATE MEMBERSHIP                                │
  │       │                                              │
  │       ▼                                              │
  │   APPLY MEMBER RULES ──┐                             │
  │                        │                             │
  ├─► Non-Member Registration                            │
  │       │                                              │
  │       ▼                                              │
  │   CREATE/UPDATE CONTACT                              │
  │       │                                              │
  │       ▼                                              │
  │   APPLY NON-MEMBER RULES                             │
  │       │                                              │
  └─► Guest Registration                                 │
          │                                              │
          ▼                                              │
      VALIDATE PRIMARY MEMBER                            │
          │                                              │
          ▼                                              │
      APPLY GUEST RULES                                  │
          │                                              │
          ▼                                              │
      COLLECT GUEST DETAILS                              │
          │                                              │
  ┌───────┴────────┐                                     │
  ▼                ▼                                     │
CHECK EVENT      GET EVENT DETAILS                       │
CAPACITY           │                                     │
  │                │                                     │
  ├─► At Capacity  │                                     │
  │     │          │                                     │
  │     ▼          │                                     │
  │  PROCESS       │                                     │
  │  WAITLIST      │                                     │
  │     │          │                                     │
  │     │          │                                     │
  ▼     ▼          ▼                                     │
EVALUATE PAYMENT REQUIREMENTS                            │
  │                                                      │
  ├─► Payment Required                                   │
  │       │                                              │
  │       ▼                                              │
  │   CALCULATE PAYMENT AMOUNT                           │
  │       │                                              │
  │       ▼                                              │
  │   PROCESS PAYMENT/INVOICE                            │
  │       │                                              │
  │       ▼                                              │
  │   UPDATE PAYMENT STATUS                              │
  │       │                                              │
  │       │                                              │
  ▼       ▼                                              │
CREATE PARTICIPATION RECORD(S)                           │
  │                                                      │
  ▼                                                      │
GENERATE COMMUNICATIONS                                  │
  │                                                      │
  ├─► Confirmation Email                                 │
  │                                                      │
  ├─► Calendar Invitation                                │
  │                                                      │
  ├─► Receipt (if payment processed)                     │
  │                                                      │
  ▼                                                      │
SCHEDULE FOLLOW-UP COMMUNICATIONS                        │
  │                                                      │
  ▼                                                      │
UPDATE EVENT CAPACITY                                    │
  │                                                      │
  ▼                                                      │
RETURN RESPONSE ────────────────────────────────────────┘
  │
  ▼
END
```

## Flow Elements in Detail

### 1. Input Variables

| Variable Name | Data Type | Description | Required | Default |
|---------------|-----------|-------------|----------|---------|
| eventId | Id | ID of the event record | Yes | null |
| memberId | Id | ID of the member registering for the event | No* | null |
| contactId | Id | ID of the contact record for non-member registrations | No* | null |
| registrationType | Text | Member, Non-member, Guest | Yes | "Member" |
| registrationDate | Date | When registration occurred | Yes | TODAY() |
| paymentRequired | Boolean | Whether payment is required | No | false |
| paymentAmount | Currency | Amount to be paid if applicable | No | 0 |
| ticketQuantity | Number | Number of tickets requested | Yes | 1 |
| attendeeDetails | Object[] | List of guest information for multiple registrations | No | null |
| triggerSource | Text | Portal, Staff, API, Public | Yes | "Staff" |
| paymentMethod | Text | Credit Card, Invoice, Check, etc. | No | null |
| paymentDetails | Object | Payment processing information | No | null |

*Either memberId OR contactId must be provided

### 2. Determine Registration Type

**Logic**:
- If `registrationType` = "Member", validate membership record exists and is active
- If `registrationType` = "Non-member", ensure contact record exists or create one
- If `registrationType` = "Guest", validate primary member and collect guest details

**Decision Branches**:
- Member Registration → Validate Membership
- Non-Member Registration → Create/Update Contact
- Guest Registration → Validate Primary Member

### 3. Validate Membership

**Operations**:
- Query Membership record using memberId
- Check if membership is Active
- Verify membership level is eligible for the event
- Check if membership has any payment holds
- Apply member-specific pricing and benefits

**Formulas**:
```
isEligibleLevel = 
OR(
  Event__c.Required_Level__c = null,
  Membership__c.Membership_Level__c = Event__c.Required_Level__c,
  Membership_Level__c.Display_Order__c <= Event__c.Required_Level__r.Display_Order__c
)
```

### 4. Create/Update Contact (Non-Member Path)

**Operations**:
- If contactId is provided, query and use existing Contact
- If no contactId, create new Contact record with registration information
- Add Contact to Event Prospect campaign if applicable
- Apply non-member pricing rules

### 5. Check Event Capacity

**Operations**:
- Query Event record to get current registration count and maximum capacity
- Calculate available slots: `maxCapacity - currentRegistrations`
- If available slots >= ticketQuantity, proceed to registration
- If available slots < ticketQuantity, process waitlist if enabled

**Decision Formula**:
```
hasCapacity = 
Event__c.Current_Registrations__c + ticketQuantity <= Event__c.Max_Participants__c
```

### 6. Process Waitlist

**Operations**:
- Create Waitlist record with position number
- Send waitlist confirmation
- Set up notification process for capacity changes
- Skip payment processing until promoted from waitlist

### 7. Evaluate Payment Requirements

**Operations**:
- Check if event requires payment based on Event record settings
- Determine if member qualifies for discounts or free attendance
- Calculate final payment amount based on membership level and ticket quantity

**Payment Required Formula**:
```
isPaymentRequired = 
AND(
  Event__c.Is_Paid_Event__c = true,
  OR(
    registrationType != "Member",
    NOT(Membership_Level__r.Free_Event_Access__c)
  )
)
```

### 8. Calculate Payment Amount

**Operations**:
- Apply member discount if applicable
- Apply early registration discount if applicable
- Apply quantity discount for multiple tickets
- Calculate final amount due

**Formula**:
```
finalAmount =
ticketQuantity * 
(Event__c.Base_Price__c - 
  (IF(
    registrationType = "Member",
    Event__c.Base_Price__c * Membership_Level__r.Event_Discount_Percent__c / 100,
    0
  ))
)
```

### 9. Process Payment/Invoice

**Operations**:
- If paymentMethod = "Credit Card", process payment through payment gateway
- If paymentMethod = "Invoice", generate invoice and set status to pending
- If paymentMethod = "Check" or other offline methods, record payment intention
- Generate receipt for successful payments

### 10. Create Participation Record(s)

**Operations**:
- Create Member Event Participation record linking Member/Contact to Event
- Set appropriate status based on registration path and payment status
- For group registrations, create multiple records linked to primary registration
- Store registration metadata (source, timestamp, etc.)

### 11. Generate Communications

**Operations**:
- Send confirmation email with registration details
- Generate and attach calendar invitation (.ics file)
- Include payment receipt if payment was processed
- Customize content based on registration type and event details

### 12. Schedule Follow-Up Communications

**Operations**:
- Schedule reminder notifications (1 week, 1 day before event)
- Schedule post-event survey and feedback request
- Set up attendance confirmation communication

### 13. Update Event Capacity

**Operations**:
- Increment Event.Current_Registrations__c
- Update available capacity metrics
- If event is now at capacity, update Event status

## Engagement Scoring Calculations

The Event Participation Flow automatically calculates and updates member engagement scores based on registration and attendance activities.

### Registration Engagement Points

```
registrationPoints = 
CASE(Event__c.Event_Type__c,
  "Workshop", 3,
  "Conference", 5,
  "Networking", 4,
  "Webinar", 2,
  "Social", 2,
  "Meeting", 1,
  2) * 
IF(registrationType = "Member", 1, 0.5)
```

### Attendance Engagement Points

```
attendancePoints =
CASE(Event__c.Event_Type__c,
  "Workshop", 7,
  "Conference", 10,
  "Networking", 8,
  "Webinar", 5,
  "Social", 5,
  "Meeting", 3,
  5) *
IF(Member_Event_Participation__c.Feedback_Score__c > 0, 1.2, 1) *
IF(registrationType = "Member", 1, 0.5)
```

### Total Engagement Score Update

When a member registers for an event:
```
Contact.Engagement_Score__c = Contact.Engagement_Score__c + registrationPoints
```

When attendance is recorded:
```
Contact.Engagement_Score__c = Contact.Engagement_Score__c + attendancePoints - registrationPoints
```

## Implementation Considerations

### Event Configuration Requirements
- Event types and categorization
- Capacity management settings
- Registration window configuration
- Payment requirement settings
- Waitlist functionality
- Member discount configuration by membership level

### Member vs. Non-Member Handling
- Different pricing structures
- Member-only events visibility
- Member benefits (early registration, discounts)
- Converting non-member participants to prospects
- Special handling for organizational memberships with multiple contacts

### Edge Cases
- Handling cancellations and refunds
  - Full refunds: Event cancelled by organizer
  - Partial refunds: Cancellation within policy window
  - No refunds: Late cancellations
- Managing waitlist promotions
  - Automatic promotion when capacity becomes available
  - Time-limited offer to accept promoted status
  - Payment processing after promotion
- Processing group registrations
  - Primary registrant responsible for payment
  - Individual tracking of each attendee
  - Mixed member/non-member groups
- Handling recurring events
  - Series registration vs. individual event registration
  - Consistent attendance tracking across series
- Managing multi-session events
  - Session selection during registration
  - Tracking attendance at individual sessions
  - Calculating engagement based on session participation

## Testing Scenarios

| Scenario | Input | Expected Outcome |
|----------|-------|------------------|
| Standard member registration | Active member, available event | Registration confirmed, engagement score updated |
| Non-member registration | Contact info, available event | Registration confirmed, prospect tag added |
| Registration for full event | Member, event at capacity | Added to waitlist, notification sent |
| Paid event registration | Member, event with fee | Payment processed, receipt generated |
| Cancellation processing | Existing registration | Registration cancelled, refund processed if applicable |
| Group registration | Member, multiple attendees | All attendees registered, single payment processed |
| Waitlist promotion | Member on waitlist, spot becomes available | Registration updated, notification sent |
| Event check-in | Member arrives at event | Attendance recorded, engagement score updated |
| Member-only event | Non-member attempted registration | Error message, suggestion to join as member |
| Failed payment | Invalid payment details | Error message, registration held pending payment |
| Post-event engagement | Attended event, submitted feedback | Engagement score increased based on participation |
| Multi-session registration | Member registering for multiple sessions | Individual session registrations created |

## Related Configurations

### Custom Metadata Types
- **EventTypeSettings__mdt**: Configuration for different event types, including default engagement points, required fields, and registration settings
- **RegistrationTemplates__mdt**: Email and communication templates for different registration scenarios
- **EngagementScoreRules__mdt**: Rules for calculating engagement points for various activities

### Process Builders / Flows
- **NMT_Post_Event_Engagement_Update**: Updates engagement scores after event completion
- **NMT_Waitlist_Management_Process**: Handles waitlist promotions and notifications
- **NMT_Event_Feedback_Collection**: Gathers and processes post-event feedback

### Permission Sets
- **EventManager**: Full access to manage events and registrations
- **RegistrationStaff**: Ability to process registrations and check in attendees
- **CheckInStaff**: Limited access for event check-in operations only

## API Integration Points

### Registration API
- **Endpoint**: `/services/apexrest/EventRegistration`
- **Methods**: `POST` (create registration), `PUT` (update registration), `DELETE` (cancel registration)
- **Authentication**: OAuth 2.0
- **Request Parameters**: Align with flow input variables

### Check-In API
- **Endpoint**: `/services/apexrest/EventCheckIn`
- **Methods**: `POST` (record attendance)
- **Parameters**: participationId, checkInTime, checkInMethod, checkInStaffId

### Waitlist Management API
- **Endpoint**: `/services/apexrest/WaitlistManagement`
- **Methods**: `GET` (waitlist status), `PUT` (promote from waitlist)
- **Parameters**: participationId, eventId, action

## Future Enhancements

1. **Advanced Registration Features**
   - Session selection for multi-track events
   - Personalized agendas
   - Accommodation and accessibility requests
   - Custom registration fields by event type

2. **Enhanced Payment Options**
   - Installment payments for expensive events
   - Group discounts
   - Early bird pricing automation
   - Membership upgrade offers during registration

3. **Integrated Marketing Features**
   - Targeted event recommendations based on past attendance
   - Social sharing integration
   - Referral tracking and incentives
   - Post-registration content delivery

4. **Mobile Experience**
   - Mobile check-in capabilities
   - Digital tickets/badges
   - Live event updates and notifications
   - Location-based services during events

5. **Analytics Enhancements**
   - Predictive attendance modeling
   - Member interest profiling based on event selection
   - Event ROI calculations
   - Engagement pattern detection for personalized outreach

## Related Documents

- [Data Model Design](../Docs/NMT-Data_Model_Design_Consolidated.md)
- [Membership Onboarding Flow Design](NMT-Membership_Onboarding_Flow_Design.md)
- [Membership Renewal Flow Design](NMT-Membership_Renewal_Flow_Design.md)
- [Payment Status Handling Flow Design](NMT-Payment_Status_Handling_Flow_Design.md)
- [Event Participation Flow Test Cases](../Tests/NMT-Event_Participation_Flow_Test_Cases.md)
- [Engagement Reports Specifications](../Reports/NMT-Engagement_Reports_Specs.md)
- [Dashboard Design](../Reports/NMT-Dashboard_Design.md) 