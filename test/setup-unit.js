// Unit test setup for NodeBOL CMS
const path = require('path');

// Set up test environment
process.env.NODE_ENV = 'test';
process.env.MONGODB_URI = 'mongodb://localhost:27017/nodebol_cms_test_unit';
process.env.DB_API_PORT = '3002';

// Global test utilities for unit tests
global.TEST_TIMEOUT = 5000;
global.TEST_PORT = 3003;

// Mock console methods to reduce noise in unit tests
global.console = {
  ...console,
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};

// Test data helpers for unit tests
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

// Mock database for unit tests
global.mockDatabase = {
  createUser: jest.fn(),
  authenticateUser: jest.fn(),
  getUsers: jest.fn(),
  createContent: jest.fn(),
  getContent: jest.fn(),
  updateContent: jest.fn(),
  deleteContent: jest.fn(),
  createMedia: jest.fn(),
  getMedia: jest.fn(),
  getContentTypes: jest.fn(),
  getStatistics: jest.fn(),
  connect: jest.fn(),
  close: jest.fn()
};

// Mock COBOL execution for unit tests
global.runCobolTest = jest.fn().mockResolvedValue({
  success: true,
  output: 'Mock COBOL output'
});

// Load test fixtures
global.testData = require('./fixtures/test-data.json'); 