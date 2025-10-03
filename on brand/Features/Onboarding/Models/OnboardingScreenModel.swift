//
//  OnboardingScreenModel.swift
//  on brand
//
//  This file contains the core data models for the onboarding flow.
//  Shared models like PermissionType, ChecklistRow, and ScreenType
//  are defined in OnboardingSharedModels.swift to avoid circular dependencies.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import Foundation
import SwiftUI

// MARK: - Onboarding Screen Model
// This struct represents a single screen in the onboarding flow
struct OnboardingScreen: Identifiable {
    
    // MARK: - Properties
    /// Unique identifier for the screen
    let id = UUID()
    
    /// The current step index (1-based)
    let progressIndex: Int
    
    /// The total number of steps
    let total: Int
    
    /// The content to display on this screen
    let content: Content
    
    // MARK: - Computed Properties
    /// Returns a formatted progress label (e.g., "Step 1 of 18")
    var progressLabel: String {
        "Step \(min(progressIndex, total)) of \(max(total, 1))"
    }
    
    /// Returns the progress percentage (0.0 to 1.0)
    var progressPercentage: Double {
        guard total > 0 else { return 0.0 }
        return Double(progressIndex) / Double(total)
    }
    
    /// Returns whether this is the first screen
    var isFirst: Bool {
        progressIndex == 1
    }
    
    /// Returns whether this is the last screen
    var isLast: Bool {
        progressIndex == total
    }
}

// MARK: - Onboarding Screen Content
// This enum defines all possible types of content for onboarding screens
extension OnboardingScreen {
    
    enum Content {
        // MARK: - Introduction Screens
        /// Hero screen with main app introduction
        case hero(image: String, title: String, subtitle: String, cta: String)
        
        /// Welcome screen with personalized greeting
        case welcome(name: String)
        
        /// Problem statement screen explaining the app's purpose
        case problemStatement(title: String, description: String, image: String)
        
        /// Benefits overview screen showing app features
        case benefits(title: String, items: [ChecklistRow])
        
        // MARK: - User Input Screens
        /// Name input screen for collecting user's name
        case nameInput
        
        /// Gender selection screen for personalization
        case genderSelection
        
        /// Quiz question screen for style assessment
        case question(QuizQuestion)
        
        // MARK: - Planning Screens
        /// Personalized plan creation screen
        case personalizedPlan(name: String, daysCount: Int)
        
        /// Progress tracking explanation screen
        case progressTracking(title: String, description: String)
        
        /// Habit tracking introduction screen
        case habitTracking(title: String, description: String)
        
        /// Daily check-in explanation screen
        case dailyCheckin(title: String, description: String)
        
        /// Custom plan details screen
        case customPlan(name: String, planDetails: String)
        
        /// Progress graph visualization screen
        case progressGraph(title: String, weeks: Int)
        
        // MARK: - Permission Screens
        /// Permission request screen for app access
        case permissionRequest(title: String, description: String, permission: PermissionType)
        
        // MARK: - Completion Screens
        /// Summary screen with key information
        case summary(title: String, body: String, accent: Color, cta: String)
        
        /// Ready to start screen with final call-to-action
        case readyToStart(name: String, cta: String)
    }
}

// MARK: - Permission Types
// This enum defines the types of permissions that can be requested
enum PermissionType: String, CaseIterable {
    case photoAccess = "photo_access"
    case notifications = "notifications"
    case analytics = "analytics"
    case location = "location"
    
    /// The display name for the permission type
    var displayName: String {
        switch self {
        case .photoAccess:
            return "Photo Access"
        case .notifications:
            return "Notifications"
        case .analytics:
            return "Analytics"
        case .location:
            return "Location"
        }
    }
    
    /// The description for the permission type
    var description: String {
        switch self {
        case .photoAccess:
            return "Access your photos to analyze your style and create recommendations"
        case .notifications:
            return "Send you reminders and updates about your style journey"
        case .analytics:
            return "Help us improve the app by collecting anonymous usage data"
        case .location:
            return "Provide location-based style recommendations and weather updates"
        }
    }
    
    /// The icon for the permission type
    var icon: String {
        switch self {
        case .photoAccess:
            return "photo.stack"
        case .notifications:
            return "bell"
        case .analytics:
            return "chart.bar"
        case .location:
            return "location"
        }
    }
}

// MARK: - Checklist Row Model
// This struct represents a single item in a checklist
struct ChecklistRow: Identifiable {
    
    // MARK: - Properties
    /// Unique identifier for the checklist item
    let id = UUID()
    
    /// The icon to display for this item
    let icon: String
    
    /// The title of this item
    let title: String
    
    /// The description of this item
    let description: String
    
    // MARK: - Initialization
    /// Initializes a checklist row
    /// - Parameters:
    ///   - icon: The icon to display
    ///   - title: The title of the item
    ///   - description: The description of the item
    init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

// MARK: - Onboarding Screen Extensions
// These extensions provide additional functionality for onboarding screens

extension OnboardingScreen {
    
    /// Returns the screen type based on the content
    /// Note: This will be re-enabled once OnboardingSharedModels.swift is added to the project
    /*
    var screenType: ScreenType {
        switch content {
        case .hero, .welcome, .problemStatement, .benefits:
            return .introduction
        case .nameInput, .genderSelection, .question:
            return .userInput
        case .personalizedPlan, .progressTracking, .habitTracking, .dailyCheckin, .customPlan, .progressGraph:
            return .planning
        case .permissionRequest:
            return .permission
        case .summary, .readyToStart:
            return .completion
        }
    }
    */
    
    /// Returns whether the screen requires user interaction
    var requiresInteraction: Bool {
        switch content {
        case .nameInput, .genderSelection, .question, .permissionRequest:
            return true
        default:
            return false
        }
    }
    
    /// Returns whether the screen can be skipped
    var canBeSkipped: Bool {
        switch content {
        case .permissionRequest:
            return true
        default:
            return false
        }
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Onboarding Screen Model")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Screen Types:")
                .font(.headline)
            
            Text("• Introduction")
                .font(.subheadline)
            Text("• User Input")
                .font(.subheadline)
            Text("• Planning")
                .font(.subheadline)
            Text("• Permission")
                .font(.subheadline)
            Text("• Completion")
                .font(.subheadline)
            
            Text("Permission Types:")
                .font(.headline)
                .padding(.top)
            
            Text("• Photo Access")
                .font(.subheadline)
            Text("• Notifications")
                .font(.subheadline)
            Text("• Analytics")
                .font(.subheadline)
            Text("• Location")
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    .padding()
}