#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { SimpleWorkflowStorage } from './simple-storage.js';
import { Task, HandOff, Plan } from './types.js';

const server = new Server(
  {
    name: 'mcp-coordinator',
    version: '1.0.0',
  },
  {
    capabilities: {
      resources: {},
      tools: {},
    },
  }
);

// Storage instances per project
const storageInstances = new Map<string, SimpleWorkflowStorage>();

// Get or create storage for a project
async function getStorage(corpusName?: string): Promise<SimpleWorkflowStorage> {
  const projectId = corpusName || 'default';
  
  if (!storageInstances.has(projectId)) {
    const storage = await SimpleWorkflowStorage.create(projectId);
    storageInstances.set(projectId, storage);
  }
  
  return storageInstances.get(projectId)!;
}

// List available resources
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: [
      {
        uri: 'workflow://plan',
        mimeType: 'application/json',
        name: 'Current Plan',
        description: 'The current project plan with architecture and requirements'
      },
      {
        uri: 'workflow://backlog',
        mimeType: 'application/json',
        name: 'Task Backlog',
        description: 'Current task backlog with priorities and status'
      },
      {
        uri: 'workflow://handoffs',
        mimeType: 'application/json',
        name: 'Current Hand-offs',
        description: 'Current persona hand-offs and workflow state'
      },
      {
        uri: 'workflow://handoffs/history',
        mimeType: 'application/json',
        name: 'Hand-off History',
        description: 'Complete history of persona hand-offs'
      }
    ]
  };
});

// Read resource content
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const uri = request.params.uri;
  
  // For resources, we'll use default project for now
  // TODO: Consider adding project scoping to resource URIs
  const storage = await getStorage();
  
  let content;
  switch (uri) {
    case 'workflow://plan':
      content = await storage.getPlan();
      break;
    case 'workflow://backlog':
      content = await storage.getTasks();
      break;
    case 'workflow://handoffs':
      content = await storage.getLatestHandOff();
      break;
    case 'workflow://handoffs/history':
      content = await storage.getHandOffs();
      break;
    default:
      throw new Error(`Unknown resource: ${uri}`);
  }

  // Ensure content is not undefined - provide default values
  if (content === undefined || content === null) {
    switch (uri) {
      case 'workflow://plan':
        content = null;
        break;
      case 'workflow://backlog':
        content = [];
        break;
      case 'workflow://handoffs':
        content = null;
        break;
      case 'workflow://handoffs/history':
        content = [];
        break;
    }
  }

  const textContent = JSON.stringify(content, null, 2);
  
  return {
    contents: [
      {
        uri,
        mimeType: 'application/json',
        text: textContent
      }
    ]
  };
});

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'create_plan',
        description: 'Create or update the project plan',
        inputSchema: {
          type: 'object',
          properties: {
            title: { type: 'string', description: 'Plan title' },
            description: { type: 'string', description: 'Plan description' },
            requirements: { type: 'array', items: { type: 'string' }, description: 'Requirements list' },
            architecture: { type: 'object', description: 'Architecture object with overview, components, and decisions' },
            constraints: { type: 'array', items: { type: 'string' }, description: 'Project constraints' },
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
          required: ['title', 'description']
        }
      },
      {
        name: 'add_task',
        description: 'Add a new task to the backlog',
        inputSchema: {
          type: 'object',
          properties: {
            title: { type: 'string', description: 'Task title' },
            description: { type: 'string', description: 'Task description' },
            acceptanceCriteria: { type: 'array', items: { type: 'string' }, description: 'Acceptance criteria' },
            priority: { type: 'string', enum: ['high', 'medium', 'low'], description: 'Task priority' },
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
          required: ['title', 'description', 'acceptanceCriteria', 'priority'],
        },
      },
      {
        name: 'update_task',
        description: 'Update an existing task',
        inputSchema: {
          type: 'object',
          properties: {
            taskId: { type: 'string', description: 'Task ID' },
            status: { type: 'string', enum: ['backlog', 'in_progress', 'coded', 'tested', 'reviewed', 'qa', 'ready_for_stakeholder', 'complete'], description: 'New status' },
            assignedPersona: { type: 'string', description: 'Assigned persona' },
            notes: { type: 'string', description: 'Update notes' },
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
          required: ['taskId'],
        },
      },
      {
        name: 'create_handoff',
        description: 'Create a new persona hand-off',
        inputSchema: {
          type: 'object',
          properties: {
            fromPersona: { type: 'string', description: 'Source persona' },
            toPersona: { type: 'string', description: 'Target persona' },
            taskId: { type: 'string', description: 'Related task ID' },
            completedWork: { type: 'array', items: { type: 'string' }, description: 'What was completed' },
            nextSteps: { type: 'array', items: { type: 'string' }, description: 'What needs to be done next' },
            notes: { type: 'string', description: 'Additional notes' },
            blockers: { type: 'array', items: { type: 'string' }, description: 'Any blockers encountered' },
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
          required: ['fromPersona', 'toPersona', 'taskId', 'completedWork', 'nextSteps'],
        },
      },
      {
        name: 'get_current_persona',
        description: 'Get the current active persona',
        inputSchema: {
          type: 'object',
          properties: {
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
        },
      },
      {
        name: 'set_current_persona',
        description: 'Set the current active persona',
        inputSchema: {
          type: 'object',
          properties: {
            persona: { type: 'string', description: 'Persona name' },
            corpus_name: { type: 'string', description: 'Project corpus name for isolation' }
          },
          required: ['persona'],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args = {} } = request.params;

  switch (name) {
    case 'create_plan': {
      const storage = await getStorage(args.corpus_name as string);
      const plan: Plan = {
        id: Date.now().toString(),
        title: args.title as string,
        description: args.description as string,
        requirements: (args.requirements as string[]) || [],
        architecture: (args.architecture as { overview: string; components: string[]; decisions: string[] }) || { overview: '', components: [], decisions: [] },
        constraints: (args.constraints as string[]) || [],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
      await storage.setPlan(plan);
      return { content: [{ type: 'text', text: `Plan created: ${plan.title}` }] };
    }

    case 'add_task': {
      const storage = await getStorage(args.corpus_name as string);
      const task = {
        id: `task-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
        title: args.title as string,
        description: args.description as string,
        acceptanceCriteria: args.acceptanceCriteria as string[],
        priority: args.priority as 'high' | 'medium' | 'low',
        status: 'backlog' as const,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
      await storage.addTask(task);
      return { content: [{ type: 'text', text: `Task added: ${task.title}` }] };
    }

    case 'update_task': {
      const storage = await getStorage(args.corpus_name as string);
      await storage.updateTask(args.taskId as string, {
        status: args.status as any,
        assignedPersona: args.assignedPersona as string,
        updatedAt: new Date().toISOString(),
      });
      const task = await storage.getTask(args.taskId as string);
      if (!task) {
        throw new Error(`Task not found: ${args.taskId}`);
      }
      return { content: [{ type: 'text', text: `Task updated: ${task.title}` }] };
    }

    case 'create_handoff': {
      const storage = await getStorage(args.corpus_name as string);
      const handoff = {
        id: `handoff-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
        fromPersona: args.fromPersona as string,
        toPersona: args.toPersona as string,
        taskId: args.taskId as string,
        completedWork: Array.isArray(args.completedWork) ? args.completedWork : [args.completedWork as string],
        nextSteps: Array.isArray(args.nextSteps) ? args.nextSteps : [args.nextSteps as string],
        notes: (args.notes as string) || '',
        blockers: Array.isArray(args.blockers) ? args.blockers : (args.blockers ? [args.blockers as string] : []),
        timestamp: new Date().toISOString()
      };
      await storage.addHandOff(handoff);
      return { content: [{ type: 'text', text: `Hand-off created from ${handoff.fromPersona} to ${handoff.toPersona}` }] };
    }

    case 'get_current_persona': {
      const storage = await getStorage(args.corpus_name as string);
      const persona = await storage.getCurrentPersona();
      return { content: [{ type: 'text', text: persona || 'No current persona set' }] };
    }

    case 'set_current_persona': {
      const storage = await getStorage(args.corpus_name as string);
      await storage.setCurrentPersona(args.persona as string);
      return { content: [{ type: 'text', text: `Current persona set to: ${args.persona}` }] };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

async function main() {
  console.error(`MCP Coordinator Server starting...`);
  console.error(`Multi-project support enabled`);
  
  // Debug mode
  if (process.env.DEBUG_MCP_COORDINATOR) {
    console.error('Debug mode enabled');
  }
  
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('MCP Coordinator Server running on stdio');
  
  // Handle graceful shutdown
  process.on('SIGINT', async () => {
    await server.close();
    process.exit(0);
  });
}

main().catch(console.error);
