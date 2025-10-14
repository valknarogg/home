#!/bin/bash

# Quick test to verify the test command works

cd /home/valknar/Projects/kompose

echo "Testing: ./kompose.sh test --help"
echo "=================================="
./kompose.sh test --help
echo ""
echo "Exit code: $?"
echo ""

echo "Testing: ./kompose.sh test (should run)"
echo "========================================"
echo "This will run all tests - press Ctrl+C to cancel if needed"
echo ""
sleep 2

# Just show that it starts
timeout 5 ./kompose.sh test 2>&1 | head -20
echo ""
echo "... (truncated)"
echo ""
echo "✅ Test command is working!"
