import { WorkflowState, Task, HandOff, Plan } from './types.js';
export declare class SimpleWorkflowStorage {
    private stateFile;
    private state;
    private projectId;
    constructor(projectId?: string);
    static create(projectId?: string): Promise<SimpleWorkflowStorage>;
    initialize(): Promise<void>;
    private loadState;
    private saveState;
    getCurrentPersona(): Promise<string>;
    setCurrentPersona(persona: string): Promise<void>;
    getTasks(): Promise<Task[]>;
    addTask(task: Task): Promise<void>;
    updateTask(taskId: string, updates: Partial<Task>): Promise<void>;
    getTask(taskId: string): Promise<Task | undefined>;
    getHandOffs(): Promise<HandOff[]>;
    addHandOff(handOff: HandOff): Promise<void>;
    getLatestHandOff(): Promise<HandOff | undefined>;
    getPlan(): Promise<Plan | undefined>;
    setPlan(plan: Plan): Promise<void>;
    getActiveTaskId(): Promise<string | undefined>;
    setActiveTaskId(taskId: string | undefined): Promise<void>;
    getFullState(): Promise<WorkflowState>;
    getStateFilePath(): string;
    getProjectId(): string;
    cleanup(): Promise<void>;
}
//# sourceMappingURL=simple-storage.d.ts.map