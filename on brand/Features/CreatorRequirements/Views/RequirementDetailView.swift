//
//  RequirementDetailView.swift
//  on brand
//
//  This file defines the detailed view for individual creator requirements.
//  Provides comprehensive information and management for single requirements.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// Detailed view for individual creator requirements
struct RequirementDetailView: View {
    
    // MARK: - Properties
    
    /// The requirement to display
    let requirement: CreatorRequirement
    
    /// Manager for creator requirements
    @ObservedObject var requirementsManager: CreatorRequirementsManager
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Presentation mode for dismissing the view
    @Environment(\.presentationMode) private var presentationMode
    
    /// Current view state
    @State private var showingEditView = false
    @State private var showingCommentSheet = false
    @State private var newComment = ""
    @State private var commentAuthor = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Header Section
                    headerSection
                    
                    // MARK: - Status and Progress Section
                    statusProgressSection
                    
                    // MARK: - Requirements Details Section
                    requirementsDetailsSection
                    
                    // MARK: - Comments Section
                    commentsSection
                    
                    // MARK: - Action Buttons Section
                    actionButtonsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Requirement Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(themeManager.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(themeManager.primary)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditRequirementView(requirement: requirement, requirementsManager: requirementsManager)
        }
        .sheet(isPresented: $showingCommentSheet) {
            AddCommentView(
                requirement: requirement,
                requirementsManager: requirementsManager,
                newComment: $newComment,
                commentAuthor: $commentAuthor
            )
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Type and Brand
            HStack {
                Image(systemName: requirement.type.iconName)
                    .font(.title2)
                    .foregroundColor(Color(requirement.type.color))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(requirement.type.displayName)
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text(requirement.brandName)
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    if let campaign = requirement.campaignName {
                        Text(campaign)
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                    }
                }
                
                Spacer()
                
                // Priority Badge
                priorityBadge
            }
            
            // Title and Description
            VStack(alignment: .leading, spacing: 8) {
                Text(requirement.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textPrimary)
                
                Text(requirement.description)
                    .font(.body)
                    .foregroundColor(themeManager.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Status and Progress Section
    
    private var statusProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status & Progress")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(spacing: 12) {
                // Status Row
                HStack {
                    Text("Status:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Spacer()
                    
                    statusBadge
                }
                
                // Priority Row
                HStack {
                    Text("Priority:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Spacer()
                    
                    priorityBadge
                }
                
                // Due Date Row
                if let dueDate = requirement.dueDate {
                    HStack {
                        Text("Due Date:")
                            .font(.subheadline)
                            .foregroundColor(themeManager.textSecondary)
                        
                        Spacer()
                        
                        Text(dueDate, style: .date)
                            .font(.subheadline)
                            .foregroundColor(requirement.isOverdue ? .red : themeManager.textPrimary)
                    }
                }
                
                // Created Date Row
                HStack {
                    Text("Created:")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Spacer()
                    
                    Text(requirement.createdAt, style: .date)
                        .font(.subheadline)
                        .foregroundColor(themeManager.textPrimary)
                }
                
                // Completion Date Row
                if let completedAt = requirement.completedAt {
                    HStack {
                        Text("Completed:")
                            .font(.subheadline)
                        .foregroundColor(themeManager.textSecondary)
                        
                        Spacer()
                        
                        Text(completedAt, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                
                // Verification Row
                if requirement.isVerified {
                    HStack {
                        Text("Verified by:")
                            .font(.subheadline)
                            .foregroundColor(themeManager.textSecondary)
                        
                        Spacer()
                        
                        Text(requirement.verifiedBy ?? "Unknown")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Requirements Details Section
    
    private var requirementsDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detailed Requirements")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(spacing: 16) {
                // Tagging Requirements
                if let tagging = requirement.taggingRequirements {
                    taggingDetailsSection(tagging)
                }
                
                // Link Requirements
                if let links = requirement.linkRequirements {
                    linkDetailsSection(links)
                }
                
                // Hashtag Requirements
                if let hashtags = requirement.hashtagRequirements {
                    hashtagDetailsSection(hashtags)
                }
                
                // Asset Requirements
                if let assets = requirement.assetRequirements {
                    assetDetailsSection(assets)
                }
                
                // Content Requirements
                if let content = requirement.contentRequirements {
                    contentDetailsSection(content)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Tagging Details Section
    
    private func taggingDetailsSection(_ tagging: TaggingRequirements) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tagging Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !tagging.accountsToTag.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Accounts:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    ForEach(tagging.accountsToTag, id: \.self) { account in
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.caption)
                                .foregroundColor(themeManager.primary)
                            
                            Text("@\(account)")
                                .font(.caption)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
            
            if !tagging.locationsToTag.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Locations:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    ForEach(tagging.locationsToTag, id: \.self) { location in
                        HStack {
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundColor(themeManager.primary)
                            
                            Text(location)
                                .font(.caption)
                                .foregroundColor(themeManager.textPrimary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Link Details Section
    
    private func linkDetailsSection(_ links: LinkRequirements) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Link Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !links.url.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Links:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Link")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.textPrimary)
                        
                        Text(links.url)
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
            
            if !links.url.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Promo Codes:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Link")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.textPrimary)
                        
                        Text(links.url)
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
    
    // MARK: - Hashtag Details Section
    
    private func hashtagDetailsSection(_ hashtags: HashtagRequirements) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hashtag Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if !hashtags.requiredHashtags.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Hashtags:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(hashtags.requiredHashtags.map { "#\($0)" }.joined(separator: " "))
                        .font(.caption)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Asset Details Section
    
    private func assetDetailsSection(_ assets: AssetRequirements) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Asset Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if true {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Assets:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textSecondary)
                    
                    HStack {
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(themeManager.primary)
                        
                        Text(assets.assetType.rawValue)
                            .font(.caption)
                            .foregroundColor(themeManager.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Content Details Section
    
    private func contentDetailsSection(_ content: ContentRequirements) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Content Requirements")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.textPrimary)
            
            if let minimumPosts = content.minimumPosts {
                HStack {
                    Text("Minimum Posts:")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text("\(minimumPosts)")
                        .font(.caption)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
            
            if let format = content.contentFormat {
                HStack {
                    Text("Format:")
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                    
                    Text(format.displayName)
                        .font(.caption)
                        .foregroundColor(themeManager.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Comments Section
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Comments (\(requirement.comments.count))")
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Spacer()
                
                Button("Add Comment") {
                    showingCommentSheet = true
                }
                .font(.caption)
                .foregroundColor(themeManager.primary)
            }
            
            if requirement.comments.isEmpty {
                Text("No comments yet")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textSecondary)
                    .italic()
            } else {
                VStack(spacing: 12) {
                    ForEach(requirement.comments) { comment in
                        commentRow(comment)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Comment Row
    
    private func commentRow(_ comment: RequirementComment) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(comment.isFromBrand ? themeManager.primary : themeManager.textSecondary)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.author)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textPrimary)
                    
                    if comment.isFromBrand {
                        Text("(Brand)")
                            .font(.caption2)
                            .foregroundColor(themeManager.primary)
                    }
                    
                    Spacer()
                    
                    Text(comment.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundColor(themeManager.textSecondary)
                }
                
                Text(comment.text)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    // MARK: - Action Buttons Section
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            if !requirement.isCompleted {
                Button(action: { markCompleted() }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.green)
                    .cornerRadius(8)
                }
            }
            
            if requirement.isCompleted && !requirement.isVerified {
                Button(action: { markVerified() }) {
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                        Text("Mark as Verified")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.purple)
                    .cornerRadius(8)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: { showingCommentSheet = true }) {
                    HStack {
                        Image(systemName: "bubble.left.fill")
                        Text("Add Comment")
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themeManager.primary, lineWidth: 1)
                    )
                }
                
                Button(action: { showingEditView = true }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themeManager.primary, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // MARK: - Priority Badge
    
    private var priorityBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(requirement.priority.color))
                .frame(width: 8, height: 8)
            
            Text(requirement.priority.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(requirement.priority.color))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(requirement.priority.color).opacity(0.1))
        )
    }
    
    // MARK: - Status Badge
    
    private var statusBadge: some View {
        Text(requirement.status.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(Color(requirement.status.color))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(requirement.status.color).opacity(0.1))
            )
    }
    
    // MARK: - Helper Methods
    
    private func markCompleted() {
        requirementsManager.markCompleted(requirement)
    }
    
    private func markVerified() {
        requirementsManager.markVerified(requirement, by: "User", method: .manual)
    }
}

// MARK: - Add Comment View

struct AddCommentView: View {
    let requirement: CreatorRequirement
    let requirementsManager: CreatorRequirementsManager
    @Binding var newComment: String
    @Binding var commentAuthor: String
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Your name", text: $commentAuthor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Enter your comment", text: $newComment, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveComment()
                    }
                    .disabled(newComment.isEmpty || commentAuthor.isEmpty)
                }
            }
        }
    }
    
    private func saveComment() {
        requirementsManager.addComment(to: requirement, text: newComment, author: commentAuthor)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview

struct RequirementDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RequirementDetailView(
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
            requirementsManager: CreatorRequirementsManager()
        )
        .environmentObject(ThemeManager.shared)
    }
}
