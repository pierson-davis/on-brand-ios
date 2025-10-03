//
//  EraBackground.swift
//  on brand
//
//  This file contains the background components for the Era design system.
//  It includes the main background gradient and related background utilities.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Era Background
// This is the main background component used throughout the app
struct EraBackground: View {
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Properties
    /// Optional custom colors for the gradient (if not provided, uses theme colors)
    let customColors: [Color]?
    
    /// Optional custom start point for the gradient
    let customStartPoint: UnitPoint?
    
    /// Optional custom end point for the gradient
    let customEndPoint: UnitPoint?
    
    // MARK: - Initializers
    /// Default initializer using theme colors
    init() {
        self.customColors = nil
        self.customStartPoint = nil
        self.customEndPoint = nil
    }
    
    /// Custom initializer with specific colors and points
    /// - Parameters:
    ///   - colors: Custom colors for the gradient
    ///   - startPoint: Custom start point for the gradient
    ///   - endPoint: Custom end point for the gradient
    init(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.customColors = colors
        self.customStartPoint = startPoint
        self.customEndPoint = endPoint
    }
    
    // MARK: - Main Body
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: gradientStartPoint,
            endPoint: gradientEndPoint
        )
        .drawingGroup() // Optimize rendering performance
        .id("background-\(themeManager.colorScheme)") // Dynamic identifier for theme changes
    }
    
    // MARK: - Computed Properties
    /// Returns the colors to use for the gradient
    private var gradientColors: [Color] {
        if let customColors = customColors {
            return customColors
        } else {
            return [themeManager.backgroundTop, themeManager.backgroundBottom]
        }
    }
    
    /// Returns the start point for the gradient
    private var gradientStartPoint: UnitPoint {
        customStartPoint ?? .topLeading
    }
    
    /// Returns the end point for the gradient
    private var gradientEndPoint: UnitPoint {
        customEndPoint ?? .bottomTrailing
    }
}

// MARK: - Era Background Variants
// These are specialized background components for different use cases

/// A subtle background with reduced opacity
struct EraSubtleBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        EraBackground()
            .opacity(0.5)
    }
}

/// A background with a specific color scheme
struct EraColoredBackground: View {
    let color: Color
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        color
            .ignoresSafeArea()
    }
}

/// A background with a pattern overlay
struct EraPatternBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            EraBackground()
            
            // Add a subtle pattern overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}

// MARK: - Background Utilities
// These utilities help with background-related functionality

/// A view modifier that applies the standard Era background
struct EraBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            EraBackground()
                .ignoresSafeArea()
            
            content
        }
    }
}

/// Extension to easily apply Era background to any view
extension View {
    /// Applies the standard Era background to the view
    func eraBackground() -> some View {
        modifier(EraBackgroundModifier())
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Era Background Components")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(spacing: 10) {
            Text("Standard Background")
                .font(.headline)
            
            EraBackground()
                .frame(height: 100)
                .cornerRadius(12)
            
            Text("Subtle Background")
                .font(.headline)
            
            EraSubtleBackground()
                .frame(height: 100)
                .cornerRadius(12)
            
            Text("Colored Background")
                .font(.headline)
            
            EraColoredBackground(color: .blue)
                .frame(height: 100)
                .cornerRadius(12)
        }
    }
    .padding()
    .environmentObject(ThemeManager.shared)
}
