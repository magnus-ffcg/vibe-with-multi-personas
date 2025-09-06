import { promises as fs } from 'fs';
import { join } from 'path';
import { WorkflowState, Task, HandOff, Plan } from './types.js';

export class WorkflowStorage {
  private dataDir: string;
  private state: WorkflowState;

  constructor(dataDir: string = './.workflow-state') {
    this.dataDir = dataDir;
    this.state = {
      currentPersona: 'ARCHITECT',
      tasks: [],
      handOffs: []
    };
  }

  async initialize(): Promise<void> {
    try {
      await fs.mkdir(this.dataDir, { recursive: true });
      await this.loadState();
    } catch (error) {
      console.warn('Failed to load existing state, starting fresh:', error);
    }
  }

  private async loadState(): Promise<void> {
    try {
      const stateFile = join(this.dataDir, 'state.json');
      const data = await fs.readFile(stateFile, 'utf-8');
      this.state = JSON.parse(data);
    } catch (error) {
      // File doesn't exist or is invalid, use default state
    }
  }

  private async saveState(): Promise<void> {
    const stateFile = join(this.dataDir, 'state.json');
    await fs.writeFile(stateFile, JSON.stringify(this.state, null, 2));
  }

  // Plan operations
  async getPlan(): Promise<Plan | undefined> {
    return this.state.plan;
  }

  async setPlan(plan: Plan): Promise<void> {
    this.state.plan = plan;
    await this.saveState();
  }

  async updatePlan(updates: Partial<Plan>): Promise<Plan | undefined> {
    if (!this.state.plan) return undefined;
    
    this.state.plan = {
      ...this.state.plan,
      ...updates,
      updatedAt: new Date().toISOString()
    };
    await this.saveState();
    return this.state.plan;
  }

  // Task operations
  async getTasks(): Promise<Task[]> {
    return this.state.tasks;
  }

  async getTask(id: string): Promise<Task | undefined> {
    return this.state.tasks.find(task => task.id === id);
  }

  async addTask(task: Omit<Task, 'id' | 'createdAt' | 'updatedAt'>): Promise<Task> {
    const newTask: Task = {
      ...task,
      id: `task-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    
    this.state.tasks.push(newTask);
    await this.saveState();
    return newTask;
  }

  async updateTask(id: string, updates: Partial<Task>): Promise<Task | undefined> {
    const taskIndex = this.state.tasks.findIndex(task => task.id === id);
    if (taskIndex === -1) return undefined;

    this.state.tasks[taskIndex] = {
      ...this.state.tasks[taskIndex],
      ...updates,
      updatedAt: new Date().toISOString()
    };
    
    await this.saveState();
    return this.state.tasks[taskIndex];
  }

  // HandOff operations
  async getHandOffs(): Promise<HandOff[]> {
    return this.state.handOffs;
  }

  async addHandOff(handOff: Omit<HandOff, 'id' | 'timestamp'>): Promise<HandOff> {
    const newHandOff: HandOff = {
      ...handOff,
      id: `handoff-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      timestamp: new Date().toISOString()
    };
    
    this.state.handOffs.push(newHandOff);
    await this.saveState();
    return newHandOff;
  }

  async getLatestHandOff(): Promise<HandOff | undefined> {
    return this.state.handOffs[this.state.handOffs.length - 1];
  }

  // Workflow state operations
  async getCurrentPersona(): Promise<string> {
    return this.state.currentPersona;
  }

  async setCurrentPersona(persona: string): Promise<void> {
    this.state.currentPersona = persona;
    await this.saveState();
  }

  async getCurrentStage(): Promise<string | undefined> {
    return this.state.currentStage;
  }

  async setCurrentStage(stage: string | undefined): Promise<void> {
    this.state.currentStage = stage;
    await this.saveState();
  }

  async getActiveTaskId(): Promise<string | undefined> {
    return this.state.activeTaskId;
  }

  async setActiveTaskId(taskId: string | undefined): Promise<void> {
    this.state.activeTaskId = taskId;
    await this.saveState();
  }

  async getFullState(): Promise<WorkflowState> {
    return { ...this.state };
  }
}
