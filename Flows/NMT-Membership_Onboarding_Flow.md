---
Title: Nonprofit Membership Tracking - Membership Onboarding Flow
Project: Nonprofit Membership Tracking
Phase: Build
Status: Completed
Last Updated: 2025-03-30
---

# Membership Onboarding Flow Design

## Flow Overview

The Membership Onboarding Flow automates the process of registering new members, creating their membership records, and initiating the welcome sequence. This flow can be triggered from multiple entry points:

1. Screen Flow - Staff-assisted signup (call center or in-person)
2. Auto-launched from Web Form - Online self-registration
3. Quick Action - From Contact record when manually converting to member

## Flow Metadata

- **API Name**: NMT_Membership_Onboarding_Flow
- **Type**: Screen Flow & Auto-launched Flow (dual-purpose)
- **Description**: Handles new member registration process
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
RECORD EXISTS CHECK ──Yes──► DISPLAY DUPLICATE WARNING
  │                              │
  │ No                           │
  ▼                              │
SCREEN: MEMBER TYPE               │
  │                              │
  ▼                              │
DECISION: Individual or Org?      │
  │                              │
  ├─► Individual                 │
  │       │                      │
  │       ▼                      │
  │   SCREEN: CONTACT INFO       │
  │       │                      │
  │       ▼                      │
  │   CREATE/UPDATE CONTACT      │
  │       │                      │
  ▼       ▼                      │
SCREEN: MEMBERSHIP DETAILS        │
  │                              │
  ▼                              │
GET PRICING                       │
  │                              │
  ▼                              │
SCREEN: PAYMENT OPTIONS           │
  │                              │
  ▼                              │
PROCESS PAYMENT ◄────────────────┘
  │
  ▼
CREATE MEMBERSHIP
  │
  ▼
SEND NOTIFICATIONS
  │
  ▼
END
```

## Flow Elements in Detail

### 1. Input Variables

| Variable Name | Data Type | Description | Required |
|---------------|-----------|-------------|----------|
| ContactId | Id | Existing contact ID if launched from contact | No |
| AccountId | Id | Existing account ID if launched from account | No |
| Email | Email | Email address for duplicate checking | No |
| Source | Text | Registration source (Web, Phone, In-Person) | Yes |

### 2. Record Exists Check

**Logic**: 
- If Contact ID is provided, verify it exists
- If Email is provided, check for existing contacts with that email
- If Account ID is provided, verify it exists

**Assignment**:
- Set recordExists = (found matching records)
- Store existing record details if found

### 3. Screen: Member Type

**Elements**:
- Radio buttons for "Individual Membership" or "Organizational Membership"
- Help text explaining differences between membership types
- Next button to proceed

**Conditions**:
- Display only if contactId and accountId are null
- Skip if source = "Web" and individualOnly = true

### 4. Decision: Individual or Org

**Logic**:
- If memberType = "Individual" → Individual path
- If memberType = "Organizational" → Set requireOrgDetails = true
- If contactId is populated → Skip Contact Info screen

### 5. Screen: Contact Info

**Elements**:
- First Name (required)
- Last Name (required)
- Email (required)
- Phone
- Address components
- Custom questions (configurable)

**Validations**:
- Email format validation
- Required field checks

### 6. Create/Update Contact

**Operations**:
- If contactId exists: Update contact with new information
- If no contactId: Create new contact record
- Store ID in contactId variable

### 7. Screen: Membership Details

**Elements**:
- Membership Level (picklist, required)
- Start Date (defaults to today)
- Special Notes or Requests
- Checkbox for Terms and Conditions

**Dynamic Content**:
- Membership levels filtered by Individual/Organizational availability
- Displays benefits based on selected level

### 8. Get Pricing

**Operations**:
- Query Membership Level record for selected level
- Get Annual Fee and any applicable discounts
- Calculate prorated amount if applicable
- Store amounts in variables

### 9. Screen: Payment Options

**Elements**:
- Payment method selection (Credit Card, Invoice, Waived)
- Display calculated dues amount
- Credit card form (if selected)

**Conditions**:
- Skip if duesAmount = 0

### 10. Process Payment

**Logic**:
- If paymentMethod = "Credit Card": Process payment
- If paymentMethod = "Invoice": Set paymentStatus = "Pending"
- If paymentMethod = "Waived": Set paymentStatus = "Paid", duesAmount = 0

**Error Handling**:
- Catch payment failures and provide retry option
- Log payment attempts

### 11. Create Membership

**Record Creation**:
- New Membership__c record with collected data
- Link to Contact or Account
- Set Status = "Active" or "Pending" based on configuration
- Set Payment Status from payment processing result

### 12. Send Notifications

**Operations**:
- Email welcome message to new member
- Notify membership team of new signup
- Add to welcome journey in Marketing Cloud (if integrated)

## Formulas and Variables

### Key Variables

| Variable Name | Data Type | Initial Value | Description |
|---------------|-----------|--------------|-------------|
| contactId | Id | null | Contact record ID |
| accountId | Id | null | Account record ID |
| membershipLevelId | Id | null | Selected membership level ID |
| duesAmount | Currency | 0 | Calculated membership fee |
| paymentStatus | Text | "Pending" | Status of payment |
| startDate | Date | TODAY() | Membership start date |
| endDate | Date | null | Calculated end date |
| newMembershipId | Id | null | Created membership ID |

### Key Formulas

**End Date Calculation**:
```
IF(
    $RecordType.Name = 'Annual Membership',
    ADDMONTHS(startDate, 12),
    IF(
        $RecordType.Name = 'Monthly Membership',
        ADDMONTHS(startDate, 1),
        ADDMONTHS(startDate, Duration__c)
    )
)
```

**Proration Calculation**:
```
IF(
    ProrationEnabled__c,
    Annual_Fee__c * (ROUND((DATE(YEAR(TODAY()), 12, 31) - TODAY()) / 365, 2)),
    Annual_Fee__c
)
```

## Considerations and Extensions

1. **Accessibility**: All screens include appropriate labels and help text for screen readers

2. **Localization**: Labels stored in custom labels for multi-language support

3. **Future Enhancements**:
   - Integration with payment gateway
   - Discount code support
   - Family membership options (multiple contacts)

4. **Testing Scenarios**:
   - Individual signup with credit card
   - Individual signup with invoice
   - Organizational signup
   - Signup from existing contact
   - Handling duplicate detection 