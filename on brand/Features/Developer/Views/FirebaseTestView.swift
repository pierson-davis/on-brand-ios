//
//  FirebaseTestView.swift
//  on brand
//
//  This view provides a simple test interface for Firebase connectivity
//  and basic functionality verification.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct FirebaseTestView: View {
    
    @StateObject private var firebaseConfig = FirebaseConfiguration.shared
    @StateObject private var authService = FirebaseAuthService()
    @StateObject private var dealService = FirebaseDealService()
    
    @State private var testResults: [String] = []
    @State private var isRunningTests = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("🔥 Firebase Test Suite")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Test Firebase connectivity and functionality")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Configuration Status
                VStack(alignment: .leading, spacing: 12) {
                    Text("Configuration Status")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: firebaseConfig.isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(firebaseConfig.isConfigured ? .green : .red)
                        Text("Firebase Configured")
                    }
                    
                    HStack {
                        Image(systemName: authService.isAuthenticated ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(authService.isAuthenticated ? .green : .red)
                        Text("User Authenticated")
                    }
                    
                    HStack {
                        Image(systemName: dealService.isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(dealService.isConnected ? .green : .red)
                        Text("Firestore Connected")
                    }
                    
                    Text("Environment: \(firebaseConfig.currentEnvironment.displayName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Test Buttons
                VStack(spacing: 12) {
                    Button("🧪 Run All Tests") {
                        runAllTests()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isRunningTests)
                    
                    Button("🔐 Test Authentication") {
                        testAuthentication()
                    }
                    .buttonStyle(.bordered)
                    .disabled(isRunningTests)
                    
                    Button("📊 Test Firestore") {
                        testFirestore()
                    }
                    .buttonStyle(.bordered)
                    .disabled(isRunningTests)
                    
                    Button("📸 Test Storage") {
                        testStorage()
                    }
                    .buttonStyle(.bordered)
                    .disabled(isRunningTests)
                }
                
                // Test Results
                if !testResults.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Test Results")
                            .font(.headline)
                        
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 4) {
                                ForEach(testResults, id: \.self) { result in
                                    Text(result)
                                        .font(.system(.caption, design: .monospaced))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Firebase Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Test Methods
    
    private func runAllTests() {
        isRunningTests = true
        testResults.removeAll()
        
        addTestResult("🧪 Starting Firebase test suite...")
        
        // Test 1: Configuration
        addTestResult("✅ Configuration: \(firebaseConfig.isConfigured ? "PASS" : "FAIL")")
        
        // Test 2: Authentication
        if authService.isAuthenticated {
            addTestResult("✅ Authentication: PASS")
        } else {
            addTestResult("❌ Authentication: FAIL - User not authenticated")
        }
        
        // Test 3: Firestore
        if dealService.isConnected {
            addTestResult("✅ Firestore: PASS")
        } else {
            addTestResult("❌ Firestore: FAIL - Not connected")
        }
        
        // Test 4: Create test deal
        testCreateDeal()
        
        isRunningTests = false
    }
    
    private func testAuthentication() {
        addTestResult("🔐 Testing authentication...")
        
        if authService.isAuthenticated {
            addTestResult("✅ User is authenticated: \(authService.currentUser?.displayName ?? "Unknown")")
        } else {
            addTestResult("❌ User is not authenticated")
            addTestResult("💡 Try signing in with Apple first")
        }
    }
    
    private func testFirestore() {
        addTestResult("📊 Testing Firestore connection...")
        
        if dealService.isConnected {
            addTestResult("✅ Firestore is connected")
            addTestResult("📈 Current deals count: \(dealService.deals.count)")
        } else {
            addTestResult("❌ Firestore is not connected")
        }
    }
    
    private func testStorage() {
        addTestResult("📸 Testing Storage connection...")
        
        // Test storage reference creation
        let storage = Storage.storage()
        let testRef = storage.reference().child("test/connection-test.txt")
        
        addTestResult("✅ Storage reference created successfully")
        addTestResult("📁 Test path: \(testRef.fullPath)")
    }
    
    private func testCreateDeal() {
        addTestResult("📝 Testing deal creation...")
        
        let testDeal = CreatorRequirement.sampleDeal
        dealService.addDeal(testDeal)
        
        addTestResult("✅ Test deal created: \(testDeal.title)")
    }
    
    private func addTestResult(_ result: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        testResults.append("[\(timestamp)] \(result)")
    }
}

#Preview {
    FirebaseTestView()
}
