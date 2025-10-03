//
//  RequirementCard.swift
//  on brand
//
//  This file defines the requirement card component for displaying
//  individual creator requirements in a list format.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// Card component for displaying a creator requirement
struct RequirementCard: View {
    
    // MARK: - Properties
    
    /// The requirement to display
    let requirement: CreatorRequirement
    
    /// Action to perform when card is tapped
    let onTap: () -> Void
    
    /// Action to perform when status is changed
    let onStatusChange: (RequirementStatus) -> Void
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Whether the card is expanded
    @State private var isExpanded = false
    
    /// Whether the status menu is showing
    @State private var showingStatusMenu = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - Main Content
            VStack(alignment: .leading, spacing: 12) {
                // Header Row
                headerRow
                
                // Title and Description
                titleSection
                
                // Tags and Badges
                tagsSection
                
                // Progress and Status
                progressSection
                
                // Expanded Content
                if isExpanded {
                    expandedContent
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.backgroundTop)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            contextMenuItems
        }
    }
    
    // MARK: - Header Row
    
    private var headerRow: some View {
        HStack {
            // Type Icon
            Image(systemName: requirement.type.iconName)
                .font(.title3)
                .foregroundColor(Color(requirement.type.color))
                .frame(width: 24, height: 24)
            
            // Brand and Campaign
            VStack(alignment: .leading, spacing: 2) {
                Text(requirement.brandName)
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                if let campaign = requirement.campaignName {
                    Text(campaign)
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
            }
            
            Spacer()
            
            // Priority Badge
            priorityBadge
            
            // Status Menu
            statusMenu
        }
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(requirement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
                .lineLimit(2)
            
            Text(requirement.description)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
                .lineLimit(isExpanded ? nil : 2)
        }
    }
    
    // MARK: - Tags Section
    
    private var tagsSection: some View {
        HStack(spacing: 8) {
            // Status Tag
            statusTag
            
            // Type Tag
            typeTag
            
            // Priority Tag
            if requirement.priority != .medium {
                priorityTag
            }
            
            // Overdue Tag
            if requirement.isOverdue {
                overdueTag
            }
            
            Spacer()
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        HStack {
            // Due Date
            if let dueDate = requirement.dueDate {
                dueDateInfo(dueDate)
            }
            
            Spacer()
            
            // Completion Status
            completionStatus
        }
    }
    
    // MARK: - Expanded Content
    
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
                .background(themeManager.textSecondary.opacity(0.2))
            
            // Requirements Details
            requirementsDetails
            
            // Comments Section
            if !requirement.comments.isEmpty {
                commentsSection
            }
            
            // Action Buttons
            actionButtons
        }
    }
    
    // MARK: - Priority Badge
    
    private var priorityBadge: some View {
        Circle()
            .fill(Color(requirement.priority.color))
            .frame(width: 8, height: 8)
    }
    
    // MARK: - Status Menu
    
    private var statusMenu: some View {
        Menu {
            ForEach(RequirementStatus.allCases, id: \.self) { status in
                Button(action: { onStatusChange(status) }) {
                    HStack {
                        Text(status.displayName)
                        if requirement.status == status {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(requirement.status.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(statusColor(for: requirement.status))
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundColor(statusColor(for: requirement.status))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(statusColor(for: requirement.status).opacity(0.1))
            )
        }
    }
    
    // MARK: - Helper Functions
    
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
    
    // MARK: - Status Tag
    
    private var statusTag: some View {
        Text(requirement.status.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(Color(requirement.status.color))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(statusColor(for: requirement.status).opacity(0.1))
            )
    }
    
    // MARK: - Type Tag
    
    private var typeTag: some View {
        Text(requirement.type.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(Color(requirement.type.color))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(requirement.type.color).opacity(0.1))
            )
    }
    
    // MARK: - Priority Tag
    
    private var priorityTag: some View {
        Text(requirement.priority.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(Color(requirement.priority.color))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(requirement.priority.color).opacity(0.1))
            )
    }
    
    // MARK: - Overdue Tag
    
    private var overdueTag: some View {
        Text("OVERDUE")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.red)
            )
    }
    
    // MARK: - Due Date Info
    
    private func dueDateInfo(_ dueDate: Date) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.caption2)
                .foregroundColor(themeManager.textSecondary)
            
            Text(dueDate, style: .date)
                .font(.caption)
                .foregroundColor(requirement.isOverdue ? .red : themeManager.textSecondary)
        }
    }
    
    // MARK: - Completion Status
    
    private var completionStatus: some View {
        HStack(spacing: 4) {
            if requirement.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            } else if requirement.isVerified {
                Image(systemName: "checkmark.shield.fill")
                    .font(.caption)
                    .foregroundColor(.purple)
            } else {
                Image(systemName: "circle")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
        }
    }
    
    // MARK: - Requirements Details
    
    private var requirementsDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Tagging Requirements
            if let tagging = requirement.taggingRequirements {
                taggingDetails(tagging)
            }
            
            // Link Requirements
            if let links = requirement.linkRequirements {
                linkDetails(links)
            }
            
            // Hashtag Requirements
            if let hashtags = requirement.hashtagRequirements {
                hashtagDetails(hashtags)
            }
            
            // Asset Requirements
            if let assets = requirement.assetRequirements {
                assetDetails(assets)
            }
        }
    }
    
    // MARK: - Tagging Details
    
    private func taggingDetails(_ tagging: TaggingRequirements) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Tagging Requirements")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !tagging.accountsToTag.isEmpty {
                HStack {
                    Text("Required Accounts:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(tagging.accountsToTag.map { "@\($0)" }.joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
            
            if !tagging.locationsToTag.isEmpty {
                HStack {
                    Text("Required Locations:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(tagging.locationsToTag.joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Link Details
    
    private func linkDetails(_ links: LinkRequirements) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Link Requirements")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !links.url.isEmpty {
                HStack {
                    Text("Required Links:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text("1 link")
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
            
            if !links.url.isEmpty {
                HStack {
                    Text("Promo Codes:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(links.url)
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Hashtag Details
    
    private func hashtagDetails(_ hashtags: HashtagRequirements) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hashtag Requirements")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !hashtags.requiredHashtags.isEmpty {
                HStack {
                    Text("Required Hashtags:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(hashtags.requiredHashtags.map { "#\($0)" }.joined(separator: " "))
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Asset Details
    
    private func assetDetails(_ assets: AssetRequirements) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Asset Requirements")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if true {
                HStack {
                    Text("Required Assets:")
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text("\(assets.quantity) assets")
                        .font(.caption2)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Comments Section
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Comments (\(requirement.comments.count))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            ForEach(requirement.comments.prefix(2)) { comment in
                commentRow(comment)
            }
            
            if requirement.comments.count > 2 {
                Text("+ \(requirement.comments.count - 2) more comments")
                    .font(.caption2)
                    .foregroundColor(themeManager.textSecondary)
            }
        }
    }
    
    // MARK: - Comment Row
    
    private func commentRow(_ comment: RequirementComment) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(comment.isFromBrand ? themeManager.primary : themeManager.textSecondary)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(comment.author)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textPrimary)
                
                Text(comment.text)
                    .font(.caption2)
                    .foregroundColor(themeManager.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: { isExpanded.toggle() }) {
                HStack(spacing: 4) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    Text(isExpanded ? "Less" : "More")
                }
                .font(.caption)
                .foregroundColor(themeManager.primary)
            }
            
            Spacer()
            
            if !requirement.isCompleted {
                Button(action: { onStatusChange(.completed) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle")
                        Text("Mark Complete")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(themeManager.primary)
                    .cornerRadius(6)
                }
            }
        }
    }
    
    // MARK: - Context Menu Items
    
    private var contextMenuItems: some View {
        Group {
            Button(action: { onTap() }) {
                Label("View Details", systemImage: "eye")
            }
            
            if !requirement.isCompleted {
                Button(action: { onStatusChange(.completed) }) {
                    Label("Mark Complete", systemImage: "checkmark.circle")
                }
            }
            
            if requirement.isCompleted && !requirement.isVerified {
                Button(action: { onStatusChange(.verified) }) {
                    Label("Mark Verified", systemImage: "checkmark.shield")
                }
            }
            
            Button(action: { isExpanded.toggle() }) {
                Label(isExpanded ? "Collapse" : "Expand", systemImage: isExpanded ? "chevron.up" : "chevron.down")
            }
        }
    }
}

// MARK: - Preview

struct RequirementCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            RequirementCard(
                requirement: CreatorRequirement(
                    type: .instagramPost,
                    title: "Post Breakaway Festival Content",
                    description: "Create and post content about the Breakaway Music Festival",
                    brandName: "Breakaway",
                    campaignName: "Philly 2025",
                    dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                    priority: .high,
                    taggingRequirements: TaggingRequirements(
                        accountsToTag: ["breakaway", "breakawayphilly"],
                        locationsToTag: ["Breakaway Music Festival"],
                        placementRules: nil,
                        formatRequirements: nil,
                        verificationSettings: nil,
                        trackingSettings: nil
                    ),
                    hashtagRequirements: HashtagRequirements(
                        requiredHashtags: ["breakaway", "musicfestival", "philly2025"],
                        optionalHashtags: ["festival", "live", "music"],
                        placementRules: nil,
                        formatRequirements: nil,
                        trackingSettings: nil
                    )
                ),
                onTap: {},
                onStatusChange: { _ in }
            )
            
            RequirementCard(
                requirement: CreatorRequirement(
                    type: .imageAssets,
                    title: "Deliver High-Res Images",
                    description: "Provide 10 high-resolution images from the AKA hotel stay",
                    brandName: "AKA",
                    campaignName: "Rittenhouse Square",
                    dueDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                    priority: .critical
                ),
                onTap: {},
                onStatusChange: { _ in }
            )
        }
        .padding()
        .environmentObject(ThemeManager.shared)
    }
}
