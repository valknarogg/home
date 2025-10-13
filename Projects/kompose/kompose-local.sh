#!/bin/bash

# ===================================================================
# Kompose Local Development Mode Manager
# DEPRECATED: This script is now a wrapper for 'kompose.sh setup'
# ===================================================================
# For new projects, use: ./kompose.sh setup <command>
# This wrapper is maintained for backward compatibility
# ===================================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

# Color output
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print deprecation notice
print_deprecation_notice() {
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠  DEPRECATION NOTICE${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}This script (kompose-local.sh) is deprecated.${NC}"
    echo -e "${BLUE}All functionality has been integrated into kompose.sh${NC}"
    echo ""
    echo -e "Please use the ${BLUE}kompose.sh setup${NC} command instead:"
    echo ""
    echo "  Old command:                New command:"
    echo "  ${YELLOW}./kompose-local.sh local${NC}    →  ${BLUE}./kompose.sh setup local${NC}"
    echo "  ${YELLOW}./kompose-local.sh prod${NC}     →  ${BLUE}./kompose.sh setup prod${NC}"
    echo "  ${YELLOW}./kompose-local.sh status${NC}   →  ${BLUE}./kompose.sh setup status${NC}"
    echo "  ${YELLOW}./kompose-local.sh backup${NC}   →  ${BLUE}./kompose.sh setup backup${NC}"
    echo ""
    echo -e "${BLUE}This wrapper will forward your command to kompose.sh${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    sleep 2
}

# Main script - forward to kompose.sh setup
main() {
    local command=${1:-status}
    
    # Show deprecation notice on first use
    print_deprecation_notice
    
    # Forward command to kompose.sh setup
    echo -e "${BLUE}Executing: ./kompose.sh setup $@${NC}"
    echo ""
    
    exec ./kompose.sh setup "$@"
}

# Run main
main "$@"
