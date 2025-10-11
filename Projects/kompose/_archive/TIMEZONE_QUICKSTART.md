# Timezone Configuration - Quick Start Guide

## ✅ Step 1: Root .env Configuration (DONE)

The root `.env` file has been updated with the timezone configuration:

```bash
# Default timezone for all containers
# Can be overridden in individual stack .env files if needed
# Common values: Europe/Amsterdam, Europe/Berlin, America/New_York, etc.
TIMEZONE=Europe/Amsterdam
```

## 📋 Step 2: Add TZ to Compose Files

You now need to add the `TZ` environment variable to each service in your compose files.

### Example: Before and After

**BEFORE** (`auth/compose.yaml`):
```yaml
services:
  keycloak:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_keycloak
    restart: unless-stopped
    environment:
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
      KC_DB_USERNAME: ${DB_USER}
      # ... other variables
```

**AFTER** (with timezone):
```yaml
services:
  keycloak:
    image: ${DOCKER_IMAGE}
    container_name: ${COMPOSE_PROJECT_NAME}_keycloak
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
      KC_DB_USERNAME: ${DB_USER}
      # ... other variables
```

## 🚀 Automatic Update Script

Run the provided script to automatically add timezone to all compose files:

### Option 1: Using the shell wrapper
```bash
chmod +x add-timezone.sh
./add-timezone.sh
```

### Option 2: Using Python directly
```bash
chmod +x add-timezone.py
./add-timezone.py
```

The script will:
- ✓ Find all compose.yaml files in subdirectories
- ✓ Add `TZ: ${TIMEZONE:-Europe/Amsterdam}` to each service
- ✓ Create backup files (*.bak) before making changes
- ✓ Skip files that already have TZ configured
- ✓ Show a summary of changes

## 🔄 Step 3: Apply Changes

After running the script, restart your containers to apply the timezone:

```bash
# Option 1: Restart all stacks
cd /home/valknar/Projects/kompose
for dir in */; do
  if [ -f "$dir/compose.yaml" ]; then
    echo "Restarting $dir..."
    cd "$dir" && docker compose up -d && cd ..
  fi
done

# Option 2: Restart individual stacks
cd auth && docker compose up -d
cd ../auto && docker compose up -d
# ... etc
```

## ✨ Verification

Check if timezone is correctly set:

```bash
# Check a container's timezone
docker exec auth_keycloak date

# Check the TZ environment variable
docker exec auth_keycloak printenv TZ

# View the parsed compose configuration
cd auth && docker compose config | grep TZ
```

## 📦 Affected Stacks

The following stacks will be updated:
- auth (Keycloak)
- auto (Semaphore)
- blog (Static web server)
- chain (OpenFaaS - if applicable)
- chat (Gotify)
- code (Code server)
- dash (Dashboard)
- data (PostgreSQL, Redis, pgAdmin)
- dock (Portainer)
- docs (Documentation)
- home (Homepage)
- link (Link shortener)
- news (News aggregator)
- proxy (Traefik)
- sexy (UI services)
- trace (SigNoz)
- track (Umami)
- vault (Vaultwarden)
- vpn (WireGuard)

## 🎯 Manual Addition (for new stacks)

When creating new stacks, always add this line to the environment section:

```yaml
environment:
  TZ: ${TIMEZONE:-Europe/Amsterdam}
  # ... your other environment variables
```

## 📖 Full Documentation

For detailed information, see [TIMEZONE_CONFIG.md](./TIMEZONE_CONFIG.md)

## ⚠️ Important Notes

1. **Review before applying**: The script creates `.bak` backup files. Review the changes before committing.
2. **Remove backups**: After verifying changes work correctly, remove `.bak` files:
   ```bash
   find . -name "compose.yaml.bak" -delete
   ```
3. **Test first**: Consider testing on a single stack before applying to all.
4. **Stack overrides**: Individual stacks can override the timezone in their local `.env` file if needed.

## 🆘 Troubleshooting

If containers don't show the correct timezone after updating:

1. Force recreate containers:
   ```bash
   docker compose up -d --force-recreate
   ```

2. Check the compose configuration:
   ```bash
   docker compose config
   ```

3. Verify the root `.env` file is being loaded

4. Some containers may need additional timezone configuration (see TIMEZONE_CONFIG.md)
