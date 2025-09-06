# MCP Coordinator Server

A Model Context Protocol (MCP) server that manages multi-persona development workflow state as the authoritative source of truth for plans, backlogs, and hand-offs.

## Overview

The MCP Coordinator replaces file-based communication between personas with a centralized state management system. Instead of updating `.workflow/docs/` files, personas interact with the MCP server to:

- Store and retrieve project plans
- Manage task backlogs
- Track hand-offs between personas
- Maintain workflow state (current persona, stage, active task)

## Installation

```bash
cd mcp-coordinator
npm install
npm run build
```

## Usage

### Starting the Server

```bash
npm start
```

The server runs on stdio and can be configured as an MCP server in your IDE.

### MCP Configuration

Add to your IDE's MCP configuration:

**Windsurf (.windsurf/mcp_servers.json):**
```json
{
  "mcpServers": {
    "mcp-coordinator": {
      "command": "node",
      "args": ["/path/to/mcp-coordinator/dist/index.js"],
      "cwd": "/path/to/your/project"
    }
  }
}
```

**Cursor (.cursor/mcp_servers.json):**
```json
{
  "mcpServers": {
    "mcp-coordinator": {
      "command": "node",
      "args": ["/path/to/mcp-coordinator/dist/index.js"],
      "cwd": "/path/to/your/project"
    }
  }
}
```

## Resources

The server exposes these MCP resources:

- `workflow://plan` - Current project plan with architecture and requirements
- `workflow://backlog` - All tasks in the project backlog
- `workflow://handoffs` - History of all persona hand-offs
- `workflow://state` - Current workflow state (persona, stage, active task)

## Tools

Available MCP tools for state mutation:

### Plan Management
- `create_plan` - Create or update the project plan
- Parameters: title, description, architecture, requirements, constraints

### Task Management
- `add_task` - Add a new task to the backlog
- Parameters: title, description, priority, acceptanceCriteria
- `update_task` - Update an existing task
- Parameters: id, status, assignedPersona, title, description, priority, acceptanceCriteria

### Hand-off Management
- `create_handoff` - Create a hand-off between personas
- Parameters: fromPersona, toPersona, taskId, completedWork, nextSteps, notes, testStatus, testRunSummary, blockers

### Workflow State
- `set_current_persona` - Set the current active persona
- `set_current_stage` - Set the current TDD stage (for TDD workflows)
- `set_active_task` - Set the currently active task

## Data Storage

The server stores state in `./.workflow-state/state.json` in your project directory. This file is automatically created and maintained.

## Integration with Personas

Personas should use MCP tools instead of file operations:

**Before (File-based):**
```markdown
[ARCHITECT] Updating .workflow/docs/plan.md with architecture decisions...
```

**After (MCP-based):**
```markdown
[ARCHITECT] Creating plan with architecture decisions...
```

The persona would then use the `create_plan` tool to store the plan in the MCP coordinator.

## Workflow Integration

1. **ARCHITECT** uses `create_plan` and `add_task` tools
2. **CODER/TDD_DEVELOPER** uses `update_task` and `create_handoff` tools
3. **TESTER** uses `create_handoff` with test status
4. **REVIEWER** uses `create_handoff` with review notes
5. **QA** uses `create_handoff` for final validation
6. **STAKEHOLDER** uses `update_task` to mark complete

All personas can read current state via MCP resources to understand context and previous work.
