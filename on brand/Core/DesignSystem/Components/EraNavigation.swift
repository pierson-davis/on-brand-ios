//
//  EraNavigation.swift
//  on brand
//
//  This file contains all navigation-related components for the Era design system.
//  It includes top bars, bottom navigation, and navigation utilities.
//
//  Created by Pierson Davis on 9/26/25.
//  Refactored for modularity on January 2025.
//

import SwiftUI

// MARK: - Era Top Bar
// This is the standard top bar component used throughout the app
struct EraTopBar: View {
    
    // MARK: - Properties
    /// The title of the top bar
    var title: String
    
    /// The subtitle of the top bar (optional)
    var subtitle: String?
    
    /// The trailing content of the top bar (optional)
    var trailing: AnyView?
    
    /// Whether to show the back button
    var showBackButton: Bool = false
    
    /// The action to perform when the back button is tapped
    var onBackTapped: (() -> Void)?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                if showBackButton {
                    Button(action: onBackTapped ?? {}) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(themeManager.textPrimary)
                    }
                    .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(themeManager.textSecondary)
                    }
                }
                
                Spacer()
                
                if let trailing = trailing {
                    trailing
                }
            }
        }
    }
}

// MARK: - Era Bottom Navigation Bar
// This is the main bottom navigation component
struct EraBottomNavigationBar: View {
    
    // MARK: - Properties
    /// Binding to the currently selected tab
    @Binding var selectedTab: Tab
    
    /// The user's archetype for display purposes
    let userArchetype: Archetype
    
    /// The action to perform when the add photo button is tapped
    let onAddPhoto: (() -> Void)?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Tab Enumeration
    /// The available tabs in the bottom navigation
    enum Tab: CaseIterable {
        case home, plus, deals, profile
        
        /// The icon for each tab
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .plus: return "plus"
            case .deals: return "dollarsign.circle.fill"
            case .profile: return "person.circle.fill"
            }
        }
        
        /// The title for each tab
        var title: String {
            switch self {
            case .home: return "Home"
            case .plus: return "Add"
            case .deals: return "Deals"
            case .profile: return "Profile"
            }
        }
    }
    
    // MARK: - Main Body
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
                                    .fill(themeManager.primary)
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
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(themeManager.surfaceOutline)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Era Section Header
// This is a header component for sections
struct EraSectionHeader: View {
    
    // MARK: - Properties
    /// The title of the section
    var title: String
    
    /// The subtitle of the section (optional)
    var subtitle: String?
    
    /// The action button for the section (optional)
    var actionButton: AnyView?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(themeManager.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(themeManager.textSecondary)
                    }
                }
                
                Spacer()
                
                if let actionButton = actionButton {
                    actionButton
                }
            }
        }
    }
}

// MARK: - Era Badge
// This is a badge component for labels and tags
struct EraBadge: View {
    
    // MARK: - Properties
    /// The text to display in the badge
    let text: String
    
    /// The color of the badge
    let color: Color?
    
    /// The background color of the badge
    let backgroundColor: Color?
    
    /// The font size of the badge
    let fontSize: Font
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Initializers
    /// Default initializer
    init(
        _ text: String,
        color: Color? = nil,
        backgroundColor: Color? = nil,
        fontSize: Font = .caption.bold()
    ) {
        self.text = text
        self.color = color
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
    }
    
    // MARK: - Main Body
    var body: some View {
        Text(text.uppercased())
            .font(fontSize)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor ?? themeManager.buttonBackground)
            .foregroundColor(color ?? themeManager.textSecondary)
            .clipShape(Capsule())
    }
}

// MARK: - Preview
// This section provides a preview for Xcode's canvas
#Preview {
    VStack(spacing: 20) {
        Text("Era Navigation Components")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(spacing: 16) {
            EraTopBar(
                title: "Welcome",
                subtitle: "Good morning!",
                trailing: AnyView(
                    Button("Edit") {
                        print("Edit tapped")
                    }
                )
            )
            
            EraSectionHeader(
                title: "Recent Activity",
                subtitle: "Your latest updates",
                actionButton: AnyView(
                    Button("View All") {
                        print("View All tapped")
                    }
                )
            )
            
            HStack {
                EraBadge("New")
                EraBadge("Featured", color: .white, backgroundColor: .blue)
                EraBadge("Popular", color: .green, backgroundColor: .green.opacity(0.2))
            }
            
            EraBottomNavigationBar(
                selectedTab: .constant(.home),
                userArchetype: .mainCharacter,
                onAddPhoto: {
                    print("Add photo tapped")
                }
            )
        }
    }
    .padding()
    .environmentObject(ThemeManager.shared)
}
