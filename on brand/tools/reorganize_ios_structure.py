#!/usr/bin/env python3
"""
iOS App Structure Reorganization Script
Reorganizes the Era iOS app following best practices for non-technical auditing
"""

import os
import shutil
from pathlib import Path

def create_folder_structure(base_path):
    """Create the new folder structure"""
    folders = [
        "App",
        "Core/DesignSystem",
        "Core/Extensions", 
        "Core/Utilities",
        "Core/Constants",
        "Features/Authentication/Views",
        "Features/Authentication/ViewModels", 
        "Features/Authentication/Services",
        "Features/Onboarding/Views",
        "Features/Onboarding/ViewModels",
        "Features/Onboarding/Models",
        "Features/Onboarding/Components",
        "Features/Home/Views",
        "Features/Home/Components",
        "Features/Profile/Views", 
        "Features/Profile/Components",
        "Features/PhotoAnalysis/Views",
        "Features/PhotoAnalysis/ViewModels",
        "Features/PhotoAnalysis/Services",
        "Features/Settings/Views",
        "Shared/Models",
        "Shared/Services",
        "Shared/ViewModels", 
        "Shared/Views",
        "Resources/Assets.xcassets",
        "Resources/Fonts",
        "Tests/UnitTests",
        "Tests/UITests",
        "Documentation"
    ]
    
    for folder in folders:
        folder_path = base_path / folder
        folder_path.mkdir(parents=True, exist_ok=True)
        print(f"Created folder: {folder}")

def move_files(base_path):
    """Move files to their new locations"""
    file_mappings = {
        # App level files
        "eraApp.swift": "App/eraApp.swift",
        "Info.plist": "App/Info.plist", 
        "era.entitlements": "App/era.entitlements",
        "Secrets.xcconfig": "App/Secrets.xcconfig",
        
        # Core files
        "DesignSystem/EraDesignSystem.swift": "Core/DesignSystem/EraDesignSystem.swift",
        "DesignSystem/ThemeManager.swift": "Core/DesignSystem/ThemeManager.swift",
        
        # Authentication files
        "Views/Components/Login/LoginView.swift": "Features/Authentication/Views/LoginView.swift",
        "Views/Components/Login/AppleSignInButton.swift": "Features/Authentication/Views/AppleSignInButton.swift", 
        "Views/Components/Login/LoginLoadingOverlay.swift": "Features/Authentication/Views/LoginLoadingOverlay.swift",
        "Services/AuthenticationService.swift": "Features/Authentication/Services/AuthenticationService.swift",
        
        # Onboarding files
        "Views/OnboardingQuestionView.swift": "Features/Onboarding/Views/OnboardingQuestionView.swift",
        "ViewModels/OnboardingViewModel.swift": "Features/Onboarding/ViewModels/OnboardingViewModel.swift",
        "Flows/Onboarding/OnboardingScreenModel.swift": "Features/Onboarding/Models/OnboardingScreenModel.swift",
        "Models/OnboardingQuestions.swift": "Features/Onboarding/Models/OnboardingQuestions.swift",
        "Models/QuizModels.swift": "Features/Onboarding/Models/QuizModels.swift",
        
        # Onboarding Components
        "Flows/Onboarding/components/GenderSelectionView.swift": "Features/Onboarding/Components/GenderSelectionView.swift",
        "Flows/Onboarding/components/NameInputView.swift": "Features/Onboarding/Components/NameInputView.swift",
        "Flows/Onboarding/components/OnboardingChecklistScreen.swift": "Features/Onboarding/Components/OnboardingChecklistScreen.swift",
        "Flows/Onboarding/components/OnboardingHeroScreen.swift": "Features/Onboarding/Components/OnboardingHeroScreen.swift",
        "Flows/Onboarding/components/OnboardingPermissionScreen.swift": "Features/Onboarding/Components/OnboardingPermissionScreen.swift",
        "Flows/Onboarding/components/OnboardingPlanScreen.swift": "Features/Onboarding/Components/OnboardingPlanScreen.swift",
        "Flows/Onboarding/components/OnboardingProblemScreen.swift": "Features/Onboarding/Components/OnboardingProblemScreen.swift",
        "Flows/Onboarding/components/OnboardingProgressGraphScreen.swift": "Features/Onboarding/Components/OnboardingProgressGraphScreen.swift",
        "Flows/Onboarding/components/OnboardingProgressHeader.swift": "Features/Onboarding/Components/OnboardingProgressHeader.swift",
        "Flows/Onboarding/components/OnboardingProgressTrackingScreen.swift": "Features/Onboarding/Components/OnboardingProgressTrackingScreen.swift",
        "Flows/Onboarding/components/OnboardingQuestionScreen.swift": "Features/Onboarding/Components/OnboardingQuestionScreen.swift",
        "Flows/Onboarding/components/OnboardingSummaryScreen.swift": "Features/Onboarding/Components/OnboardingSummaryScreen.swift",
        "Flows/Onboarding/components/OnboardingWelcomeScreen.swift": "Features/Onboarding/Components/OnboardingWelcomeScreen.swift",
        
        # Home files
        "Views/HomeView.swift": "Features/Home/Views/HomeView.swift",
        "Views/Components/Home/QuickActionsSection.swift": "Features/Home/Components/QuickActionsSection.swift",
        "Views/Components/Home/RecentPhotosSection.swift": "Features/Home/Components/RecentPhotosSection.swift",
        "Views/Components/Home/WelcomeSection.swift": "Features/Home/Components/WelcomeSection.swift",
        
        # Profile files
        "Views/ProfileView.swift": "Features/Profile/Views/ProfileView.swift",
        "Views/InstagramProfileView.swift": "Features/Profile/Views/InstagramProfileView.swift",
        "Views/Components/Profile/ActionButtonsSection.swift": "Features/Profile/Components/ActionButtonsSection.swift",
        "Views/Components/Profile/AnalysisCard.swift": "Features/Profile/Components/AnalysisCard.swift",
        "Views/Components/Profile/BioSection.swift": "Features/Profile/Components/BioSection.swift",
        "Views/Components/Profile/ContentTabsSection.swift": "Features/Profile/Components/ContentTabsSection.swift",
        "Views/Components/Profile/PhotoGridSection.swift": "Features/Profile/Components/PhotoGridSection.swift",
        "Views/Components/Profile/ProfileHeaderSection.swift": "Features/Profile/Components/ProfileHeaderSection.swift",
        "Views/Components/InstagramProfile/InstagramActionButtons.swift": "Features/Profile/Components/InstagramActionButtons.swift",
        "Views/Components/InstagramProfile/InstagramContentTabs.swift": "Features/Profile/Components/InstagramContentTabs.swift",
        "Views/Components/InstagramProfile/InstagramPhotoGrid.swift": "Features/Profile/Components/InstagramPhotoGrid.swift",
        "Views/Components/InstagramProfile/InstagramProfileHeader.swift": "Features/Profile/Components/InstagramProfileHeader.swift",
        "Views/Components/InstagramProfile/InstagramTopBar.swift": "Features/Profile/Components/InstagramTopBar.swift",
        
        # Photo Analysis files
        "Views/PhotoAnalyzerView.swift": "Features/PhotoAnalysis/Views/PhotoAnalyzerView.swift",
        "ViewModels/AnalyzeViewModel.swift": "Features/PhotoAnalysis/ViewModels/AnalyzeViewModel.swift",
        "Services/AIService.swift": "Features/PhotoAnalysis/Services/AIService.swift",
        "Services/VibeAnalyzer.swift": "Features/PhotoAnalysis/Services/VibeAnalyzer.swift",
        "Views/Components/PhotoAnalyzer/AICurationSection.swift": "Features/PhotoAnalysis/Views/AICurationSection.swift",
        "Views/Components/PhotoAnalyzer/PhotoPickerSection.swift": "Features/PhotoAnalysis/Views/PhotoPickerSection.swift",
        
        # Settings files
        "Views/SettingsView.swift": "Features/Settings/Views/SettingsView.swift",
        
        # Shared files
        "Models/Archetype.swift": "Shared/Models/Archetype.swift",
        "Models/UserProfile.swift": "Shared/Models/UserProfile.swift",
        "Models/VibeResult.swift": "Shared/Models/VibeResult.swift",
        "Models/AIPromptModels.swift": "Shared/Models/AIPromptModels.swift",
        "Services/UserProfileService.swift": "Shared/Services/UserProfileService.swift",
        "Views/ContentView.swift": "Shared/Views/ContentView.swift",
        "Views/LoadingView.swift": "Shared/Views/LoadingView.swift",
        
        # Resources
        "Assets.xcassets": "Resources/Assets.xcassets",
        "Preview Content/Preview Assets.xcassets": "Resources/Preview Assets.xcassets",
        
        # Tests
        "eraTests/eraTests.swift": "Tests/UnitTests/eraTests.swift",
        "eraUITests/eraUITests.swift": "Tests/UITests/eraUITests.swift",
        "eraUITests/eraUITestsLaunchTests.swift": "Tests/UITests/eraUITestsLaunchTests.swift",
        
        # Documentation
        "Inspo/era_code_notes.txt": "Documentation/era_code_notes.txt"
    }
    
    for old_path, new_path in file_mappings.items():
        old_file = base_path / old_path
        new_file = base_path / new_path
        
        if old_file.exists():
            # Create parent directory if it doesn't exist
            new_file.parent.mkdir(parents=True, exist_ok=True)
            
            # Move the file
            shutil.move(str(old_file), str(new_file))
            print(f"Moved: {old_path} → {new_path}")
        else:
            print(f"Warning: File not found: {old_path}")

def cleanup_unused_files(base_path):
    """Remove unused files and folders"""
    unused_items = [
        "unused/",
        "Flows/",
        "Models/",
        "Services/", 
        "ViewModels/",
        "Views/",
        "Preview Content/"
    ]
    
    for item in unused_items:
        item_path = base_path / item
        if item_path.exists():
            if item_path.is_dir():
                shutil.rmtree(str(item_path))
                print(f"Removed directory: {item}")
            else:
                item_path.unlink()
                print(f"Removed file: {item}")

def main():
    """Main reorganization function"""
    base_path = Path("/Users/piersondavis/Documents/era/era")
    
    print("🚀 Starting iOS App Structure Reorganization...")
    print("=" * 50)
    
    # Step 1: Create new folder structure
    print("\n📁 Creating new folder structure...")
    create_folder_structure(base_path)
    
    # Step 2: Move files to new locations
    print("\n📦 Moving files to new locations...")
    move_files(base_path)
    
    # Step 3: Clean up unused files
    print("\n🧹 Cleaning up unused files...")
    cleanup_unused_files(base_path)
    
    print("\n✅ Reorganization complete!")
    print("\nNext steps:")
    print("1. Update Xcode project file references")
    print("2. Update import statements in Swift files")
    print("3. Test build to ensure everything works")
    print("4. Update documentation")

if __name__ == "__main__":
    main()
