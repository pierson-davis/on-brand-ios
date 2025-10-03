#!/usr/bin/env python3
"""
Simple script to add Firebase files to main app target
"""

def add_firebase_simple():
    """Add Firebase files to main app target"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        lines = f.readlines()
    
    # Firebase files to add
    firebase_files = [
        'FirebaseConfiguration.swift',
        'FirebaseTestView.swift', 
        'FirebaseDeal.swift',
        'FirebaseDealService.swift',
        'FirebaseAuthService.swift'
    ]
    
    # Find the main app target build phase (line 857)
    # Look for the line that contains the files section
    files_start_line = None
    for i, line in enumerate(lines):
        if '7BC4B31E2E8B9BA5002E6EC0 /* Sources */ = {' in line:
            # Find the files = ( line
            for j in range(i, min(i+20, len(lines))):
                if 'files = (' in lines[j]:
                    files_start_line = j
                    break
            break
    
    if files_start_line is None:
        print("❌ Main app target build phase not found")
        return False
    
    print(f"✅ Found main app target build phase at line {files_start_line}")
    
    # Find the end of the files section
    files_end_line = None
    for i in range(files_start_line, min(files_start_line+100, len(lines))):
        if ');' in lines[i]:
            files_end_line = i
            break
    
    if files_end_line is None:
        print("❌ End of files section not found")
        return False
    
    print(f"✅ Found end of files section at line {files_end_line}")
    
    # Get the UUIDs for Firebase files
    firebase_uuids = {}
    for filename in firebase_files:
        for line in lines:
            if filename in line and 'in Sources' in line:
                # Extract UUID
                parts = line.split('/*')
                if len(parts) > 0:
                    uuid = parts[0].strip()
                    firebase_uuids[filename] = uuid
                    print(f"✅ Found UUID for {filename}: {uuid}")
                    break
    
    # Add Firebase files to the main target
    new_lines = []
    for i, line in enumerate(lines):
        if i == files_end_line:
            # Add Firebase files before the closing );
            for filename in firebase_files:
                if filename in firebase_uuids:
                    new_lines.append(f'\t\t\t\t{firebase_uuids[filename]} /* {filename} in Sources */,\n')
                    print(f"✅ Added {filename} to main target")
        new_lines.append(line)
    
    # Write the updated content
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.writelines(new_lines)
    
    print("✅ Firebase files added to main app target")
    return True

if __name__ == "__main__":
    add_firebase_simple()
