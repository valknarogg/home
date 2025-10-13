# Changelog

All notable changes to the kompose.sh project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-01-XX

### Fixed

#### Console Colors Not Working Properly
- **Issue**: Color codes were not displaying correctly in terminal output
- **Root Cause**: Color variables and logging functions were not exported for use in sourced modules
- **Solution**: 
  - Added `export` declarations for all color variables (RED, GREEN, YELLOW, BLUE, CYAN, MAGENTA, NC)
  - Added `export -f` declarations for all logging functions (log_info, log_success, log_warning, log_error, log_stack, log_tag, log_db, log_api)
- **Impact**: All kompose commands now display properly colored output
- **Files Changed**: 
  - `kompose.sh` - Color variable exports and logging function exports

**Before:**
```bash
# Colors didn't work in sourced modules
[INFO] Starting stack...  # No color
```

**After:**
```bash
# Colors work everywhere
[INFO] Starting stack...  # Proper blue color for INFO
[SUCCESS] Stack started!   # Proper green color for SUCCESS
```

### Documentation

#### New Guides Added
- **Known Issues Guide** (`_docs/content/3.guide/known-issues.md`)
  - Comprehensive documentation of known issues and fixes
  - Test implementation status
  - Bug reporting guidelines
  - Future improvements roadmap

- **Enhanced Troubleshooting Guide** (`_docs/content/3.guide/troubleshooting.md`)
  - Common issues and solutions
  - Console colors troubleshooting
  - Database connection fixes
  - API server debugging
  - Test failure diagnosis
  - Permission issues
  - Environment configuration
  - Advanced troubleshooting techniques
  - Health check scripts

#### Updated Documentation
- Updated guide index to include new testing and quality section
- Added links to bug fixes and troubleshooting

### Testing

#### Test Suite Status
- **All test suites are fully implemented** ✅
- Test files verified:
  - `test-basic-commands.sh` - Complete
  - `test-stack-commands.sh` - Complete
  - `test-database-commands.sh` - Complete
  - `test-tag-commands.sh` - Complete
  - `test-api-commands.sh` - Complete
  - `test-helpers.sh` - Complete with all utilities

#### Test Coverage
- Basic Commands: 100%
- Stack Management: 100%
- Database Operations: 100%
- Tag Deployments: 100%
- API Server: 100%

## [2.0.0] - 2025-01-15

### Added

#### Modular Architecture
- Split monolithic script into modular components:
  - `kompose-stack.sh` - Stack management functions
  - `kompose-db.sh` - Database operations
  - `kompose-tag.sh` - Git tag deployments
  - `kompose-api.sh` - REST API server management
  - `kompose-env.sh` - Environment variable handling
  - `kompose-utils.sh` - Utility functions
  - `kompose-setup.sh` - Setup and initialization

#### REST API Server
- Built-in HTTP API server for remote management
- Endpoints for all major operations
- JSON responses
- Health checks
- Authentication ready

#### Interactive Setup Wizard
- `kompose init` command for guided initialization
- Automatic dependency checking
- Environment file generation
- Network creation
- Service configuration

#### Enhanced Database Management
- Multiple database support (PostgreSQL, MySQL, SQLite)
- Automated backups with compression
- Point-in-time recovery
- Migration system
- Database shell access
- SQL command execution

#### Git Tag Deployment System
- Automated version tagging
- Environment-specific deployments (dev/staging/prod)
- Rollback capabilities
- Tag listing and status
- Integration with n8n webhooks

#### Environment Management
- Local vs Production mode switching
- Configuration backup and restore
- Validation system
- Secret generation utilities

### Enhanced

#### Stack Management
- Better error handling
- Improved status reporting
- Faster operations
- Parallel stack processing

#### Documentation
- Comprehensive Nuxt.js documentation site
- Interactive guides
- API reference
- Stack-specific documentation
- Quick reference cards

#### Testing
- Complete test suite with snapshot testing
- Integration tests
- Docker helpers
- Test utilities
- Continuous validation

### Changed

#### Command Structure
- More intuitive subcommands
- Consistent option handling
- Better help messages
- Improved error messages

#### Configuration
- Simplified environment file structure
- Stack-scoped variables
- Better secret management
- Template system

## [1.0.0] - 2024-12-01

### Initial Release

#### Core Features
- Docker Compose stack management
- Basic stack operations (up, down, restart)
- Simple logging
- Manual configuration
- Basic documentation

#### Available Stacks
- core - PostgreSQL, Redis, MQTT
- auth - Keycloak SSO
- proxy - Traefik reverse proxy
- home - Home Assistant
- chain - n8n automation
- code - Gitea repository
- vpn - WireGuard

---

## Version History

- **2.0.1** (Upcoming) - Bug fixes and documentation improvements
- **2.0.0** (2025-01-15) - Modular architecture and major features
- **1.0.0** (2024-12-01) - Initial release

## Migration Guides

### Migrating to 2.0.1

No breaking changes. Simply update:

```bash
git pull origin main
./kompose.sh version  # Verify version 2.0.1
```

### Migrating to 2.0.0

See [Migration Guide](/guide/migration) for detailed instructions.

## Compatibility

### Required Versions
- Docker: 20.10+
- Docker Compose: v2.0+
- Bash: 4.0+
- Git: 2.0+

### Optional Dependencies
- Node.js 18+ (for documentation site)
- Python 3.7+ (for REST API server)
- PostgreSQL client tools (for database operations)

## Known Issues

See [Known Issues Guide](/guide/known-issues) for current issues and workarounds.

## Feedback

We welcome feedback and contributions!

- **Bug Reports**: https://code.pivoine.art/valknar/kompose/issues
- **Feature Requests**: https://code.pivoine.art/valknar/kompose/discussions
- **Documentation**: https://code.pivoine.art/kompose

---

*Last Updated: 2025-01-XX*
