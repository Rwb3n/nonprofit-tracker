### **1. Step One: Understand the Problem**

We need a flow that:

1. **Updates "Last Event Attended"** and **"Events Attended (YTD)"** on the **Contact** record every time a member attends an event.
2. **Resets the "Events Attended (YTD)"** field to **0** every January 1st.

---

### **2. Step Two: Define All Necessary Fields**

#### **a. Fields on the "Member Event Participation" (Custom Object)**

- **Attendance Status (Picklist):** Indicates if the person attended or missed the event.
    - Values: "Attended", "No-Show", "Cancelled"
- **Membership (Lookup to Membership):** Links participation to a membership record.
- **Event (Lookup to Event):** Links to the specific event.
- ==**Contact (Lookup to Contact)** _(recommended)_: Directly link the participation record to a contact to avoid unnecessary queries.

---

#### **b. Fields on the "Event" (Custom Object)**

- **Event Date (Date):** The date when the event occurred.

---

#### **c. Fields on the "Contact" (Standard Object)**

- **Last Event Attended (Date):** The most recent event attended by the contact.
- **Events Attended (YTD) (Number):** The number of events attended this year.

---

### **3. Step Three: Build the Flows**

---

#### **Flow 1: Update Contact Event Participation Metrics**

**Purpose:** Updates **Last Event Attended** and **Events Attended (YTD)** when a new participation record is created or updated.

**Flow Type:**

- **Record-Triggered Flow**
- **Object:** Member Event Participation
- **Trigger:** After Save (Create/Update)

---

##### **Flow Structure:**

1. **START:** Trigger on **Member Event Participation** when a record is **created or updated**.
2. **CHECK ATTENDANCE STATUS:**
    - **Decision Element:**
        - If **Attendance Status = 'Attended'**, proceed.
        - Else, **End Flow**.

3. **GET RELATED CONTACT:**

    - **Get Records Element:** Fetch the **Contact** directly using the **Contact Lookup** field on **Member Event Participation**.
4. **GET EVENT DETAILS:**
    - **Get Records Element:** Fetch **Event** using the **Event Lookup** on **Member Event Participation**.
    - **Store:** Event Date.

5. **GET YTD EVENT COUNT:**
    - **Get Records Element:** Query **Member Event Participation** where:
        - **Contact ID** equals **Fetched Contact**
        - **Attendance Status = 'Attended'**
        - **Event Date = THIS_YEAR**
    - **Count the records.**

6. **UPDATE CONTACT RECORD:**
    - **Update Records Element:**
        - **Last Event Attended = Event Date**
        - **Events Attended (YTD) = Count of YTD Events**
    - **Bulk Update:** Use a **record collection** if multiple updates are needed.

7. **END FLOW.**

---

### **Flow 2: Reset YTD Event Counts**

**Purpose:** Resets **Events Attended (YTD)** to **0** every January 1st.

**Flow Type:**

- **Scheduled Flow**
- **Trigger:** Every year on **January 1st at 12:00 AM**

---

##### **Flow Structure:**

1. **START:** Triggered automatically on January 1st.
    
2. **GET ALL CONTACTS:**
    
    - **Get Records Element:**
        
        - Find all contacts where **Events Attended (YTD) > 0**.
            
3. **RESET COUNTER:**
    
    - **Loop through contacts:**
        
        - Set **Events Attended (YTD)** to **0**.
            
    - **Update Records Element:** Update all contacts in one go using a **collection**.
        
4. **END FLOW.**
    

---

### **4. Step Four: Considerations and Optimization**

**1. Flow Bulkification:**

- Store contacts needing updates in a **collection**.
    
- Perform a **single bulk update** at the end rather than updating individually.
    

**2. Error Handling:**

- Add **fault paths** in case of errors when fetching records or updating.
    
- Log errors in a **custom object** or send an alert email.
    

**3. Governor Limits:**

- Use **record collections** to avoid hitting DML limits.
    
- Always **test in a sandbox** before deploying.
    

---

### **5. Step Five: Deploy and Test**

1. Create the flows in a **sandbox environment**.
    
2. Test with **different scenarios:**
    
    - Single event attendance.
        
    - Multiple contacts attending simultaneously.
        
    - Yearly reset of YTD counts.
        
3. Deploy to production after successful testing.