#!/usr/bin/env python3
"""
Fix duplicate file references in Xcode project.pbxproj file
"""

import re
import sys
from pathlib import Path

def fix_duplicate_references(project_file_path):
    """Remove duplicate file references from Xcode project file"""
    
    with open(project_file_path, 'r') as f:
        content = f.read()
    
    # Find all duplicate file references
    duplicates = {
        'on_brandApp.swift': [],
        'Assets.xcassets': [],
        'Preview Assets.xcassets': [],
        'Info.plist': []
    }
    
    # Find all references to these files
    for file_type in duplicates:
        pattern = rf'(\w+.*{re.escape(file_type)}.*)'
        matches = re.findall(pattern, content)
        duplicates[file_type] = matches
    
    print("Found duplicate references:")
    for file_type, refs in duplicates.items():
        print(f"  {file_type}: {len(refs)} references")
    
    # Remove the second occurrence of each duplicate
    # We'll keep the first occurrence and remove subsequent ones
    
    # Remove duplicate on_brandApp.swift references
    # Keep: 7BC4B3262E8B9BA6002E6EC0 (first occurrence)
    # Remove: 7BC4B4842E8BA7DD002E6EC0 (second occurrence)
    content = re.sub(r'7BC4B4842E8BA7DD002E6EC0 /\* on_brandApp\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BC4B4832E8BA7DC002E6EC0 /\* on_brandApp\.swift \*/; \};', '', content)
    content = re.sub(r'7BC4B4832E8BA7DC002E6EC0 /\* on_brandApp\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = on_brandApp\.swift; sourceTree = "<group>"; \};', '', content)
    
    # Remove duplicate Assets.xcassets references
    # Keep: 7BC4B32A2E8B9BA9002E6EC0 (first occurrence)
    # Remove: 7BC4B3EB2E8BA6A7002E6EC0 (second occurrence)
    content = re.sub(r'7BC4B3EB2E8BA6A7002E6EC0 /\* Assets\.xcassets in Resources \*/ = \{isa = PBXBuildFile; fileRef = 7BC4B3EA2E8BA6A7002E6EC0 /\* Assets\.xcassets \*/; \};', '', content)
    content = re.sub(r'7BC4B3EA2E8BA6A7002E6EC0 /\* Assets\.xcassets \*/ = \{isa = PBXFileReference; lastKnownFileType = folder\.assetcatalog; path = Assets\.xcassets; sourceTree = "<group>"; \};', '', content)
    
    # Remove duplicate Preview Assets.xcassets references
    # Keep: 7BC4B32E2E8B9BA9002E6EC0 (first occurrence)
    # Remove: 7BC4B4872E8BA7F4002E6EC0 (second occurrence)
    content = re.sub(r'7BC4B4872E8BA7F4002E6EC0 /\* Preview Assets\.xcassets in Resources \*/ = \{isa = PBXBuildFile; fileRef = 7BC4B4862E8BA7F4002E6EC0 /\* Preview Assets\.xcassets \*/; \};', '', content)
    content = re.sub(r'7BC4B4862E8BA7F4002E6EC0 /\* Preview Assets\.xcassets \*/ = \{isa = PBXFileReference; lastKnownFileType = folder\.assetcatalog; path = "Preview Assets\.xcassets"; sourceTree = "<group>"; \};', '', content)
    
    # Remove duplicate Info.plist references
    # Keep: 7BC4B3E82E8BA696002E6EC0 (first occurrence)
    # Remove: 7BC4B3E42E8BA696002E6EC0 (second occurrence)
    content = re.sub(r'7BC4B3E82E8BA696002E6EC0 /\* Info\.plist in Resources \*/ = \{isa = PBXBuildFile; fileRef = 7BC4B3E42E8BA696002E6EC0 /\* Info\.plist \*/; \};', '', content)
    content = re.sub(r'7BC4B3E42E8BA696002E6EC0 /\* Info\.plist \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text\.plist\.xml; path = Info\.plist; sourceTree = "<group>"; \};', '', content)
    
    # Remove references from build phases
    content = re.sub(r'7BC4B4842E8BA7DD002E6EC0 /\* on_brandApp\.swift in Sources \*/,', '', content)
    content = re.sub(r'7BC4B3EB2E8BA6A7002E6EC0 /\* Assets\.xcassets in Resources \*/,', '', content)
    content = re.sub(r'7BC4B4872E8BA7F4002E6EC0 /\* Preview Assets\.xcassets in Resources \*/,', '', content)
    content = re.sub(r'7BC4B3E82E8BA696002E6EC0 /\* Info\.plist in Resources \*/,', '', content)
    
    # Remove references from file groups
    content = re.sub(r'7BC4B4832E8BA7DC002E6EC0 /\* on_brandApp\.swift \*/,', '', content)
    content = re.sub(r'7BC4B3EA2E8BA6A7002E6EC0 /\* Assets\.xcassets \*/,', '', content)
    content = re.sub(r'7BC4B4862E8BA7F4002E6EC0 /\* Preview Assets\.xcassets \*/,', '', content)
    content = re.sub(r'7BC4B3E42E8BA696002E6EC0 /\* Info\.plist \*/,', '', content)
    
    # Write the fixed content back
    with open(project_file_path, 'w') as f:
        f.write(content)
    
    print("Fixed duplicate references in project.pbxproj")

if __name__ == "__main__":
    project_file = Path("/Users/piersondavis/Documents/on brand/on brand.xcodeproj/project.pbxproj")
    fix_duplicate_references(project_file)
    print("✅ Duplicate references removed successfully!")
