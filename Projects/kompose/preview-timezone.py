#!/usr/bin/env python3
"""
Preview timezone changes for a single compose file before applying to all.
This helps you verify the changes are correct before running the full script.
"""

import sys
import re

def preview_timezone_addition(filepath):
    """Preview what changes would be made to a compose file."""
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: File not found: {filepath}")
        return
    
    lines = content.split('\n')
    modified_lines = []
    i = 0
    changes = []
    
    while i < len(lines):
        line = lines[i]
        modified_lines.append(line)
        
        # Check if this line starts an environment section
        if re.match(r'^    environment:\s*$', line):
            # Found an environment section
            service_name = None
            # Look backward to find the service name
            for j in range(i-1, -1, -1):
                if re.match(r'^  [a-zA-Z0-9_-]+:', lines[j]):
                    service_name = lines[j].strip().rstrip(':')
                    break
            
            # Add TZ as the first environment variable
            tz_line = '      TZ: ${TIMEZONE:-Europe/Amsterdam}'
            modified_lines.append(tz_line)
            changes.append(f"  Added TZ to service '{service_name}' at line {i+2}")
        
        i += 1
    
    print("=" * 60)
    print(f"PREVIEW: {filepath}")
    print("=" * 60)
    print()
    
    if not changes:
        print("No changes needed - file may already have TZ configured")
        print("or has no environment sections.")
    else:
        print("Changes that would be made:")
        print()
        for change in changes:
            print(f"  ✓ {change}")
        print()
        print("-" * 60)
        print("Modified content:")
        print("-" * 60)
        print('\n'.join(modified_lines))

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 preview-timezone.py <path-to-compose.yaml>")
        print()
        print("Example:")
        print("  python3 preview-timezone.py auth/compose.yaml")
        print("  python3 preview-timezone.py data/compose.yaml")
        sys.exit(1)
    
    filepath = sys.argv[1]
    preview_timezone_addition(filepath)

if __name__ == '__main__':
    main()
