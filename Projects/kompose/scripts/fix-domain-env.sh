#!/bin/bash
# =================================================================
# Fix Domain Environment File - Add missing Traefik host variables
# =================================================================

set -e

echo "Updating domain.env files with missing Traefik host variables..."

# =================================================================
# Function to append variables if they don't exist
# =================================================================
add_if_missing() {
    local file="$1"
    local var_name="$2"
    local var_value="$3"
    
    if ! grep -q "^${var_name}=" "$file" 2>/dev/null; then
        echo "${var_name}=${var_value}" >> "$file"
    fi
}

# =================================================================
# Update domain.env.production
# =================================================================
echo "→ Updating domain.env.production..."

# Check if file exists, if not skip
if [ ! -f "domain.env.production" ]; then
    echo "Warning: domain.env.production not found, skipping"
else
    # Add missing watch stack Traefik hosts
    cat >> domain.env.production << 'EOF'

# -------------------------------------------------------------------
# Watch Stack - Monitoring & Observability Traefik Hosts
# -------------------------------------------------------------------
WATCH_TRAEFIK_HOST_PROMETHEUS=${SUBDOMAIN_PROMETHEUS}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_GRAFANA=${SUBDOMAIN_GRAFANA}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_LOKI=${SUBDOMAIN_LOKI}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_ALERTMANAGER=${SUBDOMAIN_ALERTMANAGER}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Code Stack - Gitea Traefik Host
# -------------------------------------------------------------------
CODE_GITEA_TRAEFIK_HOST=${SUBDOMAIN_CODE}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Auth Stack - OAuth2 Proxy Traefik Host
# -------------------------------------------------------------------
AUTH_OAUTH2_PROXY_HOST=${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# VPN Stack - Traefik Host
# -------------------------------------------------------------------
VPN_TRAEFIK_HOST=${SUBDOMAIN_VPN}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Additional Stack Traefik Hosts
# -------------------------------------------------------------------
BLOG_TRAEFIK_HOST=${SUBDOMAIN_BLOG}.${ROOT_DOMAIN}
SEXY_TRAEFIK_HOST=${SUBDOMAIN_SEXY}.${ROOT_DOMAIN}
NEWS_TRAEFIK_HOST=${SUBDOMAIN_NEWS}.${ROOT_DOMAIN}
LINK_TRAEFIK_HOST=${SUBDOMAIN_LINK}.${ROOT_DOMAIN}
TRACK_TRAEFIK_HOST=${SUBDOMAIN_TRACK}.${ROOT_DOMAIN}
VAULT_TRAEFIK_HOST=${SUBDOMAIN_VAULT}.${ROOT_DOMAIN}
MESSAGING_TRAEFIK_HOST_CHAT=${SUBDOMAIN_CHAT}.${ROOT_DOMAIN}
MESSAGING_TRAEFIK_HOST_MAIL=${SUBDOMAIN_MAIL}.${ROOT_DOMAIN}
CHAIN_N8N_TRAEFIK_HOST=${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}
CHAIN_SEMAPHORE_TRAEFIK_HOST=${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}

EOF

    echo "✓ domain.env.production updated with missing Traefik hosts"
fi

# =================================================================
# Update domain.env (if being used for production)
# =================================================================
echo "→ Updating domain.env..."

# Check if file exists
if [ ! -f "domain.env" ]; then
    echo "Warning: domain.env not found, skipping"
else
    # Check if it's pointing to production or local
    if grep -q "pivoine.art" domain.env; then
        echo "  domain.env appears to be configured for production"
        
        # Add missing watch stack Traefik hosts
        cat >> domain.env << 'EOF'

# -------------------------------------------------------------------
# Watch Stack - Monitoring & Observability Traefik Hosts
# -------------------------------------------------------------------
WATCH_TRAEFIK_HOST_PROMETHEUS=${SUBDOMAIN_PROMETHEUS}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_GRAFANA=${SUBDOMAIN_GRAFANA}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_LOKI=${SUBDOMAIN_LOKI}.${ROOT_DOMAIN}
WATCH_TRAEFIK_HOST_ALERTMANAGER=${SUBDOMAIN_ALERTMANAGER}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Code Stack - Gitea Traefik Host
# -------------------------------------------------------------------
CODE_GITEA_TRAEFIK_HOST=${SUBDOMAIN_CODE}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Auth Stack - OAuth2 Proxy Traefik Host
# -------------------------------------------------------------------
AUTH_OAUTH2_PROXY_HOST=${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# VPN Stack - Traefik Host
# -------------------------------------------------------------------
VPN_TRAEFIK_HOST=${SUBDOMAIN_VPN}.${ROOT_DOMAIN}

# -------------------------------------------------------------------
# Additional Stack Traefik Hosts
# -------------------------------------------------------------------
BLOG_TRAEFIK_HOST=${SUBDOMAIN_BLOG}.${ROOT_DOMAIN}
SEXY_TRAEFIK_HOST=${SUBDOMAIN_SEXY}.${ROOT_DOMAIN}
NEWS_TRAEFIK_HOST=${SUBDOMAIN_NEWS}.${ROOT_DOMAIN}
LINK_TRAEFIK_HOST=${SUBDOMAIN_LINK}.${ROOT_DOMAIN}
TRACK_TRAEFIK_HOST=${SUBDOMAIN_TRACK}.${ROOT_DOMAIN}
VAULT_TRAEFIK_HOST=${SUBDOMAIN_VAULT}.${ROOT_DOMAIN}
MESSAGING_TRAEFIK_HOST_CHAT=${SUBDOMAIN_CHAT}.${ROOT_DOMAIN}
MESSAGING_TRAEFIK_HOST_MAIL=${SUBDOMAIN_MAIL}.${ROOT_DOMAIN}
CHAIN_N8N_TRAEFIK_HOST=${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}
CHAIN_SEMAPHORE_TRAEFIK_HOST=${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}

EOF

        echo "✓ domain.env updated with missing Traefik hosts"
    else
        echo "  domain.env appears to be configured for local development, skipping"
    fi
fi

# =================================================================
# Update domain.env.local (for completeness)
# =================================================================
echo "→ Updating domain.env.local (if exists)..."

if [ -f "domain.env.local" ]; then
    # For local, use localhost with ports
    cat >> domain.env.local << 'EOF'

# -------------------------------------------------------------------
# Watch Stack - Local Monitoring Ports
# -------------------------------------------------------------------
WATCH_TRAEFIK_HOST_PROMETHEUS=localhost:9090
WATCH_TRAEFIK_HOST_GRAFANA=localhost:3010
WATCH_TRAEFIK_HOST_LOKI=localhost:3100
WATCH_TRAEFIK_HOST_ALERTMANAGER=localhost:9093

# -------------------------------------------------------------------
# Code Stack - Local Gitea Port
# -------------------------------------------------------------------
CODE_GITEA_TRAEFIK_HOST=localhost:3001

# -------------------------------------------------------------------
# Auth Stack - Local OAuth2 Proxy Port
# -------------------------------------------------------------------
AUTH_OAUTH2_PROXY_HOST=localhost:4180

# -------------------------------------------------------------------
# VPN Stack - Local Port
# -------------------------------------------------------------------
VPN_TRAEFIK_HOST=localhost:51821

EOF

    echo "✓ domain.env.local updated with missing local ports"
fi

echo ""
echo "✓ Domain configuration files updated successfully"
echo ""
echo "Note: Verify that subdomain variables are defined in domain.env:"
echo "  - SUBDOMAIN_PROMETHEUS, SUBDOMAIN_GRAFANA, SUBDOMAIN_LOKI, SUBDOMAIN_ALERTMANAGER"
echo "  - SUBDOMAIN_CODE, SUBDOMAIN_OAUTH2, SUBDOMAIN_VPN"
