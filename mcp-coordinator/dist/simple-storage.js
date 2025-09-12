import { promises as fs } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
export class SimpleWorkflowStorage {
    stateFile;
    state;
    projectId;
    constructor(projectId) {
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
    static async create(projectId) {
        const storage = new SimpleWorkflowStorage(projectId);
        await storage.initialize();
        return storage;
    }
    async initialize() {
        try {
            await this.loadState();
        }
        catch (error) {
            // File doesn't exist or is invalid, start fresh
            await this.saveState();
        }
    }
    async loadState() {
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
    async saveState() {
        await fs.writeFile(this.stateFile, JSON.stringify(this.state, null, 2));
    }
    // Persona management
    async getCurrentPersona() {
        return this.state.currentPersona;
    }
    async setCurrentPersona(persona) {
        this.state.currentPersona = persona;
        await this.saveState();
    }
    // Task management
    async getTasks() {
        return [...this.state.tasks];
    }
    async addTask(task) {
        this.state.tasks.push(task);
        await this.saveState();
    }
    async updateTask(taskId, updates) {
        const taskIndex = this.state.tasks.findIndex(t => t.id === taskId);
        if (taskIndex >= 0) {
            this.state.tasks[taskIndex] = { ...this.state.tasks[taskIndex], ...updates };
            await this.saveState();
        }
    }
    async getTask(taskId) {
        return this.state.tasks.find(t => t.id === taskId);
    }
    // Hand-off management
    async getHandOffs() {
        return [...this.state.handOffs];
    }
    async addHandOff(handOff) {
        this.state.handOffs.push(handOff);
        await this.saveState();
    }
    async getLatestHandOff() {
        return this.state.handOffs[this.state.handOffs.length - 1];
    }
    // Plan management
    async getPlan() {
        return this.state.plan;
    }
    async setPlan(plan) {
        this.state.plan = plan;
        await this.saveState();
    }
    // Active task
    async getActiveTaskId() {
        return this.state.activeTaskId;
    }
    async setActiveTaskId(taskId) {
        this.state.activeTaskId = taskId;
        await this.saveState();
    }
    // Get full state
    async getFullState() {
        return { ...this.state };
    }
    // Get temp file path for debugging
    getStateFilePath() {
        return this.stateFile;
    }
    // Get project ID
    getProjectId() {
        return this.projectId;
    }
    // Cleanup method for tests
    async cleanup() {
        try {
            const fs = await import('fs');
            await fs.promises.unlink(this.stateFile);
        }
        catch (error) {
            // File might not exist, ignore error
        }
    }
}
//# sourceMappingURL=simple-storage.js.map