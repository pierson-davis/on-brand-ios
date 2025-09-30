#!/usr/bin/env python3
"""
Fix the EraDesignSystem.swift file reference in the Xcode project.
"""

import re
import sys

def fix_design_system_reference():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Add the missing file reference
    file_ref_pattern = r'(7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = ThemeManager\.swift; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t49C66871DF1143079074F4DD /* EraDesignSystem.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = EraDesignSystem.swift; sourceTree = "<group>"; };'
    
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add to the DesignSystem group
    group_pattern = r'(7BDFB9A62E8B93300043EF4D /\* DesignSystem \*/ = \{\s*isa = PBXGroup;\s*children = \(\s*7BDFB9A72E8B93300043EF4D /\* ThemeManager\.swift \*/,?\s*\);\s*path = DesignSystem;\s*sourceTree = "<group>";\s*\};)'
    group_replacement = r'7BDFB9A62E8B93300043EF4D /* DesignSystem */ = {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t7BDFB9A72E8B93300043EF4D /* ThemeManager.swift */,\n\t\t\t\t49C66871DF1143079074F4DD /* EraDesignSystem.swift */,\n\t\t\t);\n\t\t\tpath = DesignSystem;\n\t\t\tsourceTree = "<group>";\n\t\t};'
    
    content = re.sub(group_pattern, group_replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ EraDesignSystem.swift file reference fixed!")

if __name__ == "__main__":
    fix_design_system_reference()
