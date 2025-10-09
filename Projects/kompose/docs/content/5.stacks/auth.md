---
title: Auth - The Bouncer at Your Digital Club
description: "You shall not pass... without proper credentials!"
navigation:
  icon: i-lucide-lock-keyhole
---

> *"You shall not pass... without proper credentials!"* - Keycloak, probably

## What's This All About?

This stack is your authentication and identity management powerhouse. Think of it as the super-sophisticated bouncer for all your services - checking IDs, managing VIP lists, and making sure only the cool kids (authorized users) get into your digital club.

## The Star of the Show

### :icon{name="lucide:drama"} Keycloak

**Container**: `auth_keycloak`  
**Image**: `quay.io/keycloak/keycloak:latest`  
**Home**: https://auth.pivoine.art

Keycloak is like having a Swiss Army knife for authentication. It handles:
- :icon{name="lucide:user"} **Single Sign-On (SSO)**: Log in once, access everything. Magic!
- :icon{name="lucide:ticket"} **Identity Brokering**: Connect with Google, GitHub, and other OAuth providers
- :icon{name="lucide:users"} **User Management**: Keep track of who's who in your digital zoo
- :icon{name="lucide:lock"} **OAuth 2.0 & OpenID Connect**: Industry-standard security protocols (the fancy stuff)
- :icon{name="lucide:shield"} **Authorization Services**: Fine-grained control over who can do what

## Configuration Breakdown

### Database Connection
Keycloak stores all its secrets (not literally, they're hashed!) in PostgreSQL:
```
Database: keycloak
Host: Shared data stack (postgres)
```

### Admin Access
**Username**: `admin` (creative, right?)  
**Password**: Check your `.env` file (and change it, please!)

### Proxy Mode
Running in `edge` mode because we're living on the edge (behind Traefik)! This tells Keycloak to trust the proxy headers for HTTPS and hostname info.

## How It Works

1. **Startup**: Keycloak boots up and connects to the PostgreSQL database
2. **Health Check**: Every 30 seconds, it's like "Hey, I'm still alive!" (/health endpoint)
3. **Proxy Magic**: Traefik routes `https://auth.pivoine.art` → Keycloak
4. **SSL Termination**: Traefik handles HTTPS, Keycloak just chills on HTTP internally

## Environment Variables Explained

| Variable | What It Does | Cool Factor |
|----------|-------------|-------------|
| `KC_DB` | Database type (postgres) | :icon{name="simple-icons:postgresql"} Elephants never forget |
| `KC_DB_URL` | JDBC connection string | :icon{name="lucide:plug"} The digital umbilical cord |
| `KC_HOSTNAME` | Public-facing URL | :icon{name="lucide:globe"} Your internet identity |
| `KC_PROXY` | Proxy mode setting | :icon{name="lucide:drama"} Trust the middleman |
| `KC_FEATURES` | Enabled features (docker) | 🐳 Whale hello there! |

## Ports & Networking

- **Internal Port**: 8080 (Keycloak's cozy home)
- **External Access**: Via Traefik at https://auth.pivoine.art
- **Network**: `kompose` (the gang's all here)

## Health & Monitoring

Keycloak does a self-check every 30 seconds:
```bash
curl -f http://localhost:8080/health
```
If it doesn't respond within 5 seconds or fails 3 times in a row, Docker knows something's up and will restart it (like turning it off and on again, but automated).

## Common Tasks

### Access the Admin Console
```
URL: https://auth.pivoine.art
Login: Your admin credentials from .env
```

### View Logs
```bash
docker logs auth_keycloak -f
```

### Restart After Config Changes
```bash
docker compose restart
```

### Connect a New Application
1. Log into Keycloak admin console
2. Create a new Client
3. Configure redirect URIs
4. Grab your client ID and secret
5. Integrate with your app (check Keycloak docs)

## Integration Tips

When integrating other services with Keycloak:
- **Discovery URL**: `https://auth.pivoine.art/realms/{realm}/.well-known/openid-configuration`
- **Default Realm**: Usually "master" but create your own!
- **Client Types**: Public (SPAs), Confidential (Backend apps)

## Troubleshooting

**Q: Can't log in to admin console?**  
A: Check your `KC_ADMIN_USERNAME` and `KC_ADMIN_PASSWORD` in `.env`

**Q: Getting SSL errors?**  
A: Make sure `KC_HOSTNAME` matches your Traefik setup

**Q: Changes not taking effect?**  
A: Clear your browser cache, Keycloak loves to cache things

**Q: Database connection issues?**  
A: Ensure the `data` stack is running and healthy

## Security Notes :icon{name="lucide:lock"}

- :icon{name="lucide:siren"} **Change the default admin password** (seriously, do it now)
- :icon{name="lucide:lock-keyhole"} Database credentials are shared via root `.env`
- :icon{name="lucide:globe"} Always access via HTTPS in production
- :icon{name="lucide:file-text"} Enable audit logging for compliance
- :icon{name="lucide:target"} Use realms to separate different applications/teams

## Fun Facts

- Keycloak is maintained by Red Hat (yeah, the Linux people!)
- It supports social login with Google, Facebook, GitHub, and more
- You can theme it to match your brand (goodbye boring login pages!)
- It handles thousands of users without breaking a sweat

## Resources

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [Getting Started Guide](https://www.keycloak.org/guides#getting-started)
- [Admin REST API](https://www.keycloak.org/docs-api/latest/rest-api/)

---

*Remember: With great authentication power comes great responsibility. Don't be the person who uses "admin/admin" in production.* :icon{name="lucide:shield-check"}
