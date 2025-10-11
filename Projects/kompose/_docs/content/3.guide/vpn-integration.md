---
title: VPN Integration Guide
description: Integrate VPN with your entire kompose infrastructure for secure private intranet access
---

# VPN Integration Guide - Private Intranet Setup

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

For the complete VPN integration documentation including service access patterns, advanced configurations, and security hardening, see [VPN_INTEGRATION.md](https://github.com/your-repo/kompose/blob/main/_archive/VPN_INTEGRATION.md) in the archive.

## Quick Integration Patterns

### Pattern 1: Access Core Services

**PostgreSQL Database:**
```bash
psql -h core-postgres -U kompose -d myapp
```

**Redis Cache:**
```bash
redis-cli -h core-redis -a PASSWORD
```

**MQTT Broker:**
```bash
mosquitto_sub -h core-mqtt -t 'sensors/#'
```

### Pattern 2: Access Application Services

**n8n (Automation):**
```bash
# Via browser
https://chain.pivoine.art

# Direct access
http://chain_n8n:5678
```

**Vaultwarden (Password Manager):**
```bash
https://vault.pivoine.art
```

**Gotify (Notifications):**
```bash
https://chat.pivoine.art
```

### Pattern 3: Remote Development

Connect to your development environment from anywhere:

```bash
# 1. Connect to VPN
# 2. Access services as if local
psql -h core-postgres -U dev -d development
redis-cli -h core-redis
git clone http://code-gitea:3000/user/repo.git
```

## DNS Configuration

### Option 1: Hosts File (Simple)

Add to your `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):

```
10.42.42.X core-postgres
10.42.42.X core-redis  
10.42.42.X chain_n8n
```

### Option 2: Internal DNS Server

See the full integration guide for setting up CoreDNS for automatic service discovery.

## Security Best Practices

1. **Network Segmentation** - Isolate sensitive services
2. **Firewall Rules** - Restrict access by IP
3. **Client Restrictions** - Limit AllowedIPs per client
4. **Rate Limiting** - Prevent abuse
5. **Audit Logging** - Track all access
6. **Regular Rotation** - Update client configs periodically

## Monitoring

Monitor VPN and service access:

```bash
# Check VPN connections
docker exec vpn_app wg show wg0

# Monitor database connections
docker exec core-postgres psql -U kompose -c "SELECT * FROM pg_stat_activity;"

# Check Redis connections
docker exec core-redis redis-cli CLIENT LIST
```

## Troubleshooting

**Cannot access services via VPN:**

1. Verify VPN connection: `ping 10.42.42.42`
2. Check service is running: `docker ps | grep SERVICE`
3. Test direct access: `telnet SERVICE_IP PORT`
4. Verify AllowedIPs includes internal network
5. Check firewall rules

For detailed troubleshooting steps, see the [VPN Stack Documentation](/stacks/vpn).

## Related Documentation

- [VPN Stack](/stacks/vpn) - VPN configuration and setup
- [Core Stack](/stacks/core) - Core infrastructure services
- [Chain Stack](/stacks/chain) - Automation services
- [Network Architecture](/guide/network) - Understanding kompose networking
