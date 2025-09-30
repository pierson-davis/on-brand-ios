//
//  SettingsView.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                EraBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Theme Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Appearance")
                                .font(.headline.bold())
                                .foregroundColor(themeManager.textPrimary)
                            
                            EraSurfaceCard {
                                VStack(spacing: 16) {
                                    ForEach(ThemeManager.ThemeMode.allCases, id: \.self) { mode in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(mode.displayName)
                                                    .font(.body)
                                                    .foregroundColor(themeManager.textPrimary)
                                                
                                                if mode == .system {
                                                    let currentSystemStyle = UITraitCollection.current.userInterfaceStyle
                                                    let systemStyleText = currentSystemStyle == .dark ? "Dark" : "Light"
                                                    Text("Follows system (\(systemStyleText))")
                                                        .font(.caption)
                                                        .foregroundColor(themeManager.textSecondary)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            if themeManager.themeMode == mode {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(themeManager.primary)
                                                    .font(.title3)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(themeManager.textSecondary)
                                                    .font(.title3)
                                            }
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            themeManager.setThemeMode(mode)
                                        }
                                        
                                        if mode != .system {
                                            Divider()
                                                .background(themeManager.separator)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Quick Toggle Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.headline.bold())
                                .foregroundColor(themeManager.textPrimary)
                            
                            EraSurfaceCard {
                                VStack(spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Toggle Dark Mode")
                                                .font(.body)
                                                .foregroundColor(themeManager.textPrimary)
                                            
                                            Text("Switch between light and dark")
                                                .font(.caption)
                                                .foregroundColor(themeManager.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            themeManager.toggleTheme()
                                        }) {
                                            Image(systemName: themeManager.colorScheme == .dark ? "sun.max.fill" : "moon.fill")
                                                .foregroundColor(themeManager.primary)
                                                .font(.title3)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Current Theme Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Current Theme")
                                .font(.headline.bold())
                                .foregroundColor(themeManager.textPrimary)
                            
                            EraSurfaceCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Mode:")
                                            .foregroundColor(themeManager.textSecondary)
                                        Spacer()
                                        Text(themeManager.themeMode.displayName)
                                            .foregroundColor(themeManager.textPrimary)
                                            .fontWeight(.medium)
                                    }
                                    
                                    HStack {
                                        Text("Active:")
                                            .foregroundColor(themeManager.textSecondary)
                                        Spacer()
                                        Text(themeManager.colorScheme == .dark ? "Dark" : "Light")
                                            .foregroundColor(themeManager.textPrimary)
                                            .fontWeight(.medium)
                                    }
                                    
                                    // Debug section
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Debug Info:")
                                            .font(.caption)
                                            .foregroundColor(themeManager.textSecondary)
                                        
                                        Text("System: \(systemColorScheme == .dark ? "Dark" : "Light")")
                                            .font(.caption)
                                            .foregroundColor(themeManager.textSecondary)
                                        
                                        Text("ThemeManager: \(themeManager.colorScheme == .dark ? "Dark" : "Light")")
                                            .font(.caption)
                                            .foregroundColor(themeManager.textSecondary)
                                        
                                        Text("Mode: \(themeManager.themeMode.rawValue)")
                                            .font(.caption)
                                            .foregroundColor(themeManager.textSecondary)
                                    }
                                    
                                    // Debug button for testing system appearance
                                    if themeManager.themeMode == .system {
                                        Button(action: {
                                            themeManager.checkSystemAppearance()
                                        }) {
                                            Text("🔍 Test System Detection")
                                                .font(.caption)
                                                .foregroundColor(themeManager.primary)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100) // Space for bottom navigation
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.primary)
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                // Check system appearance when app becomes active
                themeManager.refreshSystemAppearance()
            }
        }
    }
}

