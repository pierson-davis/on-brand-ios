//
//  ProfilePhotoGridSection.swift
//  on brand
//
//  This component displays the photo grid for the profile including
//  the user's uploaded photos and an add photo button.
//  It's designed to look like Instagram's photo grid section.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI
import PhotosUI

// MARK: - Profile Photo Grid Section
// This component creates the photo grid section that appears below the content tabs
struct ProfilePhotoGridSection: View {
    
    // MARK: - Properties
    /// Binding to the array of user images
    @Binding var uiImages: [UIImage]
    
    /// The currently selected content tab (profile or hashtag)
    let selectedContentTab: ContentTab
    
    /// Binding to control the visibility of the photo picker
    @Binding var showPhotoPicker: Bool
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Constants
    /// Number of columns in the photo grid
    private let gridColumns = 3
    
    /// Spacing between grid items
    private let gridSpacing: CGFloat = 1
    
    // MARK: - Main Body
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: gridColumns),
            spacing: gridSpacing
        ) {
            // MARK: - Add Photo Button
            // This button allows users to add new photos to their profile
            addPhotoButton
            
            // MARK: - Uploaded Photos
            // This displays all the user's uploaded photos
            ForEach(Array(uiImages.enumerated()), id: \.offset) { index, image in
                photoGridItem(image, index: index)
            }
        }
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.top, 16) // Add top padding
        .background(themeManager.surface) // Use theme background color
    }
    
    // MARK: - Add Photo Button
    // This creates the button that allows users to add new photos
    private var addPhotoButton: some View {
        Button(action: {
            showPhotoPicker = true // Show the photo picker
        }) {
            ZStack {
                // MARK: - Background
                // This creates the background for the add photo button
                Rectangle()
                    .fill(themeManager.surface) // Use theme background color
                    .aspectRatio(1, contentMode: .fit) // Square aspect ratio
                
                // MARK: - Border
                // This creates a dashed border to indicate it's a button
                Rectangle()
                    .stroke(
                        themeManager.surfaceOutline, // Use theme outline color
                        style: StrokeStyle(lineWidth: 2, dash: [8, 4]) // Dashed line
                    )
                    .aspectRatio(1, contentMode: .fit) // Square aspect ratio
                
                // MARK: - Add Icon
                // This shows the plus icon to indicate adding
                VStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.title2) // Medium icon size
                        .foregroundColor(themeManager.textSecondary) // Secondary color
                    
                    Text("Add Photo")
                        .font(.caption) // Small font
                        .foregroundColor(themeManager.textSecondary) // Secondary color
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
    
    // MARK: - Photo Grid Item
    // This creates an individual photo item in the grid
    private func photoGridItem(_ image: UIImage, index: Int) -> some View {
        ZStack {
            // MARK: - Photo Image
            // This displays the actual photo
            Image(uiImage: image)
                .resizable() // Allow the image to be resized
                .aspectRatio(1, contentMode: .fill) // Square aspect ratio, fill the space
                .clipped() // Clip any overflow
            
            // MARK: - Overlay on Tap
            // This creates a subtle overlay when the photo is tapped
            Rectangle()
                .fill(Color.black.opacity(0.1)) // Semi-transparent black overlay
                .aspectRatio(1, contentMode: .fit) // Square aspect ratio
                .opacity(0) // Initially invisible
                .onTapGesture {
                    // TODO: Implement photo detail view
                    print("Photo \(index) tapped")
                }
        }
        .aspectRatio(1, contentMode: .fit) // Ensure square aspect ratio
    }
}

// MARK: - Profile Photo Grid Section (Hashtag View)
// This is a specialized version for the hashtag tab
struct ProfilePhotoGridSectionHashtag: View {
    
    // MARK: - Properties
    /// Binding to the array of user images
    @Binding var uiImages: [UIImage]
    
    /// Binding to control the visibility of the photo picker
    @Binding var showPhotoPicker: Bool
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Constants
    /// Number of columns in the photo grid
    private let gridColumns = 3
    
    /// Spacing between grid items
    private let gridSpacing: CGFloat = 1
    
    // MARK: - Main Body
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: gridColumns),
            spacing: gridSpacing
        ) {
            // MARK: - Hashtag Content
            // This shows hashtag-related content instead of photos
            ForEach(0..<9) { index in
                hashtagGridItem(index: index)
            }
        }
        .padding(.horizontal, 16) // Add horizontal padding
        .padding(.top, 16) // Add top padding
        .background(themeManager.surface) // Use theme background color
    }
    
    // MARK: - Hashtag Grid Item
    // This creates an individual hashtag item in the grid
    private func hashtagGridItem(index: Int) -> some View {
        ZStack {
            // MARK: - Background
            // This creates the background for the hashtag item
            Rectangle()
                .fill(themeManager.surface) // Use theme background color
                .aspectRatio(1, contentMode: .fit) // Square aspect ratio
            
            // MARK: - Border
            // This creates a border around the hashtag item
            Rectangle()
                .stroke(themeManager.surfaceOutline, lineWidth: 1) // Use theme outline color
                .aspectRatio(1, contentMode: .fit) // Square aspect ratio
            
            // MARK: - Hashtag Content
            // This shows the hashtag content
            VStack(spacing: 4) {
                Image(systemName: "number")
                    .font(.title2) // Medium icon size
                    .foregroundColor(themeManager.textSecondary) // Secondary color
                
                Text("#\(index + 1)")
                    .font(.caption) // Small font
                    .foregroundColor(themeManager.textSecondary) // Secondary color
            }
        }
        .aspectRatio(1, contentMode: .fit) // Ensure square aspect ratio
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 0) {
        ProfilePhotoGridSection(
            uiImages: .constant([]),
            selectedContentTab: .profile,
            showPhotoPicker: .constant(false)
        )
        
        Divider()
        
        ProfilePhotoGridSectionHashtag(
            uiImages: .constant([]),
            showPhotoPicker: .constant(false)
        )
    }
    .environmentObject(ThemeManager.shared)
}
