//
//  ContentRequirements.swift
//  on brand
//
//  This file defines detailed content requirements for creator agreements.
//  Based on analysis of real influencer contracts and brand partnerships.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation

/// Detailed content requirements for creator agreements
struct ContentRequirements: Codable, Equatable {
    
    // MARK: - Content Type Properties
    
    /// Minimum number of posts required
    let minimumPosts: Int?
    
    /// Maximum number of posts allowed
    let maximumPosts: Int?
    
    /// Specific content format required
    let contentFormat: ContentFormat?
    
    /// Content duration (for videos)
    let duration: TimeInterval?
    
    /// Content dimensions (width x height)
    let dimensions: ContentDimensions?
    
    // MARK: - Content Quality Properties
    
    /// Minimum resolution required
    let minimumResolution: ContentResolution?
    
    /// File format requirements
    let fileFormats: [String]?
    
    /// Quality standards
    let qualityStandards: [String]?
    
    // MARK: - Content Guidelines
    
    /// Brand messaging guidelines
    let messagingGuidelines: [String]?
    
    /// Visual style requirements
    let visualStyle: VisualStyleRequirements?
    
    /// Tone of voice requirements
    let toneOfVoice: ToneOfVoiceRequirements?
    
    /// Content do's and don'ts
    let dosAndDonts: DosAndDonts?
    
    // MARK: - Content Features
    
    /// Required features (swipe-up, stickers, etc.)
    let requiredFeatures: [ContentFeature]?
    
    /// Prohibited content
    let prohibitedContent: [String]?
    
    /// Required elements
    let requiredElements: [String]?
    
    // MARK: - Content Timing
    
    /// Posting schedule requirements
    let postingSchedule: PostingSchedule?
    
    /// Time zone requirements
    let timeZone: String?
    
    /// Peak engagement times
    let peakTimes: [String]?
    
    // MARK: - Content Examples
    
    /// Example content URLs
    let exampleContent: [String]?
    
    /// Reference content
    let referenceContent: [String]?
    
    /// Brand content library
    let brandContentLibrary: [String]?
}

// MARK: - Content Format

/// Format of content required
enum ContentFormat: String, CaseIterable, Codable {
    case image = "image"
    case video = "video"
    case carousel = "carousel"
    case story = "story"
    case reel = "reel"
    case live = "live"
    case text = "text"
    case mixed = "mixed"
    
    var displayName: String {
        switch self {
        case .image:
            return "Image"
        case .video:
            return "Video"
        case .carousel:
            return "Carousel"
        case .story:
            return "Story"
        case .reel:
            return "Reel"
        case .live:
            return "Live"
        case .text:
            return "Text"
        case .mixed:
            return "Mixed"
        }
    }
}

// MARK: - Content Dimensions

/// Content dimensions specification
struct ContentDimensions: Codable, Equatable {
    let width: Int
    let height: Int
    let aspectRatio: String?
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.aspectRatio = nil
    }
    
    init(width: Int, height: Int, aspectRatio: String) {
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
    }
}

// MARK: - Content Resolution

/// Content resolution requirements
enum ContentResolution: String, CaseIterable, Codable {
    case hd = "hd"           // 1280x720
    case fullHd = "full_hd"  // 1920x1080
    case fourK = "four_k"    // 3840x2160
    case instagram = "instagram" // 1080x1080
    case story = "story"     // 1080x1920
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .hd:
            return "HD (1280x720)"
        case .fullHd:
            return "Full HD (1920x1080)"
        case .fourK:
            return "4K (3840x2160)"
        case .instagram:
            return "Instagram Square (1080x1080)"
        case .story:
            return "Instagram Story (1080x1920)"
        case .custom:
            return "Custom"
        }
    }
}

// MARK: - Visual Style Requirements

/// Visual style requirements for content
struct VisualStyleRequirements: Codable, Equatable {
    let colorPalette: [String]?
    let fontRequirements: [String]?
    let logoPlacement: LogoPlacement?
    let imageStyle: ImageStyle?
    let videoStyle: VideoStyle?
    let brandElements: [String]?
}

// MARK: - Logo Placement

/// Logo placement requirements
struct LogoPlacement: Codable, Equatable {
    let position: LogoPosition
    let size: LogoSize
    let opacity: Double?
    let duration: TimeInterval? // For videos
}

enum LogoPosition: String, CaseIterable, Codable {
    case topLeft = "top_left"
    case topRight = "top_right"
    case bottomLeft = "bottom_left"
    case bottomRight = "bottom_right"
    case center = "center"
    case watermark = "watermark"
    
    var displayName: String {
        switch self {
        case .topLeft:
            return "Top Left"
        case .topRight:
            return "Top Right"
        case .bottomLeft:
            return "Bottom Left"
        case .bottomRight:
            return "Bottom Right"
        case .center:
            return "Center"
        case .watermark:
            return "Watermark"
        }
    }
}

enum LogoSize: String, CaseIterable, Codable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .custom:
            return "Custom"
        }
    }
}

// MARK: - Image Style

/// Image style requirements
struct ImageStyle: Codable, Equatable {
    let filter: String?
    let brightness: Double?
    let contrast: Double?
    let saturation: Double?
    let style: String? // e.g., "vintage", "modern", "minimalist"
}

// MARK: - Video Style

/// Video style requirements
struct VideoStyle: Codable, Equatable {
    let editingStyle: String?
    let transitions: [String]?
    let music: MusicRequirements?
    let effects: [String]?
    let pacing: String? // e.g., "fast", "slow", "medium"
}

// MARK: - Music Requirements

/// Music requirements for video content
struct MusicRequirements: Codable, Equatable {
    let genre: String?
    let mood: String?
    let duration: TimeInterval?
    let volume: Double?
    let brandMusic: [String]? // URLs to brand music
    let prohibitedMusic: [String]?
}

// MARK: - Tone of Voice Requirements

/// Tone of voice requirements
struct ToneOfVoiceRequirements: Codable, Equatable {
    let personality: [String]? // e.g., "friendly", "professional", "casual"
    let language: String? // e.g., "English", "Spanish"
    let formality: FormalityLevel?
    let keywords: [String]?
    let prohibitedWords: [String]?
    let brandVoice: String?
}

enum FormalityLevel: String, CaseIterable, Codable {
    case veryFormal = "very_formal"
    case formal = "formal"
    case neutral = "neutral"
    case casual = "casual"
    case veryCasual = "very_casual"
    
    var displayName: String {
        switch self {
        case .veryFormal:
            return "Very Formal"
        case .formal:
            return "Formal"
        case .neutral:
            return "Neutral"
        case .casual:
            return "Casual"
        case .veryCasual:
            return "Very Casual"
        }
    }
}

// MARK: - Dos and Don'ts

/// Content do's and don'ts
struct DosAndDonts: Codable, Equatable {
    let dos: [String]
    let donts: [String]
    let examples: [String]?
}

// MARK: - Content Feature

/// Required content features
enum ContentFeature: String, CaseIterable, Codable {
    case swipeUp = "swipe_up"
    case bookNow = "book_now"
    case shopNow = "shop_now"
    case learnMore = "learn_more"
    case poll = "poll"
    case question = "question"
    case quiz = "quiz"
    case countdown = "countdown"
    case location = "location"
    case mention = "mention"
    case hashtag = "hashtag"
    case link = "link"
    case music = "music"
    case effect = "effect"
    case filter = "filter"
    case sticker = "sticker"
    case gif = "gif"
    case emoji = "emoji"
    
    var displayName: String {
        switch self {
        case .swipeUp:
            return "Swipe Up Link"
        case .bookNow:
            return "Book Now Sticker"
        case .shopNow:
            return "Shop Now Sticker"
        case .learnMore:
            return "Learn More Link"
        case .poll:
            return "Poll"
        case .question:
            return "Question Sticker"
        case .quiz:
            return "Quiz"
        case .countdown:
            return "Countdown"
        case .location:
            return "Location Tag"
        case .mention:
            return "Mention"
        case .hashtag:
            return "Hashtag"
        case .link:
            return "Link"
        case .music:
            return "Music"
        case .effect:
            return "Effect"
        case .filter:
            return "Filter"
        case .sticker:
            return "Sticker"
        case .gif:
            return "GIF"
        case .emoji:
            return "Emoji"
        }
    }
}

// MARK: - Posting Schedule

/// Posting schedule requirements
struct PostingSchedule: Codable, Equatable {
    let frequency: PostingFrequency
    let days: [Weekday]?
    let times: [String]? // e.g., ["9:00 AM", "2:00 PM", "7:00 PM"]
    let timeZone: String?
    let specificDates: [Date]?
    let blackoutDates: [Date]?
}

enum PostingFrequency: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case biWeekly = "bi_weekly"
    case monthly = "monthly"
    case custom = "custom"
    case oneTime = "one_time"
    
    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .biWeekly:
            return "Bi-weekly"
        case .monthly:
            return "Monthly"
        case .custom:
            return "Custom"
        case .oneTime:
            return "One-time"
        }
    }
}

enum Weekday: String, CaseIterable, Codable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    var displayName: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}
