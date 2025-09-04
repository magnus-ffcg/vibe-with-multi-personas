# Project Backlog: Windsurf Cascade Bootstrap Template

This document## Backlog

Tasks are prioritized and managed here. Each task includes acceptance criteria and current status.

### TASK-013: Add Cursor IDE Support Alongside Windsurf Cascade
**Priority**: High  
**Status**: In Progress  
**Assigned**: ARCHITECT → CODER  
**Description**: Extend the multi-persona development template to support both Windsurf Cascade and Cursor IDE, recognizing their differences while maintaining workflow consistency.

**Acceptance Criteria**:
- [ ] Research Cursor IDE specific features and differences from Windsurf
- [ ] Design multi-IDE architecture that supports both environments
- [ ] Create IDE-specific configuration files (.cursor/ and .windsurf/)
- [ ] Update documentation to be IDE-agnostic where possible
- [ ] Add IDE detection and setup in bootstrap script
- [ ] Create Cursor-specific workflow adaptations
- [ ] Update README with multi-IDE installation instructions
- [ ] Ensure template works seamlessly in both IDEs
- [ ] Document IDE-specific features and limitations
- [ ] Create ADR for multi-IDE architecture decision

### High Priority

#### TASK-001: Document Architectural Decisions in ADRs 
#### TASK-001: Document Architectural Decisions in ADRs ✅ COMPLETE
**Priority**: High
**Estimate**: 2 hours
**Acceptance Criteria**:
- [x] Create ADR-002 for repository structure improvements
- [x] Create ADR-003 for self-referential workflow adoption
- [x] Update existing ADR-001 if needed
- [x] All major design decisions documented

**Description**: Document all architectural decisions made during template development to demonstrate proper ADR usage and provide rationale for design choices.

**Dependencies**: None

**Notes**: This demonstrates proper ADR usage for template users

---

#### TASK-002: Update Project Documentation to Follow Own Workflow ✅ COMPLETE
**Priority**: High  
**Estimate**: 3 hours
**Acceptance Criteria**:
- [x] Update changelog.md with all changes made
- [x] Create proper hand-off entries in hand-offs.md
- [x] Update dependencies.md with actual template dependencies
- [x] Update glossary.md with template-specific terms

**Description**: Make this project follow its own mob programming workflow by properly maintaining all documentation as defined in the workflow.

**Dependencies**: None

**Notes**: Critical for dogfooding credibility

### Medium Priority

#### TASK-003: Create Bootstrap Automation Script
**Priority**: Medium
**Estimate**: 4 hours
**Acceptance Criteria**:
- [ ] Shell script that copies template to new project
- [ ] Handles git initialization properly
- [ ] Prompts for project-specific customizations
- [ ] Includes error handling and validation

**Description**: Automate the bootstrap process to make it even easier for users to adopt the template.

**Dependencies**: Core template must be complete

**Notes**: Nice-to-have enhancement for user experience

### High Priority

#### TASK-005: Enable GitHub Repository Installation
**Priority**: High
**Estimate**: 3 hours
**Acceptance Criteria**:
- [ ] Install script that works with GitHub repository URLs
- [ ] Support for both public and private repositories
- [ ] Automatic cloning and bootstrap execution
- [ ] Error handling for network issues and invalid URLs
- [ ] Documentation for GitHub installation method

**Description**: Allow users to install the template directly from a GitHub repository URL, making it easily distributable and installable.

**Dependencies**: TASK-003 (Bootstrap script) must be complete

**Notes**: Stakeholder requested feature for improved distribution

#### TASK-011: Update Terminology from Mob Programming to Multi-Persona Development
**Priority**: High
**Estimate**: 2-3 hours
**Acceptance Criteria**:
- [ ] Replace "mob programming" with "multi-persona development" across all files
- [ ] Replace "mob" with "multi-persona" where contextually appropriate
- [ ] Update file names containing "mob" (e.g., 001-mob-programming-workflow.md)
- [ ] Update README.md and all documentation references
- [ ] Update bootstrap.sh and install.sh script comments and outputs
- [ ] Update template files to reflect new terminology
- [ ] Ensure terminology is consistent across all personas documentation
- [ ] Update ADRs to reflect terminology change decision

**Description**: The current "mob programming" terminology doesn't accurately reflect our multi-persona development approach. Need to update all references to use "multi-persona development" for better accuracy and clarity.

**Dependencies**: None

**Notes**: Stakeholder feedback - terminology should reflect actual development approach

#### TASK-009: Remove Duplicate Planning Documents
**Priority**: High
**Estimate**: 1-2 hours
**Acceptance Criteria**:
- [ ] Remove docs/todo.md (duplicate planning document)
- [ ] Consolidate any useful content into .workflow/docs/plan.md
- [ ] Ensure only one planning document exists (plan.md)
- [ ] Update any references to todo.md
- [ ] Verify no functionality is lost

**Description**: Currently have both todo.md and plan.md serving as planning documents. Need single source of truth for project planning in plan.md only.

**Dependencies**: None

**Notes**: Stakeholder feedback - can only have one planning document

#### TASK-010: Create Clean Template Directory Structure
**Priority**: High
**Estimate**: 3-4 hours
**Acceptance Criteria**:
- [ ] Analyze current bootstrap copying behavior
- [ ] Design template/ directory with clean installable files
- [ ] Identify files that should be template vs preserved
- [ ] Separate development files from template files
- [ ] Update bootstrap.sh to copy from template/ directory
- [ ] Ensure clean installation without existing project artifacts

**Description**: Current bootstrap copies all files including development artifacts. Need clean template directory containing only files that should be installed in new projects.

**Dependencies**: TASK-009 (planning document cleanup)

**Notes**: Stakeholder feedback - installation should be clean, not copy existing files

#### TASK-008: Improve Persona Workflow Adherence
**Priority**: High
**Estimate**: 2-3 hours
**Acceptance Criteria**:
- [ ] Analyze current persona boundary violations in workflow
- [ ] Document specific cases where personas step outside their roles
- [ ] Create guidelines for proper persona hand-offs
- [ ] Update workflow documentation with clearer boundaries
- [ ] Add persona violation detection to review checklist
- [ ] Test improved workflow with proper persona transitions

**Description**: Current workflow has instances where personas perform work outside their defined roles (e.g., ARCHITECT doing testing work instead of handing off to TESTER). Need to improve adherence to persona boundaries and hand-off protocols.

**Dependencies**: None

**Notes**: Critical for maintaining workflow integrity and demonstrating proper mob programming practices

#### TASK-006: Resolve Documentation Structure Conflicts
**Priority**: High
**Estimate**: 3-4 hours
**Acceptance Criteria**:
- [ ] Analyze current docs/ directory structure conflicts
- [ ] Design separation between workflow docs and project docs
- [ ] Implement new directory structure (.workflow/ recommended)
- [ ] Update all references in scripts and documentation
- [ ] Update bootstrap.sh to handle new structure
- [ ] Create migration guide for existing projects
- [ ] Test bootstrap process with new structure

**Description**: The current docs/ directory mixes template workflow documentation with user project documentation, creating namespace conflicts when users bootstrap projects. Need architectural separation.

**Dependencies**: None (but affects all existing documentation)

**Notes**: Critical architectural issue that affects template usability and maintainability

### Low Priority

#### TASK-004: Create Template Examples Directory
**Priority**: Low
**Estimate**: 2-3 hours
**Acceptance Criteria**:
- [ ] Create examples/ directory with sample project templates
- [ ] Include basic Python project structure example
- [ ] Include web application project structure example
- [ ] Add documentation for using examples
- [ ] Update bootstrap script to optionally use examples

**Description**: Create a collection of example project structures that users can choose from when bootstrapping new projects. This will provide starting points for common project types.

**Dependencies**: TASK-006 (documentation structure must be resolved first)

**Notes**: This is a nice-to-have feature that can enhance user experience but is not critical for core functionality.

## Task Template

When adding new tasks, use this format:

```markdown
### [TASK-ID] Task Title
**Priority**: High/Medium/Low
**Estimate**: [Time estimate]
**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Description**: Detailed description of what needs to be done

**Dependencies**: List any dependencies on other tasks

**Notes**: Any additional context or considerations
```

## Completed Tasks

*Completed tasks are moved to /docs/release-notes.md*

---

*This file is maintained by the [ARCHITECT] persona*
