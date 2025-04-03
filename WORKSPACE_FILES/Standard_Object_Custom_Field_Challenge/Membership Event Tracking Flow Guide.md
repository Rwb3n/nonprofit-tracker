
## Flow 1: "Update Contact Event Metrics"

### What This Flow Does

This flow runs automatically whenever someone records a member's event participation. It updates two fields on the Contact record:

- The date of the last event they attended
- How many events they've attended this year

### Setup Instructions

#### Step 1: Create a New Flow

1. Select **Record-Triggered Flow** and click **Create**
2. Configure trigger:
    - Object: **Member_Event_Participation__c**
    - Trigger: **A record is created or updated**
    - Condition: **None** (we'll handle conditions in the flow)
    - Optimization: **Actions and Related Records**
    - Click **Done**

#### Step 2: Add Decision Element to Check Attendance Status

1. Add a **Decision** element from the Elements panel
2. Label: "Check Attendance Status Change"
3. Create outcomes:
    - **Outcome 1:**
        - Label: "New Attended Record"
        - Condition:
            - $Record.Attendance_Status__c EQUALS "Attended"
            - $Record.IsNew EQUALS true
	            - ==Human Note: For the above to work; created a new Resource > Formula > Boolean > **ISNEW()**
	            - ==Human Note: Also **ISCLONE()** should I need it in the future...
    - **Outcome 2:**
        - Label: "Changed to Attended"
        - Condition:
            - $Record.Attendance_Status__c EQUALS "Attended"
            - $Record.IsChanged EQUALS true
            - $Record.PriorValue DOES NOT EQUAL "Attended"
    - **Outcome 3:**
        - Label: "Changed from Attended"
        - Condition:
            - $Record.Attendance_Status__c DOES NOT EQUAL "Attended"
            - $Record.IsChanged EQUALS true
            - $Record.PriorValue EQUALS "Attended"
    - Default Outcome: "No Relevant Change"
4. Click **Done**

#### Step 3: Get Related Contact

1. From any of the attendance-related outcomes, add a **Get Records** element
2. Label: "Get Related Contact"
3. Object: **Contact**
4. Condition:
    - Field: **Id**
    - Operator: **Equals**
    - Value: **$Record.Contact_Id__c** (Add this field to Member_Event_Participation__c if it doesn't exist)
5. Store record data: **Choose fields to store**
    - Select **Id**, **Last_Event_Attended__c**, **Events_Attended_YTD__c**
6. How many records to store: **Only the first record**
7. Variable name: **varContact**
8. Click **Done**

#### Step 4: Get Event Details

1. Add another **Get Records** element
2. Label: "Get Event Details"
3. Object: **Event__c**
4. Condition:
    - Field: **Id**
    - Operator: **Equals**
    - Value: **$Record.Event__c**
5. Store record data: **Choose fields to store**
    - Select **Id**, **Event_Date__c**
6. How many records to store: **Only the first record**
7. Variable name: **varEvent**
8. Click **Done**

#### Step 4 & 1/2: Create **varEventDate**

1. New Resource, Type: Variable
2. Name: varEventDate, Data Type: Date
3. Value: varEvent > Event date

#### Step 5: Count This Year's Events

1. Add another **Get Records** element
2. Label: "Count YTD Events"
3. Object: **Member_Event_Participation__c**
4. Conditions:
    
    - Field: **Contact_Id__c**
    - Operator: **Equals**
    - Value: **$Record.Contact_Id__c**
    
    AND
    
    - Field: **Attendance_Status__c**
    - Operator: **Equals**
    - Value: **Attended**
    
    AND
    - Field: **Event__r.Event_Date__c**
    - Operator: **Equals**
    - Value: **THIS_YEAR** (from the Formula resources)
5. Store record data: **Count of records**
6. Variable name: **varYtdCount**
7. Click **Done**

#### Step 6: Find Most Recent Event

1. Add another **Get Records** element
2. Label: "Get Most Recent Event"
3. Object: **Member_Event_Participation__c**
4. Conditions:
    
    - Field: **Contact_Id__c**
    - Operator: **Equals**
    - Value: **$Record.Contact_Id__c**
    
    AND
    - Field: **Attendance_Status__c**
    - Operator: **Equals**
    - Value: **Attended**
5. Sort by:
    - Field: **Event__r.Event_Date__c**
    - Direction: **Descending**
6. Store record data: **Choose fields to store**
    - Select **Event__r.Event_Date__c**
7. How many records to store: **Only the first record**
8. Variable name: **varMostRecentEvent**
9. Click **Done**

#### Step 7: Update Contact Record

1. Add an **Assignment** element
2. Label: "Prepare Contact Update Values"
3. Assignments:
    - Variable: **{!varLastEventDate}** (create new Text variable)
    - Operator: **Equals**
    - Value: **{!varMostRecentEvent.Event__r.Event_Date__c}**
4. Click **Done**
5. Add an **Update Records** element
6. Label: "Update Contact Metrics"
7. How to find records to update: **Use the IDs and all field values from a record or record collection**
8. Variable: **{!varContact}**
9. Field values to update:
    - Set **Last_Event_Attended__c** to **{!varLastEventDate}**
    - Set **Events_Attended_YTD__c** to **{!varYtdCount}**
10. Click **Done**

#### Step 8: Connect Flow Elements

1. Connect the "New Attended Record" outcome to "Get Related Contact"
2. Connect the "Changed to Attended" outcome to "Get Related Contact"
3. Connect the "Changed from Attended" outcome to "Get Related Contact"
4. Connect the default "No Relevant Change" outcome to END
5. Complete the remaining connections in sequence
6. Save the flow with name: "NMT_Update_Contact_Event_Metrics"
7. Activate the flow

## Flow 2: "Reset YTD Event Counts"

### What This Flow Does

This flow runs once a year on January 1st and resets the "Events Attended (YTD)" counter back to 0 for all contacts.

### Setup Instructions

#### Step 1: Create a New Flow

1. Go to **Setup** → **Process Automation** → **Flows** → **New Flow**
2. Select **Scheduled Flow** and click **Create**
3. Set schedule:
    - Frequency: **Once**
    - Start: **January 1, [Next Year], 12:00 AM**
    - Time Zone: **Your organization's default**
4. Click **Done**

#### Step 2: Get All Contacts With Events

1. Add a **Get Records** element
2. Label: "Get Contacts With Event Count"
3. Object: **Contact**
4. Condition:
    - Field: **Events_Attended_YTD__c**
    - Operator: **Greater than**
    - Value: **0**
5. Store record data: **All records and record data**
6. Variable name: **varContactsToReset**
7. Click **Done**

#### Step 3: Reset Event Counters

1. Add an **Update Records** element
2. Label: "Reset YTD Counters"
3. How to find records to update: **Use the IDs and all field values from a record or record collection**
4. Variable: **{!varContactsToReset}**
5. Field values to update:
    - Set **Events_Attended_YTD__c** to **0**
6. Click **Done**

#### Step 4: Add Notification (Optional)

1. Add an **Action** element
2. Search for and select **Send Email**
3. Label: "Send Completion Notification"
4. Configure email:
    - Subject: "YTD Event Counter Reset Complete"
    - Body: "Reset completed for {!varContactsToReset.size} contacts on {!$Flow.CurrentDateTime}"
    - Recipients: [your admin email]
5. Click **Done**

#### Step 5: Connect Flow Elements

1. Connect the elements in sequence
2. Save the flow with name: "NMT_Reset_YTD_Event_Counters"
3. Activate the flow

## Important Notes:

1. **Add Contact_Id__c Field**: Make sure to add a Contact_Id__c lookup field to Member_Event_Participation__c if it doesn't already exist
2. **Test in Sandbox**: Always test these flows in a sandbox environment first
3. **Data Volume**: Be mindful of how many contacts and events you have when designing these flows
4. **Error Handling**: Consider adding error handling elements for production use

## Troubleshooting:

- If the flow isn't updating contacts, check your field names and permissions
- Ensure "Allow Flows to Access and Modify All Data" is enabled if using user context
- Verify record-triggered flow is activated
- Check debug logs to identify any issues during execution