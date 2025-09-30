#!/usr/bin/env python3
"""
Fix Duplicate Info.plist References
Removes duplicate Info.plist entries that are causing build errors
"""

import re
from pathlib import Path

def fix_duplicate_info_plist():
    """Remove duplicate Info.plist references from project file"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Fixing duplicate Info.plist references...")
    
    # Find all Info.plist references
    info_plist_refs = re.findall(r'(\w+) = \{[^}]*name = Info\.plist[^}]*\};', content)
    print(f"Found {len(info_plist_refs)} Info.plist references: {info_plist_refs}")
    
    # Find all Info.plist build file references
    info_plist_build_refs = re.findall(r'(\w+) = \{[^}]*Info\.plist in Resources[^}]*\};', content)
    print(f"Found {len(info_plist_build_refs)} Info.plist build references: {info_plist_build_refs}")
    
    # Keep only the first reference, remove duplicates
    if len(info_plist_refs) > 1:
        # Remove duplicate file references
        for ref_id in info_plist_refs[1:]:
            pattern = rf'{ref_id} = \{{[^}}]*\}};'
            content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
            print(f"Removed duplicate file reference: {ref_id}")
    
    if len(info_plist_build_refs) > 1:
        # Remove duplicate build file references
        for ref_id in info_plist_build_refs[1:]:
            pattern = rf'{ref_id} = \{{[^}}]*\}};'
            content = re.sub(pattern, '', content, flags=re.MULTILINE | re.DOTALL)
            print(f"Removed duplicate build reference: {ref_id}")
    
    # Remove duplicate entries from children arrays
    # Find groups that contain Info.plist references
    group_pattern = r'(\w+) = \{\s*isa = PBXGroup;[^}]*children = \(([^)]+)\);[^}]*\};'
    
    def clean_children_array(match):
        group_id = match.group(1)
        children = match.group(2).strip()
        
        # Split children and remove duplicates
        child_list = [child.strip() for child in children.split() if child.strip()]
        unique_children = []
        seen = set()
        
        for child in child_list:
            if child not in seen:
                unique_children.append(child)
                seen.add(child)
        
        # Rebuild the children array
        if unique_children:
            children_str = '\n\t\t\t' + ',\n\t\t\t'.join(unique_children) + '\n\t\t'
        else:
            children_str = ''
        
        return f'{group_id} = {{\n\t\tisa = PBXGroup;\n\t\tchildren = ({children_str});\n\t\tsourceTree = "<group>";\n\t}};'
    
    content = re.sub(group_pattern, clean_children_array, content, flags=re.MULTILINE | re.DOTALL)
    
    # Write the fixed content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Fixed duplicate Info.plist references!")
    print("Now let's test the build...")

if __name__ == "__main__":
    fix_duplicate_info_plist()
