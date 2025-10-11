#!/bin/bash
# Wrapper script to add timezone configuration to all compose files

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not found"
    echo "Please install Python 3 and try again"
    exit 1
fi

# Make the Python script executable if not already
chmod +x add-timezone.py

# Run the Python script
python3 add-timezone.py
