//
//  EraColorPalette.swift
//  on brand
//
//  This file contains the color palette definitions for the Era design system.
//  It includes both the legacy palette (for backward compatibility) and
//  the new theme-based color system.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Legacy Era Palette
// This is now deprecated - use ThemeManager.shared instead
// This enum is kept for backward compatibility with existing code
enum EraPalette {
    // MARK: - Background Colors
    /// Top background color for gradients
    static let backgroundTop = Color(red: 0.96, green: 0.96, blue: 0.99)
    
    /// Bottom background color for gradients
    static let backgroundBottom = Color(red: 0.90, green: 0.92, blue: 0.99)
    
    // MARK: - Surface Colors
    /// Primary surface color for cards and containers
    static let surface = Color.white.opacity(0.92)
    
    /// Outline color for surface borders
    static let surfaceOutline = Color.black.opacity(0.05)
    
    // MARK: - Brand Colors
    /// Primary brand color (purple)
    static let primary = Color(red: 0.20, green: 0.22, blue: 0.75)
    
    /// Secondary brand color (pink)
    static let secondary = Color(red: 0.95, green: 0.57, blue: 0.70)
    
    /// Accent brand color (yellow)
    static let accent = Color(red: 0.98, green: 0.82, blue: 0.26)
    
    // MARK: - Text Colors
    /// Primary text color (black)
    static let textPrimary = Color.black
    
    /// Secondary text color (semi-transparent black)
    static let textSecondary = Color.black.opacity(0.6)
    
    /// Subtle text color (more transparent black)
    static let subtleText = Color.black.opacity(0.4)
}

// MARK: - Color Extensions
// These extensions provide additional color utilities for the design system
extension Color {
    /// Creates a color with the specified red, green, and blue values
    /// - Parameters:
    ///   - red: Red component (0.0 to 1.0)
    ///   - green: Green component (0.0 to 1.0)
    ///   - blue: Blue component (0.0 to 1.0)
    ///   - alpha: Alpha component (0.0 to 1.0), defaults to 1.0
    /// - Returns: A Color with the specified components
    static func era(red: Double, green: Double, blue: Double, alpha: Double = 1.0) -> Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    /// Creates a color with the specified hex value
    /// - Parameter hex: Hex color value (e.g., 0xFF0000 for red)
    /// - Returns: A Color with the specified hex value
    static func era(hex: UInt) -> Color {
        Color(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}

// MARK: - Design System Color Constants
// These constants define the standard colors used throughout the app
struct EraColors {
    // MARK: - Background Colors
    /// Light background color for light mode
    static let lightBackground = Color.era(red: 0.96, green: 0.96, blue: 0.99)
    
    /// Dark background color for dark mode
    static let darkBackground = Color.era(red: 0.05, green: 0.05, blue: 0.08)
    
    // MARK: - Surface Colors
    /// Light surface color for cards
    static let lightSurface = Color.white.opacity(0.92)
    
    /// Dark surface color for cards
    static let darkSurface = Color.era(red: 0.12, green: 0.12, blue: 0.15)
    
    // MARK: - Brand Colors
    /// Primary brand color
    static let primary = Color.era(red: 0.20, green: 0.22, blue: 0.75)
    
    /// Secondary brand color
    static let secondary = Color.era(red: 0.95, green: 0.57, blue: 0.70)
    
    /// Accent brand color
    static let accent = Color.era(red: 0.98, green: 0.82, blue: 0.26)
    
    // MARK: - Text Colors
    /// Primary text color for light mode
    static let lightTextPrimary = Color.black
    
    /// Primary text color for dark mode
    static let darkTextPrimary = Color.white
    
    /// Secondary text color for light mode
    static let lightTextSecondary = Color.black.opacity(0.6)
    
    /// Secondary text color for dark mode
    static let darkTextSecondary = Color.white.opacity(0.7)
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Era Color Palette")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 10) {
            ColorPreview(color: EraPalette.primary, name: "Primary")
            ColorPreview(color: EraPalette.secondary, name: "Secondary")
            ColorPreview(color: EraPalette.accent, name: "Accent")
            ColorPreview(color: EraPalette.surface, name: "Surface")
            ColorPreview(color: EraPalette.textPrimary, name: "Text Primary")
            ColorPreview(color: EraPalette.textSecondary, name: "Text Secondary")
        }
    }
    .padding()
}

// MARK: - Color Preview Helper
// This helper view has been moved to ThemeColors.swift for better organization
