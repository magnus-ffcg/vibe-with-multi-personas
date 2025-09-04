# Hand-off Protocol

This document defines the baton-passing rules between personas in our mob programming workflow.

## Hand-off Rules

### General Protocol
1. Complete your assigned work according to your persona responsibilities
2. Update all relevant documentation files
3. Add a hand-off entry to this file with timestamp
4. Clearly state what was completed and what the next step should be
5. Tag the next persona in the workflow

### Hand-off Entry Format
```
## [TIMESTAMP] [FROM_PERSONA] → [TO_PERSONA]
**Task**: [Task description or ID]
**Completed**: [What was accomplished]
**Next Steps**: [What needs to be done next]
**Notes**: [Any important context or blockers]
**Files Updated**: [List of files modified]
```

### Workflow Transitions

#### ARCHITECT → CODER
- **Trigger**: Design is complete, tasks are in backlog
- **Required**: `/docs/plan.md` updated, tasks in `/docs/backlog.md`
- **Hand-off**: "Design complete, ready for implementation"

#### CODER → TESTER  
- **Trigger**: Implementation is complete
- **Required**: Code committed, `/docs/changelog.md` updated
- **Hand-off**: "Implementation complete, ready for testing"

#### TESTER → REVIEWER
- **Trigger**: Tests are written and passing
- **Required**: Tests committed, `/docs/test-plan.md` and `/docs/test-report.md` updated
- **Hand-off**: "Testing complete, ready for review"

#### REVIEWER → QA
- **Trigger**: Code review is approved
- **Required**: `/docs/review-checklist.md` updated
- **Hand-off**: "Review complete, ready for QA"

#### QA → STAKEHOLDER
- **Trigger**: QA validation is complete
- **Required**: `/docs/release-notes.md` updated with "Ready for Stakeholder"
- **Hand-off**: "QA complete, ready for stakeholder approval"

#### STAKEHOLDER → COMPLETE
- **Trigger**: Stakeholder approves the work
- **Required**: Task marked as "Complete" in `/docs/release-notes.md`
- **Hand-off**: "Task approved and complete"

### Blocker Protocol
If a blocker is encountered:
1. Document the blocker clearly in the hand-off notes
2. Return to ARCHITECT for redesign
3. Use format: `[PERSONA] → ARCHITECT (BLOCKER)`
4. Include detailed description of the issue

### Example Hand-off Entries

```
## 2024-01-15 14:30 [ARCHITECT] → [CODER]
**Task**: User authentication system
**Completed**: Designed JWT-based auth system, created ADR-001
**Next Steps**: Implement login/logout endpoints and middleware
**Notes**: Using bcrypt for password hashing, JWT for sessions
**Files Updated**: /docs/plan.md, /docs/adr/001-authentication.md, /docs/backlog.md

## 2024-01-15 16:45 [CODER] → [TESTER]
**Task**: User authentication system
**Completed**: Implemented login/logout endpoints, JWT middleware
**Next Steps**: Write unit and integration tests
**Notes**: All endpoints working, need to test edge cases
**Files Updated**: /src/auth.py, /src/middleware.py, /docs/changelog.md
```

## Quality Checks

Before handing off, ensure:
- [ ] All required documentation is updated
- [ ] Work meets the quality standards for your persona
- [ ] Next steps are clearly defined
- [ ] Any blockers or concerns are documented
- [ ] Files are properly committed (for code changes)

## Automation Triggers

- When no tasks are "In Progress", ARCHITECT automatically picks up next backlog item
- Hand-offs trigger the next persona to begin their work
- Blockers automatically return work to ARCHITECT
