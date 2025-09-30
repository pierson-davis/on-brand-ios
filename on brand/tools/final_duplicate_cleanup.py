#!/usr/bin/env python3
"""
Final Duplicate Cleanup
Removes ALL remaining duplicates from the Xcode project file
"""

import re
from pathlib import Path

def final_duplicate_cleanup():
    """Final cleanup of all remaining duplicates"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Final duplicate cleanup starting...")
    
    # Find all Swift file references in Sources build phase
    sources_section = re.search(r'7B3D44332E82388E00E56ABB /\* Sources \*/ = \{[^}]*files = \(([^}]*)\);[^}]*\};', content, re.MULTILINE | re.DOTALL)
    
    if not sources_section:
        print("❌ Could not find Sources build phase section")
        return
    
    sources_content = sources_section.group(1)
    
    # Find all Swift file references
    swift_files = {}
    swift_pattern = r'(\w+) /\* ([^/]+)\.swift in Sources \*/'
    
    for match in re.finditer(swift_pattern, sources_content):
        build_id = match.group(1)
        file_name = match.group(2)
        
        if file_name not in swift_files:
            swift_files[file_name] = []
        swift_files[file_name].append(build_id)
    
    # Find duplicates
    duplicates = {name: build_ids for name, build_ids in swift_files.items() if len(build_ids) > 1}
    
    print(f"Found {len(duplicates)} Swift files with duplicates:")
    for name, build_ids in duplicates.items():
        print(f"  - {name}: {len(build_ids)} references")
    
    # Remove duplicates (keep the first one)
    for name, build_ids in duplicates.items():
        for build_id in build_ids[1:]:  # Skip the first one
            # Remove from Sources build phase
            pattern = rf'\s*{build_id}\s*/\*[^*]*\*/\s*in\s+Sources\s*\),?'
            content = re.sub(pattern, '', content)
            
            # Remove the build file reference
            build_file_pattern = rf'{build_id} = \{{[^}}]*\}};'
            content = re.sub(build_file_pattern, '', content)
            
            print(f"    Removed: {build_id} ({name})")
    
    # Clean up the project file
    print("Cleaning up project file...")
    
    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Fix malformed arrays
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    
    # Write the cleaned content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Final duplicate cleanup completed!")
    print("Now let's test the build...")

if __name__ == "__main__":
    final_duplicate_cleanup()
