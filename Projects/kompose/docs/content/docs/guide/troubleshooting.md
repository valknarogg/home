---
title: Troubleshooting
description: Common issues and solutions
---

# Troubleshooting

### Common Issues

#### 🚫 404 Error from Traefik

**Problem:** Websites return 404 even though containers are running

**Solution:**
```bash
# Check Traefik logs
docker logs proxy_app

# Verify network configuration
docker network inspect kompose

# Restart proxy and affected stacks
./kompose.sh proxy down && ./kompose.sh proxy up -d
./kompose.sh blog restart
```

**Debug:**
```bash
# Check Traefik dashboard
http://your-server:8080

# Verify container labels
docker inspect blog_app | grep traefik
```

#### 💾 Database Import Fails

**Problem:** `db:import` command fails

**Common causes:**
1. **Active connections** - Solved automatically (kompose terminates connections)
2. **Missing dump file** - Check file path
3. **Insufficient permissions** - Check DB_USER permissions
4. **Wrong database** - Verify DB_NAME in stack `.env`

**Solution:**
```bash
# Check database connectivity
docker exec data_postgres psql -U $DB_USER -l

# Verify dump file exists
ls -lh news/*.sql

# Check logs for detailed error
./kompose.sh news db:import 2>&1 | tee import.log
```

#### 🔌 Container Won't Connect to Network

**Problem:** Container fails to join kompose network

**Solution:**
```bash
# Recreate network
docker network rm kompose
docker network create kompose

# Restart all stacks
./kompose.sh "*" down
./kompose.sh "*" up -d
```

#### 🪝 Hooks Not Executing

**Problem:** Custom hooks aren't running

**Checklist:**
- [ ] `hooks.sh` file exists in stack directory
- [ ] `hooks.sh` is executable: `chmod +x <stack>/hooks.sh`
- [ ] Function names match: `hook_pre_db_export`, etc.
- [ ] Functions return 0 (success) or 1 (failure)

**Test:**
```bash
# Dry-run shows hook execution
./kompose.sh sexy db:export --dry-run

# Check if hooks.sh exists
./kompose.sh --list | grep hooks
```

### Debug Mode

Enable verbose logging:

```bash
# View Traefik debug logs
docker logs -f proxy_app

# Check environment variables
./kompose.sh news ps
docker exec news_backend env

# Inspect running containers
docker ps -a
docker inspect <container_name>
```

### Getting Help

1. **Check logs:** `./kompose.sh <stack> logs`
2. **Use dry-run:** `./kompose.sh --dry-run <pattern> <command>`
3. **List stacks:** `./kompose.sh --list`
4. **Read help:** `./kompose.sh --help`
5. **Open an issue:** [GitHub Issues](https://github.com/yourusername/kompose/issues)
