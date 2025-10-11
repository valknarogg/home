# Chain Stack - Quick Reference Card

## 🚀 Quick Start

```bash
# Make scripts executable
chmod +x kompose.sh migrate-auto-to-chain.sh

# Start prerequisites
./kompose.sh up core

# Create databases
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"

# Start chain stack
./kompose.sh up chain
```

## 📊 Stack Overview

**Chain Stack** = n8n + Semaphore + Semaphore Runner

| Component | Port | Purpose |
|-----------|------|---------|
| n8n | 5678 | Workflow automation |
| Semaphore | 3000 | Ansible UI |
| Semaphore Runner | - | Task executor |

## 🔧 Common Commands

```bash
# Stack Management
./kompose.sh up chain          # Start
./kompose.sh down chain        # Stop
./kompose.sh restart chain     # Restart
./kompose.sh status chain      # Status
./kompose.sh logs chain -f     # Logs

# Database Operations
./kompose.sh db backup -d n8n --compress
./kompose.sh db backup -d semaphore --compress
./kompose.sh db list
./kompose.sh db status

# Service Specific
docker logs chain_n8n
docker logs chain_semaphore
docker logs chain_semaphore_runner
```

## 🔑 Required Secrets

Add to `secrets.env`:

```bash
# Core
DB_HOST=core-postgres
DB_USER=kompose
DB_PASSWORD=***

# n8n
N8N_ENCRYPTION_KEY=***
N8N_BASIC_AUTH_PASSWORD=***

# Semaphore  
SEMAPHORE_ADMIN_PASSWORD=***
SEMAPHORE_RUNNER_TOKEN=***

# Email
EMAIL_SMTP_HOST=***
EMAIL_SMTP_USER=***
EMAIL_SMTP_PASSWORD=***
```

## 🔄 Migration from Auto Stack

```bash
# Run automated migration
./migrate-auto-to-chain.sh

# Or manually
./kompose.sh db backup -d semaphore --compress
./kompose.sh down auto
./kompose.sh up chain
```

## 🌐 Access URLs

```bash
# Local
n8n:       http://localhost:5678
Semaphore: http://localhost:3000

# Production (via Traefik)
n8n:       https://${N8N_TRAEFIK_HOST}
Semaphore: https://${SEMAPHORE_TRAEFIK_HOST}
```

## 🔗 Integration Example

### n8n → Semaphore API Call

```javascript
// HTTP Request Node in n8n
Method: POST
URL: http://semaphore:3000/api/project/{id}/tasks
Headers: 
  Authorization: Bearer {YOUR_API_TOKEN}
Body:
{
  "template_id": 1,
  "environment": "{}",
  "debug": false
}
```

## 📁 Key Files

```
chain/
├── compose.yaml           # Main stack definition
├── .env                   # Configuration
├── INTEGRATION_GUIDE.md   # Full documentation
└── docker-compose.yml     # Legacy (if exists)
```

## 🆘 Troubleshooting

```bash
# Service won't start
./kompose.sh validate chain
docker-compose -f chain/compose.yaml config

# Database issues
./kompose.sh db status
docker logs core-postgres

# Runner not connecting
docker exec chain_semaphore_runner env | grep SEMAPHORE
docker logs chain_semaphore_runner

# Check health
curl http://localhost:5678/healthz
curl http://localhost:3000/api/ping
```

## 📚 Documentation

- **Full Guide**: `chain/INTEGRATION_GUIDE.md`
- **Summary**: `CHAIN_INTEGRATION_SUMMARY.md`
- **Main Help**: `./kompose.sh help`

## ⚡ Pro Tips

1. Always backup before changes: `./kompose.sh db backup -d semaphore`
2. Use `--compress` for smaller backups
3. Check logs with `-f` to follow in real-time
4. Use `db shell` to inspect database directly
5. Validate compose files before deploying

## 🔐 Security Checklist

- [ ] Change default passwords
- [ ] Generate strong encryption keys
- [ ] Enable HTTPS in production
- [ ] Configure firewall rules
- [ ] Set up regular backups
- [ ] Update images regularly

## 🎯 Quick Checks

```bash
# Everything running?
./kompose.sh status chain

# Services healthy?
docker ps --filter name=chain --format "table {{.Names}}\t{{.Status}}"

# Databases accessible?
./kompose.sh db exec -d n8n "SELECT count(*) FROM pg_catalog.pg_tables;"

# Disk space?
docker system df
```

---

**Need Help?** Check the Integration Guide for detailed information.
