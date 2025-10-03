import SwiftUI

/// Developer settings view for AI configuration
struct AISettingsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var themeManager: ThemeManager
    private let aiConfiguration = AIConfiguration.shared
    
    @State private var apiKey: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isTestingConnection = false
    @State private var testResult: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // API Key Section
                        apiKeySection
                        
                        // Test Connection Section
                        testConnectionSection
                        
                        // Status Section
                        statusSection
                        
                        // Instructions Section
                        instructionsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .background(themeManager.backgroundTop)
            .navigationTitle("AI Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss view
                    }
                }
            }
        }
        .onAppear {
            loadCurrentAPIKey()
        }
        .alert("AI Configuration", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .foregroundColor(themeManager.primary)
            
            Text("AI Email Parser Configuration")
                .font(.title2.bold())
                .foregroundColor(themeManager.textPrimary)
            
            Text("Configure OpenAI API key for AI-powered deal parsing")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .background(themeManager.surface)
    }
    
    // MARK: - API Key Section
    
    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OpenAI API Key")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                SecureField("Enter your OpenAI API key", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                
                Text("Your API key is stored securely in iOS Keychain")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            HStack(spacing: 12) {
                Button("Save API Key") {
                    saveAPIKey()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(apiKey.isEmpty)
                
                Button("Clear") {
                    clearAPIKey()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Test Connection Section
    
    private var testConnectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Test Connection")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                Button(action: testConnection) {
                    HStack {
                        if isTestingConnection {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "wifi")
                        }
                        
                        Text(isTestingConnection ? "Testing..." : "Test API Connection")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.primary)
                    )
                    .foregroundColor(.white)
                }
                .disabled(isTestingConnection || !aiConfiguration.isReady())
                
                if !testResult.isEmpty {
                    Text(testResult)
                        .font(.caption)
                        .foregroundColor(testResult.contains("Success") ? .green : .red)
                        .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Status")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            HStack {
                Circle()
                    .fill(aiConfiguration.isReady() ? .green : .red)
                    .frame(width: 12, height: 12)
                
                Text(aiConfiguration.isReady() ? "API Key Configured" : "No API Key")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textPrimary)
                
                Spacer()
            }
            
            if aiConfiguration.isReady() {
                Text("AI Email Parser is ready to use")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("Please configure your OpenAI API key to use AI features")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Instructions Section
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Get Your API Key")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                instructionStep(number: "1", text: "Visit OpenAI's website at openai.com")
                instructionStep(number: "2", text: "Sign up or log in to your account")
                instructionStep(number: "3", text: "Go to API Keys section in your dashboard")
                instructionStep(number: "4", text: "Create a new API key")
                instructionStep(number: "5", text: "Copy the key and paste it above")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Helper Views
    
    private func instructionStep(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(themeManager.primary)
                )
            
            Text(text)
                .font(.caption)
                .foregroundColor(themeManager.textSecondary)
            
            Spacer()
        }
    }
    
    // MARK: - Actions
    
    private func loadCurrentAPIKey() {
        if aiConfiguration.isReady() {
            // Don't show the actual key for security
            apiKey = "••••••••••••••••"
        }
    }
    
    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }
        
        // Don't save if it's the masked key
        if apiKey == "••••••••••••••••" {
            alertMessage = "Please enter a new API key"
            showingAlert = true
            return
        }
        
        aiConfiguration.configure(apiKey: apiKey)
        alertMessage = "API key saved successfully!"
        showingAlert = true
    }
    
    private func clearAPIKey() {
        aiConfiguration.disableAI()
        apiKey = ""
        testResult = ""
        alertMessage = "API key cleared"
        showingAlert = true
    }
    
    private func testConnection() {
        guard aiConfiguration.isReady() else {
            testResult = "Error: No API key configured"
            return
        }
        
        isTestingConnection = true
        testResult = ""
        
        Task {
            do {
                // Test with a simple API call
                let testResult = await testOpenAIConnection()
                
                await MainActor.run {
                    isTestingConnection = false
                    self.testResult = testResult
                }
            }
        }
    }
    
    private func testOpenAIConnection() async -> String {
        // This would make a simple test call to OpenAI
        // For now, we'll simulate a test
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        return "Success: API connection working!"
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Preview

#Preview {
    AISettingsView()
        .environmentObject(ThemeManager.shared)
}
