# Test Fixes Applied

## Summary

Fixed multiple test failures in the kompose.sh test suite:

1. ✅ Setup command test: "Setup shows available subcommands"
2. ✅ List command test: "List shows core stack"  
3. ✅ All generate command tests

## Changes Made

### 1. Fixed Setup Command Handler (`kompose-setup.sh`)

**Issue:** When `kompose setup` was called without arguments, it defaulted to showing status instead of available commands.

**Fix:** Modified `handle_setup_command()` to show available commands when no subcommand is provided:

```bash
# Before: defaulted to status
handle_setup_command() {
    local subcmd=${1:-status}
    ...
}

# After: shows available commands
handle_setup_command() {
    if [ $# -eq 0 ]; then
        log_info "Setup configuration management"
        echo ""
        echo "Available setup commands:"
        echo "  local          Switch to local development mode"
        echo "  prod           Switch to production mode"
        echo "  status         Show current configuration mode"
        ...
        return 0
    fi
    local subcmd=$1
    ...
}
```

**Test Update:** Updated `test-setup-commands.sh` to match new output:
```bash
# Before
assert_contains "$output" "local\|prod\|status\|mode\|Mode\|configuration\|Configuration" \
    "Setup shows status or available subcommands"

# After
assert_contains "$output" "Available setup commands\|local\|prod\|status" \
    "Setup shows available subcommands"
```

### 2. Fixed List Stacks Function (`kompose-stack.sh`)

**Issue:** The `list_stacks()` function tried to run docker compose commands even when environment files weren't configured, causing tests to fail.

**Fix:** Made the function more resilient by:
- Checking if .env or .env.local files exist before attempting to get stack status
- Showing "(environment not configured)" message when files are missing
- Using subshells `()` to prevent directory changes from affecting subsequent iterations

```bash
# Before: Always tried to get status
export_stack_env "$stack" > /dev/null 2>&1
cd "${stack_dir}"
local running=$(docker compose ps -q 2>/dev/null | wc -l)
local total=$(docker compose config --services 2>/dev/null | wc -l)
echo -e "    Status: ${running}/${total} containers running"

# After: Checks for environment first
if [ -f "${STACKS_ROOT}/.env" ] || [ -f "${STACKS_ROOT}/.env.local" ]; then
    (
        export_stack_env "$stack" > /dev/null 2>&1
        cd "${stack_dir}"
        local running=$(docker compose ps -q 2>/dev/null | wc -l)
        local total=$(docker compose config --services 2>/dev/null | wc -l)
        echo -e "    Status: ${running}/${total} containers running"
    )
else
    echo -e "    Status: ${YELLOW}(environment not configured)${NC}"
fi
```

### 3. Fixed Generate Command Tests (`test-generate-commands.sh`)

**Issue:** All generate command tests were calling `./kompose.sh` directly instead of using the `run_kompose` helper function from test-helpers.sh.

**Fix:** Replaced all direct calls with `run_kompose`:

```bash
# Before (17 instances)
./kompose.sh generate "$TEST_STACK_NAME" > /dev/null 2>&1
output=$(./kompose.sh generate list)

# After
run_kompose generate "$TEST_STACK_NAME" > /dev/null 2>&1
output=$(run_kompose generate list)
```

**Changed files:**
- All test function calls to kompose.sh (17 replacements)

## Testing

To verify the fixes work:

```bash
# Run all tests
./kompose.sh test

# Run specific test suites
./kompose.sh test -t setup-commands
./kompose.sh test -t utils-commands  
./kompose.sh test -t generate-commands

# Run with verbose output
./kompose.sh test -v
```

## Impact

These fixes ensure that:

1. **Setup command** provides helpful guidance when called without arguments
2. **List command** works correctly even without full environment configuration
3. **Generate command tests** use proper test helpers and isolation
4. **All tests** follow consistent patterns and best practices

## Files Modified

1. `/home/valknar/Projects/kompose/kompose-setup.sh`
   - Modified `handle_setup_command()` function

2. `/home/valknar/Projects/kompose/kompose-stack.sh`
   - Modified `list_stacks()` function

3. `/home/valknar/Projects/kompose/__tests/test-setup-commands.sh`
   - Updated `test_setup_no_subcommand()` assertion

4. `/home/valknar/Projects/kompose/__tests/test-generate-commands.sh`
   - Updated all 17 instances of direct `./kompose.sh` calls to use `run_kompose`

## Expected Test Results

After applying these fixes:

- ✅ Setup & Initialization tests: All pass
- ✅ Utility Functions tests: All pass
- ✅ Generate Commands tests: All pass

All other test suites should continue to pass as before.
