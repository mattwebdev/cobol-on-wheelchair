const { MongoClient, ObjectId } = require('mongodb');
const bcrypt = require('bcryptjs');

class NodeBOLDatabase {
    constructor() {
        this.client = null;
        this.db = null;
        this.collections = {
            users: null,
            content: null,
            media: null,
            contentTypes: null
        };
    }

    async connect() {
        try {
            const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017';
            this.client = new MongoClient(uri);
            await this.client.connect();
            
            this.db = this.client.db('nodebol_cms');
            
            // Initialize collections
            this.collections.users = this.db.collection('users');
            this.collections.content = this.db.collection('content');
            this.collections.media = this.db.collection('media');
            this.collections.contentTypes = this.db.collection('content_types');
            
            // Create indexes
            await this.createIndexes();
            
            // Initialize default data
            await this.initializeDefaultData();
            
            console.log('✅ MongoDB connected successfully');
            return true;
        } catch (error) {
            console.error('❌ MongoDB connection failed:', error);
            return false;
        }
    }

    async createIndexes() {
        try {
            // Users collection indexes
            await this.collections.users.createIndex({ username: 1 }, { unique: true });
            await this.collections.users.createIndex({ email: 1 }, { unique: true });
            
            // Content collection indexes
            await this.collections.content.createIndex({ contentType: 1 });
            await this.collections.content.createIndex({ slug: 1 }, { unique: true });
            await this.collections.content.createIndex({ status: 1 });
            await this.collections.content.createIndex({ createdAt: -1 });
            
            // Media collection indexes
            await this.collections.media.createIndex({ filename: 1 });
            await this.collections.media.createIndex({ uploadedBy: 1 });
            await this.collections.media.createIndex({ status: 1 });
            
            console.log('✅ Database indexes created');
        } catch (error) {
            console.error('❌ Index creation failed:', error);
        }
    }

    async initializeDefaultData() {
        try {
            // Check if admin user exists
            const adminExists = await this.collections.users.findOne({ username: 'admin' });
            if (!adminExists) {
                const hashedPassword = await bcrypt.hash('password', 10);
                await this.collections.users.insertOne({
                    username: 'admin',
                    email: 'admin@nodebol-cms.com',
                    password: hashedPassword,
                    role: 'admin',
                    status: 'active',
                    createdAt: new Date(),
                    updatedAt: new Date()
                });
                console.log('✅ Default admin user created');
            }

            // Initialize content types
            const contentTypes = [
                {
                    name: 'blog_post',
                    label: 'Blog Post',
                    fields: [
                        { name: 'title', label: 'Title', type: 'text', required: true },
                        { name: 'content', label: 'Content', type: 'textarea', required: true },
                        { name: 'excerpt', label: 'Excerpt', type: 'textarea', required: false },
                        { name: 'author', label: 'Author', type: 'text', required: true },
                        { name: 'publishDate', label: 'Publish Date', type: 'date', required: false },
                        { name: 'status', label: 'Status', type: 'select', required: true, options: ['draft', 'published', 'archived'] }
                    ],
                    createdAt: new Date()
                },
                {
                    name: 'page',
                    label: 'Page',
                    fields: [
                        { name: 'title', label: 'Title', type: 'text', required: true },
                        { name: 'content', label: 'Content', type: 'textarea', required: true },
                        { name: 'slug', label: 'URL Slug', type: 'text', required: true },
                        { name: 'status', label: 'Status', type: 'select', required: true, options: ['draft', 'published', 'archived'] }
                    ],
                    createdAt: new Date()
                }
            ];

            for (const contentType of contentTypes) {
                const exists = await this.collections.contentTypes.findOne({ name: contentType.name });
                if (!exists) {
                    await this.collections.contentTypes.insertOne(contentType);
                }
            }

            console.log('✅ Default content types initialized');
        } catch (error) {
            console.error('❌ Default data initialization failed:', error);
        }
    }

    // User Management
    async createUser(userData) {
        try {
            const hashedPassword = await bcrypt.hash(userData.password, 10);
            const user = {
                ...userData,
                password: hashedPassword,
                createdAt: new Date(),
                updatedAt: new Date()
            };
            
            const result = await this.collections.users.insertOne(user);
            return { success: true, userId: result.insertedId };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async authenticateUser(username, password) {
        try {
            const user = await this.collections.users.findOne({ username, status: 'active' });
            if (!user) {
                return { success: false, error: 'User not found' };
            }

            const isValid = await bcrypt.compare(password, user.password);
            if (!isValid) {
                return { success: false, error: 'Invalid password' };
            }

            return { 
                success: true, 
                user: {
                    id: user._id,
                    username: user.username,
                    email: user.email,
                    role: user.role
                }
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getUsers() {
        try {
            const users = await this.collections.users.find({}, { password: 0 }).toArray();
            return { success: true, users };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // Content Management
    async createContent(contentData) {
        try {
            const content = {
                ...contentData,
                createdAt: new Date(),
                updatedAt: new Date()
            };
            
            const result = await this.collections.content.insertOne(content);
            return { success: true, contentId: result.insertedId };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getContent(contentType = null, status = null) {
        try {
            let query = {};
            if (contentType) query.contentType = contentType;
            if (status) query.status = status;

            const content = await this.collections.content.find(query).sort({ createdAt: -1 }).toArray();
            return { success: true, content };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getContentById(id) {
        try {
            const content = await this.collections.content.findOne({ _id: new ObjectId(id) });
            return { success: true, content };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async updateContent(id, updateData) {
        try {
            const result = await this.collections.content.updateOne(
                { _id: new ObjectId(id) },
                { 
                    $set: { 
                        ...updateData, 
                        updatedAt: new Date() 
                    } 
                }
            );
            return { success: true, modifiedCount: result.modifiedCount };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async deleteContent(id) {
        try {
            const result = await this.collections.content.deleteOne({ _id: new ObjectId(id) });
            return { success: true, deletedCount: result.deletedCount };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // Media Management
    async createMedia(mediaData) {
        try {
            const media = {
                ...mediaData,
                createdAt: new Date(),
                updatedAt: new Date()
            };
            
            const result = await this.collections.media.insertOne(media);
            return { success: true, mediaId: result.insertedId };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getMedia() {
        try {
            const media = await this.collections.media.find({ status: 'active' }).sort({ createdAt: -1 }).toArray();
            return { success: true, media };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getMediaById(id) {
        try {
            const media = await this.collections.media.findOne({ _id: new ObjectId(id) });
            return { success: true, media };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // Content Types
    async getContentTypes() {
        try {
            const contentTypes = await this.collections.contentTypes.find({}).toArray();
            return { success: true, contentTypes };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async getContentTypeByName(name) {
        try {
            const contentType = await this.collections.contentTypes.findOne({ name });
            return { success: true, contentType };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    // Statistics
    async getStatistics() {
        try {
            const [blogCount, pageCount, userCount, mediaCount] = await Promise.all([
                this.collections.content.countDocuments({ contentType: 'blog_post' }),
                this.collections.content.countDocuments({ contentType: 'page' }),
                this.collections.users.countDocuments({ status: 'active' }),
                this.collections.media.countDocuments({ status: 'active' })
            ]);

            return {
                success: true,
                statistics: {
                    blogCount,
                    pageCount,
                    userCount,
                    mediaCount
                }
            };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async close() {
        if (this.client) {
            await this.client.close();
            console.log('✅ MongoDB connection closed');
        }
    }
}

module.exports = NodeBOLDatabase; 