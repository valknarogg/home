# Chain Stack Integration Summary

## What Changed

The **chain** stack has been upgraded from a single-service stack (n8n only) to a comprehensive automation platform that includes:

1. **n8n** - Visual workflow automation engine
2. **Semaphore** - Ansible UI and task runner  
3. **Semaphore Runner** - Task execution worker

This integration combines workflow automation (n8n) with infrastructure automation (Ansible/Semaphore) in a single, cohesive stack.

## Files Modified

### `/home/valknar/Projects/kompose/chain/compose.yaml`
- **Added**: Semaphore service configuration
- **Added**: Semaphore Runner service configuration
- **Updated**: n8n service with improved configuration
- **Added**: New volumes for Semaphore data, config, and tmp
- **Updated**: All services now use consistent naming and networking

### `/home/valknar/Projects/kompose/chain/.env`
- **Added**: Semaphore-specific environment variables
- **Updated**: Organized into clear sections (n8n, Semaphore, Shared)
- **Added**: Documentation for all required secrets
- **Updated**: Port and host configurations

### `/home/valknar/Projects/kompose/kompose.sh`
- **Updated**: Chain stack description to reflect new services
- **Added**: `semaphore` to the DATABASES array for database management

## Files Created

### `/home/valknar/Projects/kompose/chain/INTEGRATION_GUIDE.md`
Comprehensive guide covering:
- Architecture overview with diagram
- Setup instructions
- Usage examples
- Integration between n8n and Semaphore
- Migration from standalone auto stack
- Troubleshooting
- API endpoints
- Security notes
- Performance tuning

### `/home/valknar/Projects/kompose/migrate-auto-to-chain.sh`
Automated migration script that:
- Backs up Semaphore database
- Backs up configuration files
- Stops auto stack
- Prepares chain stack
- Verifies databases
- Optionally starts chain stack
- Provides rollback instructions

## Quick Start

### For New Installations

```bash
# 1. Ensure PostgreSQL is running
./kompose.sh up core

# 2. Create required databases
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"

# 3. Configure secrets in secrets.env (see chain/.env for required vars)

# 4. Start the chain stack
./kompose.sh up chain

# 5. Access services
# n8n: https://${N8N_TRAEFIK_HOST} or http://localhost:5678
# Semaphore: https://${SEMAPHORE_TRAEFIK_HOST} or http://localhost:3000
```

### For Existing Auto Stack Users

```bash
# 1. Make migration script executable
chmod +x migrate-auto-to-chain.sh

# 2. Run migration
./migrate-auto-to-chain.sh

# 3. Follow the prompts
# The script will:
# - Backup your Semaphore database
# - Stop the auto stack
# - Start the chain stack
# - Preserve all your data
```

## Services & Ports

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| n8n | 5678 | 5678 | Workflow automation UI |
| Semaphore | 3000 | 3000 | Ansible automation UI |
| Semaphore Runner | - | - | Task execution worker |

## Required Secrets

Add these to your `secrets.env` file:

```bash
# Database
DB_HOST=core-postgres
DB_USER=kompose
DB_PASSWORD=your_secure_password

# n8n
N8N_ENCRYPTION_KEY=generate_with_openssl_rand_hex_32
N8N_BASIC_AUTH_PASSWORD=your_n8n_password

# Semaphore
SEMAPHORE_ADMIN_PASSWORD=your_semaphore_password
SEMAPHORE_RUNNER_TOKEN=generate_with_openssl_rand_hex_32

# Email (shared)
ADMIN_EMAIL=admin@example.com
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your_email@gmail.com
EMAIL_SMTP_PASSWORD=your_app_password

# Traefik
TRAEFIK_HOST_CHAIN=n8n.yourdomain.com
TRAEFIK_HOST_AUTO=semaphore.yourdomain.com
```

## Integration Use Cases

### 1. Automated Deployments
- n8n workflow triggered by webhook
- n8n calls Semaphore API
- Semaphore executes Ansible playbook
- Ansible deploys to servers

### 2. Scheduled Maintenance
- n8n schedule trigger
- Execute Ansible playbooks via Semaphore
- Send notifications on completion

### 3. Infrastructure as Code
- Git push triggers n8n webhook
- n8n validates changes
- Semaphore applies Ansible configurations
- Results sent to Slack/Email

## Database Management

```bash
# Backup both databases
./kompose.sh db backup -d n8n --compress
./kompose.sh db backup -d semaphore --compress

# List backups
./kompose.sh db list

# Restore
./kompose.sh db restore -f backups/database/semaphore_backup.sql.gz -d semaphore

# Check status
./kompose.sh db status

# Access database shell
./kompose.sh db shell -d semaphore
```

## Verification Commands

```bash
# Check all services are running
./kompose.sh status chain

# View logs
./kompose.sh logs chain -f

# Check specific service
docker logs chain_n8n
docker logs chain_semaphore
docker logs chain_semaphore_runner

# Test n8n health
curl http://localhost:5678/healthz

# Test Semaphore health
curl http://localhost:3000/api/ping

# Check databases
./kompose.sh db status
```

## Rollback Instructions

If you need to rollback to the standalone auto stack:

```bash
# 1. Stop chain stack
./kompose.sh down chain

# 2. Restore auto stack
./kompose.sh up auto

# 3. Restore database if needed
./kompose.sh db restore -f backups/migration/semaphore_TIMESTAMP.sql.gz -d semaphore
```

## Benefits of Integration

1. **Unified Management**: Single stack command manages both services
2. **Shared Infrastructure**: Uses same PostgreSQL, network, monitoring
3. **Better Integration**: Services can communicate directly
4. **Simplified Deployment**: One command to start/stop everything
5. **Resource Efficiency**: Shared network and database connections
6. **Easier Backup**: Single backup command for both services

## Network Architecture

```
┌──────────────────────────────────────┐
│         kompose_network              │
│                                      │
│  ┌──────┐  ┌───────────┐  ┌───────┐│
│  │ n8n  │◄─┤ Semaphore │◄─┤Runner ││
│  └───┬──┘  └─────┬─────┘  └───────┘│
│      │           │                  │
└──────┼───────────┼──────────────────┘
       │           │
       └───────────┴─────┐
                         │
                    ┌────▼────┐
                    │PostgreSQL│
                    │  (core)  │
                    └──────────┘
```

## Next Steps

1. Read the [Integration Guide](chain/INTEGRATION_GUIDE.md)
2. Configure your Ansible playbooks in Semaphore
3. Create n8n workflows to trigger Ansible tasks
4. Set up monitoring and alerting
5. Configure backup schedules

## Support

For issues:
- Check logs: `./kompose.sh logs chain`
- Verify config: `./kompose.sh validate chain`
- Check database: `./kompose.sh db status`
- Review the Integration Guide

## Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Semaphore Documentation](https://docs.semaphoreui.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
