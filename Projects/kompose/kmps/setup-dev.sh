#!/bin/bash

# KMPS Development Setup Helper
# This script helps you set up KMPS for local development

set -e

PROJECT_ROOT="/home/valknar/Projects/kompose"
KMPS_DIR="$PROJECT_ROOT/kmps"
SECRETS_FILE="$PROJECT_ROOT/secrets.env"

echo "🚀 KMPS Development Setup Helper"
echo "=================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a service is running
service_running() {
    docker ps --format '{{.Names}}' | grep -q "$1"
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists docker; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command_exists node; then
    echo "❌ Node.js is not installed. Please install Node.js 20+ first."
    exit 1
fi

echo "✅ Docker: $(docker --version | cut -d' ' -f3)"
echo "✅ Node.js: $(node --version)"
echo ""

# Check if required stacks are running
echo "🔍 Checking required services..."

if ! service_running "core_postgres"; then
    echo "⚠️  Core stack (PostgreSQL) is not running"
    read -p "Start core stack now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_ROOT"
        ./kompose.sh up core
    else
        echo "❌ Core stack is required. Start it with: ./kompose.sh up core"
        exit 1
    fi
fi

if ! service_running "auth_keycloak"; then
    echo "⚠️  Auth stack (Keycloak) is not running"
    read -p "Start auth stack now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_ROOT"
        ./kompose.sh up auth
    else
        echo "❌ Auth stack is required. Start it with: ./kompose.sh up auth"
        exit 1
    fi
fi

echo "✅ Required services are running"
echo ""

# Check secrets.env
echo "🔐 Checking secrets configuration..."

if [ ! -f "$SECRETS_FILE" ]; then
    echo "❌ secrets.env not found!"
    echo "Creating from template..."
    cp "$PROJECT_ROOT/secrets.env.template" "$SECRETS_FILE"
    echo "⚠️  Please edit $SECRETS_FILE and fill in the secrets"
    exit 1
fi

# Check if KMPS secrets are configured
if grep -q "KMPS_CLIENT_SECRET=CHANGE_ME" "$SECRETS_FILE" 2>/dev/null; then
    echo "⚠️  KMPS_CLIENT_SECRET not configured in secrets.env"
    echo ""
    echo "📝 Next steps:"
    echo "1. Access Keycloak at https://auth.pivoine.art"
    echo "2. Create client 'kmps-admin' (see kmps/DEVELOPMENT.md for details)"
    echo "3. Copy client secret to secrets.env"
    echo ""
    read -p "Have you completed Keycloak setup? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Please complete Keycloak setup first. See kmps/DEVELOPMENT.md for instructions."
        exit 1
    fi
fi

if grep -q "KMPS_NEXTAUTH_SECRET=CHANGE_ME" "$SECRETS_FILE" 2>/dev/null; then
    echo "⚠️  KMPS_NEXTAUTH_SECRET not configured"
    echo "Generating NextAuth secret..."
    NEXTAUTH_SECRET=$(openssl rand -base64 32)
    
    # Add or update the secret
    if grep -q "^KMPS_NEXTAUTH_SECRET=" "$SECRETS_FILE"; then
        # Update existing
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|^KMPS_NEXTAUTH_SECRET=.*|KMPS_NEXTAUTH_SECRET=$NEXTAUTH_SECRET|" "$SECRETS_FILE"
        else
            sed -i "s|^KMPS_NEXTAUTH_SECRET=.*|KMPS_NEXTAUTH_SECRET=$NEXTAUTH_SECRET|" "$SECRETS_FILE"
        fi
    else
        # Add new
        echo "KMPS_NEXTAUTH_SECRET=$NEXTAUTH_SECRET" >> "$SECRETS_FILE"
    fi
    echo "✅ Generated and saved KMPS_NEXTAUTH_SECRET"
fi

echo "✅ Secrets configured"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
cd "$KMPS_DIR"

if [ ! -d "node_modules" ]; then
    echo "Running npm install..."
    npm install
else
    echo "✅ Dependencies already installed"
fi

echo ""

# Source secrets for environment variables
echo "🔧 Setting up environment variables..."

# Load secrets
set -a
source "$SECRETS_FILE"
set +a

# Set development environment variables
export NODE_ENV=development
export KEYCLOAK_URL=https://auth.pivoine.art
export KEYCLOAK_REALM=kompose
export KEYCLOAK_CLIENT_ID=kmps-admin
export NEXTAUTH_URL=http://localhost:3100
export KOMPOSE_API_URL=http://localhost:8080

echo "✅ Environment configured"
echo ""

# Display configuration
echo "📊 Current Configuration:"
echo "========================"
echo "NODE_ENV: $NODE_ENV"
echo "KEYCLOAK_URL: $KEYCLOAK_URL"
echo "KEYCLOAK_REALM: $KEYCLOAK_REALM"
echo "KEYCLOAK_CLIENT_ID: $KEYCLOAK_CLIENT_ID"
echo "NEXTAUTH_URL: $NEXTAUTH_URL"
echo "KOMPOSE_API_URL: $KOMPOSE_API_URL"
echo ""

# Ask how to proceed
echo "🎯 How would you like to run KMPS?"
echo ""
echo "1) Local development server (recommended for development)"
echo "   - Hot module reloading"
echo "   - Runs on http://localhost:3100"
echo ""
echo "2) Docker development (matches production)"
echo "   - Runs in Docker container"
echo "   - Uses docker-compose"
echo ""
echo "3) Exit (I'll start it manually)"
echo ""

read -p "Choose an option (1-3): " -n 1 -r
echo
echo ""

case $REPLY in
    1)
        echo "🚀 Starting local development server..."
        echo ""
        echo "Press Ctrl+C to stop the server"
        echo ""
        npm run dev
        ;;
    2)
        echo "🐳 Starting Docker development..."
        cd "$PROJECT_ROOT"
        ./kompose.sh up kmps
        echo ""
        echo "✅ KMPS started in Docker!"
        echo "📝 View logs with: ./kompose.sh logs kmps -f"
        echo "🌐 Access at: https://manage.pivoine.art"
        ;;
    3)
        echo "👍 Setup complete!"
        echo ""
        echo "To start manually:"
        echo "  cd $KMPS_DIR"
        echo "  npm run dev"
        echo ""
        echo "Or with Docker:"
        echo "  cd $PROJECT_ROOT"
        echo "  ./kompose.sh up kmps"
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📚 Documentation:"
echo "   - Development guide: kmps/DEVELOPMENT.md"
echo "   - Main docs: _docs/content/5.stacks/kmps.md"
echo "   - Setup summary: kmps/SETUP_COMPLETE.md"
echo ""
