### **Audit and Debug Scaffolding Prompt:**

1. **Problem Identification:**
    
    - What is the **primary challenge or issue** described?
    - What **business requirement** or **user story** does it relate to?
    - What **object(s)** and **fields** are involved?
    - Is the problem related to **real-time updates**, **scheduled tasks**, **data integrity**, or **performance**?
---

2. **Field and Data Structure Analysis:**

    - What **standard** or **custom fields** are involved?
    - Are these fields correctly defined for the intended logic (e.g., **data types**, **picklist values**, **lookups**)?
    - Are there any **missing fields** that would make the logic more efficient or reliable?
    - Are **related objects** appropriately linked?

---

3. **Flow Architecture Evaluation:**
    
    - Is the **flow type** suitable for the task (e.g., **record-triggered**, **scheduled**, **screen flow**)?
    - Does the **trigger condition** accurately reflect when the flow should run?
    - Are the **steps in the flow** logically ordered and structured for optimal performance?
    - Are **Get Records** elements necessary, or can some queries be eliminated or optimized?
    - Are **bulk updates** handled efficiently (e.g., using **record collections**)?

---

4. **Automation and Process Logic:**
    
    - Are **validation rules**, **triggers**, or other automation potentially conflicting?
    - Is the logic correctly set up to **handle edge cases** (e.g., backdated records, multi-attendance)?
    - Are there any **loops or operations** that might hit **governor limits**?
    - Are the **criteria and conditions** in **decision elements** clearly defined?

---

5. **Error Handling and Fault Paths:**
    
    - Does the flow have **fault handling** to manage errors during execution?
    - Are **notifications** or **logs** configured to inform admins of failures?
    - What happens if the flow fails mid-execution?

---

6. **Performance and Scalability:**
    
    - Does the solution consider **bulk data processing** if needed?
    - Are **indexed fields** being used for large datasets?
    - Will the flow scale well with **increasing data volume** or **parallel updates**?

---

7. **Documentation and Maintenance:**
    
    - Is the **flow documentation clear** about what the flow does and when it runs?
    - Are there **clear instructions** for maintaining or updating the flow if the data model changes?
    - Are there **notes or comments** within the flow explaining critical logic?

---

8. **Recommended Action:**
    
    - What improvements can be made to **enhance efficiency**, **data accuracy**, or **scalability**?
    - Can any steps be **merged or simplified**?
    - Are there any **best practices** that should be applied (e.g., using **formulas over lookups** when possible)?
    - What **test scenarios** should be conducted to validate the fix or improvement?

---

### **Usage Example:**

- **When auditing a data model or flow,** start by identifying the problem, listing the involved fields, and assessing the architecture.
- **For debugging,** follow the same structure, but pay extra attention to **flow logic and error handling.**
- **Use this prompt as a checklist** during the initial analysis phase and when writing documentation or making improvements.