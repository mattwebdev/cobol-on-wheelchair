FROM node:18-slim

# Install GnuCOBOL and clean up
RUN apt-get update && \
    apt-get install -y gnucobol && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY src/ ./src/
COPY server.js ./
COPY public/ ./public/

# Create bin directory
RUN mkdir -p bin

# Build COBOL files
RUN npm run build

# Expose port
EXPOSE 3000

# Start server
CMD ["npm", "start"]
