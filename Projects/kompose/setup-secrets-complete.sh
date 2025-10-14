#!/bin/bash

# COMPLETE SETUP - Run this to set up everything and test

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     Kompose Secrets Management - Complete Setup & Fix         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Make all scripts executable
echo "[1/4] Making scripts executable..."
chmod +x kompose-secrets.sh
chmod +x verify-secrets-setup.sh
chmod +x test-secrets-fix.sh
chmod +x make-secrets-executable.sh
echo "✓ All scripts are now executable"
echo ""

# Step 2: Verify setup
echo "[2/4] Verifying setup..."
./verify-secrets-setup.sh
echo ""

# Step 3: Test the fix
echo "[3/4] Testing the secrets generation fix..."
./test-secrets-fix.sh
echo ""

# Step 4: Final summary
echo "[4/4] Setup Complete!"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Everything is Ready!                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "You can now use:"
echo "  ./kompose.sh secrets generate  # Generate all secrets"
echo "  ./kompose.sh secrets validate  # Validate configuration"
echo "  ./kompose.sh secrets list      # List all secrets"
echo ""
echo "Documentation:"
echo "  • Quick Start:     SECRETS_README.md"
echo "  • Quick Reference: SECRETS_QUICK_REFERENCE.md"
echo "  • Full Guide:      SECRETS_MANAGEMENT.md"
echo "  • Fix Details:     SECRETS_FIX.md"
echo ""
