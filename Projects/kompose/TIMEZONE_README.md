# 🌍 Timezone Configuration for Kompose Stacks

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
