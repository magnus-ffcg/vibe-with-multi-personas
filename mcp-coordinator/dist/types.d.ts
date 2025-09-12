export interface Task {
    id: string;
    title: string;
    description: string;
    status: 'backlog' | 'in_progress' | 'coded' | 'tested' | 'reviewed' | 'qa' | 'ready_for_stakeholder' | 'complete';
    priority: 'low' | 'medium' | 'high';
    acceptanceCriteria: string[];
    assignedPersona?: string;
    createdAt: string;
    updatedAt: string;
}
export interface HandOff {
    id: string;
    fromPersona: string;
    toPersona: string;
    taskId?: string;
    completedWork: string[];
    nextSteps: string[];
    notes: string;
    testStatus?: 'failing' | 'passing' | 'none';
    testRunSummary?: string;
    blockers?: string[];
    timestamp: string;
}
export interface Plan {
    id: string;
    title: string;
    description: string;
    architecture: {
        overview: string;
        components: string[];
        decisions: string[];
    };
    requirements: string[];
    constraints: string[];
    createdAt: string;
    updatedAt: string;
}
export interface WorkflowState {
    currentPersona: string;
    currentStage?: string;
    activeTaskId?: string;
    plan?: Plan;
    tasks: Task[];
    handOffs: HandOff[];
}
//# sourceMappingURL=types.d.ts.map