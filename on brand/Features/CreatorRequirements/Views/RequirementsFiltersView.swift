//
//  RequirementsFiltersView.swift
//  on brand
//
//  This file defines the view for filtering creator requirements.
//  Provides simple and intuitive filtering options for managing requirements.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// Simple view for filtering creator requirements
struct RequirementsFiltersView: View {
    
    // MARK: - Properties
    
    /// Manager for creator requirements
    @ObservedObject var requirementsManager: CreatorRequirementsManager
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Presentation mode for dismissing the view
    @Environment(\.presentationMode) private var presentationMode
    
    /// Current filter state
    @State private var filters: RequirementFilters
    
    // MARK: - Initialization
    
    init(requirementsManager: CreatorRequirementsManager) {
        self.requirementsManager = requirementsManager
        self._filters = State(initialValue: requirementsManager.currentFilters)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerSection
            
            // MARK: - Filter Content
            ScrollView {
                VStack(spacing: 20) {
                    // Status Filter - Simple
                    simpleStatusFilter
                    
                    // Type Filter - Simple
                    simpleTypeFilter
                    
                    // Sort Options - Simple
                    simpleSortOptions
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            // MARK: - Action Buttons
            actionButtons
        }
        .background(themeManager.backgroundTop)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Add top padding
            Spacer()
                .frame(height: 20)
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                
                Spacer()
                
                Text("Filter Deals")
                    .font(.title2.bold())
                    .foregroundColor(themeManager.textPrimary)
                
                Spacer()
                
                Button("Clear") {
                    clearAllFilters()
                }
                .font(.subheadline)
                .foregroundColor(themeManager.primary)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(themeManager.surface)
    }
    
    // MARK: - Simple Status Filter
    
    private var simpleStatusFilter: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(RequirementStatus.allCases, id: \.self) { status in
                    FilterChip(
                        title: status.displayName,
                        isSelected: filters.statuses.contains(status),
                        color: statusColor(for: status),
                        action: {
                            toggleStatusFilter(status)
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Simple Type Filter
    
    private var simpleTypeFilter: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Deal Type")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(RequirementType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.displayName,
                        isSelected: filters.types.contains(type),
                        color: themeManager.primary,
                        action: {
                            toggleTypeFilter(type)
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Simple Sort Options
    
    private var simpleSortOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort By")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(spacing: 8) {
                ForEach(SimpleSortOption.allCases, id: \.self) { option in
                    SortOptionRow(
                        option: option,
                        isSelected: filters.sortBy.rawValue == option.rawValue,
                        action: {
                            // Convert to the manager's SortOption
                            switch option {
                            case .dueDate:
                                filters.sortBy = .dueDate
                            case .createdDate:
                                filters.sortBy = .createdDate
                            case .status:
                                filters.sortBy = .status
                            case .type:
                                filters.sortBy = .title
                            case .title:
                                filters.sortBy = .title
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Apply Filters Button
            Button(action: applyFilters) {
                Text("Apply Filters")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.primary)
                    )
            }
            
            // Reset Button
            Button(action: resetFilters) {
                Text("Reset")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeManager.surface)
    }
    
    // MARK: - Helper Methods
    
    private func toggleStatusFilter(_ status: RequirementStatus) {
        if filters.statuses.contains(status) {
            filters.statuses.removeAll { $0 == status }
        } else {
            filters.statuses.append(status)
        }
    }
    
    private func toggleTypeFilter(_ type: RequirementType) {
        if filters.types.contains(type) {
            filters.types.removeAll { $0 == type }
        } else {
            filters.types.append(type)
        }
    }
    
    private func applyFilters() {
        requirementsManager.applyFilters(filters)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func resetFilters() {
        filters = RequirementFilters()
    }
    
    private func clearAllFilters() {
        filters = RequirementFilters()
        requirementsManager.applyFilters(filters)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func statusColor(for status: RequirementStatus) -> Color {
        switch status.color {
        case "orange":
            return .orange
        case "blue":
            return .blue
        case "green":
            return .green
        case "purple":
            return .purple
        case "red":
            return .red
        case "gray":
            return .gray
        case "yellow":
            return .yellow
        default:
            return .gray
        }
    }
}

// MARK: - Supporting Views

/// Filter chip for status and type filters
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Sort option row
struct SortOptionRow: View {
    let option: SimpleSortOption
    let isSelected: Bool
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option.displayName)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.subheadline)
                        .foregroundColor(themeManager.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? themeManager.primary.opacity(0.1) : themeManager.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Types

/// Simple sort options for requirements
enum SimpleSortOption: String, CaseIterable {
    case dueDate = "due_date"
    case createdDate = "created_date"
    case status = "status"
    case type = "type"
    case title = "title"
    
    var displayName: String {
        switch self {
        case .dueDate:
            return "Due Date"
        case .createdDate:
            return "Created Date"
        case .status:
            return "Status"
        case .type:
            return "Type"
        case .title:
            return "Title"
        }
    }
}

// MARK: - Preview

struct RequirementsFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementsFiltersView(requirementsManager: CreatorRequirementsManager { _ in })
            .environmentObject(ThemeManager.shared)
    }
}