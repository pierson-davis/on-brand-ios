#!/usr/bin/env python3
"""
Add OnboardingQuestionView.swift to the Xcode project.
"""

import re
import sys
import uuid

def add_onboarding_question_view():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate new UUIDs
    file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
    
    print(f"Generated IDs: {file_ref_id}, {build_file_id}")
    
    # Add the file reference (after OnboardingScreenModel.swift)
    file_ref_pattern = r'(B3EB0325FB3B43D190E464B4 /\* QuizModels\.swift \*/ = \{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode\.swift; path = "Features/Onboarding/Models/QuizModels\.swift"; sourceTree = "<group>"; \};)'
    file_ref_replacement = r'\1\n\t\t' + file_ref_id + ' /* OnboardingQuestionView.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "Features/Onboarding/Views/OnboardingQuestionView.swift"; sourceTree = "<group>"; };'
    
    content = re.sub(file_ref_pattern, file_ref_replacement, content)
    
    # Add the build file entry
    build_file_pattern = r'(6C7EF4A6245E4EBFAF6140EE /\* QuizModels\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = B3EB0325FB3B43D190E464B4 /\* QuizModels\.swift \*/; \};)'
    build_file_replacement = r'\1\n\t\t' + build_file_id + ' /* OnboardingQuestionView.swift in Sources */ = {isa = PBXBuildFile; fileRef = ' + file_ref_id + ' /* OnboardingQuestionView.swift */; };'
    
    content = re.sub(build_file_pattern, build_file_replacement, content)
    
    # Add to the Views group
    group_pattern = r'(7BDFB95E2E8B931F0043EF4D /\* Views \*/ = \{\s*isa = PBXGroup;\s*children = \(\s*7BDFB95F2E8B931F0043EF4D /\* OnboardingQuestionScreen\.swift \*/,?\s*\);\s*path = Views;\s*sourceTree = "<group>";\s*\};)'
    group_replacement = r'7BDFB95E2E8B931F0043EF4D /* Views */ = {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t7BDFB95F2E8B931F0043EF4D /* OnboardingQuestionScreen.swift */,\n\t\t\t\t' + file_ref_id + ' /* OnboardingQuestionView.swift */,\n\t\t\t);\n\t\t\tpath = Views;\n\t\t\tsourceTree = "<group>";\n\t\t};'
    
    content = re.sub(group_pattern, group_replacement, content)
    
    # Add to the main app target's Sources build phase
    sources_pattern = r'(6C7EF4A6245E4EBFAF6140EE /\* QuizModels\.swift in Sources \*/,?\s*9EC8ACACFF4D46A48231CA19 /\* EraDesignSystem\.swift in Sources \*/,?)'
    sources_replacement = r'6C7EF4A6245E4EBFAF6140EE /* QuizModels.swift in Sources */,\n\t\t\t\t9EC8ACACFF4D46A48231CA19 /* EraDesignSystem.swift in Sources */,\n\t\t\t\t' + build_file_id + ' /* OnboardingQuestionView.swift in Sources */,'
    
    content = re.sub(sources_pattern, sources_replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ OnboardingQuestionView.swift added to Xcode project!")

if __name__ == "__main__":
    add_onboarding_question_view()
