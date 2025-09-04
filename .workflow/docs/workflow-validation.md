# Workflow Validation Checklist

This document provides validation guidelines to ensure proper multi-persona development workflow execution and role enforcement.

## Pre-Task Validation

Before starting any task, validate:
- [ ] Task has clear acceptance criteria in `/docs/backlog.md`
- [ ] Task is assigned to correct starting persona (usually [ARCHITECT])
- [ ] Previous task is properly completed and documented

## Role Enforcement Validation

### ARCHITECT Compliance Check
- [ ] ARCHITECT has NOT made any code edits or file modifications
- [ ] ARCHITECT has NOT used Edit, MultiEdit, or write_to_file tools
- [ ] ARCHITECT has documented design decisions in appropriate files
- [ ] ARCHITECT has handed off implementation work to [CODER]
- [ ] Hand-off is properly documented in `/docs/hand-offs.md`

### CODER Compliance Check
- [ ] ALL code edits and file modifications done by [CODER] only
- [ ] No other persona has bypassed [CODER] for implementation work
- [ ] [CODER] has received proper hand-off from [ARCHITECT]
- [ ] Implementation follows documented design specifications
- [ ] Code changes are properly committed with clear messages

### General Workflow Compliance
- [ ] Proper persona prefixes used in all communications
- [ ] Hand-offs documented in `/docs/hand-offs.md`
- [ ] Task progression follows correct pipeline order
- [ ] No personas performing work outside their defined responsibilities

## Task Completion Validation

### Implementation Phase
- [ ] [CODER] has completed all implementation work
- [ ] Code is production-ready and follows standards
- [ ] `/docs/changelog.md` updated with changes
- [ ] Proper hand-off to [TESTER] documented

### Testing Phase
- [ ] [TESTER] has written comprehensive tests
- [ ] Test coverage meets minimum 80% requirement
- [ ] At least one negative test case included
- [ ] All tests pass successfully
- [ ] Test documentation updated

### Review Phase
- [ ] [REVIEWER] has completed code quality assessment
- [ ] Review findings documented in `/docs/review-checklist.md`
- [ ] Code approved or change requests clearly documented
- [ ] Security and performance concerns addressed

### QA Phase
- [ ] [QA] has validated against original acceptance criteria
- [ ] Regression testing completed
- [ ] No existing functionality broken
- [ ] Task marked "Ready for Stakeholder" in release notes

### Stakeholder Phase
- [ ] All deliverables presented to stakeholder
- [ ] Stakeholder has explicitly approved or requested changes
- [ ] Only stakeholder can mark task as "Complete"
- [ ] Final approval documented with timestamp

## Violation Detection

### Common Role Violations to Watch For
- ARCHITECT making code edits instead of designing
- Any persona other than CODER using implementation tools
- Skipping personas in the workflow pipeline
- Missing hand-off documentation
- Personas approving work outside their authority

### Violation Response
1. Stop current work immediately
2. Document the violation in hand-offs
3. Return to appropriate persona for correct execution
4. Update workflow documentation if needed
5. Ensure proper role separation going forward

## Success Criteria

A task is properly executed when:
- All personas stay within their defined boundaries
- Proper hand-offs occur at each stage
- Documentation is complete and accurate
- Quality gates are met at each phase
- Stakeholder provides final approval

## Continuous Improvement

After each task completion:
- Review workflow execution for improvements
- Update validation checklist if new issues discovered
- Document lessons learned in appropriate ADRs
- Refine role definitions if boundary issues persist
