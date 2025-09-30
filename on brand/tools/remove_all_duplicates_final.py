#!/usr/bin/env python3
"""
Remove All Duplicates Final
Removes all duplicate Swift file entries from Sources build phase
"""

import re
from pathlib import Path

def remove_all_duplicates_final():
    """Remove all duplicate Swift file entries"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Removing all duplicate Swift file entries...")
    
    # Find all Swift file entries in Sources build phase
    swift_entries = {}
    swift_pattern = r'(\w+) /\* ([^/]+)\.swift in Sources \*/'
    
    for match in re.finditer(swift_pattern, content):
        build_id = match.group(1)
        file_name = match.group(2)
        
        if file_name not in swift_entries:
            swift_entries[file_name] = []
        swift_entries[file_name].append(build_id)
    
    # Find duplicates
    duplicates = {name: build_ids for name, build_ids in swift_entries.items() if len(build_ids) > 1}
    
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
    
    print("✅ All duplicates removed!")
    print("Now let's test the build...")

if __name__ == "__main__":
    remove_all_duplicates_final()
