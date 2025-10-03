//
//  CreatorRequirement.swift
//  on brand
//
//  This file defines the core CreatorRequirement model that represents
//  individual requirements from brand agreements and partnerships.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation

/// Represents a single creator requirement from a brand agreement
/// Based on analysis of real influencer contracts and partnerships
struct CreatorRequirement: Identifiable, Codable, Equatable {
    
    // MARK: - Core Properties
    
    /// Unique identifier for the requirement
    let id: UUID
    
    /// The type of requirement (post, story, tagging, etc.)
    let type: RequirementType
    
    /// Human-readable title for the requirement
    let title: String
    
    /// Detailed description of what needs to be done
    let description: String
    
    /// The brand or campaign this requirement belongs to
    let brandName: String
    
    /// The campaign or project name
    let campaignName: String?
    
    // MARK: - Timing Properties
    
    /// When the requirement was created
    let createdAt: Date
    
    /// When the requirement is due
    let dueDate: Date?
    
    /// When the requirement was completed (if applicable)
    var completedAt: Date?
    
    /// When the requirement was last updated
    var updatedAt: Date
    
    // MARK: - Status Properties
    
    /// Current status of the requirement
    var status: RequirementStatus
    
    /// Priority level of the requirement
    let priority: RequirementPriority
    
    /// Whether this requirement is mandatory
    let isMandatory: Bool
    
    // MARK: - Content Properties
    
    /// Specific content requirements
    var contentRequirements: ContentRequirements?
    
    /// Tagging requirements
    var taggingRequirements: TaggingRequirements?
    
    /// Link requirements
    var linkRequirements: LinkRequirements?
    
    /// Hashtag requirements
    var hashtagRequirements: HashtagRequirements?
    
    /// Asset delivery requirements
    var assetRequirements: AssetRequirements?
    
    // MARK: - Verification Properties
    
    /// Whether the requirement has been verified
    var isVerified: Bool
    
    /// When the requirement was verified
    var verifiedAt: Date?
    
    /// Who verified the requirement
    var verifiedBy: String?
    
    /// Verification method used
    var verificationMethod: VerificationMethod?
    
    // MARK: - Notes and Comments
    
    /// Additional notes about the requirement
    var notes: String?
    
    /// Comments from brand or creator
    var comments: [RequirementComment]
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        type: RequirementType,
        title: String,
        description: String,
        brandName: String,
        campaignName: String? = nil,
        dueDate: Date? = nil,
        priority: RequirementPriority = .medium,
        isMandatory: Bool = true,
        contentRequirements: ContentRequirements? = nil,
        taggingRequirements: TaggingRequirements? = nil,
        linkRequirements: LinkRequirements? = nil,
        hashtagRequirements: HashtagRequirements? = nil,
        assetRequirements: AssetRequirements? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.brandName = brandName
        self.campaignName = campaignName
        self.createdAt = Date()
        self.dueDate = dueDate
        self.completedAt = nil
        self.updatedAt = Date()
        self.status = .pending
        self.priority = priority
        self.isMandatory = isMandatory
        self.contentRequirements = contentRequirements
        self.taggingRequirements = taggingRequirements
        self.linkRequirements = linkRequirements
        self.hashtagRequirements = hashtagRequirements
        self.assetRequirements = assetRequirements
        self.isVerified = false
        self.verifiedAt = nil
        self.verifiedBy = nil
        self.verificationMethod = nil
        self.notes = notes
        self.comments = []
    }
}


// MARK: - Requirement Priority

/// Priority level of a creator requirement
enum RequirementPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        case .critical:
            return "Critical"
        }
    }
    
    var color: String {
        switch self {
        case .low:
            return "green"
        case .medium:
            return "yellow"
        case .high:
            return "orange"
        case .critical:
            return "red"
        }
    }
}


// MARK: - Requirement Comment

/// Comment on a creator requirement
struct RequirementComment: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let author: String
    let createdAt: Date
    let isFromBrand: Bool
    
    init(
        id: UUID = UUID(),
        text: String,
        author: String,
        isFromBrand: Bool = false
    ) {
        self.id = id
        self.text = text
        self.author = author
        self.createdAt = Date()
        self.isFromBrand = isFromBrand
    }
}

// MARK: - CreatorRequirement Extensions

extension CreatorRequirement {
    
    /// Whether the requirement is overdue
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return Date() > dueDate && status != .completed && status != .verified
    }
    
    /// Days until due (negative if overdue)
    var daysUntilDue: Int {
        guard let dueDate = dueDate else { return 0 }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
        return days
    }
    
    /// Whether the requirement is completed
    var isCompleted: Bool {
        return status == .completed || status == .verified
    }
    
    /// Whether the requirement can be auto-verified
    var canAutoVerify: Bool {
        return type.canAutoVerify
    }
    
    /// Mark the requirement as completed
    mutating func markCompleted() {
        status = .completed
        completedAt = Date()
        updatedAt = Date()
    }
    
    /// Mark the requirement as verified
    mutating func markVerified(by verifier: String, method: VerificationMethod) {
        status = .verified
        verifiedAt = Date()
        verifiedBy = verifier
        verificationMethod = method
        isVerified = true
        updatedAt = Date()
    }
    
    /// Add a comment to the requirement
    mutating func addComment(_ text: String, author: String, isFromBrand: Bool = false) {
        let comment = RequirementComment(text: text, author: author, isFromBrand: isFromBrand)
        comments.append(comment)
        updatedAt = Date()
    }
    
    /// Update the requirement status
    mutating func updateStatus(_ newStatus: RequirementStatus) {
        status = newStatus
        updatedAt = Date()
        
        // Auto-update overdue status
        if isOverdue && newStatus != .completed && newStatus != .verified {
            status = .overdue
        }
    }
}

// MARK: - Sample Data

extension CreatorRequirement {
    static var sampleDeal: CreatorRequirement {
        return CreatorRequirement(
            type: .instagramPost,
            title: "Summer Collection Launch",
            description: "Post about the new summer collection with specific requirements",
            brandName: "Fashion Brand",
            campaignName: "Summer 2024",
            dueDate: Date().addingTimeInterval(86400 * 7), // 7 days from now
            priority: .high,
            isMandatory: true,
            notes: "This is a sample deal for testing purposes"
        )
    }
}
