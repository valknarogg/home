#!/bin/bash

# Kompose Documentation Cleanup Script
# Archives implementation and fix documentation to _docs/archive/

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ARCHIVE_DIR="_docs/archive/implementation-notes"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Kompose Documentation Cleanup Script                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if archive directory exists
if [ ! -d "$ARCHIVE_DIR" ]; then
    echo -e "${YELLOW}Creating archive directory...${NC}"
    mkdir -p "$ARCHIVE_DIR"
fi

# Counter
moved_count=0
not_found_count=0

# Function to move file with feedback
move_file() {
    local file="$1"
    if [ -f "$file" ]; then
        mv "$file" "$ARCHIVE_DIR/" && \
        echo -e "${GREEN}✓${NC} Archived: $file" && \
        ((moved_count++))
    else
        echo -e "${YELLOW}⊘${NC} Not found: $file"
        ((not_found_count++))
    fi
}

echo "Archiving implementation and fix documentation..."
echo ""

# Environment configuration fixes
echo -e "${BLUE}Environment Configuration Fixes:${NC}"
move_file "ENVIRONMENT_GENERATION_FIX.md"
move_file "ENVIRONMENT_SETUP_FIX.md"
move_file "ENVIRONMENT_SOLUTION_SUMMARY.md"
move_file "ENV_CHECKLIST.md"
move_file "ENV_CORRUPTION_FIX.md"
move_file "ENV_FILE_GENERATION_FIX.md"
move_file "ENV_REFERENCE.md"
move_file "ENV_VERIFICATION_REPORT.md"
echo ""

# Implementation notes
echo -e "${BLUE}Implementation Notes:${NC}"
move_file "FINAL_SUMMARY.md"
move_file "FINAL_SUMMARY_V2.md"
move_file "GENERATOR_IMPLEMENTATION.md"
move_file "IMPLEMENTATION_SUMMARY.md"
echo ""

# Secrets management fixes
echo -e "${BLUE}Secrets Management:${NC}"
move_file "SECRETS_FIX.md"
move_file "SECRETS_FIX_SUMMARY.md"
move_file "SECRETS_IMPLEMENTATION_SUMMARY.md"
move_file "SECRETS_MANAGEMENT.md"
move_file "SECRETS_QUICK_REFERENCE.md"
move_file "SECRETS_README.md"
move_file "SECRETS_WARNING_FIX.md"
echo ""

# Other configuration fixes
echo -e "${BLUE}Other Fixes:${NC}"
move_file "STARTUP_ORDER.md"
move_file "TRAEFIK_HOST_FIX_COMPLETE.md"
move_file "TRAEFIK_HOST_URL_FIX.md"
move_file "VERIFICATION_CHECKLIST.md"
move_file "WATCH_STACK_CONFIGURATION.md"
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      Summary                               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}✓ Files archived: $moved_count${NC}"
echo -e "${YELLOW}⊘ Files not found: $not_found_count${NC}"
echo ""
echo -e "Archived files location: ${BLUE}$ARCHIVE_DIR${NC}"
echo ""
echo -e "${GREEN}✓ Documentation cleanup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review _docs/archive/README.md for archive info"
echo "  2. Check new documentation in _docs/content/3.guide/"
echo "  3. Browse reference docs in _docs/content/4.reference/"
echo "  4. Remove DOCUMENTATION_CLEANUP_PLAN.md (optional)"
echo "  5. Remove DOCUMENTATION_FINALIZATION_STATUS.md (optional)"
echo ""
echo "New documentation files created:"
echo "  • _docs/content/3.guide/custom-stacks.md"
echo "  • _docs/content/3.guide/secrets.md"
echo "  • _docs/content/4.reference/environment-variables.md"
echo ""
