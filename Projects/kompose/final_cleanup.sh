#!/bin/bash
# Final Cleanup Commands for Kompose Documentation
# Execute this in the /home/valknar/Projects/kompose directory

echo "======================================================================"
echo "  Kompose Documentation Cleanup - Final Step"
echo "======================================================================"
echo ""
echo "Working directory: $(pwd)"
echo ""
echo "This will remove 5 obsolete markdown files:"
echo "  1. home/EXAMPLES.md"
echo "  2. home/HOME_STACK_OVERVIEW.md"
echo "  3. home/INSTALLATION_SUMMARY.md"
echo "  4. messaging/MIGRATION_SUMMARY.md"
echo "  5. _docs/content/5.stacks/chat.md"
echo ""
read -p "Continue with deletion? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cleanup cancelled."
    exit 1
fi

echo ""
echo "Removing obsolete files..."
echo "======================================================================"

# Remove HOME stack obsolete files
if [ -f "home/EXAMPLES.md" ]; then
    rm home/EXAMPLES.md
    echo "✓ Removed: home/EXAMPLES.md"
else
    echo "✗ Not found: home/EXAMPLES.md"
fi

if [ -f "home/HOME_STACK_OVERVIEW.md" ]; then
    rm home/HOME_STACK_OVERVIEW.md
    echo "✓ Removed: home/HOME_STACK_OVERVIEW.md"
else
    echo "✗ Not found: home/HOME_STACK_OVERVIEW.md"
fi

if [ -f "home/INSTALLATION_SUMMARY.md" ]; then
    rm home/INSTALLATION_SUMMARY.md
    echo "✓ Removed: home/INSTALLATION_SUMMARY.md"
else
    echo "✗ Not found: home/INSTALLATION_SUMMARY.md"
fi

# Remove MESSAGING stack obsolete file
if [ -f "messaging/MIGRATION_SUMMARY.md" ]; then
    rm messaging/MIGRATION_SUMMARY.md
    echo "✓ Removed: messaging/MIGRATION_SUMMARY.md"
else
    echo "✗ Not found: messaging/MIGRATION_SUMMARY.md"
fi

# Remove old _docs file
if [ -f "_docs/content/5.stacks/chat.md" ]; then
    rm _docs/content/5.stacks/chat.md
    echo "✓ Removed: _docs/content/5.stacks/chat.md"
else
    echo "✗ Not found: _docs/content/5.stacks/chat.md"
fi

echo ""
echo "======================================================================"
echo "  Cleanup Complete!"
echo "======================================================================"
echo ""
echo "Remaining documentation structure:"
echo ""
echo "HOME STACK:"
echo "  ✓ _docs/content/5.stacks/home.md (UPDATED)"
echo "  ✓ home/README.md"
echo "  ✓ home/QUICK_REFERENCE.md"
echo "  ✓ home/MATTER_SETUP.md"
echo "  ✓ home/MQTT_INTEGRATION.md"
echo ""
echo "CHAIN STACK:"
echo "  ✓ _docs/content/5.stacks/chain.md (UPDATED)"
echo "  ✓ chain/INTEGRATION_GUIDE.md"
echo ""
echo "MESSAGING STACK:"
echo "  ✓ _docs/content/5.stacks/messaging.md (NEW)"
echo "  ✓ messaging/README.md"
echo "  ✓ messaging/MESSAGING_STACK.md"
echo "  ✓ messaging/MAILHOG_INTEGRATION.md"
echo ""
echo "Next steps:"
echo "  1. Test _docs app: cd _docs && npm run dev"
echo "  2. Verify links work"
echo "  3. Check if _docs/content/5.stacks/auto.md exists and remove if obsolete"
echo "  4. Commit changes"
echo ""
