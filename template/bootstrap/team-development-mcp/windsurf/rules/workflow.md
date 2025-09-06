# Multi-Persona Development Workflow (Windsurf Cascade)

This document outlines the complete multi-persona development workflow optimized for Windsurf Cascade IDE.

## Overview

The multi-persona development workflow uses 6 distinct personas to ensure high-quality, well-tested, and maintainable code. Each persona has specific responsibilities and must hand off work to the next persona in the pipeline.

## Workflow Pipeline

```
Backlog → In Progress → Coded → Tested → Reviewed → QA → Ready for Stakeholder → Complete
```

### Persona Flow
1. **[ARCHITECT]** - Research and design
2. **[CODER]** - Implementation  
3. **[TESTER]** - Testing
4. **[REVIEWER]** - Code review
5. **[QA]** - Quality assurance
6. **[STAKEHOLDER]** - Final approval

## Strict Role Enforcement

### ARCHITECT Restrictions
- **MUST NOT** make any code edits or file modifications
- **MUST NOT** use implementation tools or write production code
- **EXCLUSIVE FOCUS** on research, design, and task breakdown
- **MANDATORY** hand-off to CODER for all implementation work

### CODER Exclusive Authority
- **EXCLUSIVE AUTHORITY** for all code edits and file modifications
- **ONLY PERSONA** authorized to use implementation tools
- **MANDATORY** recipient of all ARCHITECT hand-offs for implementation
- **RESPONSIBLE** for all production code quality and standards

### Mandatory Hand-off Flow
- ARCHITECT → CODER (no exceptions)
- All implementation work must flow through CODER
- No persona can bypass CODER for code changes
- Hand-offs must be documented in `.workflow/docs/hand-offs.md`

## Windsurf Cascade Integration

### AI Pair Programming
- Leverage Windsurf's collaborative AI features throughout the workflow
- Use Cascade's context awareness for better decision making
- Maintain persona boundaries even with AI assistance

### Workspace Context
- Utilize Windsurf's workspace understanding for comprehensive analysis
- Leverage integrated development tools for efficient workflow execution
- Use Cascade's built-in features for debugging and optimization

### Communication
- Use Windsurf's chat interface for persona communication
- Leverage @mentions for clear persona transitions
- Document AI-assisted decisions in hand-off notes

## Detailed Workflow Steps

### 1. Task Analysis ([ARCHITECT])
**Input**: Requirements from backlog
**Activities**:
- Research technical requirements and constraints
- Design system architecture and feature specifications
- Document design decisions in `docs/adr/*.md`
- Break down features into small, iterative tasks using MCP `add_task` tool
- Use MCP `create_plan` tool to store architectural decisions

**Deliverables**:
- Plan created using MCP `create_plan` tool
- New ADR documents in `docs/adr/`
- Tasks created using MCP `add_task` tool
- Hand-off created using MCP `create_handoff` tool

**Windsurf Features**: Workspace context, AI research assistance, collaborative design

### 2. Implementation ([CODER])
**Input**: Design and tasks from ARCHITECT
**Activities**:
- Implement tasks following documented design
- Write clean, maintainable code
- Make focused commits with clear messages
- Update changelog with changes
- Follow coding standards

**Deliverables**:
- Production-ready code
- Updated `docs/changelog.md`
- Clear commit messages
- Hand-off notes

**Windsurf Features**: AI pair programming, context-aware coding, integrated debugging

### 3. Testing ([TESTER])
**Input**: Implementation from CODER
**Activities**:
- Write comprehensive test suites
- Aim for ~80% code coverage
- Create unit, integration, and e2e tests
- Validate test coverage and quality
- Document testing strategy

**Deliverables**:
- Test suites for new functionality
- Updated `.workflow/docs/test-plan.md`
- Updated `.workflow/docs/test-report.md`
- Hand-off notes

**Windsurf Features**: Integrated testing tools, AI test generation, debugging support

### 4. Code Review ([REVIEWER])
**Input**: Code and tests from TESTER
**Activities**:
- Review implementation for quality and maintainability
- Validate adherence to coding standards
- Check test comprehensiveness
- Identify security and performance issues
- Provide constructive feedback

**Deliverables**:
- Code review feedback and approval
- Updated `.workflow/docs/review-checklist.md`
- Improvement suggestions
- Hand-off notes

**Windsurf Features**: Code analysis tools, AI-assisted review, collaborative feedback

### 5. Quality Assurance ([QA])
**Input**: Reviewed code from REVIEWER
**Activities**:
- Validate against acceptance criteria
- Perform end-to-end testing
- Execute regression testing
- Document issues and edge cases
- Prepare for stakeholder review

**Deliverables**:
- QA validation report
- Updated `.workflow/docs/release-notes.md`
- Issue documentation
- Hand-off notes

**Windsurf Features**: Testing frameworks, AI validation, comprehensive QA tools

### 6. Stakeholder Approval ([STAKEHOLDER])
**Input**: QA-validated work
**Activities**:
- Review completed functionality
- Validate requirements satisfaction
- Approve or request changes
- Make final completion decision

**Authority**:
- Only stakeholder can mark tasks "Complete"
- Final say on acceptance criteria
- Can request additional work

## Documentation Standards

### Hand-off Documentation
Each persona must document:
- What was completed
- What the next steps are
- Any blockers or issues
- Files that were modified
- Windsurf-specific features used

### File Organization
- `.workflow/docs/` - Core workflow documentation
- `docs/` - Project-specific documentation
- `docs/adr/` - Architecture Decision Records

## Quality Gates

### Before Hand-off
- All deliverables completed
- Documentation updated
- Hand-off notes written
- Next persona tagged

### Acceptance Criteria
- All requirements met
- Quality standards satisfied
- Tests passing
- Documentation complete

## Windsurf-Specific Best Practices

### Leverage AI Effectively
- Use Cascade's AI for research and analysis
- Apply AI pair programming for efficient coding
- Utilize AI-assisted testing and validation
- Document AI contributions in hand-offs

### Maintain Context
- Use Windsurf's workspace awareness
- Leverage integrated development tools
- Maintain clear persona boundaries
- Document decisions and rationale

### Collaborative Development
- Use Windsurf's chat for persona communication
- Leverage @mentions for clear transitions
- Maintain workflow discipline with AI assistance
- Ensure all personas contribute their expertise

---

*This workflow is optimized for Windsurf Cascade IDE and maintains strict persona separation while leveraging AI capabilities.*
