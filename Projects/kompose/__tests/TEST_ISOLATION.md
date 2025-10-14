# Test Isolation and Artifacts

## Overview

Kompose tests are designed to minimize impact on the actual project while testing functionality.

## Test Directory Structure

```
__tests/
├── temp/                          # Temporary test artifacts (auto-created, auto-cleaned)
│   ├── +custom/                  # Test custom stacks (isolated)
│   ├── _docs/                    # Test documentation (isolated)
│   ├── __tests/generated/        # Test-generated files (isolated)
│   ├── backups/                  # Test backups (isolated)
│   └── .env                      # Test environment file
├── snapshots/                     # Test snapshots (persistent)
├── test-*.sh                      # Test suites
├── test-helpers.sh                # Test utilities
└── run-all-tests.sh              # Test runner
```

## Isolation Strategy

### Fully Isolated Tests (Use `__tests/temp/`)

These tests create all artifacts in the temp directory:

1. **Basic command tests** - No file creation
2. **Stack management tests** - No file creation
3. **Database tests** - No file creation
4. **API tests** - No file creation
5. **Setup tests** - No file creation
6. **Environment tests** - No file creation

**Temp Directory Contents:**
- `.env` - Test environment configuration
- `+custom/` - Would contain test stacks if fully isolated
- `_docs/` - Would contain test documentation if fully isolated
- `backups/` - Would contain test backups if fully isolated

**Cleanup:** Automatically cleaned by `cleanup_test_env()` after each test suite.

### Partially Isolated Tests (Use Project Directories)

These tests must interact with actual project directories:

1. **Generate command tests** - Creates actual stacks
   - Why: `kompose generate` uses `STACKS_ROOT` which points to the real project
   - Impact: Creates files in `+custom/`, `_docs/`, and `__tests/generated/`
   - Cleanup: **Always cleaned up after each test**

**Files Created in Project:**
- `+custom/testapp/` - Test stack directory
- `+custom/testapp/compose.yaml` - Test compose file
- `+custom/testapp/.env` - Test environment file
- `_docs/content/5.stacks/+custom/testapp.md` - Test documentation
- `__tests/generated/test-testapp.sh` - Test script

**Cleanup Strategy:**
```bash
# Before each generate test
setup_generate_tests() {
    cleanup_test_stack  # Remove any leftover files
}

# After each generate test  
teardown_generate_tests() {
    cleanup_test_stack  # Remove created files
}
```

## Environment Files

### Test Environment (`.env`)

**Location:** `__tests/temp/.env` (primary) and `<project_root>/.env` (fallback)

**Purpose:** Provides minimal environment for tests without full configuration.

**Content:**
```bash
# Test environment configuration
TIMEZONE=Europe/Amsterdam
NETWORK_NAME=kompose
NODE_ENV=test
ENVIRONMENT=test
```

**Management:**
- Created by `setup_test_env()` in `test-helpers.sh`
- Copied to project root only if no `.env` exists
- Project root `.env` is NOT deleted by cleanup (may be needed by multiple test suites)

### Project Environment (`.env`)

**Location:** `<project_root>/.env`

**Purpose:** Production/development environment (not used by most tests).

**Management:**
- Not modified by tests
- Only created if missing (from temp `.env`)
- Never deleted by test cleanup

## Test Artifacts by Type

### Temporary (Cleaned After Each Suite)

Located in `__tests/temp/`:
- Test environment files
- Test directories
- Test backups
- Any test-specific data

**Cleaned by:** `cleanup_test_env()` at end of each test suite

### Persistent (Not Cleaned)

Located in `__tests/`:
- `snapshots/` - Test snapshots for comparison
- `test-*.sh` - Test suite files
- `test-helpers.sh` - Test utilities
- Documentation files (`.md`)
- Verification scripts

**Cleaned by:** Manual cleanup or version control

### Project Artifacts (Cleaned Immediately)

Located in project directories:
- `+custom/testapp/` - Test stack (cleaned after each test)
- `_docs/content/5.stacks/+custom/testapp.md` - Test docs (cleaned after each test)
- `__tests/generated/test-testapp.sh` - Test script (cleaned after each test)

**Cleaned by:** `cleanup_test_stack()` before and after each generate test

## Best Practices

### For Test Developers

1. **Use `TEMP_DIR` for test artifacts**
   ```bash
   TEST_FILE="${TEMP_DIR}/test-data.txt"
   ```

2. **Clean up after tests**
   ```bash
   teardown_my_test() {
       rm -f "${TEMP_DIR}/my-test-file"
   }
   ```

3. **Document non-isolated tests**
   ```bash
   # NOTE: This test modifies actual project files
   test_generate_creates_stack() {
       # ... test code ...
       cleanup_test_stack  # Always clean up!
   }
   ```

4. **Check for leftover artifacts**
   ```bash
   # Before running tests
   ls -la __tests/temp/
   ls -la +custom/testapp/
   ```

### For CI/CD

1. **Always run cleanup**
   ```bash
   ./kompose.sh test
   # Temp is auto-cleaned, but verify:
   [ ! -d "__tests/temp" ] || echo "Temp directory exists"
   ```

2. **Check for leftover test stacks**
   ```bash
   # After tests, these should not exist:
   [ ! -d "+custom/testapp" ] || echo "Test stack not cleaned!"
   [ ! -f "_docs/content/5.stacks/+custom/testapp.md" ] || echo "Test docs not cleaned!"
   ```

3. **Verify project is clean**
   ```bash
   git status --porcelain | grep -E "(testapp|my-test-app)" && echo "Test artifacts found!"
   ```

## Verification

### Check Test Isolation

```bash
# Run this before tests
ls -la __tests/temp/  # Should not exist or be empty

# Run tests
./kompose.sh test

# Run this after tests
ls -la __tests/temp/  # Should not exist (cleaned)
ls -la +custom/       # Should not contain testapp/
ls -la _docs/content/5.stacks/+custom/  # Should not contain testapp.md
```

### Manual Cleanup (If Needed)

```bash
# Clean temp directory
rm -rf __tests/temp/

# Clean test stacks (if tests failed to clean up)
rm -rf +custom/testapp/
rm -rf +custom/my-test-app/
rm -f _docs/content/5.stacks/+custom/testapp.md
rm -f _docs/content/5.stacks/+custom/my-test-app.md
rm -f __tests/generated/test-testapp.sh
rm -f __tests/generated/test-my-test-app.sh
```

## Future Improvements

### Full Isolation for Generate Tests

To fully isolate generate tests:

1. **Option 1: Override STACKS_ROOT**
   ```bash
   STACKS_ROOT="${TEMP_DIR}" run_kompose generate testapp
   ```

2. **Option 2: Mock file system**
   - Use temporary mount points
   - Redirect file operations to temp

3. **Option 3: Integration test flag**
   - Mark generate tests as integration tests
   - Run with `-i` flag
   - Accept that they modify project

### Recommended Approach

Use **Option 3** (Integration Tests):
```bash
# Unit tests (isolated, fast)
./kompose.sh test

# Integration tests (modify project, slower)
./kompose.sh test -i
```

## Summary

| Test Type | Artifacts Location | Cleanup | Impact |
|-----------|-------------------|---------|--------|
| Unit Tests | `__tests/temp/` | Automatic | None |
| Generate Tests | Project dirs | Per-test | Temporary |
| Snapshots | `__tests/snapshots/` | Manual | Persistent |

**Key Points:**
- ✅ Most tests are fully isolated in `__tests/temp/`
- ✅ Generate tests clean up after themselves
- ✅ Project `.env` is preserved for other tests
- ✅ No manual cleanup needed for normal test runs
- ⚠️  Generate tests briefly create files in project (but always clean up)
