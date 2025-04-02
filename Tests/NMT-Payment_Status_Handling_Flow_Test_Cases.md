---
title: "Nonprofit Membership Tracking - Payment Status Handling Flow Test Cases"
project: "Nonprofit Membership Tracking"
type: "Test"
phase: "Testing"
status: "Draft"
version: "1.0"
created: "2025-04-07"
updated: "2025-04-07"
author: "QA Team"
---

# Payment Status Handling Flow Test Cases

## Overview

This document outlines the test cases for validating the Payment Status Handling Flow. The flow is responsible for monitoring and updating membership status based on payment events, handling payment failures, and triggering appropriate notifications. Each test case includes:

- A unique identifier
- Description
- Test data
- Prerequisites
- Test steps
- Expected results
- Actual results
- Status

## Test Environment

- **Sandbox**: NMTRACKERDEV
- **Salesforce Version**: Spring '25
- **Last Flow Version Deployed**: v1.0
- **Test Users**:
  - Standard User: tester@nonprofittracker.dev
  - Finance User: finance@nonprofittracker.dev
  - Admin User: admin@nonprofittracker.dev

## Test Case Definitions

### TC-PSH-001: Successful Initial Payment Processing

**Description**: Validate the flow correctly processes a successful initial payment and activates a new membership

**Prerequisites**:
- New membership record in "Pending" status
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000001",
  "paymentData": {
    "paymentId": "p0001",
    "paymentAmount": 100.00,
    "paymentType": "Initial",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref123456",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation

**Expected Results**:
1. Membership status updated to "Active"
2. Payment status updated to "Paid"
3. Payment fields updated (Last Payment Date, Amount, Method)
4. Payment history record created with successful status
5. Receipt notification sent to member
6. No error messages in logs

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-002: Successful Renewal Payment Processing

**Description**: Validate the flow correctly processes a successful renewal payment and extends membership

**Prerequisites**:
- Existing membership record in "Active" status with end date approaching
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000002",
  "paymentData": {
    "paymentId": "p0002",
    "paymentAmount": 150.00,
    "paymentType": "Renewal",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref789012",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Note current membership end date
2. Trigger Payment Status Handling Flow with test data
3. Verify membership record updates
4. Check email notifications
5. Verify payment history record creation

**Expected Results**:
1. Membership status remains "Active"
2. End date extended by membership duration (typically 1 year)
3. Last Renewal Date updated to payment date
4. Payment status updated to "Paid"
5. Payment history record created
6. Renewal receipt notification sent to member

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-003: Failed Initial Payment Processing

**Description**: Validate the flow correctly handles a failed initial payment

**Prerequisites**:
- New membership record in "Pending" status
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000003",
  "paymentData": {
    "paymentId": "p0003",
    "paymentAmount": 75.00,
    "paymentType": "Initial",
    "paymentStatus": "Failed",
    "paymentDate": "2025-04-07",
    "processorReference": "ref345678",
    "failureReason": "Insufficient Funds",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment retry scheduling
5. Verify payment history record creation

**Expected Results**:
1. Membership status remains "Pending"
2. Payment status updated to "Failed"
3. Payment attempt count incremented to 1
4. Payment history record created with failure reason
5. Failure notification sent to member with retry information
6. Retry attempt scheduled for 3 days later

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-004: Failed Renewal Within Grace Period

**Description**: Validate the flow correctly handles a failed renewal payment when within the membership grace period

**Prerequisites**:
- Existing membership record in "Active" status
- End date not yet reached
- Grace period configured (e.g., 30 days)
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000004",
  "paymentData": {
    "paymentId": "p0004",
    "paymentAmount": 125.00,
    "paymentType": "Renewal",
    "paymentStatus": "Failed",
    "paymentDate": "2025-04-07",
    "processorReference": "ref567890",
    "failureReason": "Expired Card",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment retry scheduling
5. Verify payment history record creation

**Expected Results**:
1. Membership status remains "Active"
2. Payment status updated to "Failed"
3. Payment attempt count incremented
4. Payment history record created with failure reason
5. Failure notification sent to member with warning about upcoming expiration
6. Retry attempt scheduled

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-005: Failed Renewal After Grace Period

**Description**: Validate the flow correctly handles a failed renewal payment when outside the membership grace period

**Prerequisites**:
- Existing membership record in "Expired" status
- End date passed beyond grace period
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000005",
  "paymentData": {
    "paymentId": "p0005",
    "paymentAmount": 125.00,
    "paymentType": "Renewal",
    "paymentStatus": "Failed",
    "paymentDate": "2025-04-07",
    "processorReference": "ref901234",
    "failureReason": "Declined",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation

**Expected Results**:
1. Membership status updated to "Payment Failed"
2. Payment status remains "Failed"
3. Payment attempt count incremented
4. Payment history record created with failure reason
5. Failure notification sent to member with reinstatement instructions
6. Staff notification sent about expired membership with payment failure

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-006: Maximum Retries Reached

**Description**: Validate the flow correctly handles a payment that has reached the maximum retry attempts

**Prerequisites**:
- Existing membership record with payment attempt count at 2 (one away from max)
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000006",
  "paymentData": {
    "paymentId": "p0006",
    "paymentAmount": 150.00,
    "paymentType": "Renewal",
    "paymentStatus": "Failed",
    "paymentDate": "2025-04-07",
    "processorReference": "ref123789",
    "failureReason": "Insufficient Funds",
    "attemptCount": 2,
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation
5. Check staff notifications

**Expected Results**:
1. Membership status updated to "Payment Failed"
2. Payment status remains "Failed"
3. Payment attempt count incremented to 3 (max)
4. No further automatic retries scheduled
5. Payment history record created
6. Final failure notification sent to member with manual payment instructions
7. High-priority staff notification sent for manual follow-up

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-007: Partial Payment Processing

**Description**: Validate the flow correctly handles a partial payment

**Prerequisites**:
- Existing membership record in "Pending" status with dues amount of $200
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000007",
  "paymentData": {
    "paymentId": "p0007",
    "paymentAmount": 100.00,
    "paymentType": "Partial",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref456123",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation
5. Verify balance calculation

**Expected Results**:
1. Membership status updated to "Partial"
2. Payment status updated to "Partial"
3. Remaining balance calculated ($100)
4. Payment history record created
5. Partial payment receipt sent to member with remaining balance information
6. Next payment reminder scheduled

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-008: Refund Processing

**Description**: Validate the flow correctly processes a refund

**Prerequisites**:
- Existing membership record in "Active" status
- Previous successful payment record
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000008",
  "paymentData": {
    "paymentId": "p0008",
    "paymentAmount": 150.00,
    "paymentType": "Refund",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref789456",
    "originalPaymentReference": "ref987654",
    "refundReason": "Member Request",
    "triggerSource": "Manual Entry"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation

**Expected Results**:
1. Membership status updated based on refund policy (e.g., to "Cancelled" if full refund)
2. Payment status updated to "Refunded"
3. Payment history record created with refund information
4. Refund confirmation sent to member
5. Staff notification sent about the refund

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-009: Manual Payment Entry

**Description**: Validate the flow correctly processes a manually entered payment

**Prerequisites**:
- Existing membership record in "Pending" status
- Finance user permissions

**Test Data**:
```json
{
  "membershipId": "a0M000000000009",
  "paymentData": {
    "paymentId": "p0009",
    "paymentAmount": 75.00,
    "paymentType": "Initial",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "paymentMethod": "Check",
    "checkNumber": "1234",
    "triggerSource": "Manual Entry"
  }
}
```

**Test Steps**:
1. Login as finance user
2. Navigate to membership record
3. Enter manual payment information
4. Submit payment
5. Verify membership record updates
6. Check email notifications
7. Verify payment history record creation

**Expected Results**:
1. Membership status updated to "Active"
2. Payment status updated to "Paid"
3. Payment fields updated (Last Payment Date, Amount, Method = "Check")
4. Payment history record created
5. Receipt notification sent to member
6. Staff notification sent about manual payment entry

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-010: Pending Payment Processing

**Description**: Validate the flow correctly handles a payment in pending status

**Prerequisites**:
- Existing membership record in "Pending" status
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000010",
  "paymentData": {
    "paymentId": "p0010",
    "paymentAmount": 125.00,
    "paymentType": "Initial",
    "paymentStatus": "Pending",
    "paymentDate": "2025-04-07",
    "processorReference": "ref135790",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation
5. Verify follow-up scheduling

**Expected Results**:
1. Membership status updated to "Payment Pending"
2. Payment status remains "Pending"
3. Payment history record created
4. Notification sent to member about pending payment status
5. Follow-up check scheduled after configured wait period

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

## Edge Case Test Scenarios

### TC-PSH-011: Installment Plan Payment

**Description**: Validate the flow correctly processes an installment payment as part of a payment plan

**Prerequisites**:
- Existing membership with payment plan configured
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000011",
  "paymentData": {
    "paymentId": "p0011",
    "paymentAmount": 25.00,
    "paymentType": "Installment",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref246801",
    "installmentNumber": 2,
    "totalInstallments": 4,
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Trigger Payment Status Handling Flow with test data
2. Verify membership record updates
3. Check email notifications
4. Verify payment history record creation
5. Verify installment tracking

**Expected Results**:
1. Membership status remains "Active"
2. Payment status remains "Installment Plan"
3. Installment tracking updated (2 of 4 complete)
4. Payment history record created
5. Installment receipt sent to member
6. Next installment reminder scheduled

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

### TC-PSH-012: Duplicate Payment Handling

**Description**: Validate the flow correctly handles duplicate payment notifications

**Prerequisites**:
- Existing membership with recent successful payment
- Payment processor mock enabled

**Test Data**:
```json
{
  "membershipId": "a0M000000000012",
  "paymentData": {
    "paymentId": "p0012",
    "paymentAmount": 150.00,
    "paymentType": "Renewal",
    "paymentStatus": "Success",
    "paymentDate": "2025-04-07",
    "processorReference": "ref357902",
    "triggerSource": "Processor Webhook"
  }
}
```

**Test Steps**:
1. Process initial payment successfully
2. Submit identical payment data again within 24 hours
3. Verify duplicate detection
4. Check logs and notifications

**Expected Results**:
1. System identifies duplicate payment by processor reference
2. No duplicate updates made to membership record
3. No duplicate payment history record created
4. Error logged for duplicate payment attempt
5. Staff notification sent about potential duplicate payment

**Actual Results**:
*To be completed after test execution*

**Status**: 🔄 NOT TESTED

## Related Test Cases

- [Membership Onboarding Flow Test Cases](NMT-Membership_Onboarding_Flow_Test_Cases.md): Tests related to initial membership creation
- [Membership Renewal Flow Test Cases](NMT-Membership_Renewal_Flow_Test_Cases.md): Tests related to membership renewal process

## Test Data Setup

Test data for these test cases should be set up in the sandbox environment before testing begins. This includes:

1. Membership records in various states (pending, active, expired)
2. Membership levels with different fee structures
3. Mock payment processor responses for each test scenario
4. User accounts with appropriate permissions

## Acceptance Criteria

The Payment Status Handling Flow will be considered successfully validated when:

1. All test cases have been executed
2. 100% of test cases have passed
3. All edge cases have been properly handled
4. No critical or high-priority defects remain open

## Related Documentation

- [Payment Status Handling Flow Design](../Flows/NMT-Payment_Status_Handling_Flow_Design.md)
- [Data Model Design](../Docs/NMT-Data_Model_Design_Consolidated.md)
- [Membership Onboarding Flow Design](../Flows/NMT-Membership_Onboarding_Flow_Design.md)
- [Membership Renewal Flow Design](../Flows/NMT-Membership_Renewal_Flow_Design.md) 