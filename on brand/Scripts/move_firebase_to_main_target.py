#!/usr/bin/env python3
"""
Script to move Firebase files from test target to main app target
"""

import re

def move_firebase_to_main_target():
    """Move Firebase files from test target to main app target"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Firebase files to move
    firebase_files = [
        'FirebaseConfiguration.swift',
        'FirebaseTestView.swift', 
        'FirebaseDeal.swift',
        'FirebaseDealService.swift',
        'FirebaseAuthService.swift'
    ]
    
    # Find the test target build phase (contains on_brandTests.swift)
    test_target_pattern = r'(7BC4B32F2E8B9BAA002E6EC0 /\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    test_match = re.search(test_target_pattern, content, re.DOTALL)
    
    if not test_match:
        print("❌ Test target build phase not found")
        return False
    
    test_build_phase = test_match.group(1)
    
    # Find the main app target build phase (contains on_brandApp.swift)
    main_target_pattern = r'(7BC4B3272E8B9BA6002E6EC0 /\* Sources \*/ = \{[^}]*files = \([^)]*\);[^}]*\})'
    main_match = re.search(main_target_pattern, content, re.DOTALL)
    
    if not main_match:
        print("❌ Main app target build phase not found")
        return False
    
    main_build_phase = main_match.group(1)
    
    # Remove Firebase files from test target
    new_test_build_phase = test_build_phase
    for filename in firebase_files:
        pattern = rf'\s*[A-Z0-9]{{24}} /\* {filename} in Sources \*/,?\n?'
        new_test_build_phase = re.sub(pattern, '', new_test_build_phase)
        print(f"✅ Removed {filename} from test target")
    
    # Add Firebase files to main target
    main_files_pattern = r'files = \(([^)]*)\);'
    main_files_match = re.search(main_files_pattern, main_build_phase, re.DOTALL)
    
    if not main_files_match:
        print("❌ Main target files section not found")
        return False
    
    main_files_content = main_files_match.group(1)
    
    # Add Firebase files to main target
    new_main_files_content = main_files_content.rstrip()
    for filename in firebase_files:
        # Find the correct UUID for this file
        uuid_pattern = rf'([A-Z0-9]{{24}}) /\* {filename} in Sources \*/'
        uuid_match = re.search(uuid_pattern, content)
        if uuid_match:
            uuid = uuid_match.group(1)
            new_main_files_content += f'\n\t\t\t\t{uuid} /* {filename} in Sources */,'
            print(f"✅ Added {filename} to main target")
        else:
            print(f"❌ Could not find UUID for {filename}")
    
    # Replace the files content in main target
    new_main_build_phase = main_build_phase.replace(main_files_content, new_main_files_content)
    
    # Update the content
    new_content = content.replace(test_build_phase, new_test_build_phase)
    new_content = new_content.replace(main_build_phase, new_main_build_phase)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print("✅ Firebase files moved to main app target")
    return True

if __name__ == "__main__":
    move_firebase_to_main_target()

