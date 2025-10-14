# Test Command Fix

## Problem

Running `./kompose.sh test` did nothing - no output, no tests running.

## Root Cause

The test command handler had two issues:

### Issue 1: Double shift
```bash
main() {
    local command=$1
    shift  # ← First shift (correct)
    
    if [ "$command" = "test" ]; then
        shift  # ← Second shift (WRONG - removes first test arg)
        test_run_suite "$@"
        return 0
    fi
}
```

The command was shifted twice, which could cause argument handling issues.

### Issue 2: Return instead of exit
```bash
if [ "$command" = "test" ]; then
    test_run_suite "$@"
    return 0  # ← WRONG - just returns from if block, doesn't exit script
fi
```

Using `return 0` in an if-block doesn't exit the script, it just continues to the next part of main().

### Issue 3: No exit code propagation
```bash
test_run_suite() {
    cd "$test_dir"
    bash "./run-all-tests.sh" "$@"
    # ← Missing exit code capture and directory restoration
}
```

The function didn't capture the test runner's exit code or return to the original directory.

## The Fix

### Change 1: Fixed test command handler in main()
```bash
# Handle test command
if [ "$command" = "test" ]; then
    test_run_suite "$@"  # ← Removed duplicate shift
    exit $?              # ← Changed to exit with test runner's exit code
fi
```

### Change 2: Fixed test_run_suite function
```bash
test_run_suite() {
    local test_dir="${SCRIPT_DIR}/__tests"
    local test_runner="${test_dir}/run-all-tests.sh"
    
    if [ ! -f "$test_runner" ]; then
        log_error "Test runner not found at ${test_runner}"
        log_info "Expected location: __tests/run-all-tests.sh"
        exit 1
    fi
    
    if [ ! -x "$test_runner" ]; then
        log_info "Making test runner executable..."
        chmod +x "$test_runner"
    fi
    
    # Change to test directory and run
    cd "$test_dir"
    bash "./run-all-tests.sh" "$@"
    local exit_code=$?  # ← Capture exit code
    
    # Return to original directory
    cd "${SCRIPT_DIR}"  # ← Restore directory
    
    return $exit_code   # ← Return proper exit code
}
```

## File Modified

- `/home/valknar/Projects/kompose/kompose.sh`

## Verification

### Run the diagnostic script:
```bash
cd /home/valknar/Projects/kompose/__tests
chmod +x diagnose-test-command.sh
./diagnose-test-command.sh
```

Expected output:
```
=== Kompose Test Command Diagnostics ===

1. Checking kompose.sh...
   ✅ kompose.sh exists
   ✅ kompose.sh is executable

2. Checking test directory...
   ✅ __tests directory exists

3. Checking test runner...
   ✅ run-all-tests.sh exists
   ✅ run-all-tests.sh is executable

4. Testing 'kompose test --help'...
[help output should appear]

5. Testing run-all-tests.sh directly...
[help output should appear]

=== Diagnostics Complete ===
```

### Run the actual tests:
```bash
cd /home/valknar/Projects/kompose

# Show help
./kompose.sh test --help

# Run all tests
./kompose.sh test

# Run specific test suite
./kompose.sh test -t setup-commands

# Run with verbose output
./kompose.sh test -v
```

## What Should Happen Now

1. **`./kompose.sh test`** - Runs all test suites and shows results
2. **`./kompose.sh test --help`** - Shows test help
3. **`./kompose.sh test -t <suite>`** - Runs specific test suite
4. **Exit codes** - Properly propagated (0 for success, 1 for failures)

## Testing

After applying the fix:

```bash
# Quick test
cd /home/valknar/Projects/kompose
./kompose.sh test --help

# Full test run
./kompose.sh test
```

Expected final output:
```
╔════════════════════════════════════════════════════════════════╗
║              KOMPOSE TEST SUITE                                ║
║              Version 1.0.0                                     ║
╚════════════════════════════════════════════════════════════════╝

[... test output ...]

FINAL TEST REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ All test suites passed!

  Test suites run: 11
```

## Summary

The test command now:
- ✅ Properly handles arguments
- ✅ Exits with correct exit code  
- ✅ Runs test suite from correct directory
- ✅ Returns to original directory after running
- ✅ Works with all test runner options (-h, -v, -t, -u, -i)
