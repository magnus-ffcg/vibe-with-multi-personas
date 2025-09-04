# ADR-006: Multi-IDE Support Architecture

## Status
Accepted

## Context
The multi-persona development template was initially designed for Windsurf Cascade. User request to support Cursor IDE alongside Windsurf requires architectural changes to accommodate different IDE configurations and workflows while maintaining consistency.

**Key Differences Between IDEs**:
- **Windsurf Cascade**: Uses `.windsurf/` directory, Cascade AI system, specific workflow integration
- **Cursor IDE**: Uses `.cursor/` directory, different AI integration patterns, VS Code-based architecture

**Requirements**:
- Support both IDEs seamlessly
- Maintain workflow consistency across IDEs
- IDE-specific configurations where needed
- Single template that works in both environments

## Decision
Implement a multi-IDE architecture with the following design:

### 1. Dual Configuration Structure
```
project/
├── .windsurf/           # Windsurf-specific configuration
│   └── rules/
│       ├── personas.md
│       ├── workflow.md
│       └── hand-offs.md
├── .cursor/             # Cursor-specific configuration
│   └── rules/
│       ├── personas.md
│       ├── workflow.md
│       └── hand-offs.md
└── .workflow/           # IDE-agnostic workflow documentation
    └── docs/
```

### 2. IDE Detection and Bootstrap
- Bootstrap script detects target IDE environment
- Copies appropriate configuration files
- Sets up IDE-specific adaptations

### 3. Documentation Strategy
- **Core workflow**: IDE-agnostic in `.workflow/docs/`
- **IDE-specific rules**: Tailored for each IDE's capabilities
- **Unified README**: Instructions for both IDEs

### 4. Template Structure
```
template/
├── .windsurf/           # Windsurf configuration template
├── .cursor/             # Cursor configuration template
├── .workflow/           # Shared workflow documentation
└── docs/               # Project documentation
```

## Implementation Plan

### Phase 1: Architecture Setup
1. Create `.cursor/` configuration structure
2. Adapt personas and workflow for Cursor IDE
3. Update bootstrap script for IDE detection
4. Create IDE-specific documentation

### Phase 2: Testing and Validation
1. Test template in both IDE environments
2. Validate workflow consistency
3. Document IDE-specific features and limitations

## Consequences

### Positive
- Broader IDE support increases template adoption
- Maintains workflow consistency across environments
- Leverages strengths of each IDE
- Future-proof for additional IDE support

### Negative
- Increased complexity in template structure
- Need to maintain IDE-specific configurations
- Potential for configuration drift between IDEs

### Mitigation
- Shared core workflow documentation prevents drift
- Automated testing in both environments
- Clear documentation of IDE-specific differences

## Validation Criteria
- Template works seamlessly in both Windsurf and Cursor
- Workflow consistency maintained across IDEs
- IDE-specific features properly documented
- Bootstrap process handles both environments
