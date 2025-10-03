//
//  APIDebugView.swift
//  on brand
//
//  This file defines a debug view for testing API key loading.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// Debug view for testing API key loading
struct APIDebugView: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var debugInfo: [String] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("API Debug Information")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if isLoading {
                        ProgressView("Loading debug info...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(debugInfo, id: \.self) { info in
                            Text(info)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("API Debug")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadDebugInfo()
        }
    }
    
    private func loadDebugInfo() {
        debugInfo.removeAll()
        isLoading = true
        
        // Test 1: Check bundle path
        let bundlePath = Bundle.main.bundlePath
        debugInfo.append("📱 App Bundle Path: \(bundlePath)")
        
        // Test 2: Check for xcconfig files
        let configFiles = [
            "Secrets-Development.xcconfig",
            "Secrets-Staging.xcconfig", 
            "Secrets-Production.xcconfig"
        ]
        
        for configFile in configFiles {
            debugInfo.append("\n📋 Testing \(configFile):")
            
            if let configPath = Bundle.main.path(forResource: configFile.replacingOccurrences(of: ".xcconfig", with: ""), ofType: "xcconfig") {
                debugInfo.append("✅ Found in bundle: \(configPath)")
                
                do {
                    let content = try String(contentsOfFile: configPath)
                    if content.contains("sk-proj-") {
                        debugInfo.append("✅ Contains API key")
                    } else {
                        debugInfo.append("❌ No API key found")
                    }
                } catch {
                    debugInfo.append("❌ Error reading file: \(error.localizedDescription)")
                }
            } else {
                debugInfo.append("❌ Not found in bundle")
            }
        }
        
        // Test 3: Check SecureAPIManager
        debugInfo.append("\n🔧 SecureAPIManager Status:")
        let secureManager = SecureAPIManager.shared
        debugInfo.append("Deployment Mode: \(secureManager.getDeploymentMode())")
        debugInfo.append("Is Ready: \(secureManager.isReady())")
        debugInfo.append("Configuration Status: \(secureManager.configurationStatus.displayName)")
        
        if let apiKey = secureManager.getAPIKey() {
            debugInfo.append("API Key: \(String(apiKey.prefix(15)))...")
        } else {
            debugInfo.append("API Key: Not available")
        }
        
        // Test 4: Check AIConfiguration
        debugInfo.append("\n🤖 AIConfiguration Status:")
        let aiConfig = AIConfiguration.shared
        debugInfo.append("Is AI Enabled: \(aiConfig.isAIEnabled)")
        debugInfo.append("Configuration Status: \(aiConfig.configurationStatus.displayName)")
        
        if let apiKey = aiConfig.getAPIKey() {
            debugInfo.append("API Key: \(String(apiKey.prefix(15)))...")
        } else {
            debugInfo.append("API Key: Not available")
        }
        
        isLoading = false
    }
}

#Preview {
    APIDebugView()
        .environmentObject(ThemeManager.shared)
}
