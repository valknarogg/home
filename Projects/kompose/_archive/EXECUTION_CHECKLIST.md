# 🚀 Execution Checklist - Kompose System Update

## Pre-Flight Checks

Before running the migration scripts, ensure:

- [ ] You have a backup of your entire kompose directory
- [ ] You have read `COMPLETE_UPDATE_SUMMARY.md`
- [ ] All stacks are currently stopped OR you're ready to stop them
- [ ] You have terminal access and can run bash scripts
- [ ] You understand the changes (rename home→core, integrate auto→chain)

## Step-by-Step Execution

### Phase 1: Preparation (5 minutes)

```bash
# 1. Navigate to kompose directory
cd /home/valknar/Projects/kompose

# 2. Create a full backup
tar czf ~/kompose-backup-$(date +%Y%m%d).tar.gz .
echo "Backup created: ~/kompose-backup-$(date +%Y%m%d).tar.gz"

# 3. Check current status
./kompose.sh status
docker ps

# 4. Make scripts executable
chmod +x kompose.sh rename-home-to-core.sh migrate-auto-to-chain.sh
```

**Checkpoint**: ✅ Backup created, scripts are executable

---

### Phase 2: Rename home → core (10 minutes)

```bash
# 1. Run the rename script
./rename-home-to-core.sh

# The script will:
# - Stop home stack if running
# - Backup home directory
# - Update all config files
# - Rename directories
# - Start core stack (if you choose)

# 2. Verify rename success
./kompose.sh status core
docker ps | grep core

# 3. Test PostgreSQL
docker exec core-postgres psql -U kompose -l
```

**Expected Results**:
- ✅ Directory `./core` exists (was `./home`)
- ✅ Container `core-postgres` is running (was `home-postgres`)
- ✅ `./kompose.sh status core` shows services
- ✅ PostgreSQL responds to commands

**If something went wrong**: See rollback section at bottom

---

### Phase 3: Integrate Semaphore into chain (15 minutes)

```bash
# 1. Ensure core stack is running
./kompose.sh status core

# 2. Create databases (if they don't exist)
docker exec core-postgres psql -U kompose -c "CREATE DATABASE n8n;"
docker exec core-postgres psql -U kompose -c "CREATE DATABASE semaphore;"

# 3. Configure secrets.env
nano secrets.env  # Add required secrets (see below)

# 4. Run integration script
./migrate-auto-to-chain.sh

# The script will:
# - Backup Semaphore database
# - Stop auto stack
# - Prepare chain stack
# - Start chain stack (if you choose)

# 5. Verify integration
./kompose.sh status chain
docker ps | grep chain
```

**Expected Results**:
- ✅ Container `chain_n8n` is running
- ✅ Container `chain_semaphore` is running
- ✅ Container `chain_semaphore_runner` is running
- ✅ Auto stack is stopped

**Test endpoints**:
```bash
curl http://localhost:5678/healthz    # n8n
curl http://localhost:3000/api/ping   # Semaphore
```

---

### Phase 4: Verification (5 minutes)

```bash
# 1. Check all stacks
./kompose.sh status

# 2. Verify databases
./kompose.sh db status

# 3. Check logs for errors
./kompose.sh logs core | tail -20
./kompose.sh logs chain | tail -20

# 4. Test database connections
docker exec chain_n8n nc -zv core-postgres 5432
docker exec chain_semaphore nc -zv core-postgres 5432

# 5. List all containers
docker ps --format "table {{.Names}}\t{{.Status}}"
```

**Expected Output**:
```
NAMES                           STATUS
chain_semaphore_runner          Up X minutes
chain_semaphore                 Up X minutes (healthy)
chain_n8n                       Up X minutes (healthy)
core-postgres                   Up X minutes
core_mqtt                       Up X minutes
core_app                        Up X minutes
```

---

### Phase 5: Clean Up (5 minutes)

```bash
# 1. Remove auto stack directory (optional, after verifying everything works)
# rm -rf ./auto  # Keep for reference or remove

# 2. Remove old core directory if renamed (check first!)
# ls -la core-services  # This should be old service configs
# mv core-services old-core-configs  # Keep as backup

# 3. Check for unused containers
docker ps -a | grep -E "home_|auto_"

# 4. Remove old containers if they exist
# docker rm -f <container_name>

# 5. Check for unused volumes
docker volume ls | grep -E "home|auto"
```

---

## 🔍 Detailed Verification Tests

### Test 1: Core Stack (PostgreSQL)

```bash
# Connect to PostgreSQL
docker exec -it core-postgres psql -U kompose

# Run in psql:
\l                          # List databases
\c n8n                      # Connect to n8n
\dt                         # List tables
\c semaphore                # Connect to semaphore
\dt                         # List tables
\q                          # Quit
```

**Expected**: Both n8n and semaphore databases exist with tables

### Test 2: n8n Service

```bash
# Check health
curl -v http://localhost:5678/healthz

# Check UI (if enabled)
open http://localhost:5678   # or visit in browser
```

**Expected**: HTTP 200, n8n login page appears

### Test 3: Semaphore Service

```bash
# Check health
curl -v http://localhost:3000/api/ping

# Check UI
open http://localhost:3000   # or visit in browser
```

**Expected**: HTTP 200, Semaphore login page appears

### Test 4: Service Communication

```bash
# Test n8n can reach Semaphore
docker exec chain_n8n wget -O- http://semaphore:3000/api/ping

# Test Semaphore can reach PostgreSQL
docker exec chain_semaphore nc -zv core-postgres 5432
```

**Expected**: Both commands succeed

---

## 🔑 Required Secrets Configuration

Before Phase 3, ensure `secrets.env` contains:

```bash
# Database (core stack)
DB_HOST=core-postgres
DB_USER=kompose
DB_PASSWORD=<your_secure_password>

# n8n
N8N_ENCRYPTION_KEY=<generate_with: openssl rand -hex 32>
N8N_BASIC_AUTH_PASSWORD=<your_n8n_password>

# Semaphore
SEMAPHORE_ADMIN_PASSWORD=<your_semaphore_password>
SEMAPHORE_RUNNER_TOKEN=<generate_with: openssl rand -hex 32>

# Email (shared by both)
ADMIN_EMAIL=admin@example.com
EMAIL_FROM=noreply@example.com
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=<your_email>
EMAIL_SMTP_PASSWORD=<your_app_password>

# Traefik (if using)
TRAEFIK_HOST_CHAIN=n8n.yourdomain.com
TRAEFIK_HOST_AUTO=semaphore.yourdomain.com
```

Generate encryption keys:
```bash
openssl rand -hex 32   # For N8N_ENCRYPTION_KEY
openssl rand -hex 32   # For SEMAPHORE_RUNNER_TOKEN
```

---

## 🆘 Troubleshooting

### Issue: Rename script fails

**Solution**:
```bash
# Check if home stack is stopped
docker ps | grep home

# Stop manually if needed
cd home && docker-compose down && cd ..

# Try rename again
./rename-home-to-core.sh
```

### Issue: Container name conflicts

**Solution**:
```bash
# Remove old containers
docker rm -f $(docker ps -aq --filter name=home_)
docker rm -f $(docker ps -aq --filter name=auto_)

# Start fresh
./kompose.sh up core
./kompose.sh up chain
```

### Issue: Database connection errors

**Solution**:
```bash
# Verify PostgreSQL is running
docker ps | grep postgres

# Check container name
docker ps --format "{{.Names}}" | grep postgres
# Should show: core-postgres

# Restart if needed
docker restart core-postgres

# Wait 10 seconds, then restart dependent services
sleep 10
./kompose.sh restart chain
```

### Issue: Services can't find each other

**Solution**:
```bash
# Check network
docker network inspect kompose

# Reconnect services to network
docker network connect kompose chain_n8n
docker network connect kompose chain_semaphore

# Restart services
./kompose.sh restart chain
```

---

## 🔄 Rollback Procedures

### Rollback Phase 1 (Undo Rename)

```bash
# Stop core stack
./kompose.sh down core

# Restore from backup
cd ~
tar xzf kompose-backup-*.tar.gz -C /tmp/kompose-restore
cp -r /tmp/kompose-restore/* /home/valknar/Projects/kompose/

# Start home stack
cd /home/valknar/Projects/kompose
./kompose.sh up home
```

### Rollback Phase 2 (Undo Integration)

```bash
# Stop chain stack
./kompose.sh down chain

# Restore Semaphore backup
./kompose.sh db restore -f backups/migration/semaphore_*.sql.gz -d semaphore

# Start separate stacks
./kompose.sh up auto   # If you have the old auto directory
./kompose.sh up chain  # This will be n8n only
```

---

## ✅ Final Checklist

After completing all phases:

- [ ] Core stack running: `./kompose.sh status core`
- [ ] Chain stack running: `./kompose.sh status chain`
- [ ] Auto stack stopped: `docker ps | grep auto` (empty)
- [ ] PostgreSQL accessible: `docker exec core-postgres psql -U kompose -l`
- [ ] n8n accessible: http://localhost:5678
- [ ] Semaphore accessible: http://localhost:3000
- [ ] All databases exist: `./kompose.sh db status`
- [ ] No errors in logs: `./kompose.sh logs chain | grep -i error`
- [ ] Backups created and stored safely
- [ ] Documentation reviewed

---

## 📈 Success Criteria

You've successfully completed the update if:

1. ✅ `./kompose.sh list` shows "core" and "chain" stacks
2. ✅ `docker ps` shows core-postgres, chain_n8n, chain_semaphore, chain_semaphore_runner
3. ✅ Both web UIs are accessible (n8n and Semaphore)
4. ✅ Database backups exist in ./backups/
5. ✅ No home_ or auto_ containers running

---

## 🎉 Congratulations!

If all checkboxes are ticked, you've successfully:
- ✅ Renamed home → core
- ✅ Integrated Semaphore into chain
- ✅ Created a unified automation platform

Next steps:
1. Configure Ansible playbooks in Semaphore
2. Create automation workflows in n8n
3. Set up monitoring
4. Read the integration guide for advanced usage

**Documentation**: See `COMPLETE_UPDATE_SUMMARY.md` for full details.

---

## 📝 Execution Log

Keep track of your progress:

```
Date: ____________
Time Started: ____________

Phase 1 (Preparation): ⬜ Started ⬜ Completed
Phase 2 (Rename): ⬜ Started ⬜ Completed
Phase 3 (Integration): ⬜ Started ⬜ Completed
Phase 4 (Verification): ⬜ Started ⬜ Completed
Phase 5 (Clean Up): ⬜ Started ⬜ Completed

Issues Encountered: 
_________________________________________________
_________________________________________________

Resolution:
_________________________________________________
_________________________________________________

Time Completed: ____________
Total Duration: ____________
```
