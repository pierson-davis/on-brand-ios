#!/usr/bin/env python3
"""
Script to fix Firebase file UUIDs in the build phase
"""

import re

def fix_firebase_uuids():
    """Fix Firebase file UUIDs in the build phase"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Correct UUIDs from the project file
    correct_uuids = {
        'FirebaseConfiguration.swift': 'CA482DA03CFF4D4BB387DD1E',
        'FirebaseTestView.swift': '29D7CE32B231432F8C186099',
        'FirebaseDeal.swift': 'A0352C410726472A8F3E1845',
        'FirebaseDealService.swift': 'A05C5E345069423889BB3A0B',
        'FirebaseAuthService.swift': '028F148BC41245FD82B9AF79'
    }
    
    # Find the build phase section
    build_phase_pattern = r'(/\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    match = re.search(build_phase_pattern, content, re.DOTALL)
    
    if not match:
        print("❌ Build phase section not found")
        return False
    
    build_phase = match.group(1)
    
    # Fix each Firebase file UUID
    for filename, correct_uuid in correct_uuids.items():
        # Find the line with the wrong UUID
        wrong_pattern = rf'29D7CE32B231432F8C186\d+ /\* {filename} in Sources \*/'
        correct_line = f'{correct_uuid} /* {filename} in Sources */'
        
        if re.search(wrong_pattern, build_phase):
            build_phase = re.sub(wrong_pattern, correct_line, build_phase)
            print(f"✅ Fixed {filename} UUID")
        else:
            print(f"ℹ️  {filename} UUID already correct or not found")
    
    # Replace the build phase in the content
    new_content = content.replace(match.group(1), build_phase)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print("✅ Firebase UUIDs fixed in build phase")
    return True

if __name__ == "__main__":
    fix_firebase_uuids()

