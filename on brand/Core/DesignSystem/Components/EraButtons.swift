//
//  EraButtons.swift
//  on brand
//
//  This file contains all button-related components for the Era design system.
//  It includes button styles, button components, and button utilities.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Era Button Styles
// These are the standard button styles used throughout the app

/// Primary button style for main actions
struct EraPrimaryButtonStyle: ButtonStyle {
    
    // MARK: - Properties
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    /// Custom corner radius for the button
    let cornerRadius: CGFloat
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Initializers
    /// Default initializer
    init(isLoading: Bool = false, isDisabled: Bool = false, cornerRadius: CGFloat = 16) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Button Style Implementation
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.8)
            }
            
            configuration.label
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(buttonBackgroundColor)
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.1), value: isLoading)
    }
    
    // MARK: - Computed Properties
    /// Returns the background color for the button
    private var buttonBackgroundColor: Color {
        if isDisabled {
            return themeManager.textSecondary
        } else {
            return themeManager.primary
        }
    }
}

/// Secondary button style for secondary actions
struct EraSecondaryButtonStyle: ButtonStyle {
    
    // MARK: - Properties
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    /// Custom corner radius for the button
    let cornerRadius: CGFloat
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Initializers
    /// Default initializer
    init(isLoading: Bool = false, isDisabled: Bool = false, cornerRadius: CGFloat = 16) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Button Style Implementation
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primary))
                    .scaleEffect(0.8)
            }
            
            configuration.label
                .font(.headline.weight(.semibold))
                .foregroundColor(themeManager.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(themeManager.primary, lineWidth: 2)
                )
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.1), value: isLoading)
    }
}

/// Text button style for text-only actions
struct EraTextButtonStyle: ButtonStyle {
    
    // MARK: - Properties
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Initializers
    /// Default initializer
    init(isLoading: Bool = false, isDisabled: Bool = false) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }
    
    // MARK: - Button Style Implementation
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primary))
                    .scaleEffect(0.8)
            }
            
            configuration.label
                .font(.headline.weight(.semibold))
                .foregroundColor(themeManager.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.1), value: isLoading)
    }
}

// MARK: - Era Button Components
// These are pre-built button components for common use cases

/// A primary action button with loading state
struct EraPrimaryButton: View {
    
    // MARK: - Properties
    /// The text to display on the button
    let title: String
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    /// Custom corner radius for the button
    let cornerRadius: CGFloat
    
    // MARK: - Initializers
    /// Default initializer
    init(
        _ title: String,
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        cornerRadius: CGFloat = 16
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(EraPrimaryButtonStyle(
            isLoading: isLoading,
            isDisabled: isDisabled,
            cornerRadius: cornerRadius
        ))
        .disabled(isDisabled || isLoading)
    }
}

/// A secondary action button with loading state
struct EraSecondaryButton: View {
    
    // MARK: - Properties
    /// The text to display on the button
    let title: String
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    /// Custom corner radius for the button
    let cornerRadius: CGFloat
    
    // MARK: - Initializers
    /// Default initializer
    init(
        _ title: String,
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        cornerRadius: CGFloat = 16
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(EraSecondaryButtonStyle(
            isLoading: isLoading,
            isDisabled: isDisabled,
            cornerRadius: cornerRadius
        ))
        .disabled(isDisabled || isLoading)
    }
}

/// A text-only button with loading state
struct EraTextButton: View {
    
    // MARK: - Properties
    /// The text to display on the button
    let title: String
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// Whether the button is currently loading
    let isLoading: Bool
    
    /// Whether the button is disabled
    let isDisabled: Bool
    
    // MARK: - Initializers
    /// Default initializer
    init(
        _ title: String,
        action: @escaping () -> Void,
        isLoading: Bool = false,
        isDisabled: Bool = false
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }
    
    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(EraTextButtonStyle(
            isLoading: isLoading,
            isDisabled: isDisabled
        ))
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Era Button Components")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(spacing: 16) {
            EraPrimaryButton("Primary Button") {
                print("Primary button tapped")
            }
            
            EraSecondaryButton("Secondary Button") {
                print("Secondary button tapped")
            }
            
            EraTextButton("Text Button") {
                print("Text button tapped")
            }
            
            EraPrimaryButton("Loading Button", action: {}, isLoading: true)
            
            EraPrimaryButton("Disabled Button", action: {}, isDisabled: true)
        }
    }
    .padding()
    .environmentObject(ThemeManager.shared)
}
