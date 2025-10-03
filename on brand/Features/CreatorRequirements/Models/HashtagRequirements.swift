//
//  HashtagRequirements.swift
//  on brand
//
//  Created by Assistant on 2025-01-27.
//

import Foundation

/// Requirements for using specific hashtags
struct HashtagRequirements: Codable, Equatable {
    let requiredHashtags: [String]
    let optionalHashtags: [String]
    let placementRules: HashtagPlacementRules?
    let formatRequirements: HashtagFormatRequirements?
    let trackingSettings: HashtagTrackingSettings?
}

/// Rules for hashtag placement
struct HashtagPlacementRules: Codable, Equatable {
    let captionPosition: CaptionPosition?
    let storyPosition: StoryPosition?
    let postPosition: PostPosition?
    let maxPerPost: Int?
    let minPerPost: Int?
}

/// Format requirements for hashtags
struct HashtagFormatRequirements: Codable, Equatable {
    let caseSensitivity: CaseSensitivity?
    let specialCharacters: SpecialCharacterRules?
    let emoji: EmojiRules?
}

/// Tracking settings for hashtags
struct HashtagTrackingSettings: Codable, Equatable {
    let trackUsage: Bool
    let trackEngagement: Bool
    let analytics: AnalyticsSettings?
    let notifications: NotificationSettings?
}