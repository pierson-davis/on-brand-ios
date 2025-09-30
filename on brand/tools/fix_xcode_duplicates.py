#!/usr/bin/env python3
"""
Fix Xcode Project Duplicate References
Removes duplicate file references and fixes build phase issues
"""

import re
from pathlib import Path

def fix_xcode_duplicates():
    """Fix duplicate file references and build phase issues"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find all file references and their IDs
    file_refs = {}
    build_files = {}
    
    # Extract file references
    file_ref_pattern = r'(\w+) /\* ([^*]+) \*/ = \{isa = PBXFileReference[^}]+path = ([^;]+);[^}]+sourceTree = "[^"]+";[^}]*\};'
    for match in re.finditer(file_ref_pattern, content):
        file_id = match.group(1)
        file_name = match.group(2)
        file_path = match.group(3)
        file_refs[file_id] = {
            'name': file_name,
            'path': file_path
        }
    
    # Extract build file references
    build_file_pattern = r'(\w+) /\* ([^*]+) in ([^*]+) \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* ([^*]+) \*/;[^}]*\};'
    for match in re.finditer(build_file_pattern, content):
        build_id = match.group(1)
        file_name = match.group(2)
        build_phase = match.group(3)
        file_ref_id = match.group(4)
        build_files[build_id] = {
            'name': file_name,
            'phase': build_phase,
            'file_ref': file_ref_id
        }
    
    print(f"Found {len(file_refs)} file references")
    print(f"Found {len(build_files)} build file references")
    
    # Find duplicate file references (same path)
    path_to_ids = {}
    for file_id, file_info in file_refs.items():
        path = file_info['path']
        if path not in path_to_ids:
            path_to_ids[path] = []
        path_to_ids[path].append(file_id)
    
    # Find duplicates
    duplicates = {path: ids for path, ids in path_to_ids.items() if len(ids) > 1}
    
    print(f"\nFound {len(duplicates)} duplicate file references:")
    for path, ids in duplicates.items():
        print(f"  {path}: {ids}")
    
    # Find duplicate build file references
    build_duplicates = {}
    for build_id, build_info in build_files.items():
        key = f"{build_info['name']}_{build_info['phase']}"
        if key not in build_duplicates:
            build_duplicates[key] = []
        build_duplicates[key].append(build_id)
    
    build_duplicates = {key: ids for key, ids in build_duplicates.items() if len(ids) > 1}
    
    print(f"\nFound {len(build_duplicates)} duplicate build file references:")
    for key, ids in build_duplicates.items():
        print(f"  {key}: {ids}")
    
    # Remove duplicates from content
    updated_content = content
    changes_made = 0
    
    # Remove duplicate file references (keep the first one)
    for path, ids in duplicates.items():
        if len(ids) > 1:
            # Keep the first one, remove the rest
            for file_id in ids[1:]:
                # Remove the file reference
                file_ref_pattern = f'{file_id} /\\* [^*]+ \\*/ = \\{{isa = PBXFileReference[^}}]+\\}};'
                if re.search(file_ref_pattern, updated_content):
                    updated_content = re.sub(file_ref_pattern, '', updated_content)
                    changes_made += 1
                    print(f"Removed duplicate file reference: {file_id}")
    
    # Remove duplicate build file references
    for key, ids in build_duplicates.items():
        if len(ids) > 1:
            # Keep the first one, remove the rest
            for build_id in ids[1:]:
                # Remove the build file reference
                build_file_pattern = f'{build_id} /\\* [^*]+ in [^*]+ \\*/ = \\{{isa = PBXBuildFile[^}}]+\\}};'
                if re.search(build_file_pattern, updated_content):
                    updated_content = re.sub(build_file_pattern, '', updated_content)
                    changes_made += 1
                    print(f"Removed duplicate build file reference: {build_id}")
    
    # Fix Assets.xcassets in wrong build phase
    # Remove from Compile Sources
    assets_compile_pattern = r'(\w+) /\* Assets\.xcassets in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* Assets\.xcassets \*/;\};'
    if re.search(assets_compile_pattern, updated_content):
        updated_content = re.sub(assets_compile_pattern, '', updated_content)
        changes_made += 1
        print("Removed Assets.xcassets from Compile Sources")
    
    # Fix Info.plist in Copy Bundle Resources
    info_plist_copy_pattern = r'(\w+) /\* Info\.plist in Resources \*/ = \{isa = PBXBuildFile; fileRef = (\w+) /\* Info\.plist \*/;\};'
    if re.search(info_plist_copy_pattern, updated_content):
        updated_content = re.sub(info_plist_copy_pattern, '', updated_content)
        changes_made += 1
        print("Removed Info.plist from Copy Bundle Resources")
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully fixed {changes_made} issues in Xcode project file!")
    else:
        print("\n⚠️ No issues were found to fix.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Fixing Xcode project duplicate references...")
    print("=" * 60)
    
    changes = fix_xcode_duplicates()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} issues!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
