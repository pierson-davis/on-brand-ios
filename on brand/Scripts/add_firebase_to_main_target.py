#!/usr/bin/env python3
"""
Script to add Firebase files to main app target
"""

import re

def add_firebase_to_main_target():
    """Add Firebase files to main app target"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Firebase files to add
    firebase_files = [
        'FirebaseConfiguration.swift',
        'FirebaseTestView.swift', 
        'FirebaseDeal.swift',
        'FirebaseDealService.swift',
        'FirebaseAuthService.swift'
    ]
    
    # Find the main app target build phase
    main_target_pattern = r'(7BC4B31E2E8B9BA5002E6EC0 /\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    main_match = re.search(main_target_pattern, content, re.DOTALL)
    
    if not main_match:
        print("❌ Main app target build phase not found")
        return False
    
    main_build_phase = main_match.group(1)
    
    # Find the files section in main target
    files_pattern = r'files = \(([^)]*)\);'
    files_match = re.search(files_pattern, main_build_phase, re.DOTALL)
    
    if not files_match:
        print("❌ Main target files section not found")
        return False
    
    files_content = files_match.group(1)
    
    # Add Firebase files to main target
    new_files_content = files_content.rstrip()
    for filename in firebase_files:
        # Find the correct UUID for this file
        uuid_pattern = rf'([A-Z0-9]{{24}}) /\* {filename} in Sources \*/'
        uuid_match = re.search(uuid_pattern, content)
        if uuid_match:
            uuid = uuid_match.group(1)
            new_files_content += f'\n\t\t\t\t{uuid} /* {filename} in Sources */,'
            print(f"✅ Added {filename} to main target")
        else:
            print(f"❌ Could not find UUID for {filename}")
    
    # Replace the files content in main target
    new_main_build_phase = main_build_phase.replace(files_content, new_files_content)
    
    # Update the content
    new_content = content.replace(main_build_phase, new_main_build_phase)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print("✅ Firebase files added to main app target")
    return True

if __name__ == "__main__":
    add_firebase_to_main_target()

