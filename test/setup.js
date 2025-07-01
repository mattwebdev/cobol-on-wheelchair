// Global test setup for NodeBOL CMS
const path = require('path');

// Set up test environment
process.env.NODE_ENV = 'test';
process.env.MONGODB_URI = 'mongodb://localhost:27017/nodebol_cms_test';
process.env.DB_API_PORT = '3002';

// Global test utilities
global.TEST_TIMEOUT = 10000;
global.TEST_PORT = 3003;

// Mock console methods to reduce noise in tests
global.console = {
  ...console,
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};

// Test data helpers
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

// COBOL test helper (for integration tests)
global.runCobolTest = async (programName, inputData) => {
  // This would execute COBOL programs for testing
  // Implementation depends on your COBOL testing strategy
  return new Promise((resolve) => {
    // Mock COBOL execution for now
    setTimeout(() => {
      resolve({
        success: true,
        output: `Mock COBOL output from ${programName}`,
        data: inputData
      });
    }, 100);
  });
}; 