#!/usr/bin/env python3
"""
Add Missing Files to Xcode Project
Adds the new AppDelegate.swift and SceneDelegate.swift files to the Xcode project
"""

import re
from pathlib import Path

def add_missing_files():
    """Add missing files to Xcode project"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Adding missing files to Xcode project...")
    
    # Generate new IDs for the files
    app_delegate_id = "7BDFB9E02E8B94000043EF4D"
    scene_delegate_id = "7BDFB9E12E8B94000043EF4D"
    app_delegate_build_id = "7BDFB9E22E8B94000043EF4D"
    scene_delegate_build_id = "7BDFB9E32E8B94000043EF4D"
    
    # Add file references
    file_refs_to_add = f"""
		7BDFB9E02E8B94000043EF4D /* AppDelegate.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; }};
		7BDFB9E12E8B94000043EF4D /* SceneDelegate.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SceneDelegate.swift; sourceTree = "<group>"; }};"""
    
    # Add build file references
    build_files_to_add = f"""
		7BDFB9E22E8B94000043EF4D /* AppDelegate.swift in Sources */ = {{isa = PBXBuildFile; fileRef = 7BDFB9E02E8B94000043EF4D /* AppDelegate.swift */; }};
		7BDFB9E32E8B94000043EF4D /* SceneDelegate.swift in Sources */ = {{isa = PBXBuildFile; fileRef = 7BDFB9E12E8B94000043EF4D /* SceneDelegate.swift */; }};"""
    
    # Find the end of the file references section
    file_refs_pattern = r'(.*)(\s*/\* End PBXFileReference section \*/)'
    match = re.search(file_refs_pattern, content, re.DOTALL)
    
    if match:
        # Insert the new file references before the end comment
        new_content = match.group(1) + file_refs_to_add + "\n" + match.group(2)
        content = content.replace(match.group(0), new_content)
        print("Added file references")
    
    # Find the end of the build files section
    build_files_pattern = r'(.*)(\s*/\* End PBXBuildFile section \*/)'
    match = re.search(build_files_pattern, content, re.DOTALL)
    
    if match:
        # Insert the new build files before the end comment
        new_content = match.group(1) + build_files_to_add + "\n" + match.group(2)
        content = content.replace(match.group(0), new_content)
        print("Added build file references")
    
    # Add files to the App group
    app_group_pattern = r'(7BDFB91C2E8B93010043EF4D /\* App \*/ = \{[^}]*children = \([^}]*)(7BDFB9172E8B92F70043EF4D /\* eraApp\.swift \*/[^}]*)(\}[^}]*\};)'
    match = re.search(app_group_pattern, content, re.DOTALL)
    
    if match:
        new_app_group = match.group(1) + "\n\t\t\t\t7BDFB9E02E8B94000043EF4D /* AppDelegate.swift */,\n\t\t\t\t7BDFB9E12E8B94000043EF4D /* SceneDelegate.swift */,\n\t\t\t\t" + match.group(2) + match.group(3)
        content = content.replace(match.group(0), new_app_group)
        print("Added files to App group")
    
    # Add files to Sources build phase
    sources_pattern = r'(7B3D44332E82388E00E56ABB /\* Sources \*/ = \{[^}]*files = \([^}]*)(7B3D443B2E82388E00E56ABB /\* eraApp\.swift in Sources \*/[^}]*)(\}[^}]*\};)'
    match = re.search(sources_pattern, content, re.DOTALL)
    
    if match:
        new_sources = match.group(1) + "\n\t\t\t\t7BDFB9E22E8B94000043EF4D /* AppDelegate.swift in Sources */,\n\t\t\t\t7BDFB9E32E8B94000043EF4D /* SceneDelegate.swift in Sources */,\n\t\t\t\t" + match.group(2) + match.group(3)
        content = content.replace(match.group(0), new_sources)
        print("Added files to Sources build phase")
    
    # Write the updated content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Missing files added to Xcode project!")

if __name__ == "__main__":
    add_missing_files()
