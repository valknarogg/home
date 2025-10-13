# Known Issues and Fixes

This document tracks known issues in kompose.sh and their resolutions.

## Fixed Issues

### Console Colors Not Working Properly (v2.0.0)

**Status:** ✅ Fixed

**Issue Description:**
Console colors were not displaying correctly when using kompose.sh commands. The color codes were defined but not properly exported for use in sourced modules.

**Symptoms:**
- Log messages appeared without color formatting
- Output was difficult to read
- Color codes might appear as literal text in some terminals

**Root Cause:**
- Color variables (RED, GREEN, YELLOW, etc.) were not exported
- Logging functions were not exported for use in sourced modules
- Sourced module functions couldn't access parent scope color variables

**Fix Applied:**
```bash
# In kompose.sh - Color variables are now exported
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export MAGENTA='\033[0;35m'
export NC='\033[0m'

# Logging functions are now exported
export -f log_info
export -f log_success
export -f log_warning
export -f log_error
export -f log_stack
export -f log_tag
export -f log_db
export -f log_api
```

**Verification:**
Run any kompose command and verify colored output:
```bash
./kompose.sh list
./kompose.sh status
./kompose.sh version
```

You should see:
- Blue `[INFO]` messages
- Green `[SUCCESS]` messages
- Yellow `[WARNING]` messages
- Red `[ERROR]` messages
- Cyan `[STACK]` messages
- Magenta `[TAG]` and `[API]` messages

**Additional Notes:**
- This fix ensures color consistency across all modules
- Colors work correctly in bash 4.0+ terminals
- If colors still don't appear, check your terminal supports ANSI escape codes

## Testing Implementation Status

### Current Test Suite

The test suite under `__tests/` is **fully implemented** with comprehensive coverage:

#### Implemented Test Files:

1. **test-basic-commands.sh** ✅
   - Help command
   - Version command
   - List command
   - Validate command
   - Invalid command handling
   - No arguments behavior
   - Help flags (-h, --help)

2. **test-stack-commands.sh** ✅
   - Stack up/down operations
   - Stack restart
   - Stack status checking
   - Stack logs viewing
   - Stack pull/build operations
   - Stack deployment

3. **test-database-commands.sh** ✅
   - Database backup operations
   - Database restore operations
   - Database list and status
   - Database shell access
   - Database exec commands
   - Database migrations
   - Database reset operations

4. **test-tag-commands.sh** ✅
   - Tag creation
   - Tag deployment
   - Tag listing
   - Tag deletion
   - Tag moving
   - Tag rollback
   - Tag status checking

5. **test-api-commands.sh** ✅
   - API server start/stop
   - API server status checking
   - API endpoint testing
   - API health checks

#### Test Helper Functions ✅
Located in `test-helpers.sh`:
- Logging functions
- Assertion functions
- Snapshot testing
- Docker helpers
- Test environment setup/cleanup

#### Running Tests

**Run all tests:**
```bash
cd __tests
./run-all-tests.sh
```

**Run specific test suite:**
```bash
cd __tests
./test-basic-commands.sh
./test-stack-commands.sh
./test-database-commands.sh
./test-tag-commands.sh
./test-api-commands.sh
```

**Update test snapshots:**
```bash
cd __tests
UPDATE_SNAPSHOTS=1 ./run-all-tests.sh
```

**Verbose output:**
```bash
cd __tests
VERBOSE=1 ./test-basic-commands.sh
```

#### Test Coverage

The test suite provides:
- ✅ Unit tests for all main commands
- ✅ Integration tests for stack operations
- ✅ Snapshot testing for output consistency
- ✅ Error handling verification
- ✅ Docker availability checks
- ✅ Environment validation

#### Known Test Limitations

1. **Docker Dependency**: Tests require Docker to be running
2. **Environment Specific**: Some tests may behave differently based on local environment setup
3. **Network Requirements**: API tests require network access
4. **Permissions**: Database tests may require appropriate permissions

## Reporting New Issues

If you encounter any issues with kompose.sh:

1. Check this document for known issues
2. Search existing issues at: https://code.pivoine.art/valknar/kompose/issues
3. Create a new issue with:
   - Kompose version (`./kompose.sh version`)
   - Operating system and version
   - Docker version (`docker --version`)
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs or error messages

## Best Practices

To avoid common issues:

1. **Always run `kompose.sh init`** before first use
2. **Keep Docker updated** to v20.10+
3. **Use bash 4.0+** for script compatibility
4. **Export required variables** in custom scripts
5. **Run tests** after making changes to verify functionality
6. **Check logs** when troubleshooting: `./kompose.sh logs <stack> -f`

## Future Improvements

Planned enhancements:

- [ ] Add pre-commit hooks for test validation
- [ ] Implement CI/CD pipeline with automated testing
- [ ] Add performance benchmarks
- [ ] Expand test coverage for edge cases
- [ ] Add integration tests with real services
- [ ] Implement load testing for API server

## Related Documentation

- [Testing Guide](./testing.md)
- [Troubleshooting Guide](./troubleshooting.md)
- [CLI Reference](/reference/cli.md)
- [Contributing Guidelines](../../README.md#contributing)
