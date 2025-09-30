#!/usr/bin/env python3
"""
Add SettingsView.swift to the Xcode project.
"""

import re
import sys
import uuid

def add_settings_view():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate new UUIDs
    file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    print(f"Generated IDs: {file_ref_id}, {build_file_id}")
    
    # Add the file reference (after OnboardingQuestionView.swift)
    file_ref_pattern = r'(53F0D0C6E2664CC295412C34 /\* OnboardingQuestionView\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = "Features/Onboarding/Views/OnboardingQuestionView\.swift"; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t' + file_ref_id + ' /* SettingsView.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "Features/Settings/Views/SettingsView.swift"; sourceTree = "<group>"; };'
    
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add the build file entry
    build_file_pattern = r'(75EB13977A3B40E48744402B /\* OnboardingQuestionView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 53F0D0C6E2664CC295412C34 /\* OnboardingQuestionView\.swift \*/; \};)'
    build_file_replacement = r'\1\n\t\t' + build_file_id + ' /* SettingsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = ' + file_ref_id + ' /* SettingsView.swift */; };'
    
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    # Add to the main app target's Sources build phase
    sources_pattern = r'(75EB13977A3B40E48744402B /\* OnboardingQuestionView\.swift in Sources \*/,?\s*9EC8ACACFF4D46A48231CA19 /\* EraDesignSystem\.swift in Sources \*/,?)'
    sources_replacement = r'75EB13977A3B40E48744402B /* OnboardingQuestionView.swift in Sources */,\n\t\t\t\t9EC8ACACFF4D46A48231CA19 /* EraDesignSystem.swift in Sources */,\n\t\t\t\t' + build_file_id + ' /* SettingsView.swift in Sources */,'
    
    content = re.sub(sources_pattern, sources_replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ SettingsView.swift added to Xcode project!")

if __name__ == "__main__":
    add_settings_view()
