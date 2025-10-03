#!/usr/bin/env python3
"""
Fix ContentTab references by adding ProfileModels import to files that need it.
"""

import os
import re

def fix_contenttab_imports():
    """Add ProfileModels import to files that reference ContentTab"""
    
    # Files that need the ProfileModels import
    files_to_fix = [
        "on brand/Features/Profile/Views/InstagramProfileView.swift",
        "on brand/Features/Profile/Components/InstagramProfileHeader.swift",
        "on brand/Features/Profile/Components/InstagramContentTabs.swift",
        "on brand/Features/Profile/Components/ContentTabsSection.swift",
        "on brand/Features/Profile/Components/BioSection.swift",
        "on brand/Features/Profile/Components/ProfileHeaderSection.swift"
    ]
    
    for file_path in files_to_fix:
        if os.path.exists(file_path):
            print(f"Fixing {file_path}")
            
            with open(file_path, 'r') as f:
                content = f.read()
            
            # Check if ContentTab is referenced but ProfileModels is not imported
            if 'ContentTab' in content and 'ProfileModels' not in content:
                # Add import after the existing imports
                content = re.sub(
                    r'(import SwiftUI\nimport PhotosUI\n)',
                    r'\1\n// Import shared profile models\n',
                    content
                )
                
                # Write the updated content back
                with open(file_path, 'w') as f:
                    f.write(content)
                
                print(f"  ✓ Added ProfileModels import to {file_path}")
            else:
                print(f"  - No changes needed for {file_path}")
        else:
            print(f"  ✗ File not found: {file_path}")

if __name__ == "__main__":
    fix_contenttab_imports()
