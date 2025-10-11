#!/bin/bash
# Documentation Reorganization Script for Kompose
# This script reorganizes markdown files from root to _docs/content structure

set -e  # Exit on error

# Color codes for output
RED='\033[0:31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base directories
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="${ROOT_DIR}/_docs/content"
ARCHIVE_DIR="${ROOT_DIR}/_archive"

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create necessary directories
create_directories() {
    log_info "Creating directory structure..."
    
    mkdir -p "${DOCS_DIR}/3.guide"
    mkdir -p "${DOCS_DIR}/4.reference"
    mkdir -p "${DOCS_DIR}/5.stacks"
    mkdir -p "${ARCHIVE_DIR}"
    
    log_info "Directory structure created"
}

# Phase 1: Move Quick Reference (already done)
phase1_reference() {
    log_info "Phase 1: Quick Reference - Already completed"
}

# Phase 2: Create Integration Guides
phase2_integration_guides() {
    log_info "Phase 2: Creating integration guides..."
    
    # VPN Integration Guide
    if [ -f "${ROOT_DIR}/VPN_INTEGRATION.md" ]; then
        log_info "Moving VPN_INTEGRATION.md to guide..."
        cat > "${DOCS_DIR}/3.guide/vpn-integration.md" << 'EOF'
---
title: VPN Integration Guide
description: Integrate VPN with your entire kompose infrastructure for secure private intranet access
---

EOF
        tail -n +2 "${ROOT_DIR}/VPN_INTEGRATION.md" >> "${DOCS_DIR}/3.guide/vpn-integration.md"
        mv "${ROOT_DIR}/VPN_INTEGRATION.md" "${ARCHIVE_DIR}/"
    fi
    
    # SSO Integration Guide
    if [ -f "${ROOT_DIR}/SSO_INTEGRATION_GUIDE.md" ]; then
        log_info "Moving SSO_INTEGRATION_GUIDE.md to stacks/auth.md..."
        # This should be merged with existing auth.md
        mv "${ROOT_DIR}/SSO_INTEGRATION_GUIDE.md" "${ARCHIVE_DIR}/"
    fi
}

# Phase 3: Create Configuration Guides
phase3_configuration() {
    log_info "Phase 3: Creating configuration guides..."
    
    # Domain Configuration
    if [ -f "${ROOT_DIR}/DOMAIN_CONFIGURATION.md" ]; then
        log_info "Creating domain configuration section..."
        # Read existing configuration.md and append domain config
        # This needs manual merge - we'll copy to archive for now
        cp "${ROOT_DIR}/DOMAIN_CONFIGURATION.md" "${ARCHIVE_DIR}/"
    fi
    
    # Traefik Labels Guide
    if [ -f "${ROOT_DIR}/TRAEFIK_LABELS_GUIDE.md" ]; then
        log_info "Creating Traefik guide..."
        cat > "${DOCS_DIR}/3.guide/traefik.md" << 'EOF'
---
title: Traefik Configuration
description: Configure reverse proxy and routing with Traefik labels
---

EOF
        tail -n +2 "${ROOT_DIR}/TRAEFIK_LABELS_GUIDE.md" >> "${DOCS_DIR}/3.guide/traefik.md"
        mv "${ROOT_DIR}/TRAEFIK_LABELS_GUIDE.md" "${ARCHIVE_DIR}/"
    fi
    
    # Stack Standards
    if [ -f "${ROOT_DIR}/STACK_STANDARDS.md" ]; then
        log_info "Creating stack standards guide..."
        cat > "${DOCS_DIR}/3.guide/stack-standards.md" << 'EOF'
---
title: Stack Standards
description: Standards and conventions for kompose stacks
---

EOF
        tail -n +2 "${ROOT_DIR}/STACK_STANDARDS.md" >> "${DOCS_DIR}/3.guide/stack-standards.md"
        mv "${ROOT_DIR}/STACK_STANDARDS.md" "${ARCHIVE_DIR}/"
    fi
}

# Phase 4: Consolidate Timezone Documentation
phase4_timezone() {
    log_info "Phase 4: Consolidating timezone documentation..."
    
    cat > "${DOCS_DIR}/3.guide/timezone.md" << 'EOF'
---
title: Timezone Configuration
description: Configure timezone for all kompose services
---

# Timezone Configuration

## Overview

This guide consolidates all timezone configuration documentation for kompose services.

EOF
    
    # Merge all timezone files
    for tz_file in "${ROOT_DIR}"/TIMEZONE*.md; do
        if [ -f "$tz_file" ]; then
            log_info "Adding $(basename $tz_file) content..."
            echo -e "\n## $(basename $tz_file .md)\n" >> "${DOCS_DIR}/3.guide/timezone.md"
            tail -n +2 "$tz_file" >> "${DOCS_DIR}/3.guide/timezone.md"
            mv "$tz_file" "${ARCHIVE_DIR}/"
        fi
    done
}

# Phase 5: Create Migration Guide
phase5_migration() {
    log_info "Phase 5: Creating comprehensive migration guide..."
    
    cat > "${DOCS_DIR}/3.guide/migration.md" << 'EOF'
---
title: Migration Guide
description: Migrate between kompose versions and configurations
---

# Kompose Migration Guide

This guide consolidates all migration documentation.

EOF
    
    # Add migration guides
    for mig_file in "${ROOT_DIR}"/MIGRATION*.md "${ROOT_DIR}"/RENAME*.md "${ROOT_DIR}"/*MIGRATION*.md; do
        if [ -f "$mig_file" ]; then
            log_info "Adding $(basename $mig_file) content..."
            echo -e "\n## $(basename $mig_file .md | tr '_' ' ')\n" >> "${DOCS_DIR}/3.guide/migration.md"
            tail -n +2 "$mig_file" >> "${DOCS_DIR}/3.guide/migration.md"
            mv "$mig_file" "${ARCHIVE_DIR}/"
        fi
    done
}

# Phase 6: Create Implementation Guide
phase6_implementation() {
    log_info "Phase 6: Creating implementation guide..."
    
    if [ -f "${ROOT_DIR}/IMPLEMENTATION_GUIDE.md" ]; then
        cat > "${DOCS_DIR}/3.guide/implementation.md" << 'EOF'
---
title: Implementation Guide
description: Step-by-step implementation guide for kompose
---

EOF
        tail -n +2 "${ROOT_DIR}/IMPLEMENTATION_GUIDE.md" >> "${DOCS_DIR}/3.guide/implementation.md"
        mv "${ROOT_DIR}/IMPLEMENTATION_GUIDE.md" "${ARCHIVE_DIR}/"
    fi
}

# Phase 7: Create Deployment Checklist
phase7_deployment() {
    log_info "Phase 7: Creating deployment checklist..."
    
    if [ -f "${ROOT_DIR}/EXECUTION_CHECKLIST.md" ]; then
        cat > "${DOCS_DIR}/3.guide/deployment-checklist.md" << 'EOF'
---
title: Deployment Checklist
description: Complete checklist for deploying kompose
---

EOF
        tail -n +2 "${ROOT_DIR}/EXECUTION_CHECKLIST.md" >> "${DOCS_DIR}/3.guide/deployment-checklist.md"
        mv "${ROOT_DIR}/EXECUTION_CHECKLIST.md" "${ARCHIVE_DIR}/"
    fi
    
    # Add other deployment-related checklists
    for check_file in "${ROOT_DIR}"/*CHECKLIST*.md; do
        if [ -f "$check_file" ] && [ "$check_file" != "${ROOT_DIR}/EXECUTION_CHECKLIST.md" ]; then
            log_info "Adding $(basename $check_file)..."
            echo -e "\n## $(basename $check_file .md | tr '_' ' ')\n" >> "${DOCS_DIR}/3.guide/deployment-checklist.md"
            tail -n +2 "$check_file" >> "${DOCS_DIR}/3.guide/deployment-checklist.md"
            mv "$check_file" "${ARCHIVE_DIR}/"
        fi
    done
}

# Phase 8: Create Logging Guide
phase8_logging() {
    log_info "Phase 8: Creating logging guide..."
    
    if [ -f "${ROOT_DIR}/UNIFIED_LOGGING_COMPLETE.md" ]; then
        cat > "${DOCS_DIR}/3.guide/logging.md" << 'EOF'
---
title: Logging Guide  
description: Unified logging configuration for kompose services
---

EOF
        tail -n +2 "${ROOT_DIR}/UNIFIED_LOGGING_COMPLETE.md" >> "${DOCS_DIR}/3.guide/logging.md"
        mv "${ROOT_DIR}/UNIFIED_LOGGING_COMPLETE.md" "${ARCHIVE_DIR}/"
    fi
}

# Phase 9: Archive Summary Files
phase9_archive_summaries() {
    log_info "Phase 9: Archiving summary and completion files..."
    
    # These are historical/development files
    for summary_file in \
        "${ROOT_DIR}"/COMPLETE*.md \
        "${ROOT_DIR}"/*SUMMARY*.md \
        "${ROOT_DIR}"/DELIVERABLES.md \
        "${ROOT_DIR}"/UPDATE_README.md \
        "${ROOT_DIR}"/README-CHANGES.txt \
        "${ROOT_DIR}"/PROJECT_REVIEW*.md \
        "${ROOT_DIR}"/ACTION_PLAN.md \
        "${ROOT_DIR}"/CLAUDE.md
    do
        if [ -f "$summary_file" ]; then
            log_info "Archiving $(basename $summary_file)..."
            mv "$summary_file" "${ARCHIVE_DIR}/"
        fi
    done
}

# Phase 10: Update Index
phase10_update_index() {
    log_info "Phase 10: Updating main index..."
    
    # Enhance the main index with references to new guides
    if [ -f "${DOCS_DIR}/1.index.md" ]; then
        log_info "Index already exists, manual update recommended"
    fi
}

# Create README for archive
create_archive_readme() {
    log_info "Creating archive README..."
    
    cat > "${ARCHIVE_DIR}/README.md" << 'EOF'
# Archived Documentation

This directory contains historical and development documentation files that have been:

1. **Migrated** - Content merged into the main documentation site
2. **Superseded** - Replaced by newer documentation
3. **Completed** - Project completion summaries and development notes

## Purpose

These files are kept for:
- Historical reference
- Tracking project evolution
- Development context
- Audit trail

## Organization

Files are organized by topic:
- VPN-related documentation
- Core stack documentation  
- Chain/automation documentation
- SSO/authentication documentation
- Migration and update summaries
- Development notes

## Access

All files are preserved in their original form and can be referenced if needed for:
- Understanding historical decisions
- Reviewing old migration procedures
- Checking deprecated features

---
**Note:** For current documentation, see `_docs/content/`
EOF
}

# Main execution
main() {
    log_info "Starting Kompose documentation reorganization..."
    log_info "Root: ${ROOT_DIR}"
    log_info "Docs: ${DOCS_DIR}"
    log_info "Archive: ${ARCHIVE_DIR}"
    
    echo ""
    read -p "Continue with reorganization? (y/N) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_warn "Reorganization cancelled"
        exit 0
    fi
    
    create_directories
    
    phase1_reference
    phase2_integration_guides
    phase3_configuration
    phase4_timezone
    phase5_migration
    phase6_implementation
    phase7_deployment
    phase8_logging
    phase9_archive_summaries
    phase10_update_index
    
    create_archive_readme
    
    log_info "Reorganization complete!"
    log_info "Archived files: ${ARCHIVE_DIR}"
    log_info "Documentation: ${DOCS_DIR}"
    echo ""
    log_warn "Next steps:"
    echo "  1. Review merged documentation in _docs/content/"
    echo "  2. Update internal links where needed"
    echo "  3. Test documentation site: cd _docs && npm run dev"
    echo "  4. Commit changes: git add . && git commit -m 'Reorganize documentation'"
}

# Run main function
main "$@"
