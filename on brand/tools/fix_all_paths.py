#!/usr/bin/env python3
"""
Fix All Xcode Project File Paths
Updates all file references to remove the redundant era/ folder prefix
"""

import re
from pathlib import Path

def fix_all_paths():
    """Update all file references to remove era/ prefix"""
    
    project_file = Path("/Users/piersondavis/Documents/era/era.xcodeproj/project.pbxproj")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    updated_content = content
    changes_made = 0
    
    # Define all the path mappings we need to fix
    path_mappings = {
        # App files
        'era/App/eraApp.swift': 'App/eraApp.swift',
        'era/App/Info.plist': 'App/Info.plist',
        'era/App/era.entitlements': 'App/era.entitlements',
        'era/App/Secrets.xcconfig': 'App/Secrets.xcconfig',
        
        # Core files
        'era/Core/DesignSystem/EraDesignSystem.swift': 'Core/DesignSystem/EraDesignSystem.swift',
        'era/Core/DesignSystem/ThemeManager.swift': 'Core/DesignSystem/ThemeManager.swift',
        
        # Features files
        'era/Features/Authentication/Services/AuthenticationService.swift': 'Features/Authentication/Services/AuthenticationService.swift',
        'era/Features/Authentication/Views/AppleSignInButton.swift': 'Features/Authentication/Views/AppleSignInButton.swift',
        'era/Features/Authentication/Views/LoginLoadingOverlay.swift': 'Features/Authentication/Views/LoginLoadingOverlay.swift',
        'era/Features/Authentication/Views/LoginView.swift': 'Features/Authentication/Views/LoginView.swift',
        
        'era/Features/Home/Components/QuickActionsSection.swift': 'Features/Home/Components/QuickActionsSection.swift',
        'era/Features/Home/Components/RecentPhotosSection.swift': 'Features/Home/Components/RecentPhotosSection.swift',
        'era/Features/Home/Components/WelcomeSection.swift': 'Features/Home/Components/WelcomeSection.swift',
        'era/Features/Home/Views/HomeView.swift': 'Features/Home/Views/HomeView.swift',
        
        'era/Features/Onboarding/Components/GenderSelectionView.swift': 'Features/Onboarding/Components/GenderSelectionView.swift',
        'era/Features/Onboarding/Components/NameInputView.swift': 'Features/Onboarding/Components/NameInputView.swift',
        'era/Features/Onboarding/Components/OnboardingChecklistScreen.swift': 'Features/Onboarding/Components/OnboardingChecklistScreen.swift',
        'era/Features/Onboarding/Components/OnboardingHeroScreen.swift': 'Features/Onboarding/Components/OnboardingHeroScreen.swift',
        'era/Features/Onboarding/Components/OnboardingPermissionScreen.swift': 'Features/Onboarding/Components/OnboardingPermissionScreen.swift',
        'era/Features/Onboarding/Components/OnboardingPlanScreen.swift': 'Features/Onboarding/Components/OnboardingPlanScreen.swift',
        'era/Features/Onboarding/Components/OnboardingProblemScreen.swift': 'Features/Onboarding/Components/OnboardingProblemScreen.swift',
        'era/Features/Onboarding/Components/OnboardingProgressGraphScreen.swift': 'Features/Onboarding/Components/OnboardingProgressGraphScreen.swift',
        'era/Features/Onboarding/Components/OnboardingProgressHeader.swift': 'Features/Onboarding/Components/OnboardingProgressHeader.swift',
        'era/Features/Onboarding/Components/OnboardingProgressTrackingScreen.swift': 'Features/Onboarding/Components/OnboardingProgressTrackingScreen.swift',
        'era/Features/Onboarding/Components/OnboardingQuestionScreen.swift': 'Features/Onboarding/Components/OnboardingQuestionScreen.swift',
        'era/Features/Onboarding/Components/OnboardingSummaryScreen.swift': 'Features/Onboarding/Components/OnboardingSummaryScreen.swift',
        'era/Features/Onboarding/Components/OnboardingWelcomeScreen.swift': 'Features/Onboarding/Components/OnboardingWelcomeScreen.swift',
        'era/Features/Onboarding/Models/OnboardingQuestions.swift': 'Features/Onboarding/Models/OnboardingQuestions.swift',
        'era/Features/Onboarding/Models/OnboardingScreenModel.swift': 'Features/Onboarding/Models/OnboardingScreenModel.swift',
        'era/Features/Onboarding/Models/QuizModels.swift': 'Features/Onboarding/Models/QuizModels.swift',
        'era/Features/Onboarding/ViewModels/OnboardingViewModel.swift': 'Features/Onboarding/ViewModels/OnboardingViewModel.swift',
        'era/Features/Onboarding/Views/OnboardingQuestionView.swift': 'Features/Onboarding/Views/OnboardingQuestionView.swift',
        
        'era/Features/PhotoAnalysis/Services/AIService.swift': 'Features/PhotoAnalysis/Services/AIService.swift',
        'era/Features/PhotoAnalysis/Services/VibeAnalyzer.swift': 'Features/PhotoAnalysis/Services/VibeAnalyzer.swift',
        'era/Features/PhotoAnalysis/ViewModels/AnalyzeViewModel.swift': 'Features/PhotoAnalysis/ViewModels/AnalyzeViewModel.swift',
        'era/Features/PhotoAnalysis/Views/AICurationSection.swift': 'Features/PhotoAnalysis/Views/AICurationSection.swift',
        'era/Features/PhotoAnalysis/Views/PhotoAnalyzerView.swift': 'Features/PhotoAnalysis/Views/PhotoAnalyzerView.swift',
        'era/Features/PhotoAnalysis/Views/PhotoPickerSection.swift': 'Features/PhotoAnalysis/Views/PhotoPickerSection.swift',
        
        'era/Features/Profile/Components/ActionButtonsSection.swift': 'Features/Profile/Components/ActionButtonsSection.swift',
        'era/Features/Profile/Components/AnalysisCard.swift': 'Features/Profile/Components/AnalysisCard.swift',
        'era/Features/Profile/Components/BioSection.swift': 'Features/Profile/Components/BioSection.swift',
        'era/Features/Profile/Components/ContentTabsSection.swift': 'Features/Profile/Components/ContentTabsSection.swift',
        'era/Features/Profile/Components/InstagramActionButtons.swift': 'Features/Profile/Components/InstagramActionButtons.swift',
        'era/Features/Profile/Components/InstagramContentTabs.swift': 'Features/Profile/Components/InstagramContentTabs.swift',
        'era/Features/Profile/Components/InstagramPhotoGrid.swift': 'Features/Profile/Components/InstagramPhotoGrid.swift',
        'era/Features/Profile/Components/InstagramProfileHeader.swift': 'Features/Profile/Components/InstagramProfileHeader.swift',
        'era/Features/Profile/Components/InstagramTopBar.swift': 'Features/Profile/Components/InstagramTopBar.swift',
        'era/Features/Profile/Components/PhotoGridSection.swift': 'Features/Profile/Components/PhotoGridSection.swift',
        'era/Features/Profile/Components/ProfileHeaderSection.swift': 'Features/Profile/Components/ProfileHeaderSection.swift',
        'era/Features/Profile/Views/InstagramProfileView.swift': 'Features/Profile/Views/InstagramProfileView.swift',
        'era/Features/Profile/Views/ProfileView.swift': 'Features/Profile/Views/ProfileView.swift',
        
        'era/Features/Settings/Views/SettingsView.swift': 'Features/Settings/Views/SettingsView.swift',
        
        # Shared files
        'era/Shared/Models/AIPromptModels.swift': 'Shared/Models/AIPromptModels.swift',
        'era/Shared/Models/Archetype.swift': 'Shared/Models/Archetype.swift',
        'era/Shared/Models/UserProfile.swift': 'Shared/Models/UserProfile.swift',
        'era/Shared/Models/VibeResult.swift': 'Shared/Models/VibeResult.swift',
        'era/Shared/Services/UserProfileService.swift': 'Shared/Services/UserProfileService.swift',
        'era/Shared/Views/ContentView.swift': 'Shared/Views/ContentView.swift',
        'era/Shared/Views/LoadingView.swift': 'Shared/Views/LoadingView.swift',
        
        # Resources
        'era/Resources/Assets.xcassets': 'Resources/Assets.xcassets',
        'era/Resources/Preview Assets.xcassets': 'Resources/Preview Assets.xcassets',
        
        # Documentation
        'era/Documentation/ProjectStructure.md': 'Documentation/ProjectStructure.md',
        'era/Documentation/era_code_notes.txt': 'Documentation/era_code_notes.txt',
        
        # Tests
        'era/Tests/UnitTests/eraTests.swift': 'Tests/UnitTests/eraTests.swift',
        'era/Tests/UITests/eraUITests.swift': 'Tests/UITests/eraUITests.swift',
        'era/Tests/UITests/eraUITestsLaunchTests.swift': 'Tests/UITests/eraUITestsLaunchTests.swift',
    }
    
    # Apply all the path mappings
    for old_path, new_path in path_mappings.items():
        if old_path in updated_content:
            updated_content = updated_content.replace(old_path, new_path)
            changes_made += 1
            print(f"✅ Updated path: {old_path} -> {new_path}")
    
    # Write the updated content back to the file
    if changes_made > 0:
        with open(project_file, 'w') as f:
            f.write(updated_content)
        print(f"\n✅ Successfully updated {changes_made} file references!")
    else:
        print("\n⚠️ No file references were found to update.")
    
    return changes_made

if __name__ == "__main__":
    print("🔧 Fixing all Xcode project file paths...")
    print("=" * 60)
    
    changes = fix_all_paths()
    
    if changes > 0:
        print(f"\n🎉 Fixed {changes} file references!")
        print("\nNext steps:")
        print("1. Try building the project again")
        print("2. Check for any remaining issues")
    else:
        print("\n✅ No issues found!")
