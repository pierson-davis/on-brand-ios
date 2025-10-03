//
//  AppInfoView.swift
//  on brand
//
//  This view displays comprehensive app information for developers.
//  It includes version info, build details, device info, and system status.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

// MARK: - App Info View
// This view displays comprehensive app information for developers
struct AppInfoView: View {
    
    // MARK: - State Properties
    /// Controls whether the system info is visible
    @State private var showSystemInfo = true
    
    /// Controls whether the app details are visible
    @State private var showAppDetails = true
    
    /// Controls whether the build info is visible
    @State private var showBuildInfo = true
    
    /// Controls whether the device info is visible
    @State private var showDeviceInfo = true
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                EraBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Header Section
                        // This shows the app info title and icon
                        headerSection
                        
                        // MARK: - App Details Section
                        // This shows basic app information
                        if showAppDetails {
                            appDetailsSection
                        }
                        
                        // MARK: - Build Info Section
                        // This shows build and version information
                        if showBuildInfo {
                            buildInfoSection
                        }
                        
                        // MARK: - Device Info Section
                        // This shows device and system information
                        if showDeviceInfo {
                            deviceInfoSection
                        }
                        
                        // MARK: - System Info Section
                        // This shows system status and capabilities
                        if showSystemInfo {
                            systemInfoSection
                        }
                        
                        // MARK: - Actions Section
                        // This provides action buttons
                        actionsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("App Info")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the view
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    /// The header section with app icon and title
    private var headerSection: some View {
        VStack(spacing: 16) {
            // App Icon
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.primary)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            // App Name
            Text("on brand")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // App Tagline
            Text("AI-Powered Style Discovery")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Version Info
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(themeManager.primary)
                
                Text("Version 1.0.0 (Build 1)")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - App Details Section
    /// Shows basic app information
    private var appDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "App Details", icon: "app.fill")
            
            VStack(spacing: 12) {
                infoRow(title: "App Name", value: "on brand")
                infoRow(title: "Bundle ID", value: "com.piersondavis.onbrand")
                infoRow(title: "Developer", value: "Pierson Davis")
                infoRow(title: "Category", value: "Lifestyle")
                infoRow(title: "Platform", value: "iOS")
                infoRow(title: "Minimum iOS", value: "16.0")
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
    
    // MARK: - Build Info Section
    /// Shows build and version information
    private var buildInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Build Info", icon: "hammer.fill")
            
            VStack(spacing: 12) {
                infoRow(title: "Version", value: "1.0.0")
                infoRow(title: "Build Number", value: "1")
                infoRow(title: "Build Date", value: "January 2025")
                infoRow(title: "Build Type", value: "Debug")
                infoRow(title: "Xcode Version", value: "15.0")
                infoRow(title: "Swift Version", value: "5.9")
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
    
    // MARK: - Device Info Section
    /// Shows device and system information
    private var deviceInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Device Info", icon: "iphone")
            
            VStack(spacing: 12) {
                infoRow(title: "Device Model", value: UIDevice.current.model)
                infoRow(title: "Device Name", value: UIDevice.current.name)
                infoRow(title: "System Name", value: UIDevice.current.systemName)
                infoRow(title: "System Version", value: UIDevice.current.systemVersion)
                infoRow(title: "Screen Size", value: "\(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))")
                infoRow(title: "Screen Scale", value: "\(UIScreen.main.scale)x")
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
    
    // MARK: - System Info Section
    /// Shows system status and capabilities
    private var systemInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "System Info", icon: "gear")
            
            VStack(spacing: 12) {
                infoRow(title: "Theme Mode", value: themeManager.themeMode.displayName)
                infoRow(title: "Color Scheme", value: themeManager.colorScheme == .dark ? "Dark" : "Light")
                infoRow(title: "Accessibility", value: "Enabled")
                infoRow(title: "Dynamic Type", value: "Enabled")
                infoRow(title: "Voice Over", value: "Available")
                infoRow(title: "Switch Control", value: "Available")
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
    
    // MARK: - Actions Section
    /// Provides action buttons
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Actions", icon: "square.and.arrow.up")
            
            VStack(spacing: 12) {
                Button("Copy App Info") {
                    copyAppInfo()
                }
                .buttonStyle(EraPrimaryButtonStyle())
                
                Button("Export Debug Info") {
                    exportDebugInfo()
                }
                .buttonStyle(EraSecondaryButtonStyle())
                
                Button("Reset App Data") {
                    resetAppData()
                }
                .buttonStyle(EraSecondaryButtonStyle())
                
                Button("Clear Cache") {
                    clearCache()
                }
                .buttonStyle(EraSecondaryButtonStyle())
            }
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
    
    /// Creates an info row
    private func infoRow(title: String, value: String) -> some View {
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
    
    // MARK: - Helper Methods
    
    /// Copies app info to clipboard
    private func copyAppInfo() {
        let appInfo = """
        App: on brand
        Version: 1.0.0 (Build 1)
        Device: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        Screen: \(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))
        """
        
        UIPasteboard.general.string = appInfo
    }
    
    /// Exports debug information
    private func exportDebugInfo() {
        // In a real implementation, this would export debug info
    }
    
    /// Resets app data
    private func resetAppData() {
        // In a real implementation, this would reset app data
    }
    
    /// Clears app cache
    private func clearCache() {
        // In a real implementation, this would clear cache
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    AppInfoView()
        .environmentObject(ThemeManager.shared)
}
