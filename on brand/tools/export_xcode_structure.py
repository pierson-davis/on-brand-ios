#!/usr/bin/env python3
"""
Export Xcode Project Structure
Shows the exact group structure that Xcode displays in the Project Navigator
"""

import re
from pathlib import Path

def export_xcode_structure():
    """Export the Xcode project structure as it appears in the Project Navigator"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    try:
        # Read the project file
        with open(project_file, 'r') as f:
            content = f.read()
        
        print("📱 Xcode Project Structure (as shown in Project Navigator)")
        print("=" * 60)
        
        # Find all groups
        groups = {}
        group_pattern = r'(\w+) = \{\s*isa = PBXGroup;\s*children = \(([^)]+)\);\s*name = ([^;]+);\s*sourceTree = <group>;\s*\};'
        
        for match in re.finditer(group_pattern, content, re.MULTILINE | re.DOTALL):
            group_id = match.group(1)
            children = match.group(2).strip().split()
            name = match.group(3).strip()
            groups[group_id] = {'name': name, 'children': children}
        
        # Find root group
        root_match = re.search(r'rootObject = (\w+);', content)
        if not root_match:
            print("❌ Could not find root object")
            return
        
        root_id = root_match.group(1)
        
        # Find the main group from the root object
        root_obj_pattern = rf'{root_id} = \{{[^}}]*mainGroup = (\w+);[^}}]*\}};'
        main_group_match = re.search(root_obj_pattern, content, re.MULTILINE | re.DOTALL)
        
        if not main_group_match:
            print("❌ Could not find main group")
            return
        
        main_group_id = main_group_match.group(1)
        
        def print_group(group_id, indent=0):
            if group_id not in groups:
                return
            
            group = groups[group_id]
            name = group['name']
            
            print("  " * indent + f"📁 {name}")
            
            # Print children
            for child_id in group['children']:
                # Check if it's a group
                if child_id in groups:
                    print_group(child_id, indent + 1)
                else:
                    # It's a file reference - find it
                    file_pattern = rf'{child_id} = \{{[^}}]*name = ([^;]+);[^}}]*path = ([^;]+);[^}}]*\}};'
                    file_match = re.search(file_pattern, content, re.MULTILINE | re.DOTALL)
                    
                    if file_match:
                        file_name = file_match.group(1).strip()
                        file_path = file_match.group(2).strip()
                        
                        # Check if file exists
                        exists = "✅" if Path(f"/Users/piersondavis/Documents/era/{file_path}").exists() else "🔴"
                        
                        # Determine file type
                        if file_name.endswith('.swift'):
                            icon = "🔥"
                        elif file_name.endswith('.plist'):
                            icon = "📋"
                        elif file_name.endswith('.xcconfig'):
                            icon = "⚙️"
                        elif file_name.endswith('.entitlements'):
                            icon = "🔐"
                        else:
                            icon = "📄"
                        
                        print("  " * (indent + 1) + f"{icon} {file_name} {exists}")
        
        print_group(main_group_id)
        
        print("\n" + "=" * 60)
        print("Legend:")
        print("✅ = File exists and is properly referenced")
        print("🔴 = File reference is broken (red in Xcode)")
        print("📁 = Group/Folder")
        print("🔥 = Swift file")
        print("📋 = Plist file")
        print("⚙️ = Config file")
        print("🔐 = Entitlements file")
        
    except Exception as e:
        print(f"❌ Error reading project file: {e}")

if __name__ == "__main__":
    export_xcode_structure()