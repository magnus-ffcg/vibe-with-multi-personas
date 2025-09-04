# ADR-005: Strict Role Enforcement in Multi-Persona Development Workflow

## Status
Accepted

## Context
Analysis of recent workflow execution revealed that the ARCHITECT persona was performing implementation tasks (making code edits) instead of limiting work to design and documentation. This violated the intended separation of concerns and caused the CODER persona to be bypassed entirely.

**Specific Issues Identified**:
- ARCHITECT directly made code edits in TASK-011 instead of handing off to CODER
- CODER persona was skipped, violating the intended workflow pipeline
- No enforcement mechanisms existed to prevent role boundary violations
- Workflow documentation lacked explicit restrictions on tool usage by persona

## Decision
Implement strict role enforcement rules with explicit restrictions and mandatory hand-off requirements:

### ARCHITECT Restrictions
- ARCHITECT MUST NOT make any code edits or file modifications
- ARCHITECT MUST NOT use Edit, MultiEdit, or write_to_file tools
- ARCHITECT MUST hand off ALL implementation work to CODER
- ARCHITECT role limited to design, documentation, and task breakdown only

### CODER Exclusive Authority
- ONLY CODER persona can make code edits or file modifications
- ALL other personas PROHIBITED from using implementation tools
- CODER MUST be involved in EVERY implementation task
- NO persona may bypass CODER for code changes

### Mandatory Hand-off Flow
- ARCHITECT designs → CODER implements (NO EXCEPTIONS)
- Every implementation task MUST flow through CODER
- Hand-offs MUST be documented in `/docs/hand-offs.md`

## Consequences

### Positive
- Clear separation of concerns between design and implementation
- Ensures CODER persona is never bypassed
- Prevents role boundary violations
- Maintains intended workflow pipeline integrity
- Forces proper documentation of design decisions before implementation

### Negative
- May initially slow down development as personas adjust to strict boundaries
- Requires more explicit hand-off documentation
- Could feel bureaucratic for simple changes

### Mitigation
- Clear documentation of restrictions in personas.md and workflow.md
- Explicit tool usage restrictions by persona type
- Mandatory hand-off requirements with documentation

## Implementation
1. Update personas.md with explicit "MUST NOT" restrictions for ARCHITECT
2. Add "EXCLUSIVE IMPLEMENTATION AUTHORITY" section for CODER
3. Update workflow.md with strict role enforcement rules
4. Document mandatory hand-off flow requirements
5. Add workflow validation guidelines

## Validation
Success will be measured by:
- No future instances of ARCHITECT making code edits
- All implementation tasks flowing through CODER persona
- Proper hand-off documentation for all implementation work
- Maintained workflow pipeline integrity
