#!/usr/bin/env python3
"""
Fix Remaining Xcode Project Issues
Fixes Info.plist conflicts, wrong build phases, and remaining duplicates
"""

import re
from pathlib import Path

def fix_remaining_issues():
    """Fix remaining Xcode project issues"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    updated_content = content
    changes_made = 0
    
    # 1. Remove Info.plist from Copy Bundle Resources (it should only be processed, not copied)
    info_plist_copy_pattern = r'(\w+) /\* Info\.plist in Resources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* Info\.plist \*/;\};'
    if re.search(info_plist_copy_pattern, updated_content):
        updated_content = re.sub(info_plist_copy_pattern, '', updated_content)
        changes_made += 1
        print("✅ Removed Info.plist from Copy Bundle Resources")
    
    # 2. Remove Assets.xcassets from Compile Sources (it should be in Copy Bundle Resources)
    assets_compile_pattern = r'(\w+) /\* Assets\.xcassets in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* Assets\.xcassets \*/;\};'
    if re.search(assets_compile_pattern, updated_content):
        updated_content = re.sub(assets_compile_pattern, '', updated_content)
        changes_made += 1
        print("✅ Removed Assets.xcassets from Compile Sources")
    
    # 3. Remove Preview Assets.xcassets from Compile Sources
    preview_assets_compile_pattern = r'(\w+) /\* Preview Assets\.xcassets in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* Preview Assets\.xcassets \*/;\};'
    if re.search(preview_assets_compile_pattern, updated_content):
        updated_content = re.sub(preview_assets_compile_pattern, '', updated_content)
        changes_made += 1
        print("✅ Removed Preview Assets.xcassets from Compile Sources")
    
    # 4. Find and remove duplicate eraApp.swift references
    era_app_pattern = r'(\w+) /\* eraApp\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* eraApp\.swift \*/;\};'
    era_app_matches = list(re.finditer(era_app_pattern, updated_content))
    
    if len(era_app_matches) > 1:
        # Keep the first one, remove the rest
        for match in era_app_matches[1:]:
            build_id = match.group(1)
            file_ref_id = match.group(2)
            duplicate_pattern = f'{build_id} /\\* eraApp\\.swift in Sources \\*/ = \\{{isa = PBXBuildFile; fileRef = {file_ref_id} /\\* eraApp\\.swift \\*/;\\}};'
            if re.search(duplicate_pattern, updated_content):
                updated_content = re.sub(duplicate_pattern, '', updated_content)
                changes_made += 1
                print(f"✅ Removed duplicate eraApp.swift reference: {build_id}")
    
    # 5. Remove any remaining duplicate build file references
    # Find all build file references and group by name and phase
    build_file_pattern = r'(\w+) /\* ([^*]+) in ([^*]+) \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* ([^*]+) \*/;\};'
    build_files = {}
    
    for match in re.finditer(build_file_pattern, updated_content):
        build_id = match.group(1)
        file_name = match.group(2)
        build_phase = match.group(3)
        file_ref_id = match.group(4)
        
        key = f"{file_name}_{build_phase}"
        if key not in build_files:
            build_files[key] = []
        build_files[key].append((build_id, file_ref_id))
    
    # Remove duplicates
    for key, files in build_files.items():
        if len(files) > 1:
            # Keep the first one, remove the rest
            for build_id, file_ref_id in files[1:]:
                duplicate_pattern = f'{build_id} /\\* [^*]+ in [^*]+ \\*/ = \\{{isa = PBXBuildFile; fileRef = {file_ref_id} /\\* [^*]+ \\*/;\\}};'
                if re.search(duplicate_pattern, updated_content):
                    updated_content = re.sub(duplicate_pattern, '', updated_content)
                    changes_made += 1
                    print(f"✅ Removed duplicate build file reference: {key} ({build_id})")
    
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
    print("🔧 Fixing remaining Xcode project issues...")
    print("=" * 60)
    
    changes = fix_remaining_issues()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} issues!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
