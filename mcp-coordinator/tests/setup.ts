// Global test setup
import { promises as fs } from 'fs';
import { join } from 'path';

// Clean up test directories after each test
afterEach(async () => {
  const testDirs = ['./.workflow-state-test', './.test-storage', './.test-integration'];
  for (const dir of testDirs) {
    try {
      await fs.rm(dir, { recursive: true, force: true });
    } catch (error) {
      // Ignore errors if directory doesn't exist
    }
  }
});

// Mock console.error to avoid noise in test output
global.console = {
  ...console,
  error: jest.fn(),
  warn: jest.fn(),
};
