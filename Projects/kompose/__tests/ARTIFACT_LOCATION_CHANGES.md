# Test Artifact Location Changes

## Summary

All test artifacts (`config.json`, `env-vars.json`, `secrets.json`) created during test execution are now automatically placed in the `__tests/temp` directory instead of the project root.

## Changes Made

### 1. Test Helpers (`__tests/test-helpers.sh`)

**Added environment variable exports in `setup_test_env()`:**
```bash
export TEST_ARTIFACT_DIR="${TEMP_DIR}"
export ENV_VARS_JSON_OUTPUT="${TEMP_DIR}/env-vars.json"
export SECRETS_JSON_OUTPUT="${TEMP_DIR}/secrets.json"
export CONFIG_JSON_OUTPUT="${TEMP_DIR}/config.json"
```

**Enhanced `cleanup_test_env()`:**
- Removes all files from the temp directory
- Cleans up any artifacts accidentally created in the root directory during tests
- Unsets test environment variables after cleanup

### 2. Environment Module (`kompose-env.sh`)

**Modified `export_env_json()` function:**
- Uses `ENV_VARS_JSON_OUTPUT` environment variable as default output path
- When `TEST_ARTIFACT_DIR` is set and output file is a relative path, prepends `TEST_ARTIFACT_DIR` to the path
- This ensures all generated JSON files go to the temp directory during tests

### 3. Secrets Module (`kompose-secrets.sh`)

**Modified `export_secrets()` function:**
- Uses `SECRETS_JSON_OUTPUT` environment variable as default output path
- When `TEST_ARTIFACT_DIR` is set and output file is a relative path, prepends `TEST_ARTIFACT_DIR` to the path
- Ensures all secrets exports during tests go to the temp directory

## How It Works

1. **Test Setup Phase:**
   - `setup_test_env()` creates the `__tests/temp` directory
   - Environment variables are exported to redirect artifact outputs
   - These variables are automatically picked up by the kompose modules

2. **Test Execution:**
   - When tests call `kompose env export` or `kompose secrets export`
   - The output files are automatically placed in `__tests/temp`
   - This works for both default filenames and custom filenames

3. **Test Cleanup:**
   - `cleanup_test_env()` removes the entire temp directory
   - Also cleans up any stray artifacts that might have been created in root
   - Unsets all test-related environment variables

## Benefits

✅ **Clean Project Root:** No test artifacts polluting the main directory  
✅ **Automatic Cleanup:** All test files removed after test completion  
✅ **Git-Friendly:** `__tests/temp` is already in `.gitignore`  
✅ **No Test Changes Required:** Existing tests work without modification  
✅ **Safe:** Only affects test execution, not production usage  

## File Locations

### During Tests
- `config.json` → `__tests/temp/config.json`
- `env-vars.json` → `__tests/temp/env-vars.json`
- `secrets.json` → `__tests/temp/secrets.json`

### In Production
- Files are created in the current working directory (usually project root)
- No change to existing behavior outside of tests

## Testing the Changes

Run any test that creates these artifacts:

```bash
# Test environment commands
bash __tests/test-env-commands.sh

# Test secrets commands
bash __tests/test-secrets-commands.sh

# Verify artifacts are in temp directory
ls -la __tests/temp/
```

All artifact files should be in `__tests/temp/` and automatically cleaned up after tests complete.

## Notes

- The `TEST_ARTIFACT_DIR` environment variable is the key indicator that we're running in test mode
- Only relative paths are redirected; absolute paths are left unchanged
- The cleanup function has a safety check to only remove files modified within the last 5 minutes
- This prevents accidental deletion of legitimate user-created files
