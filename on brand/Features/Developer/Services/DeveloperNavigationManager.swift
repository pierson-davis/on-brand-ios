//
//  DeveloperNavigationManager.swift
//  on brand
//
//  This service manages navigation between different app screens for developers.
//  It provides a centralized way to navigate to any screen in the app.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

// MARK: - Developer Navigation Manager
// This class manages navigation between different app screens for developers
@MainActor
class DeveloperNavigationManager: ObservableObject {
    
    // MARK: - Published Properties
    /// The currently selected screen
    @Published var currentScreen: DeveloperScreen? = nil
    
    /// Whether the developer dashboard is visible
    @Published var isDashboardVisible = true
    
    /// Navigation stack for managing screen transitions
    @Published var navigationStack: [DeveloperScreen] = []
    
    // MARK: - Singleton
    /// Shared instance of the navigation manager
    static let shared = DeveloperNavigationManager()
    
    // MARK: - Private Initialization
    /// Private initializer to ensure singleton pattern
    private init() {}
    
    // MARK: - Navigation Methods
    
    /// Navigates to a specific screen
    /// - Parameter screen: The screen to navigate to
    func navigateToScreen(_ screen: DeveloperScreen) {
        currentScreen = screen
        isDashboardVisible = false
        
        // Add to navigation stack
        if !navigationStack.contains(screen) {
            navigationStack.append(screen)
        }
    }
    
    /// Returns to the developer dashboard
    func returnToDashboard() {
        currentScreen = nil
        isDashboardVisible = true
        navigationStack.removeAll()
    }
    
    /// Goes back to the previous screen
    func goBack() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
            currentScreen = navigationStack.last
        } else {
            returnToDashboard()
        }
    }
    
    /// Clears the navigation stack
    func clearNavigationStack() {
        navigationStack.removeAll()
        currentScreen = nil
        isDashboardVisible = true
    }
    
    // MARK: - Screen View Factory
    
    /// Creates a view for the specified screen
    /// - Parameter screen: The screen to create a view for
    /// - Returns: A SwiftUI view for the screen
    @ViewBuilder
    func viewForScreen(_ screen: DeveloperScreen) -> some View {
        switch screen {
        // Authentication Screens
        case .login:
            LoginView { _ in }
        case .appleSignIn:
            LoginView { _ in } // Apple Sign-In is part of LoginView
            
        // Onboarding Screens
        case .onboarding:
            OnboardingQuestionScreen(
                model: OnboardingScreen(
                    progressIndex: 0,
                    total: 18,
                    content: .question(
                        QuizQuestion(
                            prompt: "What's your style preference?",
                            answers: [
                                QuizAnswer(text: "Casual", weights: [:]),
                                QuizAnswer(text: "Formal", weights: [:]),
                                QuizAnswer(text: "Trendy", weights: [:]),
                                QuizAnswer(text: "Classic", weights: [:])
                            ]
                        )
                    )
                ),
                question: QuizQuestion(
                    prompt: "What's your style preference?",
                    answers: [
                        QuizAnswer(text: "Casual", weights: [:]),
                        QuizAnswer(text: "Formal", weights: [:]),
                        QuizAnswer(text: "Trendy", weights: [:]),
                        QuizAnswer(text: "Classic", weights: [:])
                    ]
                ),
                onSelect: { _ in },
                selectedIndex: 0
            )
        case .onboardingHero:
            OnboardingHeroScreen(
                model: OnboardingScreen(
                    progressIndex: 0,
                    total: 18,
                    content: .hero(
                        image: "hero_image",
                        title: "Welcome to Era",
                        subtitle: "Discover your unique style",
                        cta: "Get Started"
                    )
                ),
                action: {}
            )
        case .onboardingWelcome:
            OnboardingWelcomeScreen(
                model: OnboardingScreen(
                    progressIndex: 1,
                    total: 18,
                    content: .welcome(name: "Let's Get Started")
                ),
                action: {}
            )
        case .onboardingProblem:
            OnboardingProblemScreen(
                model: OnboardingScreen(
                    progressIndex: 2,
                    total: 18,
                    content: .problemStatement(
                        title: "The Problem",
                        description: "Finding your style is hard",
                        image: "problem_image"
                    )
                ),
                action: {}
            )
        case .onboardingChecklist:
            OnboardingChecklistScreen(
                model: OnboardingScreen(
                    progressIndex: 3,
                    total: 18,
                    content: .benefits(
                        title: "What You'll Get",
                        items: [
                            ChecklistRow(icon: "star.fill", title: "Personalized style recommendations", description: "Get recommendations tailored to your style"),
                            ChecklistRow(icon: "sparkles", title: "AI-powered outfit suggestions", description: "Smart suggestions based on your preferences"),
                            ChecklistRow(icon: "chart.line.uptrend.xyaxis", title: "Trend analysis and insights", description: "Stay ahead of the latest fashion trends"),
                            ChecklistRow(icon: "heart.fill", title: "Style confidence boost", description: "Feel confident in your fashion choices")
                        ]
                    )
                ),
                action: {}
            )
        case .onboardingNameInput:
            NameInputView(
                model: OnboardingScreen(
                    progressIndex: 4,
                    total: 18,
                    content: .nameInput
                ),
                userName: .constant(""),
                onContinue: {}
            )
        case .onboardingGenderSelection:
            GenderSelectionView(
                viewModel: OnboardingViewModel()
            )
        case .onboardingQuestion:
            OnboardingQuestionScreen(
                model: OnboardingScreen(
                    progressIndex: 4,
                    total: 18,
                    content: .question(
                        QuizQuestion(
                            prompt: "What's your style?",
                            answers: [
                                QuizAnswer(text: "Minimalist", weights: [.minimalistMaven: 1]),
                                QuizAnswer(text: "Bold", weights: [.boldRebel: 1]),
                                QuizAnswer(text: "Classic", weights: [.ruggedGentleman: 1]),
                                QuizAnswer(text: "Trendy", weights: [.socialMagnet: 1])
                            ]
                        )
                    )
                ),
                question: QuizQuestion(
                    prompt: "What's your style?",
                    answers: [
                        QuizAnswer(text: "Minimalist", weights: [.minimalistMaven: 1]),
                        QuizAnswer(text: "Bold", weights: [.boldRebel: 1]),
                        QuizAnswer(text: "Classic", weights: [.ruggedGentleman: 1]),
                        QuizAnswer(text: "Trendy", weights: [.socialMagnet: 1])
                    ]
                ),
                onSelect: { _ in },
                selectedIndex: 0
            )
        case .onboardingPlan:
            OnboardingPlanScreen(
                model: OnboardingScreen(
                    progressIndex: 5,
                    total: 18,
                    content: .customPlan(
                        name: "Choose Your Plan",
                        planDetails: "Select the plan that works for you"
                    )
                ),
                onContinue: {}
            )
        case .onboardingProgressTracking:
            OnboardingProgressTrackingScreen(
                model: OnboardingScreen(
                    progressIndex: 6,
                    total: 18,
                    content: .progressTracking(
                        title: "Track Your Progress",
                        description: "Monitor your style journey"
                    )
                ),
                action: {}
            )
        case .onboardingProgressGraph:
            OnboardingProgressGraphScreen(
                model: OnboardingScreen(
                    progressIndex: 7,
                    total: 18,
                    content: .progressGraph(
                        title: "Your Style Journey",
                        weeks: 12
                    )
                ),
                action: {}
            )
        case .onboardingPermission:
            OnboardingPermissionScreen(
                model: OnboardingScreen(
                    progressIndex: 8,
                    total: 18,
                    content: .permissionRequest(
                        title: "Permissions",
                        description: "We need access to help you",
                        permission: .photoAccess
                    )
                ),
                action: {}
            )
        case .onboardingSummary:
            OnboardingSummaryScreen(
                model: OnboardingScreen(
                    progressIndex: 9,
                    total: 18,
                    content: .summary(
                        title: "You're All Set!",
                        body: "Ready to discover your style?",
                        accent: .blue,
                        cta: "Start My Journey"
                    )
                ),
                action: {}
            )
            
        // Main App Screens
        case .home:
            HomeView(onLogout: {})
        case .profile:
            ProfileView(
                userArchetype: .mainCharacter,
                onDismiss: nil,
                onLogout: nil
            )
        case .instagramProfile:
            InstagramProfileView(
                userArchetype: .socialMagnet,
                onDismiss: {},
                onLogout: nil
            )
        case .photoAnalysis:
            PhotoAnalyzerView(
                result: VibeResult(
                    primary: .minimalistMaven,
                    secondary: nil,
                    description: "Clean, minimalist style with modern touches"
                ),
                onLogout: nil
            )
        case .photoAnalyzer:
            PhotoAnalyzerView(
                result: VibeResult(
                    primary: .minimalistMaven,
                    secondary: nil,
                    description: "Clean, minimalist style with modern touches"
                ),
                onLogout: nil
            )
        case .settings:
            SettingsView()
            
        // System Screens
        case .loading:
            LoadingView(onLoadingComplete: {})
        case .error:
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.octagon.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Error")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Something went wrong")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Button("Try Again") {
                    // Retry action
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding()
        }
    }
}

