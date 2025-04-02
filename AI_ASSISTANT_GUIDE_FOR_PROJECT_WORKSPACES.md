---
title: "Nonprofit Membership Tracking - AI User Guide for Project Workspaces"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Implementation"
status: "Active"
version: "1.0"
created: "2025-04-06" 
updated: "2025-04-06"
author: "Documentation Team"
---

# AI User Guide for Project Workspaces

## Scope of AI Responsibilities

The AI assistant is **ONLY** responsible for:
- Planning & Analysis documentation
- Design documentation
- Documentation creation, standardization, and consistency

The AI assistant is **NOT** responsible for:
- Build & Configuration implementation
- Testing execution
- Deployment activities

## General Workspace Tips

1. **Lean Frontmatter for Each Document:**  
   - Each Markdown document should start with a **frontmatter block** to ensure quick navigation and context.  
   - Example:  
     ```markdown
     ---
     title: "Nonprofit Membership Tracking - [Document Title]"
     project: "Nonprofit Membership Tracking"
     type: [Documentation|Flow|Test|Report]
     phase: [Planning|Design|Build|Testing|Implementation]
     status: [Draft|In Progress|Review|Completed]
     version: "1.0"
     created: YYYY-MM-DD
     updated: YYYY-MM-DD
     author: "[Author Name]"
     ---
     ```
   - This structure keeps each document **self-descriptive** and easily searchable.
   - Always update the `updated` field when making changes to a document.

2. **Progress Tracker Board:**  
   - Maintain the **Progress.md** file as a single source of truth for project status.
   - Only mark tasks as complete in the Planning & Analysis, Design, and Documentation sections.
   - Leave Build & Configuration, Testing, and Deployment task statuses for the human team members to update.
   - Example:  
     ```markdown
     ## Progress Tracker - Nonprofit Membership Tracking

     ### Planning & Analysis (AI Responsibility)
     - [x] Initial project scope definition (Completed)
     - [x] Requirements gathering (Completed)

     ### Design (AI Responsibility)
     - [x] Data model design (Completed)
     - [x] Workflow design (Completed)

     ### Documentation (AI Responsibility)
     - [x] Project plan documentation (Completed)
     - [ ] Test case documentation (In Progress)

     ### Build & Configuration (Human Team Responsibility)
     - [ ] Custom object creation (Not Started)
     - [ ] Flow implementation (Not Started)
     ```
   - Update the **Progress.md** file after completing any documentation tasks.

3. **Required Todo File:**
   - **ALWAYS** maintain a detailed **todo.md** file for each project.
   - Structure the todo file with clear sections for immediate tasks, in-progress work, and completed items.
   - Example:
     ```markdown
     # Documentation Todo List
     
     ## Priority Tasks (Next Actions)
     - [ ] Update data model documentation with new fields
     - [ ] Create test case template
     
     ## In Progress
     - [ ] Flow documentation consolidation (40% complete)
     - [ ] Dashboard documentation standardization (20% complete)
     
     ## Completed Today
     - [x] Created directory README files (4/6/2025)
     - [x] Updated consistency report (4/6/2025)
     ```
   - Update the todo.md file at the beginning and end of each work session.

4. **Verification Process:**
   - **ALWAYS** double-check work before marking as complete:
     1. Verify frontmatter is complete and accurate
     2. Confirm all cross-references and links work
     3. Check for consistency with existing documentation standards
     4. Validate that all required sections are present
     5. Update todo.md to reflect completed work
     6. Update Progress.md for completed Planning, Design, or Documentation tasks

5. **Modular Documentation Structure:**  
   - Follow the established folder structure for each project with subfolders for **Docs, Flows, Tests, Reports**.  
   - Prefix each document with the project code (e.g., **NMT-** for Nonprofit Membership Tracking).
   - Example Folder Structure:  
     ```
     Projects/
       └─ Nonprofit Membership Tracking/
             ├─ Docs/         # Technical specifications and design documents
             ├─ Flows/        # Flow design specifications
             ├─ Tests/        # Test cases and validation procedures
             ├─ Reports/      # Dashboard and report specifications
             ├─ Progress.md   # Overall progress tracking
             ├─ todo.md       # Documentation task tracking
             └─ README.md     # Project overview
     ```  

6. **Documentation Standards:**
   - Create and maintain README.md files in each directory explaining its purpose
   - Structure all design documents consistently with:
     - Overview section
     - Detailed specifications
     - Implementation considerations
     - Related documentation references
   - Include cross-references between related documents
   - Maintain consistent formatting for similar content types

7. **Deprecation Process:**
   - When a document is being replaced or consolidated, add a deprecation notice:
     ```markdown
     ---
     title: "DEPRECATED - Previous Document Title"
     ...
     ---
     
     # DEPRECATED
     
     This document has been deprecated and replaced by [New Document Name](path/to/new-document.md).
     Please refer to the new document for the most current information.
     ```

This workspace organization ensures clear separation of responsibilities and maintains high documentation quality and consistency across the project.