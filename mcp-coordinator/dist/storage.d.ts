import { WorkflowState, Task, HandOff, Plan } from './types.js';
import { ProjectInfo } from './project-identifier.js';
export declare class WorkflowStorage {
    private dataDir;
    private state;
    private projectInfo;
    constructor(dataDir?: string);
    /**
     * Create a storage instance with temporary directory
     */
    static createForProject(): Promise<WorkflowStorage>;
    initialize(): Promise<void>;
    private loadState;
    private saveState;
    getPlan(): Promise<Plan | undefined>;
    setPlan(plan: Plan): Promise<void>;
    updatePlan(updates: Partial<Plan>): Promise<Plan | undefined>;
    getTasks(): Promise<Task[]>;
    getTask(id: string): Promise<Task | undefined>;
    addTask(task: Omit<Task, 'id' | 'createdAt' | 'updatedAt'>): Promise<Task>;
    updateTask(id: string, updates: Partial<Task>): Promise<Task | undefined>;
    getHandOffs(): Promise<HandOff[]>;
    addHandOff(handOff: Omit<HandOff, 'id' | 'timestamp'>): Promise<HandOff>;
    getLatestHandOff(): Promise<HandOff | undefined>;
    getCurrentPersona(): Promise<string>;
    setCurrentPersona(persona: string): Promise<void>;
    getCurrentStage(): Promise<string | undefined>;
    setCurrentStage(stage: string | undefined): Promise<void>;
    getActiveTaskId(): Promise<string | undefined>;
    setActiveTaskId(taskId: string | undefined): Promise<void>;
    getFullState(): Promise<WorkflowState>;
    /**
     * Get the data directory path
     */
    getDataDirectory(): string;
    /**
     * Get the resolved absolute path to the state file
     * @returns The absolute path to the state.json file
     */
    getStateFilePath(): string;
    /**
     * Get project information for this storage instance
     * @returns Project information or null if not initialized
     */
    getProjectInfo(): ProjectInfo | null;
}
//# sourceMappingURL=storage.d.ts.map