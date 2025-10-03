//
//  ProfileModels.swift
//  on brand
//
//  This file contains all the shared models and types used across
//  the profile feature. This ensures consistency and reusability
//  across all profile-related components.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI
import PhotosUI

// MARK: - Content Tab Enumeration
// This enum defines the different content tabs available in the profile view
enum ContentTab {
    case profile    // Shows the user's profile content
    case hashtag    // Shows hashtag-related content
}

// MARK: - Profile View State
// This struct contains all the state properties needed for the profile view
struct ProfileViewState {
    /// Manages the photos selected by the user from their photo library
    var selectedItems: [PhotosPickerItem] = []
    
    /// Stores the actual UIImage objects loaded from the selected photos
    var uiImages: [UIImage] = []
    
    /// Tracks whether the AI is currently analyzing photos
    var isAnalyzing = false
    
    /// Stores the results of AI analysis for each photo
    var analysisResults: [AIImageAnalysisResponse] = []
    
    /// Tracks which bottom navigation tab is currently selected
    var selectedTab: EraBottomNavigationBar.Tab = .profile
    
    /// Controls whether the photo picker is currently visible
    var showPhotoPicker = false
    
    /// Tracks which content tab (profile/hashtag) is currently selected
    var selectedContentTab: ContentTab = .profile
    
    /// Controls the visibility of the logout confirmation menu
    var showLogoutMenu = false
    
    /// Controls the visibility of the settings menu
    var showSettingsMenu = false
    
    /// Controls whether the settings view is presented
    var showSettingsView = false
}

// MARK: - Profile View Configuration
// This struct contains configuration options for the profile view
struct ProfileViewConfiguration {
    /// The user's primary style archetype (used for display and styling)
    let userArchetype: Archetype
    
    /// Optional callback when the profile view should be dismissed
    let onDismiss: (() -> Void)?
    
    /// Optional callback when the user wants to log out
    let onLogout: (() -> Void)?
    
    /// Maximum number of photos that can be selected
    let maxPhotoSelection: Int
    
    /// Number of columns in the photo grid
    let photoGridColumns: Int
    
    /// Spacing between grid items
    let gridSpacing: CGFloat
    
    /// Default initializer with sensible defaults
    init(
        userArchetype: Archetype,
        onDismiss: (() -> Void)? = nil,
        onLogout: (() -> Void)? = nil,
        maxPhotoSelection: Int = 20,
        photoGridColumns: Int = 3,
        gridSpacing: CGFloat = 1
    ) {
        self.userArchetype = userArchetype
        self.onDismiss = onDismiss
        self.onLogout = onLogout
        self.maxPhotoSelection = maxPhotoSelection
        self.photoGridColumns = photoGridColumns
        self.gridSpacing = gridSpacing
    }
}

// MARK: - Profile Statistics
// This struct contains the user's profile statistics
struct ProfileStatistics {
    /// Number of posts the user has
    let postsCount: Int
    
    /// Number of followers the user has
    let followersCount: Int
    
    /// Number of people the user is following
    let followingCount: Int
    
    /// User's join date
    let joinDate: Date
    
    /// User's location
    let location: String?
    
    /// User's website URL
    let website: String?
    
    /// Default initializer
    init(
        postsCount: Int = 0,
        followersCount: Int = 0,
        followingCount: Int = 0,
        joinDate: Date = Date(),
        location: String? = nil,
        website: String? = nil
    ) {
        self.postsCount = postsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.joinDate = joinDate
        self.location = location
        self.website = website
    }
}

// MARK: - Profile Action
// This enum defines the available actions in the profile view
enum ProfileAction {
    case editProfile
    case shareProfile
    case moreOptions
    case addPhoto
    case deletePhoto(Int)
    case viewPhoto(Int)
    case switchTab(ContentTab)
    case logout
    case showSettings
}

// MARK: - Profile Error
// This enum defines the possible errors that can occur in the profile view
enum ProfileError: LocalizedError {
    case photoLoadFailed
    case photoAnalysisFailed
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .photoLoadFailed:
            return "Failed to load photo. Please try again."
        case .photoAnalysisFailed:
            return "Failed to analyze photo. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
}
