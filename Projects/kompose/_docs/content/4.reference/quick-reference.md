---
title: Quick Reference
description: Essential commands and quick reference guide for Kompose
---

# Kompose Quick Reference

## Essential Commands

### Setup & Migration

```bash
# Make scripts executable
chmod +x *.sh

# Migrate to new configuration
./migrate-domain-config.sh

# Clean up old files
./cleanup-project.sh

# Validate configuration
./validate-config.sh
```

### Service Management

```bash
# Start all services
./kompose.sh up

# Start specific stack
./kompose.sh up core

# Stop all services
./kompose.sh down

# Restart services
./kompose.sh restart

# View status
./kompose.sh status

# View logs
./kompose.sh logs chain -f
```

### Domain Configuration

```bash
# Edit domain
nano domain.env
# Change: ROOT_DOMAIN=yourdomain.com

# Apply changes
./kompose.sh restart
```

## Key Files

| File | Purpose | Edit? |
|------|---------|-------|
| `domain.env` | Domain configuration | YES |
| `.env` | Root configuration | Rarely |
| `secrets.env` | Sensitive data | YES (setup) |
| `kompose.sh` | Main control script | NO |
| `<stack>/.env` | Stack-specific config | YES |

## Default Service URLs

All services at: `<subdomain>.pivoine.art`

| Service | Subdomain | Purpose |
|---------|-----------|---------|
| Proxy | `proxy` | Traefik dashboard |
| Auth | `auth` | Keycloak SSO |
| Chain | `chain` | n8n workflows |
| Code | `code` | Gitea git |
| Auto | `auto` | Semaphore Ansible |
| Vault | `vault` | Vaultwarden |
| Home | `home` | Home Assistant |
| Chat | `chat` | Gotify |
| Mail | `mail` | Mailhog |

## Troubleshooting

### Services Won't Start

```bash
./kompose.sh logs <stack>
./validate-config.sh
docker network create kompose
```

### Domain Not Working

```bash
# Check DNS
dig proxy.pivoine.art

# Check Traefik
./kompose.sh logs proxy

# Verify domain.env
cat domain.env | grep ROOT_DOMAIN
```

### SSL Certificate Issues

```bash
# Check ACME logs
./kompose.sh logs proxy | grep -i acme

# Test domain access
curl -v http://proxy.pivoine.art

# Use staging certs for testing
# Edit proxy/compose.yaml
```

## Security Checklist

- [ ] Change all secrets in `secrets.env`
- [ ] Enable firewall (ports 22, 80, 443)
- [ ] Configure DNS properly
- [ ] Use strong passwords
- [ ] Regular backups
- [ ] Restrict Traefik dashboard
- [ ] Monitor logs

## Backup & Restore

```bash
# Backup all databases
./kompose.sh db backup

# List backups
./kompose.sh db list

# Restore database
./kompose.sh db restore -f backup.sql

# Backup configuration
cp .env .env.backup
cp secrets.env secrets.env.backup
cp domain.env domain.env.backup
```

## Quick Start (New Installation)

1. **Configure Domain**
   ```bash
   nano domain.env  # Set ROOT_DOMAIN
   ```

2. **Configure Secrets**
   ```bash
   cp secrets.env.template secrets.env
   nano secrets.env  # Replace all CHANGE_ME
   ```

3. **Create Network**
   ```bash
   docker network create kompose
   ```

4. **Start Services**
   ```bash
   ./kompose.sh up core    # Start core
   ./kompose.sh up proxy   # Start proxy
   ./kompose.sh up         # Start all
   ```

5. **Verify**
   ```bash
   ./kompose.sh status
   ```

## Update Services

```bash
# Pull latest images
./kompose.sh pull

# Rebuild and restart
./kompose.sh down
./kompose.sh up
```

## Monitoring

```bash
# View all containers
./kompose.sh ps

# Check specific stack
./kompose.sh status chain

# Follow logs
./kompose.sh logs chain -f

# Check Docker
docker ps
docker network ls
docker volume ls
```

## Multi-Environment Setup

```bash
# Production
cp domain.env domain.prod.env
# Edit: ROOT_DOMAIN=example.com

# Staging
cp domain.env domain.staging.env
# Edit: ROOT_DOMAIN=staging.example.com

# Use environment
ln -sf domain.prod.env domain.env
./kompose.sh up
```

## Emergency Commands

```bash
# Stop everything
./kompose.sh down

# Force stop
docker stop $(docker ps -q)

# Remove all containers (DANGEROUS)
docker-compose down -v  # Per stack

# Restart Docker
sudo systemctl restart docker

# Check Docker status
sudo systemctl status docker
```

## Getting Help

1. Run: `./validate-config.sh`
2. Check logs: `./kompose.sh logs <stack>`
3. Review: [Quick Start](/guide/quick-start)
4. Read: [Configuration Guide](/guide/configuration)

## Common Tasks

### Change Domain

```bash
nano domain.env
./kompose.sh restart
```

### Add Service

1. Create stack directory
2. Add compose.yaml
3. Update domain.env
4. Start: `./kompose.sh up <stack>`

### Update Configuration

```bash
nano <stack>/.env
./kompose.sh restart <stack>
```

### Check Logs for Errors

```bash
./kompose.sh logs | grep -i error
./kompose.sh logs chain | grep -i error
```

## Learning Path

**Day 1**: Setup
- Read [Quick Start](/guide/quick-start)
- Configure `domain.env`
- Start services

**Day 2**: Configuration
- Read [Configuration Guide](/guide/configuration)
- Customize services
- Configure DNS

**Day 3**: Operations
- Learn `kompose.sh` commands
- Set up backups
- Monitor logs

## Health Check

```bash
# Run validation
./validate-config.sh

# Check all services
./kompose.sh status

# Verify DNS
dig proxy.pivoine.art

# Test HTTPS
curl -I https://proxy.pivoine.art
```
