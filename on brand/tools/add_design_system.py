#!/usr/bin/env python3
"""
Add EraDesignSystem.swift to the Xcode project.
"""

import re
import sys

def add_design_system():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate a new UUID for the file reference
    import uuid
    file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    print(f"Generated IDs: {file_ref_id}, {build_file_id}")
    
    # Add the file reference
    file_ref_pattern = r'(7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = ThemeManager\.swift; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t' + file_ref_id + ' /* EraDesignSystem.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = EraDesignSystem.swift; sourceTree = "<group>"; };'
    
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add the build file entry
    build_file_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9A82E8B93300043EF4D /\* ContentView\.swift \*/; \};)'
    build_file_replacement = r'\1\n\t\t' + build_file_id + ' /* EraDesignSystem.swift in Sources */ = {isa = PBXBuildFile; fileRef = ' + file_ref_id + ' /* EraDesignSystem.swift */; };'
    
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    # Add to the DesignSystem group
    group_pattern = r'(7BDFB9A62E8B93300043EF4D /\* DesignSystem \*/ = \{\s*isa = PBXGroup;\s*children = \(\s*7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/,?\s*\);\s*path = DesignSystem;\s*sourceTree = "<group>";\s*\};)'
    group_replacement = r'7BDFB9A62E8B93300043EF4D /* DesignSystem */ = {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t7BDFB9A72E8B93300043EF4D /* ThemeManager.swift */,\n\t\t\t\t' + file_ref_id + ' /* EraDesignSystem.swift */,\n\t\t\t);\n\t\t\tpath = DesignSystem;\n\t\t\tsourceTree = "<group>";\n\t\t};'
    
    content = re.sub(group_pattern, group_replacement, content)
    
    # Add to the main app target's Sources build phase
    sources_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/,?\s*7BDFB9B12E8B93300043EF4D /\* LoadingView\.swift in Sources \*/,?\s*7BDFB9B22E8B93300043EF4D /\* UserProfileService\.swift in Sources \*/,?)'
    sources_replacement = r'7BDFB9B02E8B93300043EF4D /* ContentView.swift in Sources */,\n\t\t\t\t7BDFB9B12E8B93300043EF4D /* LoadingView.swift in Sources */,\n\t\t\t\t7BDFB9B22E8B93300043EF4D /* UserProfileService.swift in Sources */,\n\t\t\t\t' + build_file_id + ' /* EraDesignSystem.swift in Sources */,'
    
    content = re.sub(sources_pattern, sources_replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ EraDesignSystem.swift added to Xcode project!")

if __name__ == "__main__":
    add_design_system()
