# Timezone Configuration Guide

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
