// File: EventRegistrationService.cls
public class EventRegistrationService {

    @InvocableMethod(
        label='Process Event Registration Transactionally'
        description='Creates Member Event Participation records within a single transaction.'
        callout=false // Assuming no callouts needed for this core registration step
    )
    public static List<EventRegistrationWrappers.RegistrationResult> processRegistration(
        List<EventRegistrationWrappers.RegistrationRequest> requests
    ) {
        // Delegate processing to the processor class
        return EventRegistrationProcessor.process(requests);
    }
}