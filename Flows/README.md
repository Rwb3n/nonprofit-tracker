---
title: "Nonprofit Membership Tracking - Flows Directory"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Implementation"
status: "Active"
version: "1.0"
created: "2025-04-05"
updated: "2025-04-06"
author: "Documentation Team"
---

# Nonprofit Membership Tracking - Flows Directory

## Purpose

This directory contains all Flow design documentation for the Nonprofit Membership Tracking project. Flow designs specify the automation processes that handle membership-related operations, including onboarding, renewal, payment handling, and event participation.

## Document Index

### Active Documents

- **[NMT-Membership_Onboarding_Flow_Design.md](NMT-Membership_Onboarding_Flow_Design.md)**: Comprehensive design specification for the membership onboarding process flow, detailing the steps for handling both individual and organizational memberships.

- **[NMT-Membership_Renewal_Flow_Design.md](NMT-Membership_Renewal_Flow_Design.md)**: Design specification for the automated membership renewal process, including notification scheduling, renewal options presentation, and status updates.

- **[NMT-Payment_Status_Handling_Flow_Design.md](NMT-Payment_Status_Handling_Flow_Design.md)**: Design documentation for the payment status monitoring and updating flow, including handling of successful, failed, and pending payments.

- **[NMT-Event_Participation_Flow_Design.md](NMT-Event_Participation_Flow_Design.md)**: Design specification for the event registration and participation tracking process, including registration handling, payment processing, and engagement metrics updates.

### Deprecated Documents

- **[NMT-Membership_Onboarding_Flow.md](NMT-Membership_Onboarding_Flow.md)** (DEPRECATED): Earlier version of the membership onboarding flow documentation. This document is superseded by NMT-Membership_Onboarding_Flow_Design.md.

## Flow Structure

Each flow design document follows a consistent structure:

1. **Overview**: Introduction to the flow's purpose and business objectives
2. **Flow Diagram**: Visual representation of the flow's sequence and decision points
3. **Flow Elements**:
   - Input Variables: Data inputs required by the flow
   - Decision Logic: Branching logic and conditions
   - Operations: Actions performed at each step
4. **Implementation Considerations**: Special considerations, limitations, and best practices
5. **Testing Scenarios**: Key test cases for validating flow functionality
6. **Related Configurations**: Custom metadata, process builders, and permission sets
7. **Future Enhancements**: Planned improvements for future iterations

## Flow Types

The Nonprofit Membership Tracking system uses several types of flows:

1. **Record-Triggered Flows**: Automatically executed when records are created or updated
2. **Screen Flows**: Interactive flows that display screens to users
3. **Scheduled Flows**: Automatically executed at specified times
4. **Platform Event-Triggered Flows**: Execute when specific platform events occur
5. **Autolaunched Flows**: Called by other flows, processes, or code

## Document Standards

All flow design documents adhere to the following standards:

1. **Consistent Frontmatter**: Standard metadata format in YAML frontmatter
2. **Diagrams**: Flow diagrams using consistent notation and conventions
3. **Implementation Notes**: Clear guidelines for developers implementing the flows
4. **Version Control**: Proper versioning and change tracking
5. **Cross-References**: Links to related documentation including data models and test cases

## Related Documents

- **[Membership Onboarding Flow Test Cases](../Tests/NMT-Membership_Onboarding_Flow_Test_Cases.md)**: Validation test cases for the membership onboarding flow
- **[Membership Renewal Flow Test Cases](../Tests/NMT-Membership_Renewal_Flow_Test_Cases.md)**: Validation test cases for the membership renewal flow
- **[Data Model Design](../Docs/NMT-Data_Model_Design.md)**: Specification of data objects used by the flows
- **[Dashboard Design](../Reports/NMT-Dashboard_Design.md)**: Dashboards that display flow outcomes 