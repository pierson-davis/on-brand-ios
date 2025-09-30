# Era iOS App - Project Structure Documentation

## Overview
This document describes the reorganized project structure of the Era iOS app, following iOS development best practices for maintainability and non-technical auditing.

## Project Structure

```
era/
├── App/                          # App-level configuration files
│   ├── eraApp.swift             # Main app entry point
│   ├── Info.plist               # App configuration and permissions
│   ├── era.entitlements         # App capabilities and permissions
│   └── Secrets.xcconfig         # API keys and sensitive configuration
├── Core/                         # Core app functionality
│   ├── DesignSystem/            # UI design system and theming
│   │   ├── EraDesignSystem.swift # Colors, typography, components
│   │   └── ThemeManager.swift   # Theme management and switching
│   ├── Extensions/              # Swift extensions (currently empty)
│   ├── Utilities/               # Utility functions (currently empty)
│   └── Constants/               # App constants (currently empty)
├── Features/                     # Feature-based organization
│   ├── Authentication/          # User authentication feature
│   │   ├── Views/              # Authentication UI components
│   │   │   ├── LoginView.swift
│   │   │   ├── AppleSignInButton.swift
│   │   │   └── LoginLoadingOverlay.swift
│   │   ├── ViewModels/         # Authentication business logic (empty)
│   │   └── Services/           # Authentication services
│   │       └── AuthenticationService.swift
│   ├── Onboarding/             # User onboarding flow
│   │   ├── Views/              # Main onboarding views
│   │   │   └── OnboardingQuestionView.swift
│   │   ├── ViewModels/         # Onboarding business logic
│   │   │   └── OnboardingViewModel.swift
│   │   ├── Models/             # Onboarding data models
│   │   │   ├── OnboardingQuestions.swift
│   │   │   ├── OnboardingScreenModel.swift
│   │   │   └── QuizModels.swift
│   │   └── Components/         # Reusable onboarding components
│   │       ├── GenderSelectionView.swift
│   │       ├── NameInputView.swift
│   │       ├── OnboardingChecklistScreen.swift
│   │       ├── OnboardingHeroScreen.swift
│   │       ├── OnboardingPermissionScreen.swift
│   │       ├── OnboardingPlanScreen.swift
│   │       ├── OnboardingProblemScreen.swift
│   │       ├── OnboardingProgressGraphScreen.swift
│   │       ├── OnboardingProgressHeader.swift
│   │       ├── OnboardingProgressTrackingScreen.swift
│   │       ├── OnboardingQuestionScreen.swift
│   │       ├── OnboardingSummaryScreen.swift
│   │       └── OnboardingWelcomeScreen.swift
│   ├── Home/                   # Home screen feature
│   │   ├── Views/              # Home screen views
│   │   │   └── HomeView.swift
│   │   └── Components/         # Home screen components
│   │       ├── QuickActionsSection.swift
│   │       ├── RecentPhotosSection.swift
│   │       └── WelcomeSection.swift
│   ├── Profile/                # User profile feature
│   │   ├── Views/              # Profile views
│   │   │   ├── ProfileView.swift
│   │   │   └── InstagramProfileView.swift
│   │   └── Components/         # Profile components
│   │       ├── ActionButtonsSection.swift
│   │       ├── AnalysisCard.swift
│   │       ├── BioSection.swift
│   │       ├── ContentTabsSection.swift
│   │       ├── InstagramActionButtons.swift
│   │       ├── InstagramContentTabs.swift
│   │       ├── InstagramPhotoGrid.swift
│   │       ├── InstagramProfileHeader.swift
│   │       ├── InstagramTopBar.swift
│   │       ├── PhotoGridSection.swift
│   │       └── ProfileHeaderSection.swift
│   ├── PhotoAnalysis/          # AI photo analysis feature
│   │   ├── Views/              # Photo analysis views
│   │   │   ├── PhotoAnalyzerView.swift
│   │   │   ├── AICurationSection.swift
│   │   │   └── PhotoPickerSection.swift
│   │   ├── ViewModels/         # Photo analysis business logic
│   │   │   └── AnalyzeViewModel.swift
│   │   └── Services/           # Photo analysis services
│   │       ├── AIService.swift
│   │       └── VibeAnalyzer.swift
│   └── Settings/               # App settings feature
│       └── Views/              # Settings views
│           └── SettingsView.swift
├── Shared/                      # Shared components across features
│   ├── Models/                 # Shared data models
│   │   ├── AIPromptModels.swift
│   │   ├── Archetype.swift
│   │   ├── UserProfile.swift
│   │   └── VibeResult.swift
│   ├── Services/               # Shared services
│   │   └── UserProfileService.swift
│   ├── ViewModels/             # Shared view models (empty)
│   └── Views/                  # Shared views
│       ├── ContentView.swift   # Main app coordinator
│       └── LoadingView.swift   # Loading screen
├── Resources/                   # App resources and assets
│   ├── Assets.xcassets/        # App icons, colors, images
│   ├── Fonts/                  # Custom fonts (empty)
│   └── Preview Assets.xcassets/ # Preview assets for SwiftUI
├── Tests/                       # All test files
│   ├── UnitTests/              # Unit tests
│   │   └── eraTests.swift
│   └── UITests/                # UI tests
│       ├── eraUITests.swift
│       └── eraUITestsLaunchTests.swift
└── Documentation/               # Project documentation
    ├── era_code_notes.txt      # Original code notes
    └── ProjectStructure.md     # This file
```

## Organization Principles

### 1. Feature-Based Organization
- Each major feature has its own folder under `Features/`
- Each feature contains its own `Views/`, `ViewModels/`, `Models/`, `Services/`, and `Components/`
- This makes it easy to find all code related to a specific feature

### 2. Separation of Concerns
- **Views**: UI components and SwiftUI views
- **ViewModels**: Business logic and state management
- **Models**: Data structures and entities
- **Services**: External API calls and data persistence
- **Components**: Reusable UI components

### 3. Shared vs Feature-Specific
- **Shared/**: Code used across multiple features
- **Features/**: Code specific to one feature
- **Core/**: App-wide utilities and design system

### 4. Clear Naming Conventions
- Folders use PascalCase (e.g., `PhotoAnalysis`)
- Files use PascalCase with descriptive names
- Components are clearly named (e.g., `OnboardingHeroScreen`)

## Benefits for Non-Technical Auditing

### 1. Easy Navigation
- Clear folder structure makes it easy to find specific functionality
- Feature-based organization means you can focus on one area at a time

### 2. Clear Responsibilities
- Each folder has a clear purpose
- Easy to understand what code belongs where

### 3. Scalability
- Easy to add new features without cluttering existing code
- Clear patterns for where new code should go

### 4. Maintenance
- Easy to identify which files need updates when making changes
- Clear separation makes it easier to test individual components

## File Count Summary
- **Total Swift Files**: 50+
- **Features**: 6 (Authentication, Onboarding, Home, Profile, PhotoAnalysis, Settings)
- **Shared Components**: 6 files
- **Test Files**: 3 files
- **Documentation**: 2 files

## Next Steps for Development
1. Update Xcode project file references to match new structure
2. Update import statements in Swift files
3. Test build to ensure everything works correctly
4. Add new features following the established patterns
5. Consider adding more shared utilities in `Core/Utilities/`
6. Add more comprehensive tests in the `Tests/` folders

## Migration Notes
- All files have been moved from the old structure to the new structure
- Old folders (`Flows/`, `Models/`, `Services/`, `ViewModels/`, `Views/`) have been removed
- Test files have been moved to the new `Tests/` structure
- Documentation has been moved to the `Documentation/` folder
- Unused files have been cleaned up
