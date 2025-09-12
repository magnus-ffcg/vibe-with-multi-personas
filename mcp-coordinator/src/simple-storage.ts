import { promises as fs } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { WorkflowState, Task, HandOff, Plan } from './types.js';

export class SimpleWorkflowStorage {
  private stateFile: string;
  private state: WorkflowState;
  private projectId: string;

  constructor(projectId?: string) {
    // Use project-specific state file for isolation
    this.projectId = projectId || 'default';
    const safeProjectId = this.projectId.replace(/[^a-zA-Z0-9-_]/g, '_');
    this.stateFile = join(tmpdir(), `mcp-coordinator-${safeProjectId}.json`);
    this.state = {
      currentPersona: 'ARCHITECT',
      tasks: [],
      handOffs: []
    };
  }

  static async create(projectId?: string): Promise<SimpleWorkflowStorage> {
    const storage = new SimpleWorkflowStorage(projectId);
    await storage.initialize();
    return storage;
  }

  async initialize(): Promise<void> {
    try {
      await this.loadState();
    } catch (error) {
      // File doesn't exist or is invalid, start fresh
      await this.saveState();
    }
  }

  private async loadState(): Promise<void> {
    const data = await fs.readFile(this.stateFile, 'utf-8');
    const parsedState = JSON.parse(data);
    
    this.state = {
      currentPersona: parsedState.currentPersona || 'ARCHITECT',
      tasks: parsedState.tasks || [],
      handOffs: parsedState.handOffs || [],
      plan: parsedState.plan,
      activeTaskId: parsedState.activeTaskId
    };
  }

  private async saveState(): Promise<void> {
    await fs.writeFile(this.stateFile, JSON.stringify(this.state, null, 2));
  }

  // Persona management
  async getCurrentPersona(): Promise<string> {
    return this.state.currentPersona;
  }

  async setCurrentPersona(persona: string): Promise<void> {
    this.state.currentPersona = persona;
    await this.saveState();
  }

  // Task management
  async getTasks(): Promise<Task[]> {
    return [...this.state.tasks];
  }

  async addTask(task: Task): Promise<void> {
    this.state.tasks.push(task);
    await this.saveState();
  }

  async updateTask(taskId: string, updates: Partial<Task>): Promise<void> {
    const taskIndex = this.state.tasks.findIndex(t => t.id === taskId);
    if (taskIndex >= 0) {
      this.state.tasks[taskIndex] = { ...this.state.tasks[taskIndex], ...updates };
      await this.saveState();
    }
  }

  async getTask(taskId: string): Promise<Task | undefined> {
    return this.state.tasks.find(t => t.id === taskId);
  }

  // Hand-off management
  async getHandOffs(): Promise<HandOff[]> {
    return [...this.state.handOffs];
  }

  async addHandOff(handOff: HandOff): Promise<void> {
    this.state.handOffs.push(handOff);
    await this.saveState();
  }

  async getLatestHandOff(): Promise<HandOff | undefined> {
    return this.state.handOffs[this.state.handOffs.length - 1];
  }

  // Plan management
  async getPlan(): Promise<Plan | undefined> {
    return this.state.plan;
  }

  async setPlan(plan: Plan): Promise<void> {
    this.state.plan = plan;
    await this.saveState();
  }

  // Active task
  async getActiveTaskId(): Promise<string | undefined> {
    return this.state.activeTaskId;
  }

  async setActiveTaskId(taskId: string | undefined): Promise<void> {
    this.state.activeTaskId = taskId;
    await this.saveState();
  }

  // Get full state
  async getFullState(): Promise<WorkflowState> {
    return { ...this.state };
  }

  // Get temp file path for debugging
  getStateFilePath(): string {
    return this.stateFile;
  }

  // Get project ID
  getProjectId(): string {
    return this.projectId;
  }

  // Cleanup method for tests
  async cleanup(): Promise<void> {
    try {
      const fs = await import('fs');
      await fs.promises.unlink(this.stateFile);
    } catch (error) {
      // File might not exist, ignore error
    }
  }
}
