# Kompose Test Suite

Comprehensive test suite for the Kompose Docker Compose Stack Manager.

## Overview

This test suite provides automated testing for all kompose.sh commands and subcommands. Tests are organized by functional area and can be run individually or as a complete suite.

## Test Structure

```
__tests/
├── run-all-tests.sh          # Main test runner
├── test-helpers.sh           # Shared test utilities and assertions
├── make-executable.sh        # Makes all test scripts executable
├── test-basic-commands.sh    # Basic commands (help, version, list)
├── test-stack-commands.sh    # Stack management (up, down, restart, logs, etc.)
├── test-database-commands.sh # Database operations (backup, restore, shell, etc.)
├── test-tag-commands.sh      # Git tag deployments
├── test-api-commands.sh      # REST API server
├── test-secrets-commands.sh  # Secrets management
├── test-profile-commands.sh  # Profile management
├── test-env-commands.sh      # Environment management
├── test-setup-commands.sh    # Setup and initialization
├── test-utils-commands.sh    # Utility functions
├── test-generate-commands.sh # Stack generator
├── snapshots/                # Snapshot files for regression testing
├── temp/                     # Temporary files during test execution
└── generated/                # Generated test files for custom stacks
```

## Quick Start

### Make Scripts Executable

```bash
cd __tests
bash make-executable.sh
```

### Run All Tests

```bash
bash run-all-tests.sh
```

### Run Specific Test Suite

```bash
bash run-all-tests.sh -t basic-commands
bash run-all-tests.sh -t stack-commands
bash run-all-tests.sh -t secrets-commands
```

### Run with Options

```bash
# Update snapshots
bash run-all-tests.sh -u

# Verbose output
bash run-all-tests.sh -v

# Run integration tests (requires Docker)
bash run-all-tests.sh -i

# Combine options
bash run-all-tests.sh -v -i
```

## Test Suites

### 1. Basic Commands (`test-basic-commands.sh`)
Tests fundamental kompose.sh commands:
- `kompose help` - Help display
- `kompose version` - Version information
- `kompose list` - List available stacks
- `kompose validate` - Configuration validation
- Error handling for invalid commands
- Help flags (`-h`, `--help`)

**Tests:** 8 test cases

### 2. Stack Management (`test-stack-commands.sh`)
Tests stack lifecycle operations:
- `kompose up` - Start stacks
- `kompose down` - Stop stacks
- `kompose restart` - Restart stacks
- `kompose status` - Stack status
- `kompose logs` - View logs
- `kompose deploy` - Deploy specific versions
- `kompose exec` - Execute commands in containers
- `kompose ps` - Show all containers
- Error handling for non-existent stacks

**Tests:** 10 test cases + integration tests

### 3. Database Commands (`test-database-commands.sh`)
Tests database operations:
- `kompose db backup` - Create backups
- `kompose db restore` - Restore from backups
- `kompose db list` - List backups
- `kompose db status` - Database status
- `kompose db exec` - Execute SQL
- `kompose db shell` - Open database shell
- `kompose db migrate` - Run migrations
- `kompose db reset` - Reset database
- Option parsing (`-d`, `-f`, `--compress`)

**Tests:** 11 test cases

### 4. Tag Commands (`test-tag-commands.sh`)
Tests git tag deployment operations:
- `kompose tag create` - Create deployment tags
- `kompose tag deploy` - Deploy with tags
- `kompose tag move` - Move tags
- `kompose tag delete` - Delete tags
- `kompose tag list` - List tags
- `kompose tag rollback` - Rollback deployments
- `kompose tag status` - Tag status
- Option parsing (`-s`, `-e`, `-v`, `-c`, `-m`, `-f`, `-d`)

**Tests:** 11 test cases

### 5. API Commands (`test-api-commands.sh`)
Tests REST API server operations:
- `kompose api start` - Start API server
- `kompose api stop` - Stop API server
- `kompose api status` - Server status
- `kompose api logs` - View server logs
- Custom port and host configuration
- Error handling

**Tests:** 8 test cases

### 6. Secrets Management (`test-secrets-commands.sh`) ⭐ NEW
Tests secrets management operations:
- `kompose secrets generate` - Generate secrets
- `kompose secrets validate` - Validate configuration
- `kompose secrets list` - List secrets
- `kompose secrets rotate` - Rotate secrets
- `kompose secrets set` - Set secret values
- `kompose secrets backup` - Backup secrets
- `kompose secrets export` - Export to JSON
- Stack filtering (`-s`)

**Tests:** 11 test cases

### 7. Profile Management (`test-profile-commands.sh`) ⭐ NEW
Tests profile management operations:
- `kompose profile list` - List profiles
- `kompose profile create` - Create profiles
- `kompose profile use` - Switch profiles
- `kompose profile show` - Show profile details
- `kompose profile edit` - Edit profiles
- `kompose profile delete` - Delete profiles
- `kompose profile copy` - Copy profiles
- `kompose profile export` - Export profiles
- `kompose profile import` - Import profiles
- `kompose profile up` - Start profile stacks
- `kompose profile current` - Show active profile

**Tests:** 14 test cases

### 8. Environment Management (`test-env-commands.sh`) ⭐ NEW
Tests environment variable operations:
- `kompose env list` - List environment variables
- `kompose env generate` - Generate .env.example files
- `kompose env export` - Export to JSON
- `kompose env stacks` - List stacks with env definitions
- `kompose env help` - Show help
- Stack-specific operations
- Force regeneration (`--force`)

**Tests:** 13 test cases

### 9. Setup & Initialization (`test-setup-commands.sh`) ⭐ NEW
Tests setup and configuration:
- `kompose init` - Interactive initialization
- `kompose setup local` - Switch to local mode
- `kompose setup prod` - Switch to production mode
- `kompose setup status` - Show configuration mode
- `kompose setup save-prod` - Save production config
- `kompose setup backup` - Backup configuration
- `kompose cleanup` - Clean up files
- `kompose validate` - Validate configuration

**Tests:** 10 test cases

### 10. Utility Functions (`test-utils-commands.sh`) ⭐ NEW
Tests core utility functions:
- Version information
- Container listing (`ps`)
- Stack listing
- Stack existence validation
- Custom stack discovery
- Help completeness
- Error handling
- Color variable exports
- Script directory detection
- Built-in stack definitions

**Tests:** 12 test cases

### 11. Stack Generator (`test-generate-commands.sh`)
Tests stack generation functionality:
- `kompose generate <name>` - Create custom stacks
- `kompose generate list` - List custom stacks
- `kompose generate show` - Show stack info
- `kompose generate delete` - Delete custom stacks
- File generation (compose.yaml, .env, README, tests)
- Validation and error handling
- Integration with kompose ecosystem

**Tests:** Multiple test cases

## Test Helpers

The `test-helpers.sh` file provides:

### Assertion Functions
- `assert_equals` - Compare two values
- `assert_contains` - Check if string contains substring
- `assert_not_contains` - Check if string doesn't contain substring
- `assert_exit_code` - Check exit code
- `assert_file_exists` - Check file existence
- `assert_directory_exists` - Check directory existence

### Snapshot Testing
- `create_snapshot` - Create new snapshot
- `update_snapshot` - Update existing snapshot
- `compare_snapshot` - Compare output to snapshot
- Automatic normalization (whitespace, ANSI codes)

### Command Execution
- `run_kompose` - Execute kompose command with output capture
- `run_kompose_quiet` - Execute without output
- `capture_output` - Capture command output

### Test Environment
- `setup_test_env` - Initialize test environment
- `cleanup_test_env` - Clean up after tests
- `print_test_summary` - Display test results

### Docker Helpers
- `wait_for_container` - Wait for container to start
- `is_docker_available` - Check Docker availability
- `container_is_healthy` - Check container health

## Test Options

### Update Snapshots
```bash
bash run-all-tests.sh -u
```
Creates or updates snapshot files for regression testing.

### Verbose Output
```bash
bash run-all-tests.sh -v
```
Shows detailed output including diffs and full error messages.

### Integration Tests
```bash
bash run-all-tests.sh -i
```
Runs tests that require Docker (stack lifecycle tests).

### Specific Test
```bash
bash run-all-tests.sh -t basic-commands
```
Runs only the specified test suite.

## Writing Tests

### Basic Test Structure

```bash
#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

log_section "TESTING: My Feature"
setup_test_env

test_my_feature() {
    log_test "Testing my feature"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose mycommand 2>&1)
    exit_code=$?
    set -e
    
    assert_exit_code 0 $exit_code \
        "Command should succeed"
    
    assert_contains "$output" "expected text" \
        "Output should contain expected text"
}

test_my_feature

cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
```

### Best Practices

1. **Use `set -e`** - Exit on first error
2. **Use `set +e` around commands** - Capture exit codes
3. **Always restore `set -e`** - After capturing exit codes
4. **Use descriptive test names** - Clear purpose
5. **Use assertions** - Don't just check exit codes
6. **Test error cases** - Invalid inputs, missing arguments
7. **Clean up** - Remove test files/directories
8. **Use snapshots** - For complex output validation

## Continuous Integration

Tests are designed to work in CI environments:

```yaml
# Example GitHub Actions workflow
- name: Run Tests
  run: |
    cd __tests
    bash make-executable.sh
    bash run-all-tests.sh -v
```

## Test Coverage

Current test coverage:

| Area | Test Suite | Status |
|------|-----------|--------|
| Basic Commands | ✅ | Complete |
| Stack Management | ✅ | Complete |
| Database Operations | ✅ | Complete |
| Git Tag Deployments | ✅ | Complete |
| API Server | ✅ | Complete |
| Secrets Management | ✅ | Complete |
| Profile Management | ✅ | Complete |
| Environment Management | ✅ | Complete |
| Setup & Initialization | ✅ | Complete |
| Utility Functions | ✅ | Complete |
| Stack Generator | ✅ | Complete |

**Total Test Suites:** 11  
**Total Test Cases:** 100+

## Troubleshooting

### Tests Fail Due to Missing Files
```bash
cd __tests
bash make-executable.sh
```

### Snapshot Mismatches
Update snapshots if intentional changes:
```bash
bash run-all-tests.sh -u
```

### Docker Not Available
Skip integration tests:
```bash
bash run-all-tests.sh  # Skips integration tests by default
```

### Permission Denied
Make scripts executable:
```bash
chmod +x __tests/*.sh
```

## Contributing

When adding new features to kompose.sh:

1. Add corresponding tests
2. Follow existing test structure
3. Use test helpers
4. Document new test suites
5. Update this README
6. Run full test suite before submitting

## Support

For issues or questions:
- Check test output with `-v` flag
- Review test-helpers.sh for available utilities
- Examine existing tests for examples
- Run individual test suites to isolate issues

---

**Last Updated:** October 2025  
**Version:** 1.0.0
