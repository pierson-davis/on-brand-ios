//
//  CreatorRequirementsManager.swift
//  on brand
//
//  This file defines the main service for managing creator requirements.
//  Handles tracking, verification, notifications, and analytics.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import Combine
import UserNotifications

/// Main service for managing creator requirements
class CreatorRequirementsManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All creator requirements
    @Published var requirements: [CreatorRequirement] = []
    
    /// Filtered requirements based on current filters
    @Published var filteredRequirements: [CreatorRequirement] = []
    
    /// Current filter settings
    @Published var currentFilters: RequirementFilters = RequirementFilters()
    
    /// Overdue requirements count
    @Published var overdueCount: Int = 0
    
    /// Completed requirements count
    @Published var completedCount: Int = 0
    
    /// Pending requirements count
    @Published var pendingCount: Int = 0
    
    /// In progress requirements count
    @Published var inProgressCount: Int = 0
    
    // MARK: - Private Properties
    
    /// UserDefaults key for persisting requirements
    private let requirementsKey = "creator_requirements"
    
    /// Timer for checking overdue requirements
    private var overdueTimer: Timer?
    
    /// Notification center for local notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    /// Debug logging closure
    private let addDebugLog: (String) -> Void
    
    // MARK: - Initialization
    
    init(addDebugLog: @escaping (String) -> Void = { _ in }) {
        self.addDebugLog = addDebugLog
        loadRequirements()
        setupOverdueTimer()
        requestNotificationPermission()
    }
    
    deinit {
        overdueTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Add a new requirement
    func addRequirement(_ requirement: CreatorRequirement) {
        requirements.append(requirement)
        saveRequirements()
        updateFilteredRequirements()
        updateCounts()
        addDebugLog("Added requirement: \(requirement.title)")
    }
    
    /// Update an existing requirement
    func updateRequirement(_ requirement: CreatorRequirement) {
        if let index = requirements.firstIndex(where: { $0.id == requirement.id }) {
            requirements[index] = requirement
            saveRequirements()
            updateFilteredRequirements()
            updateCounts()
            addDebugLog("Updated requirement: \(requirement.title)")
        }
    }
    
    /// Delete a requirement
    func deleteRequirement(_ requirement: CreatorRequirement) {
        requirements.removeAll { $0.id == requirement.id }
        saveRequirements()
        updateFilteredRequirements()
        updateCounts()
        addDebugLog("Deleted requirement: \(requirement.title)")
    }
    
    /// Mark a requirement as completed
    func markCompleted(_ requirement: CreatorRequirement) {
        var updatedRequirement = requirement
        updatedRequirement.markCompleted()
        updateRequirement(updatedRequirement)
        
        // Send completion notification
        sendCompletionNotification(for: updatedRequirement)
    }
    
    /// Mark a requirement as verified
    func markVerified(_ requirement: CreatorRequirement, by verifier: String, method: VerificationMethod) {
        var updatedRequirement = requirement
        updatedRequirement.markVerified(by: verifier, method: method)
        updateRequirement(updatedRequirement)
        
        // Send verification notification
        sendVerificationNotification(for: updatedRequirement)
    }
    
    /// Add a comment to a requirement
    func addComment(to requirement: CreatorRequirement, text: String, author: String, isFromBrand: Bool = false) {
        var updatedRequirement = requirement
        updatedRequirement.addComment(text, author: author, isFromBrand: isFromBrand)
        updateRequirement(updatedRequirement)
        
        // Send comment notification
        sendCommentNotification(for: updatedRequirement, comment: text, author: author)
    }
    
    /// Update requirement status
    func updateStatus(_ requirement: CreatorRequirement, to newStatus: RequirementStatus) {
        var updatedRequirement = requirement
        updatedRequirement.updateStatus(newStatus)
        updateRequirement(updatedRequirement)
        
        // Send status change notification
        sendStatusChangeNotification(for: updatedRequirement, newStatus: newStatus)
    }
    
    /// Apply filters to requirements
    func applyFilters(_ filters: RequirementFilters) {
        currentFilters = filters
        updateFilteredRequirements()
        addDebugLog("Applied filters: \(filters.description)")
    }
    
    /// Clear all filters
    func clearFilters() {
        currentFilters = RequirementFilters()
        updateFilteredRequirements()
        addDebugLog("Cleared all filters")
    }
    
    /// Get requirements by brand
    func getRequirements(for brand: String) -> [CreatorRequirement] {
        return requirements.filter { $0.brandName.lowercased() == brand.lowercased() }
    }
    
    /// Get requirements by campaign
    func getRequirements(forCampaign campaign: String) -> [CreatorRequirement] {
        return requirements.filter { $0.campaignName?.lowercased() == campaign.lowercased() }
    }
    
    /// Get requirements by type
    func getRequirements(of type: RequirementType) -> [CreatorRequirement] {
        return requirements.filter { $0.type == type }
    }
    
    /// Get requirements by status
    func getRequirements(with status: RequirementStatus) -> [CreatorRequirement] {
        return requirements.filter { $0.status == status }
    }
    
    /// Get overdue requirements
    func getOverdueRequirements() -> [CreatorRequirement] {
        return requirements.filter { $0.isOverdue }
    }
    
    /// Get requirements due soon (within specified days)
    func getRequirementsDueSoon(within days: Int) -> [CreatorRequirement] {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
        
        return requirements.filter { requirement in
            guard let dueDate = requirement.dueDate else { return false }
            return dueDate <= futureDate && !requirement.isCompleted
        }
    }
    
    /// Get requirements by priority
    func getRequirements(with priority: RequirementPriority) -> [CreatorRequirement] {
        return requirements.filter { $0.priority == priority }
    }
    
    /// Get requirements by platform
    func getRequirements(for platform: SocialPlatform) -> [CreatorRequirement] {
        return requirements.filter { requirement in
            // Check if any of the requirement's components use this platform
            if let tagging = requirement.taggingRequirements {
                // For now, just check if there are any accounts to tag
                return !tagging.accountsToTag.isEmpty
            }
            if let links = requirement.linkRequirements {
                // For now, just check if there are any links
                return !links.url.isEmpty
            }
            if let hashtags = requirement.hashtagRequirements {
                // For now, just check if there are any hashtags
                return !hashtags.requiredHashtags.isEmpty || !hashtags.optionalHashtags.isEmpty
            }
            return false
        }
    }
    
    /// Get analytics data
    func getAnalytics() -> RequirementAnalytics {
        return RequirementAnalytics(
            totalRequirements: requirements.count,
            completedRequirements: completedCount,
            pendingRequirements: pendingCount,
            inProgressRequirements: inProgressCount,
            overdueRequirements: overdueCount,
            completionRate: requirements.isEmpty ? 0.0 : Double(completedCount) / Double(requirements.count),
            averageCompletionTime: calculateAverageCompletionTime(),
            requirementsByType: Dictionary(uniqueKeysWithValues: getRequirementsByType().map { ($0.key.rawValue, $0.value) }),
            requirementsByStatus: Dictionary(uniqueKeysWithValues: getRequirementsByStatus().map { ($0.key.rawValue, $0.value) }),
            requirementsByPriority: Dictionary(uniqueKeysWithValues: getRequirementsByPriority().map { ($0.key.rawValue, $0.value) }),
            requirementsByBrand: getRequirementsByBrand(),
            requirementsByCampaign: getRequirementsByCampaign()
        )
    }
    
    /// Export requirements data
    func exportRequirements() -> Data? {
        do {
            return try JSONEncoder().encode(requirements)
        } catch {
            addDebugLog("Failed to export requirements: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Import requirements data
    func importRequirements(from data: Data) -> Bool {
        do {
            let importedRequirements = try JSONDecoder().decode([CreatorRequirement].self, from: data)
            requirements.append(contentsOf: importedRequirements)
            saveRequirements()
            updateFilteredRequirements()
            updateCounts()
            addDebugLog("Imported \(importedRequirements.count) requirements")
            return true
        } catch {
            addDebugLog("Failed to import requirements: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Clear all requirements
    func clearAllRequirements() {
        requirements.removeAll()
        saveRequirements()
        updateFilteredRequirements()
        updateCounts()
        addDebugLog("Cleared all requirements")
    }
    
    // MARK: - Private Methods
    
    /// Load requirements from UserDefaults
    private func loadRequirements() {
        if let data = UserDefaults.standard.data(forKey: requirementsKey) {
            do {
                requirements = try JSONDecoder().decode([CreatorRequirement].self, from: data)
                updateFilteredRequirements()
                updateCounts()
                addDebugLog("Loaded \(requirements.count) requirements from storage")
            } catch {
                addDebugLog("Failed to load requirements: \(error.localizedDescription)")
                requirements = []
            }
        } else {
            addDebugLog("No saved requirements found, starting with empty list")
        }
    }
    
    /// Save requirements to UserDefaults
    private func saveRequirements() {
        do {
            let data = try JSONEncoder().encode(requirements)
            UserDefaults.standard.set(data, forKey: requirementsKey)
            addDebugLog("Saved \(requirements.count) requirements to storage")
        } catch {
            addDebugLog("Failed to save requirements: \(error.localizedDescription)")
        }
    }
    
    /// Update filtered requirements based on current filters
    private func updateFilteredRequirements() {
        var filtered = requirements
        
        // Apply status filter
        if !currentFilters.statuses.isEmpty {
            filtered = filtered.filter { currentFilters.statuses.contains($0.status) }
        }
        
        // Apply type filter
        if !currentFilters.types.isEmpty {
            filtered = filtered.filter { currentFilters.types.contains($0.type) }
        }
        
        // Apply priority filter
        if !currentFilters.priorities.isEmpty {
            filtered = filtered.filter { currentFilters.priorities.contains($0.priority) }
        }
        
        // Apply brand filter
        if !currentFilters.brands.isEmpty {
            filtered = filtered.filter { currentFilters.brands.contains($0.brandName) }
        }
        
        // Apply campaign filter
        if !currentFilters.campaigns.isEmpty {
            filtered = filtered.filter { requirement in
                guard let campaign = requirement.campaignName else { return false }
                return currentFilters.campaigns.contains(campaign)
            }
        }
        
        // Apply platform filter
        if !currentFilters.platforms.isEmpty {
            filtered = filtered.filter { requirement in
                return currentFilters.platforms.contains { platform in
                    getRequirements(for: platform).contains(requirement)
                }
            }
        }
        
        // Apply overdue filter
        if currentFilters.showOverdueOnly {
            filtered = filtered.filter { $0.isOverdue }
        }
        
        // Apply completed filter
        if currentFilters.showCompletedOnly {
            filtered = filtered.filter { $0.isCompleted }
        }
        
        // Apply date range filter
        if let startDate = currentFilters.startDate {
            filtered = filtered.filter { $0.createdAt >= startDate }
        }
        if let endDate = currentFilters.endDate {
            filtered = filtered.filter { $0.createdAt <= endDate }
        }
        
        // Apply search filter
        if !currentFilters.searchText.isEmpty {
            let searchText = currentFilters.searchText.lowercased()
            filtered = filtered.filter { requirement in
                return requirement.title.lowercased().contains(searchText) ||
                       requirement.description.lowercased().contains(searchText) ||
                       requirement.brandName.lowercased().contains(searchText) ||
                       (requirement.campaignName?.lowercased().contains(searchText) ?? false)
            }
        }
        
        // Apply sorting
        filtered = applySorting(to: filtered)
        
        filteredRequirements = filtered
    }
    
    /// Apply sorting to requirements
    private func applySorting(to requirements: [CreatorRequirement]) -> [CreatorRequirement] {
        switch currentFilters.sortBy {
        case .title:
            return requirements.sorted { $0.title < $1.title }
        case .dueDate:
            return requirements.sorted { requirement1, requirement2 in
                switch (requirement1.dueDate, requirement2.dueDate) {
                case (nil, nil):
                    return requirement1.title < requirement2.title
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                case (let date1?, let date2?):
                    return date1 < date2
                }
            }
        case .createdDate:
            return requirements.sorted { $0.createdAt > $1.createdAt }
        case .priority:
            return requirements.sorted { $0.priority.rawValue > $1.priority.rawValue }
        case .status:
            return requirements.sorted { $0.status.rawValue < $1.status.rawValue }
        case .brand:
            return requirements.sorted { $0.brandName < $1.brandName }
        }
    }
    
    /// Update requirement counts
    private func updateCounts() {
        overdueCount = requirements.filter { $0.isOverdue }.count
        completedCount = requirements.filter { $0.isCompleted }.count
        pendingCount = requirements.filter { $0.status == .pending }.count
        inProgressCount = requirements.filter { $0.status == .inProgress }.count
    }
    
    /// Setup timer for checking overdue requirements
    private func setupOverdueTimer() {
        overdueTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.checkOverdueRequirements()
        }
    }
    
    /// Check for overdue requirements
    private func checkOverdueRequirements() {
        let overdueRequirements = getOverdueRequirements()
        if !overdueRequirements.isEmpty {
            addDebugLog("Found \(overdueRequirements.count) overdue requirements")
            sendOverdueNotification(for: overdueRequirements)
        }
    }
    
    /// Request notification permission
    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                self.addDebugLog("Notification permission error: \(error.localizedDescription)")
            } else {
                self.addDebugLog("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Send completion notification
    private func sendCompletionNotification(for requirement: CreatorRequirement) {
        let content = UNMutableNotificationContent()
        content.title = "Requirement Completed"
        content.body = "\(requirement.title) has been marked as completed"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "completion_\(requirement.id.uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                self.addDebugLog("Failed to send completion notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send verification notification
    private func sendVerificationNotification(for requirement: CreatorRequirement) {
        let content = UNMutableNotificationContent()
        content.title = "Requirement Verified"
        content.body = "\(requirement.title) has been verified by \(requirement.verifiedBy ?? "Unknown")"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "verification_\(requirement.id.uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                self.addDebugLog("Failed to send verification notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send comment notification
    private func sendCommentNotification(for requirement: CreatorRequirement, comment: String, author: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Comment"
        content.body = "\(author) commented on \(requirement.title)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "comment_\(requirement.id.uuidString)_\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                self.addDebugLog("Failed to send comment notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send status change notification
    private func sendStatusChangeNotification(for requirement: CreatorRequirement, newStatus: RequirementStatus) {
        let content = UNMutableNotificationContent()
        content.title = "Status Updated"
        content.body = "\(requirement.title) status changed to \(newStatus.displayName)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "status_\(requirement.id.uuidString)_\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                self.addDebugLog("Failed to send status change notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Send overdue notification
    private func sendOverdueNotification(for overdueRequirements: [CreatorRequirement]) {
        let content = UNMutableNotificationContent()
        content.title = "Overdue Requirements"
        content.body = "You have \(overdueRequirements.count) overdue requirements"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "overdue_\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                self.addDebugLog("Failed to send overdue notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Calculate average completion time
    private func calculateAverageCompletionTime() -> TimeInterval? {
        let completedRequirements = requirements.filter { $0.isCompleted && $0.completedAt != nil }
        guard !completedRequirements.isEmpty else { return nil }
        
        let totalTime = completedRequirements.reduce(0.0) { total, requirement in
            guard let completedAt = requirement.completedAt else { return total }
            return total + completedAt.timeIntervalSince(requirement.createdAt)
        }
        
        return totalTime / Double(completedRequirements.count)
    }
    
    /// Get requirements grouped by type
    private func getRequirementsByType() -> [RequirementType: Int] {
        var counts: [RequirementType: Int] = [:]
        for requirement in requirements {
            counts[requirement.type, default: 0] += 1
        }
        return counts
    }
    
    /// Get requirements grouped by status
    private func getRequirementsByStatus() -> [RequirementStatus: Int] {
        var counts: [RequirementStatus: Int] = [:]
        for requirement in requirements {
            counts[requirement.status, default: 0] += 1
        }
        return counts
    }
    
    /// Get requirements grouped by priority
    private func getRequirementsByPriority() -> [RequirementPriority: Int] {
        var counts: [RequirementPriority: Int] = [:]
        for requirement in requirements {
            counts[requirement.priority, default: 0] += 1
        }
        return counts
    }
    
    /// Get requirements grouped by brand
    private func getRequirementsByBrand() -> [String: Int] {
        var counts: [String: Int] = [:]
        for requirement in requirements {
            counts[requirement.brandName, default: 0] += 1
        }
        return counts
    }
    
    /// Get requirements grouped by campaign
    private func getRequirementsByCampaign() -> [String: Int] {
        var counts: [String: Int] = [:]
        for requirement in requirements {
            if let campaign = requirement.campaignName {
                counts[campaign, default: 0] += 1
            }
        }
        return counts
    }
}

// MARK: - Supporting Types

/// Filters for requirements
struct RequirementFilters {
    var statuses: [RequirementStatus] = []
    var types: [RequirementType] = []
    var priorities: [RequirementPriority] = []
    var brands: [String] = []
    var campaigns: [String] = []
    var platforms: [SocialPlatform] = []
    var showOverdueOnly: Bool = false
    var showCompletedOnly: Bool = false
    var startDate: Date? = nil
    var endDate: Date? = nil
    var searchText: String = ""
    var sortBy: SortOption = .dueDate
    
    var description: String {
        var parts: [String] = []
        if !statuses.isEmpty { parts.append("Statuses: \(statuses.map { $0.displayName }.joined(separator: ", "))") }
        if !types.isEmpty { parts.append("Types: \(types.map { $0.displayName }.joined(separator: ", "))") }
        if !priorities.isEmpty { parts.append("Priorities: \(priorities.map { $0.displayName }.joined(separator: ", "))") }
        if !brands.isEmpty { parts.append("Brands: \(brands.joined(separator: ", "))") }
        if !campaigns.isEmpty { parts.append("Campaigns: \(campaigns.joined(separator: ", "))") }
        if !platforms.isEmpty { parts.append("Platforms: \(platforms.map { $0.displayName }.joined(separator: ", "))") }
        if showOverdueOnly { parts.append("Overdue Only") }
        if showCompletedOnly { parts.append("Completed Only") }
        if let startDate = startDate { parts.append("Start: \(startDate.formatted())") }
        if let endDate = endDate { parts.append("End: \(endDate.formatted())") }
        if !searchText.isEmpty { parts.append("Search: \(searchText)") }
        parts.append("Sort: \(sortBy.displayName)")
        return parts.joined(separator: " | ")
    }
}

/// Sort options for requirements
enum SortOption: String, CaseIterable, Codable {
    case title = "title"
    case dueDate = "due_date"
    case createdDate = "created_date"
    case priority = "priority"
    case status = "status"
    case brand = "brand"
    
    var displayName: String {
        switch self {
        case .title:
            return "Title"
        case .dueDate:
            return "Due Date"
        case .createdDate:
            return "Created Date"
        case .priority:
            return "Priority"
        case .status:
            return "Status"
        case .brand:
            return "Brand"
        }
    }
}

/// Analytics data for requirements
struct RequirementAnalytics: Codable {
    let totalRequirements: Int
    let completedRequirements: Int
    let pendingRequirements: Int
    let inProgressRequirements: Int
    let overdueRequirements: Int
    let completionRate: Double
    let averageCompletionTime: TimeInterval?
    let requirementsByType: [String: Int]
    let requirementsByStatus: [String: Int]
    let requirementsByPriority: [String: Int]
    let requirementsByBrand: [String: Int]
    let requirementsByCampaign: [String: Int]
}
