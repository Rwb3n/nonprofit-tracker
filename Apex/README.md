---
title: "Nonprofit Membership Tracking - Apex Directory"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Implementation"
status: "Active"
version: "1.0"
created: "2025-04-08" # Assuming today's date for creation
updated: "2025-04-08" # Assuming today's date for update
author: "Documentation Team"
---

# Nonprofit Membership Tracking - Apex Directory

## Purpose

This directory contains Apex code and associated design documentation developed for the Nonprofit Membership Tracking project. Apex classes handle complex business logic, custom calculations, and integrations that cannot be achieved through standard Salesforce configuration or Flows alone.

## Document Index

### Design Documents

| Document | Description |
|----------|-------------|
| [NMT-Event_Registration_Validator_Design.md](NMT-Event_Registration_Validator_Design.md) | Design specification for the Apex logic responsible for validating event registration data before processing. |
| [NMT-Event_Registration_Apex_Service_Design.md](NMT-Event_Registration_Apex_Service_Design.md) | Design specification for the Apex service layer handling event registration processing, including interactions with other objects and systems. |

### Apex Code

| File | Description |
|------|-------------|
| [EventRegistrationProcessor.cls](EventRegistrationProcessor.cls) | Core Apex class containing the main business logic for processing event registrations. |
| [EventRegistrationService.cls](EventRegistrationService.cls) | Service class providing methods to be called by Flows or other components to initiate event registration processing. |
| [EventRegistrationWrappers.cls](EventRegistrationWrappers.cls) | Contains wrapper classes used to structure data passed between Flows and Apex, or within Apex methods. |

## Code Structure

The Apex code in this directory generally follows a service layer pattern:
- **Service Classes (`*Service.cls`)**: Expose methods callable from outside Apex (e.g., Flows, LWC). They handle input/output and orchestrate calls to processor classes.
- **Processor Classes (`*Processor.cls`)**: Contain the core business logic, calculations, and data manipulation logic.
- **Wrapper Classes (`*Wrappers.cls`)**: Define custom data structures to pass complex information between components or methods.

## Usage

The Apex code is typically invoked by:
- Salesforce Flows (e.g., `NMT-Event_Participation_Flow_Design.md`)
- Lightning Web Components (LWCs)
- Other Apex triggers or classes

Refer to the specific design documents for detailed invocation patterns.

## Document Standards

All documentation follows the standards outlined in:
- [NMT-Document_Structure_Standards.md](../Docs/Standards/NMT-Document_Structure_Standards.md)
- [NMT-Documentation_Style_Guide.md](../Docs/Standards/NMT-Documentation_Style_Guide.md)

## Related Documents

- **Flow Designs**: Located in the [Flows directory](../Flows/) (e.g., `NMT-Event_Participation_Flow_Design.md` which might utilize these Apex classes)
- **Data Model**: [NMT-Data_Model_Design_Consolidated.md](../Docs/NMT-Data_Model_Design_Consolidated.md)
- **Apex Testing**: Test classes are typically located alongside their corresponding Apex classes or in a dedicated test directory (structure TBD). 