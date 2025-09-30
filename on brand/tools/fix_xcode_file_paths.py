#!/usr/bin/env python3
"""
Fix Xcode File Paths
Updates all file references in the Xcode project to point to root-level files instead of era/ subfolder
"""

import re
from pathlib import Path

def fix_xcode_file_paths():
    """Update all file references to point to root-level files"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find all era/ references and replace them with root-level paths
    era_pattern = r'era/([^"]*)'
    matches = re.findall(era_pattern, content)
    
    print(f"Found {len(matches)} era/ references:")
    for match in matches:
        print(f"  - era/{match}")
    
    # Replace all era/ references with root-level paths
    updated_content = re.sub(r'era/([^"]*)', r'\1', content)
    
    # Count changes
    changes_made = len(matches)
    
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully updated {changes_made} file references!")
        print("All files now point to root-level structure")
    else:
        print("\n⚠️ No era/ references found to update.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Fixing Xcode file paths to point to root-level structure...")
    print("=" * 70)
    
    changes = fix_xcode_file_paths()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} file references!")
        print("\nNext steps:")
        print("1. Open Xcode and check if red files are resolved")
        print("2. Try building the project")
    else:
        print("\n✅ No issues found!")
