---
title: "Nonprofit Membership Tracking - Event Participation Flow Test Cases"
project: "Nonprofit Membership Tracking"
type: "Test"
phase: "Testing"
status: "Draft"
version: "1.0"
created: "2025-04-07"
updated: "2025-04-07"
author: "QA Team"
---

# Event Participation Flow Test Cases

## Overview

This document outlines the test cases for validating the Event Participation Flow. The flow manages the end-to-end process of registering members for events, tracking their participation, and updating engagement metrics based on attendance. These test cases cover different scenarios for event registration, payment processing, waitlist management, cancellations, and attendance tracking.

## Test Environment

- **Sandbox**: NMTRACKERDEV
- **Salesforce Version**: Spring '25
- **Last Flow Version Deployed**: v1.0
- **Test Users**:
  - Standard User: events_staff@nonprofittracker.dev
  - Member Portal User: test_member@example.com
  - Admin User: admin@nonprofittracker.dev

## Test Case Definitions

### TC-EPF-001: Standard Member Registration - Free Event

**Description**: Validate the flow correctly processes a registration for an active member to a free event

**Prerequisites**:
- Active membership record
- Free event with available capacity
- Event configuration with no restriction on membership level

**Test Data**:
```json
{
  "eventId": "EVT-0001",
  "memberId": "MEM-0001",
  "contactId": "CON-0001",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": false,
  "ticketQuantity": 1,
  "triggerSource": "Portal"
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to Event Calendar
3. Select the specified event
4. Click "Register"
5. Confirm registration details
6. Submit registration

**Expected Results**:
1. Member Event Participation record is created with correct details
2. Registration status is set to "Confirmed"
3. Confirmation email is sent to member
4. Calendar invitation is generated and attached to email
5. Member's engagement score is updated
6. Event capacity count is decremented by 1

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-002: Non-Member Registration

**Description**: Validate the flow correctly processes a registration for a non-member contact

**Prerequisites**:
- Existing contact record without active membership
- Public event with available capacity
- Event configuration allowing non-member registration

**Test Data**:
```json
{
  "eventId": "EVT-0002",
  "contactId": "CON-0002",
  "registrationType": "Non-member",
  "registrationDate": "2025-04-15",
  "paymentRequired": false,
  "ticketQuantity": 1,
  "triggerSource": "Public Form"
}
```

**Test Steps**:
1. Access public event registration form
2. Enter contact details
3. Complete registration form
4. Submit registration

**Expected Results**:
1. Member Event Participation record is created with correct details
2. Registration status is set to "Confirmed"
3. Confirmation email is sent to contact
4. Contact is tagged as "Event Prospect"
5. Event capacity count is decremented by 1
6. Lead conversion workflow is triggered

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-003: Registration for Full Event - Waitlist

**Description**: Validate the flow correctly processes a waitlist registration when event is at capacity

**Prerequisites**:
- Active membership record
- Event with capacity set to 0 available slots
- Event configuration with waitlist enabled

**Test Data**:
```json
{
  "eventId": "EVT-0003",
  "memberId": "MEM-0001",
  "contactId": "CON-0001",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": false,
  "ticketQuantity": 1,
  "triggerSource": "Portal"
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to Event Calendar
3. Select the specified event showing "At Capacity"
4. Click "Join Waitlist"
5. Confirm waitlist registration

**Expected Results**:
1. Member Event Participation record is created with status "Waitlisted"
2. Waitlist position is assigned based on timestamp
3. Waitlist confirmation email is sent to member
4. No payment is processed
5. Waitlist count for event is incremented by 1

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-004: Paid Event Registration with Member Discount

**Description**: Validate the flow correctly processes a paid event registration with appropriate member discount

**Prerequisites**:
- Active membership record with discount-eligible level
- Paid event with available capacity
- Event configuration with member discount settings

**Test Data**:
```json
{
  "eventId": "EVT-0004",
  "memberId": "MEM-0003",
  "contactId": "CON-0003",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": true,
  "paymentAmount": 50.00,
  "ticketQuantity": 1,
  "triggerSource": "Portal",
  "paymentMethod": "Credit Card",
  "paymentDetails": {
    "cardNumber": "4111111111111111",
    "expMonth": "12",
    "expYear": "2028",
    "cvv": "123"
  }
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to Event Calendar
3. Select the specified paid event
4. Click "Register"
5. Verify discounted price is displayed
6. Enter payment information
7. Submit registration

**Expected Results**:
1. Member Event Participation record is created with correct details
2. Payment is processed successfully with member discount applied
3. Payment Status is set to "Paid"
4. Receipt is generated and sent to member
5. Registration status is set to "Confirmed"
6. Confirmation email with payment receipt is sent
7. Event capacity count is decremented by 1

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-005: Registration Cancellation with Refund

**Description**: Validate the flow correctly processes a cancellation with refund for a paid event

**Prerequisites**:
- Existing confirmed registration for a paid event
- Event configuration allowing cancellations with refund period active
- Payment record associated with registration

**Test Data**:
```json
{
  "participationId": "EP-0001",
  "cancellationReason": "Schedule Conflict",
  "cancellationDate": "2025-04-20",
  "refundRequested": true,
  "triggerSource": "Portal"
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to "My Registrations"
3. Select the specific event registration
4. Click "Cancel Registration"
5. Select cancellation reason
6. Choose "Request Refund" option
7. Confirm cancellation

**Expected Results**:
1. Registration status is updated to "Cancelled"
2. Refund is processed through payment gateway
3. Payment Status is updated to "Refunded"
4. Cancellation confirmation email is sent
5. Refund receipt is generated and sent
6. Event capacity is incremented by 1
7. If waitlist exists, next person is notified of availability

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-006: Group Registration

**Description**: Validate the flow correctly processes a group registration with multiple attendees

**Prerequisites**:
- Active membership record
- Event with sufficient available capacity
- Event configuration allowing group registrations

**Test Data**:
```json
{
  "eventId": "EVT-0005",
  "memberId": "MEM-0004",
  "contactId": "CON-0004",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": true,
  "paymentAmount": 200.00,
  "ticketQuantity": 4,
  "attendeeDetails": [
    {
      "firstName": "Guest",
      "lastName": "One",
      "email": "guest1@example.com"
    },
    {
      "firstName": "Guest",
      "lastName": "Two",
      "email": "guest2@example.com"
    },
    {
      "firstName": "Guest",
      "lastName": "Three",
      "email": "guest3@example.com"
    }
  ],
  "triggerSource": "Staff",
  "paymentMethod": "Credit Card"
}
```

**Test Steps**:
1. Log in as events staff user
2. Navigate to Event Management
3. Select the specified event
4. Click "Register Group"
5. Select primary member
6. Enter additional attendee information
7. Process payment
8. Submit registration

**Expected Results**:
1. Primary Member Event Participation record is created
2. Additional Guest Participation records are created for each attendee
3. All records are linked to the same registration group
4. Single payment is processed for the total amount
5. Confirmation emails are sent to all attendees
6. Event capacity count is decremented by 4
7. Primary member's engagement score is updated

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-007: Waitlist Promotion

**Description**: Validate the flow correctly promotes a waitlisted registration when a spot becomes available

**Prerequisites**:
- Existing waitlisted registration
- Event with recently opened capacity (due to cancellation)
- Waitlist management process enabled

**Test Data**:
```json
{
  "participationId": "EP-0002",
  "waitlistPosition": 1,
  "eventId": "EVT-0003",
  "newAvailableSlots": 1
}
```

**Test Steps**:
1. Simulate a cancellation of an existing registration
2. Verify waitlist promotion trigger executes
3. Monitor notification to waitlisted member

**Expected Results**:
1. Waitlist promotion process identifies next eligible registration
2. Registration status is updated from "Waitlisted" to "Pending Confirmation"
3. Notification is sent to waitlisted member with time-limited confirmation link
4. If confirmed, status changes to "Confirmed" and capacity is adjusted
5. If not confirmed within timeframe, next waitlisted member is promoted

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-008: Event Check-in

**Description**: Validate the flow correctly processes an attendee check-in at the event

**Prerequisites**:
- Existing confirmed registration
- Event date set to current date
- Check-in process enabled

**Test Data**:
```json
{
  "participationId": "EP-0003",
  "checkInTime": "2025-05-15T09:15:00",
  "checkInMethod": "Staff",
  "checkInStaffId": "USR-0001"
}
```

**Test Steps**:
1. Log in as events staff user
2. Navigate to Event Check-in interface
3. Select current event
4. Search for registered member
5. Click "Check In"
6. Confirm check-in

**Expected Results**:
1. Participation record is updated with attendance status "Attended"
2. Check-in time is recorded
3. Engagement score for member is updated
4. Staff who processed check-in is recorded
5. Post-event communications are queued for delivery after event
6. Real-time attendance dashboard is updated

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-009: Member-Only Event Registration Attempt by Non-Member

**Description**: Validate the flow correctly restricts registration for member-only events

**Prerequisites**:
- Existing contact without active membership
- Event configured as "Member Only"

**Test Data**:
```json
{
  "eventId": "EVT-0006",
  "contactId": "CON-0005",
  "registrationType": "Non-member",
  "registrationDate": "2025-04-15",
  "triggerSource": "Public Form"
}
```

**Test Steps**:
1. Access public event registration form
2. Attempt to register for member-only event

**Expected Results**:
1. System validates membership requirement
2. Registration attempt is rejected with appropriate message
3. Alternative suggestion is displayed (join as member)
4. Contact is tagged for membership follow-up
5. No participation record is created
6. Event capacity remains unchanged

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-010: Event Registration with Payment Failure

**Description**: Validate the flow correctly handles failed payments for paid events

**Prerequisites**:
- Active membership record
- Paid event with available capacity
- Payment processor configured to simulate failures

**Test Data**:
```json
{
  "eventId": "EVT-0007",
  "memberId": "MEM-0005",
  "contactId": "CON-0006",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": true,
  "paymentAmount": 75.00,
  "ticketQuantity": 1,
  "triggerSource": "Portal",
  "paymentMethod": "Credit Card",
  "paymentDetails": {
    "cardNumber": "4111111111111112", // Invalid card to force failure
    "expMonth": "12",
    "expYear": "2028",
    "cvv": "123"
  }
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to Event Calendar
3. Select the specified paid event
4. Click "Register"
5. Enter invalid payment information
6. Submit registration

**Expected Results**:
1. Payment process attempts to charge card
2. System receives payment failure response
3. User is shown payment error message with retry option
4. No participation record is created until payment succeeds
5. Temporary reservation of capacity is released after timeout
6. Failed payment attempt is logged for audit

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-011: Post-Event Engagement Tracking

**Description**: Validate the flow correctly updates engagement metrics after event completion

**Prerequisites**:
- Completed event with attendance records
- Engagement scoring rules configured
- Post-event process enabled

**Test Data**:
```json
{
  "eventId": "EVT-0008",
  "eventStatus": "Completed",
  "eventDate": "2025-05-01",
  "participationRecords": [
    {"id": "EP-0004", "status": "Attended"},
    {"id": "EP-0005", "status": "No-Show"},
    {"id": "EP-0006", "status": "Attended"}
  ]
}
```

**Test Steps**:
1. Log in as admin user
2. Update event status to "Completed"
3. Trigger post-event processing

**Expected Results**:
1. Post-event process executes for all participation records
2. Members with "Attended" status receive engagement score increase
3. Members with "No-Show" status receive engagement score decrease
4. Thank-you/feedback emails are sent to attendees
5. No-show follow-up communications are sent
6. Event analytics are updated in dashboards
7. Membership engagement records are updated

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

### TC-EPF-012: Multi-Session Event Registration

**Description**: Validate the flow correctly processes registration for a multi-session event

**Prerequisites**:
- Active membership record
- Multi-session event with available capacity
- Event configuration for session selection

**Test Data**:
```json
{
  "eventId": "EVT-0009",
  "memberId": "MEM-0006",
  "contactId": "CON-0007",
  "registrationType": "Member",
  "registrationDate": "2025-04-15",
  "paymentRequired": true,
  "paymentAmount": 150.00,
  "ticketQuantity": 1,
  "sessionSelections": [
    {"sessionId": "S-001", "selected": true},
    {"sessionId": "S-002", "selected": false},
    {"sessionId": "S-003", "selected": true},
    {"sessionId": "S-004", "selected": true}
  ],
  "triggerSource": "Portal",
  "paymentMethod": "Credit Card"
}
```

**Test Steps**:
1. Log in as member portal user
2. Navigate to Event Calendar
3. Select the multi-session event
4. Click "Register"
5. Select specific sessions to attend
6. Process payment
7. Submit registration

**Expected Results**:
1. Master Member Event Participation record is created
2. Child Session Participation records are created for selected sessions
3. Payment is processed for the total amount
4. Confirmation details show selected sessions
5. Calendar invites include session-specific details
6. Session capacity counts are decremented appropriately
7. Member can modify session selections until cutoff date

**Actual Results**: *To be filled during testing*

**Status**: NOT TESTED

## Edge Case Test Scenarios

| ID | Scenario | Key Test Points |
|----|----------|----------------|
| EC-001 | Registration near capacity limit | Test race condition handling when multiple users register simultaneously |
| EC-002 | Partial refund processing | Test handling of partial refunds for multi-session events |
| EC-003 | Membership expiration before event | Test logic for handling price adjustments if membership expires before event occurs |
| EC-004 | Event date/time modification | Test notification and option handling when event details change after registration |
| EC-005 | Duplicate registration attempts | Test system prevention of duplicate registrations by the same user |

## Related Test Cases

- Payment Status Handling Flow Test Cases (for payment processing verification)
- Membership Onboarding Flow Test Cases (for integration with membership status)
- Communication Template Test Cases (for event notification verification)

## Test Data Setup Requirements

Before executing these test cases, ensure the following test data is configured:

1. Multiple event records with various configurations:
   - Free and paid events
   - Member-only and public events
   - Events with and without capacity limits
   - Multi-session events

2. Test users with different membership levels and statuses

3. Mock payment processor configuration to test various payment scenarios

## Acceptance Criteria

The Event Participation Flow will be considered successfully validated when:

1. All test cases have passed with expected results
2. Edge cases have been successfully handled
3. Integration with membership and payment processes is verified
4. No high-severity defects remain open
5. Performance metrics meet requirements under expected load

## Related Documents

- [Event Participation Flow Design](NMT-Event_Participation_Flow_Design.md)
- [Payment Status Handling Flow Test Cases](NMT-Payment_Status_Handling_Flow_Test_Cases.md)
- [Membership Onboarding Flow Test Cases](NMT-Membership_Onboarding_Flow_Test_Cases.md)
- [Data Model Design](NMT-Data_Model_Design_Consolidated.md) 