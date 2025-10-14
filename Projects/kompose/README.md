<div align="center">
<img src="icon.svg" alt="Kompose Icon" width="128" height="128"></img>

# kompose.sh

**Docker Compose Stack Manager with Integrated SSO, Automation & Monitoring**

[Documentation](https://code.pivoine.art/kompose) • [Quick Start](#quick-start) • [Features](#features)

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![Docker](https://img.shields.io/badge/docker-compose-2496ED?logo=docker)](https://docs.docker.com/compose/)

</div>

---

## Overview

Kompose is a powerful Docker Compose stack manager that simplifies deploying and managing complex multi-service applications. Built for developers and system administrators who need a production-ready platform with minimal configuration.

### Key Features

- 🚀 **Interactive Setup Wizard** - Get started in minutes with guided initialization
- 🔐 **Built-in SSO** - Keycloak authentication with OAuth2 Proxy integration
- 🔒 **Secrets Management** - Automated generation and rotation of 35+ secrets
- 🏠 **Smart Home Ready** - Home Assistant, Matter, Zigbee, ESPHome support
- ⚡ **Automation Platform** - n8n workflows and Ansible orchestration
- 🔧 **Developer Tools** - Gitea, VS Code Server, documentation site
- 📊 **Monitoring** - Uptime Kuma, Grafana, Umami analytics
- 🌐 **VPN Access** - WireGuard with easy configuration
- 🎯 **REST API** - Programmatic control of all stacks
- 📦 **Database Management** - Automated backups and migrations
- 🏷️ **Git Tag Deployments** - Version-controlled deployments
- ➕ **Custom Stacks** - Easy integration of your own services

## Quick Start

### Prerequisites

- Docker 20.10+ & Docker Compose v2.0+
- Git
- Bash 4.0+

Optional for development:
- Node.js 18+ and pnpm
- Python 3

### Installation

```bash
# Clone the repository
git clone https://code.pivoine.art/valknar/kompose.git
cd kompose

# Run the interactive setup wizard
./kompose.sh init
```

The wizard will:
1. ✅ Check system dependencies
2. ✅ Let you choose local or production setup
3. ✅ Configure environment files
4. ✅ Generate secure secrets automatically
5. ✅ Install project dependencies
6. ✅ Create Docker network
7. ✅ Set up directory structure

### First Steps

**Local Development:**
```bash
# Start core services (PostgreSQL, Redis, MQTT)
./kompose.sh up core

# Start authentication (Keycloak)
./kompose.sh up auth

# Start management portal
./kompose.sh up kmps

# Access KMPS at http://localhost:3100
```

**Production Deployment:**
```bash
# Start reverse proxy with SSL
./kompose.sh up proxy

# Start core and auth services
./kompose.sh up core auth

# Start your chosen stacks
./kompose.sh up kmps chain code
```

## Available Stacks

| Stack | Description | Services |
|-------|-------------|----------|
| **core** | Essential services | PostgreSQL, Redis, MQTT |
| **auth** | SSO & Authentication | Keycloak, OAuth2 Proxy |
| **kmps** | Management Portal | Next.js portal for user/SSO admin |
| **proxy** | Reverse Proxy | Traefik with SSL/TLS |
| **chain** | Automation | n8n workflows, Semaphore/Ansible |
| **code** | Git & CI/CD | Gitea with Actions runner |
| **home** | Smart Home | Home Assistant, Matter, Zigbee |
| **vpn** | Remote Access | WireGuard (wg-easy) |
| **messaging** | Notifications | Gotify, Mailhog |
| **watch** | Monitoring | Uptime Kuma, Grafana, Prometheus |
| **vault** | Passwords | Vaultwarden |
| **link** | Bookmarks | Linkwarden |
| **track** | Analytics | Umami |
| **+custom/** | Your stacks | Any Docker Compose stack |

## Essential Commands

### Stack Management

```bash
./kompose.sh up <stack>          # Start a stack
./kompose.sh down <stack>        # Stop a stack
./kompose.sh restart <stack>     # Restart a stack
./kompose.sh logs <stack> -f     # Follow logs
./kompose.sh status              # Show all stack status
./kompose.sh list                # List available stacks
```

### Secrets Management

```bash
./kompose.sh secrets generate    # Generate all secrets
./kompose.sh secrets validate    # Validate configuration
./kompose.sh secrets list        # List all secrets
./kompose.sh secrets rotate NAME # Rotate a secret
./kompose.sh secrets backup      # Backup secrets
```

### Environment Setup

```bash
./kompose.sh init                # Interactive initialization wizard
./kompose.sh setup local         # Switch to local development
./kompose.sh setup prod          # Switch to production
./kompose.sh setup status        # Check current mode
```

### Database Operations

```bash
./kompose.sh db backup           # Backup all databases
./kompose.sh db restore -f FILE  # Restore from backup
./kompose.sh db list             # List backups
./kompose.sh db status           # Database health check
```

### Custom Stacks

```bash
./kompose.sh generate mystack    # Generate custom stack
./kompose.sh up mystack          # Start your custom stack
./kompose.sh logs mystack -f     # Monitor your stack
```

### REST API Server

```bash
./kompose.sh api start           # Start API server
./kompose.sh api status          # Check API status
./kompose.sh api stop            # Stop API server

# Test API
curl http://localhost:8080/api/health
curl http://localhost:8080/api/stacks
```

### Git Tag Deployments

```bash
./kompose.sh tag deploy -s frontend -e prod -v 1.2.3
./kompose.sh tag list
./kompose.sh tag rollback -s frontend -e prod -v 1.2.2
```

## Documentation

### 📚 Complete Documentation

Visit the full documentation site or browse the guides below.

### Getting Started

- [Installation Guide](./INSTALLATION.md) - Detailed installation instructions
- [Quick Start Guide](_docs/content/3.guide/quick-start.md) - Get up and running fast
- [Initialization Guide](_docs/content/3.guide/initialization.md) - Deep dive into setup wizard
- [Environment Setup](_docs/content/3.guide/environment-setup.md) - Manage local/production configs

### Essential Guides

- **[Secrets Management](_docs/content/3.guide/secrets.md)** - Complete guide to managing credentials
- **[Custom Stacks](_docs/content/3.guide/custom-stacks.md)** - Create and integrate your own services
- [Stack Management](_docs/content/3.guide/stack-management.md) - Managing all services
- [Database Operations](_docs/content/3.guide/database.md) - Backups, migrations, operations
- [REST API Server](_docs/content/3.guide/api-server.md) - Programmatic control
- [Configuration](_docs/content/3.guide/configuration.md) - Advanced configuration

### Reference Documentation

- [CLI Reference](_docs/content/4.reference/cli.md) - All commands and options
- **[Environment Variables](_docs/content/4.reference/environment-variables.md)** - Complete variable reference (200+ variables)
- [Stack Configuration](_docs/content/4.reference/stack-configuration.md) - Stack-specific settings

### Stack-Specific Documentation

Browse detailed documentation for each stack in `_docs/content/5.stacks/`:
- [Core Stack](_docs/content/5.stacks/core.md) - PostgreSQL, Redis, MQTT
- [Auth Stack](_docs/content/5.stacks/auth.md) - Keycloak SSO
- [KMPS Stack](_docs/content/5.stacks/kmps.md) - Management portal
- And 11 more stack guides...

### Development

- [Local Development](./LOCAL_DEVELOPMENT.md) - Contributing to Kompose
- [KMPS Development](./kmps/DEVELOPMENT.md) - Working on the portal

## Environment Modes

### Local Development
- Services on localhost:PORT
- No domain configuration needed
- Direct database connections
- Fast setup (~5 minutes)
- Perfect for: Development, testing, learning

### Production
- Domain-based routing with subdomains
- SSL/TLS via Let's Encrypt
- Traefik reverse proxy
- OAuth2 SSO integration
- Perfect for: Production deployments, public-facing services

Switch anytime with:
```bash
./kompose.sh setup local  # or prod
```

## Custom Stacks

Extend Kompose with your own Docker Compose stacks:

```bash
# Generate a new custom stack
./kompose.sh generate myblog

# Or create manually
mkdir -p +custom/myblog
# Add compose.yaml, .env, etc.

# Stack is automatically discovered!
./kompose.sh list
./kompose.sh up myblog
```

Custom stacks automatically get:
- ✅ Environment variable inheritance
- ✅ Domain configuration integration  
- ✅ Secrets management
- ✅ Database connectivity
- ✅ Traefik routing with SSL
- ✅ All standard management commands

[Learn more about custom stacks →](_docs/content/3.guide/custom-stacks.md)

## Secrets Management

Kompose includes a comprehensive secrets management system:

```bash
# Generate all 35+ secrets automatically
./kompose.sh secrets generate

# Validate configuration
./kompose.sh secrets validate

# List secrets by stack
./kompose.sh secrets list

# Rotate secrets safely
./kompose.sh secrets rotate DB_PASSWORD
```

Features:
- 🔐 Automatic generation of strong credentials
- 🔄 Safe rotation with automatic backups
- ✅ Validation to ensure complete configuration
- 📋 Stack mapping shows secret usage
- 🎯 Multiple secret types (passwords, tokens, UUIDs, htpasswd)

[Learn more about secrets management →](_docs/content/3.guide/secrets.md)

## Project Structure

```
kompose/
├── kompose.sh              # Main CLI interface
├── kompose-setup.sh        # Setup & initialization
├── kompose-stack.sh        # Stack management
├── kompose-db.sh           # Database operations
├── kompose-secrets.sh      # Secrets management
├── kompose-tag.sh          # Git tag deployments
├── kompose-api.sh          # API server management
├── kompose-utils.sh        # Utilities
├── kompose-api-server.sh   # REST API server
├── _docs/                  # Documentation site (Nuxt)
│   ├── content/
│   │   ├── 3.guide/        # User guides
│   │   ├── 4.reference/    # Reference docs
│   │   └── 5.stacks/       # Stack documentation
│   └── archive/            # Historical docs
├── kmps/                   # Management portal (Next.js)
├── auth/                   # Authentication stack
├── chain/                  # Automation stack
├── code/                   # Git stack
├── core/                   # Core services stack
├── home/                   # Smart home stack
├── proxy/                  # Traefik stack
├── vpn/                    # VPN stack
├── +custom/                # Your custom stacks
└── backups/                # Automated backups
    ├── database/           # Database backups
    └── secrets/            # Secrets backups
```

## Requirements

### Required
- **Docker** 20.10+ with Docker Compose v2.0+
- **Git** for repository management
- **Bash** 4.0+ shell

### Optional (for Development)
- **Node.js** 18+ and **pnpm** (for _docs and kmps)
- **Python 3** (for REST API server)
- **PostgreSQL client tools** (for database operations)

## Configuration

Configuration is managed through environment files:

- `.env` - Main environment configuration (200+ variables)
- `domain.env` - Domain and subdomain settings
- `secrets.env` - Sensitive credentials (35+ secrets, never commit!)

Templates are provided for each file. The init wizard creates them automatically.

## API Access

Start the REST API server:

```bash
./kompose.sh api start
```

**Endpoints:**
- `GET /api/health` - Health check
- `GET /api/stacks` - List all stacks
- `GET /api/stacks/{stack}` - Stack details
- `POST /api/stacks/{stack}/start` - Start stack
- `POST /api/stacks/{stack}/stop` - Stop stack
- `GET /api/db/status` - Database status
- `GET /api/tag/list` - List deployment tags
- `POST /api/secrets/generate` - Generate secrets
- `GET /api/secrets/validate` - Validate secrets

## Statistics

- **Built-in Stacks:** 14 production-ready services
- **Managed Secrets:** 35+ automatically generated
- **Environment Variables:** 200+ documented
- **Docker Images:** 20+ pre-configured
- **Documentation Pages:** 30+ comprehensive guides
- **CLI Commands:** 50+ management commands

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📚 [Full Documentation](https://code.pivoine.art/kompose)
- 🐛 [Issue Tracker](https://code.pivoine.art/valknar/kompose/issues)
- 💬 [Discussions](https://code.pivoine.art/valknar/kompose/discussions)
- 📖 [Quick Reference](_docs/content/4.reference/quick-reference.md)

## Acknowledgments

Built with:
- [Docker Compose](https://docs.docker.com/compose/) - Container orchestration
- [Traefik](https://traefik.io/) - Reverse proxy and SSL
- [Keycloak](https://www.keycloak.org/) - Identity and access management
- [n8n](https://n8n.io/) - Workflow automation
- [Home Assistant](https://www.home-assistant.io/) - Smart home platform
- [Gitea](https://gitea.io/) - Git hosting
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Redis](https://redis.io/) - Caching
- And many other amazing open-source projects!

---

<div align="center">

**Made with ❤️ for the self-hosting community**

[Get Started](#quick-start) • [View Docs](_docs/content/) • [Report Bug](https://code.pivoine.art/valknar/kompose/issues)

</div>
