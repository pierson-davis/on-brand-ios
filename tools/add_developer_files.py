#!/usr/bin/env python3
"""
Script to add Developer feature files to the Xcode project.
This script adds all the new Developer feature files to the project.pbxproj file.
"""

import re
import sys
import uuid

def add_developer_files_to_project(pbxproj_path):
    print("🚀 Adding Developer feature files to Xcode project...")
    
    with open(pbxproj_path, 'r') as f:
        content = f.read()
    
    # Files to add
    developer_files = [
        "DeveloperDashboard.swift",
        "ScreenshotGeneratorView.swift", 
        "ThemeTesterView.swift",
        "DebugToolsView.swift",
        "AppInfoView.swift",
        "DeveloperNavigationManager.swift"
    ]
    
    # Generate UUIDs for the new files
    file_refs = {}
    build_files = {}
    
    for file_name in developer_files:
        file_refs[file_name] = str(uuid.uuid4()).replace('-', '').upper()[:24]
        build_files[file_name] = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    print("📝 Adding file references...")
    
    # Add PBXFileReference entries
    file_ref_section = "/* Begin PBXFileReference section */"
    file_ref_end = "/* End PBXFileReference section */"
    
    file_ref_entries = []
    for file_name in developer_files:
        if file_name == "DeveloperNavigationManager.swift":
            # This goes in Services folder
            file_ref_entries.append(f'\t\t{file_refs[file_name]} /* {file_name} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "{file_name}"; sourceTree = "<group>"; }};')
        else:
            # These go in Views folder
            file_ref_entries.append(f'\t\t{file_refs[file_name]} /* {file_name} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "{file_name}"; sourceTree = "<group>"; }};')
    
    # Insert file references
    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/)'
    file_ref_replacement = r'\1\n' + '\n'.join(file_ref_entries)
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    print("📝 Adding build file references...")
    
    # Add PBXBuildFile entries
    build_file_section = "/* Begin PBXBuildFile section */"
    
    build_file_entries = []
    for file_name in developer_files:
        build_file_entries.append(f'\t\t{build_files[file_name]} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_refs[file_name]} /* {file_name} */; }};')
    
    # Insert build file references
    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/)'
    build_file_replacement = r'\1\n' + '\n'.join(build_file_entries)
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    print("📝 Adding files to PBXGroup...")
    
    # Add files to the appropriate groups
    # First, find the Features group
    features_group_pattern = r'(on brand/Features.*?children = \(.*?)(\s+)(.*?)(\s+\);.*?name = Features;)'
    
    def add_to_features_group(match):
        indent = match.group(2)
        existing_files = match.group(3)
        
        # Add Developer group
        developer_group_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        developer_group_entry = f'{indent}/* Developer */ = {{\n{indent}\t\t\tisa = PBXGroup;\n{indent}\t\t\tchildren = (\n'
        
        # Add Views group
        views_group_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        views_group_entry = f'{indent}\t\t\t\t/* Views */ = {{\n{indent}\t\t\t\t\tisa = PBXGroup;\n{indent}\t\t\t\t\tchildren = (\n'
        
        # Add Views files
        for file_name in developer_files:
            if file_name != "DeveloperNavigationManager.swift":
                views_group_entry += f'{indent}\t\t\t\t\t\t{file_refs[file_name]} /* {file_name} */,\n'
        
        views_group_entry += f'{indent}\t\t\t\t\t);\n{indent}\t\t\t\t\tpath = Views;\n{indent}\t\t\t\t\tsourceTree = "<group>";\n{indent}\t\t\t\t}};\n'
        
        # Add Services group
        services_group_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        services_group_entry = f'{indent}\t\t\t\t/* Services */ = {{\n{indent}\t\t\t\t\tisa = PBXGroup;\n{indent}\t\t\t\t\tchildren = (\n'
        services_group_entry += f'{indent}\t\t\t\t\t\t{file_refs["DeveloperNavigationManager.swift"]} /* DeveloperNavigationManager.swift */,\n'
        services_group_entry += f'{indent}\t\t\t\t\t);\n{indent}\t\t\t\t\tpath = Services;\n{indent}\t\t\t\t\tsourceTree = "<group>";\n{indent}\t\t\t\t}};\n'
        
        # Complete Developer group
        developer_group_entry += f'{indent}\t\t\t\t{views_group_id} /* Views */,\n'
        developer_group_entry += f'{indent}\t\t\t\t{services_group_id} /* Services */,\n'
        developer_group_entry += f'{indent}\t\t\t);\n{indent}\t\t\tpath = Developer;\n{indent}\t\t\tsourceTree = "<group>";\n{indent}\t\t}};\n'
        
        return f'{match.group(1)}{existing_files}{indent}{developer_group_entry}{indent}{match.group(4)}'
    
    content = re.sub(features_group_pattern, add_to_features_group, content, flags=re.DOTALL)
    
    print("📝 Adding files to build phases...")
    
    # Add files to PBXSourcesBuildPhase
    sources_build_phase_pattern = r'(files = \(.*?)(\s+)(.*?)(\s+\);.*?name = Sources;)'
    
    def add_to_sources_build_phase(match):
        indent = match.group(2)
        existing_files = match.group(3)
        
        # Add all build file references
        build_file_entries = []
        for file_name in developer_files:
            build_file_entries.append(f'{indent}\t\t\t\t{build_files[file_name]} /* {file_name} in Sources */,')
        
        return f'{match.group(1)}{existing_files}\n' + '\n'.join(build_file_entries) + f'\n{indent}\t\t\t{match.group(4)}'
    
    content = re.sub(sources_build_phase_pattern, add_to_sources_build_phase, content, flags=re.DOTALL)
    
    print("📝 Writing updated project.pbxproj...")
    with open(pbxproj_path, 'w') as f:
        f.write(content)
    
    print("✅ Successfully added Developer feature files to Xcode project!")
    print("💡 You can now build your project with the new Developer dashboard.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python add_developer_files.py <path_to_project.pbxproj>")
        sys.exit(1)
    
    pbxproj_file = sys.argv[1]
    add_developer_files_to_project(pbxproj_file)
