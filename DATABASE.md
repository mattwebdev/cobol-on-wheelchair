# NodeBOL CMS Database Setup

NodeBOL CMS uses **MongoDB** as its primary database with a hybrid architecture:

- **Node.js** handles database operations (MongoDB driver)
- **COBOL** focuses on business logic and data processing
- **HTTP API** bridges the two layers

## Architecture Overview

```
┌─────────────┐    HTTP API    ┌─────────────┐    MongoDB    ┌─────────────┐
│   COBOL     │ ──────────────► │   Node.js   │ ─────────────► │  MongoDB    │
│ Business    │                │ Database    │                │ Database    │
│ Logic       │                │ API Server  │                │ Server      │
└─────────────┘                └─────────────┘                └─────────────┘
```

## Quick Start

### Option 1: Docker Compose (Recommended)

1. **Start MongoDB:**
   ```bash
   docker-compose up -d
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start the full stack:**
   ```bash
   npm run dev:full
   ```

### Option 2: Local MongoDB

1. **Install MongoDB locally:**
   - [MongoDB Community Server](https://www.mongodb.com/try/download/community)
   - Or use MongoDB Atlas (cloud)

2. **Set environment variables:**
   ```bash
   export MONGODB_URI="mongodb://localhost:27017/nodebol_cms"
   ```

3. **Start the application:**
   ```bash
   npm run dev:full
   ```

## Database Collections

### Users Collection
```javascript
{
  _id: ObjectId,
  username: String (unique),
  email: String (unique),
  password: String (hashed),
  role: String (admin|editor|author),
  status: String (active|inactive),
  createdAt: Date,
  updatedAt: Date
}
```

### Content Collection
```javascript
{
  _id: ObjectId,
  contentType: String (blog_post|page),
  title: String,
  content: String,
  excerpt: String,
  slug: String (unique),
  author: String,
  status: String (draft|published|archived),
  publishDate: Date,
  createdAt: Date,
  updatedAt: Date
}
```

### Media Collection
```javascript
{
  _id: ObjectId,
  filename: String,
  originalName: String,
  filePath: String,
  fileSize: Number,
  mimeType: String,
  uploadedBy: String,
  altText: String,
  description: String,
  status: String (active|deleted),
  createdAt: Date,
  updatedAt: Date
}
```

### Content Types Collection
```javascript
{
  _id: ObjectId,
  name: String (unique),
  label: String,
  fields: [
    {
      name: String,
      label: String,
      type: String (text|textarea|date|select),
      required: Boolean,
      options: [String] (for select fields)
    }
  ],
  createdAt: Date
}
```

## API Endpoints

The database API runs on port 3001 and provides these endpoints:

### POST /api/db
Main database operation endpoint.

**Request Body:**
```javascript
{
  "action": "user|content|media|content-type|statistics",
  "collection": "collection_name",
  "operation": "create|get-all|get-by-id|update|delete|authenticate",
  "data": { /* operation-specific data */ },
  "filters": { /* optional filters */ }
}
```

**Example Requests:**

#### User Authentication
```javascript
{
  "action": "user",
  "operation": "authenticate",
  "data": {
    "username": "admin",
    "password": "password"
  }
}
```

#### Create Content
```javascript
{
  "action": "content",
  "operation": "create",
  "data": {
    "contentType": "blog_post",
    "title": "My First Post",
    "content": "This is the content...",
    "author": "admin",
    "status": "draft"
  }
}
```

#### Get Statistics
```javascript
{
  "action": "statistics",
  "operation": "get"
}
```

## COBOL Database Interface

The COBOL code uses `src/core/database-interface.cbl` to communicate with the database:

```cobol
*> Example: Get user statistics
move "statistics" to action of db-request.
move "get" to operation of db-request.
call 'database-interface' using db-request db-response.
```

## Development Workflow

### 1. Start Database
```bash
# Start MongoDB with Docker
docker-compose up -d

# Or start database API only
npm run db:dev
```

### 2. Start Application
```bash
# Start both database API and main app
npm run dev:full

# Or start them separately
npm run db:api  # Terminal 1
npm run dev     # Terminal 2
```

### 3. Monitor Database
- **MongoDB Express UI:** http://localhost:8081
- **Database API Health:** http://localhost:3001/health

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MONGODB_URI` | `mongodb://localhost:27017` | MongoDB connection string |
| `DB_API_PORT` | `3001` | Database API server port |

## Troubleshooting

### MongoDB Connection Issues
1. **Check if MongoDB is running:**
   ```bash
   docker-compose ps
   ```

2. **Check MongoDB logs:**
   ```bash
   docker-compose logs mongodb
   ```

3. **Test connection:**
   ```bash
   curl http://localhost:3001/health
   ```

### Database API Issues
1. **Check if API server is running:**
   ```bash
   curl http://localhost:3001/health
   ```

2. **Check API logs:**
   ```bash
   npm run db:dev
   ```

### COBOL Database Interface Issues
1. **Verify database interface is compiled:**
   ```bash
   npm run build
   ```

2. **Check COBOL logs for database errors**

## Performance Considerations

1. **Indexes:** MongoDB indexes are automatically created for optimal performance
2. **Connection Pooling:** Node.js MongoDB driver handles connection pooling
3. **Caching:** Consider adding Redis for session and query caching
4. **Sharding:** For large datasets, consider MongoDB sharding

## Security

1. **Authentication:** Passwords are hashed using bcrypt
2. **Authorization:** Role-based access control implemented
3. **Input Validation:** All inputs are validated before database operations
4. **Connection Security:** Use MongoDB authentication and SSL in production

## Backup and Recovery

### Backup
```bash
# Backup MongoDB data
docker exec nodebol-mongodb mongodump --out /backup

# Copy backup from container
docker cp nodebol-mongodb:/backup ./backup
```

### Restore
```bash
# Restore MongoDB data
docker exec -i nodebol-mongodb mongorestore /backup
```

## Production Deployment

1. **Use MongoDB Atlas** or self-hosted MongoDB cluster
2. **Set up proper authentication** and SSL
3. **Configure connection pooling** and timeouts
4. **Set up monitoring** and alerting
5. **Implement backup strategies**
6. **Use environment variables** for configuration

## Migration from In-Memory

The system includes fallback to in-memory storage when MongoDB is unavailable. To migrate:

1. **Start MongoDB**
2. **Run the application** - it will automatically initialize default data
3. **Verify data** through the admin interface
4. **Test all functionality** to ensure migration is complete 