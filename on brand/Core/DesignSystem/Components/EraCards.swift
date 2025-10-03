//
//  EraCards.swift
//  on brand
//
//  This file contains all card-related components for the Era design system.
//  It includes surface cards, selectable cards, and specialized card types.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Era Surface Card
// This is the main card component used throughout the app
struct EraSurfaceCard<Content: View>: View {
    
    // MARK: - Properties
    /// Corner radius for the card
    var cornerRadius: CGFloat = 28
    
    /// Padding inside the card
    var padding: CGFloat = 24
    
    /// Whether the card has a shadow
    var hasShadow: Bool = true
    
    /// Whether the card has a border
    var hasBorder: Bool = true
    
    /// Custom shadow color
    var shadowColor: Color = Color.black.opacity(0.08)
    
    /// Custom shadow radius
    var shadowRadius: CGFloat = 16
    
    /// Custom shadow offset
    var shadowOffset: CGSize = CGSize(width: 0, height: 12)
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Content
    /// The content to display inside the card
    @ViewBuilder var content: () -> Content
    
    // MARK: - Main Body
    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(themeManager.surfaceOutline)
                            .opacity(hasBorder ? 1.0 : 0.0)
                    )
                    .shadow(
                        color: shadowColor,
                        radius: hasShadow ? shadowRadius : 0,
                        x: hasShadow ? shadowOffset.width : 0,
                        y: hasShadow ? shadowOffset.height : 0
                    )
            )
    }
}

// MARK: - Era Selectable Card
// This is a card that can be selected and shows selection state
struct EraSelectableCard<Content: View>: View {
    
    // MARK: - Properties
    /// Whether the card is currently selected
    var isSelected: Bool
    
    /// The action to perform when the card is tapped
    var action: () -> Void
    
    /// Corner radius for the card
    var cornerRadius: CGFloat = 22
    
    /// Padding inside the card
    var padding: CGFloat = 22
    
    /// Whether to show the selection indicator
    var showSelectionIndicator: Bool = true
    
    /// Custom selection indicator color
    var selectionColor: Color?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Content
    /// The content to display inside the card
    @ViewBuilder var label: () -> Content
    
    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                label()
                
                Spacer(minLength: 12)
                
                if showSelectionIndicator {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(selectionColor ?? (isSelected ? themeManager.primary : themeManager.textSecondary))
                        .padding(.leading, 8)
                }
            }
            .padding(padding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                isSelected ? themeManager.primary : themeManager.surfaceOutline,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Era Info Card
// This is a specialized card for displaying information
struct EraInfoCard: View {
    
    // MARK: - Properties
    /// The title of the card
    let title: String
    
    /// The subtitle of the card
    let subtitle: String?
    
    /// The icon to display
    let icon: String?
    
    /// The action to perform when the card is tapped
    let action: (() -> Void)?
    
    /// Whether the card is clickable
    var isClickable: Bool {
        action != nil
    }
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 16) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(themeManager.primary)
                        .frame(width: 32, height: 32)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(themeManager.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                if isClickable {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(themeManager.surfaceOutline)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(!isClickable)
    }
}

// MARK: - Era Stats Card
// This is a specialized card for displaying statistics
struct EraStatsCard: View {
    
    // MARK: - Properties
    /// The title of the stats card
    let title: String
    
    /// The value to display
    let value: String
    
    /// The subtitle or description
    let subtitle: String?
    
    /// The icon to display
    let icon: String?
    
    /// The color theme for the card
    let color: Color?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color ?? themeManager.primary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(themeManager.textPrimary)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textSecondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(themeManager.surfaceOutline)
                )
        )
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("Era Card Components")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                EraSurfaceCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Surface Card")
                            .font(.headline)
                        Text("This is a standard surface card with content.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                EraSelectableCard(isSelected: true, action: {}) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selectable Card")
                            .font(.headline)
                        Text("This card can be selected.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                EraInfoCard(
                    title: "Info Card",
                    subtitle: "This is an info card with an icon",
                    icon: "info.circle",
                    action: {}
                )
                
                EraStatsCard(
                    title: "Total Posts",
                    value: "42",
                    subtitle: "This month",
                    icon: "photo.stack",
                    color: .blue
                )
            }
        }
        .padding()
    }
    .environmentObject(ThemeManager.shared)
}

// MARK: - Vibe Summary Card
// This component displays a summary of the user's vibe analysis results
struct VibeSummaryCard: View {
    
    // MARK: - Properties
    /// The vibe analysis result to display
    var result: VibeResult
    
    /// Optional callback when the profile button is tapped
    var onProfileTap: (() -> Void)?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        EraSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Header Section
                // This contains the primary archetype title and description
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(result.primary.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.textPrimary)
                        Text(result.description)
                            .font(.subheadline)
                            .foregroundColor(themeManager.textSecondary)
                    }
                    Spacer()
                    
                    // MARK: - Profile Button
                    // This is a circular button that shows the archetype initial
                    VStack(spacing: 4) {
                        Button(action: {
                            onProfileTap?()
                        }) {
                            Circle()
                                .fill(result.primary.tint.opacity(0.2))
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Text(result.primary.rawValue.prefix(1).uppercased())
                                        .font(.title.bold())
                                        .foregroundColor(result.primary.tint)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(result.primary.tint.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 0.1), value: false)
                        
                        Text("View Profile")
                            .font(.caption2)
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                }

                // MARK: - Secondary Archetype Section
                // This shows the secondary archetype if available
                if let secondary = result.secondary {
                    EraBadge("Complement")
                    Text(secondary.title)
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
