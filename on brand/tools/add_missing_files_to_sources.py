#!/usr/bin/env python3

import re

def add_missing_files_to_sources():
    project_file = "/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj"
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find the Sources build phase section
    sources_pattern = r'(7B3D44332E82388E00E56ABB /\* Sources \*/ = \{\s*isa = PBXSourcesBuildPhase;\s*buildActionMask = 2147483647;\s*files = \(\s*)(.*?)(\s*\);\s*runOnlyForDeploymentPostprocessing = 0;\s*\};)'
    
    match = re.search(sources_pattern, content, re.DOTALL)
    if not match:
        print("Could not find Sources build phase")
        return False
    
    # Get the current files list
    current_files = match.group(2)
    
    # Check if the missing files are already in the list
    if "75EB13977A3B40E48744402B" in current_files:
        print("OnboardingQuestionView.swift already in Sources build phase")
    else:
        # Add OnboardingQuestionView.swift to the files list
        current_files += "\t\t\t\t75EB13977A3B40E48744402B /* OnboardingQuestionView.swift in Sources */,\n"
        print("Added OnboardingQuestionView.swift to Sources build phase")
    
    if "3B2BA6A01A6F4E77AED93C11" in current_files:
        print("SettingsView.swift already in Sources build phase")
    else:
        # Add SettingsView.swift to the files list
        current_files += "\t\t\t\t3B2BA6A01A6F4E77AED93C11 /* SettingsView.swift in Sources */,\n"
        print("Added SettingsView.swift to Sources build phase")
    
    # Reconstruct the content
    new_content = content.replace(match.group(0), match.group(1) + current_files + match.group(3))
    
    # Write the updated content back
    with open(project_file, 'w') as f:
        f.write(new_content)
    
    print("Successfully updated Sources build phase")
    return True

if __name__ == "__main__":
    add_missing_files_to_sources()
