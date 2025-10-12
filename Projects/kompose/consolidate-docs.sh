#!/bin/bash
#
# Kompose Documentation Consolidation and Cleanup Script
# 
# This script:
# 1. Creates missing documentation pages in _docs/content
# 2. Moves root markdown files to _archive
# 3. Updates the documentation index
#
# Usage: ./consolidate-docs.sh
#

set -e

PROJECT_ROOT="/home/valknar/Projects/kompose"
DOCS_ROOT="${PROJECT_ROOT}/_docs/content"
ARCHIVE_ROOT="${PROJECT_ROOT}/_archive"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Kompose Documentation Consolidation Script          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create archive directory
ARCHIVE_DIR="${ARCHIVE_ROOT}/docs_consolidated_$(date +%Y%m%d_%H%M%S)"
mkdir -p "${ARCHIVE_DIR}"
echo -e "${YELLOW}→ Created archive directory: ${ARCHIVE_DIR}${NC}"

# ============================================================================
# Phase 1: Create Missing Quick Reference Pages
# ============================================================================
echo -e "\n${GREEN}Phase 1: Creating Quick Reference Pages${NC}"

# Create API Quick Reference
cat > "${DOCS_ROOT}/4.reference/api-quick-reference.md" << 'EOF'
# API Quick Reference

Quick reference for the Kompose REST API.

## Server Management

```bash
# Start API server
./kompose.sh api start [PORT] [HOST]

# Stop API server
./kompose.sh api stop

# Check API status
./kompose.sh api status

# View API logs
./kompose.sh api logs
```

## Endpoint Reference

### Stacks
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/stacks` | List all stacks |
| GET | `/api/stacks/{name}` | Get stack status |
| POST | `/api/stacks/{name}/start` | Start stack |
| POST | `/api/stacks/{name}/stop` | Stop stack |
| POST | `/api/stacks/{name}/restart` | Restart stack |
| GET | `/api/stacks/{name}/logs` | Get stack logs |

### Database
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/db/status` | Database status |
| GET | `/api/db/list` | List backups |

### Deployment
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tag/list` | List deployment tags |

### System
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |

## Quick Examples

### cURL
```bash
# List stacks
curl http://localhost:8080/api/stacks | jq .

# Start a stack
curl -X POST http://localhost:8080/api/stacks/core/start

# Get logs
curl http://localhost:8080/api/stacks/core/logs | jq -r .data.logs
```

### JavaScript
```javascript
const API = 'http://localhost:8080/api';

// List stacks
const stacks = await fetch(`${API}/stacks`).then(r => r.json());

// Start a stack
await fetch(`${API}/stacks/core/start`, { method: 'POST' });
```

### Python
```python
import requests

API = 'http://localhost:8080/api'

# List stacks
stacks = requests.get(f'{API}/stacks').json()

# Start a stack
requests.post(f'{API}/stacks/core/start')
```

## Response Format

All responses follow this structure:

```json
{
  "status": "success|error",
  "message": "Human-readable message",
  "data": { },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## Configuration

```bash
# Set custom port and host
export API_PORT=9000
export API_HOST=0.0.0.0
./kompose.sh api start
```

## See Also

- [Complete API Guide](/guide/api-server)
- [CLI Reference](/reference/cli)
EOF

echo -e "${GREEN}✓ Created api-quick-reference.md${NC}"

# Create Core Quick Reference
cat > "${DOCS_ROOT}/4.reference/core-quick-reference.md" << 'EOF'
# Core Stack Quick Reference

Quick reference for the core infrastructure stack.

## Services

| Service | Container | Port | Purpose |
|---------|-----------|------|---------|
| PostgreSQL | core-postgres | 5432 | Database |
| Redis | core-redis | 6379 | Cache & Sessions |
| MQTT | core-mqtt | 1883, 9001 | Message Broker |
| Redis UI | core-redis-api | 8081 | Redis Management |

## Quick Commands

```bash
# Start core stack
./kompose.sh up core

# Stop core stack
./kompose.sh down core

# Restart core stack
./kompose.sh restart core

# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core -f
```

## PostgreSQL

### Access Database
```bash
# Interactive shell
./kompose.sh db shell

# Execute query
./kompose.sh db exec -d kompose "SELECT * FROM users LIMIT 5;"

# Backup database
./kompose.sh db backup

# Restore database
./kompose.sh db restore -f backup.sql
```

### Available Databases
- `kompose` - Main application database
- `n8n` - Workflow automation
- `semaphore` - Ansible automation
- `gitea` - Git repository

## Redis

### Access Redis
```bash
# Redis CLI
docker exec -it core-redis redis-cli -a <password>

# Get keys
redis-cli -a <password> KEYS "*"

# Monitor commands
redis-cli -a <password> MONITOR
```

### Redis UI
Access: `http://localhost:8081`
- View all keys
- Inspect values
- Monitor performance

## MQTT

### Subscribe to Messages
```bash
# All messages
mosquitto_sub -h localhost -t "#" -v

# Service events
mosquitto_sub -h localhost -t "kompose/#" -v
```

### Publish Message
```bash
mosquitto_pub -h localhost -t "test" -m "hello"
```

### Monitor Broker
```bash
# System stats
mosquitto_sub -h localhost -t '$SYS/#' -C 10

# Connected clients
mosquitto_sub -h localhost -t '$SYS/broker/clients/total' -C 1
```

## Health Checks

```bash
# PostgreSQL
docker exec core-postgres pg_isready -U kompose

# Redis
docker exec core-redis redis-cli -a <password> PING

# MQTT
mosquitto_pub -h localhost -t test -m hello
```

## Environment Variables

Located in `core/.env`:

```bash
# PostgreSQL
POSTGRES_USER=kompose
POSTGRES_PASSWORD=<secret>
POSTGRES_DB=kompose

# Redis
REDIS_PASSWORD=<secret>

# MQTT
MQTT_USERNAME=kompose
MQTT_PASSWORD=<secret>
```

## Volumes

```bash
core_postgres_data    # PostgreSQL data
core_redis_data       # Redis data
core_mqtt_data        # MQTT data
core_mqtt_logs        # MQTT logs
```

## Troubleshooting

### PostgreSQL won't start
```bash
docker logs core-postgres
docker exec core-postgres pg_isready -U kompose
```

### Redis connection refused
```bash
docker logs core-redis
docker exec core-redis redis-cli -a <password> PING
```

### MQTT not accessible
```bash
docker logs core-mqtt
docker ps | grep core-mqtt
```

## See Also

- [Core Stack Guide](/stacks/core)
- [Database Management](/guide/database)
EOF

echo -e "${GREEN}✓ Created core-quick-reference.md${NC}"

# Create SSO Quick Reference
cat > "${DOCS_ROOT}/4.reference/sso-quick-reference.md" << 'EOF'
# SSO Quick Reference

Quick reference for Single Sign-On integration.

## Middleware Options

```yaml
# Basic SSO
middlewares=sso-secure

# SSO + Rate Limiting
middlewares=sso-secure-limited

# SSO + IP Restriction
middlewares=sso-internal-only
```

## Protect a Service

Edit service `compose.yaml`:

```yaml
labels:
  - 'traefik.http.routers.${COMPOSE_PROJECT_NAME}-web-secure.middlewares=sso-secure'
```

Restart:
```bash
./kompose.sh restart [stack]
```

## Keycloak Access

**URL:** `https://auth.yourdomain.com`
**Admin User:** `admin`
**Password:** Check `secrets.env` → `KC_ADMIN_PASSWORD`

## Create User

1. **Keycloak Admin → Users → Create user**
2. Fill in details
3. Save
4. **Credentials tab** → Set password

## Create Client

1. **Clients → Create Client**
2. Client ID: `service-name`
3. Client authentication: **ON**
4. Valid redirect URIs: `https://service.yourdomain.com/*`
5. Save
6. Copy **Client Secret**

## User Headers

Access user info in your application:

```javascript
req.headers['x-auth-request-user']      // Username
req.headers['x-auth-request-email']     // Email
req.headers['x-auth-request-groups']    // Groups (comma-separated)
```

## Skip Auth for Specific Paths

Edit `auth/compose.yaml`:

```yaml
environment:
  OAUTH2_PROXY_SKIP_AUTH_ROUTES: "^/api/webhook,^/health"
```

## Troubleshooting

```bash
# Check auth stack
./kompose.sh status auth

# View Keycloak logs
docker logs auth_keycloak

# View OAuth2 Proxy logs
docker logs auth_oauth2-proxy

# Test OAuth2 endpoints
curl https://sso.yourdomain.com/ping
```

## See Also

- [SSO Integration Guide](/guide/sso-integration)
- [KMPS Portal](/stacks/kmps)
EOF

echo -e "${GREEN}✓ Created sso-quick-reference.md${NC}"

# Create VPN Quick Reference
cat > "${DOCS_ROOT}/4.reference/vpn-quick-reference.md" << 'EOF'
# VPN Quick Reference

Quick reference for the WireGuard VPN stack.

## Quick Commands

```bash
# Start VPN
./kompose.sh up vpn

# Stop VPN
./kompose.sh down vpn

# Restart VPN
./kompose.sh restart vpn

# View logs
./kompose.sh logs vpn -f

# Check status
./kompose.sh status vpn
```

## Access WG-Easy UI

**URL:** `https://vpn.yourdomain.com`
**Password:** Check `secrets.env` → `VPN_PASSWORD`

## Add New Client

1. Access WG-Easy UI
2. Click **New Client**
3. Enter client name
4. Download config or scan QR code

## Client Configuration

### Mobile (iOS/Android)
1. Install WireGuard app
2. Scan QR code from WG-Easy UI
3. Enable VPN

### Desktop (Linux/macOS/Windows)
1. Install WireGuard
2. Download config from WG-Easy UI
3. Import config
4. Connect

## Environment Variables

Located in `vpn/.env`:

```bash
WG_HOST=vpn.yourdomain.com     # Public VPN endpoint
VPN_PASSWORD=<secret>           # UI password
VPN_PORT=51820                  # WireGuard port
```

## Firewall Configuration

```bash
# Allow WireGuard port
sudo ufw allow 51820/udp

# Verify
sudo ufw status
```

## Troubleshooting

### Can't connect to VPN
```bash
# Check VPN is running
./kompose.sh status vpn

# Check firewall
sudo ufw status | grep 51820

# Check logs
docker logs vpn_wg-easy
```

### Slow VPN speed
- Check server bandwidth
- Try different VPN server location
- Reduce MTU in client config

### DNS not working
Add to client config:
```
DNS = 1.1.1.1, 1.0.0.1
```

## See Also

- [VPN Integration Guide](/guide/vpn-integration)
- [VPN Stack Details](/stacks/vpn)
EOF

echo -e "${GREEN}✓ Created vpn-quick-reference.md${NC}"

# ============================================================================
# Phase 2: Create Stack Documentation
# ============================================================================
echo -e "\n${GREEN}Phase 2: Creating Stack Documentation${NC}"

# Create Core Stack Documentation
cat > "${DOCS_ROOT}/5.stacks/core.md" << 'EOF'
# Core Stack

The core infrastructure stack provides essential services for the entire Kompose system.

## Services

### PostgreSQL
- **Image:** `postgres:16-alpine`
- **Port:** 5432 (internal)
- **Purpose:** Relational database for all services
- **Databases:** kompose, n8n, semaphore, gitea

### Redis
- **Image:** `redis:7-alpine`
- **Port:** 6379 (internal)
- **Purpose:** Caching and session storage
- **Persistence:** AOF enabled

### Mosquitto MQTT
- **Image:** `eclipse-mosquitto:latest`
- **Ports:** 1883 (MQTT), 9001 (WebSocket)
- **Purpose:** Event message broker
- **Features:** Real-time event publishing

### Redis Commander
- **Image:** `ghcr.io/joeferner/redis-commander:latest`
- **Port:** 8081 (HTTP)
- **Purpose:** Redis web UI
- **Access:** `http://localhost:8081`

## Quick Start

```bash
# Start core stack
./kompose.sh up core

# Check status
./kompose.sh status core

# View logs
./kompose.sh logs core
```

## Configuration

Located in `core/.env`:

```bash
POSTGRES_USER=kompose
POSTGRES_PASSWORD=<generate-with-secrets>
POSTGRES_DB=kompose

REDIS_PASSWORD=<generate-with-secrets>

MQTT_USERNAME=kompose
MQTT_PASSWORD=<generate-with-secrets>
```

## Database Management

See [Database Guide](/guide/database) for complete database management commands.

```bash
# Backup
./kompose.sh db backup

# Restore
./kompose.sh db restore -f backup.sql

# Shell access
./kompose.sh db shell
```

## See Also

- [Core Quick Reference](/reference/core-quick-reference)
- [Database Guide](/guide/database)
- [MQTT Events](/guide/mqtt-events)
EOF

echo -e "${GREEN}✓ Created core.md${NC}"

# Create KMPS Stack Documentation
cat > "${DOCS_ROOT}/5.stacks/kmps.md" << 'EOF'
# KMPS Stack

Kompose Management Portal - Web-based management interface for SSO and user administration.

## Overview

KMPS provides:
- User management (CRUD operations)
- Password reset functionality
- Role and group management (via Keycloak API)
- Modern web interface
- Dashboard with statistics

## Services

### KMPS Application
- **Framework:** Next.js 14
- **Port:** 3000 (internal)
- **Access:** `https://manage.yourdomain.com`
- **Authentication:** NextAuth with Keycloak

## Quick Start

```bash
# Start KMPS
./kompose.sh up kmps

# Check status
./kompose.sh status kmps

# View logs
./kompose.sh logs kmps
```

## First-Time Setup

### 1. Configure Environment

Located in `kmps/.env`:

```bash
KMPS_CLIENT_SECRET=<from-keycloak>
KMPS_NEXTAUTH_SECRET=<generate-with-openssl>
```

### 2. Create Keycloak Client

1. Access Keycloak: `https://auth.yourdomain.com`
2. Navigate: **Clients → Create Client**
3. Client ID: `kmps-admin`
4. Client authentication: **ON**
5. Service accounts roles: **ON**
6. Valid redirect URIs: `https://manage.yourdomain.com/*`
7. Save and copy secret to `.env`

### 3. Assign Admin Roles

1. Navigate: **Clients → kmps-admin → Service accounts roles**
2. Assign roles:
   - `realm-admin`
   - `manage-users`
   - `manage-clients`
   - `view-users`
   - `view-clients`

### 4. Access KMPS

Visit: `https://manage.yourdomain.com`

You'll be redirected to Keycloak for authentication.

## Features

### Dashboard
- User count and statistics
- Recent user activity
- Quick action cards
- System health overview

### User Management
- List all users with search/filter
- Create new users
- Edit user details (email, name, etc.)
- Reset user passwords
- Enable/disable accounts
- Verify emails
- Delete users (with confirmation)

### API Endpoints

All management via API routes:

- `GET /api/users` - List users
- `POST /api/users` - Create user
- `GET /api/users/[id]` - Get user details
- `PUT /api/users/[id]` - Update user
- `DELETE /api/users/[id]` - Delete user
- `POST /api/users/[id]/reset-password` - Reset password

## Development

```bash
cd kmps/app

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

## Troubleshooting

### Can't login to KMPS
- Verify Keycloak is running: `./kompose.sh status auth`
- Check client configuration in Keycloak
- Verify secrets in `kmps/.env`

### Users API returns errors
- Verify KMPS client has admin roles
- Check client secret matches
- Review KMPS logs: `docker logs kmps_app`

### Page won't load
- Check if KMPS container is running
- Verify Traefik routing
- Check browser console for errors

## See Also

- [SSO Integration Guide](/guide/sso-integration)
- [SSO Quick Reference](/reference/sso-quick-reference)
- [Auth Stack](/stacks/auth)
EOF

echo -e "${GREEN}✓ Created kmps.md${NC}"

# ============================================================================
# Phase 3: Update Stack Documentation for Integrations
# ============================================================================
echo -e "\n${GREEN}Phase 3: Updating Stack Documentation${NC}"

# Note: These would need manual review and merging with existing content
# Creating backup notice files for manual update
for stack in link news track vault watch; do
    echo "# ${stack} Stack - Integration Features Added" > "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "This stack has been enhanced with:" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- SSO authentication via Keycloak" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- Redis caching for performance" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- MQTT event publishing" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- Prometheus metrics endpoints" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- Health check configurations" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "- Security headers and compression" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
    echo "Please manually merge this information into ${stack}.md" >> "${DOCS_ROOT}/5.stacks/${stack}.integration-notes.md"
done

echo -e "${GREEN}✓ Created integration notes for stacks${NC}"

# ============================================================================
# Phase 4: Move Root Markdown Files to Archive
# ============================================================================
echo -e "\n${GREEN}Phase 4: Archiving Root Markdown Files${NC}"

cd "${PROJECT_ROOT}"

# Files to archive
FILES_TO_ARCHIVE=(
    "API_COMPLETE_GUIDE.md"
    "API_IMPLEMENTATION_SUMMARY.md"
    "API_QUICK_REFERENCE.md"
    "API_QUICK_START.md"
    "API_README.md"
    "API_SERVER_IMPROVEMENTS.md"
    "CHAIN_QUICK_REF.md"
    "CHANGES.md"
    "CORE_QUICK_REF.md"
    "CORE_SETUP_COMPLETE.md"
    "DATABASE-MANAGEMENT.md"
    "DOMAIN_CONFIGURATION.md"
    "HOOKS_QUICKREF.md"
    "INDEX.md"
    "KMPS_DEPLOYMENT_COMPLETE.md"
    "QUICK_REFERENCE.md"
    "QUICK_START.md"
    "README_API_FIXES.md"
    "SSO_INTEGRATION_EXAMPLES.md"
    "SSO_QUICK_REF.md"
    "VPN_KOMPOSE_INTEGRATION.md"
    "VPN_QUICK_REF.md"
    "VPN_VISUAL_OVERVIEW.md"
)

for file in "${FILES_TO_ARCHIVE[@]}"; do
    if [ -f "${file}" ]; then
        mv "${file}" "${ARCHIVE_DIR}/"
        echo -e "${GREEN}✓ Archived ${file}${NC}"
    else
        echo -e "${YELLOW}⚠ Skipped ${file} (not found)${NC}"
    fi
done

# ============================================================================
# Phase 5: Create Summary
# ============================================================================
echo -e "\n${GREEN}Phase 5: Creating Summary${NC}"

cat > "${ARCHIVE_DIR}/CONSOLIDATION_SUMMARY.md" << EOF
# Documentation Consolidation Summary

**Date:** $(date)
**Archive Location:** ${ARCHIVE_DIR}

## Files Archived

$(for file in "${FILES_TO_ARCHIVE[@]}"; do
    echo "- ${file}"
done)

## New Documentation Created

### Guides (_docs/content/3.guide/)
- sso-integration.md - Complete SSO integration guide
- monitoring.md - Monitoring with Prometheus/Grafana
- mqtt-events.md - MQTT event system guide

### Quick References (_docs/content/4.reference/)
- api-quick-reference.md - API quick reference
- core-quick-reference.md - Core stack reference
- sso-quick-reference.md - SSO quick reference
- vpn-quick-reference.md - VPN quick reference

### Stack Documentation (_docs/content/5.stacks/)
- core.md - Core infrastructure stack
- kmps.md - Management portal stack
- *.integration-notes.md - Integration features (needs manual merge)

## Next Steps

1. Review and manually merge integration notes into existing stack docs
2. Build documentation site: \`cd _docs && npm run build\`
3. Verify all links work
4. Update main README.md to point to new docs location
5. Git commit changes

## Rollback

To restore archived files:
\`\`\`bash
cp ${ARCHIVE_DIR}/*.md ${PROJECT_ROOT}/
\`\`\`
EOF

echo -e "${GREEN}✓ Created consolidation summary${NC}"

# ============================================================================
# Done
# ============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Documentation Consolidation Complete!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo -e "  - Created 7 new documentation pages"
echo -e "  - Archived ${#FILES_TO_ARCHIVE[@]} markdown files"
echo -e "  - Archive location: ${ARCHIVE_DIR}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Review integration notes in _docs/content/5.stacks/"
echo -e "  2. Build docs: cd _docs && npm run build"
echo -e "  3. Update main README.md"
echo ""
echo -e "${GREEN}View summary: cat ${ARCHIVE_DIR}/CONSOLIDATION_SUMMARY.md${NC}"
echo ""
