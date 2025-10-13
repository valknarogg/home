---
title: Testing Guide
description: Comprehensive guide for testing Kompose
navigation:
  icon: i-lucide-test-tube
---

# Testing Guide

## Overview

Kompose includes a comprehensive test suite to ensure reliability and prevent regressions. The test suite uses snapshot testing, unit tests, and integration tests to validate all functionality.

## Test Suite Location

```
__tests/
├── README.md                    # Test suite documentation
├── run-all-tests.sh            # Master test runner
├── test-helpers.sh             # Shared test utilities
├── test-basic-commands.sh      # Basic command tests
├── test-stack-commands.sh      # Stack management tests
├── test-database-commands.sh   # Database operation tests
├── test-tag-commands.sh        # Git tag deployment tests
├── test-api-commands.sh        # API server tests
└── snapshots/                  # Snapshot comparison files
```

## Quick Start

### Using the Test Command (Recommended)

The easiest way to run tests is using the built-in `test` command:

```bash
# Run all tests
./kompose.sh test

# Run specific test suite
./kompose.sh test -t basic-commands
./kompose.sh test -t stack-commands

# Update snapshots when outputs change intentionally
./kompose.sh test -u

# Run integration tests (requires Docker)
./kompose.sh test -i

# Combine options
./kompose.sh test -u -i
./kompose.sh test -v -t api-commands
```

### Using the Test Runner Directly

You can also run the test runner directly:

```bash
cd __tests
./run-all-tests.sh
```

### Run Specific Test Suite

```bash
# Using kompose command (recommended)
./kompose.sh test -t basic-commands
./kompose.sh test -t stack-commands
./kompose.sh test -t database-commands

# Using test runner directly
cd __tests
./run-all-tests.sh -t basic-commands
```

### Update Snapshots

When you intentionally change command outputs:

```bash
# Using kompose command (recommended)
./kompose.sh test -u

# Using test runner directly
cd __tests
./run-all-tests.sh -u
```

### Run Integration Tests

Requires Docker to be running:

```bash
# Using kompose command (recommended)
./kompose.sh test -i

# Using test runner directly
cd __tests
./run-all-tests.sh -i
```

## Test Types

### Unit Tests

Test individual commands without Docker:
- Command syntax validation
- Error handling
- Output format verification
- Snapshot comparison

**Example:**
```bash
./test-basic-commands.sh
```

### Integration Tests

Test actual Docker container operations:
- Stack lifecycle (up/down/restart)
- Container health checks
- Inter-stack dependencies
- Database operations

**Enable with:**
```bash
./run-all-tests.sh -i
```

### Snapshot Tests

Compare command outputs against known-good baselines:
- Detect unexpected output changes
- Ensure consistent formatting
- Validate help text accuracy
- Track version information

**Update snapshots:**
```bash
./run-all-tests.sh -u
```

## Test Coverage

### Basic Commands ✅

- `kompose help` - Help text validation
- `kompose version` - Version information
- `kompose list` - Stack listing
- `kompose validate` - Configuration validation
- Invalid command handling

### Stack Management ✅

- `kompose up [STACK]` - Start stacks
- `kompose down [STACK]` - Stop stacks  
- `kompose restart [STACK]` - Restart stacks
- `kompose status [STACK]` - Stack status
- `kompose logs [STACK]` - View logs
- `kompose pull [STACK]` - Pull images
- `kompose deploy [STACK] [VERSION]` - Deploy specific version
- `kompose exec [STACK] [CMD]` - Execute commands
- `kompose ps` - Show all containers

### Database Commands ✅

- `kompose db backup` - Create backups
- `kompose db restore` - Restore from backup
- `kompose db list` - List backups
- `kompose db status` - Database status
- `kompose db exec` - Execute SQL
- `kompose db shell` - Interactive shell
- `kompose db migrate` - Run migrations
- `kompose db reset` - Reset database

### Git Tag Commands ✅

- `kompose tag create` - Create deployment tag
- `kompose tag deploy` - Create and deploy
- `kompose tag move` - Move tag to new commit
- `kompose tag delete` - Delete tag
- `kompose tag list` - List tags
- `kompose tag rollback` - Rollback deployment
- `kompose tag status` - Show deployment status

### API Commands ✅

- `kompose api start` - Start API server
- `kompose api stop` - Stop API server
- `kompose api status` - Check server status
- `kompose api logs` - View server logs

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
    
    assert_contains "$output" "expected text" \
        "Output contains expected text"
    
    if [ "${UPDATE_SNAPSHOTS}" = "1" ]; then
        create_snapshot "your_feature" "$output"
    else
        compare_snapshot "your_feature" "$output" \
            "Your feature output matches snapshot"
    fi
}

test_your_feature

cleanup_test_env
print_test_summary
```

### Using Assertions

```bash
# String equality
assert_equals "expected" "actual" "test description"

# String contains
assert_contains "$output" "success" "command succeeded"

# String does not contain
assert_not_contains "$output" "error" "no errors occurred"

# Exit code
assert_exit_code 0 $? "command exited successfully"

# File operations
assert_file_exists "/path/to/file" "file was created"
assert_directory_exists "/path/to/dir" "directory exists"
```

### Running Kompose Commands

```bash
# Capture output
output=$(run_kompose status core 2>&1)

# Run quietly (no output capture)
run_kompose_quiet up core

# Capture any command
output=$(capture_output docker ps)
```

### Snapshot Testing

```bash
# Create snapshot (UPDATE_SNAPSHOTS=1)
create_snapshot "test_name" "$output"

# Compare against snapshot
compare_snapshot "test_name" "$output" "snapshot matches"

# Update snapshot
update_snapshot "test_name" "$output"
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
      
      - name: Make scripts executable
        run: |
          chmod +x __tests/*.sh
      
      - name: Run Unit Tests
        run: |
          cd __tests
          ./run-all-tests.sh
      
      - name: Run Integration Tests
        run: |
          cd __tests
          ./run-all-tests.sh -i
      
      - name: Upload Test Results
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: __tests/temp/
```

### GitLab CI

```yaml
stages:
  - test

unit_tests:
  stage: test
  script:
    - cd __tests
    - chmod +x *.sh
    - ./run-all-tests.sh

integration_tests:
  stage: test
  script:
    - cd __tests
    - chmod +x *.sh
    - ./run-all-tests.sh -i
  only:
    - main
    - develop
```

### Gitea Actions

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

## Troubleshooting Tests

### Tests Fail After Changes

1. **Review the diff** - Understand what changed
   ```bash
   ./run-all-tests.sh  # Shows diffs in output
   ```

2. **Verify change is intentional**
   - Is the new output correct?
   - Was the change expected?

3. **Update snapshots if correct**
   ```bash
   ./run-all-tests.sh -u
   ```

4. **Fix bugs if incorrect**
   - Review your code changes
   - Fix the issue
   - Re-run tests

### Docker Not Available

Integration tests require Docker:

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Start Docker service
sudo systemctl start docker

# Add user to docker group
sudo usermod -aG docker $USER
```

Or skip integration tests:
```bash
./run-all-tests.sh  # Only runs unit tests
```

### Permission Denied

Make scripts executable:

```bash
cd __tests
chmod +x *.sh
./run-all-tests.sh
```

### Snapshot Mismatches

View detailed diff:
```bash
./run-all-tests.sh -v  # Verbose mode
```

Update specific test snapshots:
```bash
UPDATE_SNAPSHOTS=1 ./test-basic-commands.sh
```

Update all snapshots:
```bash
./run-all-tests.sh -u
```

## Best Practices

### Before Committing

1. **Run all tests**
   ```bash
   ./kompose.sh test
   ```

2. **Run integration tests** (if Docker available)
   ```bash
   ./kompose.sh test -i
   ```

3. **Update snapshots** (if you changed output)
   ```bash
   ./kompose.sh test -u
   ```

4. **Review diffs** carefully before updating snapshots

**Alternative (using test runner directly):**
```bash
cd __tests
./run-all-tests.sh
./run-all-tests.sh -i
./run-all-tests.sh -u
```

### Adding New Features

1. **Write tests first** (TDD approach)
2. **Create test file** in `__tests/`
3. **Add to test runner** in `run-all-tests.sh`
4. **Generate snapshots**
   ```bash
   # Using kompose command
   ./kompose.sh test -u -t new-feature
   
   # Or directly
   cd __tests
   UPDATE_SNAPSHOTS=1 ./test-new-feature.sh
   ```
5. **Verify all tests pass**
   ```bash
   # Using kompose command (recommended)
   ./kompose.sh test -i
   
   # Or directly
   cd __tests
   ./run-all-tests.sh -i
   ```

### Maintaining Tests

1. **Keep tests focused** - One test per feature
2. **Use descriptive names** - Easy to understand failures
3. **Clean up after tests** - Don't leave containers running
4. **Document complex tests** - Help future maintainers
5. **Update snapshots carefully** - Review all diffs

## Running in Development

### Watch Mode (Manual)

```bash
# In one terminal - watch for changes using kompose command
watch -n 5 './kompose.sh test'

# Or watch test runner directly
cd __tests
watch -n 5 './run-all-tests.sh'

# Make changes in another terminal
```

### Quick Iteration

```bash
# Test specific feature you're working on (using kompose command)
./kompose.sh test -t stack-commands

# Update snapshots as you go
./kompose.sh test -u -t stack-commands

# Run full suite before commit
./kompose.sh test -i

# Alternative: Using test runner directly
cd __tests
./test-stack-commands.sh
UPDATE_SNAPSHOTS=1 ./test-stack-commands.sh
./run-all-tests.sh -i
```

## Test Output

### Successful Run

```
╔════════════════════════════════════════════════════════════════╗
║              KOMPOSE TEST SUITE                                ║
║              Version 1.0.0                                     ║
╚════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════
  TESTING: Basic Commands
═══════════════════════════════════════════════════════

[TEST] Testing 'kompose help' command
[PASS] Help output contains title
[PASS] Help output contains stack commands section
[PASS] Help command output matches snapshot

═══════════════════════════════════════════════════════
  TEST SUMMARY
═══════════════════════════════════════════════════════

  Total Tests:  25
  Passed:       25
  Failed:       0

✓ All tests passed!
```

### Failed Test

```
[TEST] Testing 'kompose status' command
[FAIL] Status command output matches snapshot - Snapshot mismatch
  Snapshot: snapshots/status_output.snapshot
  Diff:
  --- expected
  +++ actual
  @@ -1,3 +1,3 @@
  -Stack: core (running)
  +Stack: core (stopped)
  
  Run with UPDATE_SNAPSHOTS=1 to update snapshots
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `UPDATE_SNAPSHOTS` | Update snapshot files | `0` |
| `RUN_INTEGRATION_TESTS` | Run Docker integration tests | `0` |
| `VERBOSE` | Enable verbose output | `0` |

**Usage:**
```bash
UPDATE_SNAPSHOTS=1 ./run-all-tests.sh
RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh
VERBOSE=1 ./run-all-tests.sh
```

## See Also

- [Test Suite README](/__tests/README.md)
- [Contributing Guide](/contributing)
- [Development Guide](/guide/development)

---

**For detailed test suite documentation, see [__tests/README.md](/__tests/README.md)**
