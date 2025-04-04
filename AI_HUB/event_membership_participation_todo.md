---
title: "AI Todo - Event Participation Refactoring (2025-04-10)"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Draft"
version: "1.0"
created: "2025-04-09"
updated: "2025-04-09"
author: "AI Assistant"
---

# AI Todo List: Event Participation Refactoring (Effective 2025-04-10)

This todo list outlines the documentation and design tasks specifically related to the refactoring of the Event Participation functionality, following the architectural decisions made on 2025-04-09.

## Priority Tasks (Next Actions)

1.  **[ ] NPSP Integration Analysis:**
    *   **Goal:** Document potential conflicts, overlaps, and considerations when implementing the custom event participation logic alongside NPSP.
    *   **Scope:**
        *   Review NPSP triggers/flows related to Contacts, Accounts, Opportunities (if relevant to payment), and Affiliations.
        *   Analyze interaction with NPSP rollup summaries (e.g., `Member Contacts` TBI on Account).
        *   Consider impact on NPSP data structures (Households, Affiliations).
        *   Propose strategies for coexistence (e.g., using Custom Metadata for configuration, abstraction layers).
        *   Document findings in a new file: `Docs/NMT-NPSP_Integration_Considerations.md`.
    *   **Exclusions:** Does not include implementing solutions, only analysis and documentation.

2.  **[ ] Testing Strategy Definition:**
    *   **Goal:** Outline a high-level testing strategy for the new modular flows and Apex components.
    *   **Scope:**
        *   Define types of tests needed (Apex Unit Tests, Flow Tests, Integration Tests, End-to-End Scenarios).
        *   Identify key integration points to test (Flow -> Validator -> Service; Service -> Triggered Flow for metrics).
        *   Propose approach for testing transactional integrity (Apex tests for rollback).
        *   Suggest methods for testing asynchronous updates (Platform Events mocks, if used).
        *   Document strategy in a new section within `Tests/README.md` or a dedicated file if extensive (`Tests/NMT-Event_Participation_Testing_Strategy.md`).
    *   **Exclusions:** Does not include writing specific test cases.

## In Progress

*   None

## Completed (Session: 2025-04-09)

*   [x] Conducted data model audit for Event Participation (`Member Event Participation` object).
*   [x] Created revised ERD (Mermaid) for Event Participation.
*   [x] Designed Apex transactional service layer (`EventRegistrationService`, `EventRegistrationProcessor`).
*   [x] Created design document: `Apex/NMT-Event_Registration_Apex_Service_Design.md`.
*   [x] Designed Apex validation layer (`EventRegistrationValidator`).
*   [x] Created design document: `Apex/NMT-Event_Registration_Validator_Design.md`.
*   [x] Updated `Docs/NMT-Data_Model_Design_Consolidated.md` with audit findings.
*   [x] Updated `Flows/NMT-Event_Participation_Flow_Design.md` with deprecation notice.
*   [x] Updated `CHANGELOG.md` with session activities.

## Future Recommendations (Generated during this refactoring)

*   [ ] Consider adding bulk validation method to `EventRegistrationValidator` if needed in the future.
*   [ ] Refine `checkEventCapacity` validation logic to better integrate with potential waitlist flow.
*   [ ] Formalize organizational membership linkage checks in `EventRegistrationValidator` (e.g., using Affiliations) once the `Member Contacts` TBI is resolved.
*   [ ] Create individual design documents for each of the 5 modular flows identified in `WORKSPACE_FILES/Standard_Object_Custom_Field_Challenge/4. Modular Flow Redev.md`.

---
*Note: This todo list adheres to the Scope Freezing Rule defined in `AI_ASSISTANT_GUIDE_FOR_PROJECT_WORKSPACES.md`. New scope items identified will be added to Future Recommendations.* 