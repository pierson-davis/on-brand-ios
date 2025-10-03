//
//  ThemeBackgroundDecorations.swift
//  on brand
//
//  This file contains the background decoration system for the theme.
//  It provides decorative elements that enhance the visual appeal of the app.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Background Decoration
// This struct represents a single background decoration element
struct BackgroundDecoration: Equatable {
    /// The color of the decoration
    let color: Color
    
    /// The size of the decoration
    let size: CGFloat
    
    /// The offset position of the decoration
    let offset: CGPoint
    
    /// The opacity of the decoration
    let opacity: Double
    
    /// Initializer for creating a background decoration
    /// - Parameters:
    ///   - color: The color of the decoration
    ///   - size: The size of the decoration
    ///   - offset: The offset position of the decoration
    ///   - opacity: The opacity of the decoration
    init(color: Color, size: CGFloat, offset: CGPoint, opacity: Double) {
        self.color = color
        self.size = size
        self.offset = offset
        self.opacity = opacity
    }
}

// MARK: - Background Decoration Manager
// This class manages the background decorations for the theme
class BackgroundDecorationManager: ObservableObject {
    
    // MARK: - Properties
    /// The current color scheme
    @Published var colorScheme: ColorScheme = .light
    
    /// The current theme colors
    private var themeColors: ThemeColors = LightThemeColors()
    
    // MARK: - Initialization
    /// Initializes the background decoration manager
    /// - Parameters:
    ///   - colorScheme: The current color scheme
    ///   - themeColors: The current theme colors
    init(colorScheme: ColorScheme = .light, themeColors: ThemeColors = LightThemeColors()) {
        self.colorScheme = colorScheme
        self.themeColors = themeColors
    }
    
    // MARK: - Background Decorations
    /// Returns the background decorations for the current theme
    var backgroundDecorations: [BackgroundDecoration] {
        let baseOpacity = colorScheme == .dark ? 0.08 : 0.15
        
        return [
            // Primary decoration (top left)
            BackgroundDecoration(
                color: themeColors.secondary,
                size: 420,
                offset: CGPoint(x: -140, y: -220),
                opacity: baseOpacity
            ),
            
            // Secondary decoration (top right)
            BackgroundDecoration(
                color: themeColors.accent,
                size: 360,
                offset: CGPoint(x: 160, y: -260),
                opacity: baseOpacity + 0.03
            ),
            
            // Tertiary decoration (bottom right)
            BackgroundDecoration(
                color: themeColors.primary,
                size: 420,
                offset: CGPoint(x: 120, y: 320),
                opacity: baseOpacity - 0.03
            )
        ]
    }
    
    // MARK: - Update Methods
    /// Updates the color scheme and theme colors
    /// - Parameters:
    ///   - colorScheme: The new color scheme
    ///   - themeColors: The new theme colors
    func update(colorScheme: ColorScheme, themeColors: ThemeColors) {
        self.colorScheme = colorScheme
        self.themeColors = themeColors
    }
}

// MARK: - Background Decoration View
// This view renders the background decorations
struct BackgroundDecorationView: View {
    
    // MARK: - Properties
    /// The decorations to render
    let decorations: [BackgroundDecoration]
    
    /// Whether to animate the decorations
    let animated: Bool
    
    /// The animation duration
    let animationDuration: Double
    
    // MARK: - State
    /// The current animation offset
    @State private var animationOffset: CGFloat = 0
    
    // MARK: - Initialization
    /// Initializes the background decoration view
    /// - Parameters:
    ///   - decorations: The decorations to render
    ///   - animated: Whether to animate the decorations
    ///   - animationDuration: The animation duration
    init(
        decorations: [BackgroundDecoration],
        animated: Bool = true,
        animationDuration: Double = 20.0
    ) {
        self.decorations = decorations
        self.animated = animated
        self.animationDuration = animationDuration
    }
    
    // MARK: - Main Body
    var body: some View {
        ZStack {
            ForEach(Array(decorations.enumerated()), id: \.offset) { index, decoration in
                Circle()
                    .fill(decoration.color.opacity(decoration.opacity))
                    .frame(width: decoration.size, height: decoration.size)
                    .offset(
                        x: decoration.offset.x + (animated ? animationOffset * CGFloat(index + 1) * 0.1 : 0),
                        y: decoration.offset.y + (animated ? animationOffset * CGFloat(index + 1) * 0.05 : 0)
                    )
                    .blur(radius: 20)
            }
        }
        .onAppear {
            if animated {
                startAnimation()
            }
        }
    }
    
    // MARK: - Animation
    /// Starts the animation for the decorations
    private func startAnimation() {
        withAnimation(
            Animation.linear(duration: animationDuration)
                .repeatForever(autoreverses: true)
        ) {
            animationOffset = 50
        }
    }
}

// MARK: - Theme Background Decorations Extension
// This extension provides access to background decorations through ThemeManager
extension ThemeManager {
    
    /// Returns the background decorations for the current theme
    var backgroundDecorations: [BackgroundDecoration] {
        let baseOpacity = colorScheme == .dark ? 0.08 : 0.15
        
        return [
            BackgroundDecoration(
                color: secondary,
                size: 420,
                offset: CGPoint(x: -140, y: -220),
                opacity: baseOpacity
            ),
            BackgroundDecoration(
                color: accent,
                size: 360,
                offset: CGPoint(x: 160, y: -260),
                opacity: baseOpacity + 0.03
            ),
            BackgroundDecoration(
                color: primary,
                size: 420,
                offset: CGPoint(x: 120, y: 320),
                opacity: baseOpacity - 0.03
            )
        ]
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ZStack {
        // Background
        Color.black.ignoresSafeArea()
        
        // Decorations
        BackgroundDecorationView(
            decorations: [
                BackgroundDecoration(
                    color: .blue,
                    size: 200,
                    offset: CGPoint(x: -100, y: -100),
                    opacity: 0.3
                ),
                BackgroundDecoration(
                    color: .purple,
                    size: 150,
                    offset: CGPoint(x: 100, y: -150),
                    opacity: 0.2
                ),
                BackgroundDecoration(
                    color: .pink,
                    size: 180,
                    offset: CGPoint(x: 50, y: 100),
                    opacity: 0.25
                )
            ],
            animated: true,
            animationDuration: 10.0
        )
        
        // Content
        VStack {
            Text("Background Decorations")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("These are animated background decorations")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}
