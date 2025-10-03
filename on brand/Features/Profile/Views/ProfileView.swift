//
//  ProfileView.swift
//  on brand
//
//  This file now serves as a compatibility layer that imports
//  the new modular ProfileView components. This ensures the
//  Xcode project continues to work while we transition to
//  the new modular structure.
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

// MARK: - ProfileView Implementation
// This file now contains the actual ProfileView implementation
// using the modular components we created

struct ProfileView: View {
    
    // MARK: - Properties
    /// The user's primary style archetype (used for display and styling)
    let userArchetype: Archetype
    
    /// Optional callback when the profile view should be dismissed
    let onDismiss: (() -> Void)?
    
    /// Optional callback when the user wants to log out
    let onLogout: (() -> Void)?
    
    // MARK: - State Properties
    /// Manages the photos selected by the user from their photo library
    @State private var selectedItems: [PhotosPickerItem] = []
    
    /// Stores the actual UIImage objects loaded from the selected photos
    @State private var uiImages: [UIImage] = []
    
    /// Tracks whether the AI is currently analyzing photos
    @State private var isAnalyzing = false
    
    /// Stores the results of AI analysis for each photo
    @State private var analysisResults: [AIImageAnalysisResponse] = []
    
    /// Tracks which bottom navigation tab is currently selected
    @State private var selectedTab: EraBottomNavigationBar.Tab = .profile
    
    /// Controls whether the photo picker is currently visible
    @State private var showPhotoPicker = false
    
    /// Tracks which content tab (profile/hashtag) is currently selected
    @State private var selectedContentTab: ContentTab = .profile
    
    /// Controls the visibility of the logout confirmation menu
    @State private var showLogoutMenu = false
    
    /// Controls the visibility of the settings menu
    @State private var showSettingsMenu = false
    
    /// Controls whether the settings view is presented
    @State private var showSettingsView = false
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar - Shows the profile header with back button and menu
            ProfileTopNavigationBar(
                userArchetype: userArchetype,
                showLogoutMenu: $showLogoutMenu,
                showSettingsMenu: $showSettingsMenu,
                onDismiss: onDismiss,
                onLogout: onLogout
            )
            
            // Main content area - Scrollable content with all profile sections
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header Section - Shows user info, stats, and profile picture
                    ProfileHeaderSection(userArchetype: userArchetype)
                    
                    // Bio Section - Shows the user's bio and description
                    ProfileBioSection(userArchetype: userArchetype)
                    
                    // Action Buttons - Edit profile, share profile, etc.
                    ProfileActionButtonsSection()
                    
                    // Content Tabs - Switch between profile and hashtag views
                    ProfileContentTabsSection(selectedContentTab: $selectedContentTab)
                    
                    // Photo Grid - Shows the user's uploaded photos in a grid
                    ProfilePhotoGridSection(
                        uiImages: $uiImages,
                        selectedContentTab: selectedContentTab,
                        showPhotoPicker: $showPhotoPicker
                    )
                    
                    // Bottom spacing to account for the navigation bar
                    Spacer()
                        .frame(height: 100)
                }
            }
            .scrollIndicators(.hidden) // Hide the scroll indicators for cleaner look
            
            // Bottom navigation bar - Fixed at the bottom of the screen
            EraBottomNavigationBar(
                selectedTab: $selectedTab,
                userArchetype: userArchetype,
                onAddPhoto: {
                showPhotoPicker = true
                }
            )
        }
        .background(themeManager.backgroundTop.ignoresSafeArea())
        .navigationBarHidden(true) // Hide the default navigation bar
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedItems,
            maxSelectionCount: 20, // Allow up to 20 photos to be selected
            matching: .images // Only allow image selection
        )
        .onChange(of: selectedItems) { _, newItems in
            // When new photos are selected, load them into the app
            Task {
                await loadImages(from: newItems)
            }
        }
        .onChange(of: selectedTab) { _, newTab in
            // Handle tab changes (e.g., switching between home and profile)
            handleTabChange(newTab)
        }
        .sheet(isPresented: $showSettingsView) {
            // Present the settings view when needed
            SettingsView()
        }
    }
    
    // MARK: - Helper Methods
    /// Loads images from the selected PhotosPickerItem objects
    /// - Parameter items: The selected photo items from the photo picker
    private func loadImages(from items: [PhotosPickerItem]) async {
        // Convert PhotosPickerItem objects to UIImage objects
        // This is done asynchronously to avoid blocking the UI
        var loadedImages: [UIImage] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                loadedImages.append(image)
            }
        }
        
        // Update the UI on the main thread
        await MainActor.run {
            uiImages = loadedImages
        }
    }
    
    /// Handles changes to the selected tab
    /// - Parameter newTab: The newly selected tab
    private func handleTabChange(_ newTab: EraBottomNavigationBar.Tab) {
        // This method can be expanded to handle specific tab change logic
        // For now, it just updates the selected tab state
        selectedTab = newTab
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ProfileView(
        userArchetype: .mainCharacter,
        onDismiss: nil,
        onLogout: nil
    )
    .environmentObject(ThemeManager.shared)
}