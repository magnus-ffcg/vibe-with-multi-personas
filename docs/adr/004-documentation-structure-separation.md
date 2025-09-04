# ADR-004: Documentation Structure Separation

## Status
Proposed

## Context
The current `docs/` directory contains two distinct types of documentation that serve different purposes:

1. **Template Workflow Documentation**: Files that manage the mob programming workflow process
   - `personas.md`, `workflow.md`, `hand-offs.md`
   - `backlog.md`, `release-notes.md`, `review-checklist.md`
   - `test-plan.md`, `test-report.md`

2. **Project Documentation**: Files that contain user project-specific content
   - `changelog.md` (project changes)
   - `dependencies.md` (project dependencies)
   - `adr/` (project architectural decisions)

**Note**: Upon further analysis, `plan.md` is actually template workflow documentation (maintained by [ARCHITECT] persona) and should be moved to workflow documentation.

This mixed structure creates namespace conflicts when users bootstrap new projects, as they typically want their own `docs/` directory for project documentation.

## Problem
- **Namespace Collision**: Users cannot create their own `docs/` folder without conflicts
- **Separation of Concerns**: Workflow management files serve different purposes than project docs
- **Template Maintenance**: Mixed documentation makes it harder to maintain template workflow independently
- **User Confusion**: Users may accidentally modify workflow files thinking they're project docs

## Decision
Separate workflow documentation from project documentation by moving workflow files to a dedicated `.workflow/` directory structure:

```
.workflow/
├── docs/
│   ├── personas.md
│   ├── workflow.md
│   ├── hand-offs.md
│   ├── backlog.md
│   ├── release-notes.md
│   ├── review-checklist.md
│   ├── test-plan.md
│   ├── test-report.md
│   └── plan.md           # Template workflow planning
└── templates/
    └── (future template files)

docs/  # Clean for user project documentation
├── changelog.md
├── dependencies.md
└── adr/
```

## Alternatives Considered

### Option A: `.workflow/docs/` (Chosen)
- **Pros**: Clear semantic separation, extensible structure, follows dot-directory conventions
- **Cons**: Requires updating many file references

### Option B: `.mob/` flat structure
- **Pros**: Shorter paths, simpler structure
- **Cons**: Less extensible, doesn't clearly separate different types of workflow files

### Option C: `workflow/` (no dot prefix)
- **Pros**: More visible to users
- **Cons**: Takes up top-level namespace, conflicts with potential user directories

## Consequences

### Positive
- Eliminates namespace conflicts for user projects
- Clear architectural separation between workflow and project concerns
- Template workflow can be maintained independently
- Extensible structure for future workflow enhancements
- Follows established conventions for tooling directories

### Negative
- Requires updating 17+ files with `docs/` references
- Breaking change for existing template users
- Bootstrap script needs modification
- All personas need to update their documentation paths

### Migration Impact
- Update all scripts (`bootstrap.sh`, `install.sh`, test files)
- Update all documentation cross-references
- Update `.windsurf/rules/` files to reference new paths
- Create migration guide for existing projects
- Test entire bootstrap process with new structure

## Implementation Plan
1. Create new `.workflow/docs/` directory structure
2. Move workflow-related files from `docs/` to `.workflow/docs/`
3. Update all file references in scripts and documentation
4. Update bootstrap script to handle new structure
5. Test bootstrap process thoroughly
6. Create migration documentation

## Notes
This decision supports the template's goal of being a best-in-class mob programming workflow tool while ensuring it doesn't interfere with user project documentation needs.
