#!/usr/bin/env python3
"""
Script to fix FirebaseTestView build phase inclusion
"""

import re

def fix_firebase_build():
    """Add FirebaseTestView to the build phase"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Find the build phase section
    build_phase_pattern = r'(/\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    match = re.search(build_phase_pattern, content, re.DOTALL)
    
    if not match:
        print("❌ Build phase section not found")
        return False
    
    build_phase = match.group(1)
    
    # Check if FirebaseTestView is already in the build phase
    if 'FirebaseTestView.swift' in build_phase:
        print("✅ FirebaseTestView.swift is already in build phase")
        return True
    
    # Find the last file in the build phase
    files_pattern = r'files = \(([^)]*)\);'
    files_match = re.search(files_pattern, build_phase, re.DOTALL)
    
    if not files_match:
        print("❌ Files section not found in build phase")
        return False
    
    files_content = files_match.group(1)
    
    # Add FirebaseTestView to the files list
    new_files_content = files_content.rstrip() + '\n\t\t\t\t29D7CE32B231432F8C186099 /* FirebaseTestView.swift in Sources */,'
    
    # Replace the files content
    new_build_phase = build_phase.replace(files_content, new_files_content)
    new_content = content.replace(build_phase, new_build_phase)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print("✅ FirebaseTestView.swift added to build phase")
    return True

if __name__ == "__main__":
    fix_firebase_build()

