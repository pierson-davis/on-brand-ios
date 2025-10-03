//
//  AssetRequirements.swift
//  on brand
//
//  Created by Assistant on 2025-01-27.
//

import Foundation

/// Requirements for delivering specific assets
struct AssetRequirements: Codable, Equatable {
    let assetType: AssetType
    let quantity: Int
    let deliveryMethod: DeliveryMethod
    let resolution: AssetResolution?
    let format: AssetFormat?
    let trackingSettings: AssetTrackingSettings?
}

/// Types of assets
enum AssetType: String, CaseIterable, Codable {
    case photo = "photo"
    case video = "video"
    case story = "story"
    case reel = "reel"
    case carousel = "carousel"
    case live = "live"
}

/// Delivery methods
enum DeliveryMethod: String, CaseIterable, Codable {
    case email = "email"
    case cloud = "cloud"
    case direct = "direct"
    case platform = "platform"
}

/// Asset resolution requirements
struct AssetResolution: Codable, Equatable {
    let width: Int
    let height: Int
    let minWidth: Int?
    let minHeight: Int?
    let maxWidth: Int?
    let maxHeight: Int?
}

/// Asset format requirements
struct AssetFormat: Codable, Equatable {
    let fileType: String
    let compression: CompressionSettings?
    let quality: QualitySettings?
}

/// Compression settings
struct CompressionSettings: Codable, Equatable {
    let enabled: Bool
    let level: Int?
    let maxFileSize: Int?
}

/// Quality settings
struct QualitySettings: Codable, Equatable {
    let minQuality: Int
    let maxQuality: Int
    let preferredQuality: Int?
}

/// Tracking settings for assets
struct AssetTrackingSettings: Codable, Equatable {
    let trackDelivery: Bool
    let trackUsage: Bool
    let analytics: AnalyticsSettings?
    let notifications: NotificationSettings?
}