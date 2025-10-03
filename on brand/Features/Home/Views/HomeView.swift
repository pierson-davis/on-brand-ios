//
//  HomeView.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var profileService = UserProfileService.shared
    @State private var selectedTab: EraBottomNavigationBar.Tab = .home
    @State private var showingPhotoPicker = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    let onLogout: () -> Void
    
    var body: some View {
        ZStack {
            EraBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main content based on selected tab
                TabView(selection: $selectedTab) {
                    homeContent
                        .tag(EraBottomNavigationBar.Tab.home)
                    
                    dealsContent
                        .tag(EraBottomNavigationBar.Tab.deals)
                    
                    profileContent
                        .tag(EraBottomNavigationBar.Tab.profile)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
            
            // Bottom navigation
            VStack {
                Spacer()
                EraBottomNavigationBar(selectedTab: $selectedTab, userArchetype: profileService.currentProfile?.primaryArchetype ?? .mainCharacter, onAddPhoto: {
                    showingPhotoPicker = true
                })
            }
        }
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: .constant([]),
            maxSelectionCount: 12,
            matching: .images
        )
    }
    
    // MARK: - Tab Content
    
    private var homeContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome message
                VStack(alignment: .leading, spacing: 4) {
                    if let profile = profileService.currentProfile {
                        Text("Welcome back, \(profile.name)!")
                            .font(.title2.bold())
                            .foregroundColor(themeManager.textPrimary)
                    } else {
                        Text("Welcome back!")
                            .font(.title2.bold())
                            .foregroundColor(themeManager.textPrimary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                
                // Quick stats or recent activity
                if let profile = profileService.currentProfile {
                    VibeSummaryCard(result: VibeResult(
                        primary: profile.primaryArchetype,
                        secondary: profile.secondaryArchetype,
                        description: profile.description
                    )) {
                        selectedTab = .profile
                    }
                    .padding(.horizontal, 24)
                }
                
                // Recent photos section
                recentPhotosSection
                
                // Quick actions
                quickActionsSection
                
                Spacer(minLength: 100) // Space for bottom navigation
            }
        }
    }
    
    
    private var dealsContent: some View {
        CreatorRequirementsView()
            .environmentObject(themeManager)
    }
    
    private var profileContent: some View {
        Group {
            if let profile = profileService.currentProfile {
                InstagramProfileView(
                    userArchetype: profile.primaryArchetype,
                    onDismiss: nil,
                    onLogout: onLogout
                )
            } else {
                // Fallback if no profile
                VStack {
                    Text("No profile found")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Button("Logout") {
                        onLogout()
                    }
                    .buttonStyle(EraPrimaryButtonStyle())
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Recent Photos Section
    
    private var recentPhotosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Photos")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("View All") {
                    selectedTab = .profile
                }
                .font(.subheadline)
                .foregroundColor(Color(red: 0.20, green: 0.22, blue: 0.75))
            }
            .padding(.horizontal, 24)
            
            if let profile = profileService.currentProfile, !profile.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(profile.photos.prefix(5)) { photo in
                            PhotoThumbnailView(photo: photo)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(themeManager.subtleText)
                    
                    Text("No photos yet")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Button("Add Your First Photo") {
                        showingPhotoPicker = true
                    }
                    .font(.caption)
                    .foregroundColor(themeManager.primary)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Quick Actions Section
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Analyze Photo",
                    icon: "camera.fill",
                    action: { showingPhotoPicker = true }
                )
                
                QuickActionButton(
                    title: "View Profile",
                    icon: "person.circle.fill",
                    action: { selectedTab = .profile }
                )
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Supporting Views
