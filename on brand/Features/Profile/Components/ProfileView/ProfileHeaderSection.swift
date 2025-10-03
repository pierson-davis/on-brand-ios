//
//  ProfileHeaderSection.swift
//  on brand
//
//  This component displays the main profile header information including
//  profile picture, username, stats, and basic user information.
//  It's designed to look like Instagram's profile header.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Profile Header Section
// This component creates the header section that appears at the top of the profile
struct ProfileHeaderSection: View {
    
    // MARK: - Properties
    /// The user's primary style archetype (used for display and styling)
    let userArchetype: Archetype
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        HStack(spacing: 20) {
            // MARK: - Profile Picture
            // This is the main profile picture displayed prominently
            profilePicture
            
            // MARK: - Stats Section
            // This shows the user's statistics (posts, followers, following)
            statsSection
        }
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.vertical, 20) // Add vertical padding
        .background(themeManager.surface) // Use theme background color
    }
    
    // MARK: - Profile Picture View
    // This creates the circular profile picture with the user's archetype
    private var profilePicture: some View {
        ZStack {
            // MARK: - Background Circle
            // This creates the circular background for the profile picture
            Circle()
                .fill(themeManager.primary.opacity(0.1)) // Light background color
                .frame(width: 100, height: 100) // Fixed size for consistency
            
            // MARK: - Profile Image
            // This shows either the user's actual photo or a placeholder
            // Show the archetype initial as a placeholder
            // Note: Profile image functionality will be added in a future update
            Text(userArchetype.rawValue.prefix(1).uppercased())
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.primary)
            
            // MARK: - Add Photo Button
            // This small button allows users to add or change their profile picture
            VStack {
                Spacer() // Push the button to the bottom
                HStack {
                    Spacer() // Push the button to the right
                    
                    Button(action: {
                        // TODO: Implement photo picker for profile picture
                        print("Add profile picture tapped")
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.caption) // Small font size
                            .foregroundColor(.white) // White color for visibility
                            .frame(width: 24, height: 24) // Fixed size
                            .background(themeManager.primary) // Background color
                            .clipShape(Circle()) // Make it circular
                    }
                }
            }
            .frame(width: 100, height: 100) // Match the profile picture size
        }
    }
    
    // MARK: - Stats Section View
    // This creates the statistics section showing posts, followers, and following
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Username
            // This displays the user's username prominently
            Text(userArchetype.title)
                .font(.title2) // Large font size
                .fontWeight(.bold) // Bold weight for emphasis
                .foregroundColor(themeManager.textPrimary) // Use theme color
            
            // MARK: - Stats Row
            // This shows the three main statistics in a horizontal row
            HStack(spacing: 20) {
                // MARK: - Posts Count
                // This shows how many posts the user has
                VStack(spacing: 4) {
                    Text("12") // TODO: Replace with actual post count
                        .font(.headline) // Prominent font
                        .fontWeight(.semibold) // Slightly bold
                        .foregroundColor(themeManager.textPrimary) // Use theme color
                    
                    Text("posts")
                        .font(.caption) // Small font
                        .foregroundColor(themeManager.textSecondary) // Secondary color
                }
                
                // MARK: - Followers Count
                // This shows how many followers the user has
                VStack(spacing: 4) {
                    Text("1.2K") // TODO: Replace with actual follower count
                        .font(.headline) // Prominent font
                        .fontWeight(.semibold) // Slightly bold
                        .foregroundColor(themeManager.textPrimary) // Use theme color
                    
                    Text("followers")
                        .font(.caption) // Small font
                        .foregroundColor(themeManager.textSecondary) // Secondary color
                }
                
                // MARK: - Following Count
                // This shows how many people the user is following
                VStack(spacing: 4) {
                    Text("456") // TODO: Replace with actual following count
                        .font(.headline) // Prominent font
                        .fontWeight(.semibold) // Slightly bold
                        .foregroundColor(themeManager.textPrimary) // Use theme color
                    
                    Text("following")
                        .font(.caption) // Small font
                        .foregroundColor(themeManager.textSecondary) // Secondary color
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Take up remaining space
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ProfileHeaderSection(userArchetype: .mainCharacter)
        .environmentObject(ThemeManager.shared)
}
