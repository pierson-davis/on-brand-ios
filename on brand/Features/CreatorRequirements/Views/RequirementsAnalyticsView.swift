//
//  RequirementsAnalyticsView.swift
//  on brand
//
//  This file defines the view for displaying creator requirements analytics.
//  Provides comprehensive insights into requirement performance and trends.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import Charts

/// View for displaying creator requirements analytics
struct RequirementsAnalyticsView: View {
    
    // MARK: - Properties
    
    /// Analytics data to display
    let analytics: RequirementAnalytics
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Presentation mode for dismissing the view
    @Environment(\.presentationMode) private var presentationMode
    
    /// Selected time period for analytics
    @State private var selectedTimePeriod: TimePeriod = .allTime
    
    /// Selected chart type
    @State private var selectedChartType: ChartType = .completionRate
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Header Section
                    headerSection
                    
                    // MARK: - Overview Cards
                    overviewCardsSection
                    
                    // MARK: - Charts Section
                    chartsSection
                    
                    // MARK: - Breakdown Sections
                    breakdownSections
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Button(period.displayName) {
                                selectedTimePeriod = period
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundColor(themeManager.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Requirements Analytics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text("Insights into your creator requirements performance")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Overview Cards Section
    
    private var overviewCardsSection: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                OverviewCard(
                    title: "Total Requirements",
                    value: "\(analytics.totalRequirements)",
                    subtitle: "All time",
                    color: themeManager.primary,
                    icon: "list.bullet"
                )
                
                OverviewCard(
                    title: "Completion Rate",
                    value: "\(Int(analytics.completionRate * 100))%",
                    subtitle: "Success rate",
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                OverviewCard(
                    title: "Pending",
                    value: "\(analytics.pendingRequirements)",
                    subtitle: "In progress",
                    color: .orange,
                    icon: "clock.fill"
                )
                
                OverviewCard(
                    title: "Overdue",
                    value: "\(analytics.overdueRequirements)",
                    subtitle: "Need attention",
                    color: .red,
                    icon: "exclamationmark.triangle.fill"
                )
            }
        }
    }
    
    // MARK: - Charts Section
    
    private var chartsSection: some View {
        VStack(spacing: 16) {
            Text("Performance Trends")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Chart Type Picker
            Picker("Chart Type", selection: $selectedChartType) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Chart Content
            chartContent
        }
    }
    
    // MARK: - Chart Content
    
    private var chartContent: some View {
        Group {
            switch selectedChartType {
            case .completionRate:
                completionRateChart
            case .requirementsByType:
                requirementsByTypeChart
            case .requirementsByStatus:
                requirementsByStatusChart
            case .requirementsByPriority:
                requirementsByPriorityChart
            case .requirementsByBrand:
                requirementsByBrandChart
            }
        }
        .frame(height: 200)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Completion Rate Chart
    
    private var completionRateChart: some View {
        VStack {
            Text("Completion Rate Over Time")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Simple completion rate visualization
            HStack {
                VStack(alignment: .leading) {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    Text("\(analytics.completedRequirements)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    Text("\(analytics.totalRequirements)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
            
            Spacer()
            
            // Progress bar
            ProgressView(value: analytics.completionRate)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .scaleEffect(x: 1, y: 3, anchor: .center)
        }
    }
    
    // MARK: - Requirements by Type Chart
    
    private var requirementsByTypeChart: some View {
        VStack {
            Text("Requirements by Type")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Simple bar chart representation
            VStack(spacing: 8) {
                ForEach(Array(analytics.requirementsByType.keys.prefix(5)), id: \.self) { type in
                    if let count = analytics.requirementsByType[type] {
                        HStack {
                            Text(type)
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                                .frame(width: 80, alignment: .leading)
                            
                            Rectangle()
                                .fill(themeManager.primary)
                                .frame(width: CGFloat(count) * 2, height: 8)
                                .cornerRadius(4)
                            
                            Text("\(count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Requirements by Status Chart
    
    private var requirementsByStatusChart: some View {
        VStack {
            Text("Requirements by Status")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Status breakdown
            VStack(spacing: 8) {
                ForEach(Array(analytics.requirementsByStatus.keys), id: \.self) { status in
                    if let count = analytics.requirementsByStatus[status] {
                        HStack {
                            Circle()
                                .fill(Color(status))
                                .frame(width: 8, height: 8)
                            
                            Text(status)
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Requirements by Priority Chart
    
    private var requirementsByPriorityChart: some View {
        VStack {
            Text("Requirements by Priority")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Priority breakdown
            VStack(spacing: 8) {
                ForEach(Array(analytics.requirementsByPriority.keys), id: \.self) { priority in
                    if let count = analytics.requirementsByPriority[priority] {
                        HStack {
                            Circle()
                                .fill(Color(priority))
                                .frame(width: 8, height: 8)
                            
                            Text(priority)
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Requirements by Brand Chart
    
    private var requirementsByBrandChart: some View {
        VStack {
            Text("Requirements by Brand")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
            
            // Brand breakdown
            VStack(spacing: 8) {
                ForEach(Array(analytics.requirementsByBrand.keys.prefix(5)), id: \.self) { brand in
                    if let count = analytics.requirementsByBrand[brand] {
                        HStack {
                            Text(brand)
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                                .frame(width: 100, alignment: .leading)
                            
                            Rectangle()
                                .fill(themeManager.secondary)
                                .frame(width: CGFloat(count) * 2, height: 8)
                                .cornerRadius(4)
                            
                            Text("\(count)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Breakdown Sections
    
    private var breakdownSections: some View {
        VStack(spacing: 24) {
            // Requirements by Type
            breakdownSection(
                title: "Requirements by Type",
                data: analytics.requirementsByType,
                color: themeManager.primary
            )
            
            // Requirements by Status
            breakdownSection(
                title: "Requirements by Status",
                data: analytics.requirementsByStatus,
                color: themeManager.secondary
            )
            
            // Requirements by Priority
            breakdownSection(
                title: "Requirements by Priority",
                data: analytics.requirementsByPriority,
                color: themeManager.accent
            )
            
            // Requirements by Brand
            breakdownSection(
                title: "Requirements by Brand",
                data: analytics.requirementsByBrand,
                color: themeManager.primary
            )
        }
    }
    
    // MARK: - Breakdown Section
    
    private func breakdownSection(title: String, data: [String: Int], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(spacing: 8) {
                ForEach(Array(data.keys.sorted()), id: \.self) { key in
                    if let value = data[key] {
                        HStack {
                            Text(key)
                                .font(.subheadline)
                                .foregroundColor(themeManager.textSecondary)
                            
                            Spacer()
                            
                            Text("\(value)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeManager.surface)
            )
        }
    }
}

// MARK: - Overview Card Component

struct OverviewCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textPrimary)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(themeManager.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Supporting Types

/// Time period for analytics
enum TimePeriod: String, CaseIterable {
    case allTime = "all_time"
    case lastWeek = "last_week"
    case lastMonth = "last_month"
    case lastQuarter = "last_quarter"
    case lastYear = "last_year"
    
    var displayName: String {
        switch self {
        case .allTime:
            return "All Time"
        case .lastWeek:
            return "Last Week"
        case .lastMonth:
            return "Last Month"
        case .lastQuarter:
            return "Last Quarter"
        case .lastYear:
            return "Last Year"
        }
    }
}

/// Chart type for analytics
enum ChartType: String, CaseIterable {
    case completionRate = "completion_rate"
    case requirementsByType = "requirements_by_type"
    case requirementsByStatus = "requirements_by_status"
    case requirementsByPriority = "requirements_by_priority"
    case requirementsByBrand = "requirements_by_brand"
    
    var displayName: String {
        switch self {
        case .completionRate:
            return "Completion Rate"
        case .requirementsByType:
            return "By Type"
        case .requirementsByStatus:
            return "By Status"
        case .requirementsByPriority:
            return "By Priority"
        case .requirementsByBrand:
            return "By Brand"
        }
    }
}

// MARK: - Preview

struct RequirementsAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementsAnalyticsView(
            analytics: RequirementAnalytics(
                totalRequirements: 25,
                completedRequirements: 18,
                pendingRequirements: 5,
                inProgressRequirements: 2,
                overdueRequirements: 3,
                completionRate: 0.72,
                averageCompletionTime: 86400,
                requirementsByType: [
                    "instagram_post": 10,
                    "instagram_story": 8,
                    "image_assets": 5,
                    "video_assets": 2
                ],
                requirementsByStatus: [
                    "completed": 18,
                    "pending": 5,
                    "in_progress": 2
                ],
                requirementsByPriority: [
                    "high": 8,
                    "medium": 12,
                    "low": 5
                ],
                requirementsByBrand: [
                    "Breakaway": 15,
                    "AKA": 10
                ],
                requirementsByCampaign: [
                    "Philly 2025": 15,
                    "Rittenhouse Square": 10
                ]
            )
        )
        .environmentObject(ThemeManager.shared)
    }
}
