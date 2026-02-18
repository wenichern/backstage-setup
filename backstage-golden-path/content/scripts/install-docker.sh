#!/bin/bash
set -e

echo "Installing Docker..."

# Update system
sudo yum update -y

# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
sudo usermod -a -G docker $USER

# Verify installation
docker --version

echo "Docker installed successfully!"
