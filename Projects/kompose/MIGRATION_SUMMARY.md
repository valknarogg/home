# 🎉 Kompose Environment Configuration - Migration Complete!

## Summary of Changes

I've successfully set up a **centralized environment configuration system** for your Kompose project! Here's what's been done:

## ✅ What Was Created

### 1. New Configuration Files

**`.env.new`** - Complete centralized configuration
- All stack configurations in one place
- Stack-scoped variables (e.g., `CORE_`, `AUTH_`, `HOME_`)
- Shared variables for common settings
- Well-organized and documented sections
- Ready to replace your current `.env`

**`kompose-env.sh`** - Environment management module
- Loads and filters environment variables per stack
- Maps scoped variables to generic names
- Generates temporary `.env.generated` files
- Provides validation and debugging tools
- Handles secrets loading

**`kompose-stack.sh`** - Updated stack management (replaced)
- Integrated with new environment system
- Uses `run_compose()` helper for proper env loading
- Generates `.env.generated` automatically
- Maintains backward compatibility

**`migrate-to-centralized-env.sh`** - Migration script
- Backs up all existing `.env` files
- Removes individual stack `.env` files
- Installs new centralized `.env`
- Updates `.gitignore`
- Verifies migration success

### 2. Documentation

**`_docs/content/3.guide/environment-migration.md`**
- Complete migration guide
- Step-by-step instructions
- Troubleshooting tips
- Rollback procedures

**`_docs/content/4.reference/stack-configuration.md`**
- Configuration overview
- Variable naming conventions
- Usage examples
- Best practices

**`_docs/content/5.stacks/core.md`** - Updated
- Reflects new configuration system
- Shows how to use scoped variables
- Examples with new structure

## 📋 What You Need to Do

### Step 1: Review the New Configuration

```bash
# View the new centralized .env
cat .env.new

# Compare with your current .env
diff .env .env.new
```

The new `.env` includes:
- All core stack variables
- All auth stack variables
- All home stack variables
- All chain, code, proxy stack variables
- All utility stack variables (+custom/+utility)

### Step 2: Update Your Secrets

The `secrets.env.template` already has placeholders. You need to:

```bash
# If you don't have a secrets.env, create one
cp secrets.env.template secrets.env

# Edit with your actual secrets
vim secrets.env

# Or generate new ones
./kompose.sh secrets generate > temp-secrets.txt
# Review temp-secrets.txt and add to secrets.env
```

**Important secrets to set:**
```bash
# Core stack
CORE_DB_PASSWORD=xxx
CORE_REDIS_PASSWORD=xxx
CORE_REDIS_API_PASSWORD=xxx

# Auth stack
AUTH_KC_ADMIN_PASSWORD=xxx
AUTH_OAUTH2_CLIENT_SECRET=xxx
AUTH_OAUTH2_COOKIE_SECRET=xxx

# Other stacks as needed
```

### Step 3: Run the Migration

```bash
# Make the migration script executable
chmod +x migrate-to-centralized-env.sh

# Run the migration
./migrate-to-centralized-env.sh
```

This will:
1. Backup all existing `.env` files to `backups/env-migration-<timestamp>/`
2. Install the new `.env` (from `.env.new`)
3. Remove individual stack `.env` files
4. Update `.gitignore`
5. Verify the migration

### Step 4: Test Each Stack

After migration, test each stack individually:

```bash
# Test core stack
./kompose.sh env validate core
./kompose.sh up core
./kompose.sh status core

# Test auth stack
./kompose.sh env validate auth
./kompose.sh up auth
./kompose.sh status auth

# Test other stacks
./kompose.sh env validate home
./kompose.sh up home

# And so on...
```

### Step 5: Verify Everything Works

```bash
# Check all stacks
./kompose.sh status

# View environment for any stack
./kompose.sh env show core
./kompose.sh env show auth

# Check logs if issues
./kompose.sh logs core -f
```

## 🎯 Key Benefits

### Before (Old System)
```
kompose/
├── .env                    # Shared settings
├── core/.env              # Core settings
├── auth/.env              # Auth settings
├── home/.env              # Home settings
└── ... (scattered config)
```

### After (New System)
```
kompose/
├── .env                    # 🎯 ALL settings (centralized)
├── secrets.env            # 🔐 All secrets
├── kompose-env.sh         # ⚙️ Environment manager
├── core/.env.generated    # 🔄 Auto-generated
└── ... (automated)
```

**Advantages:**
- ✅ Single source of truth
- ✅ Easy to maintain
- ✅ Better organization
- ✅ Simpler testing
- ✅ Clear dependencies
- ✅ Automatic generation

## 🎨 How It Works

### When you run a stack:

```bash
./kompose.sh up core
```

**Behind the scenes:**
1. `kompose-env.sh` loads root `.env`
2. Filters variables: `CORE_*` → generic names
3. Generates `.env.generated` in `core/`
4. Passes to docker-compose
5. Stack starts with correct environment

### Variable mapping example:

```bash
# In root .env:
CORE_POSTGRES_IMAGE=postgres:16-alpine
CORE_DB_USER=valknar

# Automatically becomes in core/.env.generated:
POSTGRES_IMAGE=postgres:16-alpine
DB_USER=valknar

# Used in compose.yaml:
services:
  postgres:
    image: ${POSTGRES_IMAGE}
    environment:
      POSTGRES_USER: ${DB_USER}
```

## 📖 Usage Examples

### Change PostgreSQL max connections:

```bash
# 1. Edit root .env
vim .env

# 2. Find and change:
CORE_POSTGRES_MAX_CONNECTIONS=200

# 3. Restart
./kompose.sh restart core
```

### Add a new stack:

```bash
# 1. Add to .env
cat >> .env << 'EOF'

# ===================================================================
# NEWSTACK CONFIGURATION
# ===================================================================
NEWSTACK_COMPOSE_PROJECT_NAME=newstack
NEWSTACK_IMAGE=someimage:latest
NEWSTACK_PORT=8080
EOF

# 2. Add secrets
echo "NEWSTACK_PASSWORD=xxx" >> secrets.env

# 3. Create stack directory and compose.yaml
mkdir newstack
# ... create compose.yaml ...

# 4. Test
./kompose.sh up newstack
```

### Debug environment:

```bash
# Show all core variables
./kompose.sh env show core

# Validate configuration
./kompose.sh env validate auth

# View generated file
cat home/.env.generated
```

## 🔐 Security Notes

### ✅ Safe Files (committed to git)
- `.env` - Non-sensitive configuration
- `domain.env` - Domain settings
- `.env.template` - Template
- `secrets.env.template` - Template

### 🔒 Secret Files (in .gitignore)
- `secrets.env` - **NEVER commit this!**
- `**/.env.generated` - Auto-generated, ignored

### Best Practices:
```bash
# Set proper permissions
chmod 600 secrets.env

# Verify it's ignored
git status | grep secrets.env  # Should show nothing

# Generate strong secrets
./kompose.sh secrets generate
```

## 🚨 Troubleshooting

### Stack won't start

```bash
# 1. Check environment
./kompose.sh env show stackname

# 2. Validate
./kompose.sh env validate stackname

# 3. Check generated file
cat stackname/.env.generated

# 4. View compose config
cd stackname
docker-compose --env-file .env.generated config
```

### Missing variable

```bash
# Search in .env
grep "STACKNAME_VARNAME" .env

# Check if it's exported
./kompose.sh env show stackname | grep VARNAME

# Validate stack
./kompose.sh env validate stackname
```

### Secrets not loading

```bash
# Check secrets file exists
ls -l secrets.env

# Set permissions
chmod 600 secrets.env

# Test loading
source secrets.env && echo $SOME_SECRET

# Restart stack
./kompose.sh restart stackname
```

## 📚 Next Steps

1. **Read the migration guide:**
   ```bash
   cat _docs/content/3.guide/environment-migration.md
   ```

2. **Review configuration reference:**
   ```bash
   cat _docs/content/4.reference/stack-configuration.md
   ```

3. **Update stack documentation:**
   - I've updated `core.md` as an example
   - Update other stack docs similarly
   - Show how to use the new configuration

4. **Test thoroughly:**
   - Test each stack individually
   - Verify all services work
   - Check logs for errors

5. **Commit changes:**
   ```bash
   git add .env kompose-env.sh kompose-stack.sh
   git add migrate-to-centralized-env.sh
   git add _docs/content/
   git add .gitignore  # if updated
   git commit -m "feat: centralized environment configuration system"
   ```

## 🎓 Learning Resources

### Commands to remember:

```bash
# Environment management
./kompose.sh env show <stack>      # Show variables
./kompose.sh env validate <stack>  # Validate config
./kompose.sh env list              # List all stacks

# Stack operations (unchanged)
./kompose.sh up <stack>            # Start
./kompose.sh down <stack>          # Stop
./kompose.sh restart <stack>       # Restart
./kompose.sh logs <stack> -f       # Logs
./kompose.sh status <stack>        # Status

# Secrets management
./kompose.sh secrets generate      # Generate secrets
```

### File locations:

```
Configuration:  /home/valknar/Projects/kompose/.env
Secrets:        /home/valknar/Projects/kompose/secrets.env
Domain:         /home/valknar/Projects/kompose/domain.env
Env Manager:    /home/valknar/Projects/kompose/kompose-env.sh
Backups:        /home/valknar/Projects/kompose/backups/env-migration-*/
```

## ✨ What's Different?

### Old way:
```bash
# Edit multiple files
vim core/.env
vim auth/.env
vim home/.env
# ... and so on

# Hard to see dependencies
# Duplicate values
# Easy to miss updates
```

### New way:
```bash
# Edit one file
vim .env

# All in one place
# Scoped by stack
# Clear and organized
```

## 🎯 Ready to Migrate?

Just run:

```bash
./migrate-to-centralized-env.sh
```

And follow the prompts!

---

**Questions?** Check the documentation in `_docs/content/` or examine the example in `core.md`!

Good luck! 🚀
