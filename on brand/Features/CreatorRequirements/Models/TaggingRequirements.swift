//
//  TaggingRequirements.swift
//  on brand
//
//  Created by Assistant on 2025-01-27.
//

import Foundation

/// Requirements for tagging accounts or locations
struct TaggingRequirements: Codable, Equatable {
    let accountsToTag: [String]
    let locationsToTag: [String]
    let placementRules: TaggingPlacementRules?
    let formatRequirements: TaggingFormatRequirements?
    let verificationSettings: AutoVerificationSettings?
    let trackingSettings: TaggingTrackingSettings?
}

/// Rules for tag placement
struct TaggingPlacementRules: Codable, Equatable {
    let captionPosition: CaptionPosition?
    let commentPosition: CommentPosition?
    let storyPosition: StoryPosition?
    let postPosition: PostPosition?
    let spacing: TagSpacing?
    let order: TagOrder?
}

/// Format requirements for tags
struct TaggingFormatRequirements: Codable, Equatable {
    let caseSensitivity: CaseSensitivity?
    let specialCharacters: SpecialCharacterRules?
    let emoji: EmojiRules?
}

/// Spacing rules for tags
struct TagSpacing: Codable, Equatable {
    let minSpacing: Int?
    let maxSpacing: Int?
    let preferredSpacing: Int?
}

/// Order rules for tags
struct TagOrder: Codable, Equatable {
    let specificOrder: [String]?
    let randomOrder: Bool
    let priorityOrder: [String]?
}

/// Auto-verification settings
struct AutoVerificationSettings: Codable, Equatable {
    let enabled: Bool
    let verificationMethod: VerificationMethod
    let notificationSettings: NotificationSettings?
}


/// Tracking settings for tags
struct TaggingTrackingSettings: Codable, Equatable {
    let trackMentions: Bool
    let trackEngagement: Bool
    let analytics: AnalyticsSettings?
    let notifications: NotificationSettings?
}