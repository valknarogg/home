---
title: Environment Variables
description: Complete reference of all environment variables used across Kompose stacks
---

Complete reference documentation for all environment variables used throughout the Kompose platform.

## Variable Organization

Environment variables are organized in three files:

| File | Purpose | Commit to Git? |
|------|---------|---------------|
| `.env` | Main configuration (domains, ports, images) | ✅ Yes (template) |
| `domain.env` | Domain and subdomain mappings | ✅ Yes (template) |
| `secrets.env` | Passwords, tokens, API keys | ❌ **Never!** |

## Quick Reference

### Global Variables

Variables used across multiple stacks:

| Variable | Required | Default | Description | File |
|----------|----------|---------|-------------|------|
| `NETWORK_NAME` | Yes | `kompose` | Docker network name | .env |
| `TIMEZONE` | Yes | `Europe/Amsterdam` | System timezone | .env |
| `ADMIN_EMAIL` | Yes | - | Administrator email | .env |
| `DB_USER` | Yes | `kompose` | PostgreSQL username | .env |
| `DB_PASSWORD` | Yes | - | PostgreSQL password | secrets.env |
| `DB_HOST` | Yes | `core-postgres` | PostgreSQL host | .env |
| `DB_PORT` | Yes | `5432` | PostgreSQL port | .env |
| `REDIS_HOST` | Yes | `core-redis` | Redis host | .env |
| `REDIS_PASSWORD` | Yes | - | Redis password | secrets.env |

## Domain Configuration

Variables from `domain.env`:

### Root Domain

| Variable | Description | Example |
|----------|-------------|---------|
| `ROOT_DOMAIN` | Your base domain | `example.com` |
| `BASE_DOMAIN` | Alias for ROOT_DOMAIN | `${ROOT_DOMAIN}` |
| `ACME_EMAIL` | Let's Encrypt email | `admin@example.com` |

### Subdomains

Default subdomain prefixes:

| Variable | Default | Service | Generates |
|----------|---------|---------|-----------|
| `SUBDOMAIN_PROXY` | `traefik` | Traefik | `traefik.example.com` |
| `SUBDOMAIN_AUTH` | `auth` | Keycloak | `auth.example.com` |
| `SUBDOMAIN_CODE` | `code` | Gitea | `code.example.com` |
| `SUBDOMAIN_CHAIN` | `chain` | n8n | `chain.example.com` |
| `SUBDOMAIN_AUTO` | `auto` | Semaphore | `auto.example.com` |
| `SUBDOMAIN_NEWS` | `news` | Letterspace | `news.example.com` |
| `SUBDOMAIN_CHAT` | `chat` | Gotify | `chat.example.com` |
| `SUBDOMAIN_MAIL` | `mail` | Mailhog | `mail.example.com` |
| `SUBDOMAIN_TRACK` | `track` | Umami | `track.example.com` |
| `SUBDOMAIN_HOME` | `home` | Home Assistant | `home.example.com` |
| `SUBDOMAIN_VAULT` | `vault` | Vaultwarden | `vault.example.com` |
| `SUBDOMAIN_LINK` | `link` | Linkwarden | `link.example.com` |
| `SUBDOMAIN_MANAGE` | `manage` | KMPS | `manage.example.com` |
| `SUBDOMAIN_VPN` | `vpn` | WireGuard | `vpn.example.com` |
| `SUBDOMAIN_OAUTH2` | `oauth` | OAuth2 Proxy | `oauth.example.com` |
| `SUBDOMAIN_ZIGBEE` | `zigbee` | Zigbee2MQTT | `zigbee.example.com` |

### Auto-Generated Traefik Hosts

These are automatically computed from subdomain + root domain:

```bash
TRAEFIK_HOST=${SUBDOMAIN_AUTH}.${ROOT_DOMAIN}
N8N_TRAEFIK_HOST=${SUBDOMAIN_CHAIN}.${ROOT_DOMAIN}
SEMAPHORE_TRAEFIK_HOST=${SUBDOMAIN_AUTO}.${ROOT_DOMAIN}
TRAEFIK_HOST_HOME=${SUBDOMAIN_HOME}.${ROOT_DOMAIN}
TRAEFIK_HOST_ZIGBEE=${SUBDOMAIN_ZIGBEE}.${ROOT_DOMAIN}
OAUTH2_PROXY_HOST=${SUBDOMAIN_OAUTH2}.${ROOT_DOMAIN}
```

## Stack-Specific Variables

### Core Stack

Essential infrastructure services.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CORE_COMPOSE_PROJECT_NAME` | Yes | `core` | Docker compose project name |
| `CORE_POSTGRES_IMAGE` | No | `postgres:16-alpine` | PostgreSQL image |
| `CORE_DB_NAME` | Yes | `kompose` | Default database name |
| `CORE_DB_PORT` | Yes | `5432` | PostgreSQL port |
| `CORE_DB_HOST` | Yes | `core-postgres` | PostgreSQL container name |
| `CORE_POSTGRES_MAX_CONNECTIONS` | No | `100` | Max database connections |
| `CORE_POSTGRES_SHARED_BUFFERS` | No | `256MB` | PostgreSQL shared buffers |
| `CORE_REDIS_IMAGE` | No | `redis:7-alpine` | Redis image |
| `CORE_REDIS_PORT` | Yes | `6379` | Redis port |
| `CORE_MOSQUITTO_IMAGE` | No | `eclipse-mosquitto:2` | MQTT broker image |
| `CORE_MQTT_PORT` | Yes | `1883` | MQTT port |
| `CORE_MQTT_WS_PORT` | Yes | `9001` | MQTT WebSocket port |
| `CORE_REDIS_API_USER` | Yes | `admin` | Redis Commander username |
| `CORE_REDIS_API_PASSWORD` | Yes | - | Redis Commander password |
| `CORE_REDIS_API_PORT` | Yes | `8081` | Redis Commander port |

### Auth Stack

Authentication and SSO services.

#### Keycloak

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AUTH_COMPOSE_PROJECT_NAME` | Yes | `auth` | Docker compose project name |
| `AUTH_DOCKER_IMAGE` | Yes | `quay.io/keycloak/keycloak:latest` | Keycloak image |
| `AUTH_DB_NAME` | Yes | `keycloak` | Database name |
| `AUTH_KEYCLOAK_ADMIN_USERNAME` | Yes | `admin` | Admin username |
| `AUTH_KEYCLOAK_ADMIN_PASSWORD` | Yes | - | Admin password (secrets.env) |
| `AUTH_KC_HTTP_PORT` | Yes | `8180` | HTTP port |

#### OAuth2 Proxy

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AUTH_OAUTH2_PROXY_HOST` | Yes | - | OAuth2 Proxy hostname |
| `AUTH_OAUTH2_CLIENT_ID` | Yes | `kompose-sso` | Keycloak client ID |
| `AUTH_OAUTH2_CLIENT_SECRET` | Yes | - | Client secret (secrets.env) |
| `AUTH_OAUTH2_COOKIE_SECRET` | Yes | - | Cookie encryption (secrets.env) |

### Proxy Stack

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
| `TRAEFIK_DASHBOARD_AUTH` | Yes | - | Dashboard auth (secrets.env) |

### Messaging Stack

Notification and email services.

#### Gotify

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MESSAGING_COMPOSE_PROJECT_NAME` | Yes | `messaging` | Docker compose project name |
| `MESSAGING_GOTIFY_IMAGE` | Yes | `gotify/server:latest` | Gotify image |
| `MESSAGING_GOTIFY_PORT` | Yes | `8085` | Gotify port |
| `MESSAGING_GOTIFY_TRAEFIK_HOST` | Yes | - | Traefik routing host |
| `MESSAGING_GOTIFY_DEFAULTUSER_NAME` | Yes | - | Default username |
| `MESSAGING_GOTIFY_DEFAULTUSER_PASS` | Yes | - | Default password (secrets.env) |

#### Mailhog

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MESSAGING_MAILHOG_IMAGE` | Yes | `mailhog/mailhog:latest` | Mailhog image |
| `MESSAGING_MAILHOG_PORT` | Yes | `8025` | Web UI port |
| `MAILHOG_OUTGOING_SMTP_ENABLED` | No | `false` | Enable outgoing SMTP |

### Chain Stack

Workflow automation and orchestration.

#### n8n

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CHAIN_COMPOSE_PROJECT_NAME` | Yes | `chain` | Docker compose project name |
| `CHAIN_N8N_IMAGE` | No | `n8nio/n8n:latest` | n8n image |
| `CHAIN_N8N_PORT` | Yes | `5678` | n8n port |
| `CHAIN_N8N_DB_NAME` | Yes | `n8n` | Database name |
| `CHAIN_N8N_BASIC_AUTH_USER` | Yes | `admin` | Basic auth username |
| `CHAIN_N8N_BASIC_AUTH_PASSWORD` | Yes | - | Basic auth password (secrets.env) |
| `CHAIN_N8N_WEBHOOK_URL` | Yes | - | Webhook base URL |
| `N8N_ENCRYPTION_KEY` | Yes | - | Encryption key (secrets.env) |

#### Semaphore

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CHAIN_SEMAPHORE_IMAGE` | No | `semaphoreui/semaphore:latest` | Semaphore image |
| `CHAIN_SEMAPHORE_PORT` | Yes | `3000` | Semaphore port |
| `CHAIN_SEMAPHORE_DB_NAME` | Yes | `semaphore` | Database name |
| `CHAIN_SEMAPHORE_ADMIN_USERNAME` | Yes | `admin` | Admin username |
| `CHAIN_SEMAPHORE_ADMIN_PASSWORD` | Yes | - | Admin password (secrets.env) |
| `CHAIN_SEMAPHORE_ADMIN_NAME` | Yes | `Admin` | Admin display name |
| `SEMAPHORE_RUNNER_TOKEN` | Yes | - | Runner token (secrets.env) |

### Code Stack

Git hosting and CI/CD.

#### Gitea

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
| `GITEA_OAUTH2_JWT_SECRET` | Yes | - | OAuth2 JWT (secrets.env) |
| `GITEA_METRICS_TOKEN` | Yes | - | Metrics token (secrets.env) |
| `GITEA_DISABLE_REGISTRATION` | No | `false` | Disable registration |
| `GITEA_REQUIRE_SIGNIN` | No | `false` | Require sign-in |
| `GITEA_EMAIL_CONFIRM` | No | `false` | Email confirmation |
| `GITEA_LOG_LEVEL` | No | `Info` | Log level |
| `GITEA_TRAEFIK_HOST` | Yes | - | Traefik routing host |

#### Gitea Actions Runner

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CODE_RUNNER_IMAGE` | No | `gitea/act_runner:latest` | Runner image |
| `CODE_RUNNER_TOKEN` | Yes | - | Runner token (secrets.env) |
| `GITEA_RUNNER_NAME` | Yes | `kompose-runner-1` | Runner name |
| `GITEA_RUNNER_LABELS` | Yes | - | Runner labels |

### KMPS Stack

Management portal and SSO administration.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `KMPS_COMPOSE_PROJECT_NAME` | Yes | `kmps` | Docker compose project name |
| `KMPS_DB_NAME` | Yes | `kmps` | Database name |
| `KMPS_TRAEFIK_HOST` | Yes | - | Traefik routing host |
| `KMPS_APP_PORT` | Yes | `3100` | Application port |
| `KMPS_API_PORT` | Yes | `8080` | API server port |
| `KMPS_API_HOST` | Yes | `0.0.0.0` | API bind address |
| `KMPS_CLIENT_ID` | Yes | `kmps-admin` | Keycloak client ID |
| `KMPS_CLIENT_SECRET` | Yes | - | Client secret (secrets.env) |
| `KMPS_REALM` | Yes | `kompose` | Keycloak realm |
| `KMPS_NEXTAUTH_SECRET` | Yes | - | NextAuth secret (secrets.env) |
| `KOMPOSE_ROOT` | Yes | - | Kompose root directory |

### Home Stack

Smart home automation.

#### Home Assistant

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_COMPOSE_PROJECT_NAME` | Yes | `home` | Docker compose project name |
| `HOME_HOMEASSISTANT_IMAGE` | No | `ghcr.io/home-assistant/home-assistant:stable` | HA image |
| `HOME_HOMEASSISTANT_PORT` | Yes | `8123` | HA web port |

#### Matter Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_MATTER_SERVER_IMAGE` | No | `ghcr.io/home-assistant-libs/python-matter-server:stable` | Matter image |

#### Zigbee2MQTT

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_ZIGBEE2MQTT_IMAGE` | No | `koenkk/zigbee2mqtt:latest` | Zigbee2MQTT image |
| `HOME_ZIGBEE2MQTT_PORT` | Yes | `8080` | Web UI port |

#### ESPHome

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HOME_ESPHOME_IMAGE` | No | `ghcr.io/esphome/esphome:stable` | ESPHome image |

### VPN Stack

WireGuard VPN server.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `VPN_COMPOSE_PROJECT_NAME` | Yes | `vpn` | Docker compose project name |
| `VPN_DOCKER_IMAGE` | Yes | `weejewel/wg-easy:latest` | WireGuard image |
| `VPN_WG_HOST` | Yes | - | Public IP/hostname |
| `VPN_WG_PORT` | Yes | `51820` | WireGuard UDP port |
| `VPN_WG_PERSISTENT_KEEPALIVE` | Yes | `25` | Keepalive interval (seconds) |
| `VPN_WG_DEFAULT_DNS` | Yes | `1.1.1.1,1.0.0.1` | Default DNS servers |
| `VPN_WG_DEFAULT_ADDRESS` | Yes | `10.8.0.x` | Client address pattern |
| `VPN_WG_ALLOWED_IPS` | Yes | `10.8.0.0/24` | Allowed IP range |
| `VPN_WG_MTU` | Yes | `1420` | MTU size |

### Watch Stack

Monitoring and observability.

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `WATCH_COMPOSE_PROJECT_NAME` | Yes | `watch` | Docker compose project name |
| `WATCH_GRAFANA_ADMIN_PASSWORD` | Yes | - | Grafana admin (secrets.env) |
| `WATCH_GRAFANA_DB_PASSWORD` | Yes | - | Grafana DB (secrets.env) |
| `WATCH_POSTGRES_EXPORTER_PASSWORD` | Yes | - | Postgres exporter (secrets.env) |
| `WATCH_REDIS_EXPORTER_PASSWORD` | Yes | - | Redis exporter (secrets.env) |
| `WATCH_PROMETHEUS_AUTH` | Yes | - | Prometheus auth (secrets.env) |
| `WATCH_LOKI_AUTH` | Yes | - | Loki auth (secrets.env) |
| `WATCH_ALERTMANAGER_AUTH` | Yes | - | Alertmanager auth (secrets.env) |

### Utility Stacks

#### Vault (Vaultwarden)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `VAULT_COMPOSE_PROJECT_NAME` | Yes | `vault` | Project name |
| `VAULT_TRAEFIK_HOST` | Yes | - | Traefik routing host |
| `VAULT_DB_NAME` | Yes | `vaultwarden` | Database name |
| `VAULT_SIGNUPS_ALLOWED` | No | `true` | Allow new signups |
| `VAULT_INVITATIONS_ALLOWED` | No | `true` | Allow invitations |
| `VAULT_SHOW_PASSWORD_HINT` | No | `true` | Show password hints |
| `JWT_TOKEN` | Yes | - | Admin token (secrets.env) |
| `WEBSOCKET_ENABLED` | Yes | - | Enable WebSocket |
| `DOMAIN` | Yes | - | Full domain URL |
| `MQTT_ENABLED` | No | `true` | Enable MQTT notifications |
| `APP_PORT` | Yes | - | Application port |

#### Track (Umami)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `TRACK_COMPOSE_PROJECT_NAME` | Yes | `track` | Project name |
| `TRACK_TRAEFIK_HOST` | Yes | - | Traefik routing host |
| `TRACK_DB_NAME` | Yes | `umami` | Database name |
| `APP_SECRET` | Yes | - | App secret (secrets.env) |
| `MQTT_ENABLED` | No | `true` | Enable MQTT events |

#### Link (Linkwarden)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `LINK_COMPOSE_PROJECT_NAME` | Yes | `link` | Project name |
| `LINK_TRAEFIK_HOST` | Yes | - | Traefik routing host |
| `LINK_DB_NAME` | Yes | `linkwarden` | Database name |

## Variable Naming Convention

### Format

```
{STACK}_{SERVICE}_{PROPERTY}
```

### Examples

- `CORE_POSTGRES_IMAGE` - Core stack, PostgreSQL service, image property
- `AUTH_KEYCLOAK_ADMIN_PASSWORD` - Auth stack, Keycloak, admin password
- `CHAIN_N8N_PORT` - Chain stack, n8n service, port property

### Shared Variables

Variables without stack prefix are shared:
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`
- `REDIS_HOST`, `REDIS_PASSWORD`
- `NETWORK_NAME`, `TIMEZONE`
- `ADMIN_EMAIL`

## Secrets Summary

::alert{type="danger"}
**Never commit these to version control!**
::

### Required Secrets

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

# Watch
WATCH_GRAFANA_ADMIN_PASSWORD=
WATCH_GRAFANA_DB_PASSWORD=
WATCH_PROMETHEUS_AUTH=
WATCH_LOKI_AUTH=
WATCH_ALERTMANAGER_AUTH=
```

## Validation

### Check Configuration

```bash
# Validate all environment variables
./kompose.sh validate

# Check specific stack
docker compose -f core/compose.yaml config

# Verify secrets are not in git
git ls-files | grep -E '(secrets|\.env\.production)$'
# Should return nothing
```

### Test Configuration

```bash
# Display environment for stack
./kompose.sh env core

# Check variable resolution
cd core && docker compose config | grep DB_HOST

# Verify network
docker network inspect kompose
```

## Environment Modes

### Local Development

```bash
# Characteristics
- Services on localhost:PORT
- Direct database connections
- No domain configuration
- Fast setup

# Example
DB_HOST=localhost
KC_BASE_URL=http://localhost:8180
TRAEFIK_ENABLED=false
```

### Production

```bash
# Characteristics
- Domain-based routing
- SSL/TLS encryption
- Traefik reverse proxy
- OAuth2 SSO

# Example
DB_HOST=core-postgres
KC_BASE_URL=https://auth.example.com
TRAEFIK_ENABLED=true
```

## Next Steps

- [Secrets Management](../guide/secrets.md)
- [Environment Setup](../guide/environment-setup.md)
- [Stack Configuration](./stack-configuration.md)
- [CLI Reference](./cli.md)

---

**Version:** 2.0.0  
**Last Updated:** October 2025  
**Source:** ENV_REFERENCE.md (archived)
