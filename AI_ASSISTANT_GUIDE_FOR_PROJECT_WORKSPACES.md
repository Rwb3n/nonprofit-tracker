---
title: "Nonprofit Membership Tracking - AI User Guide for Project Workspaces"
project: "Nonprofit Membership Tracking"
type: "Documentation"
phase: "Implementation"
status: "Active"
version: "1.0"
created: "2025-04-06" 
updated: "2025-04-07"
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

2. **Progress Tracker (Human Responsibility):**  
   - **Progress.md** is the HUMAN TEAM'S responsibility to maintain as the single source of truth for overall project status.
   - The AI assistant should only consult this file for reference but NOT modify it directly.
   - The human team uses Progress.md to track:
     - Overall project milestone status
     - Implementation status of build and configuration tasks
     - Testing and deployment progress
     - Resource allocation and timeline adjustments
   - Example structure:  
     ```markdown
     ## Progress Tracker - Nonprofit Membership Tracking

     ### Planning & Analysis 
     - [x] Initial project scope definition (Completed)
     - [x] Requirements gathering (Completed)

     ### Design 
     - [x] Data model design (Completed)
     - [x] Workflow design (Completed)

     ### Build & Configuration (Human Team Responsibility)
     - [ ] Custom object creation (In Progress - 50%)
     - [ ] Flow implementation (Not Started)

     ### Testing (Human Team Responsibility)
     - [ ] Unit testing (Not Started)
     - [ ] User acceptance testing (Not Started)
     ```
   - The AI should NEVER mark any tasks as complete in the Progress.md file.

3. **Todo File (AI Assistant's Responsibility):**
   - **todo.md** is the AI ASSISTANT'S responsibility - it is the AI's personal task tracker.
   - The AI **MUST ALWAYS** maintain a detailed **todo.md** file for tracking its own documentation tasks.
   - This file tracks ONLY the AI assistant's documentation, planning, and design responsibilities.
   - The todo.md file should be updated at the beginning and end of each work session.
   - Structure the todo file with clear sections:
     ```markdown
     # AI Documentation Todo List
     
     ## Priority Tasks (Next Actions)
     - [ ] Update data model documentation with new fields
     - [ ] Create test case template
     
     ## In Progress
     - [ ] Flow documentation consolidation (40% complete)
     - [ ] Dashboard documentation standardization (20% complete)
     
     ## Completed Today (2025-04-07)
     - [x] Created directory README files
     - [x] Updated consistency report
     
     ## Previously Completed
     - [x] Standardized frontmatter across all documents (2025-04-06)
     - [x] Created initial flow documentation (2025-04-05)
     ```
   - If the human needs the AI to work on specific documentation tasks, these should be reflected in the todo.md file.

4. **Todo Scope Management:**
   - **Scope Freezing Rule**: Once work has begun on a todo item, NO ADDITIONAL SCOPE may be added to that specific task.
   - When a task is in progress, maintain its original scope boundaries exactly as defined.
   - If additional related work is identified during task execution:
     - DO NOT expand the current task
     - DO NOT create subtasks that weren't in the original scope
     - INSTEAD, add these to a dedicated "Future Recommendations" section in todo.md
   - Example structure for capturing scope expansion ideas:
     ```markdown
     ## Future Recommendations
     - [ ] Consider adding a troubleshooting section to the Data Model document 
     - [ ] Create additional validation test cases for the Renewal Flow
     - [ ] Enhance the Dashboard template with mobile-specific layout guidance
     ```
   - This approach ensures:
     - Tasks remain focused and bounded
     - Work can be completed in reasonable timeframes
     - Scope creep is prevented
     - New ideas are still captured for future prioritization

5. **Responsibility Separation:**
   - **AI Assistant**: Responsible for todo.md and all documentation creation/maintenance
   - **Human Team**: Responsible for Progress.md and all implementation work
   - The AI should recommend documentation updates to the human but should not indicate these are complete in Progress.md
   - The human will review the AI's documentation work and update Progress.md accordingly

6. **Verification Process:**
   - **ALWAYS** double-check work before marking as complete in todo.md:
     1. Verify frontmatter is complete and accurate
     2. Confirm all cross-references and links work
     3. Check for consistency with existing documentation standards
     4. Validate that all required sections are present
     5. Update todo.md to reflect completed work
     6. Notify the human of completed documentation tasks so they can update Progress.md if appropriate

7. **Modular Documentation Structure:**  
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
             ├─ Progress.md   # Overall progress tracking (HUMAN MAINTAINED)
             ├─ todo.md       # Documentation task tracking (AI MAINTAINED)
             └─ README.md     # Project overview
     ```  

8. **Documentation Standards:**
   - Create and maintain README.md files in each directory explaining its purpose
   - Structure all design documents consistently with:
     - Overview section
     - Detailed specifications
     - Implementation considerations
     - Related documentation references
   - Include cross-references between related documents
   - Maintain consistent formatting for similar content types

9. **Deprecation Process:**
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

10. **Changelog Maintenance:**
   - The **CHANGELOG.md** file in the root directory serves as the central record of all documentation changes.
   - This file must be updated at the end of each work session to record all documentation activities.
   - Follow the established format:
     ```markdown
     ## YYYY-MM-DD (Date of changes)
     
     ### Added
     - New documents or features added
     
     ### Updated
     - Changes to existing documents
     
     ### Fixed
     - Bug fixes or corrections
     
     ### Removed
     - Deprecated or removed content
     ```
   - Each entry should include links to affected files where applicable.
   - The CHANGELOG.md file helps track progress, provides context for changes, and serves as a historical record.

This workspace organization ensures clear separation of responsibilities and maintains high documentation quality and consistency across the project.