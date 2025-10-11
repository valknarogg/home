# VPN Stack - WireGuard Private Intranet

## Overview

The **vpn** stack provides secure remote access to your entire kompose infrastructure using WireGuard via the wg-easy web interface. This creates a private intranet allowing you to securely access all your services from anywhere.

**Key Features:**
- 🔒 **Secure Access** - WireGuard VPN for encrypted connections
- 🌐 **Web Management** - Easy client configuration via wg-easy UI
- 🔗 **Full Integration** - Access all kompose services through VPN
- 📱 **Multi-Platform** - iOS, Android, Windows, macOS, Linux support
- 🚀 **Easy Setup** - QR code configuration for mobile devices

## Architecture

### Network Topology

```
Internet
   ↓
WireGuard UDP:51820
   ↓
[VPN Container]
   ↓
10.42.0.0/24 (VPN clients)
   ↓
kompose network (10.42.42.0/24)
   ↓
[All kompose services]
```

### Service Details

| Component | Details |
|-----------|---------|
| **Image** | ghcr.io/wg-easy/wg-easy:15 |
| **Container** | vpn_app |
| **WireGuard Port** | 51820/udp |
| **Web UI Port** | 51821/tcp (via Traefik) |
| **Web UI URL** | https://vpn.pivoine.art |
| **VPN Network** | 10.42.0.0/24 |
| **Internal Network** | 10.42.42.42 (on kompose network) |

## Quick Start

### 1. Configure Environment

The VPN stack is pre-configured, but verify these settings in `/vpn/.env`:

```bash
# Check configuration
cat vpn/.env

# Key settings to verify:
WG_HOST=vpn.pivoine.art          # Your public domain/IP
WG_PORT=51820                     # WireGuard listening port
APP_PORT=51821                    # Web UI port
WG_DEFAULT_DNS=1.1.1.1           # DNS for VPN clients
```

### 2. Set Admin Password

Generate a password hash for the web UI:

```bash
# Generate password hash
docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw YOUR_PASSWORD

# Add to vpn/.env
PASSWORD_HASH=your_generated_hash
```

### 3. Configure Port Forwarding

Ensure your router/firewall forwards:
- **UDP port 51820** → Your server IP

### 4. Start VPN Stack

```bash
# Start VPN service
./kompose.sh up vpn

# Verify it's running
./kompose.sh status vpn
```

### 5. Access Web UI

Open https://vpn.pivoine.art in your browser and log in with your password.

## Client Setup

### Desktop Clients

**1. Install WireGuard:**
- **Windows**: https://www.wireguard.com/install/
- **macOS**: App Store or https://www.wireguard.com/install/
- **Linux**: `sudo apt install wireguard` or equivalent

**2. Get Configuration:**
- Log into wg-easy web UI
- Click "+" to create new client
- Download configuration file
- Import into WireGuard client

**3. Connect:**
- Activate the tunnel
- Verify connection by accessing internal services

### Mobile Clients

**1. Install WireGuard:**
- **iOS**: App Store
- **Android**: Google Play Store

**2. Scan QR Code:**
- Open wg-easy web UI
- Create new client
- Click QR code icon
- Scan with WireGuard app

**3. Connect:**
- Enable tunnel in app
- Access your services

## Private Intranet Access

### Accessing Kompose Services

Once connected to VPN, access all services using their internal addresses:

#### Via Container Names (Recommended)

```bash
# Database
postgresql://core-postgres:5432

# Redis
redis://core-redis:6379

# MQTT
mqtt://core-mqtt:1883

# Application Services
http://chain_n8n:5678          # n8n workflows
http://chain_semaphore:3000    # Semaphore
http://chat_gotify:80          # Gotify
http://vault_vaultwarden:80    # Vaultwarden
```

#### Via Traefik Domains (When using HTTPS)

```bash
# Access via secure domains
https://chain.pivoine.art      # n8n
https://vault.pivoine.art      # Vaultwarden  
https://chat.pivoine.art       # Gotify
https://code.pivoine.art       # Gitea
https://dash.pivoine.art       # Dashboard
```

### DNS Configuration

**Option 1: Use Provided DNS (Default)**
- VPN clients use `WG_DEFAULT_DNS=1.1.1.1`
- Works for internet access
- Requires local hosts file for service names

**Option 2: Internal DNS Server**

Set up a DNS server in kompose (recommended for production):

```yaml
# Add to core stack
services:
  dns:
    image: coredns/coredns
    container_name: core-dns
    volumes:
      - ./dns/Corefile:/Corefile
      - ./dns/hosts:/etc/hosts
    networks:
      kompose_network:
        ipv4_address: 10.42.42.53
```

Then update VPN:
```bash
WG_DEFAULT_DNS=10.42.42.53
```

**Option 3: Split DNS**

Use Traefik as internal DNS resolver for `*.pivoine.art` domains while keeping public DNS for internet.

## Advanced Configuration

### Client Configuration Options

**Default Settings in `.env`:**

```bash
# IP allocation for clients
WG_DEFAULT_ADDRESS=10.42.0.x

# DNS servers for clients
WG_DEFAULT_DNS=1.1.1.1

# Allowed IPs (what routes through VPN)
WG_ALLOWED_IPS=0.0.0.0/0, 1.1.1.1/32

# Keepalive interval (for NAT)
WG_PERSISTENT_KEEPALIVE=25
```

### Route Only Internal Traffic

To route only kompose network through VPN (split tunnel):

```bash
# In vpn/.env, change:
WG_ALLOWED_IPS=10.42.42.0/24
```

This allows:
- VPN routes only kompose services
- Internet traffic uses local connection
- Better performance for general browsing

### Full Tunnel (All Traffic)

To route all traffic through VPN:

```bash
WG_ALLOWED_IPS=0.0.0.0/0, ::/0
```

### Multiple WireGuard Networks

Create separate VPN for different purposes:

```bash
# Copy vpn stack
cp -r vpn vpn-admin
cd vpn-admin

# Edit .env
COMPOSE_PROJECT_NAME=vpn-admin
WG_PORT=51821
APP_PORT=51822
WG_DEFAULT_ADDRESS=10.43.0.x

# Use different subnet
# Edit compose.yaml network:
networks:
  wg:
    ipam:
      config:
        - subnet: 10.43.42.0/24
```

## Security

### Best Practices

1. **Strong Password** - Use generated hash for web UI
2. **Firewall Rules** - Only expose UDP 51820
3. **Client Rotation** - Remove unused clients
4. **Regular Updates** - Keep wg-easy image updated
5. **Monitoring** - Check logs for unauthorized attempts

### Hardening

**1. Enable Client IP Restrictions:**

Edit `compose.yaml`:
```yaml
environment:
  WG_PRE_UP: iptables -A FORWARD -s 10.42.0.0/24 -j ACCEPT; iptables -A FORWARD -j DROP
```

**2. Rate Limiting:**

Add to Traefik labels in `compose.yaml`:
```yaml
labels:
  - 'traefik.http.middlewares.vpn-ratelimit.ratelimit.average=10'
  - 'traefik.http.middlewares.vpn-ratelimit.ratelimit.burst=20'
  - 'traefik.http.routers.vpn-web-secure.middlewares=vpn-ratelimit'
```

**3. IP Allowlist for Web UI:**

```yaml
labels:
  - 'traefik.http.middlewares.vpn-ipallowlist.ipallowlist.sourcerange=10.42.0.0/24'
  - 'traefik.http.routers.vpn-web-secure.middlewares=vpn-ipallowlist'
```

### Client Management

**Create Client:**
```bash
# Via Web UI (recommended)
# 1. Log into https://vpn.pivoine.art
# 2. Click "+" button
# 3. Enter client name
# 4. Download config or scan QR

# Via CLI (advanced)
docker exec vpn_app wg show
```

**Remove Client:**
```bash
# Via Web UI
# Click trash icon next to client

# Via CLI
docker exec vpn_app wg set wg0 peer <PUBLIC_KEY> remove
```

**List Active Connections:**
```bash
docker exec vpn_app wg show wg0
```

## Monitoring

### View Active Connections

```bash
# Check connected clients
docker exec vpn_app wg show wg0

# Check traffic stats (if enabled)
# Open web UI and view statistics
```

### Logs

```bash
# View VPN logs
./kompose.sh logs vpn -f

# Check WireGuard status
docker exec vpn_app wg show

# Monitor connection attempts
docker logs vpn_app | grep handshake
```

### Traffic Statistics

Enable in `.env`:
```bash
UI_TRAFFIC_STATS=true
UI_CHART_TYPE=0  # 0=bar, 1=line, 2=area
```

## Troubleshooting

### Cannot Connect to VPN

**Check server status:**
```bash
# Verify container running
docker ps | grep vpn

# Check WireGuard interface
docker exec vpn_app wg show

# Verify port forwarding
netstat -ulnp | grep 51820
```

**Check firewall:**
```bash
# Ensure UDP 51820 is allowed
sudo ufw allow 51820/udp

# Check iptables
sudo iptables -L -n | grep 51820
```

**Verify client configuration:**
```bash
# Endpoint should match WG_HOST
# AllowedIPs should include kompose network
# Check DNS settings
```

### Can Connect but Cannot Access Services

**1. Check routing:**
```bash
# From VPN client, test connectivity
ping 10.42.42.42  # VPN container IP

# Try reaching another service
ping 10.42.42.2   # Example: another container
```

**2. Verify kompose network:**
```bash
# Check network exists
docker network inspect kompose

# Verify VPN container is connected
docker network inspect kompose | grep vpn_app
```

**3. Test DNS:**
```bash
# From VPN client
nslookup google.com  # Should work
nslookup chain.pivoine.art  # May not work without internal DNS
```

**4. Check allowed IPs:**
```bash
# In vpn/.env, ensure:
WG_ALLOWED_IPS includes your target network
# For kompose: 10.42.42.0/24
```

### Web UI Not Accessible

**Check Traefik:**
```bash
# Verify Traefik is running
docker ps | grep traefik

# Check Traefik logs
docker logs proxy_traefik

# Test without Traefik
curl http://localhost:51821
```

**Verify DNS:**
```bash
# Ensure vpn.pivoine.art resolves correctly
nslookup vpn.pivoine.art

# If using local DNS, check hosts file
cat /etc/hosts | grep vpn.pivoine.art
```

### Clients Cannot Access Internet

**Enable IP forwarding:**
```bash
# Check current setting
docker exec vpn_app sysctl net.ipv4.ip_forward

# Should return: net.ipv4.ip_forward = 1
# Already configured in compose.yaml via sysctls
```

**Check routing:**
```bash
# Verify allowed IPs includes internet
# In vpn/.env:
WG_ALLOWED_IPS=0.0.0.0/0

# Restart VPN
./kompose.sh restart vpn
```

### Reset VPN

```bash
# Stop VPN
./kompose.sh down vpn

# Remove configuration (WARNING: deletes all clients!)
docker volume rm vpn_etc_wireguard

# Restart fresh
./kompose.sh up vpn
```

## Integration Examples

### Example 1: Remote Development

Access your development stack remotely:

```bash
# Connect to VPN from laptop
# Access services directly:
ssh user@10.42.42.10          # SSH to dev server
psql -h core-postgres -U valknar  # Database access
redis-cli -h core-redis        # Cache access
```

### Example 2: Mobile Access

Monitor services from phone:

```bash
# Connect via WireGuard app
# Open browser to:
https://dash.pivoine.art       # Dashboard
https://chat.pivoine.art       # Notifications
https://trace.pivoine.art      # Logs
```

### Example 3: Team Access

Share access with team members:

```bash
# Create client per team member
# Client naming: firstname-device
# E.g., john-laptop, jane-phone

# Set appropriate allowed IPs per role:
# Developers: 10.42.42.0/24 (full access)
# Monitoring: 10.42.42.0/24 (read-only via app permissions)
```

### Example 4: IoT Devices

Connect IoT devices to private network:

```bash
# Create client: iot-sensor-01
# Configure allowed IPs: 10.42.42.0/24
# Device can publish to MQTT:
mqtt://core-mqtt:1883
```

## Backup & Restore

### Backup VPN Configuration

```bash
# Backup WireGuard config volume
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/vpn-config-$(date +%Y%m%d).tar.gz /data

# Backup includes all client configs
```

### Restore Configuration

```bash
# Stop VPN
./kompose.sh down vpn

# Restore volume
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/vpn-config-20241011.tar.gz -C /

# Restart VPN
./kompose.sh up vpn
```

### Migrate to New Server

```bash
# On old server - backup
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/vpn-migration.tar.gz /data

# Transfer to new server
scp vpn-migration.tar.gz user@newserver:/home/user/

# On new server - restore
./kompose.sh up vpn
./kompose.sh down vpn
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/vpn-migration.tar.gz -C /
./kompose.sh up vpn
```

## Performance Tuning

### Optimize for Speed

```bash
# Reduce keepalive (if stable connection)
WG_PERSISTENT_KEEPALIVE=0

# Use faster DNS
WG_DEFAULT_DNS=1.1.1.1,8.8.8.8

# Enable BBR congestion control (Linux)
docker exec vpn_app sysctl -w net.core.default_qdisc=fq
docker exec vpn_app sysctl -w net.ipv4.tcp_congestion_control=bbr
```

### Scale for Multiple Users

```bash
# Increase MTU if on gigabit network
# Edit compose.yaml:
environment:
  WG_MTU: 1420

# Monitor resource usage
docker stats vpn_app

# Consider dedicated VPN server if >50 users
```

## Resources

- **WireGuard**: https://www.wireguard.com/
- **wg-easy**: https://github.com/wg-easy/wg-easy
- **VPN Setup Guide**: https://www.wireguard.com/quickstart/
- **Security Best Practices**: https://www.wireguard.com/papers/wireguard.pdf

## Support

### Getting Help

1. **Check logs**: `./kompose.sh logs vpn`
2. **Verify status**: `./kompose.sh status vpn`
3. **Test connectivity**: `docker exec vpn_app wg show`
4. **Review configuration**: `cat vpn/.env`

### Common Issues

| Issue | Solution |
|-------|----------|
| Cannot connect | Check port forwarding, firewall |
| No internet in VPN | Verify ALLOWED_IPS includes 0.0.0.0/0 |
| Cannot access services | Check kompose network connection |
| Slow performance | Reduce keepalive, check MTU |
| Web UI not loading | Verify Traefik, check DNS |

## Next Steps

1. ✅ Start VPN stack
2. ✅ Set admin password
3. ✅ Create first client
4. ✅ Test connection
5. ✅ Configure DNS (optional)
6. ✅ Set up monitoring
7. ✅ Create team clients
8. ✅ Document client access

---

**Need quick commands?** See [VPN_QUICK_REF.md](VPN_QUICK_REF.md)  
**Integration guide?** See [VPN_INTEGRATION.md](VPN_INTEGRATION.md)
