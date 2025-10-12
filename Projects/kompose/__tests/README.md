# Kompose Test Suite

Comprehensive test suite for the Kompose Docker Compose Stack Manager.

## Overview

This test suite provides:
- **Snapshot Testing** - Capture and compare command outputs
- **Unit Tests** - Test individual commands and functions
- **Integration Tests** - Test full stack lifecycle (requires Docker)
- **Regression Testing** - Prevent breaking changes

## Directory Structure

```
__tests/
├── README.md                    # This file
├── run-all-tests.sh            # Master test runner
├── test-helpers.sh             # Shared test utilities
├── test-basic-commands.sh      # Tests for help, version, list, etc.
├── test-stack-commands.sh      # Tests for up, down, restart, status
├── test-database-commands.sh   # Tests for database operations
├── test-tag-commands.sh        # Tests for git tag deployments
├── test-api-commands.sh        # Tests for API server commands
├── snapshots/                  # Snapshot files for comparison
│   ├── help_output.snapshot
│   ├── version_output.snapshot
│   └── ...
└── temp/                       # Temporary test files (gitignored)
```

## Quick Start

### Run All Tests

```bash
cd __tests
./run-all-tests.sh
```

### Run Specific Test Suite

```bash
./run-all-tests.sh -t basic-commands
./run-all-tests.sh -t stack-commands
./run-all-tests.sh -t database-commands
```

### Update Snapshots

When command outputs change intentionally:

```bash
./run-all-tests.sh -u
```

### Run Integration Tests

Requires Docker to be running:

```bash
./run-all-tests.sh -i
```

### Combine Options

```bash
# Update snapshots and run integration tests
./run-all-tests.sh -u -i

# Verbose output for specific test
./run-all-tests.sh -v -t basic-commands
```

## Test Suites

### Basic Commands (`test-basic-commands.sh`)

Tests fundamental kompose commands:
- `kompose help` - Help text output
- `kompose version` - Version information
- `kompose list` - Stack listing
- `kompose validate` - Configuration validation
- Error handling for invalid commands

**Example:**
```bash
./test-basic-commands.sh
```

### Stack Management (`test-stack-commands.sh`)

Tests stack lifecycle commands:
- `kompose up [STACK]` - Start stacks
- `kompose down [STACK]` - Stop stacks
- `kompose restart [STACK]` - Restart stacks
- `kompose status [STACK]` - Stack status
- `kompose logs [STACK]` - View logs
- `kompose pull [STACK]` - Pull images
- `kompose deploy [STACK] [VERSION]` - Deploy version
- `kompose exec [STACK] [CMD]` - Execute commands
- `kompose ps` - Show all containers

**Example:**
```bash
./test-stack-commands.sh
```

With Docker running:
```bash
RUN_INTEGRATION_TESTS=1 ./test-stack-commands.sh
```

### Database Commands (`test-database-commands.sh`)

Tests database operations:
- `kompose db backup` - Create backups
- `kompose db restore` - Restore from backup
- `kompose db list` - List backups
- `kompose db status` - Database status
- `kompose db exec` - Execute SQL
- `kompose db shell` - Interactive shell
- `kompose db migrate` - Run migrations
- `kompose db reset` - Reset database

**Example:**
```bash
./test-database-commands.sh
```

### Tag Commands (`test-tag-commands.sh`)

Tests git tag deployment commands:
- `kompose tag create` - Create deployment tag
- `kompose tag deploy` - Create and deploy tag
- `kompose tag move` - Move tag to new commit
- `kompose tag delete` - Delete tag
- `kompose tag list` - List tags
- `kompose tag rollback` - Rollback to previous tag
- `kompose tag status` - Show deployment status

**Example:**
```bash
./test-tag-commands.sh
```

### API Commands (`test-api-commands.sh`)

Tests REST API server:
- `kompose api start` - Start API server
- `kompose api stop` - Stop API server
- `kompose api status` - Check status
- `kompose api logs` - View logs

**Example:**
```bash
./test-api-commands.sh
```

## Snapshot Testing

### How It Works

1. **First Run**: Creates baseline snapshots of command outputs
2. **Subsequent Runs**: Compares current output against snapshots
3. **Failures**: Shows diff when output doesn't match
4. **Updates**: Use `-u` flag to update snapshots

### Snapshot Files

Snapshots are stored in `snapshots/` directory:

```
snapshots/
├── help_output.snapshot         # kompose help output
├── version_output.snapshot      # kompose version output
├── list_output.snapshot         # kompose list output
├── status_all_syntax.snapshot   # kompose status output
└── ...
```

### Creating Snapshots

```bash
# Generate all snapshots
UPDATE_SNAPSHOTS=1 ./run-all-tests.sh

# Generate specific test snapshots
UPDATE_SNAPSHOTS=1 ./test-basic-commands.sh
```

### When to Update Snapshots

Update snapshots when:
- You intentionally change command output
- You add new features that modify output
- You fix formatting or display issues

**DO NOT** update snapshots to "fix" failing tests without understanding why they fail!

## Writing Tests

### Test Structure

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

### Available Assertions

```bash
# Equality
assert_equals "expected" "actual" "test description"

# String contains
assert_contains "haystack" "needle" "test description"

# String does not contain
assert_not_contains "haystack" "needle" "test description"

# Exit code
assert_exit_code 0 $? "command succeeded"

# File exists
assert_file_exists "/path/to/file" "file exists"

# Directory exists
assert_directory_exists "/path/to/dir" "directory exists"
```

### Available Utilities

```bash
# Run kompose command
output=$(run_kompose status core)

# Run kompose quietly (no output)
run_kompose_quiet up core

# Capture any command output
output=$(capture_output docker ps)

# Snapshot operations
create_snapshot "name" "$output"
update_snapshot "name" "$output"
compare_snapshot "name" "$output" "description"

# Docker utilities
wait_for_container "container-name" 30  # Wait up to 30 seconds
is_docker_available                     # Check if Docker is available
```

## Integration Tests

Integration tests actually start Docker containers and test real functionality.

### Requirements

- Docker installed and running
- Sufficient system resources
- Network connectivity (for pulling images)

### Running Integration Tests

```bash
# Enable integration tests
./run-all-tests.sh -i

# Or set environment variable
RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh
```

### What Integration Tests Do

- Start actual Docker containers
- Test stack lifecycle (up/down/restart)
- Verify container health
- Test inter-stack dependencies
- Test database operations
- Clean up after tests

### Integration Test Example

```bash
test_core_stack_lifecycle() {
    if [ $DOCKER_AVAILABLE -eq 0 ]; then
        log_skip "Skipping - Docker not available"
        return
    fi
    
    # Start stack
    run_kompose up core -d
    
    # Wait for containers
    wait_for_container "core-postgres" 30
    
    # Check status
    status=$(run_kompose status core)
    assert_contains "$status" "healthy" "Core stack is healthy"
    
    # Stop stack
    run_kompose down core
}
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Unit Tests
        run: |
          cd __tests
          ./run-all-tests.sh
      
      - name: Run Integration Tests
        run: |
          cd __tests
          ./run-all-tests.sh -i
```

### GitLab CI Example

```yaml
test:
  stage: test
  script:
    - cd __tests
    - ./run-all-tests.sh
    - ./run-all-tests.sh -i
```

## Troubleshooting

### Tests Fail After Changes

1. **Review the diff** - Understand what changed
2. **Verify intentional** - Is the change expected?
3. **Update snapshots** - If change is correct: `./run-all-tests.sh -u`
4. **Fix bugs** - If change is unexpected, fix the bug

### Docker Not Available

```bash
# Skip integration tests
./run-all-tests.sh

# Or run specific non-Docker tests
./test-basic-commands.sh
```

### Permission Denied

```bash
# Make scripts executable
chmod +x __tests/*.sh
```

### Snapshot Mismatches

```bash
# View diff
./run-all-tests.sh  # Shows diff in output

# Update specific test snapshots
UPDATE_SNAPSHOTS=1 ./test-basic-commands.sh

# Update all snapshots
./run-all-tests.sh -u
```

## Best Practices

### Writing Tests

1. **Test one thing per test** - Keep tests focused
2. **Use descriptive names** - Make failures easy to understand
3. **Clean up after tests** - Don't leave containers running
4. **Use snapshots wisely** - Not everything needs snapshots
5. **Handle errors** - Use `set +e` when testing error cases

### Maintaining Tests

1. **Update snapshots carefully** - Review diffs before updating
2. **Run tests before committing** - Catch issues early
3. **Add tests for bugs** - Prevent regressions
4. **Document complex tests** - Help future maintainers
5. **Keep tests fast** - Minimize Docker usage in unit tests

### Running Tests

1. **Run locally before pushing** - Catch issues early
2. **Run full suite periodically** - Not just changed tests
3. **Use verbose mode for debugging** - `-v` flag
4. **Run integration tests before releases** - `-i` flag
5. **Update snapshots as needed** - `-u` flag

## Environment Variables

```bash
# Update all snapshots
UPDATE_SNAPSHOTS=1 ./run-all-tests.sh

# Run integration tests
RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh

# Verbose output
VERBOSE=1 ./run-all-tests.sh

# Combine multiple
UPDATE_SNAPSHOTS=1 RUN_INTEGRATION_TESTS=1 ./run-all-tests.sh
```

## Test Coverage

Current test coverage:

- ✅ **Basic Commands** - help, version, list, validate
- ✅ **Stack Management** - up, down, restart, status, logs, pull, deploy, exec, ps
- ✅ **Database Commands** - backup, restore, list, status, exec, shell, migrate, reset
- ✅ **Tag Commands** - create, deploy, move, delete, list, rollback, status
- ✅ **API Commands** - start, stop, status, logs
- ⏳ **Environment Validation** - Planned
- ⏳ **End-to-End Tests** - Planned

## Contributing

### Adding New Tests

1. Create test file: `test-your-feature.sh`
2. Source helpers: `source "${SCRIPT_DIR}/test-helpers.sh"`
3. Write test functions
4. Add to `run-all-tests.sh`
5. Generate snapshots: `UPDATE_SNAPSHOTS=1 ./test-your-feature.sh`
6. Run full suite: `./run-all-tests.sh`

### Example Pull Request Checklist

- [ ] Tests pass locally
- [ ] New features have tests
- [ ] Snapshots updated if needed
- [ ] Integration tests pass (if applicable)
- [ ] Documentation updated

## Resources

- [Kompose Documentation](../_docs/content/)
- [Stack Configuration](../_docs/content/5.stacks/)
- [Test Helpers Source](./test-helpers.sh)

## License

Same as Kompose project.

---

**Last Updated**: 2025-01-12  
**Version**: 1.0.0
