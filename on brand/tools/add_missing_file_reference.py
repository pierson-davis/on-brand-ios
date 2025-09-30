#!/usr/bin/env python3
"""
Add the missing file reference for EraDesignSystem.swift.
"""

import re
import sys

def add_missing_file_reference():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find where to add the file reference (after ThemeManager.swift)
    file_ref_pattern = r'(7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = ThemeManager\.swift; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t49C66871DF1143079074F4DD /* EraDesignSystem.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = EraDesignSystem.swift; sourceTree = "<group>"; };'
    
    if "49C66871DF1143079074F4DD /* EraDesignSystem.swift */" not in content:
        content = re.sub(file_ref_pattern, file_ref_replacement, content)
        print("Added file reference")
    else:
        print("File reference already exists")
    
    # Add to the DesignSystem group if not already there
    group_pattern = r'(7BDFB9A62E8B93300043EF4D /\* DesignSystem \*/ = \{\s*isa = PBXGroup;\s*children = \(\s*7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/,?\s*\);\s*path = DesignSystem;\s*sourceTree = "<group>";\s*\};)'
    group_replacement = r'7BDFB9A62E8B93300043EF4D /* DesignSystem */ = {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t7BDFB9A72E8B93300043EF4D /* ThemeManager.swift */,\n\t\t\t\t49C66871DF1143079074F4DD /* EraDesignSystem.swift */,\n\t\t\t);\n\t\t\tpath = DesignSystem;\n\t\t\tsourceTree = "<group>";\n\t\t};'
    
    if "49C66871DF1143079074F4DD /* EraDesignSystem.swift */" not in content or "children = (" in content and "49C66871DF1143079074F4DD" not in content:
        content = re.sub(group_pattern, group_replacement, content)
        print("Added to DesignSystem group")
    else:
        print("Already in DesignSystem group")
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ File reference added!")

if __name__ == "__main__":
    add_missing_file_reference()
