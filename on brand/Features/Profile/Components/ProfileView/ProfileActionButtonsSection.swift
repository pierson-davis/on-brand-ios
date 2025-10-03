//
//  ProfileActionButtonsSection.swift
//  on brand
//
//  This component displays the action buttons for the profile including
//  edit profile, share profile, and other profile-related actions.
//  It's designed to look like Instagram's action buttons section.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Profile Action Buttons Section
// This component creates the action buttons section that appears below the bio
struct ProfileActionButtonsSection: View {
    
    // MARK: - State Properties
    /// Controls whether the edit profile sheet is presented
    @State private var showEditProfile = false
    
    /// Controls whether the share sheet is presented
    @State private var showShareSheet = false
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        HStack(spacing: 8) {
            // MARK: - Edit Profile Button
            // This is the primary action button for editing the profile
            Button(action: {
                showEditProfile = true // Show the edit profile sheet
            }) {
                Text("Edit Profile")
                    .font(.subheadline) // Medium font size
                    .fontWeight(.semibold) // Slightly bold
                    .foregroundColor(themeManager.textPrimary) // Use theme color
                    .frame(maxWidth: .infinity) // Take up available width
                    .frame(height: 32) // Fixed height for consistency
                    .background(themeManager.surface) // Background color
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // Rounded corners
                            .stroke(themeManager.surfaceOutline, lineWidth: 1) // Border
                    )
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
            
            // MARK: - Share Profile Button
            // This button allows users to share their profile
            Button(action: {
                showShareSheet = true // Show the share sheet
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.subheadline) // Medium icon size
                    .foregroundColor(themeManager.textPrimary) // Use theme color
                    .frame(width: 32, height: 32) // Fixed size
                    .background(themeManager.surface) // Background color
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // Rounded corners
                            .stroke(themeManager.surfaceOutline, lineWidth: 1) // Border
                    )
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
            
            // MARK: - More Options Button
            // This button shows additional options
            Button(action: {
                // TODO: Implement more options menu
                print("More options tapped")
            }) {
                Image(systemName: "ellipsis")
                    .font(.subheadline) // Medium icon size
                    .foregroundColor(themeManager.textPrimary) // Use theme color
                    .frame(width: 32, height: 32) // Fixed size
                    .background(themeManager.surface) // Background color
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // Rounded corners
                            .stroke(themeManager.surfaceOutline, lineWidth: 1) // Border
                    )
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button styling
        }
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.vertical, 12) // Add vertical padding
        .background(themeManager.surface) // Use theme background color
        .sheet(isPresented: $showEditProfile) {
            // MARK: - Edit Profile Sheet
            // This presents the edit profile view when the button is tapped
            EditProfileView()
        }
        .sheet(isPresented: $showShareSheet) {
            // MARK: - Share Sheet
            // This presents the system share sheet when the button is tapped
            ShareSheet(activityItems: [
                "Check out my style on the on brand app!",
                URL(string: "https://onbrand.app") ?? URL(string: "https://example.com")!
            ])
        }
    }
}

// MARK: - Edit Profile View
// This is a placeholder view for editing the profile
// TODO: Implement the actual edit profile functionality
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("This feature will be implemented soon!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Share Sheet
// This is a wrapper for the system share sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ProfileActionButtonsSection()
        .environmentObject(ThemeManager.shared)
}
