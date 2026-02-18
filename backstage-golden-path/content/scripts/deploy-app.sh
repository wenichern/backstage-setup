#!/bin/bash
set -e

echo "Deploying application..."

# Configuration
APP_PORT=${APPLICATION_PORT:-8080}
DOCKER_IMAGE=${DOCKER_IMAGE:-"nginx:latest"}

# Pull Docker image (or build if Dockerfile exists)
if [ -f "/tmp/Dockerfile" ]; then
    echo "Building Docker image from Dockerfile..."
    docker build -t myapp:latest /tmp/
    DOCKER_IMAGE="myapp:latest"
else
    echo "Pulling Docker image: $DOCKER_IMAGE"
    docker pull $DOCKER_IMAGE
fi

# Stop existing container if running
if docker ps -a | grep -q myapp; then
    echo "Stopping existing container..."
    docker stop myapp || true
    docker rm myapp || true
fi

# Run container
echo "Starting container..."
docker run -d \
    --name myapp \
    --restart unless-stopped \
    -p ${APP_PORT}:${APP_PORT} \
    ${DOCKER_IMAGE}

# Wait for application to start
echo "Waiting for application to start..."
sleep 5

# Check if container is running
if docker ps | grep -q myapp; then
    echo "Application deployed successfully!"
    echo "Application is running on port ${APP_PORT}"
else
    echo "Failed to start application"
    docker logs myapp
    exit 1
fi
