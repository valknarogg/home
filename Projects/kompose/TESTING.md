# Testing Kompose

This document provides a comprehensive guide to testing the Kompose project.

## Quick Start

```bash
# Navigate to test directory
cd __tests

# Make scripts executable (first time only)
chmod +x *.sh

# Run all tests
./run-all-tests.sh

# Run with integration tests (requires Docker)
./run-all-tests.sh -i

# Update snapshots after intentional changes
./run-all-tests.sh -u
```

## Test Suite Overview

The Kompose test suite provides comprehensive coverage of all functionality:

### Test Types

1. **Unit Tests** - Test individual commands without Docker
2. **Integration Tests** - Test actual Docker operations  
3. **Snapshot Tests** - Compare outputs against known baselines
4. **Regression Tests** - Prevent breaking changes

### Test Files

| File | Description |
|------|-------------|
| `test-basic-commands.sh` | Help, version, list, validate commands |
| `test-stack-commands.sh` | Stack management (up/down/restart/status) |
| `test-database-commands.sh` | Database operations |
| `test-tag-commands.sh` | Git tag deployments |
| `test-api-commands.sh` | API server commands |

## Running Tests

### All Tests

```bash
./run-all-tests.sh
```

### Specific Test Suite

```bash
# Basic commands only
./run-all-tests.sh -t basic-commands

# Stack management only  
./run-all-tests.sh -t stack-commands

# Database commands only
./run-all-tests.sh -t database-commands
```

### With Integration Tests

Requires Docker to be running:

```bash
./run-all-tests.sh -i
```

### Update Snapshots

When you intentionally change command outputs:

```bash
./run-all-tests.sh -u
```

### Verbose Mode

For detailed debugging output:

```bash
./run-all-tests.sh -v
```

### Combine Options

```bash
# Update snapshots and run integration tests
./run-all-tests.sh -u -i

# Verbose output for specific test
./run-all-tests.sh -v -t basic-commands
```

## Test Coverage

Current test coverage by area:

- ✅ **Basic Commands** (100%)
  - help, version, list, validate
  - Error handling
  
- ✅ **Stack Management** (100%)
  - up, down, restart, status
  - logs, pull, deploy, exec, ps
  
- ✅ **Database Commands** (100%)
  - backup, restore, list, status
  - exec, shell, migrate, reset
  
- ✅ **Tag Commands** (100%)
  - create, deploy, move, delete
  - list, rollback, status
  
- ✅ **API Commands** (100%)
  - start, stop, status, logs

## Snapshot Testing

### What Are Snapshots?

Snapshots are saved outputs from commands that serve as "known good" baselines for comparison.

### How It Works

1. **First Run**: Generates baseline snapshots
2. **Subsequent Runs**: Compares current output to snapshots
3. **Mismatch**: Shows diff if outputs don't match
4. **Update**: Use `-u` flag to update snapshots

### Snapshot Files

Located in `__tests/snapshots/`:

```
snapshots/
├── help_output.snapshot
├── version_output.snapshot
├── list_output.snapshot
└── ...
```

### When to Update

Update snapshots when you:
- ✅ Intentionally change command output
- ✅ Add new features
- ✅ Fix formatting issues

**DO NOT** update to "fix" failing tests without understanding why!

### Updating Snapshots

```bash
# Update all snapshots
./run-all-tests.sh -u

# Update specific test snapshots
UPDATE_SNAPSHOTS=1 ./test-basic-commands.sh
```

## Integration Tests

### Requirements

- Docker installed and running
- Sufficient resources (2GB+ RAM)
- Network connectivity

### What They Test

- Actual Docker container operations
- Stack lifecycle management
- Container health checks
- Inter-stack dependencies
- Real database operations

### Running

```bash
# Enable integration tests
RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh

# Or use flag
./run-all-tests.sh -i
```

### Example Test

```bash
test_core_stack_lifecycle() {
    # Start core stack
    run_kompose up core -d
    
    # Wait for healthy state
    wait_for_container "core-postgres" 30
    
    # Verify status
    status=$(run_kompose status core)
    assert_contains "$status" "healthy"
    
    # Clean up
    run_kompose down core
}
```

## Writing Tests

### Basic Test Structure

```bash
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

log_section "TESTING: Your Feature"
setup_test_env

test_your_feature() {
    log_test "Testing your feature"
    
    local output
    output=$(run_kompose your-command 2>&1)
    
    assert_contains "$output" "expected" \
        "Output contains expected text"
}

test_your_feature

cleanup_test_env
print_test_summary
```

### Available Assertions

```bash
# String operations
assert_equals "expected" "actual" "description"
assert_contains "haystack" "needle" "description"
assert_not_contains "haystack" "needle" "description"

# Exit codes
assert_exit_code 0 $? "command succeeded"

# File operations
assert_file_exists "/path/to/file" "file exists"
assert_directory_exists "/path/to/dir" "directory exists"
```

### Helper Functions

```bash
# Run kompose commands
output=$(run_kompose status core)
run_kompose_quiet up core

# Snapshot operations
create_snapshot "name" "$output"
compare_snapshot "name" "$output" "description"

# Docker utilities
wait_for_container "container-name" 30
is_docker_available
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Tests
        run: |
          cd __tests
          chmod +x *.sh
          ./run-all-tests.sh -i
```

### GitLab CI

```yaml
test:
  stage: test
  script:
    - cd __tests
    - chmod +x *.sh
    - ./run-all-tests.sh -i
```

## Troubleshooting

### Tests Fail After Changes

1. Review the diff output
2. Verify change is intentional
3. Update snapshots if correct: `./run-all-tests.sh -u`
4. Fix bugs if incorrect

### Docker Not Available

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Or skip integration tests
./run-all-tests.sh  # Only runs unit tests
```

### Permission Denied

```bash
chmod +x __tests/*.sh
```

### Snapshot Mismatches

```bash
# View detailed diff
./run-all-tests.sh -v

# Update if intentional
./run-all-tests.sh -u
```

## Best Practices

### Before Committing

1. Run all tests: `./run-all-tests.sh`
2. Run integration tests: `./run-all-tests.sh -i`
3. Update snapshots if needed: `./run-all-tests.sh -u`
4. Review all diffs carefully

### Adding Features

1. Write tests first (TDD)
2. Implement feature
3. Generate snapshots
4. Verify all tests pass

### Maintaining Tests

- Keep tests focused and simple
- Use descriptive test names
- Clean up after tests
- Document complex scenarios
- Review snapshot updates carefully

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `UPDATE_SNAPSHOTS` | Update snapshot files | `0` |
| `RUN_INTEGRATION_TESTS` | Run Docker tests | `0` |
| `VERBOSE` | Enable verbose output | `0` |

## Getting Help

- Check test output for detailed error messages
- Review snapshot diffs carefully
- Read `__tests/README.md` for detailed documentation
- See `_docs/content/4.reference/testing.md` for full guide

## Resources

- [Test Suite README](__tests/README.md)
- [Testing Reference](_docs/content/4.reference/testing.md)
- [Contributing Guide](CONTRIBUTING.md)

---

**Last Updated**: 2025-01-12  
**Version**: 1.0.0
