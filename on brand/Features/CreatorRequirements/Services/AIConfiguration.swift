//
//  AIConfiguration.swift
//  on brand
//
//  This file defines secure configuration for AI services.
//  Implements App Store safe API key management and configuration.
//  Now uses SecureAPIManager for production deployment.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation

/// Secure configuration for AI services
/// This class now acts as a wrapper around SecureAPIManager for backward compatibility
class AIConfiguration: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AIConfiguration()
    
    // MARK: - Properties
    
    /// OpenAI API key (stored securely)
    @Published private(set) var openAIAPIKey: String?
    
    /// Whether AI services are enabled
    @Published private(set) var isAIEnabled: Bool = false
    
    /// Configuration status
    @Published private(set) var configurationStatus: ConfigurationStatus = .notConfigured
    
    /// Secure API Manager
    private let secureAPIManager = SecureAPIManager.shared
    
    // MARK: - Configuration Status
    
    enum ConfigurationStatus {
        case notConfigured
        case configured
        case invalidKey
        case networkError
        case rateLimited
        case disabled
        
        var displayName: String {
            switch self {
            case .notConfigured:
                return "Not Configured"
            case .configured:
                return "Ready"
            case .invalidKey:
                return "Invalid API Key"
            case .networkError:
                return "Network Error"
            case .rateLimited:
                return "Rate Limited"
            case .disabled:
                return "Disabled"
            }
        }
        
        var color: String {
            switch self {
            case .notConfigured:
                return "gray"
            case .configured:
                return "green"
            case .invalidKey:
                return "red"
            case .networkError:
                return "orange"
            case .rateLimited:
                return "yellow"
            case .disabled:
                return "gray"
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Initialize with SecureAPIManager
        updateFromSecureManager()
        
        // Listen for changes in SecureAPIManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(secureManagerDidUpdate),
            name: .secureAPIManagerDidUpdate,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    /// Configure AI services with API key
    func configure(apiKey: String) {
        // Delegate to SecureAPIManager for development mode
        if !secureAPIManager.isProductionMode() {
            // For development, store in UserDefaults
            UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
            updateFromSecureManager()
        } else {
            // For production, this should not be called
            print("Warning: configure() called in production mode. Use build script instead.")
        }
    }
    
    /// Disable AI services
    func disableAI() {
        // Clear UserDefaults for development
        if !secureAPIManager.isProductionMode() {
            UserDefaults.standard.removeObject(forKey: "openai_api_key")
        }
        updateFromSecureManager()
    }
    
    /// Get API key for use (returns nil if not configured)
    func getAPIKey() -> String? {
        return secureAPIManager.getAPIKey()
    }
    
    /// Check if AI services are ready
    func isReady() -> Bool {
        return secureAPIManager.isReady()
    }
    
    // MARK: - Private Methods
    
    /// Update properties from SecureAPIManager
    private func updateFromSecureManager() {
        openAIAPIKey = secureAPIManager.getAPIKey()
        isAIEnabled = secureAPIManager.isReady()
        
        // Map SecureAPIManager status to AIConfiguration status
        switch secureAPIManager.configurationStatus {
        case .notConfigured:
            configurationStatus = .notConfigured
        case .configured:
            configurationStatus = .configured
        case .productionReady:
            configurationStatus = .configured
        case .invalidKey:
            configurationStatus = .invalidKey
        case .networkError:
            configurationStatus = .networkError
        case .rateLimited:
            configurationStatus = .rateLimited
        case .disabled:
            configurationStatus = .disabled
        }
    }
    
    /// Handle SecureAPIManager updates
    @objc private func secureManagerDidUpdate() {
        DispatchQueue.main.async {
            self.updateFromSecureManager()
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let secureAPIManagerDidUpdate = Notification.Name("secureAPIManagerDidUpdate")
}
