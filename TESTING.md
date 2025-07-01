# NodeBOL CMS Testing Guide

This document provides comprehensive information about testing the NodeBOL CMS, including unit tests, integration tests, end-to-end tests, and COBOL-specific testing strategies.

## Table of Contents

1. [Overview](#overview)
2. [Test Structure](#test-structure)
3. [Running Tests](#running-tests)
4. [Test Types](#test-types)
5. [COBOL Testing](#cobol-testing)
6. [Test Data and Fixtures](#test-data-and-fixtures)
7. [Coverage and Quality](#coverage-and-quality)
8. [Continuous Integration](#continuous-integration)
9. [Troubleshooting](#troubleshooting)

## Overview

NodeBOL CMS uses a hybrid testing approach that combines:
- **Jest** for JavaScript/Node.js testing
- **COBOL-specific testing** for business logic
- **Integration tests** for Node.js ↔ COBOL communication
- **End-to-end tests** for complete workflows

## Test Structure

```
test/
├── setup.js                 # Global test setup
├── setup-unit.js           # Unit test setup
├── setup-integration.js    # Integration test setup
├── setup-e2e.js           # E2E test setup
├── fixtures/
│   ├── test-data.json     # Test data fixtures
│   └── test-template.cow  # Test template
├── unit/
│   ├── database.test.js   # Database unit tests
│   ├── database-api.test.js # API unit tests
│   └── cobol.test.js      # COBOL unit tests
├── integration/
│   └── nodebol-integration.test.js # Node.js ↔ COBOL tests
└── e2e/
    └── cms-workflow.test.js # Complete workflow tests
```

## Running Tests

### All Tests
```bash
npm test
```

### Specific Test Types
```bash
# Unit tests only
npm run test:unit

# Integration tests only
npm run test:integration

# End-to-end tests only
npm run test:e2e

# Watch mode for development
npm run test:watch

# Coverage report
npm run test:coverage

# CI mode (no watch, with coverage)
npm run test:ci
```

### Individual Test Files
```bash
# Run specific test file
npx jest test/unit/database.test.js

# Run tests matching pattern
npx jest --testNamePattern="should create user"

# Run tests in specific directory
npx jest test/unit/
```

## Test Types

### 1. Unit Tests (`test/unit/`)

Unit tests focus on testing individual components in isolation:

- **Database Tests** (`database.test.js`): Test MongoDB operations
- **API Tests** (`database-api.test.js`): Test HTTP API endpoints
- **COBOL Tests** (`cobol.test.js`): Test COBOL business logic

**Example Unit Test:**
```javascript
describe('NodeBOLDatabase', () => {
  test('should create user successfully', async () => {
    const userData = createTestUser();
    const result = await db.createUser(userData);
    
    expect(result.success).toBe(true);
    expect(result.userId).toBeTruthy();
  });
});
```

### 2. Integration Tests (`test/integration/`)

Integration tests verify the interaction between Node.js and COBOL components:

- **Node.js ↔ COBOL Communication**: Test data flow between layers
- **Database ↔ COBOL Interface**: Test database operations through COBOL
- **Template Engine Integration**: Test COBOL template processing

**Example Integration Test:**
```javascript
test('should handle user authentication flow', async () => {
  const authResult = await global.runCobolTest('auth', {
    username: 'admin',
    password: 'password'
  });

  expect(authResult.success).toBe(true);
  expect(mockCobolExecution).toHaveBeenCalledWith('auth', {
    username: 'admin',
    password: 'password'
  });
});
```

### 3. End-to-End Tests (`test/e2e/`)

E2E tests verify complete workflows from user interaction to final output:

- **Complete CMS Workflows**: Content creation, publishing, user management
- **Error Handling**: Graceful failure scenarios
- **Performance**: Concurrent operations and bulk processing

**Example E2E Test:**
```javascript
test('should handle complete content creation workflow', async () => {
  // Step 1: User authentication
  const authResult = await global.runCobolTest('auth', {
    username: 'admin',
    password: 'password'
  });

  // Step 2: Create content
  const contentResult = await global.runCobolTest('content-processor', contentData);

  // Step 3: Store in database
  const dbResult = await global.runCobolTest('database-interface', dbRequest);

  // Step 4: Render template
  const templateResult = await global.runCobolTest('template-engine', templateData);

  expect(authResult.success).toBe(true);
  expect(contentResult.success).toBe(true);
  expect(dbResult.success).toBe(true);
  expect(templateResult.success).toBe(true);
});
```

## COBOL Testing

### COBOL Test Runner

The `CobolTestRunner` class provides utilities for testing COBOL programs:

```javascript
class CobolTestRunner {
  async compileProgram(programPath) {
    // Compile COBOL program using GnuCOBOL
  }

  async runProgram(programName, inputData) {
    // Execute compiled COBOL program
  }

  async testTemplateEngine() {
    // Test template processing
  }

  async testDatabaseInterface() {
    // Test database operations
  }
}
```

### Mock COBOL Execution

When GnuCOBOL is not available, tests use mock COBOL execution:

```javascript
global.runCobolTest = jest.fn().mockResolvedValue({
  success: true,
  output: 'Mock COBOL output'
});
```

### COBOL Test Categories

1. **Template Engine Tests**: Variable substitution, conditionals, loops
2. **Database Interface Tests**: CRUD operations, queries, transactions
3. **Authentication Tests**: User login, session management
4. **Content Processing Tests**: Validation, transformation, storage

## Test Data and Fixtures

### Test Fixtures (`test/fixtures/`)

- **`test-data.json`**: Sample data for all test types
- **`test-template.cow`**: Template for testing template engine

### Test Data Helpers

Global helper functions create test data:

```javascript
// Create test user
const user = createTestUser({
  username: 'customuser',
  role: 'admin'
});

// Create test content
const content = createTestContent({
  title: 'Custom Title',
  contentType: 'blog_post'
});

// Create test media
const media = createTestMedia({
  filename: 'custom-file.jpg',
  mimeType: 'image/jpeg'
});
```

### Test Environment Setup

Each test type has its own setup file:

- **`setup-unit.js`**: Unit test environment (fast, isolated)
- **`setup-integration.js`**: Integration test environment (realistic delays)
- **`setup-e2e.js`**: E2E test environment (full simulation)

## Coverage and Quality

### Coverage Thresholds

The project enforces minimum coverage thresholds:

```javascript
coverageThreshold: {
  global: {
    branches: 70,
    functions: 70,
    lines: 70,
    statements: 70
  }
}
```

### Coverage Reports

Generate coverage reports:

```bash
npm run test:coverage
```

This creates:
- **Text report**: Console output
- **HTML report**: `coverage/lcov-report/index.html`
- **LCOV report**: For CI integration

### Code Quality

Tests help maintain code quality by:

- **Catching bugs early**: Unit tests catch issues in isolation
- **Preventing regressions**: Integration tests ensure components work together
- **Documenting behavior**: Tests serve as living documentation
- **Enabling refactoring**: Tests provide confidence when changing code

## Continuous Integration

### CI Configuration

The project includes CI-ready test scripts:

```bash
# CI mode (no watch, with coverage)
npm run test:ci
```

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:ci
      - run: npm run build
```

### Pre-commit Hooks

Consider adding pre-commit hooks:

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run test:unit",
      "pre-push": "npm run test:ci"
    }
  }
}
```

## Troubleshooting

### Common Issues

1. **COBOL Compilation Errors**
   ```bash
   # Install GnuCOBOL
   # Ubuntu/Debian
   sudo apt-get install gnucobol
   
   # macOS
   brew install gnu-cobol
   
   # Windows
   # Download from https://sourceforge.net/projects/gnucobol/
   ```

2. **MongoDB Connection Issues**
   ```bash
   # Start MongoDB for testing
   docker-compose up -d mongodb
   
   # Or use test database
   MONGODB_URI=mongodb://localhost:27017/nodebol_cms_test npm test
   ```

3. **Test Timeout Issues**
   ```javascript
   // Increase timeout for slow tests
   test('slow test', async () => {
     // Test code
   }, 30000); // 30 seconds
   ```

4. **Mock Issues**
   ```javascript
   // Clear mocks between tests
   beforeEach(() => {
     jest.clearAllMocks();
   });
   ```

### Debug Mode

Run tests in debug mode:

```bash
# Debug Jest
node --inspect-brk node_modules/.bin/jest --runInBand

# Debug specific test
node --inspect-brk node_modules/.bin/jest --runInBand --testNamePattern="should create user"
```

### Performance Testing

Monitor test performance:

```bash
# Run with performance profiling
npm run test -- --verbose --detectOpenHandles

# Check for memory leaks
npm run test -- --detectLeaks
```

## Best Practices

1. **Test Isolation**: Each test should be independent
2. **Descriptive Names**: Use clear, descriptive test names
3. **Arrange-Act-Assert**: Structure tests with clear sections
4. **Mock External Dependencies**: Don't rely on external services
5. **Test Data Management**: Use fixtures and helpers for consistent data
6. **Error Scenarios**: Test both success and failure cases
7. **Performance**: Keep tests fast and efficient
8. **Coverage**: Aim for high coverage but focus on critical paths

## Contributing

When adding new features:

1. **Write tests first** (TDD approach)
2. **Update test data** if needed
3. **Add integration tests** for new workflows
4. **Update documentation** for new test patterns
5. **Ensure CI passes** before merging

This testing strategy ensures NodeBOL CMS maintains high quality and reliability while supporting the unique hybrid architecture of COBOL and Node.js. 