# Kompose Setup & Init Commands

Complete guide for the new `init` and `setup` commands.

## 🚀 Quick Start

### First Time Setup (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd kompose

# Run interactive initialization
./kompose.sh init
```

The `init` command will:
1. ✅ Check all dependencies (Docker, Node.js, pnpm, etc.)
2. ✅ Guide you through environment setup (local/production)
3. ✅ Create configuration files
4. ✅ Generate secrets
5. ✅ Install project dependencies (kmps, _docs)
6. ✅ Create Docker network
7. ✅ Show next steps

## 📋 Commands Overview

### `kompose.sh init`

Interactive initialization wizard for first-time setup.

**Features:**
- Dependency checking
- Guided environment configuration
- Automatic secrets generation
- Project dependencies installation
- Docker network creation

**Usage:**
```bash
./kompose.sh init
```

**What it does:**

1. **Dependency Check**
   - Docker & Docker Compose
   - Git
   - Node.js (optional)
   - pnpm (optional)
   - Python 3 (optional)

2. **Environment Setup**
   - Choose: Local, Production, or Both
   - Configure domain (production)
   - Generate secrets.env
   - Create configuration files

3. **Project Dependencies**
   - Install kmps dependencies (pnpm)
   - Install _docs dependencies (pnpm)

4. **Infrastructure**
   - Create Docker network
   - Prepare directories

### `kompose.sh setup`

Manage configuration modes (switch between local and production).

**Subcommands:**

#### `setup local`
Switch to local development mode.

```bash
./kompose.sh setup local
```

**What it does:**
- Backs up current configuration
- Copies `.env.local` → `.env`
- Copies `domain.env.local` → `domain.env`
- Creates `secrets.env` if missing
- Shows local service URLs

**Result:**
- All services accessible on `localhost:PORT`
- No domain names or SSL needed
- Fast development setup

#### `setup prod`
Switch to production mode.

```bash
./kompose.sh setup prod
```

**What it does:**
- Backs up current configuration
- Restores `.env.production` → `.env`
- Restores `domain.env.production` → `domain.env`
- Shows production service URLs

**Result:**
- Services on `subdomain.domain.com`
- SSL/TLS enabled
- Production-ready configuration

#### `setup status`
Show current configuration mode.

```bash
./kompose.sh setup status
```

**Output:**
- Current mode (local/production/none)
- Service URLs for current mode
- Quick start commands

#### `setup save-prod`
Save current configuration as production default.

```bash
./kompose.sh setup save-prod
```

**What it does:**
- Copies `.env` → `.env.production`
- Copies `domain.env` → `domain.env.production`

**Use case:**
- After configuring production settings
- Before switching to local mode
- To preserve production config

#### `setup backup`
Create backup of current configuration.

```bash
./kompose.sh setup backup
```

**What it does:**
- Creates timestamped backup directory
- Backs up `.env`, `domain.env`, `secrets.env`
- Shows backup location

**Backup location:**
```
backups/config_backup_YYYYMMDD_HHMMSS/
├── .env
├── domain.env
└── secrets.env
```

## 📖 Usage Examples

### Example 1: Fresh Project Setup

```bash
# 1. Clone repository
git clone <repo-url>
cd kompose

# 2. Run init
./kompose.sh init

# Follow prompts:
# - Choose: 1 (Local Development)
# - Wait for dependency checks
# - Wait for installations

# 3. Update secrets
nano secrets.env
# Update KMPS_CLIENT_SECRET after Keycloak setup

# 4. Start services
./kompose.sh up core
./kompose.sh up auth
./kompose.sh up kmps

# 5. Access
open http://localhost:3100
```

### Example 2: Switch Modes

```bash
# Currently in production mode
./kompose.sh setup status
# Output: Current Mode: PRODUCTION

# Switch to local for development
./kompose.sh setup local

# Develop and test...

# Switch back to production
./kompose.sh setup prod
```

### Example 3: Production Setup

```bash
# 1. Initialize with production
./kompose.sh init

# Follow prompts:
# - Choose: 2 (Production)
# - Enter domain: example.com
# - Enter email: admin@example.com

# 2. Configure DNS
# Add A records for *.example.com

# 3. Update secrets with strong passwords
nano secrets.env

# 4. Start services
./kompose.sh up proxy     # Traefik
./kompose.sh up core
./kompose.sh up auth
./kompose.sh up kmps

# 5. Access
open https://manage.example.com
```

### Example 4: Safe Configuration Changes

```bash
# 1. Backup current config
./kompose.sh setup backup

# 2. Make changes
nano .env
nano domain.env

# 3. Test changes
./kompose.sh validate
./kompose.sh up core

# 4. If something goes wrong, restore from backup
cp backups/config_backup_YYYYMMDD_HHMMSS/.env .env
```

### Example 5: Dual Setup (Development & Production)

```bash
# 1. Initialize with both
./kompose.sh init

# Choose: 3 (Both)
# Follow prompts for both environments

# 2. Work locally
./kompose.sh setup local
./kompose.sh up core auth kmps

# Develop and test...

# 3. Deploy to production
./kompose.sh setup prod
./kompose.sh up proxy core auth kmps

# 4. Switch back for more development
./kompose.sh setup local
```

## 🔧 Configuration Files

### Created by `init`

| File | Purpose | Mode |
|------|---------|------|
| `.env` | Active configuration | Both |
| `.env.local` | Local template | Local |
| `.env.production` | Production template | Production |
| `domain.env` | Active domains | Both |
| `domain.env.local` | Local ports | Local |
| `domain.env.production` | Production domains | Production |
| `secrets.env` | Secrets (both modes) | Both |

### Managed by `setup`

The `setup` command copies templates to active files:

**Local Mode:**
```
.env.local      →  .env
domain.env.local  →  domain.env
```

**Production Mode:**
```
.env.production      →  .env
domain.env.production  →  domain.env
```

## 🎯 Dependency Requirements

### Required
- **Docker** (20.10+) - Container runtime
- **Docker Compose** (2.0+) - Stack orchestration
- **Git** (2.0+) - Version control

### Optional (but recommended for development)
- **Node.js** (20+) - For kmps and _docs
- **pnpm** (8+) - Package manager
- **Python 3** (3.9+) - For scripts

### Installation Hints

**Docker:**
```bash
# macOS
brew install docker

# Linux
curl -fsSL https://get.docker.com | sh

# Windows
# Download Docker Desktop from docker.com
```

**Node.js & pnpm:**
```bash
# macOS
brew install node
npm install -g pnpm

# Linux
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g pnpm

# Windows
# Download from nodejs.org
npm install -g pnpm
```

**Python 3:**
```bash
# macOS
brew install python3

# Linux
sudo apt-get install python3

# Windows
# Download from python.org
```

## 📊 Init Workflow

```
./kompose.sh init
       │
       ├─→ Check Dependencies
       │   ├─ Docker ✓
       │   ├─ Docker Compose ✓
       │   ├─ Git ✓
       │   ├─ Node.js ✓ (optional)
       │   ├─ pnpm ✓ (optional)
       │   └─ Python 3 ✓ (optional)
       │
       ├─→ Choose Environment
       │   ├─ 1. Local Development
       │   ├─ 2. Production
       │   └─ 3. Both
       │
       ├─→ Configure Environment
       │   ├─ Copy configuration files
       │   ├─ Set up domain (if production)
       │   └─ Generate secrets
       │
       ├─→ Install Dependencies
       │   ├─ kmps (pnpm install)
       │   └─ _docs (pnpm install)
       │
       ├─→ Setup Infrastructure
       │   └─ Create Docker network
       │
       └─→ Show Next Steps
           ├─ Configuration review
           ├─ Service start commands
           └─ Access URLs
```

## 🎓 Best Practices

### Do's ✅

1. **Run `init` first** on a fresh clone
2. **Backup before switching** modes
3. **Use local mode** for development
4. **Test locally** before deploying to production
5. **Keep secrets.env** out of git
6. **Update dependencies** regularly

### Don'ts ❌

1. **Don't skip** dependency checks
2. **Don't commit** secrets.env to git
3. **Don't use development secrets** in production
4. **Don't switch modes** without backing up
5. **Don't manually edit** generated files without backup

## 🐛 Troubleshooting

### "Dependency not found"

**Problem:** Required dependency missing

**Solution:**
```bash
# Check which dependency
./kompose.sh init

# Install missing dependency
# (see installation hints above)

# Run init again
./kompose.sh init
```

### "Configuration file not found"

**Problem:** Template files missing

**Solution:**
```bash
# Ensure you're in the project root
pwd

# Check for template files
ls -la .env.local
ls -la domain.env.local

# Re-clone repository if files missing
```

### "Docker network creation failed"

**Problem:** Docker not running or permission issues

**Solution:**
```bash
# Check Docker status
docker ps

# Start Docker (if not running)
# macOS/Windows: Open Docker Desktop
# Linux: sudo systemctl start docker

# Check permissions (Linux)
sudo usermod -aG docker $USER
# Logout and login again
```

### "pnpm install failed"

**Problem:** pnpm not installed or network issues

**Solution:**
```bash
# Install pnpm
npm install -g pnpm

# Try again
cd kmps && pnpm install
cd ../_docs && pnpm install

# If still failing, check network
ping npmjs.org
```

### "Mode switch didn't work"

**Problem:** Configuration files not copied

**Solution:**
```bash
# Check current mode
./kompose.sh setup status

# Manually verify files
cat .env | head -5

# Force switch
rm .env .env.bak domain.env domain.env.bak
./kompose.sh setup local
```

## 📚 Related Documentation

- **Complete Guide:** `COMPLETE_SUMMARY.md`
- **Quick Reference:** `QUICK_REFERENCE.md`
- **Local Development:** `LOCAL_DEVELOPMENT.md`
- **KMPS Setup:** `kmps/QUICK_START.md`

## 🆘 Getting Help

```bash
# Show help
./kompose.sh help
./kompose.sh setup help

# Check status
./kompose.sh setup status

# Validate configuration
./kompose.sh validate

# Check logs
docker logs <container_name>
```

## 🎉 Summary

The new `init` and `setup` commands make Kompose project setup easy:

- **`init`** - One command to set up everything
- **`setup`** - Easy switching between modes
- **Automated** - Dependency checks and installations
- **Interactive** - Guided prompts
- **Safe** - Automatic backups

**Quick Start:**
```bash
./kompose.sh init          # First time
./kompose.sh setup local   # Switch to local
./kompose.sh setup prod    # Switch to production
./kompose.sh setup status  # Check mode
```

---

**Happy Komposing! 🚀**
