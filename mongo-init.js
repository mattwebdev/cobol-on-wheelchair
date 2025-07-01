// MongoDB initialization script for NodeBOL CMS
db = db.getSiblingDB('nodebol_cms');

// Create collections
db.createCollection('users');
db.createCollection('content');
db.createCollection('media');
db.createCollection('content_types');

// Create indexes for users collection
db.users.createIndex({ "username": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "status": 1 });

// Create indexes for content collection
db.content.createIndex({ "contentType": 1 });
db.content.createIndex({ "slug": 1 }, { unique: true });
db.content.createIndex({ "status": 1 });
db.content.createIndex({ "createdAt": -1 });
db.content.createIndex({ "author": 1 });

// Create indexes for media collection
db.media.createIndex({ "filename": 1 });
db.media.createIndex({ "uploadedBy": 1 });
db.media.createIndex({ "status": 1 });
db.media.createIndex({ "createdAt": -1 });

// Create indexes for content_types collection
db.content_types.createIndex({ "name": 1 }, { unique: true });

print('✅ NodeBOL CMS database initialized successfully');
print('📊 Collections created: users, content, media, content_types');
print('🔍 Indexes created for optimal performance'); 