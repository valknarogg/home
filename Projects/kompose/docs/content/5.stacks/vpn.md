---
title: VPN - Encrypted Tunnel to Freedom
description: "The internet, but make it private!"
navigation:
  icon: i-lucide-plug
---

> *"The internet, but make it private!"* - WireGuard

## What's This All About?

WG-Easy is your self-hosted VPN server powered by WireGuard! It's like having your own private tunnel through the internet - encrypt all your traffic, bypass geo-restrictions, access your home network from anywhere, and surf safely on sketchy public WiFi. Plus, it has a beautiful web UI for managing clients! 🚇

## The Privacy Protector

### :icon{name="lucide:shield"} WG-Easy

**Container**: `vpn_app`  
**Image**: `ghcr.io/wg-easy/wg-easy:15`  
**Ports**: 51820 (VPN), 51821 (Web UI)  
**Home**: https://vpn.pivoine.art

WG-Easy makes WireGuard actually easy:
- :icon{name="lucide:palette"} **Beautiful Web UI**: Manage VPN from browser
- :icon{name="lucide:phone"} **QR Codes**: Instant mobile setup
- :icon{name="lucide:users"} **Multi-Client**: Unlimited devices
- :icon{name="lucide:zap"} **WireGuard**: Modern, fast, secure protocol
- :icon{name="lucide:bar-chart"} **Traffic Stats**: See bandwidth usage
- :icon{name="lucide:lock"} **Encrypted**: Industry-standard crypto
- :icon{name="lucide:globe"} **Route All Traffic**: Or split-tunnel
- :icon{name="lucide:rocket"} **Performance**: Faster than OpenVPN

## WireGuard: The Modern VPN Protocol

### Why WireGuard is Awesome
- :icon{name="lucide:zap"} **Fast**: 4000+ lines of code vs OpenVPN's 600,000+
- :icon{name="lucide:lock"} **Secure**: State-of-the-art cryptography
- :icon{name="lucide:phone"} **Battery Friendly**: Less power consumption
- :icon{name="lucide:refresh-cw"} **Roaming**: Seamless connection switching
- :icon{name="lucide:sparkles"} **Linux Kernel**: Built into Linux 5.6+
- :icon{name="lucide:target"} **Simple**: Easier to audit and configure

## Configuration Breakdown

### Network Configuration

The stack creates TWO networks:

**wg Network** (Internal WireGuard):
```yaml
subnet: 10.42.42.0/24           # IPv4
subnet: fdcc:ad94:bacf:61a3::/64  # IPv6
```
Your VPN clients get IPs from this range.

**kompose Network** (External):
```yaml
external: true
```
Connects to other services via Traefik.

### Environment Variables

**WireGuard Settings**:
```bash
WG_HOST=vpn.pivoine.art      # Your public domain/IP
WG_PORT=51820                # WireGuard port (UDP)
WG_DEFAULT_ADDRESS=10.42.0.x # Client IP range
WG_DEFAULT_DNS=1.1.1.1       # DNS for clients
WG_ALLOWED_IPS=0.0.0.0/0     # Route all traffic through VPN
```

**Web UI Settings**:
```bash
PORT=51821                   # Web interface port
UI_TRAFFIC_STATS=true        # Show bandwidth graphs
UI_CHART_TYPE=0              # Chart style
```

### Security & Capabilities

Required Linux capabilities:
```yaml
cap_add:
  - NET_ADMIN    # Network configuration
  - SYS_MODULE   # Load kernel modules
```

System controls:
```yaml
sysctls:
  - net.ipv4.ip_forward=1                  # Enable IP forwarding
  - net.ipv4.conf.all.src_valid_mark=1    # Packet routing
```

## First Time Setup :icon{name="lucide:rocket"}

### 1. Ensure Ports are Open

**Firewall**:
```bash
# Allow WireGuard port
sudo ufw allow 51820/udp

# Allow Web UI (temporary for setup)
sudo ufw allow 51821/tcp
```

**Router**:
- Forward UDP port 51820 to your server
- Check your router's port forwarding settings

### 2. Set Your Public Address

In `.env`:
```bash
# Use your domain
WG_HOST=vpn.yourdomain.com

# Or your public IP
WG_HOST=123.45.67.89
```

### 3. Start the Stack
```bash
docker compose up -d
```

### 4. Access Web UI
```
URL: https://vpn.pivoine.art
Password: (set via PASSWORD_HASH in .env)
```

### 5. Generate Password Hash

If you haven't set password yet:
```bash
# Generate bcrypt hash
echo -n 'your-password' | npx bcrypt-cli

# Or use Docker
docker run --rm -it node:alpine sh -c "npm install -g bcrypt-cli && echo -n 'your-password' | bcrypt"

# Copy hash to .env
PASSWORD_HASH=$2a$10$...your_hash...
```

Restart container:
```bash
docker compose restart
```

## Creating VPN Clients :icon{name="lucide:phone"}

### Add a Client

1. **Login to Web UI**: https://vpn.pivoine.art
2. **Click "New Client"**
3. **Give it a name**: "My iPhone", "Work Laptop", etc.
4. **Click "Create"**

### Mobile Setup (QR Code)

**For iPhone/Android**:
1. Install WireGuard app:
   - [iOS](https://apps.apple.com/app/wireguard/id1441195209)
   - [Android](https://play.google.com/store/apps/details?id=com.wireguard.android)

2. Open app → "Add tunnel" → "Scan QR code"
3. Scan the QR code from web UI
4. Give tunnel a name
5. Toggle on!

### Desktop Setup (Config File)

**For Windows/Mac/Linux**:
1. Download WireGuard:
   - [Windows](https://download.wireguard.com/windows-client/)
   - [macOS](https://apps.apple.com/app/wireguard/id1451685025)
   - [Linux](https://www.wireguard.com/install/)

2. In web UI, click "Download" next to client
3. Import config file into WireGuard app
4. Activate tunnel!

### Manual Configuration

Download the `.conf` file and inspect it:
```ini
[Interface]
PrivateKey = your_private_key
Address = 10.42.0.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = server_public_key
PresharedKey = shared_key
Endpoint = vpn.pivoine.art:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
```

## Using Your VPN :icon{name="lucide:globe"}

### Full Tunnel (All Traffic)

**Default behavior** - all internet traffic goes through VPN:
- :icon{name="lucide:check"} Complete privacy
- :icon{name="lucide:check"} Bypass geo-blocks
- :icon{name="lucide:check"} Secure public WiFi
- :icon{name="lucide:alert-triangle"} Slightly slower (routing through your server)

### Split Tunnel (Selective Routing)

**Only route specific traffic** through VPN.

Edit client config to only route home network:
```ini
AllowedIPs = 10.0.0.0/24  # Only home network
# Instead of: 0.0.0.0/0
```

**Benefits**:
- :icon{name="lucide:home"} Access home services
- :icon{name="lucide:globe"} Normal internet speed
- :icon{name="lucide:bar-chart"} Less VPN bandwidth

## Traffic Statistics :icon{name="lucide:bar-chart"}

Web UI shows for each client:
- :icon{name="lucide:upload"} **Download**: Data received
- :icon{name="lucide:download"} **Upload**: Data sent
- :icon{name="lucide:clock"} **Last Seen**: When last connected
- :icon{name="lucide:trending-up"} **Charts**: Bandwidth over time

## Common Use Cases

### 1. Secure Public WiFi :icon{name="lucide:coffee"}
```
Coffee Shop WiFi → WireGuard → Your Server → Internet
```
Encrypt traffic on untrusted networks.

### 2. Access Home Network :icon{name="lucide:home"}
```
You (anywhere) → VPN → Home Network → NAS, Printer, etc.
```
Access devices as if you're home.

### 3. Bypass Geo-Restrictions :icon{name="lucide:globe"}
```
Your Location → VPN (Server Country) → Streaming Service
```
Appear to be in server's location.

### 4. Privacy from ISP :icon{name="lucide:hat-glasses"}
```
Your Device → Encrypted Tunnel → Your Server → Internet
```
ISP only sees encrypted traffic to your server.

### 5. Multiple Locations 🗺️
Deploy VPN servers in different countries:
- USA server for US content
- EU server for European services
- Home server for local access

## Security Features :icon{name="lucide:lock"}

### Encryption
- **Protocol**: Noise Protocol Framework
- **Key Exchange**: Curve25519
- **Cipher**: ChaCha20-Poly1305
- **Hash**: BLAKE2s

**Translation**: Military-grade encryption! :icon{name="lucide:dumbbell"}

### Authentication
- **Public/Private Keys**: Per-client keypairs
- **Preshared Keys**: Extra security layer
- **Endpoint Verification**: Prevents spoofing

### Privacy
- **No Logs**: WireGuard doesn't log by default
- **Perfect Forward Secrecy**: Past sessions stay secure
- **IP Masquerading**: Hides your real IP

## DNS Configuration :icon{name="lucide:globe"}

### Default DNS (Cloudflare)
```bash
WG_DEFAULT_DNS=1.1.1.1
```

### Other Options

**Google**:
```bash
WG_DEFAULT_DNS=8.8.8.8
```

**Quad9** (Security):
```bash
WG_DEFAULT_DNS=9.9.9.9
```

**AdGuard** (Ad-blocking):
```bash
WG_DEFAULT_DNS=94.140.14.14
```

**Custom** (Your Pi-hole):
```bash
WG_DEFAULT_DNS=192.168.1.2
```

## Performance Optimization :icon{name="lucide:zap"}

### Enable BBR (Better Congestion Control)
```bash
# On host
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
```

### Increase MTU
```ini
# In client config
[Interface]
MTU = 1420  # Default, try 1500 if stable
```

### Persistent Keepalive
```ini
# Keep connection alive through NAT
PersistentKeepalive = 25
```

## Troubleshooting :icon{name="lucide:wrench"}

**Q: Can't connect to VPN?**
```bash
# Check server is running
docker logs vpn_app

# Verify port is open
nc -zvu vpn.pivoine.art 51820

# Check firewall
sudo ufw status
```

**Q: Connected but no internet?**
```bash
# Verify IP forwarding
sysctl net.ipv4.ip_forward
# Should return: 1

# Check NAT rules
sudo iptables -t nat -L
```

**Q: Slow speeds?**
- Check server bandwidth
- Try different MTU values
- Enable BBR congestion control
- Use split-tunnel for non-sensitive traffic

**Q: Client won't auto-reconnect?**
- Add `PersistentKeepalive = 25` to config
- Check client has network connectivity

**Q: DNS not working?**
```bash
# Test DNS from client
nslookup google.com

# Change DNS in config
DNS = 8.8.8.8
```

## Mobile Tips :icon{name="lucide:phone"}

### iOS
- **On-Demand**: Auto-connect on untrusted WiFi
- **Shortcuts**: Create Siri shortcuts
- **Widget**: Quick toggle from home screen

### Android  
- **Always-On**: VPN reconnects automatically
- **Kill Switch**: Block internet if VPN drops
- **Split Tunneling**: Exclude specific apps

## Advanced Configuration

### IPv6 Support
Already configured!
```yaml
enable_ipv6: true
subnet: fdcc:ad94:bacf:61a3::/64
```

### Custom Routing

**Route only specific subnets**:
```ini
AllowedIPs = 192.168.1.0/24, 10.0.0.0/24
```

**Block specific IPs**:
```bash
# On server
iptables -A FORWARD -d 192.168.1.100 -j DROP
```

### Port Forwarding

Forward ports through VPN:
```bash
# Forward port 8080 to client
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to 10.42.0.2:8080
```

## Monitoring & Logs

### Check Connection Status
```bash
# Via web UI
https://vpn.pivoine.art

# Or check container
docker exec vpn_app wg show
```

### View Logs
```bash
docker logs vpn_app -f
```

### Bandwidth Stats
Web UI shows real-time graphs for each client!

## Backup & Restore :icon{name="lucide:refresh-cw"}

### Backup Configuration
```bash
# Backup WireGuard configs
docker exec vpn_app tar -czf /tmp/wg-backup.tar.gz /etc/wireguard
docker cp vpn_app:/tmp/wg-backup.tar.gz ./backups/
```

### Restore
```bash
# Copy backup to container
docker cp ./backups/wg-backup.tar.gz vpn_app:/tmp/

# Extract
docker exec vpn_app tar -xzf /tmp/wg-backup.tar.gz -C /

# Restart
docker compose restart
```

## Security Best Practices :icon{name="lucide:shield"}

1. **Strong Password**: Use bcrypt hash for web UI
2. **Regular Updates**: Keep WG-Easy updated
3. **Firewall**: Only expose necessary ports
4. **Client Management**: Remove inactive clients
5. **Monitoring**: Watch for unusual traffic
6. **Backups**: Regular config backups
7. **Access Control**: Limit who can create clients

## Why Self-Host a VPN?

- :icon{name="lucide:lock"} **Full Control**: Your server, your rules
- :icon{name="lucide:dollar-sign"} **Cost Effective**: No monthly fees
- :icon{name="lucide:rocket"} **Performance**: Direct to your server
- :icon{name="lucide:hat-glasses"} **Privacy**: No third-party logging
- :icon{name="lucide:globe"} **Flexibility**: Use any server location
- :icon{name="lucide:bar-chart"} **Transparency**: You know what's happening
- :icon{name="lucide:hammer"} **Customization**: Configure exactly as needed

## Resources

- [WireGuard Documentation](https://www.wireguard.com/)
- [WG-Easy GitHub](https://github.com/wg-easy/wg-easy)
- [WireGuard Clients](https://www.wireguard.com/install/)

---

*"Privacy is not about having something to hide. It's about protecting what you value."* - VPN Philosophy :icon{name="lucide:lock"}:icon{name="lucide:sparkles"}
