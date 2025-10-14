#!/bin/bash

# make-secrets-executable.sh
# Makes all secrets-related scripts executable

echo "Making secrets management scripts executable..."

chmod +x kompose-secrets.sh
chmod +x verify-secrets-setup.sh

echo "✓ kompose-secrets.sh is now executable"
echo "✓ verify-secrets-setup.sh is now executable"
echo ""
echo "You can now run:"
echo "  ./verify-secrets-setup.sh     # Verify installation"
echo "  ./kompose.sh secrets generate # Generate secrets"
