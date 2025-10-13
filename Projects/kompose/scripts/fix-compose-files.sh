#!/bin/bash
# =================================================================
# Fix Compose Files - Update variable names to match .env files
# =================================================================

set -e

echo "Fixing compose.yaml files..."

# =================================================================
# CORE STACK
# =================================================================
echo "→ Fixing core/compose.yaml..."
sed -i 's/\${POSTGRES_IMAGE:-postgres:16-alpine}/${CORE_POSTGRES_IMAGE:-postgres:16-alpine}/g' core/compose.yaml
sed -i 's/\${REDIS_IMAGE:-redis:7-alpine}/${CORE_REDIS_IMAGE:-redis:7-alpine}/g' core/compose.yaml
sed -i 's/\${MOSQUITTO_IMAGE:-eclipse-mosquitto:2}/${CORE_MOSQUITTO_IMAGE:-eclipse-mosquitto:2}/g' core/compose.yaml
sed -i 's/\${REDIS_COMMANDER_IMAGE:-rediscommander\/redis-commander:latest}/${CORE_REDIS_COMMANDER_IMAGE:-rediscommander\/redis-commander:latest}/g' core/compose.yaml
sed -i 's/\${DB_USER:-kompose}/${CORE_DB_USER:-kompose}/g' core/compose.yaml
sed -i 's/\${DB_NAME:-kompose}/${CORE_DB_NAME:-kompose}/g' core/compose.yaml
sed -i 's/\${POSTGRES_MAX_CONNECTIONS:-100}/${CORE_POSTGRES_MAX_CONNECTIONS:-100}/g' core/compose.yaml
sed -i 's/\${POSTGRES_SHARED_BUFFERS:-256MB}/${CORE_POSTGRES_SHARED_BUFFERS:-256MB}/g' core/compose.yaml
sed -i 's/\${MQTT_PORT:-1883}/${CORE_MQTT_PORT:-1883}/g' core/compose.yaml
sed -i 's/\${MQTT_WS_PORT:-9001}/${CORE_MQTT_WS_PORT:-9001}/g' core/compose.yaml
sed -i 's/\${REDIS_API_USER:-admin}/${CORE_REDIS_API_USER:-admin}/g' core/compose.yaml
sed -i 's/\${REDIS_API_PORT:-8081}/${CORE_REDIS_API_PORT:-8081}/g' core/compose.yaml
sed -i 's/\${REDIS_API_TRAEFIK_HOST}/${CORE_REDIS_API_TRAEFIK_HOST}/g' core/compose.yaml

# Update DB_PASSWORD and REDIS_PASSWORD references (keeping generic for now as they're in secrets.env)
# These are intentionally shared across stacks

# =================================================================
# AUTH STACK
# =================================================================
echo "→ Fixing auth/compose.yaml..."
sed -i 's/\${DOCKER_IMAGE}/${AUTH_DOCKER_IMAGE}/g' auth/compose.yaml
sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' auth/compose.yaml
sed -i 's/\${DB_PORT}/${CORE_DB_PORT}/g' auth/compose.yaml
sed -i 's/\${DB_NAME}/${AUTH_DB_NAME}/g' auth/compose.yaml
sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' auth/compose.yaml
sed -i 's/\${KC_ADMIN_USERNAME}/${AUTH_KC_ADMIN_USERNAME}/g' auth/compose.yaml
sed -i 's/\${KC_ADMIN_PASSWORD}/${AUTH_KC_ADMIN_PASSWORD}/g' auth/compose.yaml
sed -i 's/\${OAUTH2_CLIENT_ID:-kompose-sso}/${AUTH_OAUTH2_CLIENT_ID:-kompose-sso}/g' auth/compose.yaml
sed -i 's/\${OAUTH2_CLIENT_SECRET}/${AUTH_OAUTH2_CLIENT_SECRET}/g' auth/compose.yaml
sed -i 's/\${OAUTH2_COOKIE_SECRET}/${AUTH_OAUTH2_COOKIE_SECRET}/g' auth/compose.yaml
sed -i 's/\${OAUTH2_PROXY_HOST}/${AUTH_OAUTH2_PROXY_HOST}/g' auth/compose.yaml

# =================================================================
# CHAIN STACK
# =================================================================
echo "→ Fixing chain/compose.yaml..."
sed -i 's/\${N8N_IMAGE:-n8nio\/n8n:latest}/${CHAIN_N8N_IMAGE:-n8nio\/n8n:latest}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_IMAGE:-semaphoreui\/semaphore:v2.16.18}/${CHAIN_SEMAPHORE_IMAGE:-semaphoreui\/semaphore:latest}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_RUNNER_IMAGE:-public.ecr.aws\/semaphore\/pro\/runner:v2.16.18}/${CHAIN_SEMAPHORE_RUNNER_IMAGE:-public.ecr.aws\/semaphore\/pro\/runner:latest}/g' chain/compose.yaml
sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' chain/compose.yaml
sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' chain/compose.yaml
sed -i 's/\${N8N_DB_NAME:-n8n}/${CHAIN_N8N_DB_NAME:-n8n}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_DB_NAME:-semaphore}/${CHAIN_SEMAPHORE_DB_NAME:-semaphore}/g' chain/compose.yaml
sed -i 's/\${N8N_PORT:-5678}/${CHAIN_N8N_PORT:-5678}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_PORT:-3000}/${CHAIN_SEMAPHORE_PORT:-3000}/g' chain/compose.yaml
sed -i 's/\${N8N_ENCRYPTION_KEY}/${CHAIN_N8N_ENCRYPTION_KEY}/g' chain/compose.yaml
sed -i 's/\${N8N_BASIC_AUTH_USER:-admin}/${CHAIN_N8N_BASIC_AUTH_USER:-admin}/g' chain/compose.yaml
sed -i 's/\${N8N_BASIC_AUTH_PASSWORD}/${CHAIN_N8N_BASIC_AUTH_PASSWORD}/g' chain/compose.yaml
sed -i 's/\${N8N_BASIC_AUTH_ACTIVE:-true}/${CHAIN_N8N_BASIC_AUTH_ACTIVE:-true}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_ADMIN:-admin}/${CHAIN_SEMAPHORE_ADMIN_USERNAME:-admin}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_ADMIN_PASSWORD}/${CHAIN_SEMAPHORE_ADMIN_PASSWORD}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_ADMIN_NAME:-Admin}/${CHAIN_SEMAPHORE_ADMIN_NAME:-Admin}/g' chain/compose.yaml
sed -i 's/\${SEMAPHORE_RUNNER_TOKEN}/${CHAIN_SEMAPHORE_RUNNER_TOKEN}/g' chain/compose.yaml

# =================================================================
# WATCH STACK - Most comprehensive changes
# =================================================================
echo "→ Fixing watch/compose.yaml..."
# Images
sed -i 's/\${PROMETHEUS_IMAGE:-prom\/prometheus:latest}/${WATCH_PROMETHEUS_IMAGE:-prom\/prometheus:latest}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_IMAGE:-grafana\/grafana:latest}/${WATCH_GRAFANA_IMAGE:-grafana\/grafana:latest}/g' watch/compose.yaml
sed -i 's/\${OTEL_IMAGE:-otel\/opentelemetry-collector-contrib:latest}/${WATCH_OTEL_IMAGE:-otel\/opentelemetry-collector-contrib:latest}/g' watch/compose.yaml
sed -i 's/\${POSTGRES_EXPORTER_IMAGE:-prometheuscommunity\/postgres-exporter:latest}/${WATCH_POSTGRES_EXPORTER_IMAGE:-prometheuscommunity\/postgres-exporter:latest}/g' watch/compose.yaml
sed -i 's/\${REDIS_EXPORTER_IMAGE:-oliver006\/redis_exporter:latest}/${WATCH_REDIS_EXPORTER_IMAGE:-oliver006\/redis_exporter:latest}/g' watch/compose.yaml
sed -i 's/\${MQTT_EXPORTER_IMAGE:-kpetrem\/mqtt-exporter:latest}/${WATCH_MQTT_EXPORTER_IMAGE:-kpetrem\/mqtt-exporter:latest}/g' watch/compose.yaml
sed -i 's/\${CADVISOR_IMAGE:-gcr.io\/cadvisor\/cadvisor:latest}/${WATCH_CADVISOR_IMAGE:-gcr.io\/cadvisor\/cadvisor:latest}/g' watch/compose.yaml
sed -i 's/\${NODE_EXPORTER_IMAGE:-prom\/node-exporter:latest}/${WATCH_NODE_EXPORTER_IMAGE:-prom\/node-exporter:latest}/g' watch/compose.yaml
sed -i 's/\${BLACKBOX_EXPORTER_IMAGE:-prom\/blackbox-exporter:latest}/${WATCH_BLACKBOX_EXPORTER_IMAGE:-prom\/blackbox-exporter:latest}/g' watch/compose.yaml
sed -i 's/\${LOKI_IMAGE:-grafana\/loki:latest}/${WATCH_LOKI_IMAGE:-grafana\/loki:latest}/g' watch/compose.yaml
sed -i 's/\${PROMTAIL_IMAGE:-grafana\/promtail:latest}/${WATCH_PROMTAIL_IMAGE:-grafana\/promtail:latest}/g' watch/compose.yaml
sed -i 's/\${ALERTMANAGER_IMAGE:-prom\/alertmanager:latest}/${WATCH_ALERTMANAGER_IMAGE:-prom\/alertmanager:latest}/g' watch/compose.yaml

# Ports
sed -i 's/\${PROMETHEUS_PORT:-9090}/${WATCH_PROMETHEUS_PORT:-9090}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_PORT:-3001}/${WATCH_GRAFANA_PORT:-3010}/g' watch/compose.yaml
sed -i 's/\${OTEL_GRPC_PORT:-4317}/${WATCH_OTEL_GRPC_PORT:-4317}/g' watch/compose.yaml
sed -i 's/\${OTEL_HTTP_PORT:-4318}/${WATCH_OTEL_HTTP_PORT:-4318}/g' watch/compose.yaml
sed -i 's/\${OTEL_HEALTH_PORT:-13133}/${WATCH_OTEL_HEALTH_PORT:-13133}/g' watch/compose.yaml
sed -i 's/\${OTEL_ZPAGES_PORT:-55679}/${WATCH_OTEL_ZPAGES_PORT:-55679}/g' watch/compose.yaml
sed -i 's/\${POSTGRES_EXPORTER_PORT:-9187}/${WATCH_POSTGRES_EXPORTER_PORT:-9187}/g' watch/compose.yaml
sed -i 's/\${REDIS_EXPORTER_PORT:-9121}/${WATCH_REDIS_EXPORTER_PORT:-9121}/g' watch/compose.yaml
sed -i 's/\${MQTT_EXPORTER_PORT:-9000}/${WATCH_MQTT_EXPORTER_PORT:-9000}/g' watch/compose.yaml
sed -i 's/\${CADVISOR_PORT:-8082}/${WATCH_CADVISOR_PORT:-8082}/g' watch/compose.yaml
sed -i 's/\${BLACKBOX_EXPORTER_PORT:-9115}/${WATCH_BLACKBOX_EXPORTER_PORT:-9115}/g' watch/compose.yaml
sed -i 's/\${LOKI_PORT:-3100}/${WATCH_LOKI_PORT:-3100}/g' watch/compose.yaml
sed -i 's/\${PROMTAIL_PORT:-9080}/${WATCH_PROMTAIL_PORT:-9080}/g' watch/compose.yaml
sed -i 's/\${ALERTMANAGER_PORT:-9093}/${WATCH_ALERTMANAGER_PORT:-9093}/g' watch/compose.yaml

# Configuration
sed -i 's/\${PROMETHEUS_RETENTION:-30d}/${WATCH_PROMETHEUS_RETENTION:-30d}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_ADMIN_USER:-admin}/${WATCH_GRAFANA_ADMIN_USER:-admin}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_ADMIN_PASSWORD}/${WATCH_GRAFANA_ADMIN_PASSWORD}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_PLUGINS:-grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel,grafana-worldmap-panel}/${WATCH_GRAFANA_PLUGINS:-grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel,grafana-worldmap-panel}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_DB_NAME:-grafana}/${WATCH_GRAFANA_DB_NAME:-grafana}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_DB_USER:-grafana}/${WATCH_GRAFANA_DB_USER:-grafana}/g' watch/compose.yaml
sed -i 's/\${GRAFANA_DB_PASSWORD}/${WATCH_GRAFANA_DB_PASSWORD}/g' watch/compose.yaml
sed -i 's/\${POSTGRES_EXPORTER_USER:-kompose}/${WATCH_POSTGRES_EXPORTER_USER:-kompose}/g' watch/compose.yaml
sed -i 's/\${POSTGRES_EXPORTER_DB:-kompose}/${WATCH_POSTGRES_EXPORTER_DB:-kompose}/g' watch/compose.yaml
sed -i 's/\${POSTGRES_EXPORTER_PASSWORD}/${WATCH_POSTGRES_EXPORTER_PASSWORD}/g' watch/compose.yaml
sed -i 's/\${REDIS_EXPORTER_PASSWORD}/${WATCH_REDIS_EXPORTER_PASSWORD}/g' watch/compose.yaml
sed -i 's/\${MQTT_EXPORTER_TOPIC:-#}/${WATCH_MQTT_EXPORTER_TOPIC:-#}/g' watch/compose.yaml
sed -i 's/\${MQTT_V5_PROTOCOL:-False}/${WATCH_MQTT_V5_PROTOCOL:-False}/g' watch/compose.yaml
sed -i 's/\${PROMETHEUS_AUTH}/${WATCH_PROMETHEUS_AUTH}/g' watch/compose.yaml
sed -i 's/\${LOKI_AUTH}/${WATCH_LOKI_AUTH}/g' watch/compose.yaml
sed -i 's/\${ALERTMANAGER_AUTH}/${WATCH_ALERTMANAGER_AUTH}/g' watch/compose.yaml

# Traefik hosts
sed -i 's/\${TRAEFIK_HOST_PROMETHEUS}/${WATCH_TRAEFIK_HOST_PROMETHEUS}/g' watch/compose.yaml
sed -i 's/\${TRAEFIK_HOST_GRAFANA}/${WATCH_TRAEFIK_HOST_GRAFANA}/g' watch/compose.yaml
sed -i 's/\${TRAEFIK_HOST_LOKI}/${WATCH_TRAEFIK_HOST_LOKI}/g' watch/compose.yaml
sed -i 's/\${TRAEFIK_HOST_ALERTMANAGER}/${WATCH_TRAEFIK_HOST_ALERTMANAGER}/g' watch/compose.yaml

# =================================================================
# CODE STACK
# =================================================================
echo "→ Fixing code/compose.yaml..."
sed -i 's/\${GITEA_IMAGE:-gitea\/gitea:latest}/${CODE_GITEA_IMAGE:-gitea\/gitea:latest}/g' code/compose.yaml
sed -i 's/\${GITEA_RUNNER_IMAGE:-gitea\/act_runner:latest}/${CODE_GITEA_RUNNER_IMAGE:-gitea\/act_runner:latest}/g' code/compose.yaml
sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' code/compose.yaml
sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' code/compose.yaml
sed -i 's/\${GITEA_DB_NAME:-gitea}/${CODE_GITEA_DB_NAME:-gitea}/g' code/compose.yaml
sed -i 's/\${REDIS_HOST}/${CORE_REDIS_HOST}/g' code/compose.yaml
sed -i 's/\${GITEA_UID:-1000}/${CODE_GITEA_UID:-1000}/g' code/compose.yaml
sed -i 's/\${GITEA_GID:-1000}/${CODE_GITEA_GID:-1000}/g' code/compose.yaml
sed -i 's/\${GITEA_TRAEFIK_HOST}/${CODE_GITEA_TRAEFIK_HOST}/g' code/compose.yaml
sed -i 's/\${GITEA_SSH_PORT:-2222}/${CODE_GITEA_PORT_SSH:-2222}/g' code/compose.yaml
sed -i 's/\${GITEA_HTTP_PORT:-3000}/${CODE_GITEA_PORT_HTTP:-3001}/g' code/compose.yaml
sed -i 's/\${GITEA_SECRET_KEY}/${CODE_GITEA_SECRET_KEY}/g' code/compose.yaml
sed -i 's/\${GITEA_INTERNAL_TOKEN}/${CODE_GITEA_INTERNAL_TOKEN}/g' code/compose.yaml
sed -i 's/\${GITEA_OAUTH2_JWT_SECRET}/${CODE_GITEA_OAUTH2_JWT_SECRET}/g' code/compose.yaml
sed -i 's/\${GITEA_METRICS_TOKEN}/${CODE_GITEA_METRICS_TOKEN}/g' code/compose.yaml
sed -i 's/\${CODE_RUNNER_TOKEN}/${CODE_GITEA_RUNNER_TOKEN}/g' code/compose.yaml
sed -i 's/\${GITEA_DISABLE_REGISTRATION:-false}/${CODE_GITEA_DISABLE_REGISTRATION:-false}/g' code/compose.yaml
sed -i 's/\${GITEA_REQUIRE_SIGNIN:-false}/${CODE_GITEA_REQUIRE_SIGNIN:-false}/g' code/compose.yaml
sed -i 's/\${GITEA_EMAIL_CONFIRM:-false}/${CODE_GITEA_EMAIL_CONFIRM:-false}/g' code/compose.yaml
sed -i 's/\${WEBHOOK_ALLOWED_HOSTS:-\*}/${CODE_GITEA_WEBHOOK_ALLOWED_HOSTS:-\*}/g' code/compose.yaml
sed -i 's/\${WEBHOOK_SKIP_TLS:-false}/${CODE_GITEA_WEBHOOK_SKIP_TLS:-false}/g' code/compose.yaml
sed -i 's/\${GITEA_LOG_LEVEL:-Info}/${CODE_GITEA_LOG_LEVEL:-Info}/g' code/compose.yaml
sed -i 's/\${GITEA_RUNNER_NAME:-kompose-runner-1}/${CODE_GITEA_RUNNER_NAME:-kompose-runner-1}/g' code/compose.yaml
sed -i 's/\${GITEA_RUNNER_LABELS:-ubuntu-latest:docker:\/\/node:16-bullseye,ubuntu-22.04:docker:\/\/node:16-bullseye}/${CODE_GITEA_RUNNER_LABELS:-ubuntu-latest:docker:\/\/node:16-bullseye}/g' code/compose.yaml

# =================================================================
# MESSAGING STACK
# =================================================================
echo "→ Fixing messaging/compose.yaml..."
sed -i 's/\${GOTIFY_IMAGE}/${MESSAGING_GOTIFY_IMAGE}/g' messaging/compose.yaml
sed -i 's/\${MAILHOG_IMAGE}/${MESSAGING_MAILHOG_IMAGE}/g' messaging/compose.yaml
sed -i 's/\${GOTIFY_PORT}/${MESSAGING_GOTIFY_PORT}/g' messaging/compose.yaml
sed -i 's/\${MAILHOG_PORT}/${MESSAGING_MAILHOG_PORT}/g' messaging/compose.yaml
sed -i 's/\${GOTIFY_DEFAULTUSER_NAME}/${MESSAGING_GOTIFY_DEFAULTUSER_NAME}/g' messaging/compose.yaml
sed -i 's/\${GOTIFY_DEFAULTUSER_PASS}/${MESSAGING_GOTIFY_DEFAULTUSER_PASS}/g' messaging/compose.yaml
sed -i 's/\${MAILHOG_OUTGOING_SMTP_ENABLED:-false}/${MESSAGING_MAILHOG_OUTGOING_SMTP_ENABLED:-false}/g' messaging/compose.yaml

# =================================================================
# VPN STACK
# =================================================================
echo "→ Fixing vpn/compose.yaml..."
sed -i 's/\${DOCKER_IMAGE}/${VPN_DOCKER_IMAGE}/g' vpn/compose.yaml
sed -i 's/\${WG_HOST}/${VPN_WG_HOST}/g' vpn/compose.yaml
sed -i 's/\${WG_PORT}/${VPN_WG_PORT}/g' vpn/compose.yaml
sed -i 's/\${APP_PORT}/${VPN_APP_PORT}/g' vpn/compose.yaml
sed -i 's/\${LANG:-en}/${VPN_LANG:-en}/g' vpn/compose.yaml
sed -i 's/\${UI_TRAFFIC_STATS:-true}/${VPN_UI_TRAFFIC_STATS:-true}/g' vpn/compose.yaml
sed -i 's/\${UI_CHART_TYPE:-0}/${VPN_UI_CHART_TYPE:-0}/g' vpn/compose.yaml

# Fix Traefik label syntax from $ to ${} for consistency
sed -i 's/\$COMPOSE_PROJECT_NAME/\${COMPOSE_PROJECT_NAME}/g' vpn/compose.yaml
sed -i 's/\$TRAEFIK_HOST/\${VPN_TRAEFIK_HOST}/g' vpn/compose.yaml

# =================================================================
# VAULT STACK
# =================================================================
echo "→ Fixing vault/compose.yaml..."
sed -i 's/\${DOCKER_IMAGE}/${VAULT_DOCKER_IMAGE}/g' vault/compose.yaml
sed -i 's/\${JWT_TOKEN}/${VAULT_ADMIN_TOKEN}/g' vault/compose.yaml
sed -i 's/\${WEBSOCKET_ENABLED}/${VAULT_WEBSOCKET_ENABLED}/g' vault/compose.yaml
sed -i 's/\${SIGNUPS_ALLOWED}/${VAULT_SIGNUPS_ALLOWED}/g' vault/compose.yaml
sed -i 's/\${DOMAIN}/${VAULT_TRAEFIK_HOST}/g' vault/compose.yaml
sed -i 's/\${APP_PORT}/${VAULT_APP_PORT}/g' vault/compose.yaml
sed -i 's/\${MQTT_ENABLED:-true}/${VAULT_MQTT_ENABLED:-true}/g' vault/compose.yaml

# =================================================================
# CUSTOM STACKS
# =================================================================
echo "→ Fixing +custom/blog/compose.yaml..."
sed -i 's/\${DOCKER_IMAGE}/${BLOG_DOCKER_IMAGE}/g' +custom/blog/compose.yaml
# Fix Traefik label syntax
sed -i 's/\$COMPOSE_PROJECT_NAME/\${COMPOSE_PROJECT_NAME}/g' +custom/blog/compose.yaml
sed -i 's/\$TRAEFIK_HOST/\${BLOG_TRAEFIK_HOST}/g' +custom/blog/compose.yaml

echo "→ Fixing +custom/sexy/compose.yaml..."
sed -i 's/\${DIRECTUS_BUNDLE}/${SEXY_DIRECTUS_BUNDLE}/g' +custom/sexy/compose.yaml
sed -i 's/\${DIRECTUS_SECRET}/${SEXY_DIRECTUS_SECRET}/g' +custom/sexy/compose.yaml
sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' +custom/sexy/compose.yaml
sed -i 's/\${DB_PORT}/${CORE_DB_PORT}/g' +custom/sexy/compose.yaml
sed -i 's/\${DB_NAME}/${SEXY_DB_NAME}/g' +custom/sexy/compose.yaml
sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' +custom/sexy/compose.yaml
sed -i 's/\${CACHE_ENABLED}/${SEXY_CACHE_ENABLED}/g' +custom/sexy/compose.yaml
sed -i 's/\${CACHE_AUTO_PURGE}/${SEXY_CACHE_AUTO_PURGE}/g' +custom/sexy/compose.yaml
sed -i 's/\${WEBSOCKETS_ENABLED}/${SEXY_WEBSOCKETS_ENABLED}/g' +custom/sexy/compose.yaml
sed -i 's/\${PUBLIC_URL}/${SEXY_PUBLIC_URL}/g' +custom/sexy/compose.yaml
sed -i 's/\${CORS_ENABLED}/${SEXY_CORS_ENABLED}/g' +custom/sexy/compose.yaml
sed -i 's/\${CORS_ORIGIN}/${SEXY_CORS_ORIGIN}/g' +custom/sexy/compose.yaml
sed -i 's/\${SESSION_COOKIE_SECURE}/${SEXY_SESSION_COOKIE_SECURE}/g' +custom/sexy/compose.yaml
sed -i 's/\${SESSION_COOKIE_SAME_SITE}/${SEXY_SESSION_COOKIE_SAME_SITE}/g' +custom/sexy/compose.yaml
sed -i 's/\${SESSION_COOKIE_DOMAIN}/${SEXY_SESSION_COOKIE_DOMAIN}/g' +custom/sexy/compose.yaml
sed -i 's/\${EXTENSIONS_PATH}/${SEXY_EXTENSIONS_PATH}/g' +custom/sexy/compose.yaml
sed -i 's/\${EXTENSIONS_AUTO_RELOAD}/${SEXY_EXTENSIONS_AUTO_RELOAD}/g' +custom/sexy/compose.yaml
sed -i 's/\${CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC}/${SEXY_CONTENT_SECURITY_POLICY_DIRECTIVES__FRAME_SRC}/g' +custom/sexy/compose.yaml
sed -i 's/\${USER_REGISTER_URL_ALLOW_LIST}/${SEXY_USER_REGISTER_URL_ALLOW_LIST}/g' +custom/sexy/compose.yaml
sed -i 's/\${PASSWORD_RESET_URL_ALLOW_LIST}/${SEXY_PASSWORD_RESET_URL_ALLOW_LIST}/g' +custom/sexy/compose.yaml
sed -i 's/\${FRONTEND_IMAGE}/${SEXY_FRONTEND_IMAGE}/g' +custom/sexy/compose.yaml
sed -i 's/\${FRONTEND_PORT}/${SEXY_FRONTEND_PORT}/g' +custom/sexy/compose.yaml
# Fix Traefik label syntax
sed -i 's/\$COMPOSE_PROJECT_NAME/\${COMPOSE_PROJECT_NAME}/g' +custom/sexy/compose.yaml
sed -i 's/\$TRAEFIK_HOST/\${SEXY_TRAEFIK_HOST}/g' +custom/sexy/compose.yaml

echo "→ Fixing +custom/news/compose.yaml (if exists)..."
if [ -f "+custom/news/compose.yaml" ]; then
    sed -i 's/\${DOCKER_IMAGE}/${NEWS_DOCKER_IMAGE}/g' +custom/news/compose.yaml
    sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' +custom/news/compose.yaml
    sed -i 's/\${DB_NAME}/${NEWS_DB_NAME}/g' +custom/news/compose.yaml
    sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' +custom/news/compose.yaml
    sed -i 's/\${JWT_SECRET}/${NEWS_JWT_SECRET}/g' +custom/news/compose.yaml
fi

echo "→ Fixing link/compose.yaml (if exists)..."
if [ -f "link/compose.yaml" ]; then
    sed -i 's/\${DOCKER_IMAGE}/${LINK_DOCKER_IMAGE}/g' link/compose.yaml
    sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' link/compose.yaml
    sed -i 's/\${DB_NAME}/${LINK_DB_NAME}/g' link/compose.yaml
    sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' link/compose.yaml
fi

echo "→ Fixing track/compose.yaml (if exists)..."
if [ -f "track/compose.yaml" ]; then
    sed -i 's/\${DOCKER_IMAGE}/${TRACK_DOCKER_IMAGE}/g' track/compose.yaml
    sed -i 's/\${DB_HOST}/${CORE_DB_HOST}/g' track/compose.yaml
    sed -i 's/\${DB_NAME}/${TRACK_DB_NAME}/g' track/compose.yaml
    sed -i 's/\${DB_USER}/${CORE_DB_USER}/g' track/compose.yaml
    sed -i 's/\${APP_SECRET}/${TRACK_APP_SECRET}/g' track/compose.yaml
fi

echo "✓ All compose.yaml files updated successfully"
