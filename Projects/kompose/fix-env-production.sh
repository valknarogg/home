#!/bin/bash
# ===================================================================
# Kompose Environment Variables Quick Fix Script
# ===================================================================
# This script fixes the most critical environment variable issues
# identified in the verification report.
#
# Usage: ./fix-env-production.sh
# ===================================================================

set -e  # Exit on any error

echo "=================================================="
echo "Kompose Environment Variables Quick Fix"
echo "=================================================="
echo ""

# Backup original files
echo "📦 Creating backups..."
cp .env.production .env.production.backup.$(date +%Y%m%d_%H%M%S)
echo "✅ Backup created: .env.production.backup.$(date +%Y%m%d_%H%M%S)"
echo ""

# Fix 1: Update .env.production header
echo "🔧 Fix 1: Updating .env.production header..."
sed -i '2s/Local Development Configuration/Production Configuration/' .env.production
sed -i '5s/This file is for LOCAL DEVELOPMENT ONLY/This file is for PRODUCTION DEPLOYMENT/' .env.production
sed -i 's/cp .env.local .env/cp .env.production .env/g' .env.production
sed -i 's/local:start/prod:start/g' .env.production
echo "✅ Header updated"
echo ""

# Fix 2: Add missing COMPOSE_PROJECT_NAME variables
echo "🔧 Fix 2: Adding missing COMPOSE_PROJECT_NAME variables..."

# Check if already added to avoid duplicates
if ! grep -q "CORE_COMPOSE_PROJECT_NAME=core" .env.production; then
    cat >> .env.production << 'EOF'

# ===================================================================
# ADDITIONAL MISSING VARIABLES (Auto-added by fix script)
# Generated: 2025-10-13
# ===================================================================

# Core Stack - Project Name
CORE_COMPOSE_PROJECT_NAME=core

EOF
    echo "✅ Added CORE_COMPOSE_PROJECT_NAME"
fi

# Fix 3: Add missing Auth variables
if ! grep -q "AUTH_COMPOSE_PROJECT_NAME=auth" .env.production; then
    cat >> .env.production << 'EOF'

# Auth Stack - Project Name
AUTH_COMPOSE_PROJECT_NAME=auth

EOF
    echo "✅ Added AUTH_COMPOSE_PROJECT_NAME"
fi

# Fix 4: Add missing Messaging variables
if ! grep -q "MESSAGING_MAILHOG_PORT" .env.production; then
    cat >> .env.production << 'EOF'

# Messaging Stack - Missing Variables
MESSAGING_MAILHOG_PORT=8025
MESSAGING_MAILHOG_IMAGE=mailhog/mailhog:latest
MESSAGING_GOTIFY_IMAGE=gotify/server:latest

EOF
    echo "✅ Added MESSAGING variables"
fi

# Fix 5: Add missing VPN variables
if ! grep -q "VPN_COMPOSE_PROJECT_NAME=vpn" .env.production; then
    cat >> .env.production << 'EOF'

# VPN Stack - Missing Variables
VPN_COMPOSE_PROJECT_NAME=vpn
VPN_DOCKER_IMAGE=weejewel/wg-easy:latest

EOF
    echo "✅ Added VPN variables"
fi

# Fix 6: Add note about remaining work
cat >> .env.production << 'EOF'

# ===================================================================
# IMPORTANT NOTES
# ===================================================================
# This file has been automatically updated by fix-env-production.sh
#
# ⚠️ REMAINING WORK NEEDED:
# 1. Update compose.yaml files to use prefixed variables:
#    - core/compose.yaml: POSTGRES_IMAGE → CORE_POSTGRES_IMAGE
#    - auth/compose.yaml: DOCKER_IMAGE → AUTH_DOCKER_IMAGE
#    - messaging/compose.yaml: GOTIFY_IMAGE → MESSAGING_GOTIFY_IMAGE
#    - vpn/compose.yaml: DOCKER_IMAGE → VPN_DOCKER_IMAGE
#
# 2. Review and test each stack deployment
#
# 3. See ENV_VERIFICATION_REPORT.md for complete details
# ===================================================================
EOF

echo ""
echo "=================================================="
echo "✅ Quick fixes applied successfully!"
echo "=================================================="
echo ""
echo "📝 What was fixed:"
echo "  • Updated .env.production header to reflect production config"
echo "  • Added missing COMPOSE_PROJECT_NAME variables"
echo "  • Added missing Messaging stack variables"
echo "  • Added missing VPN stack variables"
echo ""
echo "⚠️  IMPORTANT - Still needed:"
echo "  • Update compose.yaml files to use prefixed variables"
echo "  • See ENV_VERIFICATION_REPORT.md for complete instructions"
echo ""
echo "📂 Backup saved as: .env.production.backup.$(date +%Y%m%d_%H%M%S)"
echo ""
echo "🔍 Next steps:"
echo "  1. Review ENV_VERIFICATION_REPORT.md"
echo "  2. Update compose.yaml files as specified"
echo "  3. Test stack deployments"
echo ""
