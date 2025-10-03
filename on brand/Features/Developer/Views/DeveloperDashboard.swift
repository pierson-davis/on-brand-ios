//
//  DeveloperDashboard.swift
//  on brand
//
//  This is the main developer dashboard that provides quick access to all
//  app screens and development tools. It's designed to be the most simple
//  but effective implementation for developers.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import Photos

// MARK: - Developer Dashboard
// This is the main developer dashboard that provides quick access to all app screens
struct DeveloperDashboard: View {
    
    // MARK: - State Properties
    /// Controls whether the dashboard is currently visible
    @State private var isDashboardVisible = true
    
    /// Controls the current theme for testing
    @State private var selectedTheme: ThemeManager.ThemeMode = .system
    
    /// Controls whether debug mode is enabled
    @State private var isDebugModeEnabled = false
    
    /// Controls whether the screenshot generator is visible
    @State private var showScreenshotGenerator = false
    
    // MARK: - Shake Test Callback
    /// Callback for testing shake gesture simulation
    var onShakeTest: (() -> Void)?
    
    /// Controls whether the theme tester is visible
    @State private var showThemeTester = false
    
    /// Controls whether the debug tools are visible
    @State private var showDebugTools = false
    
    /// Stores debug logs for the developer
    @State private var debugLogs: [String] = []
    
    /// Controls whether the app info is visible
    @State private var showAppInfo = false
    
    /// Controls whether the performance monitor is visible
    @State private var showPerformanceMonitor = false
    
    /// Controls whether the Firebase test is visible
    @State private var showFirebaseTest = false
    
    /// Controls whether the data management is visible
    @State private var showDataManagement = false
    
    /// Controls whether the creator requirements is visible
    @State private var showCreatorRequirements = false
    
    /// Controls whether the AI settings is visible
    @State private var showAISettings = false
    
    /// Controls whether the API debug view is visible
    @State private var showAPIDebug = false
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Navigation Manager
    /// Navigation manager for developer dashboard
    @StateObject private var developerNavigationManager = DeveloperNavigationManager.shared
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                EraBackground()
                    .ignoresSafeArea()
                
                if developerNavigationManager.isDashboardVisible {
                    dashboardContent
                } else if let currentScreen = developerNavigationManager.currentScreen {
                    developerNavigationManager.viewForScreen(currentScreen)
                        .environmentObject(themeManager)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Back") {
                                    developerNavigationManager.goBack()
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Dashboard") {
                                    developerNavigationManager.returnToDashboard()
                                }
                            }
                        }
                } else {
                    dashboardContent
                }
            }
            .navigationTitle("Developer Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if developerNavigationManager.isDashboardVisible {
                            // Show additional tools
                        } else {
                            developerNavigationManager.returnToDashboard()
                        }
                    }) {
                        Image(systemName: developerNavigationManager.isDashboardVisible ? "gearshape.fill" : "house.fill")
                            .foregroundColor(themeManager.primary)
                    }
                }
            }
        }
        // Screenshot Generator temporarily disabled
        // .sheet(isPresented: $showScreenshotGenerator) {
        //     ScreenshotGeneratorView()
        //         .environmentObject(themeManager)
        // }
        .sheet(isPresented: $showThemeTester) {
            ThemeTesterView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showDebugTools) {
            DebugToolsView(debugLogs: $debugLogs)
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showAppInfo) {
            AppInfoView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showPerformanceMonitor) {
            PerformanceMonitorView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showDataManagement) {
            DataManagementView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showCreatorRequirements) {
            CreatorRequirementsView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showAISettings) {
            AISettingsView()
                .environmentObject(themeManager)
        }
                .sheet(isPresented: $showFirebaseTest) {
                    // FirebaseTestView() // TODO: Re-enable after adding to Xcode project
                    Text("Firebase Test View - Coming Soon")
                        .foregroundColor(.secondary)
                        .environmentObject(themeManager)
                }
        .sheet(isPresented: $showAPIDebug) {
            APIDebugView()
                .environmentObject(themeManager)
        }
    }
    
    // MARK: - Dashboard Content
    /// The main content of the developer dashboard
    private var dashboardContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Header Section
                // This shows the dashboard title and quick info
                headerSection
                
                // MARK: - Quick Actions Section
                // This provides quick access to common development tasks
                quickActionsSection
                
                // MARK: - App Screens Section
                // This provides navigation to all app screens
                appScreensSection
                
                // MARK: - Development Tools Section
                // This provides access to development and debugging tools
                developmentToolsSection
                
                // MARK: - Debug Info Section
                // This shows current app state and debug information
                debugInfoSection
            }
            .padding()
        }
    }
    
    // MARK: - Header Section
    /// The header section with dashboard title and quick info
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Dashboard Icon with Animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                themeManager.primary,
                                themeManager.secondary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: themeManager.primary.opacity(0.3),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
            Image(systemName: "hammer.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Title and Subtitle
            VStack(spacing: 8) {
            Text("Developer Dashboard")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.textPrimary)
            
            Text("Quick access to all app screens and development tools")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Status Indicators
            HStack(spacing: 16) {
                // Theme Indicator
                statusIndicator(
                    icon: "paintbrush.fill",
                    title: "Theme",
                    value: themeManager.themeMode.displayName,
                    color: themeManager.primary
                )
                
                // Debug Mode Indicator
                statusIndicator(
                    icon: "ladybug.fill",
                    title: "Debug",
                    value: isDebugModeEnabled ? "On" : "Off",
                    color: isDebugModeEnabled ? .green : .gray
                )
                
                // App Status Indicator
                statusIndicator(
                    icon: "checkmark.circle.fill",
                    title: "Status",
                    value: "Ready",
                    color: .green
                )
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Status Indicator
    /// Creates a status indicator with icon, title, and value
    private func statusIndicator(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(themeManager.textSecondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textPrimary)
        }
        .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
            RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                    RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
    }
    
    // MARK: - Quick Actions Section
    /// Quick actions for common development tasks
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Quick Actions", icon: "bolt.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                    // Screenshot Generator - Temporarily Disabled
                    enhancedQuickActionButton(
                    title: "Screenshots",
                        subtitle: "Coming soon",
                    icon: "camera.fill",
                        color: .gray,
                        action: { 
                            addDebugLog("Screenshot generator temporarily disabled")
                        }
                    )
                    
                    // Shake Test Button - For Testing Shake Detection
                    enhancedQuickActionButton(
                        title: "Test Shake",
                        subtitle: "Simulate shake gesture",
                        icon: "iphone.radiowaves.left.and.right",
                        color: .orange,
                        action: { 
                            addDebugLog("Testing shake gesture simulation")
                            onShakeTest?()
                        }
                )
                
                // Theme Tester
                enhancedQuickActionButton(
                    title: "Theme Test",
                    subtitle: "Test all themes",
                    icon: "paintbrush.fill",
                    color: .purple,
                    action: { showThemeTester = true }
                )
                
                // Debug Tools
                enhancedQuickActionButton(
                    title: "Debug Tools",
                    subtitle: "Logs & monitoring",
                    icon: "wrench.fill",
                    color: .orange,
                    action: { showDebugTools = true }
                )
                
                // App Info
                enhancedQuickActionButton(
                    title: "App Info",
                    subtitle: "Version & details",
                    icon: "info.circle.fill",
                    color: .green,
                    action: { showAppInfo = true }
                )
                
        // AI Settings
        enhancedQuickActionButton(
            title: "AI Settings",
            subtitle: "Configure OpenAI API",
            icon: "brain.head.profile",
            color: .blue,
            action: { showAISettings = true }
        )
        
        // API Debug
        enhancedQuickActionButton(
            title: "API Debug",
            subtitle: "Test API key loading",
            icon: "ladybug",
            color: .orange,
            action: { showAPIDebug = true }
        )
        
        // Firebase Test
        enhancedQuickActionButton(
            title: "Firebase Test",
            subtitle: "Test Firebase connectivity",
            icon: "flame.fill",
            color: .red,
            action: { 
                addDebugLog("Firebase testing started")
                showFirebaseTest = true
            }
        )
                
                // Performance Monitor
                enhancedQuickActionButton(
                    title: "Performance",
                    subtitle: "Monitor metrics",
                    icon: "speedometer",
                    color: .red,
                    action: { 
                        addDebugLog("Performance monitoring started")
                        showPerformanceMonitor = true
                    }
                )
                
                // Data Management
                enhancedQuickActionButton(
                    title: "Data Tools",
                    subtitle: "Clear & reset",
                    icon: "trash.fill",
                    color: .gray,
                    action: { 
                        addDebugLog("Data management tools accessed")
                        showDataManagement = true
                    }
                )
                
                // Creator Requirements
                enhancedQuickActionButton(
                    title: "Creator Requirements",
                    subtitle: "Track influencer agreements",
                    icon: "list.bullet.rectangle",
                    color: .purple,
                    action: { 
                        addDebugLog("Creator requirements tracker accessed")
                        showCreatorRequirements = true
                    }
                )
                
                // Crash Testing
                enhancedQuickActionButton(
                    title: "Crash Test",
                    subtitle: "Test error handling",
                    icon: "exclamationmark.triangle.fill",
                    color: .yellow,
                    action: { 
                        addDebugLog("Crash testing initiated")
                        // TODO: Implement crash testing
                    }
                )
                
                // Network Testing
                enhancedQuickActionButton(
                    title: "Network Test",
                    subtitle: "Test connectivity",
                    icon: "network",
                    color: .cyan,
                    action: { 
                        addDebugLog("Network testing started")
                        // TODO: Implement network testing
                    }
                )
            }
        }
    }
    
    // MARK: - Enhanced Quick Action Button
    /// Creates an enhanced quick action button with subtitle
    private func enhancedQuickActionButton(title: String, subtitle: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                // Title and subtitle
                VStack(spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
                    .shadow(
                        color: themeManager.primary.opacity(0.05),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: isDebugModeEnabled)
    }
    
    // MARK: - App Screens Section
    /// Navigation to all app screens organized by category
    private var appScreensSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionHeader(title: "App Screens", icon: "iphone")
            
                // Authentication Screens
            screenCategorySection(
                title: "Authentication",
                    icon: "person.circle.fill",
                    color: .blue,
                screens: DeveloperScreen.allCases.filter { $0.category == .authentication }
                )
                
                // Onboarding Screens
            screenCategorySection(
                    title: "Onboarding",
                    icon: "arrow.right.circle.fill",
                    color: .green,
                screens: DeveloperScreen.allCases.filter { $0.category == .onboarding }
            )
            
            // Main App Screens
            screenCategorySection(
                title: "Main App",
                    icon: "house.fill",
                    color: .orange,
                screens: DeveloperScreen.allCases.filter { $0.category == .mainApp }
            )
            
            // System Screens
            screenCategorySection(
                title: "System",
                icon: "gear",
                color: .gray,
                screens: DeveloperScreen.allCases.filter { $0.category == .system }
            )
        }
    }
    
    // MARK: - Screen Category Section
    /// Creates a section for a specific screen category
    private func screenCategorySection(title: String, icon: String, color: Color, screens: [DeveloperScreen]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category Header
            HStack {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text("\(screens.count) screens")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
                
                Spacer()
                
                // Expand/Collapse indicator
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
            
            // Screens Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(screens, id: \.self) { screen in
                    enhancedScreenButton(screen: screen)
                }
            }
        }
    }
    
    // MARK: - Enhanced Screen Button
    /// Creates an enhanced screen button with more information
    private func enhancedScreenButton(screen: DeveloperScreen) -> some View {
        Button(action: {
            navigateToScreen(screen)
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with Icon and Title
                HStack {
                    // Icon with background
                    ZStack {
                        Circle()
                            .fill(screen.color.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: screen.icon)
                            .font(.title3)
                            .foregroundColor(screen.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(screen.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textPrimary)
                            .lineLimit(1)
                        
                        // Priority Badge
                        HStack(spacing: 4) {
                            Image(systemName: screen.testPriority.icon)
                                .font(.caption2)
                                .foregroundColor(screen.testPriority.color)
                            
                            Text(screen.testPriority.rawValue)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(screen.testPriority.color)
                        }
                    }
                    
                    Spacer()
                    
                    // Navigation arrow
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
                
                // Description
                Text(screen.description)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Footer with Test Info and Interaction Indicator
                HStack {
                    // Test Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                        
                        Text(screen.estimatedTestTime)
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Interaction Indicator
                    if screen.requiresUserInteraction {
                        HStack(spacing: 4) {
                            Image(systemName: "hand.tap.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                            
                            Text("Interactive")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
                    .shadow(
                        color: screen.color.opacity(0.05),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: isDebugModeEnabled)
    }
    
    // MARK: - Development Tools Section
    /// Development and debugging tools
    private var developmentToolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Development Tools", icon: "wrench.and.screwdriver.fill")
            
            VStack(spacing: 12) {
                // Theme Switcher
                HStack {
                    Image(systemName: "paintbrush.fill")
                        .foregroundColor(themeManager.primary)
                        .frame(width: 24)
                    
                    Text("Theme Mode")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Spacer()
                    
                    Picker("Theme", selection: $selectedTheme) {
                        Text("System").tag(ThemeManager.ThemeMode.system)
                        Text("Light").tag(ThemeManager.ThemeMode.light)
                        Text("Dark").tag(ThemeManager.ThemeMode.dark)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.surfaceOutline, lineWidth: 1)
                        )
                )
                .onChange(of: selectedTheme) { _, newTheme in
                    themeManager.setThemeMode(newTheme)
                }
                
                // Debug Mode Toggle
                HStack {
                    Image(systemName: "ladybug.fill")
                        .foregroundColor(themeManager.primary)
                        .frame(width: 24)
                    
                    Text("Debug Mode")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDebugModeEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: themeManager.primary))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.surfaceOutline, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Debug Info Section
    /// Current app state and debug information
    private var debugInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Debug Info", icon: "info.circle.fill")
            
            VStack(alignment: .leading, spacing: 8) {
                debugInfoRow(title: "App Version", value: "1.0.0")
                debugInfoRow(title: "Build Number", value: "1")
                debugInfoRow(title: "iOS Version", value: UIDevice.current.systemVersion)
                debugInfoRow(title: "Device Model", value: UIDevice.current.model)
                debugInfoRow(title: "Screen Size", value: "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)")
                debugInfoRow(title: "Theme Mode", value: themeManager.themeMode.displayName)
                debugInfoRow(title: "Debug Mode", value: isDebugModeEnabled ? "Enabled" : "Disabled")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Helper Views
    
    /// Creates a section header with title and icon
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.primary)
                .font(.title2)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
        }
    }
    
    /// Creates a quick action button
    private func quickActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Creates a screen navigation button
    private func screenButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Creates a debug info row
    private func debugInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textPrimary)
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Navigates to a specific screen
    private func navigateToScreen(_ screen: DeveloperScreen) {
        addDebugLog("Navigating to: \(screen.rawValue)")
        developerNavigationManager.navigateToScreen(screen)
    }
    
    /// Adds a debug log entry
    private func addDebugLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        debugLogs.append("[\(timestamp)] \(message)")
    }
}

// MARK: - Developer Screen Enumeration
/// Enumeration of all available screens in the app
enum DeveloperScreen: String, CaseIterable {
    // MARK: - Authentication Screens
    case login = "Login"
    case appleSignIn = "Apple Sign-In"
    
    // MARK: - Onboarding Screens
    case onboarding = "Onboarding Flow"
    case onboardingHero = "Onboarding Hero"
    case onboardingWelcome = "Onboarding Welcome"
    case onboardingProblem = "Onboarding Problem"
    case onboardingChecklist = "Onboarding Checklist"
    case onboardingNameInput = "Name Input"
    case onboardingGenderSelection = "Gender Selection"
    case onboardingQuestion = "Onboarding Question"
    case onboardingPlan = "Onboarding Plan"
    case onboardingProgressTracking = "Progress Tracking"
    case onboardingProgressGraph = "Progress Graph"
    case onboardingPermission = "Permission Request"
    case onboardingSummary = "Onboarding Summary"
    
    // MARK: - Main App Screens
    case home = "Home"
    case profile = "Profile"
    case instagramProfile = "Instagram Profile"
    case photoAnalysis = "Photo Analysis"
    case photoAnalyzer = "Photo Analyzer"
    case settings = "Settings"
    
    // MARK: - Loading & Error Screens
    case loading = "Loading"
    case error = "Error"
    
    var icon: String {
        switch self {
        // Authentication
        case .login: return "person.circle.fill"
        case .appleSignIn: return "applelogo"
        
        // Onboarding
        case .onboarding: return "arrow.right.circle.fill"
        case .onboardingHero: return "star.fill"
        case .onboardingWelcome: return "hand.wave.fill"
        case .onboardingProblem: return "exclamationmark.triangle.fill"
        case .onboardingChecklist: return "checklist"
        case .onboardingNameInput: return "textformat"
        case .onboardingGenderSelection: return "person.2.fill"
        case .onboardingQuestion: return "questionmark.circle.fill"
        case .onboardingPlan: return "list.bullet.rectangle.fill"
        case .onboardingProgressTracking: return "chart.line.uptrend.xyaxis"
        case .onboardingProgressGraph: return "chart.bar.fill"
        case .onboardingPermission: return "lock.fill"
        case .onboardingSummary: return "checkmark.circle.fill"
        
        // Main App
        case .home: return "house.fill"
        case .profile: return "person.fill"
        case .instagramProfile: return "camera.fill"
        case .photoAnalysis: return "camera.viewfinder"
        case .photoAnalyzer: return "photo.fill"
        case .settings: return "gearshape.fill"
        
        // Loading & Error
        case .loading: return "clock.fill"
        case .error: return "exclamationmark.octagon.fill"
        }
    }
    
    var color: Color {
        switch self {
        // Authentication
        case .login: return .blue
        case .appleSignIn: return .black
        
        // Onboarding
        case .onboarding: return .green
        case .onboardingHero: return .purple
        case .onboardingWelcome: return .blue
        case .onboardingProblem: return .red
        case .onboardingChecklist: return .green
        case .onboardingNameInput: return .orange
        case .onboardingGenderSelection: return .pink
        case .onboardingQuestion: return .cyan
        case .onboardingPlan: return .indigo
        case .onboardingProgressTracking: return .mint
        case .onboardingProgressGraph: return .teal
        case .onboardingPermission: return .yellow
        case .onboardingSummary: return .green
        
        // Main App
        case .home: return .orange
        case .profile: return .purple
        case .instagramProfile: return .pink
        case .photoAnalysis: return .red
        case .photoAnalyzer: return .red
        case .settings: return .gray
        
        // Loading & Error
        case .loading: return .blue
        case .error: return .red
        }
    }
    
    var category: ScreenCategory {
        switch self {
        case .login, .appleSignIn:
            return .authentication
        case .onboarding, .onboardingHero, .onboardingWelcome, .onboardingProblem, .onboardingChecklist, .onboardingNameInput, .onboardingGenderSelection, .onboardingQuestion, .onboardingPlan, .onboardingProgressTracking, .onboardingProgressGraph, .onboardingPermission, .onboardingSummary:
            return .onboarding
        case .home, .profile, .instagramProfile, .photoAnalysis, .photoAnalyzer, .settings:
            return .mainApp
        case .loading, .error:
            return .system
        }
    }
    
    var description: String {
        switch self {
        // Authentication
        case .login: return "Main login screen with Apple Sign-In"
        case .appleSignIn: return "Apple Sign-In authentication flow"
        
        // Onboarding
        case .onboarding: return "Complete onboarding flow"
        case .onboardingHero: return "Hero screen with app introduction"
        case .onboardingWelcome: return "Welcome screen with user greeting"
        case .onboardingProblem: return "Problem statement screen"
        case .onboardingChecklist: return "Benefits checklist screen"
        case .onboardingNameInput: return "Name input form"
        case .onboardingGenderSelection: return "Gender selection screen"
        case .onboardingQuestion: return "Style quiz question"
        case .onboardingPlan: return "Plan selection screen"
        case .onboardingProgressTracking: return "Progress tracking setup"
        case .onboardingProgressGraph: return "Progress visualization"
        case .onboardingPermission: return "Permission request screen"
        case .onboardingSummary: return "Onboarding completion summary"
        
        // Main App
        case .home: return "Main home screen and dashboard"
        case .profile: return "User profile and settings"
        case .instagramProfile: return "Instagram-style profile view"
        case .photoAnalysis: return "Photo analysis and AI features"
        case .photoAnalyzer: return "Photo analyzer interface"
        case .settings: return "App settings and preferences"
        
        // Loading & Error
        case .loading: return "Loading screen with progress indicator"
        case .error: return "Error screen with error handling"
        }
    }
    
    var estimatedTestTime: String {
        switch self {
        case .login, .appleSignIn: return "1-2 minutes"
        case .onboarding: return "5-10 minutes"
        case .onboardingHero, .onboardingWelcome, .onboardingProblem, .onboardingChecklist, .onboardingNameInput, .onboardingGenderSelection, .onboardingQuestion, .onboardingPlan, .onboardingProgressTracking, .onboardingProgressGraph, .onboardingPermission, .onboardingSummary: return "1-2 minutes"
        case .home, .profile, .instagramProfile: return "2-3 minutes"
        case .photoAnalysis, .photoAnalyzer: return "3-5 minutes"
        case .settings: return "1-2 minutes"
        case .loading, .error: return "30 seconds"
        }
    }
    
    var requiresUserInteraction: Bool {
        switch self {
        case .login, .appleSignIn, .onboarding, .onboardingNameInput, .onboardingGenderSelection, .onboardingQuestion, .onboardingPlan, .onboardingPermission, .photoAnalysis, .photoAnalyzer:
            return true
        case .onboardingHero, .onboardingWelcome, .onboardingProblem, .onboardingChecklist, .onboardingProgressTracking, .onboardingProgressGraph, .onboardingSummary, .home, .profile, .instagramProfile, .settings, .loading, .error:
            return false
        }
    }
    
    var testPriority: TestPriority {
        switch self {
        case .login, .appleSignIn, .onboarding:
            return .high
        case .home, .profile, .instagramProfile, .photoAnalysis, .photoAnalyzer:
            return .medium
        case .onboardingHero, .onboardingWelcome, .onboardingProblem, .onboardingChecklist, .onboardingNameInput, .onboardingGenderSelection, .onboardingQuestion, .onboardingPlan, .onboardingProgressTracking, .onboardingProgressGraph, .onboardingPermission, .onboardingSummary, .settings, .loading, .error:
            return .low
        }
    }
}

// MARK: - Test Priority Enumeration
/// Enumeration of test priority levels
enum TestPriority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
    
    var icon: String {
        switch self {
        case .high:
            return "exclamationmark.triangle.fill"
        case .medium:
            return "exclamationmark.circle.fill"
        case .low:
            return "checkmark.circle.fill"
        }
    }
}

// MARK: - Screen Category Enumeration
/// Categories for organizing screens
enum ScreenCategory: String, CaseIterable {
    case authentication = "Authentication"
    case onboarding = "Onboarding"
    case mainApp = "Main App"
    case system = "System"
    
    var icon: String {
        switch self {
        case .authentication: return "person.circle.fill"
        case .onboarding: return "arrow.right.circle.fill"
        case .mainApp: return "house.fill"
        case .system: return "gear"
        }
    }
    
    var color: Color {
        switch self {
        case .authentication: return .blue
        case .onboarding: return .green
        case .mainApp: return .orange
        case .system: return .gray
        }
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    DeveloperDashboard()
        .environmentObject(ThemeManager.shared)
}
