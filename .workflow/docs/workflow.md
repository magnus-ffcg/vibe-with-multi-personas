# Multi-Persona Development Workflow

This document defines the complete workflow process for multi-persona development using the 6-persona system.

## Workflow Overview

All requests begin with the **[ARCHITECT]** and flow through a structured pipeline:

```
Backlog → In Progress → Coded → Tested → Reviewed → QA → Ready for Stakeholder → Complete
```

## Detailed Workflow Steps

### 1. Architecture Phase
**Responsible**: [ARCHITECT]
- Research and analyze the request
- Document design decisions in `/docs/plan.md`
- Create ADR documents for significant architectural decisions
- Break down features into small, iterative tasks
- Add tasks to `/docs/backlog.md` with clear acceptance criteria
- **MANDATORY**: Hand off to [CODER] via `/docs/hand-offs.md`

**CRITICAL RESTRICTION**: 
- **ARCHITECT MUST NOT make any code edits or file modifications**
- **ARCHITECT MUST NOT use Edit, MultiEdit, or write_to_file tools**
- **ALL implementation work MUST be handed to [CODER]**

### 2. Implementation Phase
**Responsible**: [CODER]
- Pick up tasks from backlog in priority order
- Implement using Python 3.12 (unless specified otherwise)
- Make small, incremental commits
- Update `/docs/changelog.md` with changes
- Hand off to [TESTER] via `/docs/hand-offs.md`

**EXCLUSIVE IMPLEMENTATION AUTHORITY**:
- **ONLY [CODER] can make code edits or file modifications**
- **ALL other personas are PROHIBITED from using Edit, MultiEdit, or write_to_file tools**
- **[CODER] must be involved in EVERY implementation task**

### 3. Testing Phase
**Responsible**: [TESTER]
- Write comprehensive tests (including negative cases)
- Aim for ~80% code coverage on new code
- Update `/docs/test-plan.md` and `/docs/test-report.md`
- Ensure all tests pass
- Hand off to [REVIEWER] via `/docs/hand-offs.md`

### 4. Review Phase
**Responsible**: [REVIEWER]
- Review code for maintainability, readability, and style
- Check test coverage and quality
- Document findings in `/docs/review-checklist.md`
- Approve or request changes
- Hand off to [QA] via `/docs/hand-offs.md`

### 5. Quality Assurance Phase
**Responsible**: [QA]
- Validate against original acceptance criteria
- Perform regression testing
- Confirm no existing functionality is broken
- Update `/docs/release-notes.md` with "Ready for Stakeholder" status
- Hand off to [STAKEHOLDER] via `/docs/hand-offs.md`

### 6. Stakeholder Review
**Responsible**: [STAKEHOLDER] (The User)
- Review completed work
- Validate requirements are met
- **ONLY the Stakeholder (user) can mark tasks as "Complete"**
- Approve or request changes
- **IMPORTANT**: Personas cannot approve tasks on behalf of stakeholder

**Stakeholder Approval Process**:
1. QA hands off task as "Ready for Stakeholder"
2. Stakeholder reviews all deliverables and quality gates
3. Stakeholder explicitly states approval or requests changes
4. Only after explicit stakeholder approval can task be marked "Complete"

## Workflow Rules

### STRICT ROLE ENFORCEMENT
**CRITICAL**: These rules MUST be followed to maintain proper workflow separation:

1. **ARCHITECT Restrictions**:
   - MUST NOT make any code edits or file modifications
   - MUST NOT use Edit, MultiEdit, or write_to_file tools
   - MUST hand off ALL implementation work to [CODER]
   - ONLY designs and documents - NO implementation

2. **CODER Exclusive Authority**:
   - ONLY [CODER] can make code edits or file modifications
   - ALL other personas PROHIBITED from implementation tools
   - MUST be involved in EVERY implementation task
   - NO persona may bypass [CODER] for code changes

3. **Mandatory Hand-off Flow**:
   - [ARCHITECT] designs → [CODER] implements (NO EXCEPTIONS)
   - Every implementation task MUST flow through [CODER]
   - Hand-offs MUST be documented in `/docs/hand-offs.md`

### Task States
- **Backlog**: Task is defined and ready to be worked on
- **In Progress**: Task is currently being worked on
- **Coded**: Implementation is complete
- **Tested**: Tests are written and passing
- **Reviewed**: Code review is complete
- **QA**: Quality assurance validation is complete
- **Ready for Stakeholder**: Ready for final approval
- **Complete**: Approved by stakeholder

### Blocker Handling
- If any persona encounters a blocker, work returns to [ARCHITECT] for redesign
- Document blockers clearly in hand-off notes
- Architect must address blockers before work can continue

### Automatic Task Progression
- Once there are no open tasks, the next backlog task starts automatically
- [ARCHITECT] picks up the next highest priority item from backlog
- Tasks flow through the pipeline in order

### Communication Protocol
1. All messages must be prefixed with persona role (e.g., `[ARCHITECT]`)
2. Each persona updates relevant documentation
3. Hand-off notes must be added to `/docs/hand-offs.md`
4. Clear communication of what was completed and next steps

## Quality Gates

### Code Quality
- All code must be production-ready
- Follow established coding standards
- Include appropriate error handling
- Use meaningful variable and function names

### Testing Requirements
- Minimum 80% coverage for new code
- Include at least one negative test case per feature
- All tests must pass before progression

### Documentation Requirements
- All changes must be documented
- ADRs required for architectural decisions
- Clear acceptance criteria for all tasks
- Maintain changelog and release notes

## Success Criteria

A task is considered successful when:
1. All acceptance criteria are met
2. Code is reviewed and approved
3. Tests pass with adequate coverage
4. QA validation is complete
5. **Stakeholder has given final approval**

Only after stakeholder approval can a task be marked as "Complete".
