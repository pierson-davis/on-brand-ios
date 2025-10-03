#!/usr/bin/env python3
"""
Fix Duplicate Profile Components in Xcode Project

This script removes duplicate profile component files that exist in both
old and new modular locations. It keeps the new modular versions and
removes the old ones.

Created by Pierson Davis on January 2025.
"""

import re
import sys
from pathlib import Path

def fix_duplicate_profile_components():
    """Remove duplicate profile component files from project.pbxproj"""
    
    project_file = Path("on brand.xcodeproj/project.pbxproj")
    
    if not project_file.exists():
        print("❌ Error: project.pbxproj not found")
        return False
    
    print("🔍 Reading project.pbxproj...")
    with open(project_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Profile components that exist in both old and new locations
    # We want to keep the new modular versions and remove the old ones
    duplicate_components = [
        "ProfileHeaderSection.swift",
        "ProfileBioSection.swift", 
        "ProfileActionButtonsSection.swift",
        "ProfileContentTabsSection.swift",
        "ProfilePhotoGridSection.swift",
        "ProfileTopNavigationBar.swift"
    ]
    
    # Track what we're removing
    removed_refs = []
    
    for filename in duplicate_components:
        print(f"🔧 Processing {filename}...")
        
        # Find all file references for this file
        file_ref_pattern = rf'(\w+) /\* {re.escape(filename)} \*/ = {{isa = PBXFileReference;.*?}};'
        file_refs = re.findall(file_ref_pattern, content, re.DOTALL)
        
        # Find all build file references for this file
        build_file_pattern = rf'(\w+) /\* {re.escape(filename)} \*/ in Sources \*/ = {{isa = PBXBuildFile; fileRef = (\w+) /\* {re.escape(filename)} \*/;'
        build_files = re.findall(build_file_pattern, content, re.DOTALL)
        
        print(f"   Found {len(file_refs)} file references")
        print(f"   Found {len(build_files)} build file references")
        
        # If we have duplicates, remove all but the last one (the new modular version)
        if len(file_refs) > 1:
            # Remove all but the last file reference (keep the new modular one)
            for i, ref_id in enumerate(file_refs[:-1]):
                ref_pattern = rf'{ref_id} /\* {re.escape(filename)} \*/ = {{isa = PBXFileReference;.*?}};'
                content = re.sub(ref_pattern, '', content, flags=re.DOTALL)
                removed_refs.append(f"Old file reference {ref_id} for {filename}")
                print(f"   ✅ Removed old file reference {ref_id}")
        
        if len(build_files) > 1:
            # Remove all but the last build file reference (keep the new modular one)
            for i, (build_id, file_ref_id) in enumerate(build_files[:-1]):
                build_pattern = rf'{build_id} /\* {re.escape(filename)} \*/ in Sources \*/ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /\* {re.escape(filename)} \*/;'
                content = re.sub(build_pattern, '', content, flags=re.DOTALL)
                removed_refs.append(f"Old build file reference {build_id} for {filename}")
                print(f"   ✅ Removed old build file reference {build_id}")
        
        # Remove duplicate entries from file lists (keep only the last occurrence)
        file_list_pattern = rf'(\w+) /\* {re.escape(filename)} \*/,'
        file_list_matches = re.findall(file_list_pattern, content)
        
        if len(file_list_matches) > 1:
            # Remove all but the last occurrence from file lists
            for i, ref_id in enumerate(file_list_matches[:-1]):
                list_pattern = rf'(\s+){ref_id} /\* {re.escape(filename)} \*/,'
                content = re.sub(list_pattern, r'\1', content)
                removed_refs.append(f"Old file list entry {ref_id} for {filename}")
                print(f"   ✅ Removed old file list entry {ref_id}")
    
    # Clean up any empty lines or double spaces
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    content = re.sub(r'  +', ' ', content)
    
    print(f"\n📝 Writing cleaned project.pbxproj...")
    with open(project_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"\n✅ Successfully removed {len(removed_refs)} old component references:")
    for ref in removed_refs:
        print(f"   - {ref}")
    
    return True

if __name__ == "__main__":
    print("🚀 Starting duplicate profile components cleanup...")
    success = fix_duplicate_profile_components()
    
    if success:
        print("\n🎉 Duplicate profile components cleanup completed successfully!")
        print("💡 You can now build your project without duplicate component errors.")
    else:
        print("\n❌ Duplicate profile components cleanup failed!")
        sys.exit(1)
