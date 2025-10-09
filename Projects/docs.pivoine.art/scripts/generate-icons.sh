#!/bin/bash

# Script to generate PNG icons from SVG
# Requires: librsvg (for rsvg-convert)
# Install on macOS: brew install librsvg
# Install on Ubuntu: sudo apt-get install librsvg2-bin

set -e

echo "🎨 Generating PNG icons from SVG..."

# Check if rsvg-convert is installed
if ! command -v rsvg-convert &> /dev/null; then
    echo "❌ Error: rsvg-convert not found"
    echo "Please install librsvg:"
    echo "  macOS: brew install librsvg"
    echo "  Ubuntu: sudo apt-get install librsvg2-bin"
    exit 1
fi

cd "$(dirname "$0")/../public"

# Generate various sizes from icon.svg
echo "📱 Generating PWA icons..."
rsvg-convert -w 192 -h 192 icon.svg -o icon-192.png
rsvg-convert -w 512 -h 512 icon.svg -o icon-512.png

echo "🍎 Generating Apple touch icon..."
rsvg-convert -w 180 -h 180 icon.svg -o apple-touch-icon.png

echo "🌐 Generating standard favicons..."
rsvg-convert -w 32 -h 32 favicon.svg -o favicon-32x32.png
rsvg-convert -w 16 -h 16 favicon.svg -o favicon-16x16.png

echo "✅ All icons generated successfully!"
echo ""
echo "Generated files:"
echo "  - icon-192.png (192x192) - PWA icon"
echo "  - icon-512.png (512x512) - PWA icon"
echo "  - apple-touch-icon.png (180x180) - Apple touch icon"
echo "  - favicon-32x32.png (32x32) - Standard favicon"
echo "  - favicon-16x16.png (16x16) - Standard favicon"
echo ""
echo "Note: SVG versions (icon.svg, favicon.svg) are already in place"
echo "and will be used by modern browsers automatically."
