import { promises as fs } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { ProjectIdentifier } from './project-identifier.js';
export class WorkflowStorage {
    dataDir;
    state;
    projectInfo = null;
    constructor(dataDir) {
        // Use system temp directory with a unique identifier
        this.dataDir = dataDir || join(tmpdir(), `mcp-coordinator-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`);
        this.state = {
            currentPersona: 'ARCHITECT',
            tasks: [],
            handOffs: []
        };
    }
    /**
     * Create a storage instance with temporary directory
     */
    static async createForProject() {
        return new WorkflowStorage();
    }
    async initialize() {
        try {
            // Load project info for better context
            this.projectInfo = await ProjectIdentifier.identifyProject();
            await fs.mkdir(this.dataDir, { recursive: true });
            await this.loadState();
        }
        catch (error) {
            console.warn('Failed to load existing state, starting fresh:', error);
        }
    }
    async loadState() {
        try {
            const stateFile = join(this.dataDir, 'state.json');
            const data = await fs.readFile(stateFile, 'utf-8');
            const parsedState = JSON.parse(data);
            // Validate and sanitize the loaded state
            this.state = {
                currentPersona: typeof parsedState.currentPersona === 'string' ? parsedState.currentPersona : 'ARCHITECT',
                tasks: Array.isArray(parsedState.tasks) ? parsedState.tasks : [],
                handOffs: Array.isArray(parsedState.handOffs) ? parsedState.handOffs : [],
                plan: parsedState.plan || undefined,
                currentStage: parsedState.currentStage || undefined,
                activeTaskId: parsedState.activeTaskId || undefined
            };
        }
        catch (error) {
            // File doesn't exist or is invalid, use default state
            this.state = {
                currentPersona: 'ARCHITECT',
                tasks: [],
                handOffs: []
            };
        }
    }
    async saveState() {
        try {
            await fs.mkdir(this.dataDir, { recursive: true });
            const stateFile = join(this.dataDir, 'state.json');
            await fs.writeFile(stateFile, JSON.stringify(this.state, null, 2));
        }
        catch (error) {
            console.warn('Failed to save state:', error);
            throw error;
        }
    }
    // Plan operations
    async getPlan() {
        return this.state.plan;
    }
    async setPlan(plan) {
        this.state.plan = plan;
        await this.saveState();
    }
    async updatePlan(updates) {
        if (!this.state.plan)
            return undefined;
        this.state.plan = {
            ...this.state.plan,
            ...updates,
            updatedAt: new Date().toISOString()
        };
        await this.saveState();
        return this.state.plan;
    }
    // Task operations
    async getTasks() {
        // Ensure tasks is always an array
        if (!Array.isArray(this.state.tasks)) {
            this.state.tasks = [];
        }
        return this.state.tasks;
    }
    async getTask(id) {
        return this.state.tasks.find(task => task.id === id);
    }
    async addTask(task) {
        // Ensure tasks is always an array
        if (!Array.isArray(this.state.tasks)) {
            this.state.tasks = [];
        }
        const newTask = {
            ...task,
            id: `task-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        };
        this.state.tasks.push(newTask);
        await this.saveState();
        return newTask;
    }
    async updateTask(id, updates) {
        const taskIndex = this.state.tasks.findIndex(task => task.id === id);
        if (taskIndex === -1)
            return undefined;
        this.state.tasks[taskIndex] = {
            ...this.state.tasks[taskIndex],
            ...updates,
            updatedAt: new Date().toISOString()
        };
        await this.saveState();
        return this.state.tasks[taskIndex];
    }
    // HandOff operations
    async getHandOffs() {
        // Ensure handOffs is always an array
        if (!Array.isArray(this.state.handOffs)) {
            this.state.handOffs = [];
        }
        return this.state.handOffs;
    }
    async addHandOff(handOff) {
        // Ensure handOffs is always an array
        if (!Array.isArray(this.state.handOffs)) {
            this.state.handOffs = [];
        }
        const newHandOff = {
            ...handOff,
            id: `handoff-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
            timestamp: new Date().toISOString()
        };
        this.state.handOffs.push(newHandOff);
        await this.saveState();
        return newHandOff;
    }
    async getLatestHandOff() {
        return this.state.handOffs[this.state.handOffs.length - 1];
    }
    // Workflow state operations
    async getCurrentPersona() {
        return this.state.currentPersona;
    }
    async setCurrentPersona(persona) {
        this.state.currentPersona = persona;
        await this.saveState();
    }
    async getCurrentStage() {
        return this.state.currentStage;
    }
    async setCurrentStage(stage) {
        this.state.currentStage = stage;
        await this.saveState();
    }
    async getActiveTaskId() {
        return this.state.activeTaskId;
    }
    async setActiveTaskId(taskId) {
        this.state.activeTaskId = taskId;
        await this.saveState();
    }
    async getFullState() {
        return { ...this.state };
    }
    /**
     * Get the data directory path
     */
    getDataDirectory() {
        return this.dataDir;
    }
    /**
     * Get the resolved absolute path to the state file
     * @returns The absolute path to the state.json file
     */
    getStateFilePath() {
        return join(this.dataDir, 'state.json');
    }
    /**
     * Get project information for this storage instance
     * @returns Project information or null if not initialized
     */
    getProjectInfo() {
        return this.projectInfo;
    }
}
//# sourceMappingURL=storage.js.map