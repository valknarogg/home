#!/bin/bash

# Make all Kompose scripts executable

echo "Making scripts executable..."

chmod +x kompose.sh
chmod +x kompose-api-server.sh
chmod +x test-api.sh
chmod +x make-api-executable.sh

echo ""
echo "✓ kompose.sh"
echo "✓ kompose-api-server.sh"
echo "✓ test-api.sh"
echo "✓ make-api-executable.sh"
echo ""
echo "All scripts are now executable!"
