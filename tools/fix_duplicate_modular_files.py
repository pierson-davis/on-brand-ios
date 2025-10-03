#!/usr/bin/env python3
"""
Fix Duplicate Modular Files in Xcode Project

This script removes duplicate file references that occur when adding
modular files with the same names as existing files. It keeps the
new modular files and removes the old monolithic file references.

Created by Pierson Davis on January 2025.
"""

import re
import sys
from pathlib import Path

def fix_duplicate_modular_files():
    """Remove duplicate file references from project.pbxproj"""
    
    project_file = Path("on brand.xcodeproj/project.pbxproj")
    
    if not project_file.exists():
        print("❌ Error: project.pbxproj not found")
        return False
    
    print("🔍 Reading project.pbxproj...")
    with open(project_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Files that have duplicates (old monolithic vs new modular)
    duplicate_files = [
        "OnboardingScreenModel.swift",
        "ProfileView.swift", 
        "ThemeManager.swift"
    ]
    
    # Track what we're removing
    removed_refs = []
    
    for filename in duplicate_files:
        print(f"🔧 Processing {filename}...")
        
        # Find all file references for this file
        file_ref_pattern = rf'(\w+) /\* {re.escape(filename)} \*/ = {{isa = PBXFileReference;.*?}};'
        file_refs = re.findall(file_ref_pattern, content, re.DOTALL)
        
        # Find all build file references for this file
        build_file_pattern = rf'(\w+) /\* {re.escape(filename)} \*/ in Sources \*/ = {{isa = PBXBuildFile; fileRef = (\w+) /\* {re.escape(filename)} \*/;'
        build_files = re.findall(build_file_pattern, content, re.DOTALL)
        
        print(f"   Found {len(file_refs)} file references")
        print(f"   Found {len(build_files)} build file references")
        
        # Keep only the first reference (the new modular one)
        if len(file_refs) > 1:
            # Remove all but the first file reference
            for i, ref_id in enumerate(file_refs[1:], 1):
                ref_pattern = rf'{ref_id} /\* {re.escape(filename)} \*/ = {{isa = PBXFileReference;.*?}};'
                content = re.sub(ref_pattern, '', content, flags=re.DOTALL)
                removed_refs.append(f"File reference {ref_id} for {filename}")
                print(f"   ✅ Removed duplicate file reference {ref_id}")
        
        if len(build_files) > 1:
            # Remove all but the first build file reference
            for i, (build_id, file_ref_id) in enumerate(build_files[1:], 1):
                build_pattern = rf'{build_id} /\* {re.escape(filename)} \*/ in Sources \*/ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /\* {re.escape(filename)} \*/;'
                content = re.sub(build_pattern, '', content, flags=re.DOTALL)
                removed_refs.append(f"Build file reference {build_id} for {filename}")
                print(f"   ✅ Removed duplicate build file reference {build_id}")
        
        # Remove duplicate entries from file lists
        file_list_pattern = rf'(\w+) /\* {re.escape(filename)} \*/,'
        file_list_matches = re.findall(file_list_pattern, content)
        
        if len(file_list_matches) > 1:
            # Remove all but the first occurrence from file lists
            for i, ref_id in enumerate(file_list_matches[1:], 1):
                list_pattern = rf'(\s+){ref_id} /\* {re.escape(filename)} \*/,'
                content = re.sub(list_pattern, r'\1', content)
                removed_refs.append(f"File list entry {ref_id} for {filename}")
                print(f"   ✅ Removed duplicate file list entry {ref_id}")
    
    # Clean up any empty lines or double spaces
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    content = re.sub(r'  +', ' ', content)
    
    print(f"\n📝 Writing cleaned project.pbxproj...")
    with open(project_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"\n✅ Successfully removed {len(removed_refs)} duplicate references:")
    for ref in removed_refs:
        print(f"   - {ref}")
    
    return True

if __name__ == "__main__":
    print("🚀 Starting duplicate modular files cleanup...")
    success = fix_duplicate_modular_files()
    
    if success:
        print("\n🎉 Duplicate files cleanup completed successfully!")
        print("💡 You can now build your project without duplicate file errors.")
    else:
        print("\n❌ Duplicate files cleanup failed!")
        sys.exit(1)
