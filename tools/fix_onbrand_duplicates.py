#!/usr/bin/env python3
"""
Fix On Brand Project Duplicates
Fixes duplicate file references in the on brand Xcode project
"""

import re
from pathlib import Path

def fix_onbrand_duplicates():
    """Fix duplicate references in on brand project"""
    
    project_file = Path("/Users/piersondavis/Documents/on brand/on brand.xcodeproj/project.pbxproj")
    
    if not project_file.exists():
        print("❌ Project file not found")
        return
    
    print("🔧 Fixing on brand project duplicates...")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Fix 1: Remove Info.plist from Copy Bundle Resources phase
    print("📄 Removing Info.plist from Copy Bundle Resources...")
    
    # Find the Copy Bundle Resources section
    copy_resources_pattern = r'(PBXResourcesBuildPhase.*?files = \(\s*)(.*?)(\s*\);.*?runOnlyForDeploymentPostprocessing = 0;)'
    
    def remove_info_plist_from_resources(match):
        files_section = match.group(2)
        # Remove any Info.plist references
        files_section = re.sub(r'.*Info\.plist.*\n?', '', files_section)
        return f"{match.group(1)}{files_section}{match.group(3)}"
    
    content = re.sub(copy_resources_pattern, remove_info_plist_from_resources, content, flags=re.DOTALL)
    
    # Fix 2: Remove duplicate ContentView references
    print("📄 Removing duplicate ContentView references...")
    
    # Count ContentView references
    contentview_count = content.count('ContentView.swift')
    print(f"Found {contentview_count} ContentView.swift references")
    
    # Remove duplicate ContentView build file references
    contentview_pattern = r'(.*?)(\s*[A-F0-9]{24}.*?ContentView\.swift.*?in Sources.*?)(.*?)(\s*[A-F0-9]{24}.*?ContentView\.swift.*?in Sources.*?)(.*)'
    
    def remove_duplicate_contentview(match):
        # Keep only the first ContentView reference
        return f"{match.group(1)}{match.group(2)}{match.group(3)}{match.group(5)}"
    
    # Apply multiple times to remove all duplicates
    for _ in range(5):  # Max 5 iterations to avoid infinite loop
        new_content = re.sub(contentview_pattern, remove_duplicate_contentview, content, flags=re.DOTALL)
        if new_content == content:
            break
        content = new_content
    
    # Fix 3: Remove Assets.xcassets from Compile Sources phase
    print("📄 Removing Assets.xcassets from Compile Sources...")
    
    # Find the Compile Sources section
    compile_sources_pattern = r'(PBXSourcesBuildPhase.*?files = \(\s*)(.*?)(\s*\);.*?runOnlyForDeploymentPostprocessing = 0;)'
    
    def remove_assets_from_sources(match):
        files_section = match.group(2)
        # Remove any Assets.xcassets references
        files_section = re.sub(r'.*Assets\.xcassets.*\n?', '', files_section)
        return f"{match.group(1)}{files_section}{match.group(3)}"
    
    content = re.sub(compile_sources_pattern, remove_assets_from_sources, content, flags=re.DOTALL)
    
    # Fix 4: Remove duplicate file references
    print("📄 Removing duplicate file references...")
    
    # Remove duplicate file references (same file path)
    file_refs = {}
    file_ref_pattern = r'([A-F0-9]{24}) /\* ([^*]+) \*/ = \{isa = PBXFileReference;.*?path = ([^;]+);.*?\};'
    
    def replace_duplicate_file_refs(match):
        ref_id = match.group(1)
        file_name = match.group(2)
        file_path = match.group(3)
        
        key = f"{file_name}|{file_path}"
        
        if key in file_refs:
            # This is a duplicate, remove it
            return ""
        else:
            file_refs[key] = ref_id
            return match.group(0)
    
    content = re.sub(file_ref_pattern, replace_duplicate_file_refs, content, flags=re.DOTALL)
    
    # Write the fixed project file
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Fixed on brand project duplicates!")
    print("\nFixed issues:")
    print("- Removed Info.plist from Copy Bundle Resources")
    print("- Removed duplicate ContentView references")
    print("- Removed Assets.xcassets from Compile Sources")
    print("- Removed duplicate file references")

if __name__ == "__main__":
    fix_onbrand_duplicates()
