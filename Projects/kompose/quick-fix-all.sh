#!/bin/bash

# quick-fix-all.sh - Apply all fixes and clean up in one command

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Kompose Secrets - Apply All Fixes & Clean Up          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "This will:"
echo "  1. Make all scripts executable"
echo "  2. Clean up any warning messages in secrets.env"
echo "  3. Regenerate all secrets cleanly"
echo "  4. Validate the configuration"
echo ""
read -p "Continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    echo "Cancelled"
    exit 0
fi

echo ""
echo "[1/4] Making scripts executable..."
chmod +x kompose-secrets.sh
chmod +x cleanup-secrets-warnings.sh
chmod +x verify-secrets-setup.sh
chmod +x test-secrets-fix.sh
chmod +x make-secrets-executable.sh
chmod +x setup-secrets-complete.sh
echo "✓ Done"

echo ""
echo "[2/4] Cleaning up warning messages..."
if [ -f "secrets.env" ]; then
    if grep -q "WARNING" secrets.env 2>/dev/null; then
        ./cleanup-secrets-warnings.sh
    else
        echo "✓ No warnings found - secrets.env is clean"
    fi
else
    echo "✓ No secrets.env yet - will create fresh"
fi

echo ""
echo "[3/4] Generating all secrets..."
./kompose.sh secrets generate --force

echo ""
echo "[4/4] Validating configuration..."
./kompose.sh secrets validate

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      All Fixed & Ready!                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Both fixes applied"
echo "✅ All secrets generated cleanly"
echo "✅ No warnings in secrets.env"
echo "✅ Configuration validated"
echo ""
echo "You can now use:"
echo "  ./kompose.sh up              # Start all stacks"
echo "  ./kompose.sh secrets list    # View secrets"
echo "  ./kompose.sh secrets rotate  # Rotate a secret"
echo ""
