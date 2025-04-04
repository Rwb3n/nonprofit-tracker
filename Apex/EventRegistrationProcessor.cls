// File: EventRegistrationProcessor.cls
public class EventRegistrationProcessor {

    // Processes a list of registration requests transactionally
    public static List<EventRegistrationWrappers.RegistrationResult> process(
        List<EventRegistrationWrappers.RegistrationRequest> requests
    ) {
        List<EventRegistrationWrappers.RegistrationResult> results = new List<EventRegistrationWrappers.RegistrationResult>();
        List<Member_Event_Participation__c> participationsToInsert = new List<Member_Event_Participation__c>();
        Map<Integer, EventRegistrationWrappers.RegistrationRequest> requestMap = new Map<Integer, EventRegistrationWrappers.RegistrationRequest>(); // To map results back

        // Prepare records for insertion
        for (Integer i = 0; i < requests.size(); i++) {
            EventRegistrationWrappers.RegistrationRequest req = requests[i];
            requestMap.put(i, req); // Store original request by index
            try {
                 // Basic validation before preparing SObject
                if (req.contactId == null || req.eventId == null) {
                    // Note: InvocableVariable required=true should prevent this, but good practice
                    throw new EventRegistrationException('Missing required Contact ID or Event ID.');
                }
                participationsToInsert.add(createParticipationSObject(req));
            } catch (Exception e) {
                // Capture preparation errors (though less likely with simple mapping)
                 results.add(new EventRegistrationWrappers.RegistrationResult(false, 'Error preparing registration: ' + e.getMessage()));
                 // Ensure results list matches request size if we skip insertion for this item later
                 while(results.size() < i + 1) { results.add(null); } // Pad with nulls if needed, though ideally throw early
            }
        }

         // If preparation resulted in errors for all requests, return early
        if (participationsToInsert.isEmpty() && !requests.isEmpty()) {
             // Fill results if not already done by individual errors
             while(results.size() < requests.size()) {
                 results.add(new EventRegistrationWrappers.RegistrationResult(false, 'Failed to prepare any participation records.'));
             }
            return results;
        }


        Database.Savepoint sp = Database.setSavepoint();
        try {
            // Perform DML Insert (Bulkified)
            if (!participationsToInsert.isEmpty()) {
                Database.insert(participationsToInsert, false); // Use partial success to handle record-level errors if needed, though validation layer should catch most
            }

             // Process results after DML
             Integer resultIdx = 0; // Index for results list
            for (Integer i = 0; i < participationsToInsert.size(); i++) {
                Member_Event_Participation__c insertedParticipation = participationsToInsert[i];
                // Find corresponding original request index if needed - assumes participationsToInsert maps 1:1 to requests sans prep errors

                if (insertedParticipation.Id != null) {
                     results.add(new EventRegistrationWrappers.RegistrationResult(true, 'Registration successful.', insertedParticipation.Id));
                } else {
                    // Handle potential partial insert failures if Database.insert(..., false) was used
                     String errorMsg = 'Registration failed.';
                     // Check for specific errors if allOrNone=false
                     for (Database.Error err : insertedParticipation.getErrors()) {
                         errorMsg += ' ' + err.getStatusCode() + ': ' + err.getMessage();
                         errorMsg += ' Fields: ' + String.join(err.getFields(), ',');
                     }
                    results.add(new EventRegistrationWrappers.RegistrationResult(false, errorMsg));
                }
                resultIdx++;
             }
             // Ensure results list size matches request size if some requests failed preparation
             while(results.size() < requests.size()) {
                 // This assumes preparation errors were added earlier.
                 // If not, add a generic failure message for unprepared requests.
                 results.add(new EventRegistrationWrappers.RegistrationResult(false, 'Request could not be processed due to earlier errors.'));
             }


        } catch (Exception e) {
            Database.rollback(sp);
            // Create a generic error result for all requests in this transaction batch
            results.clear(); // Clear any partial results from try block
            String errorMessage = 'Transaction failed: ' + e.getMessage();
             System.debug(LoggingLevel.ERROR, 'EventRegistrationProcessor Error: ' + e.getMessage() + '\nStackTrace: ' + e.getStackTraceString());
             for(Integer i=0; i < requests.size(); i++) {
                 results.add(new EventRegistrationWrappers.RegistrationResult(false, errorMessage));
             }
        }

        return results;
    }

    // Helper to create the SObject in memory (no DML)
    private static Member_Event_Participation__c createParticipationSObject(
        EventRegistrationWrappers.RegistrationRequest req
    ) {
        Member_Event_Participation__c participation = new Member_Event_Participation__c();
        participation.Contact__c = req.contactId;
        participation.Event__c = req.eventId;
        participation.Membership__c = req.membershipId; // Will be null if not provided
        participation.Registration_Date__c = (req.registrationDate != null) ? req.registrationDate : Date.today();
        participation.Attendance_Status__c = String.isNotBlank(req.initialAttendanceStatus) ? req.initialAttendanceStatus : 'Registered'; // Default status

        // Add other fields as necessary based on defaults or simple request mapping
        // Example: participation.Source__c = 'Flow Registration';

        return participation;
    }

     // Custom Exception class for clarity
     public class EventRegistrationException extends Exception {}
}