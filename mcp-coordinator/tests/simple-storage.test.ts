import { SimpleWorkflowStorage } from '../src/simple-storage.js';
import { tmpdir } from 'os';
import { join } from 'path';

describe('SimpleWorkflowStorage', () => {
  let storage: SimpleWorkflowStorage;
  const testProjectId = 'test-project';

  beforeEach(async () => {
    storage = await SimpleWorkflowStorage.create(testProjectId);
  });

  afterEach(async () => {
    // Clean up temp files after each test
    await storage.cleanup();
  });

  it('should create storage with project-specific temp file', async () => {
    const stateFile = storage.getStateFilePath();
    expect(stateFile).toContain(tmpdir());
    expect(stateFile).toContain('mcp-coordinator-test-project.json');
    expect(storage.getProjectId()).toBe(testProjectId);
  });

  it('should manage personas', async () => {
    expect(await storage.getCurrentPersona()).toBe('ARCHITECT');
    
    await storage.setCurrentPersona('CODER');
    expect(await storage.getCurrentPersona()).toBe('CODER');
  });

  it('should manage tasks', async () => {
    const task = {
      id: 'test-task',
      title: 'Test Task',
      description: 'Test Description',
      status: 'backlog' as const,
      priority: 'high' as const,
      acceptanceCriteria: ['Test criteria'],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    await storage.addTask(task);
    const tasks = await storage.getTasks();
    expect(tasks).toHaveLength(1);
    expect(tasks[0].title).toBe('Test Task');

    await storage.updateTask('test-task', { status: 'in_progress' });
    const updatedTask = await storage.getTask('test-task');
    expect(updatedTask?.status).toBe('in_progress');
  });

  it('should manage handoffs', async () => {
    const handoff = {
      id: 'test-handoff',
      fromPersona: 'ARCHITECT',
      toPersona: 'CODER',
      completedWork: ['Analysis done'],
      nextSteps: ['Start coding'],
      notes: 'Ready to code',
      timestamp: new Date().toISOString()
    };

    await storage.addHandOff(handoff);
    const handoffs = await storage.getHandOffs();
    expect(handoffs).toHaveLength(1);
    expect(handoffs[0].fromPersona).toBe('ARCHITECT');

    const latest = await storage.getLatestHandOff();
    expect(latest?.id).toBe('test-handoff');
  });

  it('should persist state across instances', async () => {
    const stateFile = storage.getStateFilePath();
    
    await storage.setCurrentPersona('TESTER');
    await storage.addTask({
      id: 'persist-task',
      title: 'Persist Test',
      description: 'Test persistence',
      status: 'backlog',
      priority: 'medium',
      acceptanceCriteria: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    });

    // Create new storage instance with same project ID
    const newStorage = await SimpleWorkflowStorage.create(testProjectId);

    expect(await newStorage.getCurrentPersona()).toBe('TESTER');
    const tasks = await newStorage.getTasks();
    expect(tasks).toHaveLength(1);
    expect(tasks[0].title).toBe('Persist Test');

    // Clean up the new instance too
    await newStorage.cleanup();
  });

  it('should isolate projects by ID', async () => {
    // Create storage for project A
    const storageA = await SimpleWorkflowStorage.create('project-a');
    await storageA.setCurrentPersona('CODER');
    await storageA.addTask({
      id: 'task-a',
      title: 'Task A',
      description: 'Task for project A',
      status: 'backlog',
      priority: 'high',
      acceptanceCriteria: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    });

    // Create storage for project B
    const storageB = await SimpleWorkflowStorage.create('project-b');
    await storageB.setCurrentPersona('TESTER');
    await storageB.addTask({
      id: 'task-b',
      title: 'Task B',
      description: 'Task for project B',
      status: 'in_progress',
      priority: 'medium',
      acceptanceCriteria: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    });

    // Verify isolation
    expect(await storageA.getCurrentPersona()).toBe('CODER');
    expect(await storageB.getCurrentPersona()).toBe('TESTER');
    
    const tasksA = await storageA.getTasks();
    const tasksB = await storageB.getTasks();
    
    expect(tasksA).toHaveLength(1);
    expect(tasksB).toHaveLength(1);
    expect(tasksA[0].title).toBe('Task A');
    expect(tasksB[0].title).toBe('Task B');
    
    // Verify different state files
    expect(storageA.getStateFilePath()).toContain('project-a');
    expect(storageB.getStateFilePath()).toContain('project-b');
    expect(storageA.getStateFilePath()).not.toBe(storageB.getStateFilePath());

    // Clean up
    await storageA.cleanup();
    await storageB.cleanup();
  });
});
