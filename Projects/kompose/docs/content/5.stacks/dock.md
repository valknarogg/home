---
title: Dock - Docker Compose Command Center
description: "Making Docker Compose actually fun since 2023"
navigation:
  icon: i-lucide-ship-wheel
---

> *"Making Docker Compose actually fun since 2023"* - Dockge

## What's This All About?

Dockge (pronounced "dog-ee" 🐕) is a fancy, self-hosted web UI for managing Docker Compose stacks. Think of it as Portainer's cooler younger sibling who actually understands what a compose file is! It's perfect for when you want to deploy, update, or manage containers without touching the command line (but let's be honest, you'll still use CLI because you're cool like that).

## The Stack Captain

### :icon{name="lucide:ethernet-port"} Dockge

**Container**: `dock_app`  
**Image**: `louislam/dockge:1`  
**Port**: 5001  
**Home**: http://localhost:5001

Dockge makes Docker Compose management feel like playing with LEGO:
- :icon{name="lucide:clipboard"} **Visual Stack Management**: See all your compose stacks at a glance
- :icon{name="lucide:pen"} **Built-in Editor**: Edit compose files right in the browser
- :icon{name="lucide:rocket"} **One-Click Deploy**: Start, stop, restart with a button
- :icon{name="lucide:bar-chart"} **Real-time Logs**: Watch your containers do their thing
- :icon{name="lucide:file-text"} **Compose File Preview**: See what you're deploying before you deploy it
- :icon{name="lucide:palette"} **Clean Interface**: No cluttered UI, just what you need
- :icon{name="lucide:refresh-cw"} **Update Tracking**: Know when your stacks have changes

## How It Works

```
You (Browser)
    ↓
Dockge UI (localhost:5001)
    ↓
Docker Socket
    ↓
Your Compose Stacks
```

Dockge talks directly to Docker via the socket - it's like having a conversation with Docker in its native language!

## Configuration Breakdown

### Docker Socket Access
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```
This gives Dockge the power to manage Docker. **With great power comes great responsibility!**

### Stacks Directory
```yaml
volumes:
  - /root/repos/compose:/root/repos/compose
```
This is where Dockge looks for your compose files. All the `kompose` stacks should be here!

**Important**: Make sure this path exists on your host:
```bash
mkdir -p /root/repos/compose
```

## First Time Setup :icon{name="lucide:rocket"}

1. **Ensure stacks directory exists**:
   ```bash
   mkdir -p /root/repos/compose
   ```

2. **Start Dockge**:
   ```bash
   docker compose up -d
   ```

3. **Access the UI**:
   ```
   URL: http://localhost:5001
   ```

4. **Create your first user**:
   - First visitor gets to create the admin account
   - Choose a strong password
   - You're in! :icon{name="lucide:party-popper"}

## Using Dockge Like a Pro

### Deploying a New Stack

1. **Click "+ Compose"**
2. **Give it a name** (e.g., "my-cool-app")
3. **Write your compose file** (or paste it):
   ```yaml
   name: my-cool-app
   services:
     web:
       image: nginx:latest
       ports:
         - 8080:80
   ```
4. **Click "Deploy"**
5. **Watch it go!** :icon{name="lucide:rocket"}

### Managing Existing Stacks

From the dashboard, you can:
- :icon{name="lucide:play"} **Start**: Fire up all containers
- :icon{name="lucide:pause"} **Stop**: Gracefully stop everything
- :icon{name="lucide:refresh-cw"} **Restart**: Quick bounce
- :icon{name="lucide:file-text"} **Edit**: Change the compose file
- :icon{name="lucide:wrench"} **Update**: Pull new images and redeploy
- :icon{name="lucide:trash"} **Delete**: Remove stack completely

### Viewing Logs

1. Click on a stack
2. Navigate to "Logs" tab
3. Watch logs in real-time
4. Filter by service if you have multiple containers

### Editing Compose Files

1. Click on a stack
2. Click "Edit"
3. Modify the YAML
4. Click "Save"
5. Click "Update" to apply changes

## Environment Variables

Dockge reads `.env` files from the stack directory. Structure your stacks like:
```
/root/repos/compose/
├── my-app/
│   ├── compose.yaml
│   └── .env
├── another-app/
│   ├── compose.yaml
│   └── .env
```

## Integration with Kompose Stacks

If your kompose stacks are at `/home/valknar/Projects/kompose`, either:

### Option A: Symlink
```bash
ln -s /home/valknar/Projects/kompose /root/repos/compose/kompose
```

### Option B: Update the env variable
```bash
# In .env file
DOCKGE_STACKS_DIR=/home/valknar/Projects/kompose
```

Then restart Dockge:
```bash
docker compose down && docker compose up -d
```

## Features You'll Love :icon{name="lucide:heart"}

### Terminal Access
Click "Terminal" to get a shell in any container - no `docker exec` needed!

### Network Visualization
See which containers are talking to each other (visual network graph coming soon™).

### Resource Monitoring
Check CPU, memory, and network usage at a glance.

### Compose File Validation
Dockge tells you if your YAML is broken before you try to deploy.

### Multi-Stack Actions
Select multiple stacks and start/stop them all at once.

## Ports & Networking

- **Web UI**: 5001 (exposed directly, Traefik labels commented out)
- **Network**: `kompose` (sees all your other containers)
- **Docker Socket**: Full access (read + write)

## Security Considerations :icon{name="lucide:lock"}

### :icon{name="lucide:alert-triangle"} Important Security Notes

1. **No Built-in Auth Beyond First User**: After creating admin, there's basic auth
2. **Docker Socket Access**: Dockge can do ANYTHING Docker can
3. **Exposed Port**: Currently accessible to anyone who can reach port 5001
4. **Network Access**: Can see and manage all Docker resources

### Securing Dockge

**Option 1: Enable Traefik (Recommended)**
Uncomment the Traefik labels in `compose.yaml` and access via HTTPS with Let's Encrypt.

**Option 2: Firewall Rules**
```bash
# Only allow from specific IP
ufw allow from 192.168.1.100 to any port 5001
```

**Option 3: VPN Only**
Only access Dockge when connected to your VPN.

## Common Tasks

### Import Existing Stacks

If you already have compose files:
1. Copy them to your stacks directory
2. Refresh Dockge
3. They appear automatically!

### Update All Stacks

1. Select all stacks (checkbox)
2. Click "Pull"
3. Wait for images to download
4. Click "Update" on each stack

### Backup Configurations

```bash
# Backup entire stacks directory
tar -czf dockge-backup-$(date +%Y%m%d).tar.gz /root/repos/compose/
```

### View Container Stats

Each stack shows:
- Memory usage
- CPU percentage  
- Network I/O
- Container status

## Troubleshooting

**Q: Dockge can't see my stacks?**  
A: Check the `DOCKGE_STACKS_DIR` path is correct and Docker socket is mounted

**Q: Can't start a container?**  
A: Check the logs tab for error messages - usually port conflicts or missing images

**Q: Changes not applying?**  
A: Click "Update" after editing - "Save" only saves the file

**Q: UI is slow?**  
A: Check Docker socket performance, might have many containers

**Q: Lost admin password?**  
A: Delete the Dockge volume and start fresh (you'll lose user accounts)

## Advanced Tips :icon{name="lucide:lightbulb"}

### Custom Network Configuration

Dockge respects network definitions in your compose files:
```yaml
networks:
  my_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.25.0.0/16
```

### Health Checks

Add health checks to your services:
```yaml
services:
  web:
    image: nginx
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 3s
      retries: 3
```

Dockge will show health status in the UI!

### Depends On

Use service dependencies:
```yaml
services:
  web:
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres
    healthcheck:
      test: ["CMD", "pg_isready"]
```

## Dockge vs. Alternatives

| Feature | Dockge | Portainer | Docker CLI |
|---------|--------|-----------|------------|
| Compose-First | ✅ | ❌ | ✅ |
| Lightweight | ✅ | ❌ | ✅ |
| Built-in Editor | ✅ | Limited | ❌ |
| Learning Curve | Easy | Medium | Hard |
| Visual Appeal | ✅ | ✅ | 😢 |

## Why Choose Dockge?

- :icon{name="lucide:target"} **Compose-Native**: Built specifically for docker-compose
- :icon{name="lucide:feather"} **Lightweight**: Tiny footprint, fast UI
- :icon{name="lucide:palette"} **Beautiful**: Clean, modern interface
- :icon{name="lucide:wrench"} **Simple**: Does one thing really well
- :icon{name="lucide:smile"} **Free**: Open source, no enterprise upsells
- :icon{name="lucide:laptop"} **Dev-Friendly**: Doesn't hide the compose file from you

## Integration Ideas

### With CI/CD

Deploy from GitLab/GitHub → Dockge picks up changes:
```yaml
# .gitlab-ci.yml
deploy:
  script:
    - scp compose.yaml server:/root/repos/compose/my-app/
    - curl -X POST http://localhost:5001/api/stack/my-app/update
```

### With Monitoring

Dockge + Grafana + Prometheus = :icon{name="lucide:bar-chart"} Beautiful dashboards

### With Backup Tools

Automated backups of your compose files:
```bash
# Cron job
0 2 * * * tar -czf /backups/dockge-$(date +\%Y\%m\%d).tar.gz /root/repos/compose/
```

## Resources

- [Dockge GitHub](https://github.com/louislam/dockge)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [YAML Syntax](https://yaml.org/)

---

*"The best UI is the one that gets out of your way and lets you work."* - Dockge Philosophy :icon{name="lucide:sparkles"}
