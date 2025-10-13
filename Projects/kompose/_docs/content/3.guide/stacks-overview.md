# Stacks Overview

> *"Everything you need, perfectly organized"*

Kompose organizes services into **stacks** - logical groups of related Docker containers that work together. Each stack has a specific purpose and can be managed independently while integrating seamlessly with other stacks.

## Available Stacks

### :icon{name="lucide:database"} **Core** - Foundation Services
**Essential infrastructure that everything depends on**

- **PostgreSQL 16**: Relational database for all services
- **Redis 7**: Caching and session storage
- **Mosquitto MQTT**: Event message broker
- **Redis Commander**: Web UI for Redis management

**When to start**: Always first! Every other stack depends on core.

**Learn more**: [Core Stack Documentation](/stacks/core)

---

### :icon{name="lucide:lock-keyhole"} **Auth** - Authentication & SSO
**Centralized authentication for all services**

- **Keycloak**: Identity and access management
- **OAuth2 Proxy**: Forward authentication for Traefik

**Dependencies**: Core (PostgreSQL)

**Learn more**: [Auth Stack Documentation](/stacks/auth)

---

### :icon{name="lucide:users"} **KMPS** - Management Portal
**User and SSO administration interface**

- **Web UI**: User management dashboard
- **SSO Admin**: Configure single sign-on

**Dependencies**: Core, Auth

**Learn more**: [KMPS Stack Documentation](/stacks/kmps)

---

### :icon{name="lucide:home"} **Home** - Smart Home Automation
**Complete smart home platform**

- **Home Assistant**: Smart home hub
- **Matter Server**: Next-gen protocol support
- **Zigbee2MQTT**: Zigbee device support (optional)
- **ESPHome**: ESP device management (optional)

**Dependencies**: Core (MQTT)

**Learn more**: [Home Stack Documentation](/stacks/home)

---

### :icon{name="lucide:shield"} **VPN** - Remote Access
**Secure remote access to your infrastructure**

- **WireGuard (wg-easy)**: Modern VPN with web UI

**Dependencies**: None (standalone)

**Learn more**: [VPN Stack Documentation](/stacks/vpn)

---

### :icon{name="lucide:bell"} **Messaging** - Communications
**Notifications and email**

- **Gotify**: Push notification server
- **Mailhog**: Email testing (development)
- **SMTP**: Production email (configured via env)

**Dependencies**: None (standalone)

**Learn more**: [Messaging Stack Documentation](/stacks/messaging)

---

### :icon{name="lucide:link-2"} **Chain** - Workflow & Infrastructure Automation
**Automate everything**

- **n8n**: Visual workflow automation (400+ integrations)
- **Semaphore**: Ansible automation UI
- **Semaphore Runner**: Background task executor

**Dependencies**: Core (PostgreSQL), Messaging (optional)

**Learn more**: [Chain Stack Documentation](/stacks/chain)

---

### :icon{name="lucide:git-branch"} **Code** - Git Repository & CI/CD
**Self-hosted development platform**

- **Gitea**: Git repository management
- **Gitea Actions Runner**: CI/CD pipeline executor

**Dependencies**: Core (PostgreSQL, Redis), Messaging (email)

**Learn more**: [Code Stack Documentation](/stacks/code)

---

### :icon{name="lucide:traffic-cone"} **Proxy** - Reverse Proxy
**The traffic cop of your infrastructure**

- **Traefik**: Reverse proxy with automatic SSL
- **Let's Encrypt**: Free SSL certificates
- **Dashboard**: Visual service overview

**Dependencies**: None (but used by all other stacks for HTTPS)

**Learn more**: [Proxy Stack Documentation](/stacks/proxy)

---

### :icon{name="lucide:link"} **Link** - Bookmark Management
**Save and organize your links**

- **Linkwarden**: Modern bookmark manager
- **Tags & Collections**: Organize effectively
- **Screenshots**: Archive page snapshots

**Dependencies**: Core (PostgreSQL)

**Learn more**: [Link Stack Documentation](/stacks/link)

---

### :icon{name="lucide:newspaper"} **News** - RSS Feed Reader
**Stay updated with your favorite sources**

- **FreshRSS**: Self-hosted RSS aggregator
- **Feed Management**: Subscribe to any RSS/Atom feed
- **Mobile Apps**: Android/iOS compatible

**Dependencies**: Core (PostgreSQL)

**Learn more**: [News Stack Documentation](/stacks/news)

---

### :icon{name="lucide:activity"} **Track** - Analytics
**Privacy-focused website analytics**

- **Umami**: Simple, fast analytics
- **Privacy-First**: GDPR compliant
- **No Cookies**: Respects user privacy

**Dependencies**: Core (PostgreSQL)

**Learn more**: [Track Stack Documentation](/stacks/track)

---

### :icon{name="lucide:lock"} **Vault** - Password Manager
**Secure password management**

- **Vaultwarden**: Bitwarden-compatible server
- **Cross-Platform**: Works everywhere
- **Secure**: End-to-end encryption

**Dependencies**: Core (PostgreSQL)

**Learn more**: [Vault Stack Documentation](/stacks/vault)

---

### :icon{name="lucide:play"} **Watch** - Media Server
**Stream your media collection**

- **Jellyfin**: Free media system
- **Hardware Acceleration**: GPU support
- **Live TV**: DVR capabilities

**Dependencies**: None

**Learn more**: [Watch Stack Documentation](/stacks/watch)

---

### :icon{name="lucide:activity"} **Trace** - Monitoring
**Monitor your infrastructure**

- **Uptime Kuma**: Uptime monitoring
- **Grafana**: Metrics visualization  
- **Prometheus**: Metrics collection

**Dependencies**: Core (optional)

**Learn more**: [Trace Stack Documentation](/stacks/trace)

---

## Stack Dependency Graph

```
┌─────────────────────────────────────────────────────────────┐
│                     Dependency Flow                          │
└─────────────────────────────────────────────────────────────┘

                      ┌──────────┐
                      │  Proxy   │ (Traefik - HTTPS for all)
                      └────┬─────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
    ┌────▼─────┐      ┌───▼────┐       ┌────▼────┐
    │   Core   │      │  VPN   │       │Messaging│
    │  (Base)  │      └────────┘       └─────────┘
    └────┬─────┘
         │
         ├─────────┬─────────┬─────────┬─────────┬─────────┐
         │         │         │         │         │         │
    ┌────▼───┐┌───▼───┐┌───▼───┐┌───▼───┐┌───▼───┐┌───▼───┐
    │  Auth  ││ Home  ││ Code  ││ Chain ││ KMPS  ││ Link  │
    └────────┘└───────┘└───────┘└───────┘└───────┘└───────┘
         │
    ┌────▼───┐┌───────┐┌───────┐┌───────┐┌───────┐
    │  News  ││ Track ││ Vault ││ Watch ││ Trace │
    └────────┘└───────┘└───────┘└───────┘└───────┘
```

## Recommended Startup Order

### Minimal Setup (Development)
```bash
./kompose.sh up core    # Foundation
./kompose.sh up proxy   # HTTPS access
```

### Standard Setup (Most users)
```bash
./kompose.sh up core       # 1. Foundation
./kompose.sh up proxy      # 2. Reverse proxy
./kompose.sh up messaging  # 3. Notifications
./kompose.sh up home       # 4. Smart home
./kompose.sh up chain      # 5. Automation
./kompose.sh up code       # 6. Git & CI/CD
```

### Complete Setup (All services)
```bash
./kompose.sh up core       # 1. Foundation
./kompose.sh up proxy      # 2. Reverse proxy
./kompose.sh up auth       # 3. Authentication
./kompose.sh up kmps       # 4. Management portal
./kompose.sh up messaging  # 5. Notifications
./kompose.sh up vpn        # 6. Remote access
./kompose.sh up home       # 7. Smart home
./kompose.sh up chain      # 8. Automation
./kompose.sh up code       # 9. Git & CI/CD
```

### Or Start Everything
```bash
./kompose.sh up  # Starts all stacks
```

## Stack Integration Patterns

### Event-Driven Automation
```
Home Assistant → MQTT (Core) → n8n (Chain) → Gotify (Messaging)
```
**Example**: Motion detected → Trigger workflow → Send notification

### DevOps Pipeline
```
Git Push (Code) → Webhook → n8n (Chain) → Ansible (Chain) → Deploy
```
**Example**: Developer pushes code → Auto-deploy to production

### Authentication Flow
```
User Login → OAuth2 Proxy (Auth) → Keycloak (Auth) → Service Access
```
**Example**: Single sign-on for all services

### Data Flow
```
Service → PostgreSQL (Core) → Backup (Chain) → Notification (Messaging)
```
**Example**: Automated database backups with notifications

## Stack Management Commands

### Starting Stacks

```bash
# Start specific stack
./kompose.sh up core

# Start with detached mode
./kompose.sh up home -d

# Start all stacks
./kompose.sh up
```

### Stopping Stacks

```bash
# Stop specific stack
./kompose.sh down auth

# Stop with volume removal
./kompose.sh down code --force

# Stop all stacks
./kompose.sh down
```

### Stack Status

```bash
# Check specific stack
./kompose.sh status core

# Check all stacks
./kompose.sh status
```

### Stack Logs

```bash
# View logs
./kompose.sh logs chain

# Follow logs in real-time
./kompose.sh logs chain -f
```

### Other Operations

```bash
# Restart stack
./kompose.sh restart home

# Pull latest images
./kompose.sh pull proxy

# Deploy specific version
./kompose.sh deploy code 1.2.3

# Execute command in stack
./kompose.sh exec core psql -U kompose
```

## Choosing Which Stacks to Run

### For Home Automation
```
✓ Core     - Required foundation
✓ Proxy    - HTTPS access
✓ Home     - Smart home services
✓ Chain    - Automation workflows (optional)
✓ Messaging - Notifications (optional)
```

### For Development
```
✓ Core     - Database and caching
✓ Proxy    - Local HTTPS
✓ Code     - Git and CI/CD
✓ Chain    - Build automation (optional)
✓ Messaging - Email testing
```

### For Self-Hosting
```
✓ Core     - Foundation
✓ Proxy    - Web access
✓ Auth     - SSO (optional)
✓ VPN      - Remote access (optional)
✓ Messaging - Notifications
+ Your custom services
```

## Resource Requirements

### Minimal (Core + Proxy)
- **RAM**: 2GB
- **CPU**: 2 cores
- **Disk**: 10GB

### Standard (Core + Proxy + 3 stacks)
- **RAM**: 4GB
- **CPU**: 4 cores
- **Disk**: 20GB

### Complete (All stacks)
- **RAM**: 8GB
- **CPU**: 4+ cores
- **Disk**: 50GB+

## Network Architecture

All stacks use the `kompose` Docker network for inter-service communication:

```bash
# Create network (done automatically by kompose init)
docker network create kompose

# View network
docker network inspect kompose
```

**Advantages**:
- Services can find each other by container name
- Isolated from other Docker networks
- Traefik automatically discovers services
- No port conflicts on host

## Configuration Strategy

### Environment Variables
Each stack has its own `.env` file, plus:
- **Root `.env`**: Global configuration with stack-specific prefixes
- **`secrets.env`**: Sensitive data (passwords, API keys)
- **`domain.env`**: Domain configuration

### Customization
```bash
# View stack configuration
./kompose.sh env show core

# Validate configuration
./kompose.sh env validate auth

# Edit stack settings
vim core/.env
```

## Health Monitoring

### Check All Stacks
```bash
./kompose.sh status
```

### Individual Health Checks
```bash
# Core stack
docker exec core-postgres pg_isready
docker exec core-redis redis-cli PING

# Home stack
curl -f https://home.localhost/api/

# Proxy stack
curl -f http://localhost:8080/api/http/routers
```

## Backup Strategy

### What to Backup

**Critical (Must backup)**:
- PostgreSQL databases (Core)
- Home Assistant config (Home)
- Gitea repositories (Code)
- SSL certificates (Proxy)
- Configuration files

**Important (Should backup)**:
- n8n workflows (Chain)
- Semaphore projects (Chain)
- Redis data (Core)

**Optional (Can recreate)**:
- Container images
- Temporary files
- Logs

### Backup Commands
```bash
# Backup all databases
./kompose.sh db backup --compress

# Backup specific stack data
tar -czf backups/home-data.tar.gz home/homeassistant/

# Backup Gitea repositories
tar -czf backups/gitea-repos.tar.gz code/gitea/git/
```

## Troubleshooting

### Stack Won't Start
```bash
# Check dependencies
./kompose.sh status

# View logs
./kompose.sh logs [stack] -f

# Validate configuration
./kompose.sh validate [stack]
```

### Network Issues
```bash
# Recreate network
docker network rm kompose
docker network create kompose
./kompose.sh restart
```

### Database Issues
```bash
# Check database status
./kompose.sh db status

# Access database shell
./kompose.sh db shell -d [database]
```

## See Also

- :icon{name="lucide:book-open"} [Installation Guide](/installation)
- :icon{name="lucide:settings"} [Configuration Reference](/reference/configuration)
- :icon{name="lucide:flask"} [Testing Guide](/guide/testing)
- :icon{name="lucide:zap"} [Quick Start](/guide/quick-start)

---

*"The right tools, perfectly organized, effortlessly integrated."*
