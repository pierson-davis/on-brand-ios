//
//  InstagramProfileView.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI
import PhotosUI

struct InstagramProfileView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var uiImages: [UIImage] = []
    @State private var isAnalyzing = false
    @State private var analysisResults: [AIImageAnalysisResponse] = []
    @State private var selectedTab: EraBottomNavigationBar.Tab = .profile
    @State private var showPhotoPicker = false
    @State private var selectedContentTab: ContentTab = .profile
    @State private var showLogoutMenu = false
    @State private var showSettingsView = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    let userArchetype: Archetype
    let onDismiss: (() -> Void)?
    let onLogout: (() -> Void)?
    
    // Computed properties
    private var averageConfidenceScore: Int {
        guard !analysisResults.isEmpty else { return 0 }
        let total = analysisResults.reduce(0) { $0 + $1.confidenceScore }
        return total / analysisResults.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Instagram-style Top Navigation Bar
            instagramTopBar
            
            // Main content area
            ScrollView {
                VStack(spacing: 0) {
                    // Instagram-style Profile Header
                    instagramProfileHeader
                    
                    // Instagram-style Action Buttons
                    instagramActionButtons
                    
                    // Instagram-style Content Tabs
                    instagramContentTabs
                    
                    // Instagram-style Photo Grid
                    instagramPhotoGrid
                    
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
                uiImages = await loadImages(from: newItems)
                await analyzePhotos()
            }
        }
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
    
    // MARK: - Instagram-style Top Navigation Bar
    
    private var instagramTopBar: some View {
        HStack {
            // Left side - Back button or empty space
            Spacer()
                .frame(width: 24)
            
            Spacer()
            
            // Center - Username (Instagram style)
            Text("@pierson_davis")
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
    }
    
    // MARK: - Instagram-style Profile Header
    
    private var instagramProfileHeader: some View {
        VStack(spacing: 0) {
            // Profile info row - Instagram style
            HStack(spacing: 0) {
                // Profile picture
                Circle()
                    .fill(LinearGradient(
                        colors: selectedContentTab == .profile ? 
                            [userArchetype.primaryColor, userArchetype.secondaryColor] :
                            [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 86, height: 86)
                    .overlay(
                        Group {
                            if selectedContentTab == .profile {
                                Text("✨")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            } else {
                                // Blank profile picture for Instagram mode
                                Circle()
                                    .fill(themeManager.buttonBackground)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(themeManager.subtleText)
                                    )
                            }
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(themeManager.separator, lineWidth: 1)
                    )
                
                Spacer()
                
                // Stats row - Dynamic based on selected tab
                HStack(spacing: 0) {
                    if selectedContentTab == .profile {
                        // Vibe Profile stats
                        VStack(spacing: 2) {
                            Text("\(uiImages.count)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("posts")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("\(averageConfidenceScore)%")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("match")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("\(analysisResults.count)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("analyzed")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        // Instagram style stats
                        VStack(spacing: 2) {
                            Text("15")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("posts")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("944")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("followers")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("888")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("following")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Name and bio section
            VStack(alignment: .leading, spacing: 6) {
                Text("Pierson Davis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("NYC")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - Instagram-style Action Buttons
    
    private var instagramActionButtons: some View {
        HStack(spacing: 8) {
            // Edit Profile button (Instagram style)
            Button(action: {
                // Edit profile action
            }) {
                Text("Edit profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
            
            // Share Profile button
            Button(action: {
                // Share profile action
            }) {
                Text("Share profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
            
            // Add Photo button (Instagram style)
            Button(action: {
                showPhotoPicker = true
            }) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
    
    // MARK: - Instagram-style Content Tabs
    
    private var instagramContentTabs: some View {
        HStack(spacing: 0) {
            // Vibe Profile tab (left)
            Button(action: {
                selectedContentTab = .profile
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(selectedContentTab == .profile ? themeManager.textPrimary : themeManager.tabBarInactive)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(selectedContentTab == .profile ? themeManager.textPrimary : Color.clear)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
            
            // Instagram Posts tab (right)
            Button(action: {
                selectedContentTab = .hashtag
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(selectedContentTab == .hashtag ? themeManager.textPrimary : themeManager.tabBarInactive)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(selectedContentTab == .hashtag ? themeManager.textPrimary : Color.clear)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
        }
        .padding(.horizontal, 16)
        .background(themeManager.backgroundTop)
    }
    
    // MARK: - Instagram-style Photo Grid
    
    private var instagramPhotoGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
            if uiImages.isEmpty {
                // Show placeholder grid
                ForEach(0..<9) { index in
                    Rectangle()
                        .fill(themeManager.buttonBackground)
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(themeManager.subtleText)
                        )
                }
            } else {
                // Show actual photos
                ForEach(Array(uiImages.enumerated()), id: \.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .overlay(
                            // Loading indicator for analyzing photos
                            Group {
                                if isAnalyzing && index < analysisResults.count {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                            }
                        )
                }
            }
        }
        .background(themeManager.backgroundTop)
    }
    
    // MARK: - Helper Functions
    
    private func loadImages(from items: [PhotosPickerItem]) async -> [UIImage] {
        var images: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                images.append(uiImage)
            }
        }
        return images
    }
    
    private func analyzePhotos() async {
        isAnalyzing = true
        // Simulate AI analysis
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        analysisResults = [
            AIImageAnalysisResponse(
                confidenceScore: 90,
                analysis: "This image shows a main character style with bold, vibrant colors.",
                suggestions: "Consider adding more contrast and dynamic poses."
            )
        ]
        isAnalyzing = false
    }
}
