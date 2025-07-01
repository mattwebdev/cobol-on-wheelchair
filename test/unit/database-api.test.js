const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');

// Mock the database module
jest.mock('../../src/database/mongodb');

const NodeBOLDatabase = require('../../src/database/mongodb');

describe('Database API', () => {
  let app;
  let mockDb;

  beforeEach(() => {
    // Create a fresh Express app for each test
    app = express();
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({ extended: true }));

    // Mock database instance
    mockDb = {
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

    NodeBOLDatabase.mockImplementation(() => mockDb);

    // Import and set up the database API routes
    const databaseApi = require('../../database-api');
    // Note: In a real implementation, you'd need to export the app from database-api.js
  });

  describe('POST /api/db', () => {
    test('should handle user authentication', async () => {
      const authData = {
        username: 'admin',
        password: 'password'
      };

      mockDb.authenticateUser.mockResolvedValue({
        success: true,
        user: {
          id: '1',
          username: 'admin',
          role: 'admin'
        }
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'user',
          operation: 'authenticate',
          data: authData
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(mockDb.authenticateUser).toHaveBeenCalledWith('admin', 'password');
    });

    test('should handle user creation', async () => {
      const userData = createTestUser();

      mockDb.createUser.mockResolvedValue({
        success: true,
        userId: '123'
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'user',
          operation: 'create',
          data: userData
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(mockDb.createUser).toHaveBeenCalledWith(userData);
    });

    test('should handle content creation', async () => {
      const contentData = createTestContent();

      mockDb.createContent.mockResolvedValue({
        success: true,
        contentId: '456'
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'content',
          operation: 'create',
          data: contentData
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(mockDb.createContent).toHaveBeenCalledWith(contentData);
    });

    test('should handle content retrieval', async () => {
      const mockContent = [createTestContent()];

      mockDb.getContent.mockResolvedValue({
        success: true,
        content: mockContent
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'content',
          operation: 'get-all'
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.content).toEqual(mockContent);
    });

    test('should handle media creation', async () => {
      const mediaData = createTestMedia();

      mockDb.createMedia.mockResolvedValue({
        success: true,
        mediaId: '789'
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'media',
          operation: 'create',
          data: mediaData
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(mockDb.createMedia).toHaveBeenCalledWith(mediaData);
    });

    test('should handle statistics retrieval', async () => {
      const mockStats = {
        blogCount: 5,
        pageCount: 3,
        userCount: 2,
        mediaCount: 12
      };

      mockDb.getStatistics.mockResolvedValue({
        success: true,
        statistics: mockStats
      });

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'statistics',
          operation: 'get'
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.statistics).toEqual(mockStats);
    });

    test('should handle invalid actions', async () => {
      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'invalid',
          operation: 'get'
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(false);
      expect(response.body.error).toBe('Invalid action');
    });

    test('should handle database errors', async () => {
      mockDb.createUser.mockRejectedValue(new Error('Database connection failed'));

      const response = await request(app)
        .post('/api/db')
        .send({
          action: 'user',
          operation: 'create',
          data: createTestUser()
        });

      expect(response.status).toBe(500);
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('Database connection failed');
    });
  });

  describe('GET /health', () => {
    test('should return health status', async () => {
      const response = await request(app).get('/health');

      expect(response.status).toBe(200);
      expect(response.body.status).toBe('ok');
      expect(response.body.timestamp).toBeDefined();
    });
  });
}); 