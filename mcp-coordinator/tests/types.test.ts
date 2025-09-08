import { Task, HandOff, Plan, WorkflowState } from '../src/types.js';

describe('Types', () => {
  describe('Task interface', () => {
    it('should accept valid task object', () => {
      const task: Task = {
        id: 'task-1',
        title: 'Test Task',
        description: 'A test task description',
        status: 'backlog',
        priority: 'high',
        acceptanceCriteria: ['Criteria 1', 'Criteria 2'],
        assignedPersona: 'CODER',
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      expect(task.id).toBe('task-1');
      expect(task.status).toBe('backlog');
      expect(task.priority).toBe('high');
    });

    it('should allow all valid status values', () => {
      const validStatuses: Task['status'][] = [
        'backlog',
        'in_progress',
        'coded',
        'tested',
        'reviewed',
        'qa',
        'ready_for_stakeholder',
        'complete'
      ];

      validStatuses.forEach(status => {
        const task: Task = {
          id: 'task-1',
          title: 'Test',
          description: 'Test',
          status,
          priority: 'medium',
          acceptanceCriteria: [],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-01T00:00:00Z'
        };
        expect(task.status).toBe(status);
      });
    });

    it('should allow all valid priority values', () => {
      const validPriorities: Task['priority'][] = ['low', 'medium', 'high'];

      validPriorities.forEach(priority => {
        const task: Task = {
          id: 'task-1',
          title: 'Test',
          description: 'Test',
          status: 'backlog',
          priority,
          acceptanceCriteria: [],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-01T00:00:00Z'
        };
        expect(task.priority).toBe(priority);
      });
    });

    it('should allow optional assignedPersona', () => {
      const taskWithPersona: Task = {
        id: 'task-1',
        title: 'Test',
        description: 'Test',
        status: 'backlog',
        priority: 'medium',
        acceptanceCriteria: [],
        assignedPersona: 'CODER',
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      const taskWithoutPersona: Task = {
        id: 'task-2',
        title: 'Test',
        description: 'Test',
        status: 'backlog',
        priority: 'medium',
        acceptanceCriteria: [],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      expect(taskWithPersona.assignedPersona).toBe('CODER');
      expect(taskWithoutPersona.assignedPersona).toBeUndefined();
    });
  });

  describe('HandOff interface', () => {
    it('should accept valid handoff object', () => {
      const handOff: HandOff = {
        id: 'handoff-1',
        fromPersona: 'ARCHITECT',
        toPersona: 'CODER',
        taskId: 'task-1',
        completedWork: ['Completed work 1', 'Completed work 2'],
        nextSteps: ['Next step 1', 'Next step 2'],
        notes: 'Some notes',
        testStatus: 'passing',
        testRunSummary: 'All tests passed',
        blockers: ['Blocker 1'],
        timestamp: '2023-01-01T00:00:00Z'
      };

      expect(handOff.fromPersona).toBe('ARCHITECT');
      expect(handOff.toPersona).toBe('CODER');
      expect(handOff.completedWork).toHaveLength(2);
      expect(handOff.nextSteps).toHaveLength(2);
    });

    it('should allow optional fields', () => {
      const minimalHandOff: HandOff = {
        id: 'handoff-1',
        fromPersona: 'ARCHITECT',
        toPersona: 'CODER',
        completedWork: ['Work done'],
        nextSteps: ['Next step'],
        notes: 'Notes',
        timestamp: '2023-01-01T00:00:00Z'
      };

      expect(minimalHandOff.taskId).toBeUndefined();
      expect(minimalHandOff.testStatus).toBeUndefined();
      expect(minimalHandOff.testRunSummary).toBeUndefined();
      expect(minimalHandOff.blockers).toBeUndefined();
    });

    it('should allow all valid test status values', () => {
      const validTestStatuses: HandOff['testStatus'][] = ['failing', 'passing', 'none'];

      validTestStatuses.forEach(testStatus => {
        const handOff: HandOff = {
          id: 'handoff-1',
          fromPersona: 'TESTER',
          toPersona: 'CODER',
          completedWork: ['Testing completed'],
          nextSteps: ['Fix issues'],
          notes: 'Test results',
          testStatus,
          timestamp: '2023-01-01T00:00:00Z'
        };
        expect(handOff.testStatus).toBe(testStatus);
      });
    });
  });

  describe('Plan interface', () => {
    it('should accept valid plan object', () => {
      const plan: Plan = {
        id: 'plan-1',
        title: 'Test Plan',
        description: 'A comprehensive test plan',
        architecture: {
          overview: 'System overview',
          components: ['Component A', 'Component B', 'Component C'],
          decisions: ['Decision 1', 'Decision 2']
        },
        requirements: ['Requirement 1', 'Requirement 2', 'Requirement 3'],
        constraints: ['Constraint 1', 'Constraint 2'],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      expect(plan.title).toBe('Test Plan');
      expect(plan.architecture.components).toHaveLength(3);
      expect(plan.requirements).toHaveLength(3);
      expect(plan.constraints).toHaveLength(2);
    });

    it('should require architecture object with correct structure', () => {
      const plan: Plan = {
        id: 'plan-1',
        title: 'Test Plan',
        description: 'Description',
        architecture: {
          overview: 'Overview text',
          components: ['Component 1'],
          decisions: ['Decision 1']
        },
        requirements: [],
        constraints: [],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      expect(plan.architecture.overview).toBeDefined();
      expect(Array.isArray(plan.architecture.components)).toBe(true);
      expect(Array.isArray(plan.architecture.decisions)).toBe(true);
    });

    it('should allow empty arrays for requirements and constraints', () => {
      const plan: Plan = {
        id: 'plan-1',
        title: 'Minimal Plan',
        description: 'A minimal plan',
        architecture: {
          overview: 'Simple overview',
          components: [],
          decisions: []
        },
        requirements: [],
        constraints: [],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      expect(plan.requirements).toEqual([]);
      expect(plan.constraints).toEqual([]);
      expect(plan.architecture.components).toEqual([]);
      expect(plan.architecture.decisions).toEqual([]);
    });
  });

  describe('WorkflowState interface', () => {
    it('should accept valid workflow state object', () => {
      const mockTask: Task = {
        id: 'task-1',
        title: 'Test Task',
        description: 'Description',
        status: 'backlog',
        priority: 'medium',
        acceptanceCriteria: ['Criteria'],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      const mockHandOff: HandOff = {
        id: 'handoff-1',
        fromPersona: 'ARCHITECT',
        toPersona: 'CODER',
        completedWork: ['Work done'],
        nextSteps: ['Next step'],
        notes: 'Notes',
        timestamp: '2023-01-01T00:00:00Z'
      };

      const mockPlan: Plan = {
        id: 'plan-1',
        title: 'Test Plan',
        description: 'Description',
        architecture: {
          overview: 'Overview',
          components: ['Component'],
          decisions: ['Decision']
        },
        requirements: ['Requirement'],
        constraints: ['Constraint'],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      const state: WorkflowState = {
        currentPersona: 'CODER',
        currentStage: 'red',
        activeTaskId: 'task-1',
        plan: mockPlan,
        tasks: [mockTask],
        handOffs: [mockHandOff]
      };

      expect(state.currentPersona).toBe('CODER');
      expect(state.currentStage).toBe('red');
      expect(state.activeTaskId).toBe('task-1');
      expect(state.plan).toEqual(mockPlan);
      expect(state.tasks).toHaveLength(1);
      expect(state.handOffs).toHaveLength(1);
    });

    it('should allow optional fields', () => {
      const minimalState: WorkflowState = {
        currentPersona: 'ARCHITECT',
        tasks: [],
        handOffs: []
      };

      expect(minimalState.currentStage).toBeUndefined();
      expect(minimalState.activeTaskId).toBeUndefined();
      expect(minimalState.plan).toBeUndefined();
      expect(minimalState.tasks).toEqual([]);
      expect(minimalState.handOffs).toEqual([]);
    });

    it('should require currentPersona, tasks, and handOffs', () => {
      const state: WorkflowState = {
        currentPersona: 'REVIEWER',
        tasks: [],
        handOffs: []
      };

      expect(state.currentPersona).toBeDefined();
      expect(Array.isArray(state.tasks)).toBe(true);
      expect(Array.isArray(state.handOffs)).toBe(true);
    });
  });

  describe('Type compatibility', () => {
    it('should allow task status transitions', () => {
      const task: Task = {
        id: 'task-1',
        title: 'Test',
        description: 'Test',
        status: 'backlog',
        priority: 'medium',
        acceptanceCriteria: [],
        createdAt: '2023-01-01T00:00:00Z',
        updatedAt: '2023-01-01T00:00:00Z'
      };

      // Simulate status transitions
      task.status = 'in_progress';
      expect(task.status).toBe('in_progress');

      task.status = 'coded';
      expect(task.status).toBe('coded');

      task.status = 'complete';
      expect(task.status).toBe('complete');
    });

    it('should allow handoff between different personas', () => {
      const personas = ['ARCHITECT', 'CODER', 'TESTER', 'REVIEWER', 'QA', 'STAKEHOLDER'];

      personas.forEach(fromPersona => {
        personas.forEach(toPersona => {
          if (fromPersona !== toPersona) {
            const handOff: HandOff = {
              id: `handoff-${fromPersona}-${toPersona}`,
              fromPersona,
              toPersona,
              completedWork: ['Work completed'],
              nextSteps: ['Next steps'],
              notes: 'Handoff notes',
              timestamp: '2023-01-01T00:00:00Z'
            };

            expect(handOff.fromPersona).toBe(fromPersona);
            expect(handOff.toPersona).toBe(toPersona);
          }
        });
      });
    });
  });
});
