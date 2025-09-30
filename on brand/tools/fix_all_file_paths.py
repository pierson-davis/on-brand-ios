#!/usr/bin/env python3
"""
Fix All File Paths in Xcode Project
Updates all file references to remove era/ prefix after flattening structure
"""

import re
from pathlib import Path

def fix_all_file_paths():
    """Update all file references to remove era/ prefix"""
    
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
    print("🔧 Fixing all file paths in Xcode project...")
    print("=" * 60)
    
    changes = fix_all_file_paths()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} file references!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
