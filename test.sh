#!/bin/bash

echo "Starting Environment Verification..."

# Determine python command
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Error: Python is not installed."
    exit 1
fi

echo "Using Python: $PYTHON_CMD"
# Check Pip via python module to ensure compatibility
if ! $PYTHON_CMD -m pip --version &> /dev/null; then
    echo "Error: pip module not found for $PYTHON_CMD."
    exit 1
fi

echo "Installing dependencies..."
# Using -m pip ensures we install to the environment of the python executable we found
$PYTHON_CMD -m pip install -r tests/requirements.txt

echo "----------------------------------------"
echo "Running MySQL Tests..."
$PYTHON_CMD tests/test_mysql.py

echo "----------------------------------------"
echo "Running MinIO Tests..."
$PYTHON_CMD tests/test_minio.py

echo "----------------------------------------"
echo "Verification Complete."

