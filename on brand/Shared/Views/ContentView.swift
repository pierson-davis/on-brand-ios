//
//  ContentView.swift
//  era
//
//  Created by Pierson Davis on 9/20/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

enum AppRoute: Hashable {
    case photoAnalyzer(VibeResult)
}

struct ContentView: View {
    @StateObject private var authService = FirebaseAuthService()
    // @StateObject private var onboardingService = FirebaseOnboardingService() // TODO: Enable after adding to Xcode project
    @StateObject private var vm = OnboardingViewModel()
    @State private var path: [AppRoute] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var hasCompletedOnboarding = false
    @ObservedObject private var profileService = UserProfileService.shared
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Developer Mode Properties
    /// Controls whether developer mode is enabled
    @State private var isDeveloperModeEnabled = false
    
    /// Navigation manager for developer dashboard
    @StateObject private var developerNavigationManager = DeveloperNavigationManager.shared
    
    // MARK: - Shake Detection Properties
    /// Controls whether shake feedback is visible
    @State private var showShakeFeedback = false
    
    /// Shake detector for developer console toggle
    @StateObject private var shakeDetector = ShakeDetector()
    
    /// Prevents double toggle during shake processing
    @State private var isShakeProcessing = false
    
    /// Last shake action time for additional protection
    @State private var lastShakeActionTime: Date = Date.distantPast

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                // MARK: - Developer Mode Check
                // If developer mode is enabled, show the developer dashboard
                if isDeveloperModeEnabled {
                    if developerNavigationManager.isDashboardVisible {
                        DeveloperDashboard(onShakeTest: {
                            handleShakeGesture()
                        })
                    } else if let currentScreen = developerNavigationManager.currentScreen {
                        developerNavigationManager.viewForScreen(currentScreen)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Back") {
                                        developerNavigationManager.goBack()
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Dashboard") {
                                        developerNavigationManager.returnToDashboard()
                                    }
                                }
                            }
                    }
                } else if authService.isAuthenticated {
                    // Check if user has completed onboarding in Firebase OR has a local profile
                    if let firebaseUser = authService.currentUser,
                       (profileService.hasProfile(for: firebaseUser.id) || hasCompletedOnboarding) {
                        // User has completed onboarding in Firebase or locally - show home screen
                        HomeView(onLogout: logout)
                            // TODO: Load user profile from Firebase onboarding data if it exists
                    } else {
                        // New user or no saved profile - show onboarding
                        OnboardingFlowView(vm: vm)
                            .onChange(of: vm.finished) { _, finished in
                                if finished {
                                    let result = vm.makeVibeResult()
                                    saveUserProfile(result)
                                    // Force reload the profile service to get the latest data
                                    profileService.loadCurrentProfile()
                                    // Mark onboarding as completed
                                    hasCompletedOnboarding = true
                                }
                            }
                    }
                } else {
                    // Login screen
                    loginView
                }
            }
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .photoAnalyzer(let result):
                    PhotoAnalyzerView(result: result, onLogout: logout)
                                .navigationBarBackButtonHidden(true)
                }
            }
        }
        .onAppear {
            checkAuthenticationStatus()
            setupShakeDetection()
        }
        .onShake {
            handleShakeGesture()
        }
        .overlay(
            // Shake feedback overlay
            ShakeFeedbackView(isVisible: $showShakeFeedback)
        )
    }
    
    private var loginView: some View {
        ZStack {
            EraBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 60)
                    
                    // Logo and branding section with animation
                    VStack(spacing: 32) {
                        // App icon with subtle animation
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.primary,
                                        themeManager.secondary
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Text("E")
                                    .font(.system(size: 56, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            )
                            .shadow(
                                color: themeManager.colorScheme == .dark ? 
                                    Color.clear : themeManager.primary.opacity(0.2), 
                                radius: 30, x: 0, y: 15
                            )
                            .scaleEffect(isLoading ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isLoading)
                        
                        VStack(spacing: 16) {
                            Text("Welcome to Era")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("Your AI stylist for feed-worthy vibes")
                                .font(.body)
                                .foregroundColor(themeManager.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                    
                    Spacer(minLength: 80)
                    
                    // Apple Sign In - Clean and simple
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            handleAppleSignInWithFirebase(result)
                        }
                    )
                    .signInWithAppleButtonStyle(themeManager.colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .cornerRadius(12)
                    .disabled(isLoading)
                    .padding(.horizontal, 24)
                    .id("apple-signin-\(themeManager.colorScheme)")
                    
                    Spacer(minLength: 60)
                    
                    // Terms and privacy - more subtle
                    VStack(spacing: 12) {
                        Text("By continuing, you agree to our")
                            .font(.caption2)
                            .foregroundColor(themeManager.textSecondary)
                        
                        HStack(spacing: 8) {
                            Button("Terms of Service") {
                                // TODO: Show terms
                            }
                            .font(.caption2)
                            .foregroundColor(themeManager.primary)
                            
                            Text("•")
                                .font(.caption2)
                                .foregroundColor(themeManager.textSecondary)
                            
                            Button("Privacy Policy") {
                                // TODO: Show privacy policy
                            }
                            .font(.caption2)
                            .foregroundColor(themeManager.primary)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // MARK: - Developer Mode Toggle
                    // This allows developers to access the developer dashboard
                    VStack(spacing: 8) {
                        Divider()
                            .background(themeManager.surfaceOutline)
                            .padding(.horizontal, 32)
                        
                        HStack {
                            Image(systemName: "hammer.fill")
                                .foregroundColor(themeManager.primary)
                                .font(.caption)
                            
                            Text("Developer Mode")
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isDeveloperModeEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: themeManager.primary))
                                .scaleEffect(0.8)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themeManager.surfaceOutline, lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 34)
                }
            }
        }
        .overlay(
            // Native loading overlay
            Group {
                if isLoading {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        // Native iOS style loading card
                        VStack(spacing: 20) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primary))
                                .scaleEffect(1.1)
                            
                            Text("Signing you in...")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.surface)
                                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                        )
                        .padding(.horizontal, 40)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
        )
        .alert("Unable to Sign In", isPresented: $showError) {
            Button("Try Again") {
                showError = false
                isLoading = false
            }
            Button("Cancel", role: .cancel) {
                showError = false
                isLoading = false
            }
        } message: {
            Text("Please check your connection and try again.")
        }
    }
    
    private func checkAuthenticationStatus() {
        // Authentication state is now managed by Firebase AuthService
    }
    
    // MARK: - Shake Detection Methods
    
    /// Setup shake detection for developer console toggle
    private func setupShakeDetection() {
        // Start shake detection with callback
        shakeDetector.startShakeDetection {
            handleShakeGesture()
        }
    }
    
    /// Handle shake gesture detection with enhanced protection against double triggers
    private func handleShakeGesture() {
        let currentTime = Date()
        
        // Additional protection: Check if we're already processing a shake
        if isShakeProcessing {
            print("🔧 Shake gesture ignored - already processing")
            return
        }
        
        // Additional protection: Check minimum time between shake actions
        if currentTime.timeIntervalSince(lastShakeActionTime) < 1.0 {
            print("🔧 Shake gesture ignored - too soon after last action")
            return
        }
        
        // Mark as processing to prevent double triggers
        isShakeProcessing = true
        lastShakeActionTime = currentTime
        
        // Toggle developer mode
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isDeveloperModeEnabled.toggle()
        }
        
        // Show visual feedback
        showShakeFeedback = true
        
        // Provide haptic feedback
        if isDeveloperModeEnabled {
            ShakeHapticFeedback.success()
        } else {
            ShakeHapticFeedback.warning()
        }
        
        // Log the action with timestamp
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("📱 [\(timestamp)] Shake detected - Developer mode \(isDeveloperModeEnabled ? "enabled" : "disabled")")
        
        // Additional debug information
        print("📱 [\(timestamp)] Current authentication state: \(authService.isAuthenticated)")
        print("📱 [\(timestamp)] Current onboarding completion: \(hasCompletedOnboarding)")
        
        // Reset processing flag after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isShakeProcessing = false
        }
    }
    
    private func logout() {
        // Clear authentication data
        UserDefaults.standard.removeObject(forKey: "is_authenticated")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_full_name")
        
        // Reset app state
        authService.signOut()
        hasCompletedOnboarding = false
        path = [] // Clear navigation stack
        
        // Reset onboarding flow state
        vm.reset()
        
        // Clear saved profile data
        profileService.clearProfile()
        
        print("Logged out successfully")
    }
    
    private func saveUserProfile(_ vibeResult: VibeResult) {
        guard let firebaseUser = authService.currentUser else {
            print("❌ No Firebase user found for saving profile")
            return
        }
        
        let userName = vm.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let firebaseName = firebaseUser.fullName ?? ""
        let finalName = userName.isEmpty ? (firebaseName.isEmpty ? "Era User" : firebaseName) : userName
        
        let profile = UserProfile.from(vibeResult: vibeResult, userId: firebaseUser.id, name: finalName)
        profileService.saveProfile(profile)
        print("✅ User profile saved for Firebase user: \(firebaseUser.id)")
    }
    
    private func handleAppleSignInWithFirebase(_ result: Result<ASAuthorization, Error>) {
        print("🔥 Apple Sign-In with Firebase handler called")
        isLoading = true
        
        switch result {
        case .success(let authorization):
            print("🔥 Apple Sign-In authorization received, delegating to Firebase Auth Service")
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Delegate to Firebase Auth Service
                authService.handleAppleSignInResult(appleIDCredential)
                
                // Monitor Firebase Auth state changes
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isLoading = false
                    if self.authService.isAuthenticated {
                        print("✅ Firebase authentication successful")
                        // Refresh user name from Firebase and rebuild onboarding flow
                        self.vm.refreshUserNameFromUserDefaults()
                        // TODO: Load onboarding data from Firebase
                        // self.onboardingService.loadOnboardingData()
                    } else {
                        print("❌ Firebase authentication failed")
                        self.errorMessage = "Authentication failed"
                        self.showError = true
                    }
                }
            }
            
        case .failure(let error):
            print("🔥 Apple Sign-In failed: \(error.localizedDescription)")
            isLoading = false
            errorMessage = "Sign in failed: \(error.localizedDescription)"
            showError = true
        }
    }
}


