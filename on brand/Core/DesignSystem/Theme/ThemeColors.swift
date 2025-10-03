//
//  ThemeColors.swift
//  on brand
//
//  This file contains all the color definitions for the theme system.
//  It provides both light and dark mode colors for all UI elements.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Theme Colors Protocol
// This protocol defines the interface for theme colors
protocol ThemeColors {
    var backgroundTop: Color { get }
    var backgroundBottom: Color { get }
    var surface: Color { get }
    var surfaceOutline: Color { get }
    var primary: Color { get }
    var secondary: Color { get }
    var accent: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var subtleText: Color { get }
    var buttonBackground: Color { get }
    var tabBarInactive: Color { get }
    var error: Color { get }
    var success: Color { get }
    var warning: Color { get }
    var info: Color { get }
}

// MARK: - Light Theme Colors
// This struct defines the colors for light mode
struct LightThemeColors: ThemeColors {
    
    // MARK: - Background Colors
    var backgroundTop: Color {
        Color.white
    }
    
    var backgroundBottom: Color {
        Color.white
    }
    
    // MARK: - Surface Colors
    var surface: Color {
        Color.white
    }
    
    var surfaceOutline: Color {
        Color(red: 0.86, green: 0.86, blue: 0.86)
    }
    
    // MARK: - Brand Colors
    var primary: Color {
        Color(red: 0.20, green: 0.22, blue: 0.75)
    }
    
    var secondary: Color {
        Color(red: 0.95, green: 0.57, blue: 0.70)
    }
    
    var accent: Color {
        Color(red: 0.98, green: 0.82, blue: 0.26)
    }
    
    // MARK: - Text Colors
    var textPrimary: Color {
        Color.black
    }
    
    var textSecondary: Color {
        Color(red: 0.38, green: 0.38, blue: 0.38)
    }
    
    var subtleText: Color {
        Color(red: 0.60, green: 0.60, blue: 0.60)
    }
    
    // MARK: - UI Element Colors
    var buttonBackground: Color {
        Color(red: 0.95, green: 0.95, blue: 0.95)
    }
    
    var tabBarInactive: Color {
        Color(red: 0.60, green: 0.60, blue: 0.60)
    }
    
    // MARK: - Status Colors
    var error: Color {
        Color(red: 0.86, green: 0.26, blue: 0.21)
    }
    
    var success: Color {
        Color(red: 0.20, green: 0.70, blue: 0.32)
    }
    
    var warning: Color {
        Color(red: 0.95, green: 0.61, blue: 0.07)
    }
    
    var info: Color {
        Color(red: 0.00, green: 0.48, blue: 1.00)
    }
}

// MARK: - Dark Theme Colors
// This struct defines the colors for dark mode
struct DarkThemeColors: ThemeColors {
    
    // MARK: - Background Colors
    var backgroundTop: Color {
        Color.black
    }
    
    var backgroundBottom: Color {
        Color.black
    }
    
    // MARK: - Surface Colors
    var surface: Color {
        Color(red: 0.11, green: 0.11, blue: 0.12)
    }
    
    var surfaceOutline: Color {
        Color(red: 0.22, green: 0.22, blue: 0.24)
    }
    
    // MARK: - Brand Colors
    var primary: Color {
        Color(red: 0.00, green: 0.48, blue: 1.00)
    }
    
    var secondary: Color {
        Color(red: 0.95, green: 0.57, blue: 0.70)
    }
    
    var accent: Color {
        Color(red: 1.00, green: 0.85, blue: 0.00)
    }
    
    // MARK: - Text Colors
    var textPrimary: Color {
        Color.white
    }
    
    var textSecondary: Color {
        Color(red: 0.85, green: 0.85, blue: 0.85)
    }
    
    var subtleText: Color {
        Color(red: 0.60, green: 0.60, blue: 0.60)
    }
    
    // MARK: - UI Element Colors
    var buttonBackground: Color {
        Color(red: 0.22, green: 0.22, blue: 0.24)
    }
    
    var tabBarInactive: Color {
        Color(red: 0.60, green: 0.60, blue: 0.60)
    }
    
    // MARK: - Status Colors
    var error: Color {
        Color(red: 0.86, green: 0.26, blue: 0.21)
    }
    
    var success: Color {
        Color(red: 0.20, green: 0.70, blue: 0.32)
    }
    
    var warning: Color {
        Color(red: 0.95, green: 0.61, blue: 0.07)
    }
    
    var info: Color {
        Color(red: 0.00, green: 0.48, blue: 1.00)
    }
}

// MARK: - Theme Color Factory
// This factory creates the appropriate color set based on the color scheme
struct ThemeColorFactory {
    
    /// Creates the appropriate color set for the given color scheme
    /// - Parameter colorScheme: The color scheme to create colors for
    /// - Returns: A ThemeColors instance for the specified color scheme
    static func colors(for colorScheme: ColorScheme) -> ThemeColors {
        switch colorScheme {
        case .light:
            return LightThemeColors()
        case .dark:
            return DarkThemeColors()
        @unknown default:
            return LightThemeColors()
        }
    }
}

// MARK: - Color Extensions
// These extensions provide additional color utilities

extension Color {
    /// Creates a color that adapts to the current color scheme
    /// - Parameters:
    ///   - light: The color to use in light mode
    ///   - dark: The color to use in dark mode
    /// - Returns: A color that adapts to the current color scheme
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            case .light, .unspecified:
                return UIColor(light)
            @unknown default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Theme Colors")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 10) {
            ColorPreview(color: LightThemeColors().primary, name: "Primary (Light)")
            ColorPreview(color: DarkThemeColors().primary, name: "Primary (Dark)")
            ColorPreview(color: LightThemeColors().secondary, name: "Secondary (Light)")
            ColorPreview(color: DarkThemeColors().secondary, name: "Secondary (Dark)")
            ColorPreview(color: LightThemeColors().surface, name: "Surface (Light)")
            ColorPreview(color: DarkThemeColors().surface, name: "Surface (Dark)")
        }
    }
    .padding()
}

// MARK: - Color Preview Helper
// This helper view shows a color with its name for preview purposes
struct ColorPreview: View {
    let color: Color
    let name: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
