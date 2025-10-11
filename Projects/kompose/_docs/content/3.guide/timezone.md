---
title: Timezone Configuration
description: Configure timezone for all kompose services
---

# Timezone Configuration

## Overview

This guide consolidates all timezone configuration documentation for kompose services.


## TIMEZONE_CONFIG


## Overview

All stacks in the Kompose project can now use a centralized timezone configuration through the root `.env` file. The default timezone is set to `Europe/Amsterdam`, but can be easily changed.

## Configuration

### Root .env File

The timezone is configured in the root `/home/valknar/Projects/kompose/.env` file:

```bash
# Default timezone for all containers
# Can be overridden in individual stack .env files if needed
# Common values: Europe/Amsterdam, Europe/Berlin, America/New_York, etc.
TIMEZONE=Europe/Amsterdam
```

### Changing the Timezone

To change the timezone for all stacks:

1. Edit the root `.env` file
2. Change the `TIMEZONE` value to your desired timezone
3. Restart the affected containers: `docker compose up -d` in each stack directory

### Common Timezone Values

- `Europe/Amsterdam`
- `Europe/Berlin`
- `Europe/London`
- `Europe/Paris`
- `America/New_York`
- `America/Los_Angeles`
- `America/Chicago`
- `Asia/Tokyo`
- `Asia/Shanghai`
- `Australia/Sydney`

For a complete list, see: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

## Adding Timezone to Stack Compose Files

### Automatic Method

Use the provided Python script to automatically add timezone configuration to all compose files:

```bash
# Make script executable (first time only)
chmod +x add-timezone.py

# Run the script
./add-timezone.py
```

The script will:
- Find all `compose.yaml` files in stack subdirectories
- Add `TZ: ${TIMEZONE:-Europe/Amsterdam}` to each service's environment section
- Create `.bak` backup files before making changes
- Skip files that already have TZ configured
- Provide a summary of changes

### Manual Method

If you prefer to add timezone manually or for new stacks, add the following to the `environment:` section of each service:

```yaml
services:
  myservice:
    image: some-image
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      # ... other environment variables
```

The format `${TIMEZONE:-Europe/Amsterdam}` means:
- Use the `TIMEZONE` variable from `.env` if it exists
- Fall back to `Europe/Amsterdam` if the variable is not set

## Stack-Specific Timezone Override

If a specific stack needs a different timezone, you can override it in that stack's `.env` file:

```bash
# In /home/valknar/Projects/kompose/mystack/.env
TIMEZONE=America/New_York
```

## Verification

To verify the timezone is correctly applied to a container:

```bash
# Check the timezone of a running container
docker exec <container_name> date

# Or check the TZ environment variable
docker exec <container_name> printenv TZ
```

## Why Timezone Configuration Matters

Proper timezone configuration ensures:
- Log timestamps match your local time
- Scheduled tasks run at the expected times
- Database timestamps are consistent
- Application behavior matches user expectations

## Troubleshooting

### Container still shows wrong timezone

1. Make sure the container was restarted after adding the TZ variable:
   ```bash
   docker compose up -d
   ```

2. Check if the environment variable is properly set:
   ```bash
   docker compose config
   ```

3. Some containers may need additional configuration or volume mounts for timezone data

### Changes not taking effect

1. Verify the root `.env` file contains the TIMEZONE variable
2. Ensure the compose file has the TZ environment variable
3. Restart the containers with `docker compose up -d --force-recreate`

## Example: Complete Service Configuration

```yaml
services:
  postgres:
    image: postgres:latest
    container_name: mystack_postgres
    restart: unless-stopped
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - kompose_network
```

## Notes

- The timezone configuration is applied at the container level via the `TZ` environment variable
- This is the standard method supported by most Docker images
- Some specialized images may require different timezone configuration methods
- Always test timezone changes in a development environment first

## TIMEZONE_QUICKSTART


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

## TIMEZONE_README


All stacks in this Kompose project are now configured to use a centralized timezone setting through the root `.env` file.

## 🚀 Quick Start (3 Steps)

```bash
# 1. Make scripts executable
chmod +x add-timezone.sh restart-all-stacks.sh preview-timezone.py

# 2. Add timezone to all compose files
./add-timezone.sh

# 3. Restart stacks to apply changes
./restart-all-stacks.sh
```

That's it! All your containers will now use `Europe/Amsterdam` timezone (or whatever you set in `.env`).

## 📋 What's Included

### Configuration Files
- ✅ **`.env`** - Updated with `TIMEZONE=Europe/Amsterdam`
- 📄 **`.gitignore`** - Updated to ignore `.bak` backup files

### Scripts
- 🔧 **`add-timezone.sh`** - Adds TZ environment variable to all compose files
- 🔧 **`add-timezone.py`** - Python implementation (called by .sh wrapper)
- 🔧 **`restart-all-stacks.sh`** - Restarts all stacks to apply changes
- 🔍 **`preview-timezone.py`** - Preview changes before applying

### Documentation
- 📖 **`TIMEZONE_SUMMARY.md`** - Complete implementation summary
- 📖 **`TIMEZONE_QUICKSTART.md`** - Step-by-step guide
- 📖 **`TIMEZONE_CONFIG.md`** - Detailed configuration guide
- 📖 **`TIMEZONE_README.md`** - This file

## 🎯 Preview Before Applying (Optional)

Want to see what changes will be made? Preview a single file first:

```bash
chmod +x preview-timezone.py
./preview-timezone.py auth/compose.yaml
```

This shows exactly what will be added without making any changes.

## 🔄 How It Works

1. **Root `.env`** defines: `TIMEZONE=Europe/Amsterdam`
2. **Each compose file** gets: `TZ: ${TIMEZONE:-Europe/Amsterdam}`
3. **Docker** applies the timezone to all containers
4. **Result**: All logs, timestamps, and scheduled tasks use your timezone!

### Example Service Configuration

```yaml
services:
  postgres:
    image: postgres:latest
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}  # 🆕 Added automatically
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
```

## ⚙️ Changing the Timezone

### For All Stacks
Edit the root `.env` file:
```bash
# Change from Europe/Amsterdam to your timezone
TIMEZONE=America/New_York
```

Then restart stacks:
```bash
./restart-all-stacks.sh
```

### For a Single Stack
Create or edit the stack's local `.env` file:
```bash
# In auth/.env
TIMEZONE=Asia/Tokyo
```

Then restart that stack:
```bash
cd auth && docker compose up -d
```

## 🌐 Common Timezones

| Region | Timezone | UTC Offset |
|--------|----------|------------|
| Amsterdam | `Europe/Amsterdam` | UTC+1/+2 |
| Berlin | `Europe/Berlin` | UTC+1/+2 |
| London | `Europe/London` | UTC+0/+1 |
| New York | `America/New_York` | UTC-5/-4 |
| Los Angeles | `America/Los_Angeles` | UTC-8/-7 |
| Tokyo | `Asia/Tokyo` | UTC+9 |
| Sydney | `Australia/Sydney` | UTC+10/+11 |

[Full list of timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

## ✅ Verification

Check if timezone is correctly applied:

```bash
# View current timezone
docker exec <container_name> date

# Check TZ environment variable
docker exec <container_name> printenv TZ

# View compose configuration
cd <stack> && docker compose config | grep TZ
```

## 🎓 Understanding the Format

The format `${TIMEZONE:-Europe/Amsterdam}` means:
- Use `TIMEZONE` from `.env` if set
- Otherwise, fall back to `Europe/Amsterdam`
- This ensures it works even if `.env` is missing

## 📦 Affected Stacks

All stacks in subdirectories will be configured:
- auth, auto, blog, chain, chat, code, dash, data
- dock, docs, home, link, news, proxy, sexy
- trace, track, vault, vpn

## 🔍 Troubleshooting

### Scripts won't run
```bash
chmod +x *.sh *.py
```

### Timezone not applied
```bash
# Force recreate
docker compose up -d --force-recreate

# Check configuration
docker compose config
```

### Wrong time showing
```bash
# Verify root .env
grep TIMEZONE .env

# Check for stack override
grep TIMEZONE <stack>/.env

# Verify container env
docker exec <container> env | grep TZ
```

## 📚 More Information

- **Quick Start**: See `TIMEZONE_QUICKSTART.md` for detailed steps
- **Full Guide**: See `TIMEZONE_CONFIG.md` for comprehensive documentation
- **Summary**: See `TIMEZONE_SUMMARY.md` for implementation details

## 🤝 Contributing

When adding new stacks, always include timezone configuration:

```yaml
services:
  your-service:
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}
```

## 📝 Notes

- Changes require container restart to take effect
- Backup files (`.bak`) are automatically created
- Backup files are git-ignored and can be safely deleted after verification
- Some containers may need additional timezone configuration (rare)

---

**Need Help?** Check the documentation files or open an issue!

## TIMEZONE_SUMMARY


## What Was Done

✅ **Root .env file updated**
- Added `TIMEZONE=Europe/Amsterdam` variable to `/home/valknar/Projects/kompose/.env`
- This serves as the default timezone for all stacks
- Can be easily changed to any valid timezone

✅ **Scripts created**
- `add-timezone.py` - Python script to automatically add TZ to all compose files
- `add-timezone.sh` - Shell wrapper for the Python script
- `restart-all-stacks.sh` - Script to restart all stacks after changes

✅ **Documentation created**
- `TIMEZONE_CONFIG.md` - Comprehensive timezone configuration guide
- `TIMEZONE_QUICKSTART.md` - Quick start guide with step-by-step instructions
- `TIMEZONE_SUMMARY.md` - This summary document

## What You Need to Do

### Step 1: Make Scripts Executable
```bash
cd /home/valknar/Projects/kompose
chmod +x add-timezone.py add-timezone.sh restart-all-stacks.sh
```

### Step 2: Add Timezone to Compose Files
```bash
./add-timezone.sh
```

This will:
- Scan all subdirectories for compose.yaml files
- Add `TZ: ${TIMEZONE:-Europe/Amsterdam}` to each service's environment
- Create backup files (*.bak)
- Show summary of changes

### Step 3: Review Changes
Check a few modified files to ensure changes look correct:
```bash
# Example: Check the auth stack
cat auth/compose.yaml | grep -A 2 "environment:"

# Compare with backup
diff auth/compose.yaml auth/compose.yaml.bak
```

### Step 4: Apply Changes by Restarting Stacks
```bash
./restart-all-stacks.sh
```

Or restart stacks individually:
```bash
cd auth && docker compose up -d
cd ../auto && docker compose up -d
# etc.
```

### Step 5: Verify Timezone
```bash
# Check timezone of a container
docker exec auth_keycloak date

# Should show time in Europe/Amsterdam timezone (CET/CEST)
```

### Step 6: Clean Up Backups (Optional)
After verifying everything works:
```bash
find . -name "compose.yaml.bak" -delete
```

## File Structure

```
/home/valknar/Projects/kompose/
├── .env                          # ✅ Updated with TIMEZONE variable
├── add-timezone.py               # 🆕 Script to add TZ to compose files
├── add-timezone.sh               # 🆕 Shell wrapper script
├── restart-all-stacks.sh         # 🆕 Script to restart all stacks
├── TIMEZONE_CONFIG.md            # 🆕 Detailed configuration guide
├── TIMEZONE_QUICKSTART.md        # 🆕 Quick start guide
├── TIMEZONE_SUMMARY.md           # 🆕 This summary
├── auth/
│   ├── compose.yaml              # ⏳ Will be updated by script
│   └── .env                      # Can override TIMEZONE if needed
├── auto/
│   ├── compose.yaml              # ⏳ Will be updated by script
│   └── .env
└── ... (other stacks)
```

## How It Works

1. **Root Configuration**: The `TIMEZONE` variable in the root `.env` file sets the default
2. **Variable Expansion**: Each compose file uses `${TIMEZONE:-Europe/Amsterdam}`
3. **Fallback**: If TIMEZONE is not set, it falls back to Europe/Amsterdam
4. **Override**: Individual stacks can override by setting TIMEZONE in their local `.env`

## Timezone Format in Compose Files

Each service will have TZ added as the first environment variable:

```yaml
services:
  myservice:
    image: some-image
    environment:
      TZ: ${TIMEZONE:-Europe/Amsterdam}  # 🆕 Added by script
      OTHER_VAR: value
      ANOTHER_VAR: value
```

## Stack-Specific Override Example

If you need a specific stack to use a different timezone:

```bash
# In /home/valknar/Projects/kompose/auto/.env
TIMEZONE=America/New_York
```

## Changing the Global Timezone

To change the default timezone for all stacks:

1. Edit `/home/valknar/Projects/kompose/.env`
2. Change `TIMEZONE=Europe/Amsterdam` to your desired timezone
3. Restart affected stacks: `./restart-all-stacks.sh`

## Common Timezones

- `Europe/Amsterdam` (CET/CEST, UTC+1/+2)
- `Europe/Berlin` (CET/CEST, UTC+1/+2)
- `Europe/London` (GMT/BST, UTC+0/+1)
- `America/New_York` (EST/EDT, UTC-5/-4)
- `America/Los_Angeles` (PST/PDT, UTC-8/-7)
- `Asia/Tokyo` (JST, UTC+9)
- `UTC` (Universal Coordinated Time)

Full list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

## Benefits

✅ **Consistent timestamps** across all services and logs
✅ **Correct scheduling** for cron jobs and scheduled tasks
✅ **Better debugging** with logs in your local timezone
✅ **Easy maintenance** with centralized configuration
✅ **Stack flexibility** with override capability

## Troubleshooting

### Scripts don't run
```bash
# Make sure they're executable
chmod +x *.sh *.py

# Check Python version (needs 3.x)
python3 --version
```

### Timezone not applied
```bash
# Force recreate containers
docker compose up -d --force-recreate

# Check if TZ variable is in config
docker compose config | grep TZ
```

### Wrong timezone showing
```bash
# Verify TIMEZONE in root .env
cat .env | grep TIMEZONE

# Check if stack has local override
cat <stack>/.env | grep TIMEZONE

# Verify container environment
docker exec <container> printenv | grep TZ
```

## Quick Command Reference

```bash
# Add timezone to all compose files
./add-timezone.sh

# Restart all stacks
./restart-all-stacks.sh

# Check a specific container's timezone
docker exec <container_name> date

# View parsed compose config with variables expanded
cd <stack> && docker compose config

# Force recreate a single stack
cd <stack> && docker compose up -d --force-recreate

# Remove all backup files
find . -name "compose.yaml.bak" -delete
```

## Next Steps

1. ✅ Scripts are ready - just need to be made executable
2. ⏳ Run `add-timezone.sh` to update all compose files
3. ⏳ Run `restart-all-stacks.sh` to apply changes
4. ⏳ Verify with `docker exec <container> date`
5. ⏳ Clean up `.bak` files once confirmed working

## Support

For detailed information, see:
- `TIMEZONE_QUICKSTART.md` - Step-by-step guide
- `TIMEZONE_CONFIG.md` - Comprehensive documentation

For issues or questions about specific stacks, check the individual stack documentation or the Docker image's timezone configuration requirements.
