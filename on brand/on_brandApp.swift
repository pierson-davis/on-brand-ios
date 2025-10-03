//
//  on_brandApp.swift
//  on brand
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI
import FirebaseCore
import Foundation

@main
struct on_brandApp: App {
    
    // MARK: - Firebase Configuration
    
    init() {
        // Configure Firebase with environment-specific configuration
        FirebaseConfiguration.shared.configure()
        print("🔥 Firebase configuration enabled with environment-specific settings")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ThemeManager.shared)
                .environmentObject(FirebaseConfiguration.shared)
        }
    }
}