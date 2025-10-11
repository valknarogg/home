# Changelog

All notable changes to Kompose will be documented in this file.

## [Unreleased]

### Added

- **Docker Compose Command Hooks**: Added comprehensive hook system for all Docker Compose commands
  - Pre and post hooks for: `up`, `down`, `start`, `stop`, `restart`, `build`, `pull`, `logs`, and more
  - Hooks receive full command arguments as parameters
  - Post-command hooks only execute on successful command execution
  - Consistent with existing database hooks pattern
  
- **Hook Template**: Added `hooks.sh.template` as a comprehensive reference for creating custom hooks
  - Includes all available hook types with examples
  - Provides utility functions and best practices
  - Serves as a starting point for new stacks

### Changed

- **Documentation**: Completely rewrote hooks documentation (`docs/content/3.guide/hooks.md`)
  - Added comprehensive examples for all hook types
  - Included real-world use cases (monitoring, backups, cache warming)
  - Added troubleshooting section
  - Added security considerations
  - Added best practices and advanced patterns

- **Core Script**: Enhanced `execute_stack_command()` function in `kompose.sh`
  - Added hook execution before and after Docker Compose commands
  - Improved error handling and exit code management
  - Hooks properly execute in dry-run mode

### Documentation Updates

- Updated CLI help text with complete list of Docker Compose command hooks
- Added hook execution flow diagrams
- Expanded examples section with practical use cases
- Added advanced patterns for conditional execution and hook chaining

## Hook System

### Available Hooks

**Database Hooks:**
- `hook_pre_db_export` - Before database export
- `hook_post_db_export` - After database export (receives dump file path)
- `hook_pre_db_import` - Before database import (receives dump file path)
- `hook_post_db_import` - After database import (receives dump file path)

**Docker Compose Command Hooks:**
- `hook_pre_<command>` - Before any Docker Compose command
- `hook_post_<command>` - After any Docker Compose command (only on success)

Supported commands: `up`, `down`, `start`, `stop`, `restart`, `build`, `pull`, `logs`, `ps`, `exec`, `run`, `create`, `kill`, `pause`, `unpause`, `port`, `top`

### Usage Examples

```bash
# Hooks execute automatically for supported commands
./kompose.sh news up -d          # Triggers pre_up and post_up hooks
./kompose.sh blog restart        # Triggers pre_restart and post_restart hooks
./kompose.sh "*" down            # Triggers pre_down and post_down hooks

# Test hooks in dry-run mode
./kompose.sh news up -d --dry-run
```

### Migration Guide

For existing stacks with `hooks.sh`:
1. No changes required - existing database hooks continue to work
2. Optionally add new Docker Compose command hooks as needed
3. See `hooks.sh.template` for all available hooks
4. Refer to updated documentation for examples and best practices

---

## Previous Versions

### [1.0.0] - Initial Release

- Basic Docker Compose stack management
- Database import/export functionality
- Database hooks (pre/post export/import)
- Pattern-based stack selection
- Environment variable management
- Dry-run mode
- Stack listing and filtering
