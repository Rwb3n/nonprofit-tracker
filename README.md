---
title: "Nonprofit Membership Tracking - Project Overview"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Active"
version: "1.0"
created: "2025-04-07"
updated: "2025-04-09"
author: "Documentation Team"
---

# Nonprofit Membership Tracking - Project Overview

## About This Project

The Nonprofit Membership Tracking system is a comprehensive solution designed for nonprofit organizations to manage their membership base effectively. The system streamlines the entire membership lifecycle from onboarding to renewal, handles payments, tracks event participation, and provides detailed analytics through reports and dashboards.

### Key Features

- **Membership Management**: Track individual and organizational memberships with various levels and benefits
- **Renewal Processing**: Automated reminders and streamlined renewal workflows
- **Payment Handling**: Process payments, handle failed transactions, and maintain payment history
- **Event Participation**: Manage event registrations, track attendance, and calculate engagement
- **Engagement Scoring**: Quantify member involvement through a sophisticated scoring system
- **Dashboard Analytics**: Visual representations of membership trends, financial data, and engagement metrics

## Project Structure

This project is organized into several directories containing specific types of documentation and code:

### `/Docs`

Contains the core documentation for the project, including:

- **Data Model Design**: Detailed description of all objects, fields, relationships, and validation rules
- **System Architecture**: Overview of the technical architecture and integration points
- **User Guides**: End-user documentation for system administrators

### `/Flows`

Contains design documents for Salesforce flows that power the application:

- **Membership Onboarding Flow**: Process for creating new memberships
- **Membership Renewal Flow**: Process for renewing existing memberships
- **Payment Status Handling Flow**: Logic for processing payments and handling failures
- **Event Participation Flow**: *DEPRECATED* - See Modular Flow plan in WORKSPACE_FILES and Apex service layer.

### `/Apex`

Contains custom Apex classes supporting the application logic:

- **Service Layer**: Transactional logic (e.g., `EventRegistrationService`).
- **Validation Layer**: Business rule enforcement (e.g., `EventRegistrationValidator`).
- **Wrapper Classes**: Data structures for Apex actions.

### `/Tests`

Contains test case documentation for validating system functionality:

- **Membership Onboarding Flow Test Cases**: Validation scenarios for new member signup
- **Membership Renewal Flow Test Cases**: Validation scenarios for membership renewals
- **Payment Status Handling Flow Test Cases**: Tests for payment processing scenarios
- **Event Participation Flow Test Cases**: Tests for event registration and attendance tracking

### `/Reports`

Contains specifications and designs for reports and dashboards:

- **Dashboard Design**: Layout and components for the main system dashboards
- **Financial Reports Specs**: Detailed requirements for financial reporting
- **Engagement Reports Specs**: Requirements for member engagement reporting

### `/AI_HUB`

Contains AI Assistant specific documentation:

- AI Assistant Prompt: `AI_ASSISTANT_GUIDE_FOR_PROJECT_WORKSPACES`
- `todo.md` files

### `/WORKSPACE_FILES`

Contains Working Files for the Workspace, used primarily for outputs of the 'Human in the Project ':

- `Challenge` Folders
- `Report` Documents
- `Progress.md` File

### Root Directory Files

The root directory contains several important files:

- **README.md**: This file - provides an overview of the project
- **CHANGELOG.md**: Chronological record of all documentation changes and updates
- **Project_Plan.md**:
- **Requirements.md**:

## Getting Started

To understand this project:

1. Start by reviewing the [Data Model Design](./Docs/NMT-Data_Model_Design_Consolidated.md) to understand the underlying data structure.
2. Review the modular flow approach and Apex service design (`/WORKSPACE_FILES` and `/Apex` respectively) for the Event Participation process.
3. Explore the remaining flow designs in the `/Flows` directory for other business processes.
4. Review the dashboard design in `/Reports/NMT-Dashboard_Design.md` to see the analytics capabilities.
5. Check the test cases in `/Tests` to understand how the system is validated.

## Implementation Timeline

| Phase | Description | Status |
|-------|-------------|--------|
| Discovery | Requirements gathering and stakeholder interviews | Completed |
| Design | Data model, flow, and dashboard design | In Progress |
| Development | Building and configuring the solution | Not Started |
| Testing | Validation of functionality | Not Started |
| Deployment | Implementation to production | Not Started |
| Training | User and administrator training | Not Started |
