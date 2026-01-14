#!/bin/bash
PROFILE="all"

echo "Setting up local development environment..."

# Simple argument parsing
if [ "$1" == "interactive" ]; then
    read -p "Select services to start (rds, s3, all) [default: all]: " selection
    if [ ! -z "$selection" ]; then
        PROFILE="$selection"
    fi
elif [ ! -z "$1" ]; then
    PROFILE="$1"
fi

echo "Starting services with profile: $PROFILE"

# Check if docker-compose exists, else try docker compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

$DOCKER_COMPOSE --profile $PROFILE up -d

echo "Services started."
echo "MySQL: localhost:3306 (user/password)"
if [ "$PROFILE" == "s3" ] || [ "$PROFILE" == "all" ]; then
    echo "MinIO Console: http://localhost:9001 (minioadmin/minioadmin)"
    echo "MinIO API: http://localhost:9000"
fi

echo "To stop services: $DOCKER_COMPOSE --profile $PROFILE down"

