---
title: "Nonprofit Membership Tracking - Changelog"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Design"
status: "Active"
version: "1.0"
created: "2025-04-07"
updated: "2025-04-09"
author: "Documentation Team"
---

# Changelog

This file documents all notable changes to the Nonprofit Membership Tracking project documentation.

## 2025-04-09

### (AI) Added
- Created Apex service layer design document `Apex/NMT-Event_Registration_Apex_Service_Design.md`.
- Created Apex validation layer design document `Apex/NMT-Event_Registration_Validator_Design.md`.

### (AI) Updated
- Updated `Docs/NMT-Data_Model_Design_Consolidated.md` (v1.2) to reflect revised `Member Event Participation` structure (Contact required, Membership/Account optional) based on data model audit.
- Updated `Flows/NMT-Event_Participation_Flow_Design.md` with deprecation notice, pointing to modular flow plan and locked version.

### (Human) Added
- Created `Apex/` directory for service layer code.
- Created locked versions of original designs: `Docs/NMT-Data_Model_Design_Consolidated_v_1_locked.md` and `Flows/NMT-Event_Participation_Flow_Design_v_1_locked.md`.

### (Human) Updated
- Updated `WORKSPACE_FILES/Progress.md` with notes from 2025-04-04.
- Enhanced `Docs/NMT-Data_Model_Design_Consolidated.md` with formula field implementation details:
  - Added workaround for Boolean formulas: using ISPICKVAL instead of = for picklist comparisons
  - Added guidance on using TEXT function for text output from picklist fields
  - Documented specific formula for Contact custom field 'Membership Since': `npt_Current_Membership__r.Member_Since__c`
  - Added membership status formula implementation for Account object

### (Human) Fixed
- Identified and documented data model implementation challenges in `Docs/NMT-Data_Model_Design_Consolidated.md`:
  - Documented pending solutions for Account fields: 'Last Event Attended' and 'Total Events Attended'
  - Documented pending solution for 'Member Contacts' Rollup Summary in Account
- Updated Progress.md with current implementation status and notes

## 2025-04-08

### (AI) Added
- Created comprehensive documentation style guide at `Docs/NMT-Documentation_Style_Guide.md` with:
  - Writing style standards (tone, voice, terminology)
  - Formatting rules for common elements
  - Visual design recommendations for diagrams
  - Naming conventions for files and references
  - Document quality checklist

### (AI) Updated
- Enhanced Data Model Template with Salesforce-specific configuration options:
  - Added fields for Allow Reports, Allow Activities, and Track Field History settings
  - Added detailed guidance on when to enable/disable each option
  - Included best practices for field history tracking
- Updated CHANGELOG.md to track all recent documentation activities
- Updated frontmatter in CHANGELOG.md to reflect the latest update date
- Updated todo.md to reflect completed tasks
- Continued maintenance of documentation standards across the project

## 2025-04-07

### (AI) Added
- Created root project `README.md` file with a comprehensive overview of the project structure and implementation timeline
- Created consolidated data model document at `Docs/NMT-Data_Model_Design_Consolidated.md`
- Created test cases for Payment Status Handling Flow at `Tests/NMT-Payment_Status_Handling_Flow_Test_Cases.md`
- Created test cases for Event Participation Flow at `Tests/NMT-Event_Participation_Flow_Test_Cases.md`
- Created Financial Reports specifications document at `Reports/NMT-Financial_Reports_Specs.md`
- Created Engagement Reports specifications document at `Reports/NMT-Engagement_Reports_Specs.md`
- Created this CHANGELOG.md file to track all documentation updates
- Created new prioritized todo.md file with next steps for documentation improvements
- Created Document Structure Standards document at `Docs/NMT-Document_Structure_Standards.md` with formatting guidelines
- Created Templates directory at `Docs/Templates/` with:
  - Data Model Template for standardized object documentation
  - Flow Design Template for consistent process documentation
  - Test Case Template with standardized test structure
  - Report/Dashboard Template for analytics documentation
  - README file explaining template usage

### (AI) Updated
- Updated and completed Event Participation Flow design document at `Flows/NMT-Event_Participation_Flow_Design.md`
- Updated `Tests/README.md` to include references to new test case documents
- Updated `Reports/README.md` to include references to new report specification documents
- Added deprecation notices to original data model documents
- Updated all references to data model documentation across the project to point to the consolidated document
- Updated `Docs/README.md` to reflect consolidated data model documentation
- Enhanced `Docs/NMT-Data_Model_Design_Consolidated.md` with merged validation rules and implementation notes from both original documents
- Updated todo.md to reflect completed tasks and define new priorities
- Enhanced `Reports/NMT-Dashboard_Design.md` with detailed component specifications from `Docs/NMT-Dashboard_Component_Specs.md`

### (AI) Fixed
- Fixed inconsistent naming conventions in documentation references
- Standardized formatting across all newly created documents
- Fixed outdated data model references in flow and test documentation
- Resolved duplication between dashboard documentation in different directories

## 2025-04-06

### (AI) Added
- Created initial directory README files for Docs, Flows, Tests, and Reports directories
- Created Membership Renewal Flow design document at `Flows/NMT-Membership_Renewal_Flow_Design.md`
- Added AI User Guide for Project Workspaces at `AI_ASSISTANT_GUIDE_FOR_PROJECT_WORKSPACES.md`

### (AI) Updated
- Updated the todo.md file with comprehensive documentation tasks
- Updated document frontmatter to follow standardized format

## 2025-04-05

### (AI) Added
- Initial project documentation setup
- Created basic data model documentation
- Created initial flow documentation structure

## 2025-04-03

### (Human) Updated
- Updated `Docs/NMT-Data_Model_Design_Consolidated.md`: Changed data types for Account fields: 'Last Event Attended' from Formula(Date) to Date, and 'Events Attended (YTD)' from Roll-Up Summary to Number.
- Updated `Docs/NMT-Data_Model_Design_Consolidated.md`: Added 'Contact' lookup field to the 'Member Event Participation' custom object.
- Updated `WORKSPACE_FILES/Progress.md`: Documented decision to halt and refactor the Event Participation Flow into smaller, modular flows (re-development noted).
- Updated `WORKSPACE_FILES/Progress.md`: Noted investigation into using NPSP Affiliations as a potential solution for the 'Member Contacts' Rollup Summary on the Account object (TBI).

## How to Use This Changelog

- Entries are listed in reverse-chronological order (newest at the top)
- Each entry should be labelled either as (AI) or (Human)
- Each entry should include one of the following categories:
  - **Added**: For new features or documents
  - **Updated**: For changes to existing documents
  - **Fixed**: For any bug or inconsistency fixes
  - **Removed**: For removed documents or features
  - **Security**: For security-related changes
- Each item should link to affected files where applicable
- Significant changes should include a brief description of the change 