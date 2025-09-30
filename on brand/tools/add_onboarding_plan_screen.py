#!/usr/bin/env python3

import re
import uuid

def add_onboarding_plan_screen():
    project_file = "/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj"
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate unique IDs for the new file
    file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    # Add the file reference
    file_ref = f'\t\t{file_ref_id} /* OnboardingPlanScreen.swift */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "Features/Onboarding/Components/OnboardingPlanScreen.swift"; sourceTree = "<group>"; }};'
    
    # Add the build file reference
    build_file = f'\t\t{build_file_id} /* OnboardingPlanScreen.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* OnboardingPlanScreen.swift */; }};'
    
    # Find the PBXFileReference section and add the file reference
    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/.*?)(/\* End PBXFileReference section \*/)'
    match = re.search(file_ref_pattern, content, re.DOTALL)
    if match:
        # Add the file reference before the end marker
        new_content = content.replace(
            match.group(0),
            match.group(1) + file_ref + '\n' + match.group(2)
        )
    else:
        print("Could not find PBXFileReference section")
        return False
    
    # Find the PBXBuildFile section and add the build file reference
    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/.*?)(/\* End PBXBuildFile section \*/)'
    match = re.search(build_file_pattern, new_content, re.DOTALL)
    if match:
        # Add the build file reference before the end marker
        new_content = new_content.replace(
            match.group(0),
            match.group(1) + build_file + '\n' + match.group(2)
        )
    else:
        print("Could not find PBXBuildFile section")
        return False
    
    # Find the Sources build phase and add the file
    sources_pattern = r'(7B3D44332E82388E00E56ABB /\* Sources \*/ = \{\s*isa = PBXSourcesBuildPhase;\s*buildActionMask = 2147483647;\s*files = \(\s*)(.*?)(\s*\);\s*runOnlyForDeploymentPostprocessing = 0;\s*\};)'
    match = re.search(sources_pattern, new_content, re.DOTALL)
    if match:
        # Add the file to the sources build phase
        current_files = match.group(2)
        current_files += f'\t\t\t\t{build_file_id} /* OnboardingPlanScreen.swift in Sources */,\n'
        
        new_content = new_content.replace(
            match.group(0),
            match.group(1) + current_files + match.group(3)
        )
    else:
        print("Could not find Sources build phase")
        return False
    
    # Write the updated content back
    with open(project_file, 'w') as f:
        f.write(new_content)
    
    print("Successfully added OnboardingPlanScreen.swift to Xcode project")
    return True

if __name__ == "__main__":
    add_onboarding_plan_screen()
