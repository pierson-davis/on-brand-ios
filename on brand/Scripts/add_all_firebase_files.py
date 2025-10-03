#!/usr/bin/env python3
"""
Script to add all Firebase files to the Xcode project build phase
"""

import re

def add_all_firebase_files():
    """Add all Firebase files to the build phase"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Firebase files to add
    firebase_files = [
        {
            'name': 'FirebaseConfiguration.swift',
            'uuid': 'C7B4AF8EA81440C9892873C6',
            'build_uuid': '29D7CE32B231432F8C186100'
        },
        {
            'name': 'FirebaseTestView.swift', 
            'uuid': 'C7B4AF8EA81440C9892873C5',
            'build_uuid': '29D7CE32B231432F8C186099'
        },
        {
            'name': 'FirebaseDeal.swift',
            'uuid': 'C7B4AF8EA81440C9892873C7',
            'build_uuid': '29D7CE32B231432F8C186101'
        },
        {
            'name': 'FirebaseDealService.swift',
            'uuid': 'C7B4AF8EA81440C9892873C8',
            'build_uuid': '29D7CE32B231432F8C186102'
        },
        {
            'name': 'FirebaseAuthService.swift',
            'uuid': 'C7B4AF8EA81440C9892873C9',
            'build_uuid': '29D7CE32B231432F8C186103'
        }
    ]
    
    # Find the build phase section
    build_phase_pattern = r'(/\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    match = re.search(build_phase_pattern, content, re.DOTALL)
    
    if not match:
        print("❌ Build phase section not found")
        return False
    
    build_phase = match.group(1)
    
    # Check which files are already in the build phase
    files_in_build = []
    for file_info in firebase_files:
        if file_info['name'] in build_phase:
            files_in_build.append(file_info['name'])
            print(f"✅ {file_info['name']} is already in build phase")
        else:
            print(f"❌ {file_info['name']} is NOT in build phase")
    
    # Add missing files to build phase
    files_to_add = [f for f in firebase_files if f['name'] not in files_in_build]
    
    if not files_to_add:
        print("✅ All Firebase files are already in build phase")
        return True
    
    # Find the files section in build phase
    files_pattern = r'files = \(([^)]*)\);'
    files_match = re.search(files_pattern, build_phase, re.DOTALL)
    
    if not files_match:
        print("❌ Files section not found in build phase")
        return False
    
    files_content = files_match.group(1)
    
    # Add missing files to the files list
    new_files_content = files_content.rstrip()
    for file_info in files_to_add:
        new_files_content += f'\n\t\t\t\t{file_info["build_uuid"]} /* {file_info["name"]} in Sources */,'
    
    # Replace the files content
    new_build_phase = build_phase.replace(files_content, new_files_content)
    new_content = content.replace(build_phase, new_build_phase)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print(f"✅ Added {len(files_to_add)} Firebase files to build phase")
    for file_info in files_to_add:
        print(f"   - {file_info['name']}")
    
    return True

if __name__ == "__main__":
    add_all_firebase_files()

