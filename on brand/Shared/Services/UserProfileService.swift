//
//  UserProfileService.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import Foundation
import Combine

/// Local storage service for user profiles
class UserProfileService: ObservableObject {
    static let shared = UserProfileService()
    
    @Published var currentProfile: UserProfile?
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let profileKey = "saved_user_profile"
    
    private init() {
        loadCurrentProfile()
    }
    
    /// Save a user profile locally
    func saveProfile(_ profile: UserProfile) {
        do {
            let encoded = try JSONEncoder().encode(profile)
            userDefaults.set(encoded, forKey: profileKey)
            currentProfile = profile
            print("✅ Profile saved locally for user: \(profile.userId)")
        } catch {
            print("❌ Failed to save profile: \(error)")
        }
    }
    
    /// Load the current user's profile
    func loadCurrentProfile() {
        guard let data = userDefaults.data(forKey: profileKey) else {
            currentProfile = nil
            return
        }
        
        do {
            let profile = try JSONDecoder().decode(UserProfile.self, from: data)
            currentProfile = profile
            print("✅ Profile loaded for user: \(profile.userId)")
        } catch {
            print("❌ Failed to load profile: \(error)")
            currentProfile = nil
        }
    }
    
    /// Check if current user has a saved profile
    func hasProfile(for userId: String) -> Bool {
        return currentProfile?.userId == userId
    }
    
    /// Update profile with new data
    func updateProfile(_ updates: (inout UserProfile) -> Void) {
        guard var profile = currentProfile else { return }
        
        updates(&profile)
        profile = UserProfile(
            id: profile.id,
            userId: profile.userId,
            name: profile.name,
            primaryArchetype: profile.primaryArchetype,
            secondaryArchetype: profile.secondaryArchetype,
            description: profile.description,
            bio: profile.bio,
            photos: profile.photos,
            createdAt: profile.createdAt,
            updatedAt: Date()
        )
        
        saveProfile(profile)
    }
    
    /// Add a photo to the current profile
    func addPhoto(_ photo: PhotoData) {
        updateProfile { profile in
            var updatedPhotos = profile.photos
            updatedPhotos.append(photo)
            // Keep only the last 20 photos to manage storage
            if updatedPhotos.count > 20 {
                updatedPhotos = Array(updatedPhotos.suffix(20))
            }
            profile.photos = updatedPhotos
        }
    }
    
    /// Clear all profile data (for logout)
    func clearProfile() {
        userDefaults.removeObject(forKey: profileKey)
        currentProfile = nil
        print("✅ Profile data cleared")
    }
    
    /// Get profile for a specific user ID
    func getProfile(for userId: String) -> UserProfile? {
        return currentProfile?.userId == userId ? currentProfile : nil
    }
}
