//
//  CreatorRequirementsView.swift
//  on brand
//
//  This file defines the main view for managing influencer deals.
//  Provides a comprehensive interface for tracking and managing all deals.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// Main view for managing influencer deals
struct CreatorRequirementsView: View {
    
    // MARK: - Properties
    
    /// Manager for creator requirements
    @StateObject private var requirementsManager = CreatorRequirementsManager { message in
        print("🔧 CreatorRequirements: \(message)")
    }
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Current view state
    @State private var showingAddRequirement = false
    @State private var showingFilters = false
    @State private var showingAnalytics = false
    @State private var selectedRequirement: CreatorRequirement?
    @State private var showingRequirementDetail = false
    
    /// Search text
    @State private var searchText = ""
    
    /// Search bar visibility
    @State private var isSearchVisible = false
    
    /// Selected tab
    @State private var selectedTab: RequirementsTab = .all
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Section
            headerSection
            
            // MARK: - Search Bar (Pull to reveal)
            if isSearchVisible {
                searchBarSection
            }
            
            // MARK: - Tab Section
            tabSection
            
            // MARK: - Content Section
            contentSection
        }
        .background(themeManager.backgroundTop)
        .overlay(
            // Custom toolbar for tab integration
            VStack {
                HStack {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(themeManager.primary)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("Influencer Deals")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: { showingAnalytics = true }) {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(themeManager.primary)
                                .font(.title2)
                        }
                        
                        Button(action: { showingAddRequirement = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(themeManager.primary)
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .background(themeManager.backgroundTop)
                
                Spacer()
            }
        )
        .onChange(of: searchText) { _, newValue in
            var filters = requirementsManager.currentFilters
            filters.searchText = newValue
            requirementsManager.applyFilters(filters)
        }
        .onAppear {
            // Hide search bar when returning to screen
            isSearchVisible = false
        }
        .sheet(isPresented: $showingAddRequirement) {
            AddRequirementView(requirementsManager: requirementsManager)
        }
        .sheet(isPresented: $showingFilters) {
            RequirementsFiltersView(requirementsManager: requirementsManager)
        }
        .sheet(isPresented: $showingAnalytics) {
            RequirementsAnalyticsView(analytics: requirementsManager.getAnalytics())
        }
        .sheet(isPresented: $showingRequirementDetail) {
            if let requirement = selectedRequirement {
                RequirementDetailView(requirement: requirement, requirementsManager: requirementsManager)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            // Add top padding to account for custom toolbar
            Spacer()
                .frame(height: 40)
            
            // Compact Header with Interactive Dollar Sign
            HStack(spacing: 12) {
                // Interactive Dollar Sign Button
                Button(action: { showingAddRequirement = true }) {
                    ZStack {
                        Circle()
                            .fill(themeManager.primary)
                            .frame(width: 50, height: 50)
                            .shadow(color: themeManager.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Text("💰")
                            .font(.title2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("My Deals")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("Track your influencer partnerships")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
                
                // Quick Stats in Header
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("\(requirementsManager.requirements.count)")
                            .font(.headline.bold())
                            .foregroundColor(themeManager.primary)
                        Text("Active")
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                    }
                    
                    VStack(spacing: 2) {
                        Text("\(requirementsManager.completedCount)")
                            .font(.headline.bold())
                            .foregroundColor(.green)
                        Text("Done")
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
        .background(themeManager.surface)
    }
    
    // MARK: - Tab Section
    
    private var tabSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(RequirementsTab.allCases, id: \.self) { tab in
                    SlidingTabButton(
                        title: tab.displayName,
                        isSelected: selectedTab == tab,
                        count: tabCount(for: tab),
                        action: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = tab
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(themeManager.backgroundTop)
    }
    
    // MARK: - Search Bar Section
    
    private var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.textSecondary)
            
            TextField("Search deals...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // MARK: - Content Section
    
    private var contentSection: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Pull to reveal search indicator
                if !isSearchVisible {
                    HStack {
                        Spacer()
                        Text("Pull down to search")
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Group {
                    switch selectedTab {
                    case .all:
                        requirementsList(requirements: requirementsManager.filteredRequirements)
                    case .pending:
                        requirementsList(requirements: requirementsManager.getRequirements(with: .pending))
                    case .inProgress:
                        requirementsList(requirements: requirementsManager.getRequirements(with: .inProgress))
                    case .completed:
                        requirementsList(requirements: requirementsManager.getRequirements(with: .completed))
                    case .overdue:
                        requirementsList(requirements: requirementsManager.getOverdueRequirements())
                    }
                }
            }
        }
        .refreshable {
            // Pull to reveal search
            withAnimation(.easeInOut(duration: 0.3)) {
                isSearchVisible = true
            }
        }
    }
    
    // MARK: - Requirements List
    
    private func requirementsList(requirements: [CreatorRequirement]) -> some View {
        Group {
            if requirements.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(requirements) { requirement in
                            RequirementCard(
                                requirement: requirement,
                                onTap: {
                                    selectedRequirement = requirement
                                    showingRequirementDetail = true
                                },
                                onStatusChange: { newStatus in
                                    requirementsManager.updateStatus(requirement, to: newStatus)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            // Compact empty state
            VStack(spacing: 12) {
                Text("💰")
                    .font(.system(size: 60))
                
                VStack(spacing: 4) {
                    Text("No Deals Yet!")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text("Tap the 💰 button above to add your first deal")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
    }
    
    // MARK: - Helper Methods
    
    private func tabCount(for tab: RequirementsTab) -> Int {
        switch tab {
        case .all:
            return requirementsManager.requirements.count
        case .pending:
            return requirementsManager.pendingCount
        case .inProgress:
            return requirementsManager.inProgressCount
        case .completed:
            return requirementsManager.completedCount
        case .overdue:
            return requirementsManager.overdueCount
        }
    }
}

// MARK: - Supporting Views

/// Sliding tab button for deals tabs - Influencer friendly
struct SlidingTabButton: View {
    let title: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .white : themeManager.textSecondary)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? themeManager.primary : .white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? .white : themeManager.primary)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? themeManager.primary : themeManager.surface)
                    .shadow(color: isSelected ? themeManager.primary.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Simple tab button for deals tabs - Influencer friendly
struct SimpleTabButton: View {
    let title: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? themeManager.primary : themeManager.textSecondary)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected ? themeManager.primary : themeManager.textSecondary)
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? themeManager.primary.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Tab button for deals tabs
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .white : themeManager.textSecondary)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? themeManager.primary : .white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? .white : themeManager.primary)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? themeManager.primary : themeManager.surface)
                    .shadow(color: isSelected ? themeManager.primary.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Simple stat card for displaying metrics - Influencer friendly
struct SimpleStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(themeManager.textPrimary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

/// Stat card for displaying metrics
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            // Value
            Text(value)
                .font(.title.bold())
                .foregroundColor(themeManager.textPrimary)
            
            // Title
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

/// Deals tab enumeration
enum RequirementsTab: String, CaseIterable {
    case all = "all"
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
    case overdue = "overdue"
    
    var displayName: String {
        switch self {
        case .all:
            return "All Deals"
        case .pending:
            return "Pending"
        case .inProgress:
            return "Active"
        case .completed:
            return "Complete"
        case .overdue:
            return "Overdue"
        }
    }
}

// MARK: - Preview

struct CreatorRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorRequirementsView()
            .environmentObject(ThemeManager.shared)
    }
}
