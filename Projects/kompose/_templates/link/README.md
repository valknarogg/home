# Linkwarden Stack Template

Linkwarden is a self-hosted, collaborative bookmark manager that helps you organize and save your favorite links with features like tagging, collections, full-text search, and automatic archiving.

## Features

- 📚 Organize bookmarks with collections and tags
- 🔍 Full-text search across all saved links
- 📸 Automatic screenshot capture
- 📦 Archive web pages for offline access
- 👥 Collaboration with teams
- 🔒 SSO integration with Keycloak
- 📧 Email notifications
- 🚀 Fast Redis caching
- 📊 MQTT event publishing

## Quick Start

Generate this stack using:

```bash
./kompose-generate.sh link
```

Then start the stack:

```bash
docker compose -f link/compose.yaml up -d
```

## Dependencies

**Required:**
- `core` - PostgreSQL, Redis, and MQTT broker
- `proxy` - Traefik reverse proxy

**Optional:**
- `auth` - SSO authentication via Keycloak
- `messaging` - Email notifications via Mailhog

## Configuration

See `kompose.yml` for full configuration details and environment variables.

## Documentation

Full documentation is included in the `kompose.yml` file and will be available after stack generation.
