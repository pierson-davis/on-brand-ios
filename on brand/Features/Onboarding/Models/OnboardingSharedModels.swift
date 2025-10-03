//
//  OnboardingSharedModels.swift
//  on brand
//
//  This file contains shared models and enums used across
//  multiple onboarding components. It provides a central
//  location for common types and avoids circular dependencies.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import Foundation
import SwiftUI

// MARK: - Screen Type Enumeration
// This enum categorizes onboarding screens by their purpose
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
