#!/usr/bin/env python3
"""
Comprehensive Duplicate Fix
Systematically removes all duplicate references from the Xcode project file
"""

import re
from pathlib import Path

def fix_all_duplicates_comprehensive():
    """Comprehensively fix all duplicate references"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Comprehensive duplicate fix starting...")
    
    # Step 1: Find all file references and group them by name
    file_refs = {}
    file_ref_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*path = ([^;]+);[^}]*\};'
    
    for match in re.finditer(file_ref_pattern, content, re.MULTILINE | re.DOTALL):
        ref_id = match.group(1)
        name = match.group(2).strip()
        path = match.group(3).strip()
        
        if name not in file_refs:
            file_refs[name] = []
        file_refs[name].append((ref_id, path))
    
    # Step 2: Find all build file references and group them by name
    build_files = {}
    build_file_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*fileRef = (\w+)[^}]*\};'
    
    for match in re.finditer(build_file_pattern, content, re.MULTILINE | re.DOTALL):
        build_id = match.group(1)
        name = match.group(2).strip()
        file_ref = match.group(3).strip()
        
        if name not in build_files:
            build_files[name] = []
        build_files[name].append((build_id, file_ref))
    
    # Step 3: Remove duplicate file references (keep the first one)
    print("Removing duplicate file references...")
    for name, refs in file_refs.items():
        if len(refs) > 1:
            print(f"  - {name}: {len(refs)} references")
            for ref_id, path in refs[1:]:  # Skip the first one
                # Remove the file reference
                pattern = rf'{ref_id} = \{{[^}}]*\}};'
                content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
                
                # Remove from children arrays
                children_pattern = rf'\s*{ref_id}\s*/\*[^*]*\*/\s*,?'
                content = re.sub(children_pattern, '', content)
                
                print(f"    Removed: {ref_id}")
    
    # Step 4: Remove duplicate build file references (keep the first one)
    print("Removing duplicate build file references...")
    for name, builds in build_files.items():
        if len(builds) > 1:
            print(f"  - {name}: {len(builds)} build references")
            for build_id, file_ref in builds[1:]:  # Skip the first one
                # Remove the build file reference
                pattern = rf'{build_id} = \{{[^}}]*\}};'
                content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
                
                # Remove from build phases
                build_phase_pattern = rf'\s*{build_id}\s*/\*[^*]*\*/\s*in\s+\w+\s*\),?'
                content = re.sub(build_phase_pattern, '', content)
                
                print(f"    Removed: {build_id}")
    
    # Step 5: Clean up empty lines and malformed arrays
    print("Cleaning up project file...")
    
    # Remove empty lines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Fix malformed children arrays
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    content = re.sub(r'\(\s*\)', '()', content)
    
    # Fix malformed build phases
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    
    # Step 6: Write the cleaned content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Comprehensive duplicate fix completed!")
    print("Now let's test the build...")

if __name__ == "__main__":
    fix_all_duplicates_comprehensive()
