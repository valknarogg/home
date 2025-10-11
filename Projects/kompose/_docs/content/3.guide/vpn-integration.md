---
title: VPN Integration Guide
description: Integrate VPN with your entire kompose infrastructure for secure private intranet access
---


## Overview

This guide shows you how to integrate the VPN stack with your entire kompose infrastructure to create a secure private intranet. You'll learn how to access all services remotely, set up service discovery, and implement security best practices.

## Architecture Overview

### Complete Network Topology

```
┌─────────────────────────────────────────────────────────────┐
│                      Internet                                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ UDP:51820
                         │
                ┌────────▼────────┐
                │  WireGuard VPN  │
                │   10.42.42.42   │
                └────────┬────────┘
                         │
            ┌────────────┴────────────┐
            │   kompose network       │
            │   10.42.42.0/24        │
            └────────────┬────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
    │  Core   │    │  Chain  │    │  Other  │
    │Services │    │ Automation│  │ Services│
    └─────────┘    └─────────┘    └─────────┘
         │               │               │
    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
    │Postgres │    │   n8n   │    │  Vault  │
    │  Redis  │    │Semaphore│    │  Chat   │
    │  MQTT   │    │         │    │  Code   │
    └─────────┘    └─────────┘    └─────────┘
```

### Client Connection Flow

```
1. VPN Client (10.42.0.x)
   ↓
2. VPN Gateway (10.42.42.42)
   ↓
3. kompose Network (10.42.42.0/24)
   ↓
4. Target Service (e.g., core-postgres, chain_n8n)
   ↓
5. Response back through VPN
```

## Initial Setup

### 1. Verify Core Infrastructure

Before setting up VPN access, ensure all services are running:

```bash
# Start core services first
./kompose.sh up core

# Start application stacks
./kompose.sh up chain
./kompose.sh up vault
./kompose.sh up chat

# Verify all running
./kompose.sh ps

# Check kompose network
docker network inspect kompose
```

### 2. Configure VPN Stack

```bash
# Navigate to VPN directory
cd vpn

# Configure environment
cat > .env << EOF
COMPOSE_PROJECT_NAME=vpn
DOCKER_IMAGE=ghcr.io/wg-easy/wg-easy:15
TRAEFIK_ENABLED=true
TRAEFIK_HOST=vpn.pivoine.art
APP_PORT=51821
WG_PORT=51820
WG_HOST=YOUR_PUBLIC_IP_OR_DOMAIN
PASSWORD_HASH=GENERATE_THIS
WG_DEFAULT_DNS=1.1.1.1
WG_ALLOWED_IPS=10.42.42.0/24,0.0.0.0/0
LANG=en
UI_TRAFFIC_STATS=true
UI_CHART_TYPE=0
EOF

# Generate password hash
docker run --rm ghcr.io/wg-easy/wg-easy wgpw YOUR_STRONG_PASSWORD
# Copy output to PASSWORD_HASH in .env

# Start VPN
cd ..
./kompose.sh up vpn
```

### 3. Configure Router/Firewall

Forward UDP port 51820 to your server:

```bash
# Example router configuration:
External Port: 51820 (UDP)
Internal IP: YOUR_SERVER_IP
Internal Port: 51820 (UDP)
Protocol: UDP

# Verify port is open
# From external network:
nc -z -v -u YOUR_PUBLIC_IP 51820
```

### 4. Create First VPN Client

```bash
# Access Web UI
open https://vpn.pivoine.art

# Or direct access:
open http://YOUR_SERVER_IP:51821

# Create admin client
# Click "+" → Name: "admin-laptop" → Download config
```

## Service Integration

### Core Services Access

#### PostgreSQL Database

**Access from VPN Client:**

```bash
# Using container name (recommended)
psql -h core-postgres -U valknar -d kompose

# Using direct IP
psql -h 10.42.42.X -U valknar -d kompose

# From application code
DATABASE_URL=postgresql://valknar:password@core-postgres:5432/kompose
```

**Example: pgAdmin Connection**

```yaml
Host: core-postgres
Port: 5432
Username: valknar
Password: your_password
Database: kompose
```

**Database Operations via VPN:**

```bash
# List all databases
psql -h core-postgres -U valknar -l

# Backup database remotely
pg_dump -h core-postgres -U valknar -d n8n > n8n_backup.sql

# Restore database remotely
psql -h core-postgres -U valknar -d n8n < n8n_backup.sql

# Run query
psql -h core-postgres -U valknar -d kompose -c "SELECT * FROM users;"
```

#### Redis Cache

**Access from VPN Client:**

```bash
# Using redis-cli
redis-cli -h core-redis -a YOUR_REDIS_PASSWORD

# Test connection
redis-cli -h core-redis -a YOUR_REDIS_PASSWORD PING

# Get all keys
redis-cli -h core-redis -a YOUR_REDIS_PASSWORD KEYS '*'

# Monitor commands
redis-cli -h core-redis -a YOUR_REDIS_PASSWORD MONITOR
```

**Example: Redis GUI (RedisInsight)**

```yaml
Host: core-redis
Port: 6379
Password: your_redis_password
```

**Redis Operations via VPN:**

```bash
# Set value
redis-cli -h core-redis -a PASSWORD SET mykey "myvalue"

# Get value
redis-cli -h core-redis -a PASSWORD GET mykey

# List databases
redis-cli -h core-redis -a PASSWORD INFO keyspace

# Flush database (careful!)
redis-cli -h core-redis -a PASSWORD FLUSHDB
```

#### MQTT Broker

**Access from VPN Client:**

```bash
# Subscribe to topic
mosquitto_sub -h core-mqtt -t 'sensors/#' -v

# Publish message
mosquitto_pub -h core-mqtt -t 'sensors/temperature' -m '22.5'

# Subscribe to all topics
mosquitto_sub -h core-mqtt -t '#' -v
```

**Example: MQTT.fx Configuration**

```yaml
Broker Address: core-mqtt
Broker Port: 1883
Client ID: vpn-client-1
```

**MQTT Integration:**

```python
# Python example
import paho.mqtt.client as mqtt

def on_connect(client, userdata, flags, rc):
    print("Connected!")
    client.subscribe("sensors/#")

def on_message(client, userdata, msg):
    print(f"{msg.topic}: {msg.payload.decode()}")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("core-mqtt", 1883, 60)
client.loop_forever()
```

### Chain Stack (Automation) Access

#### n8n Workflows

**Web Access:**

```bash
# Via Traefik (HTTPS)
https://chain.pivoine.art

# Direct access (HTTP)
http://chain_n8n:5678
http://10.42.42.X:5678
```

**API Access:**

```bash
# Get workflows
curl -H "X-N8N-API-KEY: your_api_key" \
  http://chain_n8n:5678/api/v1/workflows

# Execute workflow
curl -X POST \
  -H "X-N8N-API-KEY: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{"data": "test"}' \
  http://chain_n8n:5678/webhook/my-webhook
```

**Integration Example:**

```javascript
// Trigger n8n workflow from external app via VPN
const axios = require('axios');

async function triggerWorkflow(data) {
  const response = await axios.post(
    'http://chain_n8n:5678/webhook/deployment',
    data,
    {
      headers: {
        'Content-Type': 'application/json'
      }
    }
  );
  return response.data;
}

// Usage
triggerWorkflow({
  service: 'frontend',
  version: '1.0.0',
  environment: 'production'
});
```

#### Semaphore (Ansible)

**Web Access:**

```bash
# Via Traefik
https://chain.pivoine.art/semaphore

# Direct access
http://chain_semaphore:3000
```

**API Usage:**

```bash
# List projects
curl -u admin:password \
  http://chain_semaphore:3000/api/projects

# Run playbook
curl -X POST \
  -u admin:password \
  -H "Content-Type: application/json" \
  -d '{"template_id": 1}' \
  http://chain_semaphore:3000/api/project/1/tasks
```

### Vault Stack (Password Manager)

**Access Vaultwarden:**

```bash
# Via Traefik (recommended)
https://vault.pivoine.art

# Direct access
http://vault_vaultwarden:80
```

**Mobile Access:**

```bash
# 1. Connect to VPN on mobile
# 2. Open Bitwarden app
# 3. Settings → Self-hosted
# 4. Server URL: https://vault.pivoine.art
# 5. Log in
```

**CLI Access:**

```bash
# Install bw CLI
npm install -g @bitwarden/cli

# Login
bw config server https://vault.pivoine.art
bw login

# Sync
bw sync

# Get password
bw get password "my-account"
```

### Chat Stack (Notifications)

**Gotify Access:**

```bash
# Web UI
https://chat.pivoine.art

# Direct access
http://chat_gotify:80
```

**Send Notification via VPN:**

```bash
# Create app and get token from Web UI
# Send notification
curl -X POST \
  -F "title=Deployment Complete" \
  -F "message=Application deployed successfully" \
  -F "priority=5" \
  "http://chat_gotify:80/message?token=YOUR_APP_TOKEN"
```

**Integration with Scripts:**

```bash
#!/bin/bash
# deploy.sh - Send Gotify notification after deployment

GOTIFY_URL="http://chat_gotify:80"
GOTIFY_TOKEN="your_app_token"

send_notification() {
  local title="$1"
  local message="$2"
  local priority="${3:-5}"
  
  curl -X POST \
    -F "title=$title" \
    -F "message=$message" \
    -F "priority=$priority" \
    "${GOTIFY_URL}/message?token=${GOTIFY_TOKEN}"
}

# Usage
./deploy.sh
send_notification "Deployment" "App deployed successfully!"
```

## Advanced Integration Patterns

### Pattern 1: Remote Development Environment

Access your entire development stack from anywhere:

```bash
# 1. Connect to VPN

# 2. Access database
psql -h core-postgres -U valknar -d dev

# 3. Access Redis
redis-cli -h core-redis

# 4. Monitor MQTT
mosquitto_sub -h core-mqtt -t 'dev/#'

# 5. Access n8n for workflow testing
open http://chain_n8n:5678

# 6. SSH to development server (if exposed)
ssh user@dev-server.kompose.local
```

### Pattern 2: Automated Deployment Pipeline

Create deployment pipeline accessible via VPN:

```yaml
# n8n workflow: Deployment Pipeline
# Trigger: Webhook from Git push
# Access: http://chain_n8n:5678/webhook/deploy

Workflow:
  1. Receive deployment request
  2. Trigger Semaphore playbook
  3. Update database schema (via core-postgres)
  4. Clear Redis cache (via core-redis)
  5. Send Gotify notification (via chat_gotify)
  6. Log to database
```

**Implementation:**

```bash
# Trigger deployment from laptop via VPN
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "service": "frontend",
    "version": "1.2.0",
    "environment": "staging"
  }' \
  http://chain_n8n:5678/webhook/deploy
```

### Pattern 3: Monitoring & Alerting

Set up remote monitoring:

```bash
# 1. Monitor database health
psql -h core-postgres -U valknar -c "
  SELECT 
    datname,
    pg_size_pretty(pg_database_size(datname)) as size,
    numbackends as connections
  FROM pg_stat_database;"

# 2. Check Redis memory
redis-cli -h core-redis INFO memory

# 3. Monitor MQTT topics
mosquitto_sub -h core-mqtt -t '$SYS/#'

# 4. Check service health
for service in core-postgres core-redis core-mqtt; do
  echo "Checking $service..."
  docker exec $service echo "OK" || echo "FAILED"
done
```

### Pattern 4: IoT Device Integration

Connect IoT devices to private network:

```yaml
# IoT Sensor Configuration
WiFi:
  SSID: "Your Network"
  
VPN:
  Enabled: true
  Config: "iot-sensor-01.conf"  # Downloaded from wg-easy
  
MQTT:
  Broker: core-mqtt
  Port: 1883
  Topics:
    Publish: sensors/temperature
    Subscribe: commands/sensor-01
```

**Example: Temperature Sensor**

```python
import time
import paho.mqtt.client as mqtt

# Connect to MQTT via VPN
client = mqtt.Client("temp-sensor-01")
client.connect("core-mqtt", 1883)

# Publish temperature every 60 seconds
while True:
    temp = read_temperature()
    client.publish("sensors/temp-01", f"{temp:.1f}")
    time.sleep(60)
```

### Pattern 5: Team Collaboration

Set up access for team members:

```yaml
Team Setup:
  Developers:
    - Client: "dev-john-laptop"
    - Access: All services
    - AllowedIPs: 10.42.42.0/24
    
  DevOps:
    - Client: "devops-jane-laptop"  
    - Access: All services + admin
    - AllowedIPs: 10.42.42.0/24, 0.0.0.0/0
    
  QA Team:
    - Client: "qa-team-shared"
    - Access: Read-only services
    - AllowedIPs: 10.42.42.0/24
    
  Mobile Testing:
    - Client: "qa-phone-01"
    - Access: Frontend only
    - AllowedIPs: Specific IPs
```

## DNS Configuration

### Option 1: Hosts File (Simple)

**Client-side configuration:**

```bash
# On VPN client, edit hosts file

# Linux/Mac: /etc/hosts
# Windows: C:\Windows\System32\drivers\etc\hosts

# Add entries:
10.42.42.X core-postgres
10.42.42.X core-redis
10.42.42.X core-mqtt
10.42.42.X chain_n8n
10.42.42.X chain_semaphore
10.42.42.X vault_vaultwarden
10.42.42.X chat_gotify

# Now you can use friendly names:
psql -h core-postgres
redis-cli -h core-redis
```

### Option 2: Internal DNS Server (Advanced)

**Set up CoreDNS in kompose:**

```yaml
# Add to core/compose.yaml
services:
  dns:
    image: coredns/coredns:latest
    container_name: core-dns
    restart: unless-stopped
    volumes:
      - ./dns/Corefile:/Corefile:ro
      - ./dns/hosts:/etc/coredns/hosts:ro
    networks:
      kompose_network:
        ipv4_address: 10.42.42.53
    ports:
      - "53:53/udp"
      - "53:53/tcp"
```

**Create Corefile:**

```bash
# core/dns/Corefile
.:53 {
    hosts /etc/coredns/hosts {
        fallthrough
    }
    forward . 1.1.1.1 8.8.8.8
    log
    errors
}
```

**Create hosts file:**

```bash
# core/dns/hosts
10.42.42.2  core-postgres postgres.kompose.local
10.42.42.3  core-redis redis.kompose.local
10.42.42.4  core-mqtt mqtt.kompose.local
10.42.42.10 chain_n8n n8n.kompose.local
10.42.42.11 chain_semaphore semaphore.kompose.local
10.42.42.20 vault_vaultwarden vault.kompose.local
10.42.42.21 chat_gotify chat.kompose.local
```

**Update VPN to use internal DNS:**

```bash
# vpn/.env
WG_DEFAULT_DNS=10.42.42.53

# Restart VPN
./kompose.sh restart vpn
```

**Now clients can use:**

```bash
psql -h postgres.kompose.local
redis-cli -h redis.kompose.local
mosquitto_pub -h mqtt.kompose.local -t test -m "hello"
```

### Option 3: Split Horizon DNS (Production)

Use different DNS for internal and external:

```bash
# Internal queries (*.kompose.local) → core-dns (10.42.42.53)
# External queries (*.com, etc) → 1.1.1.1

# Configure in CoreDNS:
kompose.local:53 {
    hosts /etc/coredns/hosts
}

.:53 {
    forward . 1.1.1.1 8.8.8.8
}
```

## Security Hardening

### 1. Network Segmentation

Create separate networks for different security zones:

```yaml
# vpn/compose.yaml - add security zones
networks:
  vpn_public:
    driver: bridge
    ipam:
      config:
        - subnet: 10.42.0.0/24
        
  vpn_management:
    driver: bridge
    ipam:
      config:
        - subnet: 10.43.0.0/24
        
  kompose_network:
    external: true
```

### 2. Firewall Rules

**Implement strict rules:**

```yaml
# vpn/compose.yaml - add firewall rules
environment:
  WG_PRE_UP: |
    iptables -A FORWARD -i wg0 -o eth0 -s 10.42.0.0/24 -j ACCEPT
    iptables -A FORWARD -i eth0 -o wg0 -d 10.42.0.0/24 -j ACCEPT
    iptables -A FORWARD -j DROP
    
  WG_POST_DOWN: |
    iptables -D FORWARD -i wg0 -o eth0 -s 10.42.0.0/24 -j ACCEPT
    iptables -D FORWARD -i eth0 -o wg0 -d 10.42.0.0/24 -j ACCEPT
    iptables -D FORWARD -j DROP
```

### 3. Client IP Restrictions

**Limit access by client IP:**

```bash
# Allow only specific VPN clients to access database
docker network create \
  --subnet 10.42.0.0/24 \
  --ip-range 10.42.0.100/28 \
  vpn_restricted

# Only .100-.115 can access certain services
```

### 4. Rate Limiting

**Add rate limiting via Traefik:**

```yaml
# vpn/compose.yaml - add to labels
labels:
  - 'traefik.http.middlewares.vpn-ratelimit.ratelimit.average=100'
  - 'traefik.http.middlewares.vpn-ratelimit.ratelimit.burst=50'
  - 'traefik.http.middlewares.vpn-ratelimit.ratelimit.period=1m'
  - 'traefik.http.routers.vpn-web-secure.middlewares=vpn-ratelimit'
```

### 5. Access Control Lists

**Implement service-level ACLs:**

```yaml
# core/postgres/pg_hba.conf
# Only allow VPN network
host    all             all             10.42.0.0/24            md5
host    all             all             10.42.42.0/24           md5
```

```yaml
# core/redis/redis.conf
# Bind to kompose network only
bind 0.0.0.0
protected-mode yes
requirepass YOUR_STRONG_PASSWORD
```

### 6. Audit Logging

**Enable comprehensive logging:**

```bash
# Log all VPN connections
docker logs -f vpn_app | grep handshake >> /var/log/vpn-connections.log

# Log database access
docker exec core-postgres psql -U valknar -c "ALTER SYSTEM SET log_connections = on;"

# Log Redis commands
redis-cli -h core-redis CONFIG SET slowlog-log-slower-than 0
```

## Monitoring & Maintenance

### Health Checks

**Automated health monitoring:**

```bash
#!/bin/bash
# health-check.sh - Run every 5 minutes via cron

VPN_STATUS=$(docker exec vpn_app wg show wg0 | grep "peer:" | wc -l)
POSTGRES_STATUS=$(docker exec core-postgres pg_isready -U valknar)
REDIS_STATUS=$(docker exec core-redis redis-cli -a PASSWORD PING)

# Send to monitoring system
curl -X POST http://chat_gotify:80/message?token=TOKEN \
  -F "title=Health Check" \
  -F "message=VPN: $VPN_STATUS clients, DB: $POSTGRES_STATUS, Redis: $REDIS_STATUS"
```

### Performance Monitoring

**Track VPN performance:**

```bash
# Connection statistics
docker exec vpn_app wg show wg0 transfer

# Bandwidth usage per client
docker exec vpn_app wg show wg0 | grep -A 2 "peer:"

# Network throughput
docker stats vpn_app --no-stream
```

### Backup Strategy

**Comprehensive backup:**

```bash
#!/bin/bash
# backup-all.sh - Daily backup script

BACKUP_DATE=$(date +%Y%m%d)
BACKUP_DIR="/backups/${BACKUP_DATE}"
mkdir -p "$BACKUP_DIR"

# Backup VPN configs
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v "$BACKUP_DIR:/backup" \
  alpine tar czf /backup/vpn-config.tar.gz /data

# Backup databases
./kompose.sh db backup --compress

# Backup environment configs
tar czf "$BACKUP_DIR/env-configs.tar.gz" \
  .env secrets.env */. env

# Upload to cloud storage
rclone copy "$BACKUP_DIR" remote:backups/kompose/
```

## Troubleshooting Guide

### Issue: Cannot Connect to VPN

**Diagnostic steps:**

```bash
# 1. Check VPN server is running
docker ps | grep vpn_app

# 2. Verify WireGuard interface
docker exec vpn_app wg show

# 3. Test port is open
nc -z -v -u YOUR_PUBLIC_IP 51820

# 4. Check client config
# Ensure Endpoint matches WG_HOST:WG_PORT

# 5. Check firewall
sudo ufw status | grep 51820

# 6. View detailed logs
./kompose.sh logs vpn -f
```

### Issue: Connected but Cannot Access Services

**Diagnostic steps:**

```bash
# 1. Test VPN gateway
ping 10.42.42.42

# 2. Test service IP
ping 10.42.42.X  # Replace with service IP

# 3. Check routing
# On client:
ip route | grep 10.42

# Should show route through VPN

# 4. Verify AllowedIPs in client config
# Should include: 10.42.42.0/24

# 5. Test specific service
telnet core-postgres 5432
curl http://chain_n8n:5678

# 6. Check service is on kompose network
docker network inspect kompose | grep SERVICE_NAME
```

### Issue: Slow Performance

**Optimization steps:**

```bash
# 1. Reduce keepalive if stable connection
# vpn/.env
WG_PERSISTENT_KEEPALIVE=0

# 2. Optimize MTU
# Client config:
MTU = 1420

# 3. Use split tunnel
WG_ALLOWED_IPS=10.42.42.0/24  # Only route internal traffic

# 4. Check server resources
docker stats vpn_app

# 5. Test bandwidth
# From client:
iperf3 -c 10.42.42.42
```

## Best Practices

### 1. Client Naming Convention

```
Format: role-user-device
Examples:
  - admin-john-laptop
  - dev-jane-workstation
  - mobile-john-iphone
  - iot-sensor-bedroom
  - ci-github-runner
```

### 2. Configuration Management

```bash
# Store configs in version control (encrypted)
git-crypt init
echo "secrets.env" >> .gitattributes
echo "vpn/.env" >> .gitattributes
git add .gitattributes
git commit -m "Add git-crypt"
```

### 3. Rotation Policy

```bash
# Rotate clients every 90 days
# Create calendar reminder:
echo "0 0 1 */3 * /scripts/rotate-vpn-clients.sh" >> /etc/crontab
```

### 4. Documentation

```bash
# Document each client
# vpn/clients.md
| Client | User | Device | Purpose | Created | Expires |
|--------|------|--------|---------|---------|---------|
| admin-john-laptop | John | MacBook | Admin | 2024-01-01 | 2024-04-01 |
```

### 5. Monitoring Alerts

```bash
# Alert on suspicious activity
docker logs vpn_app | grep "handshake" | \
  awk '{print $5}' | sort | uniq -c | \
  awk '$1 > 100 {print "Alert: Excessive handshakes from", $2}'
```

## Production Deployment Checklist

- [ ] VPN server has static IP or DDNS
- [ ] Port forwarding configured (UDP 51820)
- [ ] Firewall rules implemented
- [ ] Strong password set for Web UI
- [ ] DNS configuration tested
- [ ] All services accessible via VPN
- [ ] Backup strategy implemented
- [ ] Monitoring configured
- [ ] Documentation created
- [ ] Team access granted
- [ ] Client rotation policy defined
- [ ] Audit logging enabled
- [ ] Rate limiting configured
- [ ] Health checks automated
- [ ] Disaster recovery plan documented

## Additional Resources

- [VPN README](vpn/README.md) - Complete VPN documentation
- [VPN Quick Reference](VPN_QUICK_REF.md) - Quick commands
- [Core Services](core/README.md) - Core infrastructure docs
- [Chain Stack](chain/INTEGRATION_GUIDE.md) - Automation integration
- [WireGuard Documentation](https://www.wireguard.com/quickstart/)
- [wg-easy GitHub](https://github.com/wg-easy/wg-easy)

## Support

For issues or questions:

1. Check logs: `./kompose.sh logs vpn`
2. Verify configuration: `cat vpn/.env`
3. Test connectivity: `docker exec vpn_app wg show`
4. Review this integration guide
5. Check service-specific documentation

---

**🔒 Security First:** Always prioritize security over convenience  
**📖 Document Everything:** Keep client and configuration documentation updated  
**🔄 Regular Maintenance:** Weekly health checks, monthly client rotation  
**💾 Backup Always:** Daily backups of VPN configs and databases
