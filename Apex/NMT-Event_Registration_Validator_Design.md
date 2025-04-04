---
title: "Nonprofit Membership Tracking - Event Registration Validator Design"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Draft"
version: "1.0"
created: "2025-04-09"
updated: "2025-04-09"
author: "AI Assistant"
---

# Event Registration Validator Design

## Overview

This document outlines the design for the `EventRegistrationValidator` Apex class. This class serves as the central validation layer, responsible for enforcing business rules and data integrity checks *before* an event registration request is passed to the transactional `EventRegistrationService` layer. Its purpose is to ensure that only valid registration requests proceed to the DML stage, improving data quality and providing clear feedback on invalid requests.

## Design Principles/Approach

1.  **Centralization**: Consolidates all registration-related business rule validation logic in one place.
2.  **Reusability**: Designed to be called from various entry points (Flows, other Apex, potentially APIs) before invoking the transactional service.
3.  **Clarity**: Returns a clear `ValidationResult` object containing a boolean status and a list of specific error messages if validation fails.
4.  **Pre-Transaction**: Executes checks *before* the transactional service layer, preventing unnecessary DML attempts with invalid data.
5.  **Read-Only**: Performs read operations (SOQL queries) to check existing data but does not perform any DML itself.

## Detailed Specifications

### 1. Wrapper Class (`EventValidationWrappers.ValidationResult`)

**Purpose**: Represents the outcome of validation checks.

**Location**: Defined within `EventRegistrationWrappers.cls` (or as an inner class within the Validator).

**Key Properties**:
-   `isValid` (Boolean): True if all checks passed, false otherwise.
-   `errors` (List<String>): A list of specific error messages explaining why validation failed.

**Key Methods**:
-   `addError(String errorMessage)`: Adds an error message to the list and sets `isValid` to false.

### 2. Validator Class (`EventRegistrationValidator.cls`)

**Purpose**: Contains the static methods to perform validation.

**Key Components**:

-   **`validate(EventRegistrationWrappers.RegistrationRequest request)` Static Method**:
    -   Accepts a single `RegistrationRequest` object.
    -   Instantiates a `ValidationResult`.
    -   Calls various private helper methods to perform specific checks.
    -   Aggregates errors into the `ValidationResult`.
    -   Returns the final `ValidationResult`.

-   **Private Helper Methods**: Encapsulate specific validation logic (examples below):
    -   `checkRequiredFields()`: Verifies presence of `contactId`, `eventId`.
    -   `checkEventExistsAndStatus()`: Queries `Event__c` to confirm existence and check if status allows registration (e.g., 'Planned', 'Active').
    -   `checkContactExists()`: Queries `Contact` to confirm existence.
    -   `checkMembershipExistsAndStatus()`: Queries `Membership__c` (if ID provided) to confirm existence and 'Active' status.
    -   `checkRegistrationDeadline()`: Compares registration date to `Event__c.Registration_Deadline__c`.
    -   `checkDuplicateRegistration()`: Queries `Member_Event_Participation__c` to see if the Contact is already registered (and not 'Cancelled').
    -   `checkEventCapacity()`: Queries `Member_Event_Participation__c` count against `Event__c.Max_Participants__c`.
    -   `checkMembershipLinkage()`: Verifies the provided `Membership__c` is linked to the provided `ContactId` (for individual memberships).
    -   `checkMembershipEventEligibility()`: Checks `Event__c.Member_Only__c` and `Event__c.Required_Level__c` against the provided `Membership__c`.
    -   `checkIfMembershipRequired()`: Checks if `Event__c.Member_Only__c` is true but no `MembershipId` was provided.

**Code Snippet Structure**:
```apex
// File: EventRegistrationValidator.cls
public with sharing class EventRegistrationValidator {

    public static EventValidationWrappers.ValidationResult validate(
        EventRegistrationWrappers.RegistrationRequest request
    ) {
        EventValidationWrappers.ValidationResult result = new EventValidationWrappers.ValidationResult();

        // Call private helper methods sequentially
        checkRequiredFields(request, result);
        if (!result.isValid) return result; // Early exit

        // Query necessary records (Event, Contact, Membership)
        Map<Id, Event__c> eventsMap = checkEventExistsAndStatus(...);
        // ... other existence checks ...
        if (!result.isValid) return result; // Early exit

        // Perform rule checks using queried records
        checkRegistrationDeadline(...);
        checkDuplicateRegistration(...);
        checkEventCapacity(...);
        if (request.membershipId != null) {
            checkMembershipLinkage(...);
            checkMembershipEventEligibility(...);
        } else {
            checkIfMembershipRequired(...);
        }

        return result;
    }

    // --- Private Helper Method Definitions ---
    // private static void checkRequiredFields(...) { ... }
    // private static Map<Id, Event__c> checkEventExistsAndStatus(...) { ... }
    // ... etc ...
}
```

## Implementation Notes

-   **Placement in Process**: This validator should be called immediately after gathering registration inputs (e.g., in a Screen Flow) and *before* calling the `EventRegistrationService.processRegistration` method.
-   **Flow Handling**: The calling Flow must check the `isValid` property of the returned `ValidationResult`. If `false`, the Flow should display the `errors` list to the user and prevent progression to the service call.
-   **SOQL Queries**: This class performs necessary SOQL queries to fetch data for validation. Ensure queries are selective and bulkified where possible if a list-based `validate` method is implemented in the future.
-   **Complexity of Checks**: Some checks (like capacity or level comparison) might require more nuanced logic depending on specific business requirements (e.g., handling waitlists distinctly, comparing membership level hierarchies).
-   **Error Messages**: Error messages should be user-friendly and informative.
-   **Permissions**: The context user running the code that calls this validator needs read access to `Event__c`, `Contact`, `Membership__c`, `Membership_Level__c`, and `Member_Event_Participation__c` objects and relevant fields.

## Related Documents

-   [NMT-Data_Model_Design_Consolidated.md](../Docs/NMT-Data_Model_Design_Consolidated.md)
-   [NMT-Event_Registration_Apex_Service_Design.md](NMT-Event_Registration_Apex_Service_Design.md)
-   [EventRegistrationWrappers.cls](EventRegistrationWrappers.cls)
-   *(Future Link)* `EventRegistrationValidator.cls`
-   *(Future Link)* Relevant Flow Design Documents calling this validator. 