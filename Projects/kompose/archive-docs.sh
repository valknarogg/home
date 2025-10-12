#!/bin/bash
#
# Archive Root Markdown Files
# Moves all documentation markdown files from project root to _archive
#

set -e

PROJECT_ROOT="/home/valknar/Projects/kompose"
ARCHIVE_DIR="${PROJECT_ROOT}/_archive/docs_consolidated_$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Archive Root Markdown Files           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Create archive directory
mkdir -p "${ARCHIVE_DIR}"
echo -e "${YELLOW}→ Archive directory: ${ARCHIVE_DIR}${NC}"
echo ""

cd "${PROJECT_ROOT}"

# Files to archive
FILES=(
    "API_COMPLETE_GUIDE.md"
    "API_IMPLEMENTATION_SUMMARY.md"
    "API_QUICK_REFERENCE.md"
    "API_QUICK_START.md"
    "API_README.md"
    "API_SERVER_IMPROVEMENTS.md"
    "CHAIN_QUICK_REF.md"
    "CHANGES.md"
    "CORE_QUICK_REF.md"
    "CORE_SETUP_COMPLETE.md"
    "DATABASE-MANAGEMENT.md"
    "DOMAIN_CONFIGURATION.md"
    "HOOKS_QUICKREF.md"
    "INDEX.md"
    "KMPS_DEPLOYMENT_COMPLETE.md"
    "QUICK_REFERENCE.md"
    "QUICK_START.md"
    "README_API_FIXES.md"
    "SSO_INTEGRATION_EXAMPLES.md"
    "SSO_QUICK_REF.md"
    "VPN_KOMPOSE_INTEGRATION.md"
    "VPN_QUICK_REF.md"
    "VPN_VISUAL_OVERVIEW.md"
)

# Archive files
ARCHIVED_COUNT=0
SKIPPED_COUNT=0

for file in "${FILES[@]}"; do
    if [ -f "${file}" ]; then
        mv "${file}" "${ARCHIVE_DIR}/"
        echo -e "${GREEN}✓ Archived ${file}${NC}"
        ((ARCHIVED_COUNT++))
    else
        echo -e "${YELLOW}⚠ Skipped ${file} (not found)${NC}"
        ((SKIPPED_COUNT++))
    fi
done

# Create summary
cat > "${ARCHIVE_DIR}/ARCHIVE_SUMMARY.md" << EOF
# Documentation Archive Summary

**Date**: $(date)
**Archive Location**: ${ARCHIVE_DIR}

## Files Archived

$(for file in "${FILES[@]}"; do echo "- ${file}"; done)

## Statistics

- **Total files**: ${#FILES[@]}
- **Archived**: ${ARCHIVED_COUNT}
- **Skipped**: ${SKIPPED_COUNT}

## New Documentation Location

All documentation has been consolidated into \`_docs/content/\`:

### Guides (_docs/content/3.guide/)
- sso-integration.md
- monitoring.md
- mqtt-events.md
- api-server.md
- database.md
- configuration.md
- hooks.md
- logging.md
- migration.md
- network.md
- quick-start.md
- stack-management.md
- stack-standards.md
- timezone.md
- traefik.md
- troubleshooting.md
- vpn-integration.md

### References (_docs/content/4.reference/)
- api-quick-reference.md
- cli.md
- core-quick-reference.md
- environment.md
- quick-reference.md
- sso-quick-reference.md
- vpn-quick-reference.md

### Stacks (_docs/content/5.stacks/)
- auth.md
- chain.md
- core.md
- kmps.md
- link.md
- news.md
- track.md
- vault.md
- watch.md
- vpn.md
- ... and more

## Rollback

To restore archived files:

\`\`\`bash
cp ${ARCHIVE_DIR}/*.md ${PROJECT_ROOT}/
\`\`\`

## Next Steps

1. Build documentation site: \`cd _docs && npm run build\`
2. Update main README.md
3. Commit changes to git
EOF

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Archive Complete!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo -e "  - Archived: ${ARCHIVED_COUNT} files"
echo -e "  - Skipped: ${SKIPPED_COUNT} files"
echo -e "  - Location: ${ARCHIVE_DIR}"
echo ""
echo -e "${GREEN}View summary: cat ${ARCHIVE_DIR}/ARCHIVE_SUMMARY.md${NC}"
echo ""
