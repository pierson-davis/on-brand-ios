#!/usr/bin/env python3
"""
Fix test files by removing them from main app target and ensuring they're only in test targets.
"""

import re
import sys

def fix_test_targets():
    project_file = "era.xcodeproj/project.pbxproj"
    
    print("Reading project file...")
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Test file references that should be removed from main app target
    test_files = [
        "eraUITestsLaunchTests.swift in Sources",
        "eraUITests.swift in Sources", 
        "eraTests.swift in Sources"
    ]
    
    print("Removing test files from main app target...")
    
    # Find the main app target's Sources build phase
    # Look for the pattern that includes all the test files
    sources_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9A82E8B93300043EF4D /\* ContentView\.swift \*/; \};\s*7BDFB9B12E8B93300043EF4D /\* LoadingView\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9A92E8B93300043EF4D /\* LoadingView\.swift \*/; \};\s*7BDFB9B22E8B93300043EF4D /\* UserProfileService\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9AB2E8B93300043EF4D /\* UserProfileService\.swift \*/; \};\s*7BDFB9B92E8B93370043EF4D /\* eraUITestsLaunchTests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B52E8B93370043EF4D /\* eraUITestsLaunchTests\.swift \*/; \};\s*7BDFB9BA2E8B93370043EF4D /\* eraUITests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B62E8B93370043EF4D /\* eraUITests\.swift \*/; \};\s*7BDFB9BB2E8B93370043EF4D /\* eraTests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B82E8B93370043EF4D /\* eraTests\.swift \*/; \};)'
    
    # Remove the test file build file entries
    content = re.sub(r'7BDFB9B92E8B93370043EF4D /\* eraUITestsLaunchTests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B52E8B93370043EF4D /\* eraUITestsLaunchTests\.swift \*/; \};\s*', '', content)
    content = re.sub(r'7BDFB9BA2E8B93370043EF4D /\* eraUITests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B62E8B93370043EF4D /\* eraUITests\.swift \*/; \};\s*', '', content)
    content = re.sub(r'7BDFB9BB2E8B93370043EF4D /\* eraTests\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 7BDFB9B82E8B93370043EF4D /\* eraTests\.swift \*/; \};\s*', '', content)
    
    # Remove test files from the main app target's Sources build phase
    # Find the main app target's build phase and remove test file references
    main_target_sources_pattern = r'(7BDFB9B02E8B93300043EF4D /\* ContentView\.swift in Sources \*/,?\s*7BDFB9B12E8B93300043EF4D /\* LoadingView\.swift in Sources \*/,?\s*7BDFB9B22E8B93300043EF4D /\* UserProfileService\.swift in Sources \*/,?\s*7BDFB9B92E8B93370043EF4D /\* eraUITestsLaunchTests\.swift in Sources \*/,?\s*7BDFB9BA2E8B93370043EF4D /\* eraUITests\.swift in Sources \*/,?\s*7BDFB9BB2E8B93370043EF4D /\* eraTests\.swift in Sources \*/,?)'
    
    # Replace with just the non-test files
    replacement = r'7BDFB9B02E8B93300043EF4D /* ContentView.swift in Sources */,\n\t\t\t\t7BDFB9B12E8B93300043EF4D /* LoadingView.swift in Sources */,\n\t\t\t\t7BDFB9B22E8B93300043EF4D /* UserProfileService.swift in Sources */,'
    
    content = re.sub(main_target_sources_pattern, replacement, content)
    
    print("Writing updated project file...")
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Test files removed from main app target!")
    print("Test files should now only be in their respective test targets.")

if __name__ == "__main__":
    fix_test_targets()
