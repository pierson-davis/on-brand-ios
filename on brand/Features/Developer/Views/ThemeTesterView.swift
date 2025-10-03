//
//  ThemeTesterView.swift
//  on brand
//
//  This view provides theme testing functionality for developers.
//  It allows testing of all theme modes and components in real-time.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

// MARK: - Theme Tester View
// This view provides theme testing functionality for developers
struct ThemeTesterView: View {
    
    // MARK: - State Properties
    /// Controls the current theme mode being tested
    @State private var selectedTheme: ThemeManager.ThemeMode = .system
    
    /// Controls whether the theme preview is visible
    @State private var showThemePreview = true
    
    /// Controls whether the component showcase is visible
    @State private var showComponentShowcase = true
    
    /// Controls whether the color palette is visible
    @State private var showColorPalette = true
    
    /// Controls whether the typography showcase is visible
    @State private var showTypographyShowcase = true
    
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
                        // This shows the theme tester title and current theme
                        headerSection
                        
                        // MARK: - Theme Controls Section
                        // This provides controls for switching themes
                        themeControlsSection
                        
                        // MARK: - Theme Preview Section
                        // This shows a preview of the current theme
                        if showThemePreview {
                            themePreviewSection
                        }
                        
                        // MARK: - Component Showcase Section
                        // This showcases all UI components with the current theme
                        if showComponentShowcase {
                            componentShowcaseSection
                        }
                        
                        // MARK: - Color Palette Section
                        // This shows all theme colors
                        if showColorPalette {
                            colorPaletteSection
                        }
                        
                        // MARK: - Typography Showcase Section
                        // This shows all typography styles
                        if showTypographyShowcase {
                            typographyShowcaseSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Theme Tester")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the view
                    }
                }
            }
        }
        .onAppear {
            selectedTheme = themeManager.themeMode
        }
        .onChange(of: selectedTheme) { _, newTheme in
            themeManager.setThemeMode(newTheme)
        }
    }
    
    // MARK: - Header Section
    /// The header section with title and current theme info
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Theme Tester Icon
            Image(systemName: "paintbrush.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primary)
            
            // Title
            Text("Theme Tester")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // Description
            Text("Test and preview all theme modes and components")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Current Theme Info
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .foregroundColor(themeManager.primary)
                
                Text("Current Theme: \(themeManager.themeMode.displayName)")
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
    
    // MARK: - Theme Controls Section
    /// Controls for switching between different theme modes
    private var themeControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Theme Controls", icon: "slider.horizontal.3")
            
            VStack(spacing: 12) {
                // Theme Mode Picker
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
                
                // Toggle Controls
                VStack(spacing: 8) {
                    toggleControl(
                        title: "Theme Preview",
                        isOn: $showThemePreview,
                        icon: "eye.fill"
                    )
                    
                    toggleControl(
                        title: "Component Showcase",
                        isOn: $showComponentShowcase,
                        icon: "rectangle.stack.fill"
                    )
                    
                    toggleControl(
                        title: "Color Palette",
                        isOn: $showColorPalette,
                        icon: "paintpalette.fill"
                    )
                    
                    toggleControl(
                        title: "Typography Showcase",
                        isOn: $showTypographyShowcase,
                        icon: "textformat"
                    )
                }
            }
        }
    }
    
    // MARK: - Theme Preview Section
    /// Shows a preview of the current theme
    private var themePreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Theme Preview", icon: "eye.fill")
            
            VStack(spacing: 16) {
                // Sample Card
                EraSurfaceCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sample Card")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textPrimary)
                        
                        Text("This is a sample card showing how content looks with the current theme.")
                            .font(.body)
                            .foregroundColor(themeManager.textSecondary)
                        
                        HStack {
                            Button("Primary Action") {
                                // Action
                            }
                            .buttonStyle(EraPrimaryButtonStyle())
                            
                            Spacer()
                            
                            Button("Secondary") {
                                // Action
                            }
                            .buttonStyle(EraSecondaryButtonStyle())
                        }
                    }
                }
                
                // Sample Text
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Text")
                        .font(.title)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text("Secondary Text")
                        .font(.body)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text("Subtle Text")
                        .font(.caption)
                        .foregroundColor(themeManager.subtleText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    // MARK: - Component Showcase Section
    /// Showcases all UI components with the current theme
    private var componentShowcaseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Component Showcase", icon: "rectangle.stack.fill")
            
            VStack(spacing: 16) {
                // Buttons
                VStack(alignment: .leading, spacing: 8) {
                    Text("Buttons")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    VStack(spacing: 8) {
                        Button("Primary Button") { }
                            .buttonStyle(EraPrimaryButtonStyle())
                        
                        Button("Secondary Button") { }
                            .buttonStyle(EraSecondaryButtonStyle())
                    }
                }
                
                // Cards
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cards")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    EraSurfaceCard {
                        Text("Surface Card Content")
                            .foregroundColor(themeManager.textPrimary)
                    }
                    
                    EraSelectableCard(isSelected: true, action: { }) {
                        Text("Selectable Card")
                            .foregroundColor(themeManager.textPrimary)
                    }
                }
                
                // Badges
                VStack(alignment: .leading, spacing: 8) {
                    Text("Badges")
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    HStack {
                        EraBadge("Primary")
                        EraBadge("Secondary", color: .orange)
                        EraBadge("Success", color: .green)
                        EraBadge("Warning", color: .yellow)
                        EraBadge("Error", color: .red)
                    }
                }
            }
        }
    }
    
    // MARK: - Color Palette Section
    /// Shows all theme colors
    private var colorPaletteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Color Palette", icon: "paintpalette.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                colorSwatch(name: "Primary", color: themeManager.primary)
                colorSwatch(name: "Secondary", color: themeManager.secondary)
                colorSwatch(name: "Accent", color: themeManager.accent)
                colorSwatch(name: "Surface", color: themeManager.surface)
                colorSwatch(name: "Text Primary", color: themeManager.textPrimary)
                colorSwatch(name: "Text Secondary", color: themeManager.textSecondary)
                colorSwatch(name: "Subtle Text", color: themeManager.subtleText)
                colorSwatch(name: "Background Top", color: themeManager.backgroundTop)
                colorSwatch(name: "Background Bottom", color: themeManager.backgroundBottom)
                colorSwatch(name: "Surface Outline", color: themeManager.surfaceOutline)
            }
        }
    }
    
    // MARK: - Typography Showcase Section
    /// Shows all typography styles
    private var typographyShowcaseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Typography", icon: "textformat")
            
            VStack(alignment: .leading, spacing: 12) {
                typographySample(text: "Large Title", font: .largeTitle)
                typographySample(text: "Title", font: .title)
                typographySample(text: "Title 2", font: .title2)
                typographySample(text: "Title 3", font: .title3)
                typographySample(text: "Headline", font: .headline)
                typographySample(text: "Body", font: .body)
                typographySample(text: "Callout", font: .callout)
                typographySample(text: "Subheadline", font: .subheadline)
                typographySample(text: "Footnote", font: .footnote)
                typographySample(text: "Caption", font: .caption)
                typographySample(text: "Caption 2", font: .caption2)
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
    
    /// Creates a toggle control
    private func toggleControl(title: String, isOn: Binding<Bool>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.primary)
                .frame(width: 24)
            
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: isOn)
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
    
    /// Creates a color swatch
    private func colorSwatch(name: String, color: Color) -> some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.surfaceOutline, lineWidth: 1)
                )
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textPrimary)
                .multilineTextAlignment(.center)
        }
    }
    
    /// Creates a typography sample
    private func typographySample(text: String, font: Font) -> some View {
        HStack {
            Text(text)
                .font(font)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            Text("Font Preview")
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
        }
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    ThemeTesterView()
        .environmentObject(ThemeManager.shared)
}
