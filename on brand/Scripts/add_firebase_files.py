#!/usr/bin/env python3
"""
Script to add Firebase files to Xcode project
This script systematically adds all Firebase-related files to the project.pbxproj
"""

import re
import uuid

def generate_uuid():
    """Generate a UUID for Xcode project references"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def add_firebase_files():
    """Add Firebase files to the Xcode project"""
    
    # Read the project file
    with open('on brand.xcodeproj/project.pbxproj', 'r') as f:
        content = f.read()
    
    # Firebase files to add
    firebase_files = [
        {
            'path': 'on brand/Core/Services/FirebaseConfiguration.swift',
            'name': 'FirebaseConfiguration.swift',
            'group': 'Core/Services'
        },
        {
            'path': 'on brand/Features/Authentication/Services/FirebaseAuthService.swift',
            'name': 'FirebaseAuthService.swift',
            'group': 'Features/Authentication/Services'
        },
        {
            'path': 'on brand/Features/CreatorRequirements/Models/FirebaseDeal.swift',
            'name': 'FirebaseDeal.swift',
            'group': 'Features/CreatorRequirements/Models'
        },
        {
            'path': 'on brand/Features/CreatorRequirements/Services/FirebaseDealService.swift',
            'name': 'FirebaseDealService.swift',
            'group': 'Features/CreatorRequirements/Services'
        },
        {
            'path': 'on brand/Features/Developer/Views/FirebaseTestView.swift',
            'name': 'FirebaseTestView.swift',
            'group': 'Features/Developer/Views'
        }
    ]
    
    # Generate UUIDs for each file
    file_refs = {}
    build_files = {}
    
    for file_info in firebase_files:
        file_id = generate_uuid()
        build_id = generate_uuid()
        
        file_refs[file_info['name']] = {
            'id': file_id,
            'path': file_info['path'],
            'group': file_info['group']
        }
        
        build_files[file_info['name']] = {
            'id': build_id,
            'file_ref': file_id
        }
    
    # Add PBXFileReference entries
    file_ref_section = "/* Begin PBXFileReference section */"
    file_ref_entries = []
    
    for name, info in file_refs.items():
        entry = f"\t\t{info['id']} /* {name} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = \"{info['path']}\"; sourceTree = \"<group>\"; }};"
        file_ref_entries.append(entry)
    
    # Insert file references
    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/)'
    file_ref_replacement = file_ref_section + '\n' + '\n'.join(file_ref_entries)
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add PBXBuildFile entries
    build_file_section = "/* Begin PBXBuildFile section */"
    build_file_entries = []
    
    for name, info in build_files.items():
        entry = f"\t\t{info['id']} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {info['file_ref']} /* {name} */; }};"
        build_file_entries.append(entry)
    
    # Insert build files
    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/)'
    build_file_replacement = build_file_section + '\n' + '\n'.join(build_file_entries)
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    # Add files to PBXSourcesBuildPhase
    sources_section_pattern = r'(files = \([\s\S]*?\);[\s]*inputPaths = \([\s\S]*?\);[\s]*outputPaths = \([\s\S]*?\);[\s]*runOnlyForDeploymentPostprocessing = 0;[\s]*shellPath = /bin/sh;[\s]*buildPhases = \([\s\S]*?\);[\s]*buildRules = \([\s\S]*?\);[\s]*dependencies = \([\s\S]*?\);[\s]*name = "on brand";[\s]*productName = "on brand";[\s]*productReference = [\s\S]*?;[\s]*productType = "com\.apple\.product-type\.application";[\s]*targets = \([\s\S]*?\);[\s]*\);[\s]*/\* End PBXNativeTarget section \*/)'
    
    # Find the sources build phase
    sources_pattern = r'(files = \([\s\S]*?)(\s*\);[\s]*inputPaths = \()'
    
    def add_sources_files(match):
        files_section = match.group(1)
        rest = match.group(2)
        
        # Add Firebase build files to sources
        firebase_sources = []
        for name, info in build_files.items():
            firebase_sources.append(f"\t\t\t\t{info['id']} /* {name} in Sources */,")
        
        return files_section + '\n' + '\n'.join(firebase_sources) + rest
    
    content = re.sub(sources_pattern, add_sources_files, content)
    
    # Write the updated project file
    with open('on brand.xcodeproj/project.pbxproj', 'w') as f:
        f.write(content)
    
    print("✅ Firebase files added to Xcode project successfully!")
    print("Added files:")
    for file_info in firebase_files:
        print(f"  - {file_info['name']}")

if __name__ == "__main__":
    add_firebase_files()

