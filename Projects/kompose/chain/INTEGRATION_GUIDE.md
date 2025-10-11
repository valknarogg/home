# Chain Stack Integration Guide

## Overview

The **chain** stack has been expanded to include both n8n and Semaphore, creating a comprehensive automation platform:

- **n8n**: Workflow automation engine for creating complex automation workflows
- **Semaphore**: Ansible UI and task runner for infrastructure automation
- **Integration**: n8n can trigger Ansible playbooks via Semaphore's API

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Chain Stack                         │
│                                                  │
│  ┌────────────┐         ┌──────────────────┐   │
│  │    n8n     │         │    Semaphore     │   │
│  │            │◄───────►│                  │   │
│  │ Workflows  │  API    │  Ansible Tasks   │   │
│  └─────┬──────┘         └────────┬─────────┘   │
│        │                         │              │
│        │    ┌────────────────┐   │              │
│        │    │   Semaphore    │   │              │
│        │    │     Runner     │◄──┘              │
│        │    │                │                  │
│        │    └────────────────┘                  │
│        │                                        │
└────────┼────────────────────────────────────────┘
         │
         ▼
   ┌────────────┐
   │ PostgreSQL │
   │  (core)    │
   └────────────┘
```

## Services

### n8n (Port 5678)
- **Purpose**: Visual workflow automation
- **Database**: `n8n` in PostgreSQL
- **URL**: https://${N8N_TRAEFIK_HOST}
- **Access**: Basic Auth (username/password)

### Semaphore (Port 3000)
- **Purpose**: Ansible automation UI
- **Database**: `semaphore` in PostgreSQL
- **URL**: https://${SEMAPHORE_TRAEFIK_HOST}
- **Access**: Username/password login

### Semaphore Runner
- **Purpose**: Execute Ansible tasks
- **Connection**: Connects to Semaphore API
- **Registration**: Uses JWT token authentication

## Setup Instructions

### 1. Ensure Prerequisites

Make sure the `core` stack is running (for PostgreSQL):

```bash
./kompose.sh up core
```

### 2. Create Databases

Create the required databases:

```bash
# Create n8n database
./kompose.sh db exec -d postgres "CREATE DATABASE n8n;"

# Create semaphore database
./kompose.sh db exec -d postgres "CREATE DATABASE semaphore;"
```

Or use the database management commands:

```bash
./kompose.sh db migrate -d n8n
./kompose.sh db migrate -d semaphore
```

### 3. Configure Environment

Ensure your `secrets.env` file contains:

```bash
# Database connection
DB_HOST=core-postgres
DB_USER=kompose
DB_PASSWORD=your_secure_password

# n8n Configuration
N8N_ENCRYPTION_KEY=your_32_char_encryption_key
N8N_BASIC_AUTH_PASSWORD=your_n8n_password

# Semaphore Configuration
SEMAPHORE_ADMIN_PASSWORD=your_semaphore_password
SEMAPHORE_RUNNER_TOKEN=your_jwt_token

# Email Configuration
ADMIN_EMAIL=admin@example.com
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your_email@gmail.com
EMAIL_SMTP_PASSWORD=your_app_password

# Traefik Hosts
TRAEFIK_HOST_CHAIN=n8n.yourdomain.com
TRAEFIK_HOST_AUTO=semaphore.yourdomain.com
```

### 4. Start the Chain Stack

```bash
./kompose.sh up chain
```

### 5. Verify Services

```bash
# Check status
./kompose.sh status chain

# View logs
./kompose.sh logs chain -f

# Check specific service
docker logs chain_n8n
docker logs chain_semaphore
docker logs chain_semaphore_runner
```

## Usage Examples

### Managing the Stack

```bash
# Start the stack
./kompose.sh up chain

# Stop the stack
./kompose.sh down chain

# Restart a specific service
docker-compose -f chain/compose.yaml restart n8n

# View logs
./kompose.sh logs chain -f

# Execute command in n8n
./kompose.sh exec chain n8n n8n --version

# Access database
./kompose.sh db shell -d n8n
./kompose.sh db shell -d semaphore
```

### Backup & Restore

```bash
# Backup both databases
./kompose.sh db backup -d n8n --compress
./kompose.sh db backup -d semaphore --compress

# List backups
./kompose.sh db list

# Restore from backup
./kompose.sh db restore -f backups/database/n8n_20241011_123456.sql.gz
```

### Integrating n8n with Semaphore

1. **In Semaphore**: Create a project, add your Ansible playbooks
2. **In Semaphore**: Generate an API token (User Settings → API Tokens)
3. **In n8n**: Create a new workflow
4. **In n8n**: Add an HTTP Request node:
   - Method: POST
   - URL: `http://semaphore:3000/api/project/{project_id}/tasks`
   - Authentication: Header Auth
   - Header Name: `Authorization`
   - Header Value: `Bearer YOUR_API_TOKEN`
   - Body: JSON with task parameters

Example n8n HTTP Request payload:
```json
{
  "template_id": 1,
  "environment": "{}",
  "debug": false,
  "dry_run": false
}
```

## Migrating from Standalone Auto Stack

If you previously had the `auto` stack running separately:

### Option 1: Fresh Start (Recommended)

```bash
# 1. Backup Semaphore database
./kompose.sh db backup -d semaphore --compress

# 2. Stop and remove auto stack
./kompose.sh down auto -f

# 3. Start chain stack (includes Semaphore)
./kompose.sh up chain

# 4. Restore Semaphore data if needed
./kompose.sh db restore -f backups/database/semaphore_backup.sql.gz -d semaphore
```

### Option 2: Database Migration

```bash
# 1. Export from auto stack
docker exec auto_app pg_dump -U kompose semaphore > semaphore_export.sql

# 2. Stop auto stack
./kompose.sh down auto

# 3. Start chain stack
./kompose.sh up chain

# 4. Import into chain stack
cat semaphore_export.sql | docker exec -i chain_semaphore psql -U kompose semaphore
```

## Troubleshooting

### Semaphore Runner Not Connecting

```bash
# Check runner logs
docker logs chain_semaphore_runner

# Verify token is set correctly
docker exec chain_semaphore_runner env | grep SEMAPHORE

# Regenerate runner key
docker exec chain_semaphore rm -f /var/lib/semaphore/runner.key
docker-compose -f chain/compose.yaml restart semaphore-runner
```

### n8n Database Connection Issues

```bash
# Check database connectivity
docker exec chain_n8n wget -O- http://core-postgres:5432

# Verify database exists
./kompose.sh db exec -d postgres "\l" | grep n8n

# Check n8n logs
docker logs chain_n8n
```

### Service Not Starting

```bash
# Check healthcheck status
docker inspect chain_n8n | grep -A 10 Health

# View compose config
docker-compose -f chain/compose.yaml config

# Validate compose file
./kompose.sh validate chain
```

## API Endpoints

### n8n
- Health: `http://localhost:5678/healthz`
- API: `http://localhost:5678/api/v1/`
- Webhooks: `http://localhost:5678/webhook/`

### Semaphore
- Health: `http://localhost:3000/api/ping`
- API: `http://localhost:3000/api/`
- Tasks: `http://localhost:3000/api/project/{id}/tasks`

## Database Schema

Both services automatically handle their database migrations on startup.

To manually check database status:

```bash
# n8n tables
./kompose.sh db exec -d n8n "\dt"

# Semaphore tables
./kompose.sh db exec -d semaphore "\dt"
```

## Security Notes

1. **Change default passwords** in `secrets.env`
2. **Use strong encryption keys** (generate with `openssl rand -hex 32`)
3. **Enable HTTPS** via Traefik for production
4. **Restrict network access** to trusted sources only
5. **Regular backups** of both databases
6. **Keep images updated** regularly

## Performance Tuning

### Resource Limits

Add to `compose.yaml` if needed:

```yaml
services:
  n8n:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### Database Optimization

```bash
# Analyze database performance
./kompose.sh db exec -d n8n "SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC LIMIT 10;"
```

## Next Steps

1. **Configure Ansible playbooks** in Semaphore
2. **Create n8n workflows** to trigger deployments
3. **Set up monitoring** for both services
4. **Configure email notifications** for task results
5. **Implement CI/CD pipelines** using n8n + Semaphore

## Support

For issues or questions:
- Check service logs: `./kompose.sh logs chain`
- Review database status: `./kompose.sh db status`
- Validate configuration: `./kompose.sh validate chain`

## References

- [n8n Documentation](https://docs.n8n.io/)
- [Semaphore Documentation](https://docs.semaphoreui.com/)
- [Ansible Documentation](https://docs.ansible.com/)
