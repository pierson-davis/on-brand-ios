import Foundation
import SwiftUI

struct OnboardingScreen: Identifiable {
    enum Content {
        case hero(image: String, title: String, subtitle: String, cta: String)
        case welcome(name: String)
        case problemStatement(title: String, description: String, image: String)
        case benefits(title: String, items: [ChecklistRow])
        case nameInput
        case genderSelection
        case question(QuizQuestion)
        case personalizedPlan(name: String, daysCount: Int)
        case progressTracking(title: String, description: String)
        case habitTracking(title: String, description: String)
        case permissionRequest(title: String, description: String, permission: PermissionType)
        case dailyCheckin(title: String, description: String)
        case customPlan(name: String, planDetails: String)
        case progressGraph(title: String, weeks: Int)
        case summary(title: String, body: String, accent: Color, cta: String)
        case readyToStart(name: String, cta: String)
    }
    
    enum PermissionType {
        case photoAccess
        case notifications
        case analytics
        case location
    }

    struct ChecklistRow: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
    }

    let id = UUID()
    let progressIndex: Int
    let total: Int
    let content: Content

    var progressLabel: String {
        "Step \(min(progressIndex, total)) of \(max(total, 1))"
    }
}

struct OnboardingFlowBuilder {
    static func makeScreens(from questions: [QuizQuestion], needsNameInput: Bool = true, userName: String = "") -> [OnboardingScreen] {
        // Extended onboarding with 18-20 screens similar to QUITTR
        let totalSteps = 18
        
        var screens = [OnboardingScreen]()
        screens.reserveCapacity(totalSteps)

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
                        .init(icon: "sparkles", title: "Personalized vibe analysis", description: "AI discovers your unique style archetype"),
                        .init(icon: "camera", title: "Smart photo curation", description: "Automatically selects your best shots"),
                        .init(icon: "paintpalette", title: "Cohesive aesthetic system", description: "Color palettes and themes that work"),
                        .init(icon: "chart.line.uptrend.xyaxis", title: "Style evolution tracking", description: "See how your aesthetic develops over time")
                    ]
                )
            )
        )

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

        // 11. Personalized Plan Creation
        let planIndex = needsNameInput ? 11 : 10
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

        // 17. Permission Requests
        screens.append(
            OnboardingScreen(
                progressIndex: planIndex + 6,
                total: totalSteps,
                content: .permissionRequest(
                    title: "Allow Era to access your photos?",
                    description: "Era needs access to analyze your photos and create personalized style recommendations.",
                    permission: .photoAccess
                )
            )
        )

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
