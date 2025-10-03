//
//  LinkRequirements.swift
//  on brand
//
//  Created by Assistant on 2025-01-27.
//

import Foundation

/// Requirements for including specific links
struct LinkRequirements: Codable, Equatable {
    let url: String
    let callToAction: String?
    let placement: LinkPlacementRules?
    let trackingSettings: LinkTrackingSettings?
}

/// Rules for link placement
struct LinkPlacementRules: Codable, Equatable {
    let captionPosition: CaptionPosition?
    let storyPosition: StoryPosition?
    let postPosition: PostPosition?
    let bioLink: Bool
    let storyLink: Bool
}

/// Tracking settings for links
struct LinkTrackingSettings: Codable, Equatable {
    let trackClicks: Bool
    let trackConversions: Bool
    let analytics: AnalyticsSettings?
    let notifications: NotificationSettings?
}