#!/bin/bash

# Script to add missing DOCS_COMPOSE_PROJECT_NAME variable to environment files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

add_docs_section() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi
    
    # Check if DOCS_COMPOSE_PROJECT_NAME already exists
    if grep -q "^DOCS_COMPOSE_PROJECT_NAME=" "$file"; then
        echo "✓ DOCS_COMPOSE_PROJECT_NAME already exists in $file"
        return 0
    fi
    
    echo "Adding DOCS_COMPOSE_PROJECT_NAME to $file..."
    
    # Find position to insert (before "Local Development Notes" or at end)
    if grep -q "# Local Development Notes" "$file"; then
        # Insert before Local Development Notes
        local temp_file="${file}.tmp"
        awk '
        /^# ===================================================================/ && 
        /# Local Development Notes/ {
            print ""
            print "# ==================================================================="
            print "# DOCS STACK CONFIGURATION"
            print "# ==================================================================="
            print "DOCS_COMPOSE_PROJECT_NAME=_docs"
            print ""
            print "# Documentation Site Configuration"
            print "DOCS_PORT=3003"
            print "DOCS_NODE_ENV=production"
            print "DOCS_TRAEFIK_HOST=localhost:3003"
            print ""
        }
        {print}
        ' "$file" > "$temp_file"
        
        mv "$temp_file" "$file"
    else
        # Append at the end
        cat >> "$file" << 'EOF'

# ===================================================================
# DOCS STACK CONFIGURATION
# ===================================================================
DOCS_COMPOSE_PROJECT_NAME=_docs

# Documentation Site Configuration
DOCS_PORT=3003
DOCS_NODE_ENV=production
DOCS_TRAEFIK_HOST=localhost:3003
EOF
    fi
    
    echo "✓ Added DOCS_COMPOSE_PROJECT_NAME to $file"
}

# Add to all environment files
for env_file in .env .env.local .env.production; do
    if [ -f "${SCRIPT_DIR}/${env_file}" ]; then
        add_docs_section "${SCRIPT_DIR}/${env_file}"
    else
        echo "⚠ File not found: ${env_file}"
    fi
done

echo ""
echo "✓ Done! All environment files have been updated."
