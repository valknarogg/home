#!/usr/bin/env python3
"""
Add timezone configuration to all compose.yaml files in subdirectories.
This ensures all containers use the TIMEZONE variable from the root .env file.
"""

import os
import re
import sys
from pathlib import Path

# ANSI color codes
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
RED = '\033[0;31m'
NC = '\033[0m'  # No Color

def find_compose_files():
    """Find all compose.yaml files in subdirectories, excluding node_modules."""
    compose_files = []
    for root, dirs, files in os.walk('.'):
        # Skip node_modules directories
        dirs[:] = [d for d in dirs if 'node_modules' not in d]
        
        # Only look at immediate subdirectories (depth 1)
        depth = root.count(os.sep) - root.startswith('.').count(os.sep)
        if depth > 1:
            continue
            
        if 'compose.yaml' in files:
            compose_files.append(os.path.join(root, 'compose.yaml'))
    
    return sorted(compose_files)

def add_timezone_to_compose(filepath):
    """Add TZ environment variable to all services in a compose file."""
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Check if TZ is already configured
    if re.search(r'^\s+TZ:', content, re.MULTILINE):
        return False, "Already configured"
    
    lines = content.split('\n')
    modified_lines = []
    i = 0
    changes_made = False
    
    while i < len(lines):
        line = lines[i]
        modified_lines.append(line)
        
        # Check if this line starts an environment section (with 4 spaces of indentation)
        if re.match(r'^    environment:\s*$', line):
            # Add TZ as the first environment variable
            modified_lines.append('      TZ: ${TIMEZONE:-Europe/Amsterdam}')
            changes_made = True
        
        i += 1
    
    if changes_made:
        # Create backup
        backup_path = filepath + '.bak'
        with open(backup_path, 'w') as f:
            f.write(content)
        
        # Write modified content
        with open(filepath, 'w') as f:
            f.write('\n'.join(modified_lines))
        
        return True, "Added TZ environment variable"
    else:
        return False, "No environment sections found"

def main():
    print(f"{GREEN}========================================{NC}")
    print(f"{GREEN}Adding Timezone Configuration to Stacks{NC}")
    print(f"{GREEN}========================================{NC}")
    print()
    
    compose_files = find_compose_files()
    
    if not compose_files:
        print(f"{RED}No compose.yaml files found!{NC}")
        return 1
    
    print(f"Found {GREEN}{len(compose_files)}{NC} compose files")
    print()
    
    modified = 0
    skipped = 0
    errors = 0
    
    for compose_file in compose_files:
        stack_name = os.path.basename(os.path.dirname(compose_file))
        print(f"Processing: {YELLOW}{stack_name}{NC} ({compose_file})")
        
        try:
            success, message = add_timezone_to_compose(compose_file)
            if success:
                print(f"  {GREEN}✓ {message}{NC}")
                modified += 1
            else:
                print(f"  {YELLOW}⏭  {message}{NC}")
                skipped += 1
        except Exception as e:
            print(f"  {RED}✗ Error: {e}{NC}")
            errors += 1
        
        print()
    
    print()
    print(f"{GREEN}========================================{NC}")
    print(f"{GREEN}Summary{NC}")
    print(f"{GREEN}========================================{NC}")
    print(f"Modified: {GREEN}{modified}{NC} files")
    print(f"Skipped:  {YELLOW}{skipped}{NC} files")
    if errors > 0:
        print(f"Errors:   {RED}{errors}{NC} files")
    print()
    print(f"{GREEN}Backup files created with .bak extension{NC}")
    print("Review changes and remove .bak files if satisfied")
    print()
    print(f"{YELLOW}Note: Run 'docker compose up -d' in each stack directory to apply changes{NC}")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
