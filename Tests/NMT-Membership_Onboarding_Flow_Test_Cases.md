/* 
 * DEPRECATED: This file will be renamed to NMT-Membership_Onboarding_Flow_Test_Cases.md after review.
 * This change is part of the documentation consistency initiative to make file names more specific.
 * Please refer to Tests/NMT-Membership_Onboarding_Flow_Test_Cases.md for the most up-to-date test case documentation.
 */

---
title: "Nonprofit Membership Tracking - Flow Test Cases"
project: "Nonprofit Membership Tracking"
type: "Test"
phase: "Testing"
status: "In Progress"
version: "1.0"
created: "2025-03-30"
updated: "2025-03-31"
author: "QA Team"
---

# Membership Onboarding Flow Test Cases

## Overview

This document outlines the test cases for validating the Membership Onboarding Flow. Each test case includes:

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
- **Last Flow Version Deployed**: v2.3
- **Test Users**:
  - Standard User: tester@nonprofittracker.dev
  - Admin User: admin@nonprofittracker.dev

## Test Case Definitions

### TC-001: Individual Member Registration - Basic Path

**Description**: Validate the complete flow for registering a new individual member with credit card payment

**Prerequisites**:
- At least one active Membership Level configured
- Payment processor mock enabled

**Test Data**:
```json
{
  "contactData": {
    "firstName": "Jane",
    "lastName": "Doe",
    "email": "jane.doe@example.com",
    "phone": "555-123-4567"
  },
  "membershipData": {
    "membershipLevel": "Bronze",
    "startDate": "2025-04-01",
    "joinMethod": "Online"
  },
  "paymentData": {
    "method": "Credit Card",
    "cardNumber": "4111111111111111",
    "expMonth": "12",
    "expYear": "2029",
    "cvv": "123"
  }
}
```

**Test Steps**:
1. Launch flow from "New Membership" action
2. Select "Individual Membership" option
3. Enter contact information from test data
4. Select membership level and start date from test data
5. Choose payment method and enter payment details
6. Complete flow

**Expected Results**:
1. New Contact record is created with provided information
2. New Membership record is created with:
   - Status = "Active"
   - Payment Status = "Paid"
   - End Date calculated correctly (1 year from start date for annual membership)
3. Welcome email is sent to the member's email address
4. Internal notification is sent to membership team

**Actual Results**:
Contact and membership created successfully. Welcome email received. Payment status correctly set to "Paid".

**Status**: ✅ PASSED

### TC-002: Organizational Member Registration

**Description**: Validate the organizational membership registration path

**Prerequisites**:
- At least one Membership Level with "Available To" = "Organizations" or "Both"

**Test Data**:
```json
{
  "accountData": {
    "name": "Acme Nonprofit",
    "website": "www.acmenonprofit.org",
    "phone": "555-987-6543"
  },
  "contactData": {
    "firstName": "John",
    "lastName": "Smith",
    "email": "john.smith@acmenonprofit.org",
    "role": "Executive Director"
  },
  "membershipData": {
    "membershipLevel": "Silver",
    "startDate": "2025-04-01",
    "joinMethod": "Phone"
  }
}
```

**Test Steps**:
1. Launch flow from "New Membership" action
2. Select "Organizational Membership" option
3. Enter organization and primary contact information
4. Select membership level and start date
5. Choose "Invoice" as payment method
6. Complete flow

**Expected Results**:
1. New Account record is created with organization information
2. New Contact record is created and linked to the Account
3. New Membership record is created with:
   - Status = "Pending" (due to invoice payment)
   - Payment Status = "Pending"
   - Linked to the Account (not to the Contact)
4. Welcome email is sent
5. Invoice generation process is triggered

**Actual Results**:
Account, contact and membership created successfully. Status correctly set to "Pending". Invoice generated and email sent.

**Status**: ✅ PASSED

### TC-003: Registration from Existing Contact

**Description**: Test membership creation for an existing contact

**Prerequisites**:
- Existing contact record in system

**Test Data**:
```json
{
  "existingContactId": "003000000000001",
  "membershipData": {
    "membershipLevel": "Gold",
    "startDate": "2025-04-01",
    "joinMethod": "In-Person"
  }
}
```

**Test Steps**:
1. Navigate to existing contact record
2. Launch flow from "Add Membership" quick action
3. Verify contact information is pre-populated
4. Select membership level and start date
5. Complete flow

**Expected Results**:
1. No new Contact record is created
2. Existing contact record is associated with new membership
3. New Membership record is created with correct details
4. Welcome email is sent to contact's email address

**Actual Results**:
Membership successfully associated with existing contact. No duplicate contacts created.

**Status**: ✅ PASSED

### TC-004: Duplicate Contact Detection

**Description**: Verify the duplicate detection and handling functionality

**Prerequisites**:
- Existing contact with email "duplicate@example.com"

**Test Data**:
```json
{
  "contactData": {
    "firstName": "Duplicate",
    "lastName": "User",
    "email": "duplicate@example.com",
    "phone": "555-555-5555"
  }
}
```

**Test Steps**:
1. Launch flow from "New Membership" action
2. Select "Individual Membership"
3. Enter contact information with matching email
4. Observe system behavior

**Expected Results**:
1. System identifies potential duplicate
2. User is prompted with duplicate warning
3. User is given options to:
   - Create new contact anyway
   - Use existing contact
   - Cancel operation

**Actual Results**:
Duplicate correctly identified. Options presented as expected. Selecting "Use existing contact" properly associated membership with existing record.

**Status**: ✅ PASSED

### TC-005: Membership Renewal

**Description**: Test the membership renewal process for an existing member

**Prerequisites**:
- Contact with existing membership that has End Date within 30 days

**Test Data**:
```json
{
  "existingContactId": "003000000000002",
  "existingMembershipId": "a0A000000000001",
  "renewalData": {
    "membershipLevel": "Same as current",
    "paymentMethod": "Credit Card"
  }
}
```

**Test Steps**:
1. Navigate to existing membership record
2. Launch "Renew Membership" action
3. Verify pre-populated data is correct
4. Process payment
5. Complete renewal

**Expected Results**:
1. Existing membership End Date is updated to one year from current End Date
2. Membership History record is created documenting renewal
3. Renewal confirmation email is sent
4. Payment record is created

**Actual Results**:
End date correctly extended. History record created. Confirmation email sent successfully.

**Status**: ✅ PASSED

### TC-006: Applying Discount Code

**Description**: Verify that discount codes are properly applied to membership dues

**Prerequisites**:
- Valid discount code "SPRING25" configured for 25% off

**Test Data**:
```json
{
  "contactData": {
    "firstName": "Discount",
    "lastName": "Tester",
    "email": "discount@example.com"
  },
  "membershipData": {
    "membershipLevel": "Bronze",
    "discountCode": "SPRING25"
  }
}
```

**Test Steps**:
1. Launch flow from "New Membership" action
2. Enter contact information
3. Select membership level
4. Apply discount code
5. Verify discounted amount is displayed
6. Complete registration

**Expected Results**:
1. System validates discount code
2. Displays original price, discount amount, and final price
3. Final membership record shows discounted amount

**Actual Results**:
Discount properly applied. 25% reduction correctly calculated and displayed. Final membership record shows discounted amount.

**Status**: ✅ PASSED

### TC-007: Failed Payment Handling

**Description**: Verify the system's handling of failed payments

**Prerequisites**:
- Payment processor mock set to fail with specific test card

**Test Data**:
```json
{
  "contactData": {
    "firstName": "Failed",
    "lastName": "Payment",
    "email": "failed@example.com"
  },
  "membershipData": {
    "membershipLevel": "Silver"
  },
  "paymentData": {
    "method": "Credit Card",
    "cardNumber": "4111111111111111",
    "expMonth": "12",
    "expYear": "2020",  // Expired card
    "cvv": "123"
  }
}
```

**Test Steps**:
1. Launch flow from "New Membership" action
2. Enter contact information
3. Select membership level
4. Enter invalid payment information
5. Submit payment
6. Observe system behavior

**Expected Results**:
1. System shows payment error message
2. User is offered options to retry payment or choose different method
3. No active membership is created until payment is successful
4. If user abandons process, partial record is saved for follow-up

**Actual Results**:
Error correctly displayed with specific reason. Retry option worked properly. Pending membership created with "Payment Failed" status for follow-up.

**Status**: ✅ PASSED

## Test Results Summary

| Test Case ID | Description | Status | Last Run Date | Tester |
|--------------|-------------|--------|---------------|--------|
| TC-001 | Individual Registration | PASSED | 2025-03-30 | JDoe |
| TC-002 | Organizational Registration | PASSED | 2025-03-30 | JDoe |
| TC-003 | Existing Contact | PASSED | 2025-03-30 | JDoe |
| TC-004 | Duplicate Detection | PASSED | 2025-03-31 | JDoe |
| TC-005 | Membership Renewal | PASSED | 2025-03-31 | JDoe |
| TC-006 | Discount Code | PASSED | 2025-03-31 | JDoe |
| TC-007 | Failed Payment | PASSED | 2025-03-31 | JDoe |

## Issues Identified

| Issue ID | Description | Severity | Status | Associated Test Case |
|----------|-------------|----------|--------|----------------------|
| NMT-BUG-101 | Discount calculation incorrect for multi-year memberships | Medium | Fixed | TC-006 |
| NMT-BUG-102 | Error message unclear when payment processor unavailable | Low | Open | TC-007 |

## Regression Test Plan

For each future release, the following test cases should be executed as part of regression testing:

- TC-001: Basic individual registration path
- TC-003: Registration from existing contact
- TC-005: Membership renewal
- TC-007: Failed payment handling

Additional test cases should be added if new functionality is introduced. 