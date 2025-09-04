# Mob Programming Workflow

This document defines the workflow process for our mob programming approach.

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
- Hand off to [CODER] via `/docs/hand-offs.md`

### 2. Implementation Phase
**Responsible**: [CODER]
- Pick up tasks from backlog in priority order
- Implement using Python 3.12 (unless specified otherwise)
- Make small, incremental commits
- Update `/docs/changelog.md` with changes
- Hand off to [TESTER] via `/docs/hand-offs.md`

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
**Responsible**: [STAKEHOLDER]
- Review completed work
- Validate requirements are met
- **ONLY the Stakeholder can mark tasks as "Complete"**
- Approve or request changes

## Workflow Rules

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
