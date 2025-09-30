#!/usr/bin/env python3
"""
Comprehensive Xcode Project File Reference Fixer
Finds and updates ALL file references in the Xcode project file to match the new folder structure
"""

import re
from pathlib import Path

def fix_all_xcode_references():
    """Update all file references in the Xcode project file"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Define comprehensive path mappings
    path_mappings = {
        # App level files
        'eraApp.swift': 'App/eraApp.swift',
        'Info.plist': 'App/Info.plist',
        'era.entitlements': 'App/era.entitlements',
        'Secrets.xcconfig': 'App/Secrets.xcconfig',
        
        # Core files
        'DesignSystem/EraDesignSystem.swift': 'Core/DesignSystem/EraDesignSystem.swift',
        'DesignSystem/ThemeManager.swift': 'Core/DesignSystem/ThemeManager.swift',
        
        # Authentication files
        'Views/Components/Login/LoginView.swift': 'Features/Authentication/Views/LoginView.swift',
        'Views/Components/Login/AppleSignInButton.swift': 'Features/Authentication/Views/AppleSignInButton.swift',
        'Views/Components/Login/LoginLoadingOverlay.swift': 'Features/Authentication/Views/LoginLoadingOverlay.swift',
        'Services/AuthenticationService.swift': 'Features/Authentication/Services/AuthenticationService.swift',
        
        # Onboarding files
        'Views/OnboardingQuestionView.swift': 'Features/Onboarding/Views/OnboardingQuestionView.swift',
        'ViewModels/OnboardingViewModel.swift': 'Features/Onboarding/ViewModels/OnboardingViewModel.swift',
        'Flows/Onboarding/OnboardingScreenModel.swift': 'Features/Onboarding/Models/OnboardingScreenModel.swift',
        'Models/OnboardingQuestions.swift': 'Features/Onboarding/Models/OnboardingQuestions.swift',
        'Models/QuizModels.swift': 'Features/Onboarding/Models/QuizModels.swift',
        
        # Onboarding Components
        'Flows/Onboarding/components/GenderSelectionView.swift': 'Features/Onboarding/Components/GenderSelectionView.swift',
        'Flows/Onboarding/components/NameInputView.swift': 'Features/Onboarding/Components/NameInputView.swift',
        'Flows/Onboarding/components/OnboardingChecklistScreen.swift': 'Features/Onboarding/Components/OnboardingChecklistScreen.swift',
        'Flows/Onboarding/components/OnboardingHeroScreen.swift': 'Features/Onboarding/Components/OnboardingHeroScreen.swift',
        'Flows/Onboarding/components/OnboardingPermissionScreen.swift': 'Features/Onboarding/Components/OnboardingPermissionScreen.swift',
        'Flows/Onboarding/components/OnboardingPlanScreen.swift': 'Features/Onboarding/Components/OnboardingPlanScreen.swift',
        'Flows/Onboarding/components/OnboardingProblemScreen.swift': 'Features/Onboarding/Components/OnboardingProblemScreen.swift',
        'Flows/Onboarding/components/OnboardingProgressGraphScreen.swift': 'Features/Onboarding/Components/OnboardingProgressGraphScreen.swift',
        'Flows/Onboarding/components/OnboardingProgressHeader.swift': 'Features/Onboarding/Components/OnboardingProgressHeader.swift',
        'Flows/Onboarding/components/OnboardingProgressTrackingScreen.swift': 'Features/Onboarding/Components/OnboardingProgressTrackingScreen.swift',
        'Flows/Onboarding/components/OnboardingQuestionScreen.swift': 'Features/Onboarding/Components/OnboardingQuestionScreen.swift',
        'Flows/Onboarding/components/OnboardingSummaryScreen.swift': 'Features/Onboarding/Components/OnboardingSummaryScreen.swift',
        'Flows/Onboarding/components/OnboardingWelcomeScreen.swift': 'Features/Onboarding/Components/OnboardingWelcomeScreen.swift',
        
        # Home files
        'Views/HomeView.swift': 'Features/Home/Views/HomeView.swift',
        'Views/Components/Home/QuickActionsSection.swift': 'Features/Home/Components/QuickActionsSection.swift',
        'Views/Components/Home/RecentPhotosSection.swift': 'Features/Home/Components/RecentPhotosSection.swift',
        'Views/Components/Home/WelcomeSection.swift': 'Features/Home/Components/WelcomeSection.swift',
        
        # Profile files
        'Views/ProfileView.swift': 'Features/Profile/Views/ProfileView.swift',
        'Views/InstagramProfileView.swift': 'Features/Profile/Views/InstagramProfileView.swift',
        'Views/Components/Profile/ActionButtonsSection.swift': 'Features/Profile/Components/ActionButtonsSection.swift',
        'Views/Components/Profile/AnalysisCard.swift': 'Features/Profile/Components/AnalysisCard.swift',
        'Views/Components/Profile/BioSection.swift': 'Features/Profile/Components/BioSection.swift',
        'Views/Components/Profile/ContentTabsSection.swift': 'Features/Profile/Components/ContentTabsSection.swift',
        'Views/Components/Profile/PhotoGridSection.swift': 'Features/Profile/Components/PhotoGridSection.swift',
        'Views/Components/Profile/ProfileHeaderSection.swift': 'Features/Profile/Components/ProfileHeaderSection.swift',
        'Views/Components/InstagramProfile/InstagramActionButtons.swift': 'Features/Profile/Components/InstagramActionButtons.swift',
        'Views/Components/InstagramProfile/InstagramContentTabs.swift': 'Features/Profile/Components/InstagramContentTabs.swift',
        'Views/Components/InstagramProfile/InstagramPhotoGrid.swift': 'Features/Profile/Components/InstagramPhotoGrid.swift',
        'Views/Components/InstagramProfile/InstagramProfileHeader.swift': 'Features/Profile/Components/InstagramProfileHeader.swift',
        'Views/Components/InstagramProfile/InstagramTopBar.swift': 'Features/Profile/Components/InstagramTopBar.swift',
        
        # Photo Analysis files
        'Views/PhotoAnalyzerView.swift': 'Features/PhotoAnalysis/Views/PhotoAnalyzerView.swift',
        'ViewModels/AnalyzeViewModel.swift': 'Features/PhotoAnalysis/ViewModels/AnalyzeViewModel.swift',
        'Services/AIService.swift': 'Features/PhotoAnalysis/Services/AIService.swift',
        'Services/VibeAnalyzer.swift': 'Features/PhotoAnalysis/Services/VibeAnalyzer.swift',
        'Views/Components/PhotoAnalyzer/AICurationSection.swift': 'Features/PhotoAnalysis/Views/AICurationSection.swift',
        'Views/Components/PhotoAnalyzer/PhotoPickerSection.swift': 'Features/PhotoAnalysis/Views/PhotoPickerSection.swift',
        
        # Settings files
        'Views/SettingsView.swift': 'Features/Settings/Views/SettingsView.swift',
        
        # Shared files
        'Models/Archetype.swift': 'Shared/Models/Archetype.swift',
        'Models/UserProfile.swift': 'Shared/Models/UserProfile.swift',
        'Models/VibeResult.swift': 'Shared/Models/VibeResult.swift',
        'Models/AIPromptModels.swift': 'Shared/Models/AIPromptModels.swift',
        'Services/UserProfileService.swift': 'Shared/Services/UserProfileService.swift',
        'Views/ContentView.swift': 'Shared/Views/ContentView.swift',
        'Views/LoadingView.swift': 'Shared/Views/LoadingView.swift',
        
        # Test files
        'eraTests/eraTests.swift': 'Tests/UnitTests/eraTests.swift',
        'eraUITests/eraUITests.swift': 'Tests/UITests/eraUITests.swift',
        'eraUITests/eraUITestsLaunchTests.swift': 'Tests/UITests/eraUITestsLaunchTests.swift'
    }
    
    # Apply the mappings with multiple patterns
    updated_content = content
    changes_made = 0
    
    for old_path, new_path in path_mappings.items():
        # Pattern 1: path = old_path;
        old_pattern1 = f'path = {old_path};'
        new_pattern1 = f'path = {new_path};'
        
        if old_pattern1 in updated_content:
            updated_content = updated_content.replace(old_pattern1, new_pattern1)
            changes_made += 1
            print(f"Updated: {old_path} → {new_path}")
        
        # Pattern 2: path = "old_path";
        old_pattern2 = f'path = "{old_path}";'
        new_pattern2 = f'path = "{new_path}";'
        
        if old_pattern2 in updated_content:
            updated_content = updated_content.replace(old_pattern2, new_pattern2)
            changes_made += 1
            print(f"Updated: \"{old_path}\" → \"{new_path}\"")
        
        # Pattern 3: path = era/old_path;
        old_pattern3 = f'path = era/{old_path};'
        new_pattern3 = f'path = era/{new_path};'
        
        if old_pattern3 in updated_content:
            updated_content = updated_content.replace(old_pattern3, new_pattern3)
            changes_made += 1
            print(f"Updated: era/{old_path} → era/{new_path}")
        
        # Pattern 4: path = "era/old_path";
        old_pattern4 = f'path = "era/{old_path}";'
        new_pattern4 = f'path = "era/{new_path}";'
        
        if old_pattern4 in updated_content:
            updated_content = updated_content.replace(old_pattern4, new_pattern4)
            changes_made += 1
            print(f"Updated: \"era/{old_path}\" → \"era/{new_path}\"")
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully updated {changes_made} file references in Xcode project file!")
    else:
        print("⚠️ No file references were updated. The project file might already be correct.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Comprehensive Xcode project file reference fixer...")
    print("=" * 60)
    
    changes = fix_all_xcode_references()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} file references!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. If there are still issues, check for any remaining old path references")
    else:
        print("\n⚠️ No changes were made. The project file might already be correct.")
