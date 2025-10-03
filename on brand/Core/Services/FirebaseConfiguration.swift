//
//  FirebaseConfiguration.swift
//  on brand
//
//  This file handles Firebase configuration for different environments
//  (development, staging, production) with proper security and setup.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseAnalytics
import FirebaseCrashlytics

/// Manages Firebase configuration for different environments
class FirebaseConfiguration: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = FirebaseConfiguration()
    
    // MARK: - Properties
    
    @Published var isConfigured = false
    @Published var currentEnvironment: Environment = .development
    @Published var configurationError: String?
    
    private var firestore: Firestore?
    private var storage: Storage?
    
    // MARK: - Environment Enum
    
    enum Environment: String, CaseIterable {
        case development = "dev"
        case staging = "staging"
        case production = "prod"
        
        var displayName: String {
            switch self {
            case .development:
                return "Development"
            case .staging:
                return "Staging"
            case .production:
                return "Production"
            }
        }
        
        var bundleIdentifier: String {
            switch self {
            case .development:
                return "com.pierson.on-brand.dev"
            case .staging:
                return "com.pierson.on-brand.staging"
            case .production:
                return "com.pierson.on-brand"
            }
        }
        
        var googleServiceFileName: String {
            switch self {
            case .development:
                return "GoogleService-Info-Dev"
            case .staging:
                return "GoogleService-Info-Staging"
            case .production:
                return "GoogleService-Info-Prod"
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Auto-detect environment based on bundle identifier
        detectEnvironment()
    }
    
    // MARK: - Public Methods
    
    /// Configure Firebase for the current environment
    func configure() {
        guard !isConfigured else {
            print("Firebase already configured")
            return
        }
        
        do {
            try configureFirebase()
            setupServices()
            isConfigured = true
            configurationError = nil
            print("✅ Firebase configured successfully for \(currentEnvironment.displayName)")
        } catch {
            configurationError = error.localizedDescription
            print("❌ Firebase configuration failed: \(error.localizedDescription)")
            print("⚠️ App will continue without Firebase functionality")
            // Don't set isConfigured to true, so Firebase services won't be used
        }
    }
    
    /// Get Firestore instance
    func getFirestore() -> Firestore? {
        return firestore
    }
    
    /// Get Storage instance
    func getStorage() -> Storage? {
        return storage
    }
    
    /// Switch to a different environment (for testing)
    func switchEnvironment(to environment: Environment) {
        guard environment != currentEnvironment else { return }
        
        // Reset current configuration
        isConfigured = false
        firestore = nil
        storage = nil
        
        // Update environment
        currentEnvironment = environment
        
        // Reconfigure
        configure()
    }
    
    // MARK: - Private Methods
    
    private func detectEnvironment() {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        
        if bundleId.contains(".dev") {
            currentEnvironment = .development
        } else if bundleId.contains(".staging") {
            currentEnvironment = .staging
        } else {
            // Default to development for now (change to .production for release)
            currentEnvironment = .development
        }
        
        print("🔍 Detected environment: \(currentEnvironment.displayName) (Bundle ID: \(bundleId))")
    }
    
    private func configureFirebase() throws {
        // Check if Firebase is already configured
        if FirebaseApp.app() != nil {
            print("⚠️ Firebase already configured, skipping...")
            return
        }
        
        // Load the environment-specific GoogleService-Info.plist
        guard let path = Bundle.main.path(forResource: currentEnvironment.googleServiceFileName, ofType: "plist") else {
            throw FirebaseConfigurationError.missingConfigurationFile(currentEnvironment.googleServiceFileName)
        }
        
        guard let options = FirebaseOptions(contentsOfFile: path) else {
            throw FirebaseConfigurationError.invalidConfigurationFile(path)
        }
        
        // Configure Firebase with the loaded options
        FirebaseApp.configure(options: options)
        
        print("✅ Firebase configured with \(currentEnvironment.googleServiceFileName)")
    }
    
    private func setupServices() {
        // Initialize Firestore
        firestore = Firestore.firestore()
        
        // Configure Firestore settings
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        firestore?.settings = settings
        
        // Initialize Storage
        storage = Storage.storage()
        
        // Configure Analytics
        Analytics.setAnalyticsCollectionEnabled(true)
        
        // Configure Crashlytics
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        print("✅ Firebase services initialized")
    }
}

// MARK: - Error Types

enum FirebaseConfigurationError: LocalizedError {
    case missingConfigurationFile(String)
    case invalidConfigurationFile(String)
    case configurationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .missingConfigurationFile(let fileName):
            return "Missing Firebase configuration file: \(fileName).plist"
        case .invalidConfigurationFile(let path):
            return "Invalid Firebase configuration file at: \(path)"
        case .configurationFailed(let reason):
            return "Firebase configuration failed: \(reason)"
        }
    }
}

// MARK: - Environment Detection

extension FirebaseConfiguration {
    
    /// Check if running in development environment
    var isDevelopment: Bool {
        return currentEnvironment == .development
    }
    
    /// Check if running in staging environment
    var isStaging: Bool {
        return currentEnvironment == .staging
    }
    
    /// Check if running in production environment
    var isProduction: Bool {
        return currentEnvironment == .production
    }
    
    /// Get current project ID
    var projectId: String {
        switch currentEnvironment {
        case .development:
            return "on-brand-app-dev"
        case .staging:
            return "on-brand-app-staging"
        case .production:
            return "on-brand-app-prod"
        }
    }
    
    /// Get current storage bucket
    var storageBucket: String {
        return "\(projectId).appspot.com"
    }
}
