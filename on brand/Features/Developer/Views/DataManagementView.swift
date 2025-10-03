//
//  DataManagementView.swift
//  on brand
//
//  This view provides data management functionality for developers.
//  It allows clearing cache, resetting data, and managing app storage.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import Foundation

// MARK: - Data Management View
// This view provides data management functionality for developers
struct DataManagementView: View {
    
    // MARK: - State Properties
    /// Controls whether the operation is in progress
    @State private var isOperationInProgress = false
    
    /// Current operation being performed
    @State private var currentOperation = ""
    
    /// Storage information
    @State private var cacheSize: Int64 = 0
    @State private var documentsSize: Int64 = 0
    @State private var totalSize: Int64 = 0
    
    /// User profiles count
    @State private var userProfilesCount = 0
    
    /// Photos count
    @State private var photosCount = 0
    
    /// Settings count
    @State private var settingsCount = 0
    
    /// Operation results
    @State private var operationResults: [OperationResult] = []
    
    /// Controls whether to show confirmation dialogs
    @State private var showConfirmation = false
    @State private var pendingOperation: DataOperation?
    
    // MARK: - Environment Objects
    /// Provides access to the app's theme management system
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                EraBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Header Section
                        headerSection
                        
                        // MARK: - Storage Info Section
                        storageInfoSection
                        
                        // MARK: - Data Overview Section
                        dataOverviewSection
                        
                        // MARK: - Operations Section
                        operationsSection
                        
                        // MARK: - Operation Results Section
                        if !operationResults.isEmpty {
                            operationResultsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Data Management")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the view
                    }
                }
            }
        }
        .onAppear {
            loadStorageInfo()
        }
        .alert("Confirm Operation", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) {
                pendingOperation = nil
            }
            Button("Confirm", role: .destructive) {
                if let operation = pendingOperation {
                    performOperation(operation)
                }
            }
        } message: {
            if let operation = pendingOperation {
                Text(operation.confirmationMessage)
            }
        }
    }
    
    // MARK: - Header Section
    /// The header section with title and description
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Data Management Icon
            Image(systemName: "trash.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primary)
            
            // Title
            Text("Data Management")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // Description
            Text("Manage app data, clear cache, and reset storage")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Status
            HStack {
                Image(systemName: isOperationInProgress ? "clock.fill" : "checkmark.circle.fill")
                    .foregroundColor(isOperationInProgress ? .orange : .green)
                
                Text(isOperationInProgress ? "Operation in Progress" : "Ready")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isOperationInProgress ? Color.orange.opacity(0.1) : Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isOperationInProgress ? Color.orange.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Storage Info Section
    /// Shows storage information
    private var storageInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Storage Information", icon: "internaldrive.fill")
            
            VStack(spacing: 12) {
                storageRow(title: "Cache Size", size: cacheSize, color: .orange)
                storageRow(title: "Documents Size", size: documentsSize, color: .blue)
                storageRow(title: "Total Size", size: totalSize, color: .green)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Data Overview Section
    /// Shows data overview
    private var dataOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Data Overview", icon: "chart.pie.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                dataCard(title: "User Profiles", count: userProfilesCount, icon: "person.fill", color: .blue)
                dataCard(title: "Photos", count: photosCount, icon: "photo.fill", color: .green)
                dataCard(title: "Settings", count: settingsCount, icon: "gearshape.fill", color: .purple)
                dataCard(title: "Cache Files", count: Int(cacheSize / 1024), icon: "folder.fill", color: .orange)
            }
        }
    }
    
    // MARK: - Operations Section
    /// Shows available operations
    private var operationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Operations", icon: "wrench.and.screwdriver.fill")
            
            VStack(spacing: 12) {
                // Clear Cache
                operationButton(
                    title: "Clear Cache",
                    description: "Remove temporary files and cached data",
                    icon: "trash.fill",
                    color: .orange,
                    operation: .clearCache
                )
                
                // Clear User Data
                operationButton(
                    title: "Clear User Data",
                    description: "Remove all user profiles and preferences",
                    icon: "person.crop.circle.fill",
                    color: .red,
                    operation: .clearUserData
                )
                
                // Clear Photos
                operationButton(
                    title: "Clear Photos",
                    description: "Remove all stored photos and analysis data",
                    icon: "photo.fill",
                    color: .purple,
                    operation: .clearPhotos
                )
                
                // Reset All Data
                operationButton(
                    title: "Reset All Data",
                    description: "Remove all app data and reset to defaults",
                    icon: "arrow.clockwise.circle.fill",
                    color: .red,
                    operation: .resetAllData
                )
                
                // Export Data
                operationButton(
                    title: "Export Data",
                    description: "Export all app data for backup",
                    icon: "square.and.arrow.up.fill",
                    color: .blue,
                    operation: .exportData
                )
                
                // Import Data
                operationButton(
                    title: "Import Data",
                    description: "Import data from backup file",
                    icon: "square.and.arrow.down.fill",
                    color: .green,
                    operation: .importData
                )
            }
        }
    }
    
    // MARK: - Operation Results Section
    /// Shows operation results
    private var operationResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Operation Results", icon: "list.bullet.fill")
            
            VStack(spacing: 8) {
                ForEach(operationResults, id: \.id) { result in
                    operationResultRow(result: result)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Helper Views
    
    /// Creates a section header with title and icon
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(themeManager.primary)
                .font(.title2)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Spacer()
        }
    }
    
    /// Creates a storage row
    private func storageRow(title: String, size: Int64, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
            
            Spacer()
            
            Text(formatBytes(size))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
    
    /// Creates a data card
    private func dataCard(title: String, count: Int, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.surfaceOutline, lineWidth: 1)
                )
        )
    }
    
    /// Creates an operation button
    private func operationButton(title: String, description: String, icon: String, color: Color, operation: DataOperation) -> some View {
        Button(action: {
            if operation.requiresConfirmation {
                pendingOperation = operation
                showConfirmation = true
            } else {
                performOperation(operation)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(themeManager.textPrimary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(themeManager.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isOperationInProgress)
    }
    
    /// Creates an operation result row
    private func operationResultRow(result: OperationResult) -> some View {
        HStack {
            Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(result.success ? .green : .red)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.operation.title)
                    .font(.headline)
                    .foregroundColor(themeManager.textPrimary)
                
                Text(result.message)
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            Spacer()
            
            Text(result.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(result.success ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(result.success ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Helper Methods
    
    /// Loads storage information
    private func loadStorageInfo() {
        // Simulate loading storage info
        cacheSize = Int64.random(in: 10...100) * 1024 * 1024 // 10-100 MB
        documentsSize = Int64.random(in: 50...500) * 1024 * 1024 // 50-500 MB
        totalSize = cacheSize + documentsSize
        
        userProfilesCount = Int.random(in: 0...5)
        photosCount = Int.random(in: 0...50)
        settingsCount = Int.random(in: 10...20)
    }
    
    /// Performs a data operation
    private func performOperation(_ operation: DataOperation) {
        isOperationInProgress = true
        currentOperation = operation.title
        
        // Simulate operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let success = Bool.random()
            let result = OperationResult(
                operation: operation,
                success: success,
                message: success ? operation.successMessage : operation.errorMessage,
                timestamp: Date()
            )
            
            operationResults.append(result)
            
            // Keep only last 10 results
            if operationResults.count > 10 {
                operationResults.removeFirst()
            }
            
            isOperationInProgress = false
            currentOperation = ""
            
            // Refresh storage info
            loadStorageInfo()
        }
    }
    
    /// Formats bytes into human readable string
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Supporting Types

/// Data operation types
enum DataOperation {
    case clearCache
    case clearUserData
    case clearPhotos
    case resetAllData
    case exportData
    case importData
    
    var title: String {
        switch self {
        case .clearCache: return "Clear Cache"
        case .clearUserData: return "Clear User Data"
        case .clearPhotos: return "Clear Photos"
        case .resetAllData: return "Reset All Data"
        case .exportData: return "Export Data"
        case .importData: return "Import Data"
        }
    }
    
    var requiresConfirmation: Bool {
        switch self {
        case .clearCache, .exportData, .importData: return false
        case .clearUserData, .clearPhotos, .resetAllData: return true
        }
    }
    
    var confirmationMessage: String {
        switch self {
        case .clearUserData: return "This will remove all user profiles and preferences. This action cannot be undone."
        case .clearPhotos: return "This will remove all stored photos and analysis data. This action cannot be undone."
        case .resetAllData: return "This will remove all app data and reset to defaults. This action cannot be undone."
        default: return ""
        }
    }
    
    var successMessage: String {
        switch self {
        case .clearCache: return "Cache cleared successfully"
        case .clearUserData: return "User data cleared successfully"
        case .clearPhotos: return "Photos cleared successfully"
        case .resetAllData: return "All data reset successfully"
        case .exportData: return "Data exported successfully"
        case .importData: return "Data imported successfully"
        }
    }
    
    var errorMessage: String {
        switch self {
        case .clearCache: return "Failed to clear cache"
        case .clearUserData: return "Failed to clear user data"
        case .clearPhotos: return "Failed to clear photos"
        case .resetAllData: return "Failed to reset data"
        case .exportData: return "Failed to export data"
        case .importData: return "Failed to import data"
        }
    }
}

/// Operation result
struct OperationResult: Identifiable {
    let id = UUID()
    let operation: DataOperation
    let success: Bool
    let message: String
    let timestamp: Date
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    DataManagementView()
        .environmentObject(ThemeManager.shared)
}
