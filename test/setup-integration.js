// Integration test setup for NodeBOL CMS
const path = require('path');

// Set up test environment
process.env.NODE_ENV = 'test';
process.env.MONGODB_URI = 'mongodb://localhost:27017/nodebol_cms_test_integration';
process.env.DB_API_PORT = '3002';

// Global test utilities for integration tests
global.TEST_TIMEOUT = 15000;
global.TEST_PORT = 3004;

// Mock console methods to reduce noise in integration tests
global.console = {
  ...console,
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};

// Test data helpers for integration tests
global.createTestUser = (overrides = {}) => ({
  username: 'testuser',
  email: 'test@example.com',
  password: 'password123',
  role: 'editor',
  status: 'active',
  ...overrides
});

global.createTestContent = (overrides = {}) => ({
  contentType: 'blog_post',
  title: 'Test Blog Post',
  content: 'This is test content',
  author: 'testuser',
  status: 'draft',
  ...overrides
});

global.createTestMedia = (overrides = {}) => ({
  filename: 'test-image.jpg',
  originalName: 'test-image.jpg',
  filePath: 'uploads/test-image.jpg',
  fileSize: 1024,
  mimeType: 'image/jpeg',
  uploadedBy: 'testuser',
  status: 'active',
  ...overrides
});

// Integration test COBOL execution (more realistic)
global.runCobolTest = async (programName, inputData) => {
  // Simulate COBOL execution with realistic delays
  return new Promise((resolve) => {
    setTimeout(() => {
      // Mock different COBOL program responses
      switch (programName) {
        case 'auth':
          resolve({
            success: true,
            output: JSON.stringify({
              success: true,
              user: {
                id: '1',
                username: inputData.username,
                role: 'admin',
                status: 'active'
              }
            })
          });
          break;
        case 'database-interface':
          resolve({
            success: true,
            output: JSON.stringify({
              success: true,
              data: [createTestContent()]
            })
          });
          break;
        case 'template-engine':
          resolve({
            success: true,
            output: '<html><body><h1>Test Output</h1></body></html>'
          });
          break;
        default:
          resolve({
            success: true,
            output: `Mock output from ${programName}`
          });
      }
    }, 100); // Simulate processing time
  });
};

// Load test fixtures
global.testData = require('./fixtures/test-data.json');

// Integration test utilities
global.setupTestDatabase = async () => {
  // This would set up a test database with sample data
  console.log('Setting up test database...');
};

global.cleanupTestDatabase = async () => {
  // This would clean up test database
  console.log('Cleaning up test database...');
}; 