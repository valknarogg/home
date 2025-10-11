# 🌍 Timezone Configuration - Implementation Summary

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
