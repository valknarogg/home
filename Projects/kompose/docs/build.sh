#!/bin/bash

# Build script for Kompose documentation
set -e

echo "🎨 Building Kompose Documentation..."
echo ""

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is not installed. Installing pnpm..."
    npm install -g pnpm@9.0.0
fi

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install

# Generate static site
echo "🔨 Generating static site..."
pnpm run generate

echo ""
echo "✅ Build complete!"
echo "📁 Output directory: .output/public"
echo ""
echo "To preview locally:"
echo "  pnpm run preview"
echo ""
echo "To deploy with Docker:"
echo "  ./kompose.sh docs up -d --build"
