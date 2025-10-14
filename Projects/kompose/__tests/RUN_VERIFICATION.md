# Making Test Scripts Executable

The verification script needs to be executable. Run this command:

```bash
chmod +x __tests/verify-artifact-locations.sh
```

Or to make all test scripts executable at once:

```bash
chmod +x __tests/*.sh
```

## Running the Verification

After making the script executable, run it to verify the changes:

```bash
cd /home/valknar/Projects/kompose
bash __tests/verify-artifact-locations.sh
```

Expected output:
- ✓ env-vars.json created in temp directory
- ✓ config.json created in temp directory
- ✓ No test artifacts found in root directory
- ✓ Temp directory removed
- ✓ Verification complete!
