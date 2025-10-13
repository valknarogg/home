# Testing Guide

> *"Tests are the safety net that lets you code with confidence"*

## Overview

The Kompose project includes a comprehensive test suite that ensures all commands work correctly and helps prevent regressions when making changes. This guide will help you understand and use the testing framework effectively.

## Test Structure

```
__tests/
├── test-helpers.sh           # Shared test utilities
├── run-all-tests.sh         # Master test runner
├── test-basic-commands.sh   # Basic command tests
├── test-stack-commands.sh   # Stack management tests
├── test-database-commands.sh # Database command tests
├── test-tag-commands.sh     # Git tag deployment tests
├── test-api-commands.sh     # API server tests
└── snapshots/               # Expected command outputs
```

## Quick Start

### Running All Tests

```bash
cd __tests
./run-all-tests.sh
```

This runs all test suites and provides a comprehensive report at the end.

### Running Specific Test Suites

```bash
# Run only basic command tests
./run-all-tests.sh -t basic-commands

# Run stack management tests
./run-all-tests.sh -t stack-commands

# Run database tests
./run-all-tests.sh -t database-commands

# Run tag tests
./run-all-tests.sh -t tag-commands

# Run API tests
./run-all-tests.sh -t api-commands
```

### Verbose Output

For detailed test output and debugging:

```bash
./run-all-tests.sh -v
```

## Test Types

### 1. Unit Tests

**Purpose**: Test individual commands without Docker

**What they test**:
- Command syntax recognition
- Error message correctness
- Help text display
- Input validation
- Option parsing

**Examples**:
```bash
# Tests that help command works
kompose help

# Tests error handling
kompose invalid_command

# Tests required arguments
kompose db exec  # Should fail with error
```

**When to use**: Always! These run quickly and don't require Docker.

### 2. Snapshot Tests

**Purpose**: Ensure command outputs don't change unexpectedly

**How they work**:
1. First run: Creates baseline "snapshot" of command output
2. Subsequent runs: Compares current output to snapshot
3. Fails if output differs (indicates breaking change)

**Update snapshots when**:
- You intentionally changed command output
- You added new features
- You fixed display/formatting issues

**Updating snapshots**:
```bash
./run-all-tests.sh -u
```

**Example**:
```bash
# Generate initial snapshot
UPDATE_SNAPSHOTS=1 ./test-basic-commands.sh

# Run test (will compare against snapshot)
./test-basic-commands.sh
```

### 3. Integration Tests

**Purpose**: Test actual Docker operations

**Requirements**:
- Docker installed and running
- Proper permissions to run Docker commands
- Network access (for pulling images)

**What they test**:
- Stack lifecycle (up/down/restart)
- Container health checks
- Network connectivity
- Real database operations

**Running integration tests**:
```bash
# Enable integration tests
./run-all-tests.sh -i

# Or set environment variable
RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh
```

**Example integration test**:
```bash
# Start core stack
kompose up core

# Wait for containers
sleep 5

# Check status
kompose status core

# Stop stack
kompose down core
```

## Test Options

### Available Flags

| Flag | Description |
|------|-------------|
| `-u`, `--update-snapshots` | Update all snapshots |
| `-i`, `--integration` | Run integration tests |
| `-v`, `--verbose` | Enable verbose output |
| `-t`, `--test <name>` | Run specific test suite |
| `-h`, `--help` | Show help message |

### Combining Options

```bash
# Update snapshots and run integration tests
./run-all-tests.sh -u -i

# Verbose mode for specific test
./run-all-tests.sh -v -t basic-commands
```

## Writing Tests

### Basic Test Structure

```bash
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

# Setup
log_section "TESTING: My Feature"
setup_test_env

# Test function
test_my_feature() {
    log_test "Testing my feature"
    
    local output
    local exit_code
    
    set +e
    output=$(run_kompose my-command 2>&1)
    exit_code=$?
    set -e
    
    assert_exit_code 0 $exit_code \
        "Command executes successfully"
    
    assert_contains "$output" "expected text" \
        "Output contains expected text"
}

# Run tests
test_my_feature

# Cleanup
cleanup_test_env

if print_test_summary; then
    exit 0
else
    exit 1
fi
```

### Available Assertions

```bash
# Exit code assertions
assert_exit_code 0 $exit_code "test description"

# String assertions
assert_equals "expected" "actual" "test description"
assert_contains "haystack" "needle" "test description"
assert_not_contains "haystack" "needle" "test description"

# File/directory assertions
assert_file_exists "/path/to/file" "test description"
assert_directory_exists "/path/to/dir" "test description"
```

### Snapshot Testing

```bash
test_help_command() {
    local output
    output=$(run_kompose help 2>&1)
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        # Create/update snapshot
        create_snapshot "help_output" "$output"
    else
        # Compare against existing snapshot
        compare_snapshot "help_output" "$output" \
            "Help output matches snapshot"
    fi
}
```

### Integration Tests

```bash
test_stack_lifecycle() {
    # Skip if Docker not available
    if [ $DOCKER_AVAILABLE -eq 0 ]; then
        log_skip "Skipping - Docker not available"
        return
    fi
    
    # Skip if integration tests not requested
    if [ "${RUN_INTEGRATION_TESTS}" != "1" ]; then
        log_skip "Set RUN_INTEGRATION_TESTS=1 to run"
        return
    fi
    
    # Run actual Docker operations
    run_kompose up core -d
    wait_for_container "core-postgres" 30
    run_kompose down core
    
    log_pass "Stack lifecycle test completed"
}
```

## Understanding Test Output

### Successful Test Run

```
═══════════════════════════════════════════════════════
  TESTING: Basic Commands
═══════════════════════════════════════════════════════

[TEST] Testing 'kompose help' command
[PASS] Help command exits successfully
[PASS] Help output contains title
[PASS] Help output contains stack commands section
[PASS] Help command output matches snapshot

═══════════════════════════════════════════════════════
  TEST SUMMARY
═══════════════════════════════════════════════════════

  Total Tests:  15
  Passed:       15
  Failed:       0
  Pass Rate:    100%

✓ All tests passed!
```

### Failed Test Run

```
[TEST] Testing 'kompose help' command
[FAIL] Help output matches snapshot - Snapshot mismatch
  Snapshot: snapshots/help_output.snapshot
  Use -v flag to see diff
  Run with UPDATE_SNAPSHOTS=1 to update snapshots

═══════════════════════════════════════════════════════
  TEST SUMMARY
═══════════════════════════════════════════════════════

  Total Tests:  15
  Passed:       14
  Failed:       1
  Pass Rate:    93%

✗ Some tests failed
```

## Troubleshooting Tests

### Tests Fail After Code Changes

**Cause**: Command output changed

**Solution**:
1. Review the diff to understand changes
2. If changes are intentional:
   ```bash
   ./run-all-tests.sh -u
   ```
3. If changes are bugs, fix the code

### Docker Tests Fail

**Cause**: Docker not running or not accessible

**Check Docker**:
```bash
# Verify Docker is running
docker ps

# Check permissions
docker run hello-world
```

**Solution**:
```bash
# Start Docker
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### Snapshot Mismatches

**Cause**: Output format changed

**View differences**:
```bash
./run-all-tests.sh -v
```

**Update if correct**:
```bash
./run-all-tests.sh -u
```

### Permission Denied

**Cause**: Test scripts not executable

**Solution**:
```bash
cd __tests
chmod +x *.sh
```

## Best Practices

### Before Committing

```bash
# Run all tests
cd __tests
./run-all-tests.sh

# Run integration tests (if possible)
./run-all-tests.sh -i
```

### After Changing Output

```bash
# Update snapshots
./run-all-tests.sh -u

# Verify tests pass
./run-all-tests.sh
```

### When Adding Features

1. Write tests first (TDD approach)
2. Implement feature
3. Generate snapshots if needed
4. Verify all tests pass

### Regular Testing

- Run tests before each commit
- Run integration tests before releases
- Keep snapshots up-to-date
- Add tests for bug fixes

## CI/CD Integration

### GitHub Actions

Tests run automatically on push/PR:
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
          ./run-all-tests.sh
```

### Local Pre-commit Hook

Add to `.git/hooks/pre-commit`:
```bash
#!/bin/bash
cd __tests
./run-all-tests.sh
```

## Test Coverage

Current test coverage:

- ✅ **Basic Commands**: 100% (help, version, list, validate)
- ✅ **Stack Management**: 100% (up, down, restart, status, logs, pull, deploy, exec, ps)
- ✅ **Database Commands**: 100% (backup, restore, list, status, exec, shell, migrate, reset)
- ✅ **Tag Commands**: 100% (create, deploy, move, delete, list, rollback, status)
- ✅ **API Commands**: 100% (start, stop, status, logs)

## Advanced Topics

### Custom Test Helpers

Add to `test-helpers.sh`:
```bash
my_custom_helper() {
    # Your custom logic
}

export -f my_custom_helper
```

### Parallel Testing

Run multiple test suites simultaneously:
```bash
./test-basic-commands.sh & \
./test-stack-commands.sh & \
wait
```

### Performance Testing

Time test execution:
```bash
time ./run-all-tests.sh
```

### Coverage Reports

Track which commands are tested:
```bash
grep -r "run_kompose" test-*.sh | sort -u
```

## Resources

- **Test Suite README**: `__tests/README.md`
- **Implementation Summary**: `__tests/IMPLEMENTATION_SUMMARY.md`
- **Test Helpers Source**: `__tests/test-helpers.sh`

## Quick Reference

| Task | Command |
|------|---------|
| Run all tests | `./run-all-tests.sh` |
| Run specific test | `./run-all-tests.sh -t basic-commands` |
| Update snapshots | `./run-all-tests.sh -u` |
| Integration tests | `./run-all-tests.sh -i` |
| Verbose output | `./run-all-tests.sh -v` |
| Help | `./run-all-tests.sh -h` |

---

*"The best time to write tests was yesterday. The second best time is now."*
