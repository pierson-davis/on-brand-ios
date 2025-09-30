//
//  UserProfile.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import Foundation

/// Represents a saved user profile with their archetype data and photos
struct UserProfile: Codable, Identifiable {
    let id: String
    let userId: String // Apple Sign-In user ID
    let name: String // User's display name
    let primaryArchetype: Archetype
    let secondaryArchetype: Archetype?
    let description: String
    let bio: String
    var photos: [PhotoData]
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        name: String,
        primaryArchetype: Archetype,
        secondaryArchetype: Archetype?,
        description: String,
        bio: String = "",
        photos: [PhotoData] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.primaryArchetype = primaryArchetype
        self.secondaryArchetype = secondaryArchetype
        self.description = description
        self.bio = bio
        self.photos = photos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    /// Create a UserProfile from a VibeResult
    static func from(vibeResult: VibeResult, userId: String, name: String, bio: String = "") -> UserProfile {
        return UserProfile(
            userId: userId,
            name: name,
            primaryArchetype: vibeResult.primary,
            secondaryArchetype: vibeResult.secondary,
            description: vibeResult.description,
            bio: bio
        )
    }
}

/// Represents a photo with its AI analysis data
struct PhotoData: Codable, Identifiable {
    let id: String
    let fileName: String
    let aiAnalysis: AIImageAnalysisResponse
    let uploadedAt: Date
    let imageData: Data? // Base64 encoded image data for local storage
    
    init(
        id: String = UUID().uuidString,
        fileName: String,
        aiAnalysis: AIImageAnalysisResponse,
        uploadedAt: Date = Date(),
        imageData: Data? = nil
    ) {
        self.id = id
        self.fileName = fileName
        self.aiAnalysis = aiAnalysis
        self.uploadedAt = uploadedAt
        self.imageData = imageData
    }
}