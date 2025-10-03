//
//  ThemeManager.swift
//  on brand
//
//  This file contains the core theme management logic including
//  theme switching, persistence, and system appearance monitoring.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI
import Foundation

// MARK: - Theme Manager
// This is the main theme manager that handles theme switching and persistence
class ThemeManager: ObservableObject {
    
    // MARK: - Singleton
    /// The shared instance of the theme manager
    static let shared = ThemeManager()
    
    // MARK: - Published Properties
    /// The current color scheme (light or dark)
    @Published var colorScheme: ColorScheme = .light {
        didSet {
            UserDefaults.standard.set(colorScheme == .dark, forKey: "dark_mode_enabled")
        }
    }
    
    /// The current theme mode (system, light, or dark)
    @Published var themeMode: ThemeMode = .system {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "theme_mode")
            updateColorScheme()
        }
    }
    
    // MARK: - Private Properties
    /// Timer for monitoring system appearance changes
    private var systemAppearanceTimer: Timer?
    
    /// The last known system interface style
    private var lastSystemStyle: UIUserInterfaceStyle = .light
    
    /// The current color set based on the color scheme
    private var currentColors: ThemeColors = LightThemeColors()
    
    // MARK: - Initialization
    /// Private initializer for singleton pattern
    private init() {
        loadThemeSettings()
        setupSystemAppearanceObserver()
    }
    
    // MARK: - Deinitialization
    deinit {
        systemAppearanceTimer?.invalidate()
        systemAppearanceTimer = nil
    }
    
    // MARK: - Theme Mode Enumeration
    /// The available theme modes
    enum ThemeMode: String, CaseIterable {
        case system = "system"
        case light = "light"
        case dark = "dark"
        
        /// The display name for the theme mode
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }
    
    // MARK: - System Appearance Monitoring
    /// Sets up the system appearance observer
    private func setupSystemAppearanceObserver() {
        lastSystemStyle = UITraitCollection.current.userInterfaceStyle
        
        // Start timer to periodically check for system appearance changes
        systemAppearanceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentStyle = UITraitCollection.current.userInterfaceStyle
            
            if currentStyle != self.lastSystemStyle {
                print("🔄 System appearance changed from \(self.lastSystemStyle == .dark ? "Dark" : "Light") to \(currentStyle == .dark ? "Dark" : "Light")")
                self.lastSystemStyle = currentStyle
                
                if self.themeMode == .system {
                    self.updateColorScheme()
                }
            }
        }
    }
    
    // MARK: - Theme Persistence
    /// Loads the saved theme settings from UserDefaults
    private func loadThemeSettings() {
        if let savedMode = UserDefaults.standard.string(forKey: "theme_mode"),
           let mode = ThemeMode(rawValue: savedMode) {
            themeMode = mode
        } else {
            // Default to system mode if no preference is saved
            themeMode = .system
        }
        updateColorScheme()
    }
    
    // MARK: - Color Scheme Management
    /// Updates the color scheme based on the current theme mode
    private func updateColorScheme() {
        let newColorScheme: ColorScheme
        
        switch themeMode {
        case .system:
            // Get current system appearance
            let currentStyle = UITraitCollection.current.userInterfaceStyle
            newColorScheme = currentStyle == .dark ? .dark : .light
        case .light:
            newColorScheme = .light
        case .dark:
            newColorScheme = .dark
        }
        
        // Only update if the color scheme actually changed
        if newColorScheme != colorScheme {
            print("🔧 Updating color scheme from \(colorScheme == .dark ? "Dark" : "Light") to \(newColorScheme == .dark ? "Dark" : "Light")")
            DispatchQueue.main.async {
                self.colorScheme = newColorScheme
                self.currentColors = ThemeColorFactory.colors(for: newColorScheme)
            }
        } else {
            print("🔧 Color scheme unchanged: \(newColorScheme == .dark ? "Dark" : "Light")")
        }
    }
    
    // MARK: - Public Methods
    /// Manually refreshes the system appearance
    func refreshSystemAppearance() {
        if themeMode == .system {
            let currentStyle = UITraitCollection.current.userInterfaceStyle
            if currentStyle != lastSystemStyle {
                lastSystemStyle = currentStyle
            }
            updateColorScheme()
        }
    }
    
    /// Forces a check of the system appearance (useful for testing)
    func checkSystemAppearance() {
        let currentStyle = UITraitCollection.current.userInterfaceStyle
        print("🔍 System appearance check: \(currentStyle == .dark ? "Dark" : "Light")")
        if themeMode == .system {
            print("📱 Theme mode is system, updating...")
            if currentStyle != lastSystemStyle {
                print("🔄 System style changed from \(lastSystemStyle == .dark ? "Dark" : "Light") to \(currentStyle == .dark ? "Dark" : "Light")")
                lastSystemStyle = currentStyle
                updateColorScheme()
            }
        } else {
            print("⚙️ Theme mode is \(themeMode.rawValue), not updating")
        }
    }
    
    /// Toggles between light and dark themes
    func toggleTheme() {
        switch themeMode {
        case .system:
            themeMode = .dark
        case .light:
            themeMode = .dark
        case .dark:
            themeMode = .light
        }
    }
    
    /// Sets the theme mode to a specific value
    /// - Parameter mode: The theme mode to set
    func setThemeMode(_ mode: ThemeMode) {
        themeMode = mode
    }
}

// MARK: - Theme Colors Extension
// This extension provides access to the current theme colors
extension ThemeManager: ThemeColors {
    
    // MARK: - Background Colors
    var backgroundTop: Color {
        currentColors.backgroundTop
    }
    
    var backgroundBottom: Color {
        currentColors.backgroundBottom
    }
    
    // MARK: - Surface Colors
    var surface: Color {
        currentColors.surface
    }
    
    var surfaceOutline: Color {
        currentColors.surfaceOutline
    }
    
    // MARK: - Brand Colors
    var primary: Color {
        currentColors.primary
    }
    
    var secondary: Color {
        currentColors.secondary
    }
    
    var accent: Color {
        currentColors.accent
    }
    
    // MARK: - Text Colors
    var textPrimary: Color {
        currentColors.textPrimary
    }
    
    var textSecondary: Color {
        currentColors.textSecondary
    }
    
    var subtleText: Color {
        currentColors.subtleText
    }
    
    // MARK: - UI Element Colors
    var buttonBackground: Color {
        currentColors.buttonBackground
    }
    
    var tabBarInactive: Color {
        currentColors.tabBarInactive
    }
    
    // MARK: - Status Colors
    var error: Color {
        currentColors.error
    }
    
    var success: Color {
        currentColors.success
    }
    
    var warning: Color {
        currentColors.warning
    }
    
    var info: Color {
        currentColors.info
    }
}

// MARK: - Environment Key
// This key allows ThemeManager to be accessed through the environment
struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager.shared
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
