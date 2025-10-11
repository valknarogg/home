# 📚 Kompose Documentation Index

## Overview

This index helps you navigate all the documentation for the kompose system - a comprehensive Docker Compose stack management system.

---

## 🎯 Start Here

### New to kompose?
➡️ **[README.md](README.md)** - System overview  
➡️ **[CORE_QUICK_REF.md](CORE_QUICK_REF.md)** - Core infrastructure reference  
➡️ **[VPN_QUICK_REF.md](VPN_QUICK_REF.md)** - VPN quick reference

### Setting up VPN for remote access?
➡️ **[vpn/README.md](vpn/README.md)** - Complete VPN setup guide  
➡️ **[VPN_INTEGRATION.md](VPN_INTEGRATION.md)** - Private intranet integration

### Working with automation?
➡️ **[CHAIN_QUICK_REF.md](CHAIN_QUICK_REF.md)** - Automation stack reference  
➡️ **[chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md)** - Integration guide

---

## 📋 Documentation by Stack

### 🔒 VPN Stack (WireGuard/wg-easy)
| Document | Purpose | Time to Read |
|----------|---------|--------------|
| **[vpn/README.md](vpn/README.md)** | Complete VPN setup guide | 20 min |
| **[VPN_QUICK_REF.md](VPN_QUICK_REF.md)** | Quick commands & reference | 5 min |
| **[VPN_INTEGRATION.md](VPN_INTEGRATION.md)** | Private intranet setup | 30 min |

**Key Features:**
- Secure remote access to all services
- Mobile & desktop client support
- QR code configuration
- Web-based client management
- Integration with all kompose stacks

### 🏗️ Core Stack (Infrastructure)
| Document | Purpose | Time to Read |
|----------|---------|--------------|
| **[core/README.md](core/README.md)** | Complete core documentation | 15 min |
| **[CORE_QUICK_REF.md](CORE_QUICK_REF.md)** | Quick commands & reference | 5 min |
| **[CORE_STACK_SUMMARY.md](CORE_STACK_SUMMARY.md)** | Stack summary | 10 min |

**Services:**
- PostgreSQL - Database
- Redis - Cache & sessions
- Mosquitto - MQTT broker
- Redis Commander - Web UI

### 🔗 Chain Stack (Automation)
| Document | Purpose | Time to Read |
|----------|---------|--------------|
| **[chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md)** | Complete integration guide | 30 min |
| **[CHAIN_QUICK_REF.md](CHAIN_QUICK_REF.md)** | Quick commands & reference | 5 min |
| **[CHAIN_INTEGRATION_SUMMARY.md](CHAIN_INTEGRATION_SUMMARY.md)** | Integration overview | 15 min |

**Services:**
- n8n - Workflow automation
- Semaphore - Ansible UI
- Gitea - Git repository (optional)

---

## 🛠️ Management Tools

### Main Script
| Tool | Purpose | Documentation |
|------|---------|---------------|
| **kompose.sh** | Stack management CLI | `./kompose.sh help` |

**Key Commands:**
```bash
./kompose.sh up [STACK]          # Start stack
./kompose.sh down [STACK]        # Stop stack
./kompose.sh logs [STACK]        # View logs
./kompose.sh status [STACK]      # Check status
./kompose.sh db backup          # Backup databases
```

### Helper Scripts
| Script | Purpose | Documentation |
|--------|---------|---------------|
| **rename-home-to-core.sh** | Rename home→core | [RENAME_HOME_TO_CORE.md](RENAME_HOME_TO_CORE.md) |
| **migrate-auto-to-chain.sh** | Migrate auto→chain | [CHAIN_INTEGRATION_SUMMARY.md](CHAIN_INTEGRATION_SUMMARY.md) |

---

## 🎓 Quick Start Guides

### Setting Up VPN for Remote Access

**Goal:** Access all kompose services securely from anywhere

```bash
# 1. Configure VPN
cd vpn
nano .env  # Set WG_HOST and generate PASSWORD_HASH

# 2. Start VPN stack
./kompose.sh up vpn

# 3. Create client
# Open https://vpn.pivoine.art
# Click "+" → Create client → Download/Scan QR

# 4. Connect & Access
# Connect to VPN → Access services via:
# https://chain.pivoine.art (n8n)
# https://vault.pivoine.art (Vaultwarden)
# postgresql://core-postgres:5432 (Database)
```

**Next Steps:**
- [vpn/README.md](vpn/README.md) - Full setup
- [VPN_INTEGRATION.md](VPN_INTEGRATION.md) - Integration patterns
- [VPN_QUICK_REF.md](VPN_QUICK_REF.md) - Commands

### Setting Up Core Infrastructure

**Goal:** Deploy shared database, cache, and MQTT services

```bash
# 1. Create network
docker network create kompose

# 2. Configure secrets
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> secrets.env
echo "REDIS_PASSWORD=$(openssl rand -base64 32)" >> secrets.env

# 3. Start core
./kompose.sh up core

# 4. Verify
./kompose.sh status core
docker exec core-postgres psql -U kompose -l
```

**Next Steps:**
- [core/README.md](core/README.md) - Full documentation
- [CORE_QUICK_REF.md](CORE_QUICK_REF.md) - Quick reference

### Setting Up Automation Stack

**Goal:** Deploy n8n and Semaphore for workflow automation

```bash
# 1. Ensure core is running
./kompose.sh status core

# 2. Start chain stack
./kompose.sh up chain

# 3. Access services
# n8n: https://chain.pivoine.art
# Semaphore: https://chain.pivoine.art/semaphore

# 4. Configure
# Set up n8n workflows
# Configure Ansible playbooks in Semaphore
```

**Next Steps:**
- [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) - Integration
- [CHAIN_QUICK_REF.md](CHAIN_QUICK_REF.md) - Commands

---

## 🎯 Common Use Cases

### Remote Development Environment

**Access your development stack from anywhere:**

1. **Set up VPN**: [vpn/README.md](vpn/README.md)
2. **Connect to VPN**: Use WireGuard client
3. **Access services**:
   ```bash
   psql -h core-postgres -U valknar
   redis-cli -h core-redis
   ssh dev-server.kompose.local
   ```

**Documentation:**
- [VPN_INTEGRATION.md](VPN_INTEGRATION.md) - Pattern 1: Remote Development

### Team Collaboration

**Provide secure access for team members:**

1. **Create VPN clients** for each team member
2. **Set up access levels** via AllowedIPs
3. **Document access** in vpn/clients.md

**Documentation:**
- [VPN_INTEGRATION.md](VPN_INTEGRATION.md) - Pattern 5: Team Collaboration
- [vpn/README.md](vpn/README.md) - Client Management

### Automated Deployments

**Set up CI/CD with n8n and Semaphore:**

1. **Configure Git webhooks** in Gitea
2. **Create n8n workflow** for deployment pipeline
3. **Set up Ansible playbooks** in Semaphore
4. **Test deployment** via VPN

**Documentation:**
- [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) - Deployment workflows
- [VPN_INTEGRATION.md](VPN_INTEGRATION.md) - Pattern 2: Automated Deployment

### IoT Device Integration

**Connect IoT devices to private network:**

1. **Configure device** with WireGuard
2. **Set up MQTT** connection to core-mqtt
3. **Create workflows** in n8n for data processing

**Documentation:**
- [VPN_INTEGRATION.md](VPN_INTEGRATION.md) - Pattern 4: IoT Integration
- [core/README.md](core/README.md) - MQTT Broker

---

## 📊 Documentation Structure

```
kompose/
│
├── 📖 README.md                       # Main overview
├── 📄 INDEX.md                        # This file - documentation index
│
├── 🔒 VPN Stack
│   ├── vpn/README.md                  # Complete VPN guide
│   ├── VPN_QUICK_REF.md              # Quick reference
│   └── VPN_INTEGRATION.md            # Integration patterns
│
├── 🏗️ Core Stack
│   ├── core/README.md                # Complete core guide
│   ├── CORE_QUICK_REF.md            # Quick reference
│   └── CORE_STACK_SUMMARY.md        # Stack summary
│
├── 🔗 Chain Stack
│   ├── chain/INTEGRATION_GUIDE.md   # Complete integration guide
│   ├── CHAIN_QUICK_REF.md           # Quick reference
│   └── CHAIN_INTEGRATION_SUMMARY.md # Integration summary
│
├── 🔧 Management Scripts
│   ├── kompose.sh                    # Main stack manager
│   ├── rename-home-to-core.sh       # Rename automation
│   └── migrate-auto-to-chain.sh     # Migration automation
│
└── 📚 Additional Documentation
    ├── EXECUTION_CHECKLIST.md        # Step-by-step execution
    ├── RENAME_HOME_TO_CORE.md       # Rename guide
    ├── DATABASE-MANAGEMENT.md        # Database operations
    └── TIMEZONE_*.md                 # Timezone configuration
```

---

## 🔍 Finding What You Need

### By Task

**I want to...**

| Task | Documentation |
|------|---------------|
| Set up remote access | [vpn/README.md](vpn/README.md) |
| Deploy core services | [core/README.md](core/README.md) |
| Create workflows | [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) |
| Backup databases | [DATABASE-MANAGEMENT.md](DATABASE-MANAGEMENT.md) |
| Manage VPN clients | [VPN_QUICK_REF.md](VPN_QUICK_REF.md) |
| Access via VPN | [VPN_INTEGRATION.md](VPN_INTEGRATION.md) |
| Configure timezone | [TIMEZONE_QUICKSTART.md](TIMEZONE_QUICKSTART.md) |

### By Stack

**Which stack handles...**

| Function | Stack | Documentation |
|----------|-------|---------------|
| Database (PostgreSQL) | core | [core/README.md](core/README.md) |
| Cache (Redis) | core | [core/README.md](core/README.md) |
| MQTT Messaging | core | [core/README.md](core/README.md) |
| VPN Access | vpn | [vpn/README.md](vpn/README.md) |
| Workflows (n8n) | chain | [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) |
| Ansible (Semaphore) | chain | [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) |
| Password Manager | vault | Check vault directory |
| Notifications | chat | Check chat directory |

### By Experience Level

**Beginner:**
1. [README.md](README.md) - System overview
2. [CORE_QUICK_REF.md](CORE_QUICK_REF.md) - Core basics
3. [VPN_QUICK_REF.md](VPN_QUICK_REF.md) - VPN basics
4. Use quick reference guides

**Intermediate:**
1. Stack-specific README files
2. Integration guides
3. `./kompose.sh help` for commands

**Advanced:**
1. Complete integration guides
2. Source code in compose.yaml files
3. Custom modifications

---

## 📞 Support & Help

### Getting Help

1. **Check relevant documentation**:
   - Quick reference for commands
   - README for detailed setup
   - Integration guide for advanced usage

2. **Use built-in help**:
   ```bash
   ./kompose.sh help
   ./kompose.sh db --help
   ./kompose.sh tag --help
   ```

3. **Check logs**:
   ```bash
   ./kompose.sh logs [STACK] -f
   docker logs [CONTAINER] -f
   ```

4. **Verify status**:
   ```bash
   ./kompose.sh status [STACK]
   docker ps
   docker network inspect kompose
   ```

### Troubleshooting

**VPN Issues:**
- [VPN_QUICK_REF.md](VPN_QUICK_REF.md) - Troubleshooting section
- [vpn/README.md](vpn/README.md) - Troubleshooting guide

**Core Services Issues:**
- [CORE_QUICK_REF.md](CORE_QUICK_REF.md) - Troubleshooting section
- [core/README.md](core/README.md) - Troubleshooting guide

**Automation Issues:**
- [CHAIN_QUICK_REF.md](CHAIN_QUICK_REF.md) - Troubleshooting section
- [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md) - Troubleshooting

---

## 🔗 External Resources

### WireGuard VPN
- [WireGuard Official](https://www.wireguard.com/)
- [wg-easy GitHub](https://github.com/wg-easy/wg-easy)
- [WireGuard Quick Start](https://www.wireguard.com/quickstart/)

### Core Services
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [Mosquitto MQTT](https://mosquitto.org/documentation/)

### Automation
- [n8n Documentation](https://docs.n8n.io/)
- [Semaphore Ansible UI](https://docs.ansible-semaphore.com/)
- [Ansible Documentation](https://docs.ansible.com/)

---

## ✅ Quick Checklist

### Initial Setup
- [ ] Install Docker & Docker Compose
- [ ] Clone kompose repository
- [ ] Create `secrets.env` from template
- [ ] Create kompose network: `docker network create kompose`
- [ ] Start core stack: `./kompose.sh up core`

### VPN Setup
- [ ] Configure vpn/.env (WG_HOST, PASSWORD_HASH)
- [ ] Configure port forwarding (UDP 51820)
- [ ] Start VPN: `./kompose.sh up vpn`
- [ ] Create first client
- [ ] Test connection

### Automation Setup
- [ ] Start chain stack: `./kompose.sh up chain`
- [ ] Access n8n: https://chain.pivoine.art
- [ ] Configure first workflow
- [ ] Set up Semaphore project

### Security Hardening
- [ ] Change all default passwords
- [ ] Enable firewall rules
- [ ] Configure VPN client restrictions
- [ ] Set up monitoring
- [ ] Configure backups

---

## 📈 System Statistics

**Available Stacks:**
- 🏗️ Core - Infrastructure (PostgreSQL, Redis, MQTT)
- 🔒 VPN - WireGuard remote access
- 🔗 Chain - Automation (n8n, Semaphore)
- 💬 Chat - Notifications (Gotify)
- 🔐 Vault - Password manager (Vaultwarden)
- 📝 And more...

**Documentation:**
- 📄 15+ comprehensive documents
- 🔧 Multiple automated scripts
- ⏱️ 10,000+ lines of documentation
- 💡 100+ command examples

---

## 🎯 Recommended Learning Path

### Day 1: Foundation
1. Read [README.md](README.md)
2. Deploy core stack with [core/README.md](core/README.md)
3. Test with [CORE_QUICK_REF.md](CORE_QUICK_REF.md)

### Day 2: Remote Access
1. Set up VPN with [vpn/README.md](vpn/README.md)
2. Create clients and test connectivity
3. Access services via VPN

### Day 3: Automation
1. Deploy chain stack with [chain/INTEGRATION_GUIDE.md](chain/INTEGRATION_GUIDE.md)
2. Create first n8n workflow
3. Set up Ansible playbook in Semaphore

### Day 4: Integration
1. Study [VPN_INTEGRATION.md](VPN_INTEGRATION.md)
2. Implement your use case
3. Set up monitoring and backups

### Ongoing: Operations
1. Use quick reference guides daily
2. Implement backup strategy
3. Monitor and optimize

---

**Last Updated**: 2024-10-11  
**Version**: 2.0  
**Status**: ✅ Complete with VPN Integration

---

**🚀 Quick Start:** [README.md](README.md) → [CORE_QUICK_REF.md](CORE_QUICK_REF.md) → [VPN_QUICK_REF.md](VPN_QUICK_REF.md)  
**🔒 VPN Setup:** [vpn/README.md](vpn/README.md) → [VPN_INTEGRATION.md](VPN_INTEGRATION.md)  
**📞 Need Help?** Check the relevant quick reference guide first!
