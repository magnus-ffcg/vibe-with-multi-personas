# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2024-12-19

### Added
- **Multi-IDE Support**: Full support for both Windsurf Cascade and Cursor IDE
- **Windsurf Cascade Features**: 
  - AI pair programming integration with Cascade context
  - Windsurf-specific workflow optimizations
  - Enhanced code review capabilities with AI assistance
- **Cursor IDE Features**:
  - AI code completion integration
  - Cursor-specific workflow adaptations
  - Enhanced debugging and refactoring support
- **IDE Detection**: Automatic IDE environment detection in bootstrap script
- **Multi-IDE Installation**: Support for `./install.sh windsurf` and `./install.sh cursor`
- **Comprehensive Testing**: 7-scenario test suite with 100% pass rate
- **Updated Documentation**: Multi-IDE installation instructions and feature comparisons
- Strict role enforcement between ARCHITECT and CODER personas
- Mandatory hand-off flow from ARCHITECT to CODER
- Workflow validation checklist for persona compliance
- ADR-005 documenting strict role enforcement decision

### Changed
- Project title updated to "Multi-Persona Development Bootstrap Template"
- Bootstrap script supports IDE parameter and auto-detection
- README.md includes multi-IDE installation instructions and IDE-specific features
- Template structure supports both Windsurf and Cursor configurations
- ARCHITECT persona explicitly restricted from code edits and implementation tools
- CODER persona has exclusive authority for all code modifications
- Enhanced personas.md and workflow.md with enforcement rules
- Updated terminology from "mob programming" to "multi-persona development"
- Separated workflow documentation into .workflow/docs/ directory
- Improved bootstrap process with clean template copying
- Enhanced personas.md with explicit ARCHITECT restrictions and CODER exclusive authority
- Updated workflow.md with mandatory hand-off requirements

### Fixed
- Updated terminology from "mob programming" to "multi-persona development" throughout project
- Bootstrap script git commit message uses correct terminology
- All documentation files updated with new terminology
- Documentation structure conflicts between workflow and project docs
- Bootstrap script reliability and error handling
- Role boundary violations where ARCHITECT performed implementation work
- Missing enforcement mechanisms for proper persona separation
- Broken references to deleted workflow files in README
- Inconsistent documentation organization
- Missing architectural decision documentation
- **Template Directory Access**: Resolved critical access restrictions for hidden directories
  - Renamed `template/.workflow/` → `template/workflow/`
  - Renamed `template/.windsurf/` → `template/windsurf/`
  - Renamed `template/.cursor/` → `template/cursor/`
- **Bootstrap Script**: Enhanced directory mapping for proper installation as hidden directories
- **File Customization**: Improved error handling for read-only files during project setup
- **Permission Errors**: Eliminated permission denied errors during bootstrap process

### Infrastructure
- **Git Repository**: Added version control to project for improved collaboration and change tracking

## Template for New Entries

```markdown
## [Version] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes
```

---

*This file is maintained by the [CODER] persona*
