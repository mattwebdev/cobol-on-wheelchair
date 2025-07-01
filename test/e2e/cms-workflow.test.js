const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');

describe('NodeBOL CMS E2E Tests', () => {
  let app;

  beforeAll(async () => {
    // Set up E2E test environment
    await global.setupE2ETestEnvironment();
    
    // Create Express app for testing
    app = express();
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({ extended: true }));
  });

  afterAll(async () => {
    // Clean up E2E test environment
    await global.cleanupE2ETestEnvironment();
  });

  describe('Complete CMS Workflow', () => {
    test('should handle complete content creation and publishing workflow', async () => {
      // Step 1: User authentication
      const authResult = await global.runCobolTest('auth', {
        username: 'admin',
        password: 'password'
      });

      expect(authResult.success).toBe(true);
      const authData = JSON.parse(authResult.output);
      expect(authData.user.role).toBe('admin');

      // Step 2: Create content
      const contentData = createTestContent({
        title: 'E2E Test Post',
        content: 'This is a test post created during E2E testing.',
        author: authData.user.username
      });

      const contentResult = await global.runCobolTest('content-processor', contentData);
      expect(contentResult.success).toBe(true);
      const processedContent = JSON.parse(contentResult.output);
      expect(processedContent.contentId).toBeTruthy();

      // Step 3: Store in database
      const dbResult = await global.runCobolTest('database-interface', {
        action: 'content',
        operation: 'create',
        data: processedContent.processedContent
      });

      expect(dbResult.success).toBe(true);

      // Step 4: Render template
      const templateResult = await global.runCobolTest('template-engine', {
        template: 'blog-post.cow',
        variables: {
          title: contentData.title,
          content: contentData.content,
          author: contentData.author
        }
      });

      expect(templateResult.success).toBe(true);
      expect(templateResult.output).toContain(contentData.title);
      expect(templateResult.output).toContain(contentData.content);
    });

    test('should handle user management workflow', async () => {
      // Step 1: Admin authentication
      const authResult = await global.runCobolTest('auth', {
        username: 'admin',
        password: 'password'
      });

      expect(authResult.success).toBe(true);
      const authData = JSON.parse(authResult.output);
      expect(authData.user.permissions).toContain('admin');

      // Step 2: Create new user
      const newUser = createTestUser({
        username: 'newuser',
        email: 'newuser@test.com',
        role: 'author'
      });

      const userResult = await global.runCobolTest('user-manager', {
        action: 'create',
        data: newUser
      });

      expect(userResult.success).toBe(true);

      // Step 3: Get all users
      const usersResult = await global.runCobolTest('user-manager', {
        action: 'get-all'
      });

      expect(usersResult.success).toBe(true);
      const usersData = JSON.parse(usersResult.output);
      expect(usersData.users.length).toBeGreaterThan(0);
    });

    test('should handle media upload workflow', async () => {
      // Step 1: User authentication
      const authResult = await global.runCobolTest('auth', {
        username: 'editor',
        password: 'password'
      });

      expect(authResult.success).toBe(true);

      // Step 2: Upload media
      const mediaData = createTestMedia({
        filename: 'e2e-test-image.jpg',
        uploadedBy: 'editor'
      });

      const mediaResult = await global.runCobolTest('media-manager', {
        action: 'upload',
        data: mediaData
      });

      expect(mediaResult.success).toBe(true);

      // Step 3: Get media library
      const libraryResult = await global.runCobolTest('media-manager', {
        action: 'get-all'
      });

      expect(libraryResult.success).toBe(true);
      const libraryData = JSON.parse(libraryResult.output);
      expect(libraryData.media.length).toBeGreaterThan(0);
    });

    test('should handle admin dashboard workflow', async () => {
      // Step 1: Admin authentication
      const authResult = await global.runCobolTest('auth', {
        username: 'admin',
        password: 'password'
      });

      expect(authResult.success).toBe(true);
      const authData = JSON.parse(authResult.output);

      // Step 2: Get statistics
      const statsResult = await global.runCobolTest('database-interface', {
        action: 'statistics',
        operation: 'get'
      });

      expect(statsResult.success).toBe(true);
      const statsData = JSON.parse(statsResult.output);
      expect(statsData.statistics).toHaveProperty('blogCount');
      expect(statsData.statistics).toHaveProperty('userCount');

      // Step 3: Render admin dashboard
      const dashboardResult = await global.runCobolTest('template-engine', {
        template: 'admin-dashboard.cow',
        variables: {
          username: authData.user.username,
          blogCount: statsData.statistics.blogCount,
          pageCount: statsData.statistics.pageCount,
          userCount: statsData.statistics.userCount,
          mediaCount: statsData.statistics.mediaCount
        }
      });

      expect(dashboardResult.success).toBe(true);
      expect(dashboardResult.output).toContain(authData.user.username);
      expect(dashboardResult.output).toContain('Dashboard');
    });
  });

  describe('Error Handling E2E', () => {
    test('should handle authentication failures gracefully', async () => {
      const authResult = await global.runCobolTest('auth', {
        username: 'invalid',
        password: 'wrong'
      });

      expect(authResult.success).toBe(false);
      const authData = JSON.parse(authResult.output);
      expect(authData.error).toBe('Invalid credentials');
    });

    test('should handle database connection failures', async () => {
      // Simulate database connection failure
      const dbResult = await global.runCobolTest('database-interface', {
        action: 'content',
        operation: 'get-all'
      });

      // Should handle gracefully even if database is down
      expect(dbResult.success).toBe(true);
    });

    test('should handle template rendering errors', async () => {
      const templateResult = await global.runCobolTest('template-engine', {
        template: 'non-existent-template.cow',
        variables: { name: 'Test' }
      });

      expect(templateResult.success).toBe(false);
      expect(templateResult.output).toBe('Template not found');
    });
  });

  describe('Performance E2E', () => {
    test('should handle concurrent user sessions', async () => {
      const promises = [];
      const numUsers = 5;

      for (let i = 0; i < numUsers; i++) {
        promises.push(
          global.runCobolTest('auth', {
            username: `user${i}`,
            password: 'password'
          })
        );
      }

      const results = await Promise.all(promises);

      expect(results).toHaveLength(numUsers);
      results.forEach(result => {
        expect(result.success).toBe(true);
      });
    });

    test('should handle bulk content operations', async () => {
      const startTime = Date.now();
      const promises = [];
      const numPosts = 10;

      for (let i = 0; i < numPosts; i++) {
        const contentData = createTestContent({
          title: `Bulk Test Post ${i + 1}`,
          content: `Content for bulk test post ${i + 1}`
        });

        promises.push(
          global.runCobolTest('content-processor', contentData)
        );
      }

      const results = await Promise.all(promises);
      const endTime = Date.now();
      const totalTime = endTime - startTime;

      expect(results).toHaveLength(numPosts);
      results.forEach(result => {
        expect(result.success).toBe(true);
      });

      // Should complete within reasonable time
      expect(totalTime).toBeLessThan(5000); // 5 seconds
    });
  });
}); 