#!/usr/bin/env python3
"""
Fix All Duplicate References
Removes all duplicate file references that are causing build errors
"""

import re
from pathlib import Path

def fix_all_duplicates():
    """Remove all duplicate file references from project file"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Fixing all duplicate references...")
    
    # Find all file references
    file_refs = {}
    file_ref_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*path = ([^;]+);[^}]*\};'
    
    for match in re.finditer(file_ref_pattern, content, re.MULTILINE | re.DOTALL):
        ref_id = match.group(1)
        name = match.group(2).strip()
        path = match.group(3).strip()
        
        if name not in file_refs:
            file_refs[name] = []
        file_refs[name].append((ref_id, path))
    
    # Find duplicates
    duplicates = {name: refs for name, refs in file_refs.items() if len(refs) > 1}
    
    print(f"Found {len(duplicates)} files with duplicates:")
    for name, refs in duplicates.items():
        print(f"  - {name}: {len(refs)} references")
    
    # Remove duplicates (keep the first one)
    for name, refs in duplicates.items():
        for ref_id, path in refs[1:]:  # Skip the first one
            # Remove the file reference
            pattern = rf'{ref_id} = \{{[^}}]*\}};'
            content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
            
            # Remove from children arrays
            children_pattern = rf'\s*{ref_id}\s*/\*[^*]*\*/\s*,?'
            content = re.sub(children_pattern, '', content)
            
            # Remove from build phases
            build_pattern = rf'\s*{ref_id}\s*/\*[^*]*\*/\s*in\s+\w+\s*\),?'
            content = re.sub(build_pattern, '', content)
            
            print(f"Removed duplicate: {name} ({ref_id})")
    
    # Clean up empty lines and extra commas
    content = re.sub(r'\n\s*\n', '\n', content)
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    
    # Write the fixed content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Fixed all duplicate references!")
    print("Now let's test the build...")

if __name__ == "__main__":
    fix_all_duplicates()
