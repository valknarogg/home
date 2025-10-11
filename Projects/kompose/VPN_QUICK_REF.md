# VPN Stack - Quick Reference

## 🚀 Quick Start

```bash
# 1. Set admin password
docker run --rm ghcr.io/wg-easy/wg-easy wgpw YOUR_PASSWORD
# Add hash to vpn/.env: PASSWORD_HASH=...

# 2. Configure port forwarding
# Forward UDP 51820 → Your server IP

# 3. Start VPN
./kompose.sh up vpn

# 4. Access Web UI
# https://vpn.pivoine.art

# 5. Create client
# Click "+" in Web UI, scan QR or download config
```

## 📦 Service Overview

| Service | Container | Port | Access |
|---------|-----------|------|--------|
| WireGuard VPN | vpn_app | 51820/udp | VPN connection |
| Web UI | vpn_app | 51821/tcp | https://vpn.pivoine.art |
| Internal IP | vpn_app | 10.42.42.42 | kompose network |
| Client Network | - | 10.42.0.0/24 | VPN clients |

## 🔧 Stack Management

```bash
# Start VPN
./kompose.sh up vpn

# Stop VPN  
./kompose.sh down vpn

# Restart VPN
./kompose.sh restart vpn

# View logs
./kompose.sh logs vpn -f

# Check status
./kompose.sh status vpn

# Update image
./kompose.sh pull vpn
```

## 👥 Client Management

```bash
# Create client (via Web UI - recommended)
# 1. Open https://vpn.pivoine.art
# 2. Click "+" button
# 3. Enter client name
# 4. Download config or scan QR code

# List active clients
docker exec vpn_app wg show wg0

# View connected clients
docker exec vpn_app wg show wg0 | grep peer

# Check client traffic
docker exec vpn_app wg show wg0 transfer

# Remove client
# Click trash icon in Web UI
```

## 🌐 Network Access

### Access Kompose Services via VPN

```bash
# Container names (internal DNS)
postgresql://core-postgres:5432
redis://core-redis:6379
mqtt://core-mqtt:1883
http://chain_n8n:5678
http://vault_vaultwarden:80

# Via Traefik domains
https://chain.pivoine.art      # n8n
https://vault.pivoine.art      # Vaultwarden
https://chat.pivoine.art       # Gotify
https://code.pivoine.art       # Gitea

# Direct IP access
http://10.42.42.42             # VPN container
http://10.42.42.2              # Other services
```

### Test Connectivity

```bash
# From VPN client - test VPN gateway
ping 10.42.42.42

# Test another service
ping 10.42.42.2

# Test internet (if full tunnel)
ping 1.1.1.1

# Test DNS
nslookup google.com
```

## ⚙️ Configuration

### Environment Variables (vpn/.env)

```bash
# Essential settings
WG_HOST=vpn.pivoine.art        # Your public domain/IP
WG_PORT=51820                   # WireGuard port
PASSWORD_HASH=...               # Web UI password hash

# Client defaults
WG_DEFAULT_ADDRESS=10.42.0.x    # Client IP allocation
WG_DEFAULT_DNS=1.1.1.1          # DNS for clients
WG_PERSISTENT_KEEPALIVE=25      # NAT keepalive

# Traffic routing
WG_ALLOWED_IPS=0.0.0.0/0       # Full tunnel (all traffic)
# OR
WG_ALLOWED_IPS=10.42.42.0/24   # Split tunnel (only kompose)

# UI options
UI_TRAFFIC_STATS=true           # Enable stats
UI_CHART_TYPE=0                 # 0=bar, 1=line, 2=area
```

### Generate Password Hash

```bash
# Generate hash for PASSWORD_HASH
docker run --rm ghcr.io/wg-easy/wg-easy wgpw YOUR_PASSWORD
```

### Change VPN Settings

```bash
# Edit configuration
nano vpn/.env

# Apply changes
./kompose.sh restart vpn
```

## 🔒 Security

### Set Strong Password

```bash
# Generate secure password
openssl rand -base64 32

# Create hash
docker run --rm ghcr.io/wg-easy/wg-easy wgpw GENERATED_PASSWORD

# Add to vpn/.env
PASSWORD_HASH=your_hash_here
```

### Firewall Rules

```bash
# Allow WireGuard port
sudo ufw allow 51820/udp

# Check rules
sudo ufw status

# Verify port listening
netstat -ulnp | grep 51820
```

### Client Rotation

```bash
# Remove old/unused clients via Web UI
# 1. Log into https://vpn.pivoine.art
# 2. Click trash icon next to client
# 3. Confirm deletion

# Create replacement client
# Click "+" and set up new config
```

## 📊 Monitoring

### Check VPN Status

```bash
# Show WireGuard status
docker exec vpn_app wg show

# Show active connections
docker exec vpn_app wg show wg0 endpoints

# Show data transfer
docker exec vpn_app wg show wg0 transfer

# Monitor logs
./kompose.sh logs vpn -f
```

### Traffic Statistics

```bash
# Enable in vpn/.env
UI_TRAFFIC_STATS=true

# View in Web UI
# Stats appear under each client

# Check via CLI
docker exec vpn_app wg show wg0 transfer
```

### Resource Usage

```bash
# Container stats
docker stats vpn_app

# Network stats
docker exec vpn_app ifconfig wg0

# Connection count
docker exec vpn_app wg show wg0 | grep peer | wc -l
```

## 💾 Backup & Restore

### Backup VPN Config

```bash
# Create backup directory
mkdir -p backups/vpn

# Backup WireGuard configuration
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd)/backups/vpn:/backup \
  alpine tar czf /backup/vpn-config-$(date +%Y%m%d).tar.gz /data

# Backup includes all client configs!
```

### Restore from Backup

```bash
# Stop VPN
./kompose.sh down vpn

# Restore configuration
docker run --rm \
  -v vpn_etc_wireguard:/data \
  -v $(pwd)/backups/vpn:/backup \
  alpine tar xzf /backup/vpn-config-YYYYMMDD.tar.gz -C /

# Restart VPN  
./kompose.sh up vpn
```

### List Backups

```bash
# Show available backups
ls -lh backups/vpn/

# Show backup contents
docker run --rm \
  -v $(pwd)/backups/vpn:/backup \
  alpine tar tzf /backup/vpn-config-YYYYMMDD.tar.gz
```

## 🐛 Troubleshooting

### Cannot Connect to VPN

```bash
# Check VPN is running
docker ps | grep vpn_app

# Check WireGuard interface
docker exec vpn_app wg show

# Verify port forwarding
netstat -ulnp | grep 51820

# Check firewall
sudo ufw status | grep 51820

# Test from outside
# Use online port checker for UDP 51820

# Check logs for errors
./kompose.sh logs vpn | grep -i error
```

### Connected but No Access

```bash
# Test VPN gateway
ping 10.42.42.42

# Check routing from client
# Verify AllowedIPs includes kompose network

# Verify kompose network connection
docker network inspect kompose | grep vpn_app

# Test specific service
ping 10.42.42.2              # Example service
curl http://10.42.42.42:51821  # VPN web UI

# Check client config
# Ensure: AllowedIPs = 10.42.42.0/24 (or 0.0.0.0/0)
```

### Web UI Not Accessible

```bash
# Check Traefik is running
docker ps | grep traefik

# Test direct access
curl http://localhost:51821

# Check Traefik logs
docker logs proxy_traefik | grep vpn

# Verify DNS
nslookup vpn.pivoine.art

# Check Traefik labels
docker inspect vpn_app | grep -A 5 traefik
```

### No Internet on VPN

```bash
# Check allowed IPs includes internet
cat vpn/.env | grep ALLOWED_IPS
# Should be: WG_ALLOWED_IPS=0.0.0.0/0

# Verify IP forwarding
docker exec vpn_app sysctl net.ipv4.ip_forward
# Should return: net.ipv4.ip_forward = 1

# Restart VPN
./kompose.sh restart vpn

# Test from client
ping 1.1.1.1
ping google.com
```

### Reset VPN (Nuclear Option)

```bash
# WARNING: Deletes all clients!

# Stop and remove
./kompose.sh down vpn -f

# Remove volume
docker volume rm vpn_etc_wireguard

# Start fresh
./kompose.sh up vpn

# Recreate clients
```

## 📱 Client Setup

### Desktop (Windows/Mac/Linux)

```bash
# 1. Install WireGuard
# Windows: https://www.wireguard.com/install/
# Mac: App Store or wireguard.com
# Linux: sudo apt install wireguard

# 2. Download config from Web UI
# Log in → Create client → Download

# 3. Import to WireGuard
# Open WireGuard → Import tunnel → Select .conf file

# 4. Activate
# Click "Activate" button

# 5. Test
ping 10.42.42.42
```

### Mobile (iOS/Android)

```bash
# 1. Install WireGuard app
# iOS: App Store
# Android: Google Play

# 2. Scan QR code
# Log into Web UI
# Create client
# Click QR icon
# Scan with app

# 3. Enable tunnel

# 4. Test
# Open browser → https://vpn.pivoine.art
```

### Linux CLI

```bash
# Download config
scp user@server:/path/to/client.conf ~/

# Import config
sudo cp ~/client.conf /etc/wireguard/wg0.conf

# Start VPN
sudo wg-quick up wg0

# Check status
sudo wg show

# Stop VPN
sudo wg-quick down wg0

# Auto-start on boot
sudo systemctl enable wg-quick@wg0
```

## 🎯 Common Tasks

### Create New Client

```bash
# 1. Open Web UI
open https://vpn.pivoine.art

# 2. Log in with password

# 3. Click "+" button

# 4. Enter client name (e.g., "john-laptop")

# 5. Download or scan QR

# 6. Import to WireGuard client
```

### Remove Client

```bash
# Via Web UI (recommended)
# Click trash icon → Confirm

# Via CLI
docker exec vpn_app wg show wg0
# Find peer public key
docker exec vpn_app wg set wg0 peer PUBLIC_KEY remove
```

### Update VPN

```bash
# Pull latest image
./kompose.sh pull vpn

# Restart with new image
./kompose.sh down vpn
./kompose.sh up vpn

# Verify version
docker inspect vpn_app | grep Image
```

### Change VPN Port

```bash
# Edit vpn/.env
WG_PORT=51821  # New port

# Update port forwarding on router

# Restart VPN
./kompose.sh restart vpn

# Update all client configs
# Download new configs from Web UI
```

## 📚 Quick Reference

### Useful Commands

```bash
# Status check
docker exec vpn_app wg show

# Connection count
docker exec vpn_app wg show wg0 | grep peer | wc -l

# Traffic stats
docker exec vpn_app wg show wg0 transfer

# Last handshake (connection test)
docker exec vpn_app wg show wg0 latest-handshakes

# Container health
docker inspect vpn_app | grep -A 10 Health
```

### Configuration Files

```bash
# Stack config
vpn/.env                       # Environment variables
vpn/compose.yaml               # Docker compose file

# WireGuard config (in volume)
docker exec vpn_app cat /etc/wireguard/wg0.conf

# Client configs (generated in Web UI)
# Stored in: vpn_etc_wireguard volume
```

### Web UI Access

```bash
# Production
https://vpn.pivoine.art

# Direct (bypass Traefik)
http://localhost:51821
http://SERVER_IP:51821

# From VPN
http://10.42.42.42:51821
```

## 🔗 Integration

### Access Other Stacks

```bash
# Core services
postgresql://core-postgres:5432
redis://core-redis:6379
mqtt://core-mqtt:1883

# Application stacks
http://chain_n8n:5678          # n8n
http://chain_semaphore:3000    # Semaphore
http://vault_vaultwarden:80    # Vaultwarden
http://chat_gotify:80          # Gotify

# Via Traefik
https://chain.pivoine.art
https://vault.pivoine.art
https://chat.pivoine.art
```

### Service Discovery

```bash
# List all services on kompose network
docker network inspect kompose --format '{{range .Containers}}{{.Name}} - {{.IPv4Address}}{{"\n"}}{{end}}'

# Find specific service IP
docker inspect SERVICE_NAME | grep -A 10 Networks

# Test connectivity
docker exec vpn_app ping SERVICE_NAME
```

## 💡 Pro Tips

### Split Tunnel (Recommended)

```bash
# Only route kompose network through VPN
# Edit vpn/.env:
WG_ALLOWED_IPS=10.42.42.0/24

# Benefits:
# - Faster internet browsing
# - Less VPN server load  
# - Access local network too

# Restart VPN
./kompose.sh restart vpn
```

### Full Tunnel (Maximum Security)

```bash
# Route all traffic through VPN
# Edit vpn/.env:
WG_ALLOWED_IPS=0.0.0.0/0, ::/0

# Benefits:
# - All traffic encrypted
# - IP address hidden
# - Access geo-restricted content

# Restart VPN
./kompose.sh restart vpn
```

### Multiple Clients Same User

```bash
# Name convention: user-device
# Examples:
john-laptop
john-phone
john-tablet

# Easy to manage and identify
# Can revoke specific devices
```

### Monitor Active Connections

```bash
# Real-time monitoring
watch -n 2 'docker exec vpn_app wg show wg0 endpoints'

# Log handshakes
docker logs -f vpn_app | grep handshake

# Connection summary
docker exec vpn_app wg show wg0 | grep "peer:" | wc -l
```

---

**📖 Full Documentation:** [README.md](README.md)  
**🔗 Integration Guide:** [VPN_INTEGRATION.md](VPN_INTEGRATION.md)  
**🚀 Need help?** Check logs: `./kompose.sh logs vpn`
