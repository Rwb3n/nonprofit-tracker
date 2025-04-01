---
Title: Nonprofit Membership Tracking - Membership Onboarding Flow Design
Project: Nonprofit Membership Tracking
Phase: Design
Status: Draft
Last Updated: 2025-03-26
---

# Membership Onboarding Flow Design

## Flow Overview

The Membership Onboarding Flow automates the process of registering new members, creating their membership records, and initiating the welcome sequence. This flow is designed to be versatile, supporting multiple entry points:

1. **Screen Flow**: Staff-assisted signup (call center or in-person)
2. **Auto-launched Flow**: Web form integration (online self-registration)
3. **Quick Action**: From Contact record when manually converting to member

## Flow Metadata

- **API Name**: NMT_Membership_Onboarding_Flow
- **Type**: Screen Flow & Auto-launched Flow (dual-purpose)
- **Description**: Handles new member registration process and creates membership records
- **Runtime**: User (for staff usage) or System (for web integration)
- **Protection**: Protected to prevent modification

## Flow Logic Diagram

```
START
  │
  ▼
GET INPUT VARIABLES ──────────────────────────────────────┐
  │                                                       │
  ▼                                                       │
RECORD EXISTS CHECK ──Yes──► DISPLAY DUPLICATE WARNING    │
  │                              │                        │
  │ No                           │                        │
  ▼                              │                        │
SCREEN: MEMBER TYPE               │                        │
  │                              │                        │
  ▼                              │                        │
DECISION: Individual or Org?      │                        │
  │                              │                        │
  ├─► Individual                 │                        │
  │       │                      │                        │
  │       ▼                      │                        │
  │   SCREEN: CONTACT INFO       │                        │
  │       │                      │                        │
  │       ▼                      │                        │
  │   CREATE/UPDATE CONTACT      │                        │
  │       │                      │                        │
  ▼       ▼                      │                        │
SCREEN: MEMBERSHIP DETAILS        │                        │
  │                              │                        │
  ▼                              │                        │
GET PRICING ◄───────────────────┐│                        │
  │                              ││                        │
  ▼                              ││                        │
SCREEN: PAYMENT OPTIONS           ││                        │
  │                              ││                        │
  ▼                              ││                        │
PROCESS PAYMENT ◄────────────────┘│                        │
  │                               │                        │
  ▼                               │                        │
CREATE MEMBERSHIP                  │                        │
  │                               │                        │
  ▼                               │                        │
CREATE HISTORY RECORD              │                        │
  │                               │                        │
  ▼                               │                        │
UPDATE CONTACT/ACCOUNT             │                        │
  │                               │                        │
  ▼                               │                        │
SEND NOTIFICATIONS                 │                        │
  │                               │                        │
  ▼                               │                        │
DISPLAY CONFIRMATION               │                        │
  │                               │                        │
  ▼                               │                        │
END                                │                        │
                                  │                        │
                                  ▼                        │
                   USE EXISTING RECORD? ──No──► END        │
                                  │                        │
                                  │ Yes                    │
                                  ▼                        │
                        LOAD EXISTING CONTACT              │
                                  │                        │
                                  └────────────────────────┘
```

## Flow Elements in Detail

### 1. Input Variables

| Variable Name | Data Type | Description | Required | Default |
|---------------|-----------|-------------|----------|---------|
| contactId | Id | Existing contact ID if launched from contact | No | null |
| accountId | Id | Existing account ID if launched from account | No | null |
| email | Email | Email address for duplicate checking | No | null |
| source | Text | Registration source (Web, Phone, In-Person) | Yes | "Staff" |
| membershipLevelId | Id | Pre-selected membership level | No | null |
| skipDuplicateCheck | Boolean | Whether to bypass duplicate checking | No | false |
| autoLaunch | Boolean | Whether flow is running in auto-launch mode | No | false |

### 2. Record Exists Check

**Logic**: 
- If `contactId` is provided, verify it exists
- If `email` is provided, check for existing contacts with that email using SOQL:
  ```sql
  SELECT Id, FirstName, LastName, Email, Phone
  FROM Contact
  WHERE Email = :email
  LIMIT 5
  ```
- If `accountId` is provided, verify it exists
- If `skipDuplicateCheck` is true, bypass this check

**Assignment**:
- Set `recordExists = (found matching records)`
- Store existing record details in `existingRecords` collection variable

### 3. Screen: Member Type
*(Skip if `contactId` or `accountId` is populated)*

**Elements**:
- Header: "Select Membership Type"
- Radio buttons for "Individual Membership" or "Organizational Membership"
- Help text explaining differences between membership types
- Button: "Next"

**Conditions**:
- Display only if `contactId` and `accountId` are null
- Skip if `source` = "Web" and `individualOnly` = true
- Skip in auto-launch mode (set default to Individual)

### 4. Decision: Individual or Org

**Logic**:
- If `memberType` = "Individual" → Individual path
- If `memberType` = "Organizational" → Set `requireOrgDetails` = true
- If `contactId` is populated → Skip Contact Info screen
- If `accountId` is populated → Skip Account Info screen

### 5. Screen: Contact Info
*(Skip if `contactId` is populated)*

**Elements**:
- Header: "Member Information"
- First Name (required)
- Last Name (required)
- Email (required)
- Phone
- Address components (Street, City, State, Zip, Country)
- Custom questions (configurable based on Membership Level)
- Button: "Next"

**Validations**:
- Email format validation using regex
- Required field checks with highlighted indicators

### 6. Create/Update Contact

**Operations**:
- If `contactId` exists: Update contact with new information
- If no `contactId`: Create new contact record
- Store ID in `contactId` variable

**DML Operations**:
```
IF(ISBLANK(contactId)) {
    // Create new Contact
    Contact newContact = new Contact(
        FirstName = firstName,
        LastName = lastName,
        Email = email,
        Phone = phone,
        MailingStreet = street,
        MailingCity = city,
        MailingState = state,
        MailingPostalCode = zip,
        MailingCountry = country
    );
    INSERT newContact;
    contactId = newContact.Id;
} ELSE {
    // Update existing Contact
    Contact existingContact = [SELECT Id FROM Contact WHERE Id = :contactId];
    existingContact.FirstName = firstName;
    existingContact.LastName = lastName;
    // ... other fields
    UPDATE existingContact;
}
```

### 7. Screen: Membership Details

**Elements**:
- Header: "Membership Details"
- Membership Level (picklist, required)
  - Dynamically filtered based on "Available To" field matching Individual/Organizational
  - Pre-selected if `membershipLevelId` was provided
- Start Date (defaults to today)
- Special Notes or Requests (text area)
- Checkbox for Terms and Conditions (required)
- Button: "Next"

**Dynamic Content**:
- Membership level selection shows description and benefits from Membership Level object
- Annual fee updates based on selected level

### 8. Get Pricing

**Operations**:
- Query Membership Level record for selected level:
  ```sql
  SELECT Id, Name, Annual_Fee__c, Duration__c, Grace_Period__c
  FROM Membership_Level__c
  WHERE Id = :membershipLevelId
  ```
- Get Annual Fee and any applicable discounts
- Calculate prorated amount if proration is enabled

**Assignment**:
- Set `duesAmount` to calculated final price
- Set `endDate` to Start Date + Duration (months)

### 9. Screen: Payment Options
*(Skip if `duesAmount` = 0)*

**Elements**:
- Header: "Payment Details"
- Payment amount display (calculated from membership level)
- Payment method selection (Credit Card, Invoice, Waived)
- Credit card form (conditionally displayed if method = "Credit Card")
  - Card Number
  - Expiration Date
  - CVV
  - Billing Address
- Button: "Complete Registration"

**Conditions**:
- Skip if `duesAmount` = 0
- Credit card fields only appear if payment method = "Credit Card"

### 10. Process Payment
*(Mock implementation for demonstration - no actual payment processing)*

**Logic**:
- If `paymentMethod` = "Credit Card": Simulate payment processing
- If `paymentMethod` = "Invoice": Set `paymentStatus` = "Pending"
- If `paymentMethod` = "Waived": Set `paymentStatus` = "Paid", `duesAmount` = 0

**Error Handling**:
- Catch payment failures and provide retry option
- Log payment attempts in debug logs
- For demo: Always succeed unless specific test cards are used

### 11. Create Membership

**Record Creation**:
- New `Membership__c` record with collected data
- Link to Contact or Account based on membership type
- Set Status based on configuration and payment status
- Set End Date from calculation

**DML Operation**:
```
Membership__c newMembership = new Membership__c(
    Contact__c = (isIndividual) ? contactId : null,
    Account__c = (!isIndividual) ? accountId : null,
    Membership_Level__c = membershipLevelId,
    Start_Date__c = startDate,
    End_Date__c = endDate,
    Status__c = (paymentStatus == 'Paid') ? 'Active' : 'Pending',
    Renewal_Type__c = renewalType,
    Join_Method__c = source,
    Dues_Amount__c = duesAmount,
    Payment_Status__c = paymentStatus,
    Auto_Renew__c = autoRenew,
    Member_Since__c = startDate,
    Referral_Source__c = referralSource,
    Special_Notes__c = specialNotes
);
INSERT newMembership;
membershipId = newMembership.Id;
```

### 12. Create History Record

**Record Creation**:
- New `Membership_History__c` record
- Records initial membership creation event
- Sets appropriate status and timestamps

**DML Operation**:
```
Membership_History__c history = new Membership_History__c(
    Membership__c = membershipId,
    Change_Date__c = NOW(),
    Previous_Status__c = null,
    New_Status__c = (paymentStatus == 'Paid') ? 'Active' : 'Pending',
    Previous_Level__c = null,
    New_Level__c = membershipLevelId,
    Change_Reason__c = 'Initial Membership Creation',
    Changed_By__c = UserInfo.getUserId()
);
INSERT history;
```

### 13. Update Contact/Account

**Logic**:
- Update the Contact or Account's `Current_Membership__c` field with the new membership ID
- If this is their first membership, also set the `Membership_Since__c` field

**DML Operation**:
```
IF(isIndividual) {
    Contact cont = [SELECT Id, Current_Membership__c, Membership_Since__c 
                   FROM Contact WHERE Id = :contactId];
    cont.Current_Membership__c = membershipId;
    if(cont.Membership_Since__c == null) {
        cont.Membership_Since__c = startDate;
    }
    UPDATE cont;
} ELSE {
    Account acc = [SELECT Id, Current_Membership__c, Membership_Since__c 
                  FROM Account WHERE Id = :accountId];
    acc.Current_Membership__c = membershipId;
    if(acc.Membership_Since__c == null) {
        acc.Membership_Since__c = startDate;
    }
    UPDATE acc;
}
```

### 14. Send Notifications

**Operations**:
- Email welcome message to new member
- Notify membership team of new signup
- Add to welcome journey in Marketing Cloud (if integrated)

**Email Template Variables**:
- Member Name
- Membership Level
- Start Date
- End Date
- Organization Name
- Membership Benefits

### 15. Display Confirmation

**Elements**:
- Header: "Membership Registration Complete"
- Confirmation message with membership details
- Membership ID and status
- Next steps information
- Button: "Finish"

**Skip Logic**:
- Skip in auto-launch mode

## Variable and Collection Details

### Key Variables

| Variable Name | Data Type | Initial Value | Description |
|---------------|-----------|--------------|-------------|
| contactId | Id | null | Contact record ID |
| accountId | Id | null | Account record ID |
| membershipType | String | "Individual" | Type of membership (Individual/Organizational) |
| membershipLevelId | Id | null | Selected membership level ID |
| duesAmount | Currency | 0 | Calculated membership fee |
| paymentMethod | String | null | Selected payment method |
| paymentStatus | String | "Pending" | Status of payment |
| startDate | Date | TODAY() | Membership start date |
| endDate | Date | null | Calculated end date |
| membershipId | Id | null | Created membership ID |
| recordExists | Boolean | false | Whether duplicate was found |
| isIndividual | Boolean | true | Whether this is an individual membership |

### Collection Variables

| Variable Name | Data Type | Description |
|---------------|-----------|-------------|
| existingRecords | SObject Collection (Contact) | Collection of potential duplicate contacts |
| availableLevels | SObject Collection (Membership_Level__c) | Available membership levels |

## Formulas and Calculations

### End Date Calculation
```
IF(
    durationMonths == 12,
    DATE(YEAR(startDate) + 1, MONTH(startDate), DAY(startDate)),
    DATE(
        YEAR(startDate) + FLOOR(durationMonths / 12),
        MONTH(startDate) + MOD(durationMonths, 12),
        DAY(startDate)
    )
)
```

### Proration Calculation
```
IF(
    ProrationEnabled__c,
    Annual_Fee__c * (ROUND((DATE(YEAR(TODAY()), 12, 31) - TODAY()) / 365, 2)),
    Annual_Fee__c
)
```

## Error Handling

The flow incorporates several error handling mechanisms:

1. **Input Validation**:
   - Required field checks before proceeding to next screens
   - Data format validation (email, dates, etc.)
   - Membership level availability validation

2. **Duplicate Detection**:
   - Detection and resolution of potential duplicate contacts
   - Options to use existing records or create new ones
   - Prevention of duplicate memberships for same time period

3. **Payment Processing**:
   - Error handling for failed payments
   - Retry options for users
   - Status tracking for payment attempts

4. **DML Error Handling**:
   - Try/catch blocks around database operations
   - Informative error messages for users
   - Rollback on partial failures

## Testing Considerations

Test cases should include:

1. **Individual Membership**:
   - New contact with credit card payment
   - New contact with invoice payment
   - Existing contact with new membership

2. **Organizational Membership**:
   - New account with primary contact
   - Existing account with new membership

3. **Edge Cases**:
   - Duplicate email detection and resolution
   - $0 memberships (free/complementary)
   - Payment failures and retries

## Accessibility Considerations

The flow is designed with accessibility in mind:

1. All screens include appropriate labels for screen readers
2. Error messages are descriptive and helpful
3. Tab order follows logical screen flow
4. Color is not the only indicator for required fields
5. Sufficient contrast for all UI elements

## Future Enhancements

Potential enhancements for future versions (not in current scope):

1. Integration with payment gateway for real-time processing
2. Multi-language support through custom labels
3. Family membership options (multiple contacts)
4. Discount code functionality
5. Renewal flow integration 