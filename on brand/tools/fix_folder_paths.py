#!/usr/bin/env python3
"""
Fix Xcode Project File Paths
Updates all file references to remove the redundant era/ folder prefix
"""

import re
from pathlib import Path

def fix_folder_paths():
    """Update all file references to remove era/ prefix"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    updated_content = content
    changes_made = 0
    
    # Remove era/ prefix from all file paths
    # Pattern: path = "era/SomePath" -> path = "SomePath"
    path_pattern = r'path = "era/([^"]+)"'
    matches = re.findall(path_pattern, updated_content)
    
    for match in matches:
        old_path = f'path = "era/{match}"'
        new_path = f'path = "{match}"'
        if old_path in updated_content:
            updated_content = updated_content.replace(old_path, new_path)
            changes_made += 1
            print(f"✅ Updated path: era/{match} -> {match}")
    
    # Also update any other references that might have era/ prefix
    # Pattern: era/SomeFile.swift -> SomeFile.swift
    file_ref_pattern = r'era/([^"]+\.swift)'
    file_matches = re.findall(file_ref_pattern, updated_content)
    
    for match in file_matches:
        old_ref = f'era/{match}'
        new_ref = match
        if old_ref in updated_content:
            updated_content = updated_content.replace(old_ref, new_ref)
            changes_made += 1
            print(f"✅ Updated file reference: era/{match} -> {match}")
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully updated {changes_made} file references!")
    else:
        print("\n⚠️ No file references were found to update.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Fixing Xcode project file paths...")
    print("=" * 60)
    
    changes = fix_folder_paths()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} file references!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
