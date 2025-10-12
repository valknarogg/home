#!/bin/bash

# setup-permissions.sh - Set correct permissions for Kompose scripts
# Run this after cloning the repository or pulling updates

set -e

echo "Setting up file permissions for Kompose..."
echo ""

# Main scripts
chmod +x kompose.sh
chmod +x kompose-env.sh
chmod +x kompose-stack.sh
chmod +x kompose-db.sh
chmod +x kompose-tag.sh
chmod +x kompose-api.sh
chmod +x kompose-api-server.sh
chmod +x kompose-utils.sh

# Migration script
chmod +x migrate-to-centralized-env.sh

# Make hooks executable if it exists
if [ -f hooks.sh ]; then
    chmod +x hooks.sh
fi

# Set proper permissions for secrets
if [ -f secrets.env ]; then
    chmod 600 secrets.env
    echo "✓ Set secrets.env to 600 (owner read/write only)"
fi

echo "✓ Made all scripts executable"
echo ""
echo "Permissions set successfully!"
echo ""
echo "Next steps:"
echo "  1. Review configuration: cat .env"
echo "  2. Set up secrets: vim secrets.env"
echo "  3. Run migration: ./migrate-to-centralized-env.sh"
echo "  4. Start stacks: ./kompose.sh up core"
