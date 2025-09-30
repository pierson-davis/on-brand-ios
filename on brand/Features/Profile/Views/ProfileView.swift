//
//  ProfileView.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI
import PhotosUI

enum ContentTab {
    case profile
    case hashtag
}

struct ProfileView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var uiImages: [UIImage] = []
    @State private var isAnalyzing = false
    @State private var analysisResults: [AIImageAnalysisResponse] = []
    @State private var selectedTab: EraBottomNavigationBar.Tab = .profile
    @State private var showPhotoPicker = false
    @State private var selectedContentTab: ContentTab = .profile
    @State private var showLogoutMenu = false
    @State private var showSettingsMenu = false
    @State private var showSettingsView = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    let userArchetype: Archetype
    let onDismiss: (() -> Void)?
    let onLogout: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            instagramTopBar
            
            // Main content area
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header Section
                    profileHeaderSection
                    
                    // Bio Section
                    bioSection
                    
                    // Action Buttons
                    actionButtonsSection
                    
                    // Content Tabs
                    contentTabsSection
                    
                    // Photo Grid
                    photoGridSection
                    
                    // Add bottom padding to account for navigation bar
                    Spacer()
                        .frame(height: 100)
                }
            }
            .scrollIndicators(.hidden)
            
            // Bottom navigation bar - Fixed positioning
            EraBottomNavigationBar(selectedTab: $selectedTab, userArchetype: userArchetype, onAddPhoto: {
                showPhotoPicker = true
            })
        }
        .background(themeManager.backgroundTop.ignoresSafeArea())
        .navigationBarHidden(true)
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedItems,
            maxSelectionCount: 20,
            matching: .images
        )
        .onChange(of: selectedItems) { _, newItems in
            Task {
                await loadImages(from: newItems)
            }
        }
        .onChange(of: selectedTab) { _, newTab in
            handleTabChange(newTab)
        }
    }
    
    // MARK: - Instagram-style Top Navigation Bar
    
    private var instagramTopBar: some View {
        HStack {
            // Left side - Back button or empty space
            Spacer()
                .frame(width: 24)
            
            Spacer()
            
            // Center - Username (Instagram style)
            Text("@\(userArchetype.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Right side - Menu button
            Button(action: {
                showLogoutMenu = true
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(themeManager.textPrimary)
            }
            .frame(width: 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(themeManager.backgroundTop)
        .confirmationDialog("Options", isPresented: $showLogoutMenu) {
            Button("Settings") {
                showSettingsView = true
            }
            Button("Toggle Dark Mode") {
                themeManager.toggleTheme()
            }
            Button("Logout", role: .destructive) {
                onLogout?()
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
                .environmentObject(themeManager)
        }
    }
    
    // MARK: - Profile Header Section
    
    private var profileHeaderSection: some View {
        HStack(spacing: 20) {
            // Profile picture - always use ZStack for consistent layout
            ZStack {
                if selectedContentTab == .hashtag {
                    // Instagram style profile picture
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                } else {
                    // Vibe profile picture
                    Circle()
                        .fill(LinearGradient(
                            colors: [userArchetype.primaryColor, userArchetype.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 90, height: 90)
                }
                
                // Only show sparkle for vibe profile
                if selectedContentTab == .profile {
                    Text("✨")
                        .font(.system(size: 36))
                }
            }
            .frame(width: 90, height: 90) // Fixed frame to prevent movement
            
            // Stats - use fixed width to prevent movement
            HStack(spacing: 40) {
                if selectedContentTab == .hashtag {
                    // Instagram style stats
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("posts")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("followers")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("following")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                } else {
                    // Vibe profile stats
                    VStack {
                        Text("\(uiImages.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("posts")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("\(averageConfidenceScore)%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("match")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("\(analysisResults.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("analyzed")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    // MARK: - Bio Section
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 6) { // Fixed spacing for stability
            if selectedContentTab == .hashtag {
                // Instagram style bio
                Text("Pierson")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("nyc")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                Button(action: {
                    if let url = URL(string: "https://instagram.com/piersonrdavis") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("instagram.com/piersonrdavis")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            } else {
                // Vibe profile bio
                Text(userArchetype.title.uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(userArchetype.blurb)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                
                Text(userArchetype.analysis)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 120) // Fixed minimum height to prevent layout shifts
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    // MARK: - Action Buttons Section
    
    private var actionButtonsSection: some View {
        HStack(spacing: 8) {
            // Left button - Vibe Profile
            Button(action: {
                // TODO: Navigate to vibe profile
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "number")
                        .font(.system(size: 14, weight: .medium))
                    Text("Your Vibe Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(8)
            }
            
            // Right button - Instagram
            Button(action: {
                // TODO: Open Instagram profile
                if let url = URL(string: "https://instagram.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 14, weight: .medium))
                    Text("Instagram")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.0, blue: 0.8),
                            Color(red: 0.8, green: 0.2, blue: 0.4),
                            Color(red: 1.0, green: 0.6, blue: 0.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    // MARK: - Content Tabs Section
    
    private var contentTabsSection: some View {
        HStack(spacing: 0) {
            // Hashtag tab (left)
            Button(action: {
                selectedContentTab = .hashtag
            }) {
                Image(systemName: "number")
                    .font(.title2)
                    .foregroundColor(selectedContentTab == .hashtag ? .black : .gray)
                    .frame(width: 44, height: 44) // Fixed frame for stability
            }
            .frame(maxWidth: .infinity)
            
            // Profile tab (right)
            Button(action: {
                selectedContentTab = .profile
            }) {
                Image(systemName: "person.crop.rectangle")
                    .font(.title2)
                    .foregroundColor(selectedContentTab == .profile ? .black : .gray)
                    .frame(width: 44, height: 44) // Fixed frame for stability
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 60) // Fixed height to prevent movement
        .background(Color.white)
    }
    
    // MARK: - Photo Grid Section
    
    private var photoGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
            // Add Photo Button
            addPhotoButton
            
            // Uploaded Photos
            ForEach(Array(uiImages.enumerated()), id: \.offset) { index, image in
                photoGridItem(image, index: index)
            }
        }
    }
    
    private var addPhotoButton: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 20,
            matching: .images
        ) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.7))
                        Text("Add")
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.7))
                    }
                )
        }
    }
    
    private func photoGridItem(_ image: UIImage, index: Int) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            // Instagram-style white square in corner
            VStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .cornerRadius(2)
                }
                Spacer()
            }
            .padding(4)
        }
    }
    
    private func confidenceBadge(_ score: Int) -> some View {
        Text("\(score)%")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(scoreColor(score).opacity(0.9))
            )
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 60...79: return .orange
        default: return .red
        }
    }
    
    // MARK: - Analysis Card
    
    private func analysisCard(_ result: AIImageAnalysisResponse, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Photo \(index + 1)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                confidenceBadge(result.confidenceScore)
            }
            
            Text(result.analysis)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let suggestions = result.suggestions {
                Text("💡 \(suggestions)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Computed Properties
    
    private var averageConfidenceScore: Int {
        guard !analysisResults.isEmpty else { return 0 }
        let total = analysisResults.map { $0.confidenceScore }.reduce(0, +)
        return total / analysisResults.count
    }
    
    // MARK: - Methods
    
    private func loadImages(from items: [PhotosPickerItem]) async {
        var loadedImages: [UIImage] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                loadedImages.append(image)
            }
        }
        
        let finalImages = loadedImages
        await MainActor.run {
            uiImages.append(contentsOf: finalImages)
        }
    }
    
    private func analyzeProfile() {
        guard !uiImages.isEmpty else { return }
        
        isAnalyzing = true
        
        // Simplified analysis for better performance
        let results = uiImages.enumerated().map { index, _ in
            AIImageAnalysisResponse(
                confidenceScore: Int.random(in: 60...95),
                analysis: "Mock analysis for \(userArchetype.title) vibe",
                suggestions: "Mock suggestions for improvement"
            )
        }
        
        analysisResults = results
        isAnalyzing = false
    }
    
    private func handleTabChange(_ tab: EraBottomNavigationBar.Tab) {
        switch tab {
        case .home:
            onDismiss?()
        case .plus:
            showPhotoPicker = true
        case .profile:
            // Already on profile
            break
        }
    }
}

// MARK: - Simplified Preview Components

struct ProfileViewPreview: View {
    let userArchetype: Archetype
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("@\(userArchetype.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 16)
            .background(Color.white)
            
            // Main content area
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header Section
                    profileHeaderSection
                    
                    // Bio Section
                    bioSection
                    
                    // Action Buttons
                    actionButtonsSection
                    
                    // Content Tabs
                    contentTabsSection
                    
                    // Photo Grid Placeholder
                    photoGridPlaceholder
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .scrollIndicators(.hidden)
            
            // Bottom navigation bar
            EraBottomNavigationBar(selectedTab: .constant(.profile), userArchetype: userArchetype, onAddPhoto: nil)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    private var profileHeaderSection: some View {
        HStack(spacing: 20) {
            // Profile picture
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [userArchetype.primaryColor, userArchetype.secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 90, height: 90)
                
                Text("✨")
                    .font(.system(size: 36))
            }
            .frame(width: 90, height: 90)
            
            // Stats
            HStack(spacing: 40) {
                VStack {
                    Text("12")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("posts")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(minWidth: 50)
                
                VStack {
                    Text("87%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("match")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(minWidth: 50)
                
                VStack {
                    Text("8")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("analyzed")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(minWidth: 50)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(userArchetype.title.uppercased())
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(userArchetype.blurb)
                .font(.subheadline)
                .foregroundColor(.black)
                .fontWeight(.medium)
            
            Text(userArchetype.analysis)
                .font(.subheadline)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 120)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "number")
                        .font(.system(size: 14, weight: .medium))
                    Text("Your Vibe Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(8)
            }
            
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 14, weight: .medium))
                    Text("Instagram")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var contentTabsSection: some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                Text("Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.black),
                        alignment: .bottom
                    )
            }
            
            Button(action: {}) {
                Text("Hashtag")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
            }
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    private var photoGridPlaceholder: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 3), spacing: 2) {
            ForEach(0..<9) { index in
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Text("\(index + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

