#!/bin/bash
set -e

echo "Installing Helm..."

# Download Helm installer
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make it executable
chmod 700 get_helm.sh

# Run installer
./get_helm.sh

# Cleanup
rm get_helm.sh

# Verify installation
helm version

echo "Helm installed successfully!"
