//
//  ScreenshotGeneratorView.swift
//  on brand
//
//  This view provides screenshot generation functionality for developers.
//  It captures visual screenshots of all app screens in light, dark, and system themes.
//  Based on the screenshot generator implementation guide.
//
//  Created by Pierson Davis on January 2025.
//  TEMPORARILY DISABLED - Contains compilation errors
//

/*
import SwiftUI
import UIKit
import Photos

// MARK: - Screenshot Generator View
// This view provides screenshot generation functionality for developers
struct ScreenshotGeneratorView: View {
    
    // MARK: - State Properties
    /// Controls whether screenshots are currently being generated
    @State private var isGenerating = false
    
    /// Current progress of screenshot generation (0.0 to 1.0)
    @State private var progress: Double = 0
    
    /// Current screen being processed
    @State private var currentScreen = ""
    
    /// Controls whether the completion alert is shown
    @State private var showCompletion = false
    
    /// Debug logs for the screenshot generation process
    @State private var debugLogs: [String] = []
    
    /// Controls whether the Photos permission is granted
    @State private var photosPermissionGranted = false
    
    /// Controls whether the permission request is shown
    @State private var showPermissionRequest = false
    
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
                    VStack(spacing: 30) {
                        // MARK: - Header Section
                        // This shows the screenshot generator title and description
                        headerSection
                        
                        // MARK: - Progress Section
                        // This shows the current progress when generating screenshots
                        if isGenerating {
                            progressSection
                        }
                        
                        // MARK: - Action Buttons Section
                        // This provides the main action buttons
                        actionButtonsSection
                        
                        // MARK: - Debug Logs Section
                        // This shows debug information about the screenshot generation
                        if !debugLogs.isEmpty {
                            debugLogsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Screenshot Generator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the view
                    }
                }
            }
        }
        .alert("Screenshots Generated!", isPresented: $showCompletion) {
            Button("OK") { }
        } message: {
            Text("All screenshots have been generated and saved to your Photos library.")
        }
        .alert("Photos Permission Required", isPresented: $showPermissionRequest) {
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please grant Photos permission in Settings to save screenshots.")
        }
        .onAppear {
            checkPhotosPermission()
        }
    }
    
    // MARK: - Header Section
    /// The header section with title and description
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Screenshot Icon
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primary)
            
            // Title
            Text("Screenshot Generator")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textPrimary)
            
            // Description
            Text("Generate visual screenshots of all app screens in light, dark, and system themes")
                .font(.subheadline)
                .foregroundColor(themeManager.textSecondary)
                .multilineTextAlignment(.center)
            
            // Permission Status
            HStack {
                Image(systemName: photosPermissionGranted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(photosPermissionGranted ? .green : .orange)
                
                Text(photosPermissionGranted ? "Photos Permission Granted" : "Photos Permission Required")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(photosPermissionGranted ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(photosPermissionGranted ? Color.green.opacity(0.3) : Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Progress Section
    /// Shows the current progress when generating screenshots
    private var progressSection: some View {
        VStack(spacing: 16) {
            // Progress Bar
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: themeManager.primary))
                .scaleEffect(y: 2)
            
            // Current Screen
            if !currentScreen.isEmpty {
                Text("Processing: \(currentScreen)")
                    .font(.caption)
                    .foregroundColor(themeManager.textSecondary)
            }
            
            // Progress Percentage
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
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
    
    // MARK: - Action Buttons Section
    /// The main action buttons for screenshot generation
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Generate All Screenshots Button
            Button(action: {
                Task {
                    await generateAllScreenshots()
                }
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Generate All Screenshots")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.primary)
                .cornerRadius(12)
            }
            .disabled(isGenerating || !photosPermissionGranted)
            
            // Test Photos Access Button
            Button(action: {
                Task {
                    await testPhotosAccess()
                }
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Test Photos Access")
                }
                .font(.subheadline)
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Clear Logs Button
            if !debugLogs.isEmpty {
                Button(action: {
                    debugLogs.removeAll()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Clear Logs")
                    }
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Debug Logs Section
    /// Shows debug information about the screenshot generation
    private var debugLogsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Debug Logs")
                .font(.headline)
                .foregroundColor(themeManager.textPrimary)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(debugLogs, id: \.self) { log in
                        Text(log)
                            .font(.caption)
                            .foregroundColor(themeManager.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themeManager.surfaceOutline, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Helper Methods
    
    /// Checks if Photos permission is granted
    private func checkPhotosPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        photosPermissionGranted = status == .authorized || status == .limited
    }
    
    /// Tests Photos access
    private func testPhotosAccess() async {
        addDebugLog("Testing Photos access...")
        
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        switch status {
        case .authorized, .limited:
            photosPermissionGranted = true
            addDebugLog("✅ Photos permission granted")
        case .denied, .restricted:
            photosPermissionGranted = false
            addDebugLog("❌ Photos permission denied")
            showPermissionRequest = true
        case .notDetermined:
            addDebugLog("⚠️ Photos permission not determined")
        @unknown default:
            addDebugLog("❓ Unknown Photos permission status")
        }
    }
    
    /// Generates all screenshots using real view capture
    private func generateAllScreenshots() async {
        guard photosPermissionGranted else {
            addDebugLog("❌ Cannot generate screenshots without Photos permission")
            showPermissionRequest = true
            return
        }
        
        isGenerating = true
        progress = 0
        currentScreen = ""
        debugLogs.removeAll()
        
        addDebugLog("🚀 Starting screenshot generation...")
        
        // Create screenshot generator
        let generator = ScreenshotGenerator()
        generator.addDebugLog = { log in
            addDebugLog(log)
        }
        
        // Generate screenshots for each theme
        let themes: [ThemeMode] = [.light, .dark, .system]
        
        for (themeIndex, theme) in themes.enumerated() {
            addDebugLog("📱 Generating screenshots for \(theme.displayName) theme...")
            
            // Set theme
            themeManager.setThemeMode(theme)
            
            // Wait for theme to apply
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Generate onboarding screenshots
            await generateOnboardingScreenshots(themeName: theme.displayName, generator: generator) { screen, progressValue in
                currentScreen = "\(theme.displayName) - \(screen)"
                let totalScreens = 22 * themes.count // 22 screens total
                let currentProgress = (Double(themeIndex * 22) + progressValue) / Double(totalScreens)
                progress = currentProgress
            }
            
            // Generate main app screenshots
            await generateMainAppScreenshots(themeName: theme.displayName, generator: generator) { screen, progressValue in
                currentScreen = "\(theme.displayName) - \(screen)"
                let totalScreens = 22 * themes.count // 22 screens total
                let currentProgress = (Double(themeIndex * 22) + 18 + progressValue) / Double(totalScreens)
                progress = currentProgress
            }
        }
        
        addDebugLog("✅ Screenshot generation completed!")
        addDebugLog("📊 Generated 66 screenshots (22 screens × 3 themes)")
        
        isGenerating = false
        currentScreen = ""
        showCompletion = true
    }
    
    /// Generates onboarding screenshots
    private func generateOnboardingScreenshots(themeName: String, generator: ScreenshotGenerator, progressCallback: @escaping (String, Double) -> Void) async {
        let screens: [(String, () -> AnyView)] = [
            ("01_hero_screen", { [self] in AnyView(createOnboardingHeroScreen()) }),
            ("02_welcome_screen", { [self] in AnyView(createOnboardingWelcomeScreen()) }),
            ("03_problem_screen", { [self] in AnyView(createOnboardingProblemScreen()) }),
            ("04_checklist_screen", { [self] in AnyView(createOnboardingChecklistScreen()) }),
            ("05_name_input", { [self] in AnyView(createNameInputScreen()) }),
            ("06_gender_selection", { [self] in AnyView(createGenderSelectionScreen()) }),
            ("07_question_screen", { [self] in AnyView(createOnboardingQuestionScreen()) }),
            ("08_plan_screen", { [self] in AnyView(createOnboardingPlanScreen()) }),
            ("09_progress_tracking", { [self] in AnyView(createOnboardingProgressTrackingScreen()) }),
            ("10_progress_graph", { [self] in AnyView(createOnboardingProgressGraphScreen()) }),
            ("11_permission_screen", { [self] in AnyView(createOnboardingPermissionScreen()) }),
            ("12_summary_screen", { [self] in AnyView(createOnboardingSummaryScreen()) })
        ]
        
        for (index, (name, viewCreator)) in screens.enumerated() {
            let view = viewCreator()
            await generator.takeScreenshot(of: view, named: "\(themeName.lowercased())_\(name)")
            let progress = Double(index + 1) / Double(screens.count)
            progressCallback("Onboarding: \(name)", progress)
        }
    }
    
    /// Generates main app screenshots
    private func generateMainAppScreenshots(themeName: String, generator: ScreenshotGenerator, progressCallback: @escaping (String, Double) -> Void) async {
        let screens: [(String, () -> AnyView)] = [
            ("01_login_screen", { [self] in AnyView(createLoginScreen()) }),
            ("02_home_screen", { [self] in AnyView(createHomeScreen()) }),
            ("03_profile_screen", { [self] in AnyView(createProfileScreen()) }),
            ("04_instagram_profile", { [self] in AnyView(createInstagramProfileScreen()) }),
            ("05_photo_analyzer", { [self] in AnyView(createPhotoAnalyzerScreen()) }),
            ("06_settings_screen", { [self] in AnyView(createSettingsScreen()) }),
            ("07_loading_screen", { [self] in AnyView(createLoadingScreen()) }),
            ("08_error_screen", { [self] in AnyView(createErrorScreen()) })
        ]
        
        for (index, (name, viewCreator)) in screens.enumerated() {
            let view = viewCreator()
            await generator.takeScreenshot(of: view, named: "\(themeName.lowercased())_\(name)")
            let progress = Double(index + 1) / Double(screens.count)
            progressCallback("Main App: \(name)", progress)
        }
    }
    
    // MARK: - Screen Creators
    
    private func createOnboardingHeroScreen() -> some View {
        OnboardingHeroScreen(
            model: OnboardingScreen(
                progressIndex: 0,
                total: 18,
                content: .hero(
                    image: "hero_image",
                    title: "Welcome to Era",
                    subtitle: "Discover your unique style",
                    cta: "Get Started"
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingWelcomeScreen() -> some View {
        OnboardingWelcomeScreen(
            model: OnboardingScreen(
                progressIndex: 1,
                total: 18,
                content: .welcome(name: "Let's Get Started")
            ),
            action: {}
        )
    }
    
    private func createOnboardingProblemScreen() -> some View {
        OnboardingProblemScreen(
            model: OnboardingScreen(
                progressIndex: 2,
                total: 18,
                content: .problem(
                    title: "The Problem",
                    description: "Finding your style is hard",
                    icon: "exclamationmark.triangle.fill"
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingChecklistScreen() -> some View {
        OnboardingChecklistScreen(
            model: OnboardingScreen(
                progressIndex: 3,
                total: 18,
                content: .benefits(
                    title: "What You'll Get",
                    items: [
                        OnboardingScreen.ChecklistRow(icon: "star.fill", title: "Personalized style recommendations", description: "Get recommendations tailored to your style"),
                        OnboardingScreen.ChecklistRow(icon: "sparkles", title: "AI-powered outfit suggestions", description: "Smart suggestions based on your preferences"),
                        OnboardingScreen.ChecklistRow(icon: "chart.line.uptrend.xyaxis", title: "Trend analysis and insights", description: "Stay ahead of the latest fashion trends"),
                        OnboardingScreen.ChecklistRow(icon: "heart.fill", title: "Style confidence boost", description: "Feel confident in your fashion choices")
                    ]
                )
            ),
            action: {}
        )
    }
    
    private func createNameInputScreen() -> some View {
        NameInputView(
            name: .constant("John"),
            onContinue: {}
        )
    }
    
    private func createGenderSelectionScreen() -> some View {
        GenderSelectionView(
            selectedGender: .constant(.male),
            onContinue: {}
        )
    }
    
    private func createOnboardingQuestionScreen() -> some View {
        OnboardingQuestionScreen(
            model: OnboardingScreen(
                progressIndex: 4,
                total: 18,
                content: .question(
                    QuizQuestion(
                        prompt: "What's your style?",
                        answers: [
                            QuizAnswer(text: "Minimalist", weights: [.minimalistMaven: 1]),
                            QuizAnswer(text: "Bold", weights: [.boldRebel: 1]),
                            QuizAnswer(text: "Classic", weights: [.ruggedGentleman: 1]),
                            QuizAnswer(text: "Trendy", weights: [.socialMagnet: 1])
                        ]
                    )
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingPlanScreen() -> some View {
        OnboardingPlanScreen(
            model: OnboardingScreen(
                progressIndex: 5,
                total: 18,
                content: .plan(
                    title: "Choose Your Plan",
                    description: "Select the plan that works for you",
                    plans: [
                        OnboardingScreen.PlanOption(name: "Basic", price: "Free", features: ["Basic recommendations", "Limited AI analysis"]),
                        OnboardingScreen.PlanOption(name: "Pro", price: "$9.99/month", features: ["Advanced AI analysis", "Unlimited recommendations", "Priority support"])
                    ]
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingProgressTrackingScreen() -> some View {
        OnboardingProgressTrackingScreen(
            model: OnboardingScreen(
                progressIndex: 6,
                total: 18,
                content: .progressTracking(
                    title: "Track Your Progress",
                    description: "Monitor your style journey",
                    features: [
                        OnboardingScreen.ProgressFeature(icon: "chart.line.uptrend.xyaxis", title: "Style Analytics", description: "Track your style evolution"),
                        OnboardingScreen.ProgressFeature(icon: "calendar", title: "Daily Check-ins", description: "Regular style updates"),
                        OnboardingScreen.ProgressFeature(icon: "trophy", title: "Achievements", description: "Unlock style milestones")
                    ]
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingProgressGraphScreen() -> some View {
        OnboardingProgressGraphScreen(
            model: OnboardingScreen(
                progressIndex: 7,
                total: 18,
                content: .progressGraph(
                    title: "Your Style Journey",
                    weeks: 12
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingPermissionScreen() -> some View {
        OnboardingPermissionScreen(
            model: OnboardingScreen(
                progressIndex: 8,
                total: 18,
                content: .permissionRequest(
                    title: "Permissions",
                    description: "We need access to help you",
                    permission: .photoAccess
                )
            ),
            action: {}
        )
    }
    
    private func createOnboardingSummaryScreen() -> some View {
        OnboardingSummaryScreen(
            model: OnboardingScreen(
                progressIndex: 9,
                total: 18,
                content: .summary(
                    title: "You're All Set!",
                    body: "Ready to discover your style?",
                    accent: .blue,
                    cta: "Start My Journey"
                )
            ),
            action: {}
        )
    }
    
    private func createLoginScreen() -> some View {
        LoginView()
    }
    
    private func createHomeScreen() -> some View {
        HomeView(onLogout: {})
    }
    
    private func createProfileScreen() -> some View {
        ProfileView(
            userArchetype: .mainCharacter,
            onDismiss: nil,
            onLogout: nil
        )
    }
    
    private func createInstagramProfileScreen() -> some View {
        InstagramProfileView(
            userArchetype: .socialMagnet,
            onDismiss: {},
            onLogout: nil
        )
    }
    
    private func createPhotoAnalyzerScreen() -> some View {
        PhotoAnalyzerView(
            result: VibeResult(
                primary: .minimalistMaven,
                secondary: nil,
                confidence: 0.9,
                analysis: "Your style is very minimalist.",
                recommendations: ["Keep it simple"],
                createdAt: Date()
            ),
            onLogout: nil
        )
    }
    
    private func createSettingsScreen() -> some View {
        SettingsView()
    }
    
    private func createLoadingScreen() -> some View {
        LoadingView(message: "Analyzing your style...")
    }
    
    private func createErrorScreen() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.octagon.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Something went wrong")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Try Again") {
                // Retry action
            }
            .buttonStyle(EraPrimaryButtonStyle())
        }
        .padding()
    }
    
    /// Adds a debug log entry
    private func addDebugLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        debugLogs.append("[\(timestamp)] \(message)")
    }
}

// MARK: - Preview
/// This section provides a preview for Xcode's canvas
#Preview {
    ScreenshotGeneratorView()
        .environmentObject(ThemeManager.shared)
}
*/
