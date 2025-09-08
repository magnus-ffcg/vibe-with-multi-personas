# MCP Coordinator Test Suite

This directory contains comprehensive tests for the mcp-coordinator MCP server.

## Test Structure

### Unit Tests
- **`storage.test.ts`** - Tests for the WorkflowStorage class
  - Data persistence and retrieval
  - Task lifecycle management
  - HandOff operations
  - Plan management
  - Error handling and recovery

- **`types.test.ts`** - Tests for TypeScript interfaces and type safety
  - Task interface validation
  - HandOff interface validation
  - Plan interface validation
  - WorkflowState interface validation
  - Type compatibility checks

- **`server.test.ts`** - Tests for MCP server functionality
  - Resource handlers (list/read)
  - Tool handlers (list/call)
  - Server lifecycle management
  - Error handling for invalid requests

### Integration Tests
- **`integration.test.ts`** - End-to-end workflow scenarios
  - Complete task lifecycle workflows
  - TDD workflow with red-green-refactor stages
  - Multi-persona handoff scenarios
  - Blocker resolution workflows
  - Concurrent task handling
  - Data persistence across restarts
  - Performance and scalability tests

## Running Tests

### Prerequisites
```bash
npm install
```

### Run All Tests
```bash
npm test
```

### Run Tests in Watch Mode
```bash
npm run test:watch
```

### Run Tests with Coverage
```bash
npm run test:coverage
```

### Run Specific Test Files
```bash
# Run only storage tests
npm test -- storage.test.ts

# Run only integration tests
npm test -- integration.test.ts
```

## Test Configuration

The test suite uses Jest with TypeScript support via ts-jest. Key configuration:

- **ESM Support**: Configured for ES modules compatibility
- **Test Environment**: Node.js environment
- **Coverage**: Collects coverage from all source files except index.ts
- **Setup**: Automatic cleanup of test directories after each test

## Test Data

Tests use isolated storage directories to prevent interference:
- `./.test-storage` - Used by storage tests
- `./.test-integration` - Used by integration tests
- `./.test-server-storage` - Used by server tests

These directories are automatically cleaned up after each test run.

## Coverage Goals

The test suite aims for comprehensive coverage:
- **Storage Layer**: 100% coverage of all CRUD operations
- **MCP Protocol**: All resource and tool handlers tested
- **Error Scenarios**: Comprehensive error handling validation
- **Integration**: Real-world workflow scenarios
- **Performance**: Scalability under load

## Test Scenarios Covered

### Workflow Scenarios
1. **Team Development Workflow**
   - ARCHITECT → CODER → TESTER → REVIEWER → QA → STAKEHOLDER
   - Task status transitions
   - Persona handoffs with context

2. **Strict TDD Workflow**
   - TEST_ARCHITECT → TEST_WRITER → CODER → STAKEHOLDER
   - Red-green-refactor cycle enforcement
   - Test status tracking

3. **Error Recovery**
   - Blocker identification and resolution
   - Workflow resumption after issues
   - Data corruption recovery

### Data Operations
- Plan creation and updates
- Task lifecycle management
- HandOff creation and retrieval
- Workflow state persistence
- Concurrent operations

### MCP Protocol Compliance
- Resource listing and reading
- Tool schema validation
- Tool execution with various parameters
- Error responses for invalid requests

## Adding New Tests

When adding new functionality to mcp-coordinator:

1. **Add Unit Tests** - Test individual functions/methods in isolation
2. **Add Integration Tests** - Test complete workflows that use the new functionality
3. **Update Type Tests** - If new interfaces are added
4. **Test Error Cases** - Ensure proper error handling

### Test Naming Convention
- Use descriptive test names: `should handle X when Y`
- Group related tests in `describe` blocks
- Use `beforeEach`/`afterEach` for setup/cleanup

### Mock Usage
- Mock external dependencies (MCP SDK, file system when needed)
- Use real storage for integration tests
- Clean up test data automatically

## Debugging Tests

### Common Issues
1. **Test Isolation**: Ensure tests don't share state
2. **Async Operations**: Use proper async/await patterns
3. **File System**: Clean up test directories
4. **Mocking**: Verify mocks are properly configured

### Debug Commands
```bash
# Run tests with verbose output
npm test -- --verbose

# Run a single test
npm test -- --testNamePattern="should handle complete task lifecycle"

# Debug with Node.js inspector
node --inspect-brk node_modules/.bin/jest --runInBand
```
