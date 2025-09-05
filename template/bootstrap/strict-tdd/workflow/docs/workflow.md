# Strict Test-Driven Development Workflow

This document defines the workflow process for our strict TDD approach with clear boundaries and enforcement.

## Workflow Overview

All requests begin with the **[TEST_ARCHITECT]** and follow the strict Red-Green-Refactor cycle:

```
Requirements → Test Design → Failing Tests → Minimal Code → Refactor → Complete
```

## TDD Cycle Phases

### Phase 1: Test Architecture
**Responsible**: [TEST_ARCHITECT]
- Analyze user requirements and acceptance criteria
- Design comprehensive test specifications
- Document test strategy in `.workflow/docs/test-plan.md`
- Break down features into testable behaviors
- Hand off to [TEST_WRITER] with complete test specifications

### Phase 2: RED - Write Failing Tests
**Responsible**: [TEST_WRITER]
- Implement test specifications as executable failing tests
- Write unit tests, integration tests, and acceptance tests
- Ensure ALL tests fail initially (RED phase)
- Document test implementation approach
- **CRITICAL**: Verify tests fail before handoff
- Hand off to [CODER] with failing test suite

### Phase 3: GREEN - Make Tests Pass
**Responsible**: [CODER]
- Write minimal production code to make failing tests pass
- Focus on making tests green, not on perfect implementation
- Follow the simplest solution that works
- Update `.workflow/docs/changelog.md` with changes
- **CRITICAL**: Only write code that makes tests pass
- Hand off to [CODER] for refactoring (same persona, different phase)

### Phase 4: REFACTOR - Improve Code Quality
**Responsible**: [CODER]
- Refactor code while keeping all tests green
- Improve code structure, readability, and maintainability
- Apply design patterns and best practices
- Ensure tests remain green throughout refactoring
- Hand off to [STAKEHOLDER] for approval

### Phase 5: Stakeholder Review
**Responsible**: [STAKEHOLDER]
- Review completed feature with passing tests
- Validate requirements are met through test execution
- **ONLY the Stakeholder can mark features as "Complete"**
- Approve or request changes

## Strict TDD Rules

### Fundamental Laws
1. **You may not write production code until you have written a failing unit test**
2. **You may not write more of a unit test than is sufficient to fail**
3. **You may not write more production code than is sufficient to make the failing test pass**

### Enforcement Mechanisms
- **TEST_WRITER must create failing tests before any production code**
- **CODER cannot write code without corresponding failing tests**
- **All tests must be green before refactoring**
- **No skipping phases in the Red-Green-Refactor cycle**

### Quality Gates

#### Test Quality Requirements
- Tests must be comprehensive and cover all acceptance criteria
- Tests must fail initially (RED phase validation)
- Tests must have clear, descriptive names
- Tests must be maintainable and readable

#### Code Quality Requirements
- Code must make tests pass with minimal implementation
- Refactored code must maintain all tests in green state
- Code must follow established coding standards
- All changes must be documented in changelog

### Workflow States
- **Requirements Analysis**: [TEST_ARCHITECT] analyzing requirements
- **Test Design**: [TEST_ARCHITECT] designing test specifications  
- **RED Phase**: [TEST_WRITER] writing failing tests
- **GREEN Phase**: [CODER] writing minimal code to pass tests
- **REFACTOR Phase**: [CODER] improving code while keeping tests green
- **Ready for Stakeholder**: Feature complete with passing tests
- **Complete**: Approved by stakeholder

### Communication Protocol
1. All messages must be prefixed with persona role
2. Each persona updates relevant documentation
3. Hand-off notes must be added to `.workflow/docs/hand-offs.md`
4. Clear communication of current TDD phase and next steps

### Blocker Handling
- If tests cannot be written, return to [TEST_ARCHITECT] for requirement clarification
- If tests cannot be made to pass, return to [TEST_WRITER] for test review
- If refactoring breaks tests, revert and try different approach
- Document all blockers in hand-off notes

## Success Criteria

A feature is considered successful when:
1. Comprehensive failing tests are written first
2. Minimal code makes all tests pass
3. Code is refactored while maintaining green tests
4. All acceptance criteria are validated through tests
5. **Stakeholder has given final approval**

The strict TDD cycle ensures high code quality, comprehensive test coverage, and clear requirement validation through executable specifications.
