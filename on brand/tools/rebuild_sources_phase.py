#!/usr/bin/env python3
"""
Rebuild Sources Phase
Completely rebuilds the Sources build phase with only unique files
"""

import re
from pathlib import Path

def rebuild_sources_phase():
    """Rebuild the Sources build phase with only unique files"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Rebuilding Sources build phase...")
    
    # Find all Swift files in the project
    swift_files = {}
    file_ref_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*path = ([^;]+);[^}]*\};'
    
    for match in re.finditer(file_ref_pattern, content, re.MULTILINE | re.DOTALL):
        ref_id = match.group(1)
        name = match.group(2).strip()
        path = match.group(3).strip()
        
        if name.endswith('.swift'):
            swift_files[name] = ref_id
    
    print(f"Found {len(swift_files)} unique Swift files")
    
    # Find all build file references for Swift files
    build_files = {}
    build_file_pattern = r'(\w+) = \{[^}]*name = ([^;]+);[^}]*fileRef = (\w+)[^}]*\};'
    
    for match in re.finditer(build_file_pattern, content, re.MULTILINE | re.DOTALL):
        build_id = match.group(1)
        name = match.group(2).strip()
        file_ref = match.group(3).strip()
        
        if name.endswith('.swift') and file_ref in swift_files.values():
            build_files[name] = build_id
    
    print(f"Found {len(build_files)} build file references for Swift files")
    
    # Create new Sources build phase content
    sources_entries = []
    for name, build_id in build_files.items():
        sources_entries.append(f"\t\t\t\t{build_id} /* {name} in Sources */,")
    
    new_sources_content = f"""7B3D44332E82388E00E56ABB /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{chr(10).join(sources_entries)}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};"""
    
    # Replace the Sources build phase
    sources_pattern = r'7B3D44332E82388E00E56ABB /\* Sources \*/ = \{[^}]*\};'
    content = re.sub(sources_pattern, new_sources_content, content, flags=re.MULTILINE | re.DOTALL)
    
    # Write the updated content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Sources build phase rebuilt!")
    print("Now let's test the build...")

if __name__ == "__main__":
    rebuild_sources_phase()
