//
//  ThemeManager.swift
//  era
//

import SwiftUI
import Foundation

// MARK: - Theme Manager with Dark Mode Support
class ThemeManager: ObservableObject {
    // Singleton instance
    static let shared = ThemeManager()
    
    // Theme preference
    @Published var colorScheme: ColorScheme = .light {
        didSet {
            UserDefaults.standard.set(colorScheme == .dark, forKey: "dark_mode_enabled")
        }
    }
    
    // Theme modes
    enum ThemeMode: String, CaseIterable {
        case system = "system"
        case light = "light"
        case dark = "dark"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }
    
    @Published var themeMode: ThemeMode = .system {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "theme_mode")
            updateColorScheme()
        }
    }
    
    private init() {
        loadThemeSettings()
        setupSystemAppearanceObserver()
    }
    
    private var systemAppearanceTimer: Timer?
    private var lastSystemStyle: UIUserInterfaceStyle = .light
    
    private func setupSystemAppearanceObserver() {
        // Store initial system style
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
    
    deinit {
        systemAppearanceTimer?.invalidate()
        systemAppearanceTimer = nil
    }
    
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
            }
        } else {
            print("🔧 Color scheme unchanged: \(newColorScheme == .dark ? "Dark" : "Light")")
        }
    }
    
    // Method to manually refresh system appearance
    func refreshSystemAppearance() {
        if themeMode == .system {
            let currentStyle = UITraitCollection.current.userInterfaceStyle
            if currentStyle != lastSystemStyle {
                lastSystemStyle = currentStyle
            }
            updateColorScheme()
        }
    }
    
    // Method to force check system appearance (useful for testing)
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
    
    // MARK: - Color Properties (Instagram-style)
    var backgroundTop: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var backgroundBottom: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var surface: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color.white
    }
    
    var surfaceOutline: Color {
        colorScheme == .dark ? Color(red: 0.22, green: 0.22, blue: 0.24) : Color(red: 0.86, green: 0.86, blue: 0.86)
    }
    
    var primary: Color { 
        colorScheme == .dark ? Color(red: 0.00, green: 0.48, blue: 1.00) : Color(red: 0.20, green: 0.22, blue: 0.75)
    }
    
    var secondary: Color { 
        colorScheme == .dark ? Color(red: 0.95, green: 0.57, blue: 0.70) : Color(red: 0.95, green: 0.57, blue: 0.70)
    }
    
    var accent: Color { 
        colorScheme == .dark ? Color(red: 1.00, green: 0.85, blue: 0.00) : Color(red: 0.98, green: 0.82, blue: 0.26)
    }
    
    var textPrimary: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var textSecondary: Color {
        colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : Color(red: 0.38, green: 0.38, blue: 0.38)
    }
    
    var subtleText: Color {
        colorScheme == .dark ? Color(red: 0.64, green: 0.64, blue: 0.64) : Color(red: 0.55, green: 0.55, blue: 0.55)
    }
    
    // Instagram-style dark mode colors
    var cardBackground: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color.white
    }
    
    var separator: Color {
        colorScheme == .dark ? Color(red: 0.22, green: 0.22, blue: 0.24) : Color(red: 0.86, green: 0.86, blue: 0.86)
    }
    
    var buttonBackground: Color {
        colorScheme == .dark ? Color(red: 0.22, green: 0.22, blue: 0.24) : Color(red: 0.94, green: 0.94, blue: 0.94)
    }
    
    var navigationBackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var tabBarBackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var tabBarBorder: Color {
        colorScheme == .dark ? Color(red: 0.22, green: 0.22, blue: 0.24) : Color(red: 0.86, green: 0.86, blue: 0.86)
    }
    
    var tabBarInactive: Color {
        colorScheme == .dark ? Color(red: 0.64, green: 0.64, blue: 0.64) : Color(red: 0.55, green: 0.55, blue: 0.55)
    }
    
    var tabBarActive: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    // MARK: - Background Decorations
    // This property has been moved to ThemeBackgroundDecorations.swift for better organization
    
    // MARK: - Theme Methods
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
    
    func setThemeMode(_ mode: ThemeMode) {
        themeMode = mode
    }
}

// MARK: - BackgroundDecoration
// This struct has been moved to ThemeBackgroundDecorations.swift for better organization

// MARK: - Environment Key
struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager.shared
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}
