#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { WorkflowStorage } from './storage.js';
import { Task, HandOff, Plan } from './types.js';

class MCPCoordinatorServer {
  private server: Server;
  private storage: WorkflowStorage;

  constructor() {
    this.server = new Server(
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

    this.storage = new WorkflowStorage();
    this.setupHandlers();
  }

  private setupHandlers() {
    // List available resources
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => {
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
            description: 'All tasks in the project backlog'
          },
          {
            uri: 'workflow://handoffs',
            mimeType: 'application/json',
            name: 'Hand-off History',
            description: 'History of all persona hand-offs'
          },
          {
            uri: 'workflow://state',
            mimeType: 'application/json',
            name: 'Workflow State',
            description: 'Current workflow state including active persona and task'
          }
        ]
      };
    });

    // Read resource content
    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      const { uri } = request.params;

      switch (uri) {
        case 'workflow://plan':
          const plan = await this.storage.getPlan();
          return {
            contents: [{
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(plan || null, null, 2)
            }]
          };

        case 'workflow://backlog':
          const tasks = await this.storage.getTasks();
          return {
            contents: [{
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(tasks, null, 2)
            }]
          };

        case 'workflow://handoffs':
          const handOffs = await this.storage.getHandOffs();
          return {
            contents: [{
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(handOffs, null, 2)
            }]
          };

        case 'workflow://state':
          const state = await this.storage.getFullState();
          return {
            contents: [{
              uri,
              mimeType: 'application/json',
              text: JSON.stringify(state, null, 2)
            }]
          };

        default:
          throw new Error(`Unknown resource: ${uri}`);
      }
    });

    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'create_plan',
            description: 'Create or update the project plan',
            inputSchema: {
              type: 'object',
              properties: {
                title: { type: 'string' },
                description: { type: 'string' },
                architecture: {
                  type: 'object',
                  properties: {
                    overview: { type: 'string' },
                    components: { type: 'array', items: { type: 'string' } },
                    decisions: { type: 'array', items: { type: 'string' } }
                  }
                },
                requirements: { type: 'array', items: { type: 'string' } },
                constraints: { type: 'array', items: { type: 'string' } }
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
                title: { type: 'string' },
                description: { type: 'string' },
                priority: { type: 'string', enum: ['low', 'medium', 'high'] },
                acceptanceCriteria: { type: 'array', items: { type: 'string' } }
              },
              required: ['title', 'description', 'priority', 'acceptanceCriteria']
            }
          },
          {
            name: 'update_task',
            description: 'Update an existing task',
            inputSchema: {
              type: 'object',
              properties: {
                id: { type: 'string' },
                status: { 
                  type: 'string', 
                  enum: ['backlog', 'in_progress', 'coded', 'tested', 'reviewed', 'qa', 'ready_for_stakeholder', 'complete']
                },
                assignedPersona: { type: 'string' },
                title: { type: 'string' },
                description: { type: 'string' },
                priority: { type: 'string', enum: ['low', 'medium', 'high'] },
                acceptanceCriteria: { type: 'array', items: { type: 'string' } }
              },
              required: ['id']
            }
          },
          {
            name: 'create_handoff',
            description: 'Create a hand-off between personas',
            inputSchema: {
              type: 'object',
              properties: {
                fromPersona: { type: 'string' },
                toPersona: { type: 'string' },
                taskId: { type: 'string' },
                completedWork: { type: 'array', items: { type: 'string' } },
                nextSteps: { type: 'array', items: { type: 'string' } },
                notes: { type: 'string' },
                testStatus: { type: 'string', enum: ['failing', 'passing', 'none'] },
                testRunSummary: { type: 'string' },
                blockers: { type: 'array', items: { type: 'string' } }
              },
              required: ['fromPersona', 'toPersona', 'completedWork', 'nextSteps', 'notes']
            }
          },
          {
            name: 'set_current_persona',
            description: 'Set the current active persona',
            inputSchema: {
              type: 'object',
              properties: {
                persona: { type: 'string' }
              },
              required: ['persona']
            }
          },
          {
            name: 'set_current_stage',
            description: 'Set the current TDD stage (for TDD workflows)',
            inputSchema: {
              type: 'object',
              properties: {
                stage: { type: 'string' }
              },
              required: ['stage']
            }
          },
          {
            name: 'set_active_task',
            description: 'Set the currently active task',
            inputSchema: {
              type: 'object',
              properties: {
                taskId: { type: 'string' }
              },
              required: ['taskId']
            }
          }
        ]
      };
    });

    // Handle tool calls
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      switch (name) {
        case 'create_plan':
          const plan: Plan = {
            id: `plan-${Date.now()}`,
            title: args.title,
            description: args.description,
            architecture: args.architecture || { overview: '', components: [], decisions: [] },
            requirements: args.requirements || [],
            constraints: args.constraints || [],
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
          };
          await this.storage.setPlan(plan);
          return {
            content: [{
              type: 'text',
              text: `Plan created: ${plan.title}`
            }]
          };

        case 'add_task':
          const task = await this.storage.addTask({
            title: args.title,
            description: args.description,
            status: 'backlog',
            priority: args.priority,
            acceptanceCriteria: args.acceptanceCriteria
          });
          return {
            content: [{
              type: 'text',
              text: `Task added: ${task.title} (ID: ${task.id})`
            }]
          };

        case 'update_task':
          const updatedTask = await this.storage.updateTask(args.id, args);
          if (!updatedTask) {
            throw new Error(`Task not found: ${args.id}`);
          }
          return {
            content: [{
              type: 'text',
              text: `Task updated: ${updatedTask.title}`
            }]
          };

        case 'create_handoff':
          const handOff = await this.storage.addHandOff({
            fromPersona: args.fromPersona,
            toPersona: args.toPersona,
            taskId: args.taskId,
            completedWork: args.completedWork,
            nextSteps: args.nextSteps,
            notes: args.notes,
            testStatus: args.testStatus,
            testRunSummary: args.testRunSummary,
            blockers: args.blockers
          });
          
          // Update current persona
          await this.storage.setCurrentPersona(args.toPersona);
          
          return {
            content: [{
              type: 'text',
              text: `Hand-off created: ${args.fromPersona} → ${args.toPersona}`
            }]
          };

        case 'set_current_persona':
          await this.storage.setCurrentPersona(args.persona);
          return {
            content: [{
              type: 'text',
              text: `Current persona set to: ${args.persona}`
            }]
          };

        case 'set_current_stage':
          await this.storage.setCurrentStage(args.stage);
          return {
            content: [{
              type: 'text',
              text: `Current stage set to: ${args.stage}`
            }]
          };

        case 'set_active_task':
          await this.storage.setActiveTaskId(args.taskId);
          return {
            content: [{
              type: 'text',
              text: `Active task set to: ${args.taskId}`
            }]
          };

        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    });
  }

  async run() {
    await this.storage.initialize();
    
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    
    console.error('MCP Coordinator Server running on stdio');
  }
}

const server = new MCPCoordinatorServer();
server.run().catch(console.error);
