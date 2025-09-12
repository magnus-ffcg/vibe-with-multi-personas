# Mob Programming Workflow

This document defines the complete workflow process for mob programming using the 6-persona system.

## Important notes

All mcp-server calls to mcp-coordinator includes corpus_name

## Workflow Pipeline

```
Backlog → In Progress → Coded → Tested → Reviewed → QA → Ready for Stakeholder → Complete
```

## Persona Flow

1. **[ARCHITECT]** - Research, design, and task breakdown
2. **[CODER]** - Implementation using best practices
3. **[TESTER]** - Comprehensive testing with 80% coverage
4. **[REVIEWER]** - Code review for quality and maintainability
5. **[QA]** - Validation against acceptance criteria
6. **[STAKEHOLDER]** - Final approval (you, the user)

## Task Lifecycle

### 1. Backlog Management
- Tasks managed via MCP `add_task` and `update_task` tools
- [ARCHITECT] creates and prioritizes tasks
- Clear acceptance criteria required for each task

### 2. Implementation Phase
- [ARCHITECT] moves task to "In Progress"
- Designs solution and documents using MCP `create_plan` tool
- Hands off to [CODER] with clear specifications

### 3. Development Phase
- [CODER] implements following the design
- Makes small, focused commits
- Updates `docs/changelog.md`
- Hands off to [TESTER]

### 4. Testing Phase
- [TESTER] writes comprehensive tests
- Aims for ~80% coverage
- Updates test documentation via MCP coordinator
- Hands off to [REVIEWER]

### 5. Review Phase
- [REVIEWER] assesses code quality and maintainability
- Documents review feedback via MCP coordinator
- Provides feedback and approval
- Hands off to [QA]

### 6. Quality Assurance
- [QA] validates against acceptance criteria
- Performs end-to-end testing
- Updates task status using MCP `update_task` tool
- Marks as "Ready for Stakeholder"

### 7. Stakeholder Approval
- [STAKEHOLDER] (you) reviews completed work
- **Only stakeholders can mark tasks as "Complete"**
- Can request changes or approve for completion

## Communication Rules

### Message Prefixes
All personas must prefix messages with their role:
- `[ARCHITECT]` for design work
- `[CODER]` for implementation
- `[TESTER]` for testing
- `[REVIEWER]` for code review
- `[QA]` for quality assurance
- `[STAKEHOLDER]` for final approval

### Hand-off Protocol
1. Update relevant documentation
2. Create hand-off using MCP `create_handoff` tool
3. State what was completed and next steps
4. Tag the next persona

## Quality Gates

Each phase has specific quality requirements:
- **Design**: Clear acceptance criteria and architectural decisions
- **Implementation**: Clean, maintainable code with proper commits
- **Testing**: Comprehensive test coverage with passing tests
- **Review**: Code quality assessment and approval
- **QA**: Validation against all acceptance criteria
- **Stakeholder**: Final approval for completion

## Documentation Requirements

- MCP coordinator resources - Centralized state management
  - `plan://current` - Project design and architecture
  - `backlog://current` - Task management
  - `handoffs://current` - Active persona transitions
  - `handoffs://history` - Completed work tracking
- `docs/changelog.md` - Code changes
- `docs/adr/` - Architectural decision records

## Workflow Benefits

✅ **Quality Focus** - Multiple review stages catch issues early  
✅ **Clear Ownership** - Each persona has defined responsibilities  
✅ **Complete Documentation** - All work is properly documented  
✅ **Stakeholder Control** - Clear approval process for all work  
✅ **Continuous Improvement** - Regular hand-offs enable feedback
