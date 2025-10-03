#!/usr/bin/env python3
"""
Final script to add Firebase files to main app target
"""

def add_firebase_final():
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
    
    # Find the line that contains the closing of the main app target files section
    # Look for the line that contains "APIDebugView.swift in Sources" followed by ");"
    target_line = "7F7ED2E5D37C456598A75DE3 /* APIDebugView.swift in Sources */,"
    
    # Get the UUIDs for Firebase files
    firebase_uuids = {}
    for filename in firebase_files:
        for line in content.split('\n'):
            if filename in line and 'in Sources' in line:
                # Extract UUID
                parts = line.split('/*')
                if len(parts) > 0:
                    uuid = parts[0].strip()
                    firebase_uuids[filename] = uuid
                    print(f"✅ Found UUID for {filename}: {uuid}")
                    break
    
    # Add Firebase files after the target line
    new_content = content.replace(
        target_line,
        target_line + '\n' + '\n'.join([f'\t\t\t\t{firebase_uuids[filename]} /* {filename} in Sources */,' for filename in firebase_files if filename in firebase_uuids])
    )
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(new_content)
    
    print("✅ Firebase files added to main app target")
    return True

if __name__ == "__main__":
    add_firebase_final()

