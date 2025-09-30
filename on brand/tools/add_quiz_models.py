#!/usr/bin/env python3
"""
Add QuizModels.swift to the Xcode project.
"""

import re
import sys
import uuid

def add_quiz_models():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate new UUIDs
    file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    print(f"Generated IDs: {file_ref_id}, {build_file_id}")
    
    # Add the file reference (after OnboardingScreenModel.swift)
    file_ref_pattern = r'(7BDFB93E2E8B93200043EF4D /\* OnboardingScreenModel\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = OnboardingScreenModel\.swift; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t' + file_ref_id + ' /* QuizModels.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "Features/Onboarding/Models/QuizModels.swift"; sourceTree = "<group>"; };'
    
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add the build file entry
    build_file_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9A82E8B93300043EF4D /\* ContentView\.swift \*/; \};)'
    build_file_replacement = r'\1\n\t\t' + build_file_id + ' /* QuizModels.swift in Sources */ = {isa = PBXBuildFile; fileRef = ' + file_ref_id + ' /* QuizModels.swift */; };'
    
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    # Add to the Models group
    group_pattern = r'(7BDFB93D2E8B93200043EF4D /\* Models \*/ = \{\s*isa = PBXGroup;\s*children = \(\s*7BDFB93E2E8B93200043EF4D /\* OnboardingScreenModel\.swift \*/,?\s*\);\s*path = Models;\s*sourceTree = "<group>";\s*\};)'
    group_replacement = r'7BDFB93D2E8B93200043EF4D /* Models */ = {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t7BDFB93E2E8B93200043EF4D /* OnboardingScreenModel.swift */,\n\t\t\t\t' + file_ref_id + ' /* QuizModels.swift */,\n\t\t\t);\n\t\t\tpath = Models;\n\t\t\tsourceTree = "<group>";\n\t\t};'
    
    content = re.sub(group_pattern, group_replacement, content)
    
    # Add to the main app target's Sources build phase
    sources_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/,?\s*7BDFB9B12E8B93300043EF4D /\* LoadingView\.swift in Sources \*/,?\s*7BDFB9B22E8B93300043EF4D /\* UserProfileService\.swift in Sources \*/,?\s*9EC8ACACFF4D46A48231CA19 /\* EraDesignSystem\.swift in Sources \*/,?)'
    sources_replacement = r'7BDFB9B02E8B93300043EF4D /* ContentView.swift in Sources */,\n\t\t\t\t7BDFB9B12E8B93300043EF4D /* LoadingView.swift in Sources */,\n\t\t\t\t7BDFB9B22E8B93300043EF4D /* UserProfileService.swift in Sources */,\n\t\t\t\t9EC8ACACFF4D46A48231CA19 /* EraDesignSystem.swift in Sources */,\n\t\t\t\t' + build_file_id + ' /* QuizModels.swift in Sources */,'
    
    content = re.sub(sources_pattern, sources_replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ QuizModels.swift added to Xcode project!")

if __name__ == "__main__":
    add_quiz_models()
