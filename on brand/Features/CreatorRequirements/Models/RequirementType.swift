//
//  RequirementType.swift
//  on brand
//
//  This file defines the different types of creator requirements based on
//  real-world influencer agreements and brand partnerships.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation

/// Enumeration of all possible creator requirement types
/// Based on analysis of real influencer agreements
enum RequirementType: String, CaseIterable, Codable {
    
    // MARK: - Content Creation Requirements
    
    /// Static Instagram post with specific requirements
    case instagramPost = "instagram_post"
    
    /// Instagram story (single or multiple)
    case instagramStory = "instagram_story"
    
    /// Instagram reel with specific features
    case instagramReel = "instagram_reel"
    
    /// TikTok video content
    case tiktokVideo = "tiktok_video"
    
    /// YouTube video content
    case youtubeVideo = "youtube_video"
    
    /// Twitter/X post
    case twitterPost = "twitter_post"
    
    /// Facebook post
    case facebookPost = "facebook_post"
    
    /// LinkedIn post
    case linkedinPost = "linkedin_post"
    
    // MARK: - Asset Delivery Requirements
    
    /// High-resolution image files for brand use
    case imageAssets = "image_assets"
    
    /// Video content files for brand use
    case videoAssets = "video_assets"
    
    /// Raw footage for brand editing
    case rawFootage = "raw_footage"
    
    // MARK: - Promotional Requirements
    
    /// Promo code sharing and tracking
    case promoCode = "promo_code"
    
    /// Unique tracking link sharing
    case trackingLink = "tracking_link"
    
    /// Affiliate link sharing
    case affiliateLink = "affiliate_link"
    
    // MARK: - Engagement Requirements
    
    /// Specific account tagging
    case accountTagging = "account_tagging"
    
    /// Hashtag usage requirements
    case hashtagUsage = "hashtag_usage"
    
    /// Geo-tagging requirements
    case geoTagging = "geo_tagging"
    
    /// Link inclusion (swipe-up, bio link, etc.)
    case linkInclusion = "link_inclusion"
    
    // MARK: - Compliance Requirements
    
    /// FTC disclosure requirements
    case ftcDisclosure = "ftc_disclosure"
    
    /// Brand guideline compliance
    case brandCompliance = "brand_compliance"
    
    /// Content approval workflow
    case contentApproval = "content_approval"
    
    // MARK: - Communication Requirements
    
    /// Email communication requirements
    case emailCommunication = "email_communication"
    
    /// Phone call requirements
    case phoneCall = "phone_call"
    
    /// Meeting attendance
    case meetingAttendance = "meeting_attendance"
    
    // MARK: - Event Requirements
    
    /// Event attendance
    case eventAttendance = "event_attendance"
    
    /// Live streaming requirements
    case liveStreaming = "live_streaming"
    
    /// Behind-the-scenes content
    case behindTheScenes = "behind_the_scenes"
    
    // MARK: - Custom Requirements
    
    /// Custom requirement type
    case custom = "custom"
}

// MARK: - RequirementType Extensions

extension RequirementType {
    
    /// Human-readable display name for the requirement type
    var displayName: String {
        switch self {
        case .instagramPost:
            return "Instagram Post"
        case .instagramStory:
            return "Instagram Story"
        case .instagramReel:
            return "Instagram Reel"
        case .tiktokVideo:
            return "TikTok Video"
        case .youtubeVideo:
            return "YouTube Video"
        case .twitterPost:
            return "Twitter/X Post"
        case .facebookPost:
            return "Facebook Post"
        case .linkedinPost:
            return "LinkedIn Post"
        case .imageAssets:
            return "Image Assets"
        case .videoAssets:
            return "Video Assets"
        case .rawFootage:
            return "Raw Footage"
        case .promoCode:
            return "Promo Code"
        case .trackingLink:
            return "Tracking Link"
        case .affiliateLink:
            return "Affiliate Link"
        case .accountTagging:
            return "Account Tagging"
        case .hashtagUsage:
            return "Hashtag Usage"
        case .geoTagging:
            return "Geo-tagging"
        case .linkInclusion:
            return "Link Inclusion"
        case .ftcDisclosure:
            return "FTC Disclosure"
        case .brandCompliance:
            return "Brand Compliance"
        case .contentApproval:
            return "Content Approval"
        case .emailCommunication:
            return "Email Communication"
        case .phoneCall:
            return "Phone Call"
        case .meetingAttendance:
            return "Meeting Attendance"
        case .eventAttendance:
            return "Event Attendance"
        case .liveStreaming:
            return "Live Streaming"
        case .behindTheScenes:
            return "Behind-the-Scenes"
        case .custom:
            return "Custom Requirement"
        }
    }
    
    /// System icon name for the requirement type
    var iconName: String {
        switch self {
        case .instagramPost, .instagramStory, .instagramReel:
            return "camera.fill"
        case .tiktokVideo:
            return "video.fill"
        case .youtubeVideo:
            return "play.rectangle.fill"
        case .twitterPost, .facebookPost, .linkedinPost:
            return "text.bubble.fill"
        case .imageAssets, .videoAssets, .rawFootage:
            return "photo.fill"
        case .promoCode, .trackingLink, .affiliateLink:
            return "link"
        case .accountTagging, .hashtagUsage, .geoTagging, .linkInclusion:
            return "tag.fill"
        case .ftcDisclosure, .brandCompliance, .contentApproval:
            return "checkmark.shield.fill"
        case .emailCommunication, .phoneCall, .meetingAttendance:
            return "message.fill"
        case .eventAttendance, .liveStreaming, .behindTheScenes:
            return "calendar"
        case .custom:
            return "gear"
        }
    }
    
    /// Color scheme for the requirement type
    var color: String {
        switch self {
        case .instagramPost, .instagramStory, .instagramReel:
            return "pink"
        case .tiktokVideo:
            return "black"
        case .youtubeVideo:
            return "red"
        case .twitterPost:
            return "blue"
        case .facebookPost:
            return "blue"
        case .linkedinPost:
            return "blue"
        case .imageAssets, .videoAssets, .rawFootage:
            return "purple"
        case .promoCode, .trackingLink, .affiliateLink:
            return "green"
        case .accountTagging, .hashtagUsage, .geoTagging, .linkInclusion:
            return "orange"
        case .ftcDisclosure, .brandCompliance, .contentApproval:
            return "red"
        case .emailCommunication, .phoneCall, .meetingAttendance:
            return "blue"
        case .eventAttendance, .liveStreaming, .behindTheScenes:
            return "purple"
        case .custom:
            return "gray"
        }
    }
    
    /// Whether this requirement type has a deadline
    var hasDeadline: Bool {
        switch self {
        case .imageAssets, .videoAssets, .rawFootage, .contentApproval:
            return true
        case .eventAttendance, .meetingAttendance:
            return true
        case .instagramPost, .instagramStory, .instagramReel, .tiktokVideo, .youtubeVideo:
            return true
        case .twitterPost, .facebookPost, .linkedinPost:
            return true
        case .promoCode, .trackingLink, .affiliateLink:
            return true
        case .accountTagging, .hashtagUsage, .geoTagging, .linkInclusion:
            return true
        case .ftcDisclosure, .brandCompliance:
            return true
        case .emailCommunication, .phoneCall:
            return false
        case .liveStreaming, .behindTheScenes:
            return true
        case .custom:
            return true
        }
    }
    
    /// Whether this requirement type can be verified automatically
    var canAutoVerify: Bool {
        switch self {
        case .accountTagging, .hashtagUsage, .geoTagging, .linkInclusion:
            return true
        case .promoCode, .trackingLink, .affiliateLink:
            return true
        case .ftcDisclosure:
            return true
        case .brandCompliance:
            return true
        case .instagramPost, .instagramStory, .instagramReel, .tiktokVideo, .youtubeVideo:
            return false
        case .twitterPost, .facebookPost, .linkedinPost:
            return false
        case .imageAssets, .videoAssets, .rawFootage:
            return false
        case .contentApproval:
            return false
        case .emailCommunication, .phoneCall, .meetingAttendance:
            return false
        case .eventAttendance, .liveStreaming, .behindTheScenes:
            return false
        case .custom:
            return false
        }
    }
}
