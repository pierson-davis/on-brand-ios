#!/usr/bin/env python3
"""
Find and Fix All era/ References
Finds all remaining era/ references in the Xcode project file and fixes them
"""

import re
from pathlib import Path

def find_and_fix_era_references():
    """Find and fix all era/ references in the Xcode project file"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find all era/ references
    era_pattern = r'era/[^"]*'
    matches = re.findall(era_pattern, content)
    
    print(f"Found {len(matches)} era/ references:")
    for match in matches:
        print(f"  - {match}")
    
    # Create a mapping of old paths to new paths
    path_mappings = {}
    for match in matches:
        if match.startswith('era/'):
            new_path = match[4:]  # Remove 'era/' prefix
            path_mappings[match] = new_path
    
    # Apply the mappings
    updated_content = content
    changes_made = 0
    
    for old_path, new_path in path_mappings.items():
        if old_path in updated_content:
            updated_content = updated_content.replace(old_path, new_path)
            changes_made += 1
            print(f"✅ Updated: {old_path} -> {new_path}")
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully updated {changes_made} references!")
    else:
        print("\n⚠️ No references were updated.")
    
    return changes_made

if __name__ == "__main__":
    print("🔍 Finding and fixing all era/ references...")
    print("=" * 60)
    
    changes = find_and_fix_era_references()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} references!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
