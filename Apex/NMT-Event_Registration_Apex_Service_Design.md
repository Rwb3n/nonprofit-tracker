---
title: "Nonprofit Membership Tracking - Event Registration Apex Service Design"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Draft"
version: "1.0"
created: "2025-04-09"
updated: "2025-04-09"
author: "AI Assistant"
---

# Event Registration Apex Service Design

## Overview

This document details the design of the Apex service layer responsible for handling the transactional creation of `Member_Event_Participation__c` records. This service ensures that event registrations are processed reliably and atomically, forming a core part of the refined event participation architecture. It is designed to be invoked from Salesforce Flows or other Apex components.

## Design Principles/Approach

The Apex service layer adheres to the following principles:

1.  **Transactional Integrity**: The primary goal is to ensure that the core registration operation (creating the `Member_Event_Participation__c` record) succeeds or fails as a single unit. Apex transactions with savepoints and rollbacks are used to guarantee atomicity.
2.  **Separation of Concerns**: This service layer is strictly focused on the transactional creation of the participation record. It delegates validation logic to a separate `Validation Layer` (to be implemented) and assumes subsequent updates (like metric calculations) are handled by other mechanisms (e.g., record-triggered flows or platform events), aligning with the modular flow design.
3.  **Bulkification**: All DML operations are designed to handle lists of records efficiently, preventing governor limit issues when processing multiple registrations simultaneously.
4.  **Invocable Interface**: The service provides a clear, invocable interface using wrapper classes, making it easily consumable by Salesforce Flows.
5.  **Clear Error Handling**: Provides distinct success/failure feedback for each request within a transaction, including error messages upon failure.

## Detailed Specifications

The service layer consists of three main Apex components:

### 1. Wrapper Classes (`EventRegistrationWrappers.cls`)

**Purpose**: Define the data structures for input requests and output results passed to and from the invocable service method.

**Key Components**:

-   **`RegistrationRequest` Inner Class**: Defines the input parameters required for a single registration request.
    -   `contactId` (Id, required): The ID of the Contact participating.
    -   `eventId` (Id, required): The ID of the Event being registered for.
    -   `membershipId` (Id, optional): The ID of the associated Membership record, if applicable.
    -   `registrationDate` (Date, optional): Defaults to today if not provided.
    -   `initialAttendanceStatus` (String, optional): The starting status (e.g., 'Registered'). Defaults if not provided.
-   **`RegistrationResult` Inner Class**: Defines the output structure returned for each processed request.
    -   `isSuccess` (Boolean): Indicates if the individual registration was successful.
    -   `message` (String): Provides a status message (success or error details).
    -   `participationId` (Id): The ID of the created `Member_Event_Participation__c` record if successful, otherwise null.

**Code Snippet**:
```apex
// File: EventRegistrationWrappers.cls
public class EventRegistrationWrappers {

    public class RegistrationRequest {
        @InvocableVariable(label='Contact ID' required=true)
        public Id contactId;
        @InvocableVariable(label='Event ID' required=true)
        public Id eventId;
        @InvocableVariable(label='Membership ID (Optional)')
        public Id membershipId;
        @InvocableVariable(label='Registration Date (Optional)')
        public Date registrationDate;
        @InvocableVariable(label='Initial Attendance Status (Optional)')
        public String initialAttendanceStatus;
    }

    public class RegistrationResult {
        @InvocableVariable(label='Success')
        public Boolean isSuccess;
        @InvocableVariable(label='Message')
        public String message;
        @InvocableVariable(label='Participation Record ID')
        public Id participationId;

        public RegistrationResult(Boolean success, String msg, Id participationId) {
            // ... constructor ...
        }
         public RegistrationResult(Boolean success, String msg) {
            // ... constructor ...
         }
    }
}
```

### 2. Service Class (`EventRegistrationService.cls`)

**Purpose**: Provides the public, invocable entry point for initiating the registration process from Flows or other Apex code.

**Key Components**:

-   **`processRegistration` Static Method**:
    -   Annotated with `@InvocableMethod` for Flow compatibility.
    -   Accepts a `List<RegistrationRequest>`.
    -   Delegates the actual processing logic to the `EventRegistrationProcessor` class.
    -   Returns a `List<RegistrationResult>`.

**Code Snippet**:
```apex
// File: EventRegistrationService.cls
public class EventRegistrationService {

    @InvocableMethod(
        label='Process Event Registration Transactionally'
        description='Creates Member Event Participation records within a single transaction.'
        callout=false
    )
    public static List<EventRegistrationWrappers.RegistrationResult> processRegistration(
        List<EventRegistrationWrappers.RegistrationRequest> requests
    ) {
        return EventRegistrationProcessor.process(requests);
    }
}
```

### 3. Processor Class (`EventRegistrationProcessor.cls`)

**Purpose**: Contains the core transactional logic for creating `Member_Event_Participation__c` records. Ensures atomicity using savepoints and rollbacks.

**Key Logic**:

-   Accepts a `List<RegistrationRequest>`.
-   Prepares a list of `Member_Event_Participation__c` SObjects in memory based on the requests. Includes basic validation during preparation.
-   Sets a `Database.Savepoint`.
-   Performs a single bulk `Database.insert` operation within a `try` block. Uses `allOrNone=false` to allow for partial success reporting, though comprehensive validation should ideally occur earlier.
-   Processes the `Database.SaveResult` to construct the `List<RegistrationResult>`, indicating success/failure and the created record ID for each request.
-   If any exception occurs during the DML or result processing, it catches the exception, performs a `Database.rollback` using the savepoint, logs the error, and returns failure results for all requests in the batch.

**Code Snippet**:
```apex
// File: EventRegistrationProcessor.cls
public class EventRegistrationProcessor {

    public static List<EventRegistrationWrappers.RegistrationResult> process(
        List<EventRegistrationWrappers.RegistrationRequest> requests
    ) {
        // ... initialization ...
        List<Member_Event_Participation__c> participationsToInsert = new List<Member_Event_Participation__c>();

        // ... preparation loop with basic validation ...
            // participationsToInsert.add(createParticipationSObject(req));
        // ... handle preparation errors ...

        Database.Savepoint sp = Database.setSavepoint();
        try {
            if (!participationsToInsert.isEmpty()) {
                Database.insert(participationsToInsert, false); // Partial success allowed
            }

            // ... process results based on insert outcome ...

        } catch (Exception e) {
            Database.rollback(sp);
            // ... handle rollback and set error results for the batch ...
            System.debug(LoggingLevel.ERROR, 'EventRegistrationProcessor Error: ...');
        }

        return results;
    }

    private static Member_Event_Participation__c createParticipationSObject(
        EventRegistrationWrappers.RegistrationRequest req
    ) {
        // ... maps request fields to SObject fields ...
        return participation;
    }

    public class EventRegistrationException extends Exception {}
}
```

## Implementation Notes

-   **Validation Layer Dependency**: This service layer assumes that comprehensive business rule validation (e.g., checking event capacity, membership eligibility, duplicate registrations) is handled *before* this service is called, ideally by a dedicated `EventRegistrationValidator` Apex class.
-   **Flow Integration**: This Apex service is designed to be called from a Screen Flow (for user-driven registration) or potentially an Auto-launched Flow triggered by other events. The Flow is responsible for gathering input and invoking this Apex action.
-   **Error Handling in Flow**: The calling Flow must handle the `RegistrationResult` list returned by the Apex action, checking the `isSuccess` flag for each result and displaying appropriate messages or taking corrective action.
-   **Metric Updates**: Updates to related records (e.g., calculating `Contact.Last_Event_Attended__c` or `Contact.Events_Attended_YTD__c`) are intentionally excluded from this transaction and should be handled by a separate record-triggered flow listening for the creation/update of `Member_Event_Participation__c` records.
-   **Permissions**: Ensure the running user (or the context in which the Flow calls Apex) has the necessary permissions to create `Member_Event_Participation__c` records.

## Related Documents

-   [NMT-Data_Model_Design_Consolidated.md](../Docs/NMT-Data_Model_Design_Consolidated.md)
-   [EventRegistrationWrappers.cls](EventRegistrationWrappers.cls)
-   [EventRegistrationService.cls](EventRegistrationService.cls)
-   [EventRegistrationProcessor.cls](EventRegistrationProcessor.cls)
-   *(Future Link)* `NMT-Event_Registration_Validator_Design.md`
-   *(Future Link)* Relevant Flow Design Documents (e.g., `NMT-Event_Registration_Screen_Flow_Design.md`) 