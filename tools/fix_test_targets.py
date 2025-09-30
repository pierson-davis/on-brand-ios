#!/usr/bin/env python3
"""
Fix test files being included in main app target
"""

import re
import sys
from pathlib import Path

def fix_test_targets(project_file_path):
    """Remove test files from main app target and ensure they're only in test targets"""
    
    with open(project_file_path, 'r') as f:
        content = f.read()
    
    # Test files that should be removed from main app target
    test_files = [
        'eraTests.swift',
        'eraUITests.swift', 
        'eraUITestsLaunchTests.swift'
    ]
    
    print("Removing test files from main app target...")
    
    # Remove test file build references from main app target
    for test_file in test_files:
        # Remove build file references
        pattern = rf'(\w+.*{re.escape(test_file)}.*in Sources.*)'
        content = re.sub(pattern, '', content)
        
        # Remove file references from main app target
        pattern = rf'(\w+.*{re.escape(test_file)}.*)'
        content = re.sub(pattern, '', content)
        
        print(f"  Removed {test_file}")
    
    # Clean up any empty lines or trailing commas
    content = re.sub(r',\s*\n\s*};', '};', content)
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)
    
    # Write the fixed content back
    with open(project_file_path, 'w') as f:
        f.write(content)
    
    print("✅ Test files removed from main app target!")

if __name__ == "__main__":
    project_file = Path("/Users/piersondavis/Documents/on brand/on brand.xcodeproj/project.pbxproj")
    fix_test_targets(project_file)
    print("✅ Test target configuration fixed!")
