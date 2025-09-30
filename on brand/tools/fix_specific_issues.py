#!/usr/bin/env python3
"""
Fix Specific Xcode Project Issues
Fixes Info.plist in Resources and duplicate Assets.xcassets
"""

import re
from pathlib import Path

def fix_specific_issues():
    """Fix specific Xcode project issues"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    updated_content = content
    changes_made = 0
    
    # 1. Remove Info.plist from Resources build phase
    # Find the line: 7B2E109B2E8B856E002DA087 /* Info.plist in Resources */,
    info_plist_line = "7B2E109B2E8B856E002DA087 /* Info.plist in Resources */,"
    if info_plist_line in updated_content:
        updated_content = updated_content.replace(info_plist_line, "")
        changes_made += 1
        print("✅ Removed Info.plist from Resources build phase")
    
    # 2. Remove duplicate Assets.xcassets from Resources build phase
    # Keep the one with Resources/Assets.xcassets, remove the one with just Assets.xcassets
    duplicate_assets_line = "7B2E109C2E8B856E002DA087 /* Assets.xcassets in Resources */,"
    if duplicate_assets_line in updated_content:
        updated_content = updated_content.replace(duplicate_assets_line, "")
        changes_made += 1
        print("✅ Removed duplicate Assets.xcassets from Resources build phase")
    
    # 3. Remove the build file reference for the duplicate Assets.xcassets
    duplicate_assets_build_ref = "7B2E109C2E8B856E002DA087 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 7B2E103B2E8B856E002DA087 /* Assets.xcassets */; };"
    if duplicate_assets_build_ref in updated_content:
        updated_content = updated_content.replace(duplicate_assets_build_ref, "")
        changes_made += 1
        print("✅ Removed duplicate Assets.xcassets build file reference")
    
    # 4. Remove the file reference for the duplicate Assets.xcassets
    duplicate_assets_file_ref = "7B2E103B2E8B856E002DA087 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = \"<group>\"; };"
    if duplicate_assets_file_ref in updated_content:
        updated_content = updated_content.replace(duplicate_assets_file_ref, "")
        changes_made += 1
        print("✅ Removed duplicate Assets.xcassets file reference")
    
    # 5. Remove the build file reference for Info.plist in Resources
    info_plist_build_ref = "7B2E109B2E8B856E002DA087 /* Info.plist in Resources */ = {isa = PBXBuildFile; fileRef = 7B2E103A2E8B856E002DA087 /* Info.plist */; };"
    if info_plist_build_ref in updated_content:
        updated_content = updated_content.replace(info_plist_build_ref, "")
        changes_made += 1
        print("✅ Removed Info.plist build file reference for Resources")
    
    # 6. Clean up any empty lines that might have been left
    updated_content = re.sub(r'\n\s*\n\s*\n', '\n\n', updated_content)
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully fixed {changes_made} issues in Xcode project file!")
    else:
        print("\n⚠️ No issues were found to fix.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Fixing specific Xcode project issues...")
    print("=" * 60)
    
    changes = fix_specific_issues()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} issues!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
