#!/bin/bash

# Make all test scripts executable

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "${SCRIPT_DIR}"/test-*.sh
chmod +x "${SCRIPT_DIR}"/run-all-tests.sh

echo "✓ All test scripts are now executable"
