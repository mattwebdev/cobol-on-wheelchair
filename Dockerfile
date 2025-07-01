# Build stage
FROM ubuntu:22.04 AS builder
WORKDIR /cow
RUN apt-get update && apt-get install -qy open-cobol
COPY . /cow
RUN ./downhill.sh

# Runtime stage
FROM node:18-slim
WORKDIR /app

# Install COBOL runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcob4 \
    && rm -rf /var/lib/apt/lists/*

# Copy Node.js files
COPY package*.json ./
RUN npm install --production

# Copy application files
COPY server.js ./
COPY --from=builder /cow/the.cow ./
COPY views/ ./views/
COPY public/ ./public/

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
