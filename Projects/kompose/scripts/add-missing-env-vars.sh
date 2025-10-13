#!/bin/bash
# =================================================================
# Add Missing Environment Variables to .env files
# =================================================================

set -e

echo "Adding missing environment variables..."

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
# Update .env (local development)
# =================================================================
echo "→ Updating .env (local development)..."

# Core Stack - Add missing DB_HOST
add_if_missing ".env" "CORE_DB_HOST" "core-postgres"
add_if_missing ".env" "CORE_DB_PORT" "5432"
add_if_missing ".env" "CORE_REDIS_HOST" "core-redis"

# Auth Stack - ensure prefixed versions exist
add_if_missing ".env" "AUTH_DOCKER_IMAGE" "quay.io/keycloak/keycloak:latest"

# Code Stack - Add missing Gitea variables
add_if_missing ".env" "CODE_GITEA_UID" "1000"
add_if_missing ".env" "CODE_GITEA_GID" "1000"
add_if_missing ".env" "CODE_GITEA_DISABLE_REGISTRATION" "false"
add_if_missing ".env" "CODE_GITEA_REQUIRE_SIGNIN" "false"
add_if_missing ".env" "CODE_GITEA_EMAIL_CONFIRM" "false"
add_if_missing ".env" "CODE_GITEA_WEBHOOK_ALLOWED_HOSTS" "*"
add_if_missing ".env" "CODE_GITEA_WEBHOOK_SKIP_TLS" "false"
add_if_missing ".env" "CODE_GITEA_LOG_LEVEL" "Info"
add_if_missing ".env" "CODE_GITEA_RUNNER_NAME" "kompose-runner-1"
add_if_missing ".env" "CODE_GITEA_RUNNER_LABELS" "ubuntu-latest:docker://node:16-bullseye"

# Messaging Stack - Add Gotify user config
add_if_missing ".env" "MESSAGING_GOTIFY_DEFAULTUSER_NAME" "admin"
add_if_missing ".env" "MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED" "false"

# VPN Stack - Add missing variables
add_if_missing ".env" "VPN_DOCKER_IMAGE" "weejewel/wg-easy:latest"
add_if_missing ".env" "VPN_APP_PORT" "51821"
add_if_missing ".env" "VPN_LANG" "en"
add_if_missing ".env" "VPN_UI_TRAFFIC_STATS" "true"
add_if_missing ".env" "VPN_UI_CHART_TYPE" "0"

# Vault Stack - Add missing variables
add_if_missing ".env" "VAULT_DOCKER_IMAGE" "vaultwarden/server:latest"
add_if_missing ".env" "VAULT_APP_PORT" "80"
add_if_missing ".env" "VAULT_WEBSOCKET_ENABLED" "true"
add_if_missing ".env" "VAULT_MQTT_ENABLED" "true"

# Custom Stacks - Blog
add_if_missing ".env" "BLOG_DOCKER_IMAGE" "joseluisq/static-web-server:latest"

# Custom Stacks - Sexy (Directus)
add_if_missing ".env" "SEXY_DIRECTUS_BUNDLE" "./extensions"
add_if_missing ".env" "SEXY_CACHE_ENABLED" "true"
add_if_missing ".env" "SEXY_CACHE_AUTO_PURGE" "true"
add_if_missing ".env" "SEXY_WEBSOCKETS_ENABLED" "true"
add_if_missing ".env" "SEXY_PUBLIC_URL" "https://sexy.pivoine.art"
add_if_missing ".env" "SEXY_CORS_ENABLED" "true"
add_if_missing ".env" "SEXY_CORS_ORIGIN" "true"
add_if_missing ".env" "SEXY_SESSION_COOKIE_SECURE" "true"
add_if_missing ".env" "SEXY_SESSION_COOKIE_SAME_SITE" "lax"
add_if_missing ".env" "SEXY_SESSION_COOKIE_DOMAIN" ".pivoine.art"
add_if_missing ".env" "SEXY_EXTENSIONS_PATH" "./extensions"
add_if_missing ".env" "SEXY_EXTENSIONS_AUTO_RELOAD" "false"
add_if_missing ".env" "SEXY_CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC" "'self' https://sexy.pivoine.art"
add_if_missing ".env" "SEXY_USER_REGISTER_URL_ALLOW_LIST" ""
add_if_missing ".env" "SEXY_PASSWORD_RESET_URL_ALLOW_LIST" ""
add_if_missing ".env" "SEXY_FRONTEND_IMAGE" "node:20-alpine"
add_if_missing ".env" "SEXY_FRONTEND_PORT" "3000"

# News Stack
add_if_missing ".env" "NEWS_DOCKER_IMAGE" "letterpad/letterpad:latest"

# Link Stack
add_if_missing ".env" "LINK_DOCKER_IMAGE" "ghcr.io/linkwarden/linkwarden:latest"

# Track Stack
add_if_missing ".env" "TRACK_DOCKER_IMAGE" "ghcr.io/umami-software/umami:postgresql-latest"

# =================================================================
# Update .env.production (production deployment)
# =================================================================
echo "→ Updating .env.production (production deployment)..."

# Core Stack
add_if_missing ".env.production" "CORE_DB_HOST" "core-postgres"
add_if_missing ".env.production" "CORE_DB_PORT" "5432"
add_if_missing ".env.production" "CORE_REDIS_HOST" "core-redis"

# Auth Stack
add_if_missing ".env.production" "AUTH_DOCKER_IMAGE" "quay.io/keycloak/keycloak:latest"

# Code Stack
add_if_missing ".env.production" "CODE_GITEA_UID" "1000"
add_if_missing ".env.production" "CODE_GITEA_GID" "1000"
add_if_missing ".env.production" "CODE_GITEA_DISABLE_REGISTRATION" "true"
add_if_missing ".env.production" "CODE_GITEA_REQUIRE_SIGNIN" "true"
add_if_missing ".env.production" "CODE_GITEA_EMAIL_CONFIRM" "true"
add_if_missing ".env.production" "CODE_GITEA_WEBHOOK_ALLOWED_HOSTS" "*.pivoine.art"
add_if_missing ".env.production" "CODE_GITEA_WEBHOOK_SKIP_TLS" "false"
add_if_missing ".env.production" "CODE_GITEA_LOG_LEVEL" "Warn"
add_if_missing ".env.production" "CODE_GITEA_RUNNER_NAME" "kompose-runner-production"
add_if_missing ".env.production" "CODE_GITEA_RUNNER_LABELS" "ubuntu-latest:docker://node:20-bullseye"

# Messaging Stack
add_if_missing ".env.production" "MESSAGING_GOTIFY_DEFAULTUSER_NAME" "admin"
add_if_missing ".env.production" "MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED" "true"

# VPN Stack
add_if_missing ".env.production" "VPN_DOCKER_IMAGE" "weejewel/wg-easy:latest"
add_if_missing ".env.production" "VPN_APP_PORT" "51821"
add_if_missing ".env.production" "VPN_LANG" "en"
add_if_missing ".env.production" "VPN_UI_TRAFFIC_STATS" "true"
add_if_missing ".env.production" "VPN_UI_CHART_TYPE" "1"

# Vault Stack
add_if_missing ".env.production" "VAULT_DOCKER_IMAGE" "vaultwarden/server:latest"
add_if_missing ".env.production" "VAULT_APP_PORT" "80"
add_if_missing ".env.production" "VAULT_WEBSOCKET_ENABLED" "true"
add_if_missing ".env.production" "VAULT_MQTT_ENABLED" "true"

# Custom Stacks - Blog
add_if_missing ".env.production" "BLOG_DOCKER_IMAGE" "joseluisq/static-web-server:latest"

# Custom Stacks - Sexy
add_if_missing ".env.production" "SEXY_DIRECTUS_BUNDLE" "./extensions"
add_if_missing ".env.production" "SEXY_CACHE_ENABLED" "true"
add_if_missing ".env.production" "SEXY_CACHE_AUTO_PURGE" "true"
add_if_missing ".env.production" "SEXY_WEBSOCKETS_ENABLED" "true"
add_if_missing ".env.production" "SEXY_PUBLIC_URL" "https://sexy.pivoine.art"
add_if_missing ".env.production" "SEXY_CORS_ENABLED" "true"
add_if_missing ".env.production" "SEXY_CORS_ORIGIN" "https://sexy.pivoine.art"
add_if_missing ".env.production" "SEXY_SESSION_COOKIE_SECURE" "true"
add_if_missing ".env.production" "SEXY_SESSION_COOKIE_SAME_SITE" "lax"
add_if_missing ".env.production" "SEXY_SESSION_COOKIE_DOMAIN" ".pivoine.art"
add_if_missing ".env.production" "SEXY_EXTENSIONS_PATH" "./extensions"
add_if_missing ".env.production" "SEXY_EXTENSIONS_AUTO_RELOAD" "false"
add_if_missing ".env.production" "SEXY_CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC" "'self' https://sexy.pivoine.art"
add_if_missing ".env.production" "SEXY_USER_REGISTER_URL_ALLOW_LIST" "https://sexy.pivoine.art"
add_if_missing ".env.production" "SEXY_PASSWORD_RESET_URL_ALLOW_LIST" "https://sexy.pivoine.art"
add_if_missing ".env.production" "SEXY_FRONTEND_IMAGE" "node:20-alpine"
add_if_missing ".env.production" "SEXY_FRONTEND_PORT" "3000"

# News Stack
add_if_missing ".env.production" "NEWS_DOCKER_IMAGE" "letterpad/letterpad:latest"

# Link Stack
add_if_missing ".env.production" "LINK_DOCKER_IMAGE" "ghcr.io/linkwarden/linkwarden:latest"

# Track Stack
add_if_missing ".env.production" "TRACK_DOCKER_IMAGE" "ghcr.io/umami-software/umami:postgresql-latest"

echo "✓ Environment variables added successfully"
echo ""
echo "Note: Review the added variables and adjust values as needed"
