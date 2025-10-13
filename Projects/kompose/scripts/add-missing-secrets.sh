#!/bin/bash
# =================================================================
# Add Missing Secrets - Generate and add missing secrets to secrets.env
# =================================================================

set -e

echo "Adding missing secrets to secrets.env..."

# =================================================================
# Secret generation function
# =================================================================
generate_secret() {
    openssl rand -base64 32
}

generate_password() {
    openssl rand -base64 24 | tr -d "=+/" | cut -c1-24
}

generate_htpasswd() {
    local username="$1"
    local password="$2"
    echo "$(htpasswd -nb "$username" "$password" 2>/dev/null || echo "$username:\$apr1\$salt\$hash")"
}

# =================================================================
# Check if htpasswd is available
# =================================================================
if ! command -v htpasswd &> /dev/null; then
    echo "Warning: htpasswd not found. Basic auth credentials will need manual generation."
    echo "Install with: sudo apt-get install apache2-utils (Debian/Ubuntu)"
    echo "           or: sudo yum install httpd-tools (CentOS/RHEL)"
    HTPASSWD_AVAILABLE=false
else
    HTPASSWD_AVAILABLE=true
fi

# =================================================================
# Function to add secret if it doesn't exist
# =================================================================
add_secret_if_missing() {
    local var_name="$1"
    local var_value="$2"
    
    if ! grep -q "^${var_name}=" secrets.env 2>/dev/null; then
        echo "${var_name}=${var_value}" >> secrets.env
        echo "  ✓ Added: ${var_name}"
        return 0
    else
        echo "  ⊘ Skipped (exists): ${var_name}"
        return 1
    fi
}

# =================================================================
# Backup existing secrets.env
# =================================================================
if [ -f "secrets.env" ]; then
    cp secrets.env "secrets.env.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✓ Backed up existing secrets.env"
fi

# =================================================================
# Add header to secrets file if it doesn't exist
# =================================================================
if [ ! -f "secrets.env" ]; then
    cat > secrets.env << 'EOF'
# =================================================================
# KOMPOSE - Secrets Configuration
# =================================================================
# GENERATED FILE - Keep this secure and do not commit to git!
# Generated: $(date)
# =================================================================

EOF
fi

echo ""
echo "→ Adding Watch Stack secrets..."

# Watch Stack - Prometheus Auth
if [ "$HTPASSWD_AVAILABLE" = true ]; then
    PROMETHEUS_USER="admin"
    PROMETHEUS_PASS=$(generate_password)
    PROMETHEUS_AUTH=$(generate_htpasswd "$PROMETHEUS_USER" "$PROMETHEUS_PASS")
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH" "$PROMETHEUS_AUTH"
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH_USER" "$PROMETHEUS_USER"
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH_PASSWORD" "$PROMETHEUS_PASS"
else
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH" "admin:\$apr1\$CHANGEME\$CHANGEME"
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH_USER" "admin"
    add_secret_if_missing "WATCH_PROMETHEUS_AUTH_PASSWORD" "CHANGE_ME_MANUALLY"
fi

# Watch Stack - Grafana
add_secret_if_missing "WATCH_GRAFANA_ADMIN_PASSWORD" "$(generate_password)"
add_secret_if_missing "WATCH_GRAFANA_DB_PASSWORD" "$(generate_password)"

# Watch Stack - Exporters
add_secret_if_missing "WATCH_POSTGRES_EXPORTER_PASSWORD" "$(generate_password)"
add_secret_if_missing "WATCH_REDIS_EXPORTER_PASSWORD" "\${REDIS_PASSWORD}"

# Watch Stack - Loki Auth
if [ "$HTPASSWD_AVAILABLE" = true ]; then
    LOKI_USER="admin"
    LOKI_PASS=$(generate_password)
    LOKI_AUTH=$(generate_htpasswd "$LOKI_USER" "$LOKI_PASS")
    add_secret_if_missing "WATCH_LOKI_AUTH" "$LOKI_AUTH"
    add_secret_if_missing "WATCH_LOKI_AUTH_USER" "$LOKI_USER"
    add_secret_if_missing "WATCH_LOKI_AUTH_PASSWORD" "$LOKI_PASS"
else
    add_secret_if_missing "WATCH_LOKI_AUTH" "admin:\$apr1\$CHANGEME\$CHANGEME"
    add_secret_if_missing "WATCH_LOKI_AUTH_USER" "admin"
    add_secret_if_missing "WATCH_LOKI_AUTH_PASSWORD" "CHANGE_ME_MANUALLY"
fi

# Watch Stack - Alertmanager Auth
if [ "$HTPASSWD_AVAILABLE" = true ]; then
    ALERTMANAGER_USER="admin"
    ALERTMANAGER_PASS=$(generate_password)
    ALERTMANAGER_AUTH=$(generate_htpasswd "$ALERTMANAGER_USER" "$ALERTMANAGER_PASS")
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH" "$ALERTMANAGER_AUTH"
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH_USER" "$ALERTMANAGER_USER"
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH_PASSWORD" "$ALERTMANAGER_PASS"
else
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH" "admin:\$apr1\$CHANGEME\$CHANGEME"
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH_USER" "admin"
    add_secret_if_missing "WATCH_ALERTMANAGER_AUTH_PASSWORD" "CHANGE_ME_MANUALLY"
fi

echo ""
echo "→ Adding Messaging Stack secrets..."

# Messaging Stack - Gotify
add_secret_if_missing "MESSAGING_GOTIFY_DEFAULTUSER_PASS" "$(generate_password)"

echo ""
echo "→ Adding Code Stack secrets (if not already present)..."

# Code Stack - These should already exist from initial generation
# We'll only add them if completely missing
add_secret_if_missing "CODE_GITEA_SECRET_KEY" "$(generate_secret | tr -d '\n')"
add_secret_if_missing "CODE_GITEA_INTERNAL_TOKEN" "$(openssl rand -hex 64)"
add_secret_if_missing "CODE_GITEA_OAUTH2_JWT_SECRET" "$(generate_secret)"
add_secret_if_missing "CODE_GITEA_METRICS_TOKEN" "$(openssl rand -hex 16)"
add_secret_if_missing "CODE_GITEA_RUNNER_TOKEN" "GENERATE_IN_GITEA_UI_AFTER_FIRST_START"

echo ""
echo "→ Adding Chain Stack secrets (if not already present)..."

# Chain Stack - These should already exist
add_secret_if_missing "CHAIN_N8N_ENCRYPTION_KEY" "$(generate_secret)"
add_secret_if_missing "CHAIN_N8N_BASIC_AUTH_PASSWORD" "$(generate_password)"
add_secret_if_missing "CHAIN_SEMAPHORE_ADMIN_PASSWORD" "$(generate_password)"
add_secret_if_missing "CHAIN_SEMAPHORE_RUNNER_TOKEN" "$(generate_secret)"

echo ""
echo "→ Adding Custom Stack secrets..."

# Sexy Stack - Directus
add_secret_if_missing "SEXY_DIRECTUS_SECRET" "$(generate_secret)"

# News Stack
add_secret_if_missing "NEWS_JWT_SECRET" "$(generate_secret)"

# Track Stack
add_secret_if_missing "TRACK_APP_SECRET" "$(generate_secret)"

# Vault Stack - Ensure admin token is set
add_secret_if_missing "VAULT_ADMIN_TOKEN" "$(generate_secret)"

echo ""
echo "✓ Secrets added successfully"
echo ""
echo "=========================================="
echo "IMPORTANT: Review secrets.env"
echo "=========================================="
echo ""

if [ "$HTPASSWD_AVAILABLE" = false ]; then
    echo "⚠️  htpasswd not available - Basic auth credentials need manual generation"
    echo ""
fi

echo "Credentials generated for the following services:"
echo ""

# Display credentials for easy reference
if [ "$HTPASSWD_AVAILABLE" = true ]; then
    echo "Watch Stack:"
    echo "  Prometheus: User: admin, Password: $PROMETHEUS_PASS"
    echo "  Loki: User: admin, Password: $LOKI_PASS"
    echo "  Alertmanager: User: admin, Password: $ALERTMANAGER_PASS"
    echo ""
fi

echo "These credentials have been saved to secrets.env"
echo ""
echo "Next steps:"
echo "  1. Review secrets.env and update any CHANGE_ME values"
echo "  2. Ensure secrets.env is NOT committed to git"
echo "  3. Keep a secure backup of secrets.env"
echo "  4. For Code Stack: Generate runner token in Gitea UI after first start"
echo ""
echo "To view all secrets: cat secrets.env | grep -v '^#' | grep -v '^$'"
echo ""
