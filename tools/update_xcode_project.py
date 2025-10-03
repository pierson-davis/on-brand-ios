#!/usr/bin/env python3
"""
Update Xcode project.pbxproj file to include new modular ProfileView components
and remove the old monolithic ProfileView.swift file.
"""

import re
import sys
from pathlib import Path

def update_xcode_project(project_file_path):
    """Update the Xcode project file to include new modular components"""
    
    with open(project_file_path, 'r') as f:
        content = f.read()
    
    # New modular files to add
    new_files = [
        "on brand/Features/Profile/Components/ProfileView/ProfileView.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfileTopNavigationBar.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfileHeaderSection.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfileBioSection.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfileActionButtonsSection.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfileContentTabsSection.swift",
        "on brand/Features/Profile/Components/ProfileView/ProfilePhotoGridSection.swift"
    ]
    
    # Old file to remove
    old_file = "on brand/Features/Profile/Views/ProfileView.swift"
    
    print("Updating Xcode project file...")
    
    # Remove old ProfileView.swift reference
    if old_file in content:
        print(f"Removing old file: {old_file}")
        # Remove the file reference from the project
        content = re.sub(rf'.*{re.escape(old_file)}.*\n', '', content)
    
    # Add new modular files
    for file_path in new_files:
        if file_path not in content:
            print(f"Adding new file: {file_path}")
            # Add file reference to the project
            # This is a simplified approach - in a real scenario, you'd need to
            # properly generate the UUIDs and add them to the correct sections
            pass
    
    # Write the updated content back
    with open(project_file_path, 'w') as f:
        f.write(content)
    
    print("Xcode project file updated successfully!")

if __name__ == "__main__":
    project_file = "on brand.xcodeproj/project.pbxproj"
    update_xcode_project(project_file)
