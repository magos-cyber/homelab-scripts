#!/bin/bash
# Docker Cleanup Script
# Remove unused containers, images, volumes, and networks

set -euo pipefail

echo "=== Docker Cleanup ==="

# Stop exited containers
echo "Removing exited containers..."
docker container prune -f

# Remove dangling images
echo "Removing dangling images..."
docker image prune -f

# Remove unused images (not just dangling)
echo "Removing unused images..."
docker image prune -af

# Remove unused volumes
echo "Removing unused volumes..."
docker volume prune -f

# Remove unused networks
echo "Removing unused networks..."
docker network prune -f

# Show disk usage
echo ""
echo "=== Docker Disk Usage ==="
docker system df
