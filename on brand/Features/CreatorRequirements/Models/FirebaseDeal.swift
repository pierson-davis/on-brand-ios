//
//  FirebaseDeal.swift
//  on brand
//
//  This file defines Firebase-compatible data models for deals
//  with proper Codable support and Firestore integration.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import FirebaseFirestore

/// Firebase-compatible deal model for Firestore storage
struct FirebaseDeal: Codable, Identifiable {
    
    // MARK: - Core Properties
    
    /// Document ID in Firestore
    let id: String
    
    /// The type of requirement (post, story, tagging, etc.)
    let type: String
    
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
    let createdAt: Timestamp
    
    /// When the requirement is due
    let dueDate: Timestamp?
    
    /// When the requirement was completed (if applicable)
    let completedAt: Timestamp?
    
    /// When the requirement was last updated
    let updatedAt: Timestamp
    
    // MARK: - Status Properties
    
    /// Current status of the requirement
    let status: String
    
    /// Priority level of the requirement
    let priority: String
    
    /// Whether this requirement is mandatory
    let isMandatory: Bool
    
    // MARK: - Content Properties
    
    /// Specific content requirements (JSON string)
    let contentRequirements: String?
    
    /// Tagging requirements (JSON string)
    let taggingRequirements: String?
    
    /// Link requirements (JSON string)
    let linkRequirements: String?
    
    /// Hashtag requirements (JSON string)
    let hashtagRequirements: String?
    
    /// Asset delivery requirements (JSON string)
    let assetRequirements: String?
    
    // MARK: - Verification Properties
    
    /// Whether the requirement has been verified
    let isVerified: Bool
    
    /// When the requirement was verified
    let verifiedAt: Timestamp?
    
    /// Who verified the requirement
    let verifiedBy: String?
    
    /// Verification method used
    let verificationMethod: String?
    
    // MARK: - Notes and Comments
    
    /// Additional notes about the requirement
    let notes: String?
    
    /// Comments from brand or creator (JSON string)
    let comments: String?
    
    // MARK: - Firebase Properties
    
    /// User ID who owns this deal
    let userId: String
    
    /// Document reference path
    let documentPath: String
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        type: String,
        title: String,
        description: String,
        brandName: String,
        campaignName: String? = nil,
        dueDate: Timestamp? = nil,
        priority: String = "medium",
        isMandatory: Bool = true,
        contentRequirements: String? = nil,
        taggingRequirements: String? = nil,
        linkRequirements: String? = nil,
        hashtagRequirements: String? = nil,
        assetRequirements: String? = nil,
        notes: String? = nil,
        comments: String? = nil,
        userId: String
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.brandName = brandName
        self.campaignName = campaignName
        self.createdAt = Timestamp(date: Date())
        self.dueDate = dueDate
        self.completedAt = nil
        self.updatedAt = Timestamp(date: Date())
        self.status = "pending"
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
        self.comments = comments
        self.userId = userId
        self.documentPath = "users/\(userId)/deals/\(id)"
    }
}

// MARK: - Conversion Methods

extension FirebaseDeal {
    
    /// Convert from CreatorRequirement to FirebaseDeal
    static func from(_ requirement: CreatorRequirement, userId: String) -> FirebaseDeal {
        let contentRequirementsJSON = requirement.contentRequirements?.toJSONString()
        let taggingRequirementsJSON = requirement.taggingRequirements?.toJSONString()
        let linkRequirementsJSON = requirement.linkRequirements?.toJSONString()
        let hashtagRequirementsJSON = requirement.hashtagRequirements?.toJSONString()
        let assetRequirementsJSON = requirement.assetRequirements?.toJSONString()
        let commentsJSON = requirement.comments.toJSONString()
        
        return FirebaseDeal(
            id: requirement.id.uuidString,
            type: requirement.type.rawValue,
            title: requirement.title,
            description: requirement.description,
            brandName: requirement.brandName,
            campaignName: requirement.campaignName,
            dueDate: requirement.dueDate.map { Timestamp(date: $0) },
            priority: requirement.priority.rawValue,
            isMandatory: requirement.isMandatory,
            contentRequirements: contentRequirementsJSON,
            taggingRequirements: taggingRequirementsJSON,
            linkRequirements: linkRequirementsJSON,
            hashtagRequirements: hashtagRequirementsJSON,
            assetRequirements: assetRequirementsJSON,
            notes: requirement.notes,
            comments: commentsJSON,
            userId: userId
        )
    }
    
    /// Convert from FirebaseDeal to CreatorRequirement
    func toCreatorRequirement() -> CreatorRequirement? {
        guard let type = RequirementType(rawValue: self.type),
              let priority = RequirementPriority(rawValue: self.priority),
              let status = RequirementStatus(rawValue: self.status) else {
            return nil
        }
        
        var requirement = CreatorRequirement(
            id: UUID(uuidString: self.id) ?? UUID(),
            type: type,
            title: self.title,
            description: self.description,
            brandName: self.brandName,
            campaignName: self.campaignName,
            dueDate: self.dueDate?.dateValue(),
            priority: priority,
            isMandatory: self.isMandatory,
            contentRequirements: self.contentRequirements?.fromJSONString(ContentRequirements.self),
            taggingRequirements: self.taggingRequirements?.fromJSONString(TaggingRequirements.self),
            linkRequirements: self.linkRequirements?.fromJSONString(LinkRequirements.self),
            hashtagRequirements: self.hashtagRequirements?.fromJSONString(HashtagRequirements.self),
            assetRequirements: self.assetRequirements?.fromJSONString(AssetRequirements.self),
            notes: self.notes
        )
        
        // Set additional properties
        requirement.status = status
        requirement.completedAt = self.completedAt?.dateValue()
        requirement.updatedAt = self.updatedAt.dateValue()
        requirement.isVerified = self.isVerified
        requirement.verifiedAt = self.verifiedAt?.dateValue()
        requirement.verifiedBy = self.verifiedBy
        requirement.verificationMethod = self.verificationMethod.flatMap { VerificationMethod(rawValue: $0) }
        requirement.comments = self.comments?.fromJSONString([RequirementComment].self) ?? []
        
        return requirement
    }
}

// MARK: - JSON Conversion Extensions

extension FirebaseDeal {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

extension ContentRequirements {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension TaggingRequirements {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension LinkRequirements {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension HashtagRequirements {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension AssetRequirements {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element == String {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element == RequirementComment {
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension String {
    func fromJSONString<T: Codable>(_ type: T.Type) -> T? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: - Firestore Collection Paths

extension FirebaseDeal {
    
    /// Get the Firestore collection path for deals
    static func collectionPath(for userId: String) -> String {
        return "users/\(userId)/deals"
    }
    
    /// Get the Firestore document path for a specific deal
    static func documentPath(for userId: String, dealId: String) -> String {
        return "users/\(userId)/deals/\(dealId)"
    }
}

// MARK: - Sample Data

extension FirebaseDeal {
    static var sampleDeal: FirebaseDeal {
        return FirebaseDeal(
            type: "instagram_post",
            title: "Summer Collection Launch",
            description: "Post about the new summer collection with specific requirements",
            brandName: "Fashion Brand",
            campaignName: "Summer 2024",
            dueDate: Timestamp(date: Date().addingTimeInterval(86400 * 7)), // 7 days from now
            priority: "high",
            isMandatory: true,
            notes: "This is a sample deal for testing purposes",
            userId: "sample-user-id"
        )
    }
}

