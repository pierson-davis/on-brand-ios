#!/usr/bin/env python3
"""
Remove Duplicate Build Files
Removes all duplicate build file references that are causing build errors
"""

import re
from pathlib import Path

def remove_duplicate_build_files():
    """Remove all duplicate build file references"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Removing duplicate build file references...")
    
    # Find all build file references
    build_files = {}
    build_file_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*fileRef = (\w+)[^}]*\};'
    
    for match in re.finditer(build_file_pattern, content, re.MULTILINE | re.DOTALL):
        build_id = match.group(1)
        name = match.group(2).strip()
        file_ref = match.group(3).strip()
        
        key = f"{name}_{file_ref}"
        if key not in build_files:
            build_files[key] = []
        build_files[key].append(build_id)
    
    # Find duplicates
    duplicates = {key: build_ids for key, build_ids in build_files.items() if len(build_ids) > 1}
    
    print(f"Found {len(duplicates)} duplicate build file references:")
    for key, build_ids in duplicates.items():
        print(f"  - {key}: {len(build_ids)} references")
    
    # Remove duplicates (keep the first one)
    for key, build_ids in duplicates.items():
        for build_id in build_ids[1:]:  # Skip the first one
            # Remove the build file reference
            pattern = rf'{build_id} = \{{[^}}]*\}};'
            content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
            
            # Remove from build phases
            build_phase_pattern = rf'\s*{build_id}\s*/\*[^*]*\*/\s*in\s+\w+\s*\),?'
            content = re.sub(build_phase_pattern, '', content)
            
            print(f"Removed duplicate build file: {build_id}")
    
    # Clean up empty lines and extra commas
    content = re.sub(r'\n\s*\n', '\n', content)
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    
    # Write the fixed content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Removed all duplicate build file references!")
    print("Now let's test the build...")

if __name__ == "__main__":
    remove_duplicate_build_files()
