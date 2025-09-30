#!/usr/bin/env python3
"""
Aggressive Duplicate Fix
Uses a more aggressive approach to remove all duplicates
"""

import re
from pathlib import Path

def aggressive_duplicate_fix():
    """Aggressively remove all duplicates"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Aggressive duplicate fix starting...")
    
    # Find all unique file names and their references
    file_names = set()
    file_ref_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*path = ([^;]+);[^}]*\};'
    
    for match in re.finditer(file_ref_pattern, content, re.MULTILINE | re.DOTALL):
        name = match.group(2).strip()
        file_names.add(name)
    
    print(f"Found {len(file_names)} unique file names")
    
    # For each file name, find all references and keep only the first one
    for file_name in file_names:
        # Find all file references for this name
        file_refs = []
        for match in re.finditer(file_ref_pattern, content, re.MULTILINE | re.DOTALL):
            if match.group(2).strip() == file_name:
                ref_id = match.group(1)
                file_refs.append(ref_id)
        
        # If there are duplicates, remove all but the first
        if len(file_refs) > 1:
            print(f"  - {file_name}: {len(file_refs)} references")
            for ref_id in file_refs[1:]:  # Skip the first one
                # Remove the file reference
                pattern = rf'{ref_id} = \{{[^}}]*\}};'
                content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
                
                # Remove from children arrays
                children_pattern = rf'\s*{ref_id}\s*/\*[^*]*\*/\s*,?'
                content = re.sub(children_pattern, '', content)
                
                print(f"    Removed: {ref_id}")
    
    # Find all unique build file names and their references
    build_file_names = set()
    build_file_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*fileRef = (\w+)[^}]*\};'
    
    for match in re.finditer(build_file_pattern, content, re.MULTILINE | re.DOTALL):
        name = match.group(2).strip()
        build_file_names.add(name)
    
    print(f"Found {len(build_file_names)} unique build file names")
    
    # For each build file name, find all references and keep only the first one
    for build_file_name in build_file_names:
        # Find all build file references for this name
        build_refs = []
        for match in re.finditer(build_file_pattern, content, re.MULTILINE | re.DOTALL):
            if match.group(2).strip() == build_file_name:
                build_id = match.group(1)
                build_refs.append(build_id)
        
        # If there are duplicates, remove all but the first
        if len(build_refs) > 1:
            print(f"  - {build_file_name}: {len(build_refs)} build references")
            for build_id in build_refs[1:]:  # Skip the first one
                # Remove the build file reference
                pattern = rf'{build_id} = \{{[^}}]*\}};'
                content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
                
                # Remove from build phases
                build_phase_pattern = rf'\s*{build_id}\s*/\*[^*]*\*/\s*in\s+\w+\s*\),?'
                content = re.sub(build_phase_pattern, '', content)
                
                print(f"    Removed: {build_id}")
    
    # Clean up the project file
    print("Cleaning up project file...")
    
    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Fix malformed arrays
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    content = re.sub(r'\(\s*\)', '()', content)
    
    # Write the cleaned content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Aggressive duplicate fix completed!")
    print("Now let's test the build...")

if __name__ == "__main__":
    aggressive_duplicate_fix()
