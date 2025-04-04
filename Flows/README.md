---
title: "Nonprofit Membership Tracking - Flows Directory"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Implementation"
status: "Active"
version: "1.0"
created: "2025-04-05"
updated: "2025-04-08"
author: "Documentation Team"
---

# Nonprofit Membership Tracking - Flows Directory

## Purpose

This directory contains all Flow design documentation for the Nonprofit Membership Tracking project. Flow designs specify the automation processes that handle membership-related operations, including onboarding, renewal, payment handling, and event participation.

## Document Index

### Active Documents

| Document | Description |
|----------|-------------|
| [NMT-Membership_Onboarding_Flow_Design.md](NMT-Membership_Onboarding_Flow_Design.md) | Comprehensive design specification for the membership onboarding process flow, detailing the steps for handling both individual and organizational memberships. |
| [NMT-Membership_Renewal_Flow_Design.md](NMT-Membership_Renewal_Flow_Design.md) | Design specification for the automated membership renewal process, including notification scheduling, renewal options presentation, and status updates. |
| [NMT-Payment_Status_Handling_Flow_Design.md](NMT-Payment_Status_Handling_Flow_Design.md) | Design documentation for the payment status monitoring and updating flow, including handling of successful, failed, and pending payments. |
| [NMT-Event_Participation_Flow_Design.md](NMT-Event_Participation_Flow_Design.md) | Design specification for the event registration and participation tracking process, including registration handling, payment processing (potentially invoking Apex), and engagement metrics updates. |

### Deprecated Documents

| Document | Status | Reason | Replacement |
|----------|--------|--------|-------------|
| [NMT-Membership_Onboarding_Flow.md](NMT-Membership_Onboarding_Flow.md) | **DEPRECATED** | Superseded by newer design | [NMT-Membership_Onboarding_Flow_Design.md](NMT-Membership_Onboarding_Flow_Design.md) |

## Flow Structure

Each flow design document follows a consistent structure as defined in the [Document Structure Standards](../Docs/Standards/NMT-Document_Structure_Standards.md):

1. **Overview**
2. **Flow Metadata** (e.g., Type, Trigger)
3. **Flow Diagram** (using Mermaid syntax)
4. **Flow Elements in Detail** (Input Variables, Decision Logic, Operations)
5. **Decision Points and Formulas**
6. **Error Handling**
7. **Testing Considerations**
8. **Related Documents**

## Flow Types

The Nonprofit Membership Tracking system utilizes several types of Salesforce Flows:

1. **Record-Triggered Flows**: Execute automatically based on record changes (create, update, delete).
2. **Screen Flows**: Guide users through interactive processes with UI screens.
3. **Scheduled Flows**: Run automatically at predetermined times or intervals.
4. **Platform Event-Triggered Flows**: Triggered by specific Platform Events.
5. **Autolaunched Flows (No Trigger)**: Invoked by other flows, processes, Apex, or APIs.

## Document Standards

All flow design documents adhere to the standards defined in:
- [NMT-Document_Structure_Standards.md](../Docs/Standards/NMT-Document_Structure_Standards.md)
- [NMT-Documentation_Style_Guide.md](../Docs/Standards/NMT-Documentation_Style_Guide.md)

Key standards include:
1. **Consistent Frontmatter**: Standard metadata in YAML format.
2. **Diagrams**: Mermaid syntax for flow visualization.
3. **Implementation Notes**: Clear guidelines for developers.
4. **Version Control**: Proper versioning and tracking via frontmatter and Git.
5. **Cross-References**: Relative links to related documentation (Data Model, Apex, Tests).

## Related Documents

- **Testing**: Test cases for flows are located in the [Tests directory](../Tests/). Example: [Membership Onboarding Flow Test Cases](../Tests/NMT-Membership_Onboarding_Flow_Test_Cases.md)
- **Data Model**: The data structures used by these flows are defined in [NMT-Data_Model_Design_Consolidated.md](../Docs/NMT-Data_Model_Design_Consolidated.md)
- **Apex Code**: Complex logic invoked by flows is documented in the [Apex directory](../Apex/). Example: [Event Registration Service Design](../Apex/NMT-Event_Registration_Apex_Service_Design.md)
- **Reports**: Dashboards displaying flow outcomes are specified in the [Reports directory](../Reports/). Example: [Dashboard Design](../Reports/NMT-Dashboard_Design.md) 