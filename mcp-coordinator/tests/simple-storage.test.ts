import { SimpleWorkflowStorage } from '../src/simple-storage.js';
import { tmpdir } from 'os';
import { join } from 'path';

describe('SimpleWorkflowStorage', () => {
  let storage: SimpleWorkflowStorage;

  beforeEach(async () => {
    storage = await SimpleWorkflowStorage.create();
  });

  afterEach(async () => {
    // Clean up temp files after each test
    await storage.cleanup();
  });

  it('should create storage with temp file', async () => {
    const stateFile = storage.getStateFilePath();
    expect(stateFile).toContain(tmpdir());
    expect(stateFile).toContain('mcp-coordinator-state.json');
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

    // Create new storage instance with same file
    const newStorage = new SimpleWorkflowStorage();
    newStorage['stateFile'] = stateFile; // Use same file
    await newStorage.initialize();

    expect(await newStorage.getCurrentPersona()).toBe('TESTER');
    const tasks = await newStorage.getTasks();
    expect(tasks).toHaveLength(1);
    expect(tasks[0].title).toBe('Persist Test');

    // Clean up the new instance too
    await newStorage.cleanup();
  });
});
