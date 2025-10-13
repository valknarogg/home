#!/bin/bash

# Kompose Documentation Cleanup Script
# Moves redundant root markdown files to a backup directory

set -e

# Create backup directory
BACKUP_DIR="./docs-archive-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

echo "📦 Creating backup directory: $BACKUP_DIR"

# Files to archive (move to backup)
FILES_TO_ARCHIVE=(
    "LOCAL_DEV_COMPLETE.md"
    "COMPLETE_SUMMARY.md"
    "SETUP_INTEGRATION_UPDATE.md"
    "FINAL_TEST_FIXES.md"
    "TESTING_FIXES_SUMMARY.md"
    "TESTING_UPDATE_SUMMARY.md"
    "TESTING.md"
    "LOCAL_DEVELOPMENT.md"
    "QUICK_REFERENCE.md"
    "SETUP_INIT_GUIDE.md"
    "SETUP_QUICK_REFERENCE.md"
)

# Archive the files
for file in "${FILES_TO_ARCHIVE[@]}"; do
    if [ -f "$file" ]; then
        echo "📁 Archiving: $file"
        mv "$file" "$BACKUP_DIR/"
    elif [ -f "${file}.bak" ]; then
        echo "📁 Archiving: ${file}.bak"
        mv "${file}.bak" "$BACKUP_DIR/${file}"
    else
        echo "⚠️  Not found: $file (skipping)"
    fi
done

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📦 Archived files are in: $BACKUP_DIR"
echo ""
echo "📋 Remaining root markdown files:"
ls -1 *.md 2>/dev/null || echo "  (none or error listing)"
echo ""
echo "📚 Documentation is now organized in: _docs/content/"
echo ""
echo "🔍 To verify:"
echo "  - Check _docs/content/3.guide/ for guides"
echo "  - Check _docs/content/5.stacks/ for stack docs"
echo "  - Run tests: cd __tests && ./run-all-tests.sh"
echo ""
