import SwiftUI

// MARK: - Era Design System
// This file now serves as the main entry point for the modular design system.
// All components have been moved to separate files for better organization.

// MARK: - EraPalette
// This enum has been moved to EraColorPalette.swift for better organization

// MARK: - EraBackground
// This component has been moved to EraBackground.swift for better organization
/*
struct EraBackground: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        LinearGradient(
            colors: [themeManager.backgroundTop, themeManager.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .drawingGroup() // Optimize rendering performance
        .id("background-\(themeManager.colorScheme)") // Dynamic identifier for theme changes
    }
}
*/

// MARK: - EraBadge
// This component has been moved to EraCards.swift for better organization
/*
struct EraBadge: View {
    let text: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Text(text.uppercased())
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(themeManager.buttonBackground)
            .foregroundColor(themeManager.textSecondary)
            .clipShape(Capsule())
    }
}
*/

// MARK: - EraTopBar
// This component has been moved to EraNavigation.swift for better organization
/*
struct EraTopBar: View {
    var title: String
    var subtitle: String?
    var trailing: AnyView?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                }
                Spacer()
                if let trailing {
                    trailing
                }
            }
        }
    }
}
*/

// MARK: - EraSurfaceCard
// This component has been moved to EraCards.swift for better organization
/*
struct EraSurfaceCard<Content: View>: View {
    var cornerRadius: CGFloat = 28
    var padding: CGFloat = 24
    @EnvironmentObject private var themeManager: ThemeManager
    @ViewBuilder var content: () -> Content

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
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 12)
            )
    }
}
*/

// MARK: - Button Styles
// Button styles have been moved to EraButtons.swift for better organization

// MARK: - EraSelectableCard
// This component has been moved to EraCards.swift for better organization
/*
struct EraSelectableCard<Content: View>: View {
    var isSelected: Bool
    var action: () -> Void
    @ViewBuilder var label: () -> Content
    
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                label()
                Spacer(minLength: 12)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? themeManager.primary : themeManager.textSecondary)
                    .padding(.leading, 8)
            }
            .padding(22)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(isSelected ? themeManager.primary : themeManager.surfaceOutline, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
*/

// MARK: - EraSectionHeader
// This component has been moved to EraCards.swift for better organization
/*
struct EraSectionHeader: View {
    var title: String
    var subtitle: String?
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(themeManager.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(themeManager.textSecondary)
            }
        }
    }
}
*/

// MARK: - VibeSummaryCard
// This component has been moved to EraCards.swift for better organization
/*
struct VibeSummaryCard: View {
    var result: VibeResult
    var onProfileTap: (() -> Void)?
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        EraSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
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

                if let secondary = result.secondary {
                    EraBadge(text: "Complement")
                    Text(secondary.title)
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
*/

// MARK: - EraBottomNavigationBar
// This component has been moved to EraNavigation.swift for better organization
/*
struct EraBottomNavigationBar: View {
    @Binding var selectedTab: Tab
    let userArchetype: Archetype
    let onAddPhoto: (() -> Void)?
    @EnvironmentObject private var themeManager: ThemeManager
    
    enum Tab: CaseIterable {
        case home, plus, profile
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .plus: return "plus"
            case .profile: return "person.circle.fill"
            }
        }
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .plus: return "Add"
            case .profile: return "Profile"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    if tab == .plus {
                        onAddPhoto?()
                    } else {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if tab == .plus {
                                Circle()
                                    .fill(Color(red: 0.20, green: 0.22, blue: 0.75))
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Image(systemName: tab.icon)
                                            .font(.title2.bold())
                                            .foregroundColor(.white)
                                    )
                        } else {
                            Image(systemName: tab.icon)
                                .font(.title2)
                                .foregroundColor(selectedTab == tab ? themeManager.primary : themeManager.tabBarInactive)
                        }
                    }
                    
                    Text(tab.title)
                        .font(.caption2.bold())
                        .foregroundColor(selectedTab == tab ? themeManager.primary : themeManager.tabBarInactive)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(themeManager.tabBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(themeManager.tabBarBorder, lineWidth: 0.5)
                )
                .shadow(color: themeManager.colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 0) // Remove extra bottom padding that was causing the background to extend too far
    }
}
*/
