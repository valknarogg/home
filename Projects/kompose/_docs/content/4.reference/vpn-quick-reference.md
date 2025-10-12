# VPN Quick Reference

Quick reference for the WireGuard VPN stack.

## Quick Commands

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
```

## Access WG-Easy UI

**URL:** `https://vpn.yourdomain.com`  
**Password:** Check `secrets.env` → `VPN_PASSWORD`

## Add New Client

1. Access WG-Easy UI
2. Click **New Client**
3. Enter client name
4. Download config or scan QR code

## Client Configuration

### Mobile (iOS/Android)
1. Install WireGuard app
2. Scan QR code from WG-Easy UI
3. Enable VPN

### Desktop (Linux/macOS/Windows)
1. Install WireGuard
2. Download config from WG-Easy UI
3. Import config
4. Connect

## Environment Variables

Located in `vpn/.env`:

```bash
WG_HOST=vpn.yourdomain.com     # Public VPN endpoint
VPN_PASSWORD=<secret>           # UI password
VPN_PORT=51820                  # WireGuard port
```

## Firewall Configuration

```bash
# Allow WireGuard port
sudo ufw allow 51820/udp

# Verify
sudo ufw status
```

## Troubleshooting

### Can't connect to VPN
```bash
# Check VPN is running
./kompose.sh status vpn

# Check firewall
sudo ufw status | grep 51820

# Check logs
docker logs vpn_wg-easy
```

### Slow VPN speed
- Check server bandwidth
- Try different VPN server location
- Reduce MTU in client config

### DNS not working
Add to client config:
```
DNS = 1.1.1.1, 1.0.0.1
```

## See Also

- [VPN Integration Guide](/guide/vpn-integration)
- [VPN Stack Details](/stacks/vpn)
