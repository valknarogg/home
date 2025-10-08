#!/usr/bin/env bash

echo "🧹 Cleaning up old documentation files..."

# Remove old documentation
rm -f DATABASE_OPS.md
rm -f HOOKS.md
rm -f NETWORK_CONFIG.md
rm -f SMTP_STATUS.md

echo "✅ Old documentation files removed!"
echo "📖 All documentation is now in README.md"
