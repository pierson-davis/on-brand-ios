//
//  ProfileTopNavigationBar.swift
//  on brand
//
//  This component handles the top navigation bar for the profile view.
//  It includes the back button, profile title, and menu options.
//  It's designed to look like Instagram's top navigation bar.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Profile Top Navigation Bar
// This component creates the top navigation bar that appears at the top of the profile view
struct ProfileTopNavigationBar: View {
    
    // MARK: - Properties
    /// The user's primary style archetype (used for display purposes)
    let userArchetype: Archetype
    
    /// Binding to control the visibility of the logout confirmation menu
    @Binding var showLogoutMenu: Bool
    
    /// Binding to control the visibility of the settings menu
    @Binding var showSettingsMenu: Bool
    
    /// Optional callback when the back button is tapped
    let onDismiss: (() -> Void)?
    
    /// Optional callback when the logout option is selected
    let onLogout: (() -> Void)?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        HStack {
            // MARK: - Back Button
            // This button allows the user to go back to the previous screen
            Button(action: {
                onDismiss?() // Call the dismiss callback if provided
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2) // Use title2 font size for good visibility
                    .foregroundColor(themeManager.textPrimary) // Use theme color for consistency
            }
            .frame(width: 44, height: 44) // Fixed size for consistent touch target
            
            Spacer() // Push the title to the center
            
            // MARK: - Profile Title
            // This shows the user's profile handle (e.g., @maincharacter)
            Text("@\(userArchetype.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.headline) // Use headline font for prominence
                .fontWeight(.semibold) // Make it slightly bold
                .foregroundColor(themeManager.textPrimary) // Use theme color
                .lineLimit(1) // Prevent text wrapping
            
            Spacer() // Push the menu button to the right
            
            // MARK: - Menu Button
            // This button shows additional options (settings, logout, etc.)
            Button(action: {
                showSettingsMenu = true // Show the settings menu
            }) {
                Image(systemName: "ellipsis")
                    .font(.title2) // Use title2 font size
                    .foregroundColor(themeManager.textPrimary) // Use theme color
            }
            .frame(width: 44, height: 44) // Fixed size for consistent touch target
        }
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.top, 8) // Add top padding
        .padding(.bottom, 16) // Add bottom padding
        .background(themeManager.surface) // Use theme background color
        .overlay(
            // Add a subtle border at the bottom
            Rectangle()
                .frame(height: 1)
                .foregroundColor(themeManager.surfaceOutline),
            alignment: .bottom
        )
        .confirmationDialog(
            "Profile Options", // Title for the confirmation dialog
            isPresented: $showSettingsMenu, // Control visibility
            titleVisibility: .visible // Show the title
        ) {
            // MARK: - Settings Option
            Button("Settings") {
                // This would open the settings view
                // Implementation depends on your navigation structure
            }
            
            // MARK: - Logout Option
            Button("Logout", role: .destructive) {
                showLogoutMenu = true // Show logout confirmation
            }
            
            // MARK: - Cancel Option
            Button("Cancel", role: .cancel) {
                // This automatically dismisses the menu
            }
        }
        .confirmationDialog(
            "Logout", // Title for logout confirmation
            isPresented: $showLogoutMenu, // Control visibility
            titleVisibility: .visible // Show the title
        ) {
            // MARK: - Confirm Logout
            Button("Logout", role: .destructive) {
                onLogout?() // Call the logout callback
            }
            
            // MARK: - Cancel Logout
            Button("Cancel", role: .cancel) {
                // This automatically dismisses the menu
            }
        } message: {
            // MARK: - Logout Confirmation Message
            Text("Are you sure you want to logout? This will end your current session.")
        }
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ProfileTopNavigationBar(
        userArchetype: .mainCharacter,
        showLogoutMenu: .constant(false),
        showSettingsMenu: .constant(false),
        onDismiss: nil,
        onLogout: nil
    )
    .environmentObject(ThemeManager.shared)
}
