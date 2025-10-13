# Kompose 2.0 - Setup & Init Integration Update

**Date:** January 15, 2025
**Version:** 2.0.0

## Summary

This update fully integrates setup and initialization functionality into the main `kompose.sh` CLI, deprecating the standalone `kompose-local.sh` script in favor of unified `kompose.sh setup` commands.

## What Changed

### 1. Integrated Setup Commands

All setup functionality is now accessible via `kompose.sh setup`:

```bash
# New unified commands
./kompose.sh init                  # Interactive initialization wizard
./kompose.sh setup local           # Switch to local development
./kompose.sh setup prod            # Switch to production
./kompose.sh setup status          # Show current mode
./kompose.sh setup save-prod       # Save production config
./kompose.sh setup backup          # Backup configuration
```

### 2. Deprecated kompose-local.sh

The `kompose-local.sh` script is now deprecated and acts as a wrapper that forwards commands to `kompose.sh setup`:

**Old (deprecated):**
```bash
./kompose-local.sh local
./kompose-local.sh status
```

**New (recommended):**
```bash
./kompose.sh setup local
./kompose.sh setup status
```

The deprecated script will display a notice and forward your command automatically.

### 3. Enhanced Init Command

The `kompose.sh init` command now provides a comprehensive initialization wizard:

**Features:**
- ✅ System dependency checking (Docker, Git, Node.js, pnpm, Python 3)
- ✅ Interactive environment selection (local/production/both)
- ✅ Automatic configuration file creation
- ✅ Project dependency installation (_docs and kmps via pnpm)
- ✅ Docker network setup
- ✅ Directory structure creation
- ✅ Clear next steps guidance

**Usage:**
```bash
cd kompose
./kompose.sh init
```

### 4. Improved Dependency Management

The init command now properly checks and installs:

- **Required:**
  - Docker 20.10+
  - Docker Compose v2.0+
  - Git

- **Optional (for development):**
  - Node.js 18+
  - pnpm package manager
  - Python 3 (for REST API server)

**Automatic Installation:**
- Installs _docs dependencies (Nuxt-based documentation site)
- Installs kmps dependencies (Next.js management portal)
- Handles both `kmps/` and legacy `_kmps/` directories

## Migration Guide

### For Users of kompose-local.sh

If you were using `kompose-local.sh`, update your scripts and workflows:

**Before:**
```bash
#!/bin/bash
./kompose-local.sh local
./kompose-local.sh status
```

**After:**
```bash
#!/bin/bash
./kompose.sh setup local
./kompose.sh setup status
```

**Aliases (optional):**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias ksetup='./kompose.sh setup'
alias kinit='./kompose.sh init'
```

### For New Projects

First-time setup is now simpler:

```bash
# 1. Clone repository
git clone https://code.pivoine.art/valknar/kompose.git
cd kompose

# 2. Run interactive initialization
./kompose.sh init

# 3. Follow the wizard prompts
# - Dependency check
# - Choose environment (local/prod/both)
# - Automatic setup

# 4. Start using Kompose
./kompose.sh up core
./kompose.sh status
```

### For Existing Projects

Re-initialize to benefit from the new features:

```bash
# 1. Backup your current configuration
./kompose.sh setup backup

# 2. Re-run initialization
./kompose.sh init

# 3. Your existing .env, domain.env, and secrets.env will be preserved
# 4. New features and improvements will be applied
```

## Updated Documentation

The following documentation has been updated:

### 1. Installation Guide
- Updated to reflect new `init` command
- Added deprecation note for `kompose-local.sh`
- Improved dependency installation instructions

**Location:** `_docs/content/2.installation.md`

### 2. CLI Reference
- Added complete `init` command documentation
- Added comprehensive `setup` command documentation
- Added utility commands (cleanup, validate, version)

**Location:** `_docs/content/4.reference/cli.md`

### 3. Initialization Guide
Already comprehensive, confirmed to be current.

**Location:** `_docs/content/3.guide/initialization.md`

### 4. Environment Setup Guide
Already comprehensive, confirmed to be current.

**Location:** `_docs/content/3.guide/environment-setup.md`

## New Features

### 1. Dependency Verification

The init wizard now checks all dependencies:

```
Step 1: Checking system dependencies
✓ Docker: 24.0.6
✓ Docker Compose: 2.23.0
✓ Git: 2.42.0
✓ Node.js: 20.10.0
✓ pnpm: 8.15.0
✓ Python 3: 3.11.6
```

### 2. Smart Dependency Installation

Automatically installs project dependencies:

```bash
# Documentation site
cd _docs && pnpm install

# Management portal  
cd kmps && pnpm install

# Legacy location (if exists)
cd _kmps && pnpm install
```

### 3. Configuration Backups

All setup commands automatically create backups:

```
backups/config_backup_20250115_103000/
├── .env
├── domain.env
└── secrets.env
```

### 4. Environment Detection

Automatically detects and shows current environment:

```bash
./kompose.sh setup status
```

Output clearly shows:
- Current mode (local/production)
- Service URLs
- Next steps

### 5. Guided Setup Flow

Step-by-step wizard for first-time users:

1. System dependency check
2. Environment selection
3. Configuration file setup
4. Dependency installation
5. Docker network creation
6. Directory structure setup
7. Next steps guidance

## Benefits

### For Developers

- ✅ **Faster onboarding**: Single command to initialize project
- ✅ **Clear guidance**: Step-by-step wizard with helpful prompts
- ✅ **Automatic setup**: Dependencies installed automatically
- ✅ **Error prevention**: Validates everything before proceeding

### For DevOps

- ✅ **Unified CLI**: All commands in one place
- ✅ **Consistent interface**: Same patterns across all commands
- ✅ **Better logging**: Clear status messages and progress
- ✅ **Automated backups**: Configuration safely preserved

### For Teams

- ✅ **Standardized setup**: Everyone uses same initialization process
- ✅ **Documentation**: Comprehensive guides and references
- ✅ **Easy switching**: Simple commands to change environments
- ✅ **Reproducible**: Same setup process for all team members

## Technical Details

### Module Structure

```
kompose/
├── kompose.sh                 # Main CLI - routes commands
├── kompose-setup.sh          # Setup & initialization logic
├── kompose-stack.sh          # Stack management
├── kompose-db.sh             # Database operations
├── kompose-tag.sh            # Git tag deployments
├── kompose-api.sh            # REST API management
├── kompose-utils.sh          # Utility functions
├── kompose-api-server.sh     # REST API server
└── kompose-local.sh          # DEPRECATED - wrapper for kompose.sh setup
```

### Function Flow

**init command:**
```
kompose.sh main()
  → init_project() [in kompose-setup.sh]
    → check_all_dependencies()
    → setup_local_environment() or setup_production_environment()
    → install_project_dependencies()
    → create Docker network
    → create directories
    → display next steps
```

**setup commands:**
```
kompose.sh main()
  → handle_setup_command() [in kompose-setup.sh]
    → switch_to_local() or switch_to_production()
      → backup_config()
      → copy configuration files
      → display status
```

### Backward Compatibility

The deprecated `kompose-local.sh` script maintains backward compatibility by:

1. Displaying deprecation notice
2. Forwarding command to `kompose.sh setup`
3. Executing with same arguments

This allows existing scripts to continue working while encouraging migration to the new syntax.

## Testing

### Manual Testing Checklist

- [x] `./kompose.sh init` - First time initialization
- [x] `./kompose.sh init` - Re-initialization
- [x] `./kompose.sh setup local` - Switch to local
- [x] `./kompose.sh setup prod` - Switch to production
- [x] `./kompose.sh setup status` - Show status
- [x] `./kompose.sh setup backup` - Create backup
- [x] `./kompose.sh setup save-prod` - Save production
- [x] `./kompose-local.sh local` - Deprecated wrapper works
- [x] `./kompose.sh validate` - Validate configuration
- [x] `./kompose.sh cleanup` - Clean up project
- [x] `./kompose.sh version` - Show version

### Automated Testing

Consider adding these test cases:

```bash
# Test init command
./kompose.sh init <<< "1"  # Select local dev

# Test setup commands
./kompose.sh setup local
./kompose.sh setup status | grep "LOCAL DEVELOPMENT"
./kompose.sh setup prod
./kompose.sh setup status | grep "PRODUCTION"

# Test validation
./kompose.sh validate

# Test deprecated wrapper
./kompose-local.sh status 2>&1 | grep "DEPRECATION"
```

## Troubleshooting

### Common Issues

**Issue:** init fails with dependency errors
**Solution:** Install missing dependencies:
```bash
# Ubuntu/Debian
sudo apt-get install docker.io docker-compose git nodejs npm
npm install -g pnpm

# macOS
brew install docker git node
npm install -g pnpm
```

**Issue:** pnpm not found during dependency installation
**Solution:** Install pnpm and re-run init:
```bash
npm install -g pnpm
./kompose.sh init
```

**Issue:** Docker network already exists
**Solution:** This is normal on re-initialization, the init process handles it gracefully.

**Issue:** Configuration files already exist
**Solution:** init preserves existing files. Use `./kompose.sh setup backup` first if concerned.

## Next Steps

### For Users

1. **Update workflows** to use `kompose.sh setup` instead of `kompose-local.sh`
2. **Re-run init** on existing projects to benefit from new features
3. **Review documentation** to learn about new capabilities
4. **Update scripts** to use new command syntax

### For Contributors

1. **Remove kompose-local.sh** in future version (after deprecation period)
2. **Add automated tests** for init and setup commands
3. **Enhance validation** with more comprehensive checks
4. **Add CI/CD integration** for initialization workflow

## Support

### Documentation

- **Installation Guide:** `_docs/content/2.installation.md`
- **Initialization Guide:** `_docs/content/3.guide/initialization.md`
- **CLI Reference:** `_docs/content/4.reference/cli.md`
- **Environment Setup:** `_docs/content/3.guide/environment-setup.md`

### Getting Help

- **Issues:** Open an issue on the repository
- **Questions:** Check the documentation site
- **Discussions:** Join the team chat

## Changelog

### Version 2.0.0 - 2025-01-15

**Added:**
- Interactive `kompose.sh init` wizard
- Comprehensive dependency checking
- Automatic project dependency installation
- `kompose.sh setup` command suite
- Configuration backup system
- Environment detection and status display

**Changed:**
- Deprecated `kompose-local.sh` (now wrapper)
- Improved logging and user feedback
- Enhanced error handling
- Updated documentation

**Fixed:**
- Dependency installation for _docs and kmps
- Environment switching reliability
- Configuration validation

**Deprecated:**
- `kompose-local.sh` - use `kompose.sh setup` instead

---

**Upgrade today** and enjoy the improved setup experience! 🚀
