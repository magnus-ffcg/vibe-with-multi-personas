# Team Development with MCP Coordinator

This workflow uses the **MCP Coordinator** server to manage state instead of file-based communication. The MCP server provides centralized storage for plans, backlogs, and hand-offs.

## Setup

1. **Install MCP Coordinator**:
   ```bash
   cd mcp-coordinator
   npm install
   npm run build
   ```

2. **Configure Windsurf**: The `mcp_servers.json` file is already configured to use the MCP coordinator.

3. **Start Development**: Begin with `[ARCHITECT]` persona - the MCP server will automatically track state.

## Workflow Overview

**6 Personas**: ARCHITECT → CODER → TESTER → REVIEWER → QA → STAKEHOLDER

### Key Differences from Standard Team Development

- **State Management**: Uses MCP tools instead of `.workflow/docs/` files
- **Centralized Storage**: All workflow state stored in MCP coordinator
- **Real-time Access**: Personas can query current state via MCP resources

### MCP Integration

**Instead of file operations, personas use MCP tools**:

- `[ARCHITECT]` uses `create_plan` and `add_task`
- `[CODER]` uses `update_task` and `create_handoff`
- `[TESTER]` uses `create_handoff` with test status
- `[REVIEWER]` uses `create_handoff` with review notes
- `[QA]` uses `create_handoff` for validation
- `[STAKEHOLDER]` uses `update_task` to mark complete

### Available MCP Resources

- `workflow://plan` - Current project plan
- `workflow://backlog` - All tasks
- `workflow://handoffs` - Hand-off history
- `workflow://state` - Current workflow state

## Benefits

✅ **Centralized State** - Single source of truth for all workflow data  
✅ **Real-time Updates** - Immediate access to current state  
✅ **Structured Data** - JSON-based storage with validation  
✅ **Query Capability** - Easy access to historical data  
✅ **No File Conflicts** - Eliminates merge conflicts in documentation  

## Getting Started

1. Start with `[ARCHITECT]` persona
2. Use MCP tools to create plan and tasks
3. Follow normal workflow with MCP-based hand-offs
4. Query MCP resources to understand current state

The personas and process remain the same - only the storage mechanism changes from files to MCP.
