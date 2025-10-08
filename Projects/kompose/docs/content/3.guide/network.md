---
title: Network Architecture
description: Understanding Kompose network design
---

### Single Network Design

All stacks communicate through a unified Docker network:

```
┌─────────────────────────────────────────────────┐
│          kompose Network (Bridge)               │
│                                                 │
│  ┌───────┐  ┌───────┐  ┌──────┐  ┌──────┐    │
│  │ Blog  │  │ News  │  │ Auth │  │ Data │    │
│  └───────┘  └───────┘  └──────┘  └──────┘    │
│      │          │          │         │         │
│  ┌───────────────────────────────────────┐    │
│  │         Traefik (Reverse Proxy)       │    │
│  └───────────────────────────────────────┘    │
│                    │                            │
└────────────────────┼────────────────────────────┘
                     │
              ┌──────┴──────┐
              │  Internet   │
              └─────────────┘
```

### Network Configuration

**Default network:** `kompose` (defined in root `.env`)

**Override network:**
```bash
# Temporary override
./kompose.sh --network staging "*" up -d

# Permanent override
echo "NETWORK_NAME=production" >> .env
```

### Special Network Cases

**trace stack** - Dual network setup:
- `kompose` - External access via Traefik
- `signoz` - Internal component communication

**vpn stack** - Dual network setup:
- `kompose` - Web UI access
- `wg` - WireGuard tunnel network
