# Hand-offs Documentation (Windsurf Cascade with MCP)

This document describes the hand-off protocol for the multi-persona development workflow using MCP coordinator for state management.

## MCP-Based Hand-off Protocol

All hand-offs are now managed through the MCP coordinator server instead of file-based communication. Each persona uses MCP tools to create structured hand-offs.

### Creating Hand-offs with MCP

Use the MCP `create_handoff` tool with the following structure:

```typescript
create_handoff({
  from_persona: "ARCHITECT",
  to_persona: "CODER", 
  task_id: "task-001",
  completed_work: "Designed authentication system architecture",
  next_steps: "Implement JWT-based login/logout endpoints",
  notes: "Using bcrypt for password hashing, consider rate limiting",
  files_updated: ["docs/adr/001-authentication.md"],
  windsurf_features_used: ["AI research", "workspace context"]
})
```

## Hand-off Template (for reference)

```markdown
### [TIMESTAMP] [FROM_PERSONA] → [TO_PERSONA]
**Task**: [Task description or ID]
**Completed**: [What was accomplished]
**Next Steps**: [What needs to be done next]
**Notes**: [Any important context or blockers]
**Files Updated**: [List of files modified]
**Windsurf Features Used**: [Specific Windsurf Cascade features utilized]
```

## MCP Resources for Hand-offs

- **Resource**: `handoffs://current` - View current active hand-offs
- **Resource**: `handoffs://history` - View completed hand-offs
- **Tool**: `create_handoff` - Create new hand-off between personas
- **Tool**: `get_current_persona` - Check which persona should be active
- **Tool**: `set_current_persona` - Update active persona in workflow

---

## Windsurf Cascade Specific Guidelines

### Hand-off Best Practices
- Document which Windsurf features were used during the work phase
- Include any AI pair programming insights that influenced decisions
- Mention Windsurf workspace context that was leveraged
- Note any Cascade-specific configurations or settings applied

### Communication in Windsurf with MCP
- Use Windsurf's chat interface for persona communication
- Leverage @mentions for clear persona transitions
- Use MCP tools for all state management and hand-offs
- Document AI-assisted decisions in MCP hand-off records
- Include Windsurf workspace context when relevant

### MCP Tool Usage Documentation
When creating hand-offs with MCP tools, document:
- **ARCHITECT**: Use `create_plan` and `add_task` tools, analysis using Windsurf's context awareness
- **CODER**: AI pair programming features, integrated debugging tools used
- **TESTER**: Testing frameworks, AI test generation capabilities utilized
- **REVIEWER**: Code analysis features, collaborative review tools employed
- **QA**: Use `update_task` tool to mark tasks ready for stakeholder, validation frameworks used

### Quality Assurance with MCP
- All workflow state managed through MCP coordinator server
- Hand-offs created using `create_handoff` MCP tool
- Task status updated using `update_task` MCP tool
- Current persona tracked using `set_current_persona` MCP tool
- Document any manual modifications to AI suggestions in MCP records

### Strict Role Enforcement
- ARCHITECT must hand off to CODER for all implementation work using MCP tools
- CODER has exclusive authority for code modifications
- All personas must respect workflow boundaries and use MCP for state management
- Document any role enforcement issues in MCP hand-off records

---

*This workflow uses MCP coordinator server for authoritative state management*
