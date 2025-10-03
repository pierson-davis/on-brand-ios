//
//  ProfileContentTabsSection.swift
//  on brand
//
//  This component displays the content tabs for switching between
//  different views in the profile (e.g., profile posts vs hashtag posts).
//  It's designed to look like Instagram's content tabs section.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Profile Content Tabs Section
// This component creates the content tabs section that appears below the action buttons
struct ProfileContentTabsSection: View {
    
    // MARK: - Properties
    /// Binding to track which content tab is currently selected
    @Binding var selectedContentTab: ContentTab
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        HStack(spacing: 0) {
            // MARK: - Profile Tab (Left)
            // This tab shows the user's profile posts/content
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedContentTab = .profile // Switch to profile tab
                }
            }) {
                VStack(spacing: 4) {
                    // MARK: - Profile Tab Icon
                    Image(systemName: "person.crop.rectangle")
                        .font(.title2) // Medium icon size
                        .foregroundColor(selectedContentTab == .profile ? 
                                       themeManager.textPrimary : // Selected color
                                       themeManager.textSecondary) // Unselected color
                        .frame(width: 44, height: 44) // Fixed size for stability
                    
                    // MARK: - Profile Tab Label
                    Text("Profile")
                        .font(.caption) // Small font
                        .foregroundColor(selectedContentTab == .profile ? 
                                       themeManager.textPrimary : // Selected color
                                       themeManager.textSecondary) // Unselected color
                }
            }
            .frame(maxWidth: .infinity) // Take up half the width
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
            
            // MARK: - Hashtag Tab (Right)
            // This tab shows hashtag-related content
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedContentTab = .hashtag // Switch to hashtag tab
                }
            }) {
                VStack(spacing: 4) {
                    // MARK: - Hashtag Tab Icon
                    Image(systemName: "number")
                        .font(.title2) // Medium icon size
                        .foregroundColor(selectedContentTab == .hashtag ? 
                                       themeManager.textPrimary : // Selected color
                                       themeManager.textSecondary) // Unselected color
                        .frame(width: 44, height: 44) // Fixed size for stability
                    
                    // MARK: - Hashtag Tab Label
                    Text("Hashtag")
                        .font(.caption) // Small font
                        .foregroundColor(selectedContentTab == .hashtag ? 
                                       themeManager.textPrimary : // Selected color
                                       themeManager.textSecondary) // Unselected color
                }
            }
            .frame(maxWidth: .infinity) // Take up half the width
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
        }
        .frame(height: 60) // Fixed height to prevent movement
        .background(themeManager.surface) // Use theme background color
        .overlay(
            // MARK: - Bottom Border
            // This adds a subtle border at the bottom of the tabs
            Rectangle()
                .frame(height: 1)
                .foregroundColor(themeManager.surfaceOutline),
            alignment: .bottom
        )
        .overlay(
            // MARK: - Selection Indicator
            // This shows which tab is currently selected
            selectionIndicator,
            alignment: .bottom
        )
    }
    
    // MARK: - Selection Indicator
    // This creates the visual indicator showing which tab is selected
    private var selectionIndicator: some View {
        HStack {
            if selectedContentTab == .profile {
                // MARK: - Profile Tab Indicator
                Rectangle()
                    .fill(themeManager.primary) // Use theme color
                    .frame(width: 100, height: 2) // Fixed width and height
                    .animation(.easeInOut(duration: 0.2), value: selectedContentTab) // Smooth animation
            } else {
                Spacer() // Empty space when profile is not selected
            }
            
            Spacer() // Space between indicators
            
            if selectedContentTab == .hashtag {
                // MARK: - Hashtag Tab Indicator
                Rectangle()
                    .fill(themeManager.primary) // Use theme color
                    .frame(width: 100, height: 2) // Fixed width and height
                    .animation(.easeInOut(duration: 0.2), value: selectedContentTab) // Smooth animation
            } else {
                Spacer() // Empty space when hashtag is not selected
            }
        }
        .padding(.horizontal, 16) // Add horizontal padding to match the tabs
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 0) {
        ProfileContentTabsSection(selectedContentTab: .constant(.profile))
        ProfileContentTabsSection(selectedContentTab: .constant(.hashtag))
    }
    .environmentObject(ThemeManager.shared)
}
