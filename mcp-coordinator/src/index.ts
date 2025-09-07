#!/usr/bin/env node

import { WorkflowStorage } from './storage.js';
import { Task, HandOff, Plan } from './types.js';

// MCP Protocol types
interface MCPRequest {
  jsonrpc: '2.0';
  id: string | number;
  method: string;
  params?: any;
}

interface MCPResponse {
  jsonrpc: '2.0';
  id: string | number;
  result?: any;
  error?: {
    code: number;
    message: string;
    data?: any;
  };
}

class MCPCoordinatorServer {
  private storage: WorkflowStorage;

  constructor() {
    this.storage = new WorkflowStorage();
  }

  private createResponse(id: string | number, result?: any, error?: any): MCPResponse {
    if (error) {
      return {
        jsonrpc: '2.0',
        id,
        error: {
          code: -32000,
          message: error.message || 'Internal error',
          data: error
        }
      };
    }
    return {
      jsonrpc: '2.0',
      id,
      result
    };
  }

  private async handleListResources(): Promise<any> {
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
  }

  private async handleReadResource(request: MCPRequest): Promise<any> {
    const uri = request.params?.uri;
    if (!uri) {
      throw new Error('URI parameter is required');
    }

    let content;
    switch (uri) {
      case 'workflow://plan':
        content = await this.storage.getPlan();
        break;
      case 'workflow://backlog':
        content = await this.storage.getTasks();
        break;
      case 'workflow://handoffs':
        content = await this.storage.getLatestHandOff();
        break;
      case 'workflow://handoffs/history':
        content = await this.storage.getHandOffs();
        break;
      default:
        throw new Error(`Unknown resource: ${uri}`);
    }

    return {
      contents: [
        {
          uri,
          mimeType: 'application/json',
          text: JSON.stringify(content, null, 2)
        }
      ]
    };
  }

  private async handleListTools(): Promise<any> {
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
              constraints: { type: 'array', items: { type: 'string' }, description: 'Project constraints' }
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
              priority: { type: 'string', enum: ['high', 'medium', 'low'], description: 'Task priority' }
            },
            required: ['title', 'description', 'acceptanceCriteria', 'priority']
          }
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
              notes: { type: 'string', description: 'Update notes' }
            },
            required: ['taskId']
          }
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
              blockers: { type: 'array', items: { type: 'string' }, description: 'Any blockers encountered' }
            },
            required: ['fromPersona', 'toPersona', 'taskId', 'completedWork', 'nextSteps']
          }
        },
        {
          name: 'get_current_persona',
          description: 'Get the current active persona',
          inputSchema: {
            type: 'object',
            properties: {}
          }
        },
        {
          name: 'set_current_persona',
          description: 'Set the current active persona',
          inputSchema: {
            type: 'object',
            properties: {
              persona: { type: 'string', description: 'Persona name' }
            },
            required: ['persona']
          }
        }
      ]
    };
  }

  private async handleCallTool(request: MCPRequest): Promise<any> {
    const toolName = request.params?.name;
    const args = request.params?.arguments || {};

    switch (toolName) {
      case 'create_plan': {
        const plan: Plan = {
          id: Date.now().toString(),
          title: args.title,
          description: args.description,
          requirements: args.requirements || [],
          architecture: args.architecture || { overview: '', components: [], decisions: [] },
          constraints: args.constraints || [],
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        };
        await this.storage.setPlan(plan);
        return { content: [{ type: 'text', text: `Plan created: ${plan.title}` }] };
      }

      case 'add_task': {
        const task = {
          title: args.title,
          description: args.description,
          acceptanceCriteria: args.acceptanceCriteria,
          priority: args.priority,
          status: 'backlog' as const
        };
        await this.storage.addTask(task);
        return { content: [{ type: 'text', text: `Task added: ${task.title}` }] };
      }

      case 'update_task': {
        const updated = await this.storage.updateTask(args.taskId, {
          status: args.status,
          assignedPersona: args.assignedPersona
        });
        if (!updated) {
          throw new Error(`Task not found: ${args.taskId}`);
        }
        return { content: [{ type: 'text', text: `Task updated: ${updated.title}` }] };
      }

      case 'create_handoff': {
        const handoff = {
          fromPersona: args.fromPersona,
          toPersona: args.toPersona,
          taskId: args.taskId,
          completedWork: Array.isArray(args.completedWork) ? args.completedWork : [args.completedWork],
          nextSteps: Array.isArray(args.nextSteps) ? args.nextSteps : [args.nextSteps],
          notes: args.notes || '',
          blockers: args.blockers ? (Array.isArray(args.blockers) ? args.blockers : [args.blockers]) : []
        };
        await this.storage.addHandOff(handoff);
        return { content: [{ type: 'text', text: `Hand-off created: ${args.fromPersona} → ${args.toPersona}` }] };
      }

      case 'get_current_persona': {
        const persona = await this.storage.getCurrentPersona();
        return { content: [{ type: 'text', text: persona || 'No current persona set' }] };
      }

      case 'set_current_persona': {
        await this.storage.setCurrentPersona(args.persona);
        return { content: [{ type: 'text', text: `Current persona set to: ${args.persona}` }] };
      }

      default:
        throw new Error(`Unknown tool: ${toolName}`);
    }
  }

  private async processRequest(request: MCPRequest): Promise<MCPResponse> {
    try {
      let result;
      
      switch (request.method) {
        case 'resources/list':
          result = await this.handleListResources();
          break;
        case 'resources/read':
          result = await this.handleReadResource(request);
          break;
        case 'tools/list':
          result = await this.handleListTools();
          break;
        case 'tools/call':
          result = await this.handleCallTool(request);
          break;
        default:
          throw new Error(`Unknown method: ${request.method}`);
      }

      return this.createResponse(request.id, result);
    } catch (error: any) {
      return this.createResponse(request.id, undefined, error);
    }
  }

  async run(): Promise<void> {
    process.stdin.setEncoding('utf8');
    
    let buffer = '';
    
    process.stdin.on('data', async (chunk: string) => {
      buffer += chunk;
      
      // Process complete JSON-RPC messages
      let newlineIndex;
      while ((newlineIndex = buffer.indexOf('\n')) !== -1) {
        const line = buffer.slice(0, newlineIndex).trim();
        buffer = buffer.slice(newlineIndex + 1);
        
        if (line) {
          try {
            const request: MCPRequest = JSON.parse(line);
            const response = await this.processRequest(request);
            process.stdout.write(JSON.stringify(response) + '\n');
          } catch (error) {
            console.error('Error processing request:', error);
          }
        }
      }
    });

    console.error('MCP Coordinator Server running on stdio');
  }
}

// Start the server
const server = new MCPCoordinatorServer();
server.run().catch(console.error);
