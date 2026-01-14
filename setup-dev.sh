#!/bin/bash
PROFILE="all"

# Function to check if Docker is running
function check_docker() {
    docker info &> /dev/null
    return $?
}

# Function to start Docker Desktop
function start_docker() {
    OS="$(uname -s)"
    echo "Attempting to start Docker on $OS..."
    
    if [[ "$OS" == "Darwin" ]]; then
        open -a Docker
    elif [[ "$OS" == *"MINGW"* ]] || [[ "$OS" == *"CYGWIN"* ]] || [[ "$OS" == *"MSYS"* ]]; then
        # Try to start Docker Desktop on Windows
        if command -v powershell.exe &> /dev/null; then
            powershell.exe -Command "Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'"
        else
            echo "Error: powershell.exe not found to start Docker."
            return 1
        fi
    else
        echo "Unsupported OS for auto-starting Docker Desktop. Please start it manually."
        return 1
    fi
}

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

# Check Docker Status
if ! check_docker; then
    echo "Docker is not currently running."
    read -p "Do you want to attempt to start Docker? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if start_docker; then
            echo "Waiting for Docker to initialize (this may take a minute)..."
            # Wait loop
            MAX_CHECKS=0
            while ! check_docker; do
                sleep 2
                echo -n "."
                MAX_CHECKS=$((MAX_CHECKS+1))
                if [ $MAX_CHECKS -ge 60 ]; then
                    echo " Timed out waiting for Docker."
                    exit 1
                fi
            done
            echo " Docker is now running!"
        else
            echo "Failed to start Docker."
            exit 1
        fi
    else
        echo "Aborting. Please start Docker and try again."
        exit 1
    fi
fi

echo "Starting services with profile: $PROFILE"

# Check if docker-compose exists, else try docker compose
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

$DOCKER_COMPOSE --profile $PROFILE up -d

EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    echo "Error: Failed to bring up services."
    exit $EXIT_CODE
fi

echo "Services started successfully."
echo "MySQL: localhost:3306 (user/password)"
if [ "$PROFILE" == "s3" ] || [ "$PROFILE" == "all" ]; then
    echo "MinIO Console: http://localhost:9001 (minioadmin/minioadmin)"
    echo "MinIO API: http://localhost:9000"
fi


# Prompt to run tests
read -p "Do you want to run the verification tests now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chmod +x test.sh
    ./test.sh
fi
echo ""
echo ""
echo "To stop services: $DOCKER_COMPOSE --profile $PROFILE down"
