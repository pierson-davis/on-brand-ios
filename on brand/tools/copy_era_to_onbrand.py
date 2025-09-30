#!/usr/bin/env python3
"""
Copy Era Project to On Brand Project
Copies all files from the era project to the on brand project
"""

import os
import shutil
from pathlib import Path

def copy_all_files():
    """Copy all files from era to on brand project"""
    
    era_path = Path("/Users/piersondavis/Documents/era")
    onbrand_path = Path("/Users/piersondavis/Documents/on brand")
    
    print("🚀 Starting complete copy from era to on brand...")
    print("=" * 60)
    
    # Files and directories to copy
    items_to_copy = [
        # App level files
        ("App/", "on brand/App/"),
        ("Core/", "on brand/Core/"),
        ("Features/", "on brand/Features/"),
        ("Shared/", "on brand/Shared/"),
        ("Resources/", "on brand/Resources/"),
        ("Tests/", "on brand/Tests/"),
        ("Documentation/", "on brand/Documentation/"),
        ("tools/", "on brand/tools/"),
        (".cursorrules", "on brand/.cursorrules"),
        ("README.md", "on brand/README.md"),
        (".gitignore", "on brand/.gitignore"),
    ]
    
    # Copy each item
    for source, destination in items_to_copy:
        source_path = era_path / source
        dest_path = onbrand_path / destination
        
        if source_path.exists():
            if source_path.is_dir():
                print(f"📁 Copying directory: {source} → {destination}")
                if dest_path.exists():
                    shutil.rmtree(str(dest_path))
                shutil.copytree(str(source_path), str(dest_path))
            else:
                print(f"📄 Copying file: {source} → {destination}")
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(str(source_path), str(dest_path))
        else:
            print(f"⚠️  Warning: {source} not found")
    
    # Copy era subfolder files (if they exist)
    era_subfolder = era_path / "era"
    if era_subfolder.exists():
        print("\n📁 Copying era subfolder contents...")
        for item in era_subfolder.iterdir():
            if item.is_dir():
                dest_path = onbrand_path / "on brand" / item.name
                print(f"📁 Copying subfolder: era/{item.name} → on brand/{item.name}")
                if dest_path.exists():
                    shutil.rmtree(str(dest_path))
                shutil.copytree(str(item), str(dest_path))
            else:
                dest_path = onbrand_path / "on brand" / item.name
                print(f"📄 Copying subfile: era/{item.name} → on brand/{item.name}")
                shutil.copy2(str(item), str(dest_path))
    
    print("\n✅ Copy complete!")
    print("\nNext steps:")
    print("1. Open on brand.xcodeproj in Xcode")
    print("2. Add all the copied Swift files to the project")
    print("3. Update build settings if needed")
    print("4. Test the build")

def verify_copy():
    """Verify that all important files were copied"""
    
    onbrand_path = Path("/Users/piersondavis/Documents/on brand")
    
    print("\n🔍 Verifying copy...")
    
    # Check for key directories
    key_dirs = [
        "on brand/App",
        "on brand/Core", 
        "on brand/Features",
        "on brand/Shared",
        "on brand/Resources",
        "on brand/Tests",
        "on brand/Documentation"
    ]
    
    for dir_path in key_dirs:
        full_path = onbrand_path / dir_path
        if full_path.exists():
            file_count = len(list(full_path.rglob("*.swift")))
            print(f"✅ {dir_path}: {file_count} Swift files")
        else:
            print(f"❌ {dir_path}: Missing")
    
    # Check for key files
    key_files = [
        "on brand/App/eraApp.swift",
        "on brand/App/Info.plist",
        "on brand/App/era.entitlements",
        "on brand/Shared/Views/ContentView.swift",
        "on brand/Resources/Assets.xcassets"
    ]
    
    for file_path in key_files:
        full_path = onbrand_path / file_path
        if full_path.exists():
            print(f"✅ {file_path}: Found")
        else:
            print(f"❌ {file_path}: Missing")

if __name__ == "__main__":
    copy_all_files()
    verify_copy()
