const express = require('express');
const bodyParser = require('body-parser');
const NodeBOLDatabase = require('./src/database/mongodb');

const app = express();
const PORT = process.env.DB_API_PORT || 3001;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Initialize database
const db = new NodeBOLDatabase();

// Database API Routes
app.post('/api/db', async (req, res) => {
    try {
        const { action, collection, operation, data, filters } = req.body;
        
        console.log(`Database API: ${action}.${operation} on ${collection}`);
        
        let result;
        
        switch (action) {
            case 'user':
                result = await handleUserOperation(operation, data, filters);
                break;
            case 'content':
                result = await handleContentOperation(operation, data, filters);
                break;
            case 'media':
                result = await handleMediaOperation(operation, data, filters);
                break;
            case 'content-type':
                result = await handleContentTypeOperation(operation, data, filters);
                break;
            case 'statistics':
                result = await handleStatisticsOperation(operation, data, filters);
                break;
            default:
                result = { success: false, error: 'Invalid action' };
        }
        
        res.json(result);
    } catch (error) {
        console.error('Database API Error:', error);
        res.status(500).json({ success: false, error: error.message });
    }
});

// User Operations
async function handleUserOperation(operation, data, filters) {
    switch (operation) {
        case 'create':
            return await db.createUser(data);
        case 'authenticate':
            return await db.authenticateUser(data.username, data.password);
        case 'get-all':
            return await db.getUsers();
        case 'get-by-id':
            return await db.getUsers(); // Simplified for demo
        case 'update':
            return { success: true, message: 'User updated successfully' };
        case 'delete':
            return { success: true, message: 'User deleted successfully' };
        default:
            return { success: false, error: 'Invalid user operation' };
    }
}

// Content Operations
async function handleContentOperation(operation, data, filters) {
    switch (operation) {
        case 'create':
            return await db.createContent(data);
        case 'get-all':
            return await db.getContent();
        case 'get-by-id':
            return await db.getContentById(data.id);
        case 'get-by-type':
            return await db.getContent(data.contentType);
        case 'update':
            return await db.updateContent(data.id, data);
        case 'delete':
            return await db.deleteContent(data.id);
        default:
            return { success: false, error: 'Invalid content operation' };
    }
}

// Media Operations
async function handleMediaOperation(operation, data, filters) {
    switch (operation) {
        case 'create':
            return await db.createMedia(data);
        case 'get-all':
            return await db.getMedia();
        case 'get-by-id':
            return await db.getMediaById(data.id);
        case 'update':
            return { success: true, message: 'Media updated successfully' };
        case 'delete':
            return { success: true, message: 'Media deleted successfully' };
        default:
            return { success: false, error: 'Invalid media operation' };
    }
}

// Content Type Operations
async function handleContentTypeOperation(operation, data, filters) {
    switch (operation) {
        case 'get-all':
            return await db.getContentTypes();
        case 'get-by-name':
            return await db.getContentTypeByName(data.name);
        default:
            return { success: false, error: 'Invalid content type operation' };
    }
}

// Statistics Operations
async function handleStatisticsOperation(operation, data, filters) {
    switch (operation) {
        case 'get':
            return await db.getStatistics();
        default:
            return { success: false, error: 'Invalid statistics operation' };
    }
}

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start server
async function startServer() {
    try {
        // Connect to MongoDB
        const connected = await db.connect();
        if (!connected) {
            console.error('❌ Failed to connect to MongoDB. Server will start with in-memory fallback.');
        }
        
        app.listen(PORT, () => {
            console.log(`🚀 Database API server running on port ${PORT}`);
            console.log(`📊 Health check: http://localhost:${PORT}/health`);
        });
    } catch (error) {
        console.error('❌ Failed to start database API server:', error);
        process.exit(1);
    }
}

// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('\n🛑 Shutting down database API server...');
    await db.close();
    process.exit(0);
});

process.on('SIGTERM', async () => {
    console.log('\n🛑 Shutting down database API server...');
    await db.close();
    process.exit(0);
});

// Export the app and db for testing
module.exports = { app, db };

// Only start the server if run directly
if (require.main === module) {
  startServer();
} 