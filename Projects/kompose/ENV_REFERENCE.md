# Kompose Environment Variables Reference

**Complete reference of all environment variables used across all stacks**

Generated: 2025-10-13

---

## Table of Contents

1. [Global Variables](#global-variables)
2. [Domain Configuration](#domain-configuration)
3. [Core Stack](#core-stack)
4. [Auth Stack](#auth-stack)
5. [Proxy Stack](#proxy-stack)
6. [Messaging Stack](#messaging-stack)
7. [Chain Stack](#chain-stack)
8. [Code Stack](#code-stack)
9. [KMPS Stack](#kmps-stack)
10. [Home Stack](#home-stack)
11. [VPN Stack](#vpn-stack)
12. [Utility Stacks](#utility-stacks)

---

## Global Variables

These variables are used across multiple stacks.

| Variable | Required | Default | Description | Location |
|----------|----------|---------|-------------|----------|
| `NETWORK_NAME` | Yes | `kompose` | Docker network name | .env.production |
| `TIMEZONE` | Yes | `Europe/Amsterdam` | System timezone | .env.production |
| `ADMIN_EMAIL` | Yes | - | Administrator email | .env.production |
| `DB_USER` | Yes | `kompose` | PostgreSQL username | secrets.env |
| `DB_PASSWORD` | Yes | - | PostgreSQL password | secrets.env |
| `DB_HOST` | Yes | `core-postgres` | PostgreSQL host | .env.production |
| `DB_PORT` | Yes | `5432` | PostgreSQL port | .env.production |
| `REDIS_PASSWORD` | Yes | - | Redis password | secrets.env |
| `REDIS_HOST` | Yes | `core-redis` | Redis host | .env.production |
| `EMAIL_TRANSPORT` | Yes | `smtp` | Email transport type | .env.production |
| `EMAIL_FROM` | Yes | - | Email sender address | .env.production |
| `EMAIL_SMTP_HOST` | Yes | `messaging_mailhog` | SMTP server host | .env.production |
| `EMAIL_SMTP_PORT` | Yes | `1025` | SMTP server port | .env.production |
| `EMAIL_SMTP_USER` | No | - | SMTP username | .env.production |
| `EMAIL_SMTP_PASSWORD` | No | - | SMTP password | secrets.env |

---

## Domain Configuration

Variables from `domain.env.production`

### Root Domain

| Variable | Value | Description |
|----------|-------|-------------|
| `ROOT_DOMAIN` | `pivoine.art` | Root domain name |
| `BASE_DOMAIN` | `${ROOT_DOMAIN}` | Base domain alias |
| `ACME_EMAIL` | `valknar@pivoine.art` | Let's Encrypt email |

### Subdomains

| Variable | Default Value | Service |
|----------|---------------|---------|
| `SUBDOMAIN_PROXY` | `traefik` | Traefik |
| `SUBDOMAIN_AUTH` | `auth` | Keycloak |
| `SUBDOMAIN_CODE` | `code` | Gitea |
| `SUBDOMAIN_CHAIN` | `chain` | n8n |
| `SUBDOMAIN_AUTO` | `auto` | Semaphore |
| `SUBDOMAIN_NEWS` | `news` | Letterspace |
| `SUBDOMAIN_CHAT` | `chat` | Gotify |
| `SUBDOMAIN_MAIL` | `mail` | Mailhog |
| `SUBDOMAIN_TRACK` | `track` | Umami |
| `SUBDOMAIN_HOME` | `home` | Home Assistant |
| `SUBDOMAIN_VAULT` | `vault` | Vaultwarden |
| `SUBDOMAIN_LINK` | `link` | Linkwarden |
| `SUBDOMAIN_MANAGE` | `manage` | KMPS |
| `SUBDOMAIN_VPN` | `vpn` | WireGuard |
| `SUBDOMAIN_OAUTH2` | `oauth` | OAuth2 Proxy |
| `SUBDOMAIN_ZIGBEE` | `zigbee` | Zigbee2MQTT |

### Traefik Hosts

| Variable | Computed Value |
|----------|----------------|
| `TRAEFIK_HOST` | `${SUBDOMAIN_AUTH}.${ROOT_DOMAIN}` |
| `N8N_TRAEFIK_HOST` | `${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}` |
| `SEMAPHORE_TRAEFIK_HOST` | `${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}` |
| `TRAEFIK_HOST_HOME` | `${SUBDOMAIN_HOME}.${ROOT_DOMAIN}` |
| `TRAEFIK_HOST_ZIGBEE` | `${SUBDOMAIN_ZIGBEE}.${ROOT_DOMAIN}` |
| `OAUTH2_PROXY_HOST` | `${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}` |

---

## Core Stack

Database, cache, and message broker services.

### Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CORE_COMPOSE_PROJECT_NAME` | Yes | `core` | Docker compose project name |
| `CORE_POSTGRES_IMAGE` | No | `postgres:16-alpine` | PostgreSQL image |
| `DB_USER` | Yes | `kompose` | Database username |
| `CORE_DB_NAME` | Yes | `kompose` | Database name |
| `CORE_DB_PORT` | Yes | `5432` | Database port |
| `CORE_DB_HOST` | Yes | `localhost` | Database host (local dev) |
| `CORE_POSTGRES_MAX_CONNECTIONS` | No | `100` | Max connections |
| `CORE_POSTGRES_SHARED_BUFFERS` | No | `256MB` | Shared buffer size |
| `CORE_REDIS_IMAGE` | No | `redis:7-alpine` | Redis image |
| `CORE_REDIS_PORT` | Yes | `6379` | Redis port |
| `CORE_MOSQUITTO_IMAGE` | No | `eclipse-mosquitto:2` | MQTT broker image |
| `CORE_MQTT_PORT` | Yes | `1883` | MQTT port |
| `CORE_MQTT_WS_PORT` | Yes | `9001` | MQTT WebSocket port |
| `CORE_REDIS_COMMANDER_IMAGE` | No | `rediscommander/redis-commander:latest` | Redis UI image |
| `CORE_REDIS_API_USER` | Yes | `admin` | Redis UI username |
| `CORE_REDIS_API_PASSWORD` | Yes | - | Redis UI password (secrets.env) |
| `CORE_REDIS_API_PORT` | Yes | `8081` | Redis UI port |

---

## Auth Stack

Authentication and SSO services.

### Keycloak Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AUTH_COMPOSE_PROJECT_NAME` | Yes | `auth` | Docker compose project name |
| `AUTH_DOCKER_IMAGE` | Yes | `quay.io/keycloak/keycloak:latest` | Keycloak image |
| `AUTH_DB_NAME` | Yes | `keycloak` | Database name |
| `AUTH_KEYCLOAK_ADMIN_USERNAME` | Yes | `admin` | Admin username |
| `AUTH_KEYCLOAK_ADMIN_PASSWORD` | Yes | - | Admin password (secrets.env) |
| `AUTH_KC_HTTP_PORT` | Yes | `8180` | HTTP port |

### OAuth2 Proxy Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AUTH_OAUTH2_PROXY_HOST` | Yes | - | OAuth2 Proxy host |
| `AUTH_OAUTH2_CLIENT_ID` | Yes | `kompose-sso` | Client ID |
| `AUTH_OAUTH2_CLIENT_SECRET` | Yes | - | Client secret (secrets.env) |
| `AUTH_OAUTH2_COOKIE_SECRET` | Yes | - | Cookie secret (secrets.env) |

---

## Proxy Stack

Traefik reverse proxy and SSL termination.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PROXY_COMPOSE_PROJECT_NAME` | Yes | `proxy` | Docker compose project name |
| `PROXY_TRAEFIK_IMAGE` | Yes | `traefik:latest` | Traefik image |
| `PROXY_TRAEFIK_PORT_HTTP` | Yes | `80` | HTTP port |
| `PROXY_TRAEFIK_PORT_HTTPS` | Yes | `443` | HTTPS port |
| `PROXY_TRAEFIK_PORT_DASHBOARD` | Yes | `8080` | Dashboard port |
| `PROXY_TRAEFIK_LOG_LEVEL` | No | `DEBUG` | Log level |
| `PROXY_TRAEFIK_ACME_EMAIL` | Yes | - | Let's Encrypt email |
| `TRAEFIK_DASHBOARD_AUTH` | Yes | - | Dashboard basic auth (secrets.env) |

---

## Messaging Stack

Notification and email services.

### Gotify Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MESSAGING_COMPOSE_PROJECT_NAME` | Yes | `messaging` | Docker compose project name |
| `MESSAGING_GOTIFY_IMAGE` | Yes | `gotify/server:latest` | Gotify image |
| `MESSAGING_GOTIFY_PORT` | Yes | `8085` | Gotify port |
| `MESSAGING_GOTIFY_TRAEFIK_HOST` | Yes | - | Traefik host |
| `MESSAGING_GOTIFY_DEFAULTUSER_NAME` | Yes | - | Default username (secrets.env) |
| `MESSAGING_GOTIFY_DEFAULTUSER_PASS` | Yes | - | Default password (secrets.env) |

### Mailhog Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MESSAGING_MAILHOG_IMAGE` | Yes | `mailhog/mailhog:latest` | Mailhog image |
| `MESSAGING_MAILHOG_PORT` | Yes | `8025` | Mailhog UI port |
| `MAILHOG_OUTGOING_SMTP_ENABLED` | No | `false` | Enable outgoing SMTP |

---

## Chain Stack

Workflow automation and task orchestration.

### n8n Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CHAIN_COMPOSE_PROJECT_NAME` | Yes | `chain` | Docker compose project name |
| `CHAIN_N8N_IMAGE` | No | `n8nio/n8n:latest` | n8n image |
| `CHAIN_N8N_PORT` | Yes | `5678` | n8n port |
| `CHAIN_N8N_DB_NAME` | Yes | `n8n` | Database name |
| `CHAIN_N8N_BASIC_AUTH_USER` | Yes | `admin` | Basic auth user |
| `CHAIN_N8N_BASIC_AUTH_PASSWORD` | Yes | - | Basic auth password (secrets.env) |
| `CHAIN_N8N_WEBHOOK_URL` | Yes | - | Webhook URL |
| `N8N_ENCRYPTION_KEY` | Yes | - | Encryption key (secrets.env) |

### Semaphore Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CHAIN_SEMAPHORE_IMAGE` | No | `semaphoreui/semaphore:latest` | Semaphore image |
| `CHAIN_SEMAPHORE_PORT` | Yes | `3000` | Semaphore port |
| `CHAIN_SEMAPHORE_DB_NAME` | Yes | `semaphore` | Database name |
| `CHAIN_SEMAPHORE_ADMIN_USERNAME` | Yes | `admin` | Admin username |
| `CHAIN_SEMAPHORE_ADMIN_PASSWORD` | Yes | - | Admin password (secrets.env) |
| `CHAIN_SEMAPHORE_ADMIN_NAME` | Yes | `Admin` | Admin display name |
| `SEMAPHORE_RUNNER_TOKEN` | Yes | - | Runner token (secrets.env) |

---

## Code Stack

Git hosting and CI/CD.

### Gitea Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CODE_COMPOSE_PROJECT_NAME` | Yes | `code` | Docker compose project name |
| `CODE_GITEA_IMAGE` | No | `gitea/gitea:latest` | Gitea image |
| `CODE_GITEA_PORT_HTTP` | Yes | `3001` | HTTP port |
| `CODE_GITEA_PORT_SSH` | Yes | `2222` | SSH port |
| `CODE_GITEA_DB_NAME` | Yes | `gitea` | Database name |
| `CODE_GITEA_APP_NAME` | Yes | - | Application name |
| `CODE_GITEA_RUN_MODE` | Yes | `dev` | Run mode (dev/prod) |
| `GITEA_SECRET_KEY` | Yes | - | Secret key (secrets.env) |
| `GITEA_INTERNAL_TOKEN` | Yes | - | Internal token (secrets.env) |
| `GITEA_OAUTH2_JWT_SECRET` | Yes | - | OAuth2 JWT secret (secrets.env) |
| `GITEA_METRICS_TOKEN` | Yes | - | Metrics token (secrets.env) |
| `GITEA_DISABLE_REGISTRATION` | No | `false` | Disable registration |
| `GITEA_REQUIRE_SIGNIN` | No | `false` | Require sign-in |
| `GITEA_EMAIL_CONFIRM` | No | `false` | Email confirmation |
| `GITEA_LOG_LEVEL` | No | `Info` | Log level |
| `GITEA_TRAEFIK_HOST` | Yes | - | Traefik host |

### Gitea Actions Runner

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CODE_RUNNER_IMAGE` | No | `gitea/act_runner:latest` | Runner image |
| `CODE_RUNNER_TOKEN` | Yes | - | Runner token (secrets.env) |
| `GITEA_RUNNER_NAME` | Yes | `kompose-runner-1` | Runner name |
| `GITEA_RUNNER_LABELS` | Yes | - | Runner labels |

---

## KMPS Stack

Kompose Management Portal and SSO administration.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `KMPS_COMPOSE_PROJECT_NAME` | Yes | `kmps` | Docker compose project name |
| `KMPS_DB_NAME` | Yes | `kmps` | Database name |
| `KMPS_TRAEFIK_HOST` | Yes | - | Traefik host |
| `KMPS_APP_PORT` | Yes | `3100` | Application port |
| `KMPS_API_PORT` | Yes | `8080` | API port |
| `KMPS_API_HOST` | Yes | `0.0.0.0` | API host |
| `KMPS_CLIENT_ID` | Yes | `kmps-admin` | Keycloak client ID |
| `KMPS_CLIENT_SECRET` | Yes | - | Client secret (secrets.env) |
| `KMPS_REALM` | Yes | `kompose` | Keycloak realm |
| `KMPS_NEXTAUTH_SECRET` | Yes | - | NextAuth secret (secrets.env) |
| `KOMPOSE_ROOT` | Yes | - | Kompose root directory |

---

## Home Stack

Smart home automation.

### Home Assistant

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_COMPOSE_PROJECT_NAME` | Yes | `home` | Docker compose project name |
| `HOME_HOMEASSISTANT_IMAGE` | No | `ghcr.io/home-assistant/home-assistant:stable` | HA image |
| `HOME_HOMEASSISTANT_PORT` | Yes | `8123` | HA port |

### Matter Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_MATTER_SERVER_IMAGE` | No | `ghcr.io/home-assistant-libs/python-matter-server:stable` | Matter image |

### Zigbee2MQTT

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_ZIGBEE2MQTT_IMAGE` | No | `koenkk/zigbee2mqtt:latest` | Zigbee2MQTT image |
| `HOME_ZIGBEE2MQTT_PORT` | Yes | `8080` | Zigbee2MQTT port |

### ESPHome

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_ESPHOME_IMAGE` | No | `ghcr.io/esphome/esphome:stable` | ESPHome image |

---

## VPN Stack

WireGuard VPN server.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `VPN_COMPOSE_PROJECT_NAME` | Yes | `vpn` | Docker compose project name |
| `VPN_DOCKER_IMAGE` | Yes | `weejewel/wg-easy:latest` | WireGuard image |
| `VPN_WG_HOST` | Yes | - | WireGuard host |
| `VPN_WG_PORT` | Yes | `51820` | WireGuard port |
| `VPN_WG_PERSISTENT_KEEPALIVE` | Yes | `25` | Keepalive interval |
| `VPN_WG_DEFAULT_DNS` | Yes | `1.1.1.1,1.0.0.1` | Default DNS |
| `VPN_WG_DEFAULT_ADDRESS` | Yes | `10.8.0.x` | Default address |
| `VPN_WG_ALLOWED_IPS` | Yes | `10.8.0.0/24` | Allowed IPs |
| `VPN_WG_MTU` | Yes | `1420` | MTU size |

---

## Utility Stacks

### Vault (Vaultwarden)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `VAULT_COMPOSE_PROJECT_NAME` | Yes | `vault` | Project name |
| `VAULT_TRAEFIK_HOST` | Yes | - | Traefik host |
| `VAULT_DB_NAME` | Yes | `vaultwarden` | Database name |
| `VAULT_SIGNUPS_ALLOWED` | No | `true` | Allow signups |
| `VAULT_INVITATIONS_ALLOWED` | No | `true` | Allow invitations |
| `VAULT_SHOW_PASSWORD_HINT` | No | `true` | Show password hint |
| `JWT_TOKEN` | Yes | - | Admin token (secrets.env) |
| `WEBSOCKET_ENABLED` | Yes | - | Enable WebSocket |
| `DOMAIN` | Yes | - | Domain URL |
| `MQTT_ENABLED` | No | `true` | Enable MQTT |
| `APP_PORT` | Yes | - | Application port |

### Track (Umami)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `TRACK_COMPOSE_PROJECT_NAME` | Yes | `track` | Project name |
| `TRACK_TRAEFIK_HOST` | Yes | - | Traefik host |
| `TRACK_DB_NAME` | Yes | `umami` | Database name |
| `APP_SECRET` | Yes | - | App secret (secrets.env) |
| `MQTT_ENABLED` | No | `true` | Enable MQTT |

### Link (Linkwarden)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `LINK_COMPOSE_PROJECT_NAME` | Yes | `link` | Project name |
| `LINK_TRAEFIK_HOST` | Yes | - | Traefik host |
| `LINK_DB_NAME` | Yes | `linkwarden` | Database name |

### News (Letterspace)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NEWS_COMPOSE_PROJECT_NAME` | Yes | `news` | Project name |
| `NEWS_TRAEFIK_HOST` | Yes | - | Traefik host |
| `NEWS_DB_NAME` | Yes | `letterspace` | Database name |

### Blog

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `BLOG_COMPOSE_PROJECT_NAME` | Yes | `blog` | Project name |
| `BLOG_TRAEFIK_HOST` | Yes | - | Traefik host |

### Sexy (Directus)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SEXY_COMPOSE_PROJECT_NAME` | Yes | `sexy` | Project name |
| `SEXY_TRAEFIK_HOST` | Yes | - | Traefik host |
| `SEXY_DB_NAME` | Yes | `directus` | Database name |
| `SEXY_ADMIN_EMAIL` | Yes | - | Admin email |
| `DIRECTUS_SECRET` | Yes | - | Secret (secrets.env) |
| `DIRECTUS_BUNDLE` | Yes | - | Extensions bundle path |
| `CACHE_ENABLED` | Yes | - | Enable cache |
| `CACHE_AUTO_PURGE` | Yes | - | Auto purge cache |
| `WEBSOCKETS_ENABLED` | Yes | - | Enable WebSocket |
| `PUBLIC_URL` | Yes | - | Public URL |
| `CORS_ENABLED` | Yes | - | Enable CORS |
| `CORS_ORIGIN` | Yes | - | CORS origin |
| `FRONTEND_IMAGE` | Yes | - | Frontend image |
| `FRONTEND_PORT` | Yes | - | Frontend port |

---

## Security Notes

### Secrets Management

Variables marked with "secrets.env" should **NEVER** be committed to version control. Store them in:
- `secrets.env` (gitignored)
- Environment-specific secret management system
- CI/CD secret variables

### Common Secrets Required

```bash
# Database
DB_PASSWORD=
REDIS_PASSWORD=

# Auth
AUTH_KEYCLOAK_ADMIN_PASSWORD=
AUTH_OAUTH2_CLIENT_SECRET=
AUTH_OAUTH2_COOKIE_SECRET=

# Gitea
GITEA_SECRET_KEY=
GITEA_INTERNAL_TOKEN=
GITEA_OAUTH2_JWT_SECRET=
GITEA_METRICS_TOKEN=
CODE_RUNNER_TOKEN=

# n8n
N8N_ENCRYPTION_KEY=
CHAIN_N8N_BASIC_AUTH_PASSWORD=

# Semaphore
CHAIN_SEMAPHORE_ADMIN_PASSWORD=
SEMAPHORE_RUNNER_TOKEN=

# KMPS
KMPS_CLIENT_SECRET=
KMPS_NEXTAUTH_SECRET=

# Gotify
MESSAGING_GOTIFY_DEFAULTUSER_PASS=

# Redis UI
CORE_REDIS_API_PASSWORD=

# Traefik
TRAEFIK_DASHBOARD_AUTH=

# Vault
JWT_TOKEN=

# Umami
APP_SECRET=

# Directus
DIRECTUS_SECRET=
ADMIN_PASSWORD=
```

---

## Variable Naming Convention

Format: `{STACK}_{SERVICE}_{PROPERTY}`

Examples:
- `CORE_POSTGRES_IMAGE` - Core stack, PostgreSQL service, image property
- `AUTH_KEYCLOAK_ADMIN_PASSWORD` - Auth stack, Keycloak, admin password
- `CHAIN_N8N_PORT` - Chain stack, n8n service, port property

---

## Validation

Use this checklist to validate your environment:

```bash
# Check if all required variables are set
./kompose.sh validate

# Test individual stack configuration
docker-compose -f core/compose.yaml config

# Verify secrets are not in git
git ls-files | grep -E '(secrets|\.env\.production)$'
```

---

**Last Updated**: 2025-10-13  
**Maintainer**: Kompose Team
