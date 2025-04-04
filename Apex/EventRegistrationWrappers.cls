// File: EventRegistrationWrappers.cls
public class EventRegistrationWrappers {

    // Input structure for the Invocable Method
    public class RegistrationRequest {
        @InvocableVariable(label='Contact ID' required=true)
        public Id contactId;

        @InvocableVariable(label='Event ID' required=true)
        public Id eventId;

        @InvocableVariable(label='Membership ID (Optional)')
        public Id membershipId; // Optional link if registering via membership

        @InvocableVariable(label='Registration Date (Optional)')
        public Date registrationDate; // Defaults to today if null

        @InvocableVariable(label='Initial Attendance Status (Optional)')
        public String initialAttendanceStatus; // e.g., 'Registered', defaults if null
    }

    // Output structure for the Invocable Method
    public class RegistrationResult {
        @InvocableVariable(label='Success')
        public Boolean isSuccess;

        @InvocableVariable(label='Message')
        public String message;

        @InvocableVariable(label='Participation Record ID')
        public Id participationId; // ID of the created record on success

        public RegistrationResult(Boolean success, String msg, Id participationId) {
            this.isSuccess = success;
            this.message = msg;
            this.participationId = participationId;
        }
         public RegistrationResult(Boolean success, String msg) {
            this.isSuccess = success;
            this.message = msg;
            this.participationId = null;
        }
    }
}