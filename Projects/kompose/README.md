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
- 🏠 **Smart Home Ready** - Home Assistant, Matter, Zigbee, ESPHome support
- ⚡ **Automation Platform** - n8n workflows and Ansible orchestration
- 🔧 **Developer Tools** - Gitea, VS Code Server, documentation site
- 📊 **Monitoring** - Uptime Kuma, Grafana, Umami analytics
- 🌐 **VPN Access** - WireGuard with easy configuration
- 🎯 **REST API** - Programmatic control of all stacks
- 📦 **Database Management** - Automated backups and migrations
- 🏷️ **Git Tag Deployments** - Version-controlled deployments

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
4. ✅ Install project dependencies
5. ✅ Create Docker network
6. ✅ Set up directory structure

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
| **core** | Essential services | PostgreSQL, Redis, MQTT, Directus |
| **auth** | SSO & Authentication | Keycloak, OAuth2 Proxy |
| **kmps** | Management Portal | Next.js portal for user/SSO admin |
| **proxy** | Reverse Proxy | Traefik with SSL/TLS |
| **chain** | Automation | n8n workflows, Semaphore/Ansible |
| **code** | Git & CI/CD | Gitea with Actions runner |
| **home** | Smart Home | Home Assistant, Matter, Zigbee |
| **vpn** | Remote Access | WireGuard (wg-easy) |
| **messaging** | Notifications | Gotify, Mailhog |
| **watch** | Monitoring | Uptime Kuma, Grafana |
| **vault** | Passwords | Vaultwarden |
| **link** | Bookmarks | Linkwarden |
| **track** | Analytics | Umami |

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

### Getting Started
- [Installation Guide](./INSTALLATION.md) - Detailed installation instructions
- [Quick Start Guide](_docs/content/3.guide/quick-start.md) - Get up and running fast
- [Initialization Guide](_docs/content/3.guide/initialization.md) - Deep dive into setup wizard
- [Environment Setup](_docs/content/3.guide/environment-setup.md) - Manage configurations

### Guides
- [Stack Management](_docs/content/3.guide/stack-management.md)
- [Database Operations](_docs/content/3.guide/database.md)
- [REST API Server](_docs/content/3.guide/api-server.md)
- [Configuration](_docs/content/3.guide/configuration.md)

### Reference
- [CLI Reference](_docs/content/4.reference/cli.md)
- [Environment Variables](_docs/content/4.reference/environment.md)

### Development
- [Local Development](./LOCAL_DEVELOPMENT.md)
- [KMPS Development](./kmps/DEVELOPMENT.md)

## Environment Modes

### Local Development
- Services on localhost:PORT
- No domain configuration needed
- Direct database connections
- Fast setup (~5 minutes)

**Perfect for:** Development, testing, learning

### Production
- Domain-based routing with subdomains
- SSL/TLS via Let's Encrypt
- Traefik reverse proxy
- OAuth2 SSO integration

**Perfect for:** Production deployments, public-facing services

Switch anytime with:
```bash
./kompose.sh setup local  # or prod
```

## Project Structure

```
kompose/
├── kompose.sh              # Main CLI interface
├── kompose-setup.sh        # Setup & initialization
├── kompose-stack.sh        # Stack management
├── kompose-db.sh           # Database operations
├── kompose-tag.sh          # Git tag deployments
├── kompose-api.sh          # API server management
├── kompose-utils.sh        # Utilities
├── kompose-api-server.sh   # REST API server
├── _docs/                  # Documentation site (Nuxt)
├── kmps/                   # Management portal (Next.js)
├── auth/                   # Authentication stack
├── chain/                  # Automation stack
├── code/                   # Git stack
├── core/                   # Core services stack
├── home/                   # Smart home stack
├── proxy/                  # Traefik stack
├── vpn/                    # VPN stack
├── +custom/                # Optional user stacks
└── +utility/               # Utility services
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

- `.env` - Main environment configuration
- `domain.env` - Domain and subdomain settings
- `secrets.env` - Sensitive credentials (never commit!)

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

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📚 [Documentation](https://code.pivoine.art/kompose)
- 🐛 [Issue Tracker](https://code.pivoine.art/valknar/kompose/issues)
- 💬 [Discussions](https://code.pivoine.art/valknar/kompose/discussions)

## Acknowledgments

Built with:
- [Docker Compose](https://docs.docker.com/compose/)
- [Traefik](https://traefik.io/)
- [Keycloak](https://www.keycloak.org/)
- [n8n](https://n8n.io/)
- [Home Assistant](https://www.home-assistant.io/)
- [Gitea](https://gitea.io/)
- And many other amazing open-source projects!

---

<div align="center">
Made with ❤️ for the self-hosting community
</div>
