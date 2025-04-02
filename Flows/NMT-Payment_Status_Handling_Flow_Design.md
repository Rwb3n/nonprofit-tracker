---
title: "Nonprofit Membership Tracking - Payment Status Handling Flow Design"
project: "Nonprofit Membership Tracking"
type: "Flow Design"
phase: "Design"
status: "Draft"
version: "0.1"
created: "2025-04-06"
updated: "2025-04-06"
author: "Flow Design Team"
---

# Nonprofit Membership Tracking - Payment Status Handling Flow Design

## Overview

The Payment Status Handling Flow automates the process of monitoring and updating membership status based on payment events. It ensures that membership records accurately reflect current payment status, handles payment failures, and triggers appropriate notifications to both members and staff. The flow is designed to integrate with payment processors, handle both manual and automated payment updates, and maintain a comprehensive payment history.

## Flow Diagram

```
[Flow diagram to be added in the next iteration]
```

## Flow Elements

### Input Variables

- **paymentId**: ID of the payment record that triggered the flow
- **membershipId**: ID of the membership record associated with the payment
- **paymentAmount**: The amount of the payment
- **paymentType**: Type of payment (Initial, Renewal, Partial, Installment)
- **paymentStatus**: Status of the payment (Success, Failed, Pending, Refunded)
- **paymentDate**: Date when payment was made or attempted
- **processorReference**: Reference ID from payment processor
- **triggerSource**: Source that triggered the flow (Processor Webhook, Manual Entry, Scheduled Job)

### Decision Logic

1. **Payment Type Determination**
   - Determine if this is an initial payment, renewal payment, or installment

2. **Status Evaluation Branch**
   - Different paths for successful payments, failed payments, and pending payments

3. **Notification Determination**
   - Decide which notifications to send based on payment status and type

### Operations

#### Successful Payment Branch
- Query membership record
- Update membership status to "Active"
- Update payment fields (Last Payment Date, Amount, Method)
- Calculate and update expiration date if renewal payment
- Create payment history record
- Send receipt notification

#### Failed Payment Branch
- Query membership record 
- Update attempt count
- Determine if maximum attempts reached
  - If maximum reached: Update membership status to "Payment Failed"
  - If not maximum: Keep current status
- Create payment history record with failure reason
- Send appropriate notification based on attempt count

#### Pending Payment Branch
- Query membership record
- Update membership status to "Payment Pending"
- Schedule follow-up check after configured wait period
- Create payment history record

## Implementation Considerations

### Payment Status Rules
- New memberships require successful payment to activate
- Renewal payments must be received within grace period to maintain continuity
- Failed payments should trigger retry attempt after 3 days
- Maximum of 3 payment attempts before requiring manual intervention

### Integration Requirements
- Integration with payment processor webhook API
- Secure handling of payment processor callbacks
- Proper error handling for API failures

### Edge Cases
- Handling partial payments
- Managing payment plan installments
- Processing refunds and membership cancellations
- Handling offline/manual payments
- Managing overdue payments and grace periods

## Testing Scenarios

| Scenario | Input | Expected Outcome |
|----------|-------|------------------|
| Successful initial payment | New membership, successful payment | Membership activated, receipt sent |
| Successful renewal payment | Existing membership, successful payment | Expiration date extended, receipt sent |
| Failed initial payment | New membership, failed payment | Membership remains in pending status, retry scheduled |
| Failed renewal within grace period | Existing active membership, failed payment | Membership remains active, retry scheduled |
| Failed renewal after grace period | Expired membership, failed payment | Membership status set to "Payment Failed" |
| Maximum retries reached | Three failed attempts | Staff notification, membership status updated |
| Partial payment received | Payment amount < required amount | Partial payment recorded, remaining balance calculated |
| Refund processed | Refund payment type | Membership status updated based on refund policy |

## Related Configurations

### Custom Metadata Types
- Payment Status Configuration
- Payment Retry Rules
- Notification Templates for Payment Events

### Process Builders / Flows
- Post-Payment Financial Record Updates
- Accounting System Integration Process

### Permission Sets
- Payment Processing Admin
- Finance Team Member

## Future Enhancements

1. **Advanced Retry Logic**
   - Implement progressive retry intervals
   - Support for different retry strategies based on failure reason

2. **Payment Plan Support**
   - Enhanced handling of installment payments
   - Automatic generation of installment schedule

3. **Discount and Promotion Handling**
   - Support for coupon codes and promotional rates
   - Time-limited discount application

4. **Advanced Reporting Integration**
   - Real-time payment status dashboards
   - Revenue forecasting based on payment patterns

5. **Multi-Currency Support**
   - Handle payments in different currencies
   - Automatic currency conversion

## Related Documents

- [Data Model Design](../Docs/NMT-Data_Model_Design_Consolidated.md)
- [Membership Onboarding Flow Design](NMT-Membership_Onboarding_Flow_Design.md)
- [Membership Renewal Flow Design](NMT-Membership_Renewal_Flow_Design.md)
- [Dashboard Design](../Reports/NMT-Dashboard_Design.md)

## Implementation Notes

This document is currently in draft form. The next steps for this design include:

1. Complete flow diagram with detailed branching logic
2. Refine payment status rules based on business requirements
3. Define exact field updates for each type of payment event
4. Develop comprehensive test cases for validation
5. Review integration requirements with the payment processor team

---

**Note**: This flow design should be implemented after the completion of the Membership Onboarding Flow and Membership Renewal Flow, as it depends on the membership data structures established by those flows. 