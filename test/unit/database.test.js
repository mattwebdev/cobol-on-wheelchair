const NodeBOLDatabase = require('../../src/database/mongodb');

describe('NodeBOLDatabase', () => {
  let db;

  beforeEach(() => {
    db = new NodeBOLDatabase();
  });

  afterEach(async () => {
    if (db.client) {
      await db.close();
    }
  });

  describe('Connection', () => {
    test('should connect to MongoDB successfully', async () => {
      const connected = await db.connect();
      expect(connected).toBe(true);
      expect(db.client).toBeTruthy();
      expect(db.db).toBeTruthy();
    });

    test('should handle connection errors gracefully', async () => {
      // Test with invalid connection string
      const originalUri = process.env.MONGODB_URI;
      process.env.MONGODB_URI = 'mongodb://invalid:27017';
      
      const connected = await db.connect();
      expect(connected).toBe(false);
      
      // Restore original URI
      process.env.MONGODB_URI = originalUri;
    });
  });

  describe('User Management', () => {
    beforeEach(async () => {
      await db.connect();
    });

    test('should create user successfully', async () => {
      const userData = createTestUser();
      const result = await db.createUser(userData);
      
      expect(result.success).toBe(true);
      expect(result.userId).toBeTruthy();
    });

    test('should authenticate user with correct credentials', async () => {
      const userData = createTestUser();
      await db.createUser(userData);
      
      const result = await db.authenticateUser(userData.username, userData.password);
      
      expect(result.success).toBe(true);
      expect(result.user.username).toBe(userData.username);
      expect(result.user.role).toBe(userData.role);
    });

    test('should reject authentication with wrong password', async () => {
      const userData = createTestUser();
      await db.createUser(userData);
      
      const result = await db.authenticateUser(userData.username, 'wrongpassword');
      
      expect(result.success).toBe(false);
      expect(result.error).toContain('Invalid password');
    });

    test('should get all users', async () => {
      const user1 = createTestUser({ username: 'user1' });
      const user2 = createTestUser({ username: 'user2' });
      
      await db.createUser(user1);
      await db.createUser(user2);
      
      const result = await db.getUsers();
      
      expect(result.success).toBe(true);
      expect(result.users.length).toBeGreaterThanOrEqual(2);
    });
  });

  describe('Content Management', () => {
    beforeEach(async () => {
      await db.connect();
    });

    test('should create content successfully', async () => {
      const contentData = createTestContent();
      const result = await db.createContent(contentData);
      
      expect(result.success).toBe(true);
      expect(result.contentId).toBeTruthy();
    });

    test('should get content by type', async () => {
      const contentData = createTestContent();
      await db.createContent(contentData);
      
      const result = await db.getContent('blog_post');
      
      expect(result.success).toBe(true);
      expect(result.content.length).toBeGreaterThan(0);
      expect(result.content[0].contentType).toBe('blog_post');
    });

    test('should update content successfully', async () => {
      const contentData = createTestContent();
      const createResult = await db.createContent(contentData);
      
      const updateData = { title: 'Updated Title' };
      const result = await db.updateContent(createResult.contentId, updateData);
      
      expect(result.success).toBe(true);
      expect(result.modifiedCount).toBe(1);
    });

    test('should delete content successfully', async () => {
      const contentData = createTestContent();
      const createResult = await db.createContent(contentData);
      
      const result = await db.deleteContent(createResult.contentId);
      
      expect(result.success).toBe(true);
      expect(result.deletedCount).toBe(1);
    });
  });

  describe('Media Management', () => {
    beforeEach(async () => {
      await db.connect();
    });

    test('should create media successfully', async () => {
      const mediaData = createTestMedia();
      const result = await db.createMedia(mediaData);
      
      expect(result.success).toBe(true);
      expect(result.mediaId).toBeTruthy();
    });

    test('should get all media', async () => {
      const mediaData = createTestMedia();
      await db.createMedia(mediaData);
      
      const result = await db.getMedia();
      
      expect(result.success).toBe(true);
      expect(result.media.length).toBeGreaterThan(0);
    });
  });

  describe('Content Types', () => {
    beforeEach(async () => {
      await db.connect();
    });

    test('should get all content types', async () => {
      const result = await db.getContentTypes();
      
      expect(result.success).toBe(true);
      expect(result.contentTypes.length).toBeGreaterThan(0);
    });

    test('should get content type by name', async () => {
      const result = await db.getContentTypeByName('blog_post');
      
      expect(result.success).toBe(true);
      expect(result.contentType.name).toBe('blog_post');
    });
  });

  describe('Statistics', () => {
    beforeEach(async () => {
      await db.connect();
    });

    test('should get statistics successfully', async () => {
      const result = await db.getStatistics();
      
      expect(result.success).toBe(true);
      expect(result.statistics).toHaveProperty('blogCount');
      expect(result.statistics).toHaveProperty('pageCount');
      expect(result.statistics).toHaveProperty('userCount');
      expect(result.statistics).toHaveProperty('mediaCount');
    });
  });
}); 