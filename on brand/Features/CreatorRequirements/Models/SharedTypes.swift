//
//  SharedTypes.swift
//  on brand
//
//  Created by Assistant on 2025-01-27.
//

import Foundation

// MARK: - Position Enums
enum CaptionPosition: String, CaseIterable, Codable {
    case beginning = "beginning"
    case end = "end"
    case middle = "middle"
    case anywhere = "anywhere"
}

enum CommentPosition: String, CaseIterable, Codable {
    case first = "first"
    case second = "second"
    case third = "third"
    case anywhere = "anywhere"
}

enum StoryPosition: String, CaseIterable, Codable {
    case first = "first"
    case second = "second"
    case third = "third"
    case last = "last"
    case anywhere = "anywhere"
}

enum PostPosition: String, CaseIterable, Codable {
    case first = "first"
    case second = "second"
    case third = "third"
    case last = "last"
    case anywhere = "anywhere"
}

// MARK: - Format Rules
enum CaseSensitivity: String, CaseIterable, Codable {
    case caseSensitive = "case_sensitive"
    case caseInsensitive = "case_insensitive"
    case mixed = "mixed"
}

struct SpecialCharacterRules: Codable, Equatable {
    let allowedCharacters: [String]
    let forbiddenCharacters: [String]
    let maxLength: Int?
    let minLength: Int?
}

struct EmojiRules: Codable, Equatable {
    let allowed: Bool
    let maxCount: Int?
    let specificEmojis: [String]?
    let forbiddenEmojis: [String]?
}

// MARK: - Settings
struct AnalyticsSettings: Codable, Equatable {
    let trackViews: Bool
    let trackClicks: Bool
    let trackEngagement: Bool
    let customMetrics: [String: String]?
}

struct NotificationSettings: Codable, Equatable {
    let enabled: Bool
    let reminderIntervals: [TimeInterval]
    let escalationEnabled: Bool
    let customMessages: [String: String]?
}

// MARK: - Additional Types
enum VerificationMethod: String, CaseIterable, Codable {
    case manual = "manual"
    case automatic = "automatic"
    case hybrid = "hybrid"
}

enum SocialPlatform: String, CaseIterable, Codable {
    case instagram = "instagram"
    case tiktok = "tiktok"
    case youtube = "youtube"
    case twitter = "twitter"
    case facebook = "facebook"
    case linkedin = "linkedin"
    case snapchat = "snapchat"
    case pinterest = "pinterest"
    
    var displayName: String {
        switch self {
        case .instagram:
            return "Instagram"
        case .tiktok:
            return "TikTok"
        case .youtube:
            return "YouTube"
        case .twitter:
            return "Twitter"
        case .facebook:
            return "Facebook"
        case .linkedin:
            return "LinkedIn"
        case .snapchat:
            return "Snapchat"
        case .pinterest:
            return "Pinterest"
        }
    }
}

enum RequirementStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    case verified = "verified"
    case overdue = "overdue"
    case cancelled = "cancelled"
    case needsRevision = "needs_revision"
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        case .verified:
            return "Verified"
        case .overdue:
            return "Overdue"
        case .cancelled:
            return "Cancelled"
        case .needsRevision:
            return "Needs Revision"
        }
    }
    
    var color: String {
        switch self {
        case .pending:
            return "orange"
        case .inProgress:
            return "blue"
        case .completed:
            return "green"
        case .verified:
            return "purple"
        case .overdue:
            return "red"
        case .cancelled:
            return "gray"
        case .needsRevision:
            return "yellow"
        }
    }
}
