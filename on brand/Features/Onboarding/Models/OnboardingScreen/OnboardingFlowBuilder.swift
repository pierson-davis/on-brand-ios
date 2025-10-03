//
//  OnboardingFlowBuilder.swift
//  on brand
//
//  This file contains the onboarding flow builder that creates
//  the complete onboarding experience with all screens and logic.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import Foundation
import SwiftUI

// MARK: - Screen Type Enumeration (Temporary)
// This is a temporary definition until OnboardingSharedModels.swift is added to the project
enum ScreenType: String, CaseIterable {
    case introduction = "introduction"
    case userInput = "user_input"
    case planning = "planning"
    case permission = "permission"
    case completion = "completion"
    
    /// The display name for the screen type
    var displayName: String {
        switch self {
        case .introduction:
            return "Introduction"
        case .userInput:
            return "User Input"
        case .planning:
            return "Planning"
        case .permission:
            return "Permission"
        case .completion:
            return "Completion"
        }
    }
}

// MARK: - Onboarding Flow Builder
// This class builds the complete onboarding flow with all screens
struct OnboardingFlowBuilder {
    
    // MARK: - Flow Configuration
    /// The total number of steps in the onboarding flow
    static let totalSteps = 18
    
    // MARK: - Main Flow Builder
    /// Creates the complete onboarding flow
    /// - Parameters:
    ///   - questions: The quiz questions to include
    ///   - needsNameInput: Whether to include the name input screen
    ///   - userName: The user's name (if already known)
    /// - Returns: An array of onboarding screens
    static func makeScreens(
        from questions: [QuizQuestion],
        needsNameInput: Bool = true,
        userName: String = ""
    ) -> [OnboardingScreen] {
        
        var screens = [OnboardingScreen]()
        screens.reserveCapacity(totalSteps)
        
        // Build the flow step by step
        screens.append(contentsOf: buildIntroductionScreens(needsNameInput: needsNameInput, userName: userName))
        screens.append(contentsOf: buildUserInputScreens(needsNameInput: needsNameInput, questions: questions))
        screens.append(contentsOf: buildPlanningScreens(needsNameInput: needsNameInput, userName: userName))
        screens.append(contentsOf: buildPermissionScreens())
        screens.append(contentsOf: buildCompletionScreens(userName: userName))
        
        return screens
    }
    
    // MARK: - Introduction Screens
    /// Builds the introduction screens (hero, welcome, problem, benefits)
    private static func buildIntroductionScreens(needsNameInput: Bool, userName: String) -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        
        // 1. Hero Screen
        screens.append(
            OnboardingScreen(
                progressIndex: 1,
                total: totalSteps,
                content: .hero(
                    image: "photo.artframe",
                    title: "Meet Era",
                    subtitle: "Your AI stylist for feed-worthy vibes.",
                    cta: "Start your style journey"
                )
            )
        )
        
        // 2. Welcome Screen (if we have name)
        if !userName.isEmpty {
            screens.append(
                OnboardingScreen(
                    progressIndex: 2,
                    total: totalSteps,
                    content: .welcome(name: userName)
                )
            )
        }
        
        // 3. Problem Statement
        screens.append(
            OnboardingScreen(
                progressIndex: needsNameInput ? 3 : 3,
                total: totalSteps,
                content: .problemStatement(
                    title: "Your style deserves better",
                    description: "Stop posting mediocre photos. Era helps you discover your authentic vibe and create content that actually gets noticed.",
                    image: "camera.badge.ellipsis"
                )
            )
        )
        
        // 4. Benefits Overview
        screens.append(
            OnboardingScreen(
                progressIndex: needsNameInput ? 4 : 4,
                total: totalSteps,
                content: .benefits(
                    title: "What Era unlocks for you",
                    items: [
                        ChecklistRow(
                            icon: "sparkles",
                            title: "Personalized vibe analysis",
                            description: "AI discovers your unique style archetype"
                        ),
                        ChecklistRow(
                            icon: "camera",
                            title: "Smart photo curation",
                            description: "Automatically selects your best shots"
                        ),
                        ChecklistRow(
                            icon: "paintpalette",
                            title: "Cohesive aesthetic system",
                            description: "Color palettes and themes that work"
                        ),
                        ChecklistRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Style evolution tracking",
                            description: "See how your aesthetic develops over time"
                        )
                    ]
                )
            )
        )
        
        return screens
    }
    
    // MARK: - User Input Screens
    /// Builds the user input screens (name, gender, quiz)
    private static func buildUserInputScreens(needsNameInput: Bool, questions: [QuizQuestion]) -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        
        // 5. Name Input (conditional)
        if needsNameInput {
            screens.append(
                OnboardingScreen(
                    progressIndex: 5,
                    total: totalSteps,
                    content: .nameInput
                )
            )
        }
        
        // 6. Gender Selection
        let genderIndex = needsNameInput ? 6 : 5
        screens.append(
            OnboardingScreen(
                progressIndex: genderIndex,
                total: totalSteps,
                content: .genderSelection
            )
        )
        
        // 7-10. Quiz Questions
        let questionStartIndex = needsNameInput ? 7 : 6
        for (idx, question) in questions.enumerated() {
            screens.append(
                OnboardingScreen(
                    progressIndex: idx + questionStartIndex,
                    total: totalSteps,
                    content: .question(question)
                )
            )
        }
        
        return screens
    }
    
    // MARK: - Planning Screens
    /// Builds the planning screens (plan, tracking, habits, etc.)
    private static func buildPlanningScreens(needsNameInput: Bool, userName: String) -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        
        let planIndex = needsNameInput ? 11 : 10
        
        // 11. Personalized Plan Creation
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex,
                total: totalSteps,
                content: .personalizedPlan(
                    name: userName.isEmpty ? "there" : userName,
                    daysCount: 0
                )
            )
        )
        
        // 12. Progress Tracking Explanation
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 1,
                total: totalSteps,
                content: .progressTracking(
                    title: "Track your style evolution",
                    description: "Era monitors your aesthetic growth and helps you maintain consistency across all your content."
                )
            )
        )
        
        // 13. Habit Tracking
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 2,
                total: totalSteps,
                content: .habitTracking(
                    title: "Build better style habits",
                    description: "Daily check-ins help you stay consistent with your aesthetic goals and identify what's working."
                )
            )
        )
        
        // 14. Daily Check-in
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 3,
                total: totalSteps,
                content: .dailyCheckin(
                    title: "Stay motivated",
                    description: "Your daily style check-in keeps you on track towards your aesthetic goals and helps you refine your personal brand."
                )
            )
        )
        
        // 15. Custom Plan Details
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 4,
                total: totalSteps,
                content: .customPlan(
                    name: userName.isEmpty ? "there" : userName,
                    planDetails: "Based on your answers, we've created a personalized style roadmap that evolves with your aesthetic journey."
                )
            )
        )
        
        // 16. Progress Graph
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 5,
                total: totalSteps,
                content: .progressGraph(
                    title: "Style Evolution",
                    weeks: 4
                )
            )
        )
        
        return screens
    }
    
    // MARK: - Permission Screens
    /// Builds the permission request screens
    private static func buildPermissionScreens() -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        
        // 17. Permission Requests
        screens.append(
            OnboardingScreen(
                progressIndex: totalSteps - 1,
                total: totalSteps,
                content: .permissionRequest(
                    title: "Allow Era to access your photos?",
                    description: "Era needs access to analyze your photos and create personalized style recommendations.",
                    permission: .photoAccess
                )
            )
        )
        
        return screens
    }
    
    // MARK: - Completion Screens
    /// Builds the completion screens (summary, ready to start)
    private static func buildCompletionScreens(userName: String) -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        
        // 18. Ready to Start
        screens.append(
            OnboardingScreen(
                progressIndex: totalSteps,
                total: totalSteps,
                content: .readyToStart(
                    name: userName.isEmpty ? "there" : userName,
                    cta: "Start my style journey"
                )
            )
        )
        
        return screens
    }
}

// MARK: - Flow Builder Extensions
// These extensions provide additional functionality for the flow builder

extension OnboardingFlowBuilder {
    
    /// Creates a simplified flow for returning users
    /// - Parameter userName: The user's name
    /// - Returns: An array of onboarding screens for returning users
    static func makeReturningUserFlow(userName: String) -> [OnboardingScreen] {
        return [
            OnboardingScreen(
                progressIndex: 1,
                total: 3,
                content: .welcome(name: userName)
            ),
            OnboardingScreen(
                progressIndex: 2,
                total: 3,
                content: .summary(
                    title: "Welcome back!",
                    body: "Your style journey continues. Let's see what's new.",
                    accent: .blue,
                    cta: "Continue"
                )
            ),
            OnboardingScreen(
                progressIndex: 3,
                total: 3,
                content: .readyToStart(
                    name: userName,
                    cta: "Resume my journey"
                )
            )
        ]
    }
    
    /// Creates a flow for specific screen types
    /// - Parameters:
    ///   - screenTypes: The types of screens to include
    ///   - userName: The user's name
    /// - Returns: An array of onboarding screens for the specified types
    static func makeCustomFlow(screenTypes: [ScreenType], userName: String = "") -> [OnboardingScreen] {
        var screens = [OnboardingScreen]()
        var currentIndex = 1
        
        for screenType in screenTypes {
            switch screenType {
            case .introduction:
                screens.append(contentsOf: buildIntroductionScreens(needsNameInput: false, userName: userName))
                currentIndex += 4
            case .userInput:
                screens.append(contentsOf: buildUserInputScreens(needsNameInput: true, questions: []))
                currentIndex += 2
            case .planning:
                screens.append(contentsOf: buildPlanningScreens(needsNameInput: false, userName: userName))
                currentIndex += 6
            case .permission:
                screens.append(contentsOf: buildPermissionScreens())
                currentIndex += 1
            case .completion:
                screens.append(contentsOf: buildCompletionScreens(userName: userName))
                currentIndex += 1
            }
        }
        
        return screens
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Onboarding Flow Builder")
            .font(.title)
            .fontWeight(.bold)
        
        Text("This builder creates the complete onboarding experience with \(OnboardingFlowBuilder.totalSteps) screens.")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Flow Sections:")
                .font(.headline)
            
            Text("• Introduction (4 screens)")
            Text("• User Input (2-6 screens)")
            Text("• Planning (6 screens)")
            Text("• Permission (1 screen)")
            Text("• Completion (1 screen)")
        }
        .font(.subheadline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    .padding()
}
