#!/bin/bash

cd /home/valknar/Projects/kompose

echo "=== Testing setup command ==="
bash kompose.sh setup 2>&1
echo ""
echo "Exit code: $?"
echo ""

echo "=== Testing list command ==="
bash kompose.sh list 2>&1
echo ""
echo "Exit code: $?"
echo ""

echo "=== Testing generate command ==="
bash kompose.sh generate 2>&1
echo ""
echo "Exit code: $?"
echo ""
