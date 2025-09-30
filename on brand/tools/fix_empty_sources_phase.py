#!/usr/bin/env python3
"""
Fix Empty Sources Phase
Adds all Swift files back to the Sources build phase
"""

import re
from pathlib import Path

def fix_empty_sources_phase():
    """Fix the empty Sources build phase by adding all Swift files"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    print("🔧 Fixing empty Sources build phase...")
    
    # Find all Swift build file references
    swift_build_files = []
    build_file_pattern = r'(\w+) /\* ([^/]+)\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = (\w+)[^}]*\};'
    
    for match in re.finditer(build_file_pattern, content):
        build_id = match.group(1)
        file_name = match.group(2)
        file_ref = match.group(3)
        swift_build_files.append((build_id, file_name, file_ref))
    
    print(f"Found {len(swift_build_files)} Swift build file references")
    
    # Create the Sources build phase content
    sources_entries = []
    for build_id, file_name, file_ref in swift_build_files:
        sources_entries.append(f"\t\t\t\t{build_id} /* {file_name}.swift in Sources */,")
    
    new_sources_content = f"""7B3D44332E82388E00E56ABB /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{chr(10).join(sources_entries)}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};"""
    
    # Replace the empty Sources build phase
    sources_pattern = r'7B3D44332E82388E00E56ABB /\* Sources \*/ = \{[^}]*\};'
    content = re.sub(sources_pattern, new_sources_content, content, flags=re.MULTILINE | re.DOTALL)
    
    # Write the updated content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Sources build phase fixed!")
    print("Now let's test the build...")

if __name__ == "__main__":
    fix_empty_sources_phase()
