//
//  ContentView.swift
//  era
//
//  Created by Pierson Davis on 9/20/25.
//

import SwiftUI
import AuthenticationServices

enum AppRoute: Hashable {
    case photoAnalyzer(VibeResult)
}

struct ContentView: View {
    @State private var isAuthenticated = false
    @StateObject private var vm = OnboardingViewModel()
    @State private var path: [AppRoute] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var hasCompletedOnboarding = false
    @ObservedObject private var profileService = UserProfileService.shared
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
            NavigationStack(path: $path) {
            Group {
                if isAuthenticated {
                    // Check if user has a saved profile OR has completed onboarding
                    if let currentUserId = UserDefaults.standard.string(forKey: "user_id"),
                       (profileService.hasProfile(for: currentUserId) || hasCompletedOnboarding) {
                        // User has saved profile or just completed onboarding - show home screen
                        HomeView(onLogout: logout)
                    } else {
                        // New user or no saved profile - show onboarding
                OnboardingFlowView(vm: vm)
                        .onChange(of: vm.finished) { finished in
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
        }
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
                            handleAppleSignIn(result)
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
        isAuthenticated = UserDefaults.standard.bool(forKey: "is_authenticated")
    }
    
    private func logout() {
        // Clear authentication data
        UserDefaults.standard.removeObject(forKey: "is_authenticated")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_full_name")
        
        // Reset app state
        isAuthenticated = false
        hasCompletedOnboarding = false
        path = [] // Clear navigation stack
        
        // Reset onboarding flow state
        vm.reset()
        
        // Clear saved profile data
        profileService.clearProfile()
        
        print("Logged out successfully")
    }
    
    private func saveUserProfile(_ vibeResult: VibeResult) {
        guard let userId = UserDefaults.standard.string(forKey: "user_id") else {
            print("❌ No user ID found for saving profile")
            return
        }
        
        let userName = vm.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let appleIdName = UserDefaults.standard.string(forKey: "user_full_name") ?? ""
        let finalName = userName.isEmpty ? (appleIdName.isEmpty ? "Era User" : appleIdName) : userName
        
        
        let profile = UserProfile.from(vibeResult: vibeResult, userId: userId, name: finalName)
        profileService.saveProfile(profile)
        print("✅ User profile saved for returning user experience")
    }
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        print("🍎 Apple Sign-In handler called")
        isLoading = true
        
        switch result {
        case .success(let authorization):
            print("🍎 Apple Sign-In authorization received")
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("🍎 Credential details:")
                print("🍎 User ID: \(userIdentifier)")
                print("🍎 Full Name Object: \(String(describing: fullName))")
                print("🍎 Given Name: \(fullName?.givenName ?? "nil")")
                print("🍎 Family Name: \(fullName?.familyName ?? "nil")")
                print("🍎 Email: \(email ?? "nil")")
                
                let fullNameString: String?
                if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                    fullNameString = "\(givenName) \(familyName)"
                    print("🍎 Combined name: \(fullNameString!)")
                } else {
                    fullNameString = fullName?.givenName ?? fullName?.familyName
                    print("🍎 Single name: \(fullNameString ?? "nil")")
                }
                
                print("Apple Sign In successful:")
                print("User ID: \(userIdentifier)")
                print("Full Name: \(fullNameString ?? "N/A")")
                print("Email: \(email ?? "N/A")")
                
                // Store basic auth state
                UserDefaults.standard.set(true, forKey: "is_authenticated")
                UserDefaults.standard.set(userIdentifier, forKey: "user_id")
                if let email = email {
                    UserDefaults.standard.set(email, forKey: "user_email")
                }
                
                // Handle name storage - only store if provided (first sign-in) or if we don't have one stored
                let existingStoredName = UserDefaults.standard.string(forKey: "user_full_name")
                print("🍎 Existing stored name: '\(existingStoredName ?? "nil")'")
                
                if let fullName = fullNameString {
                    // New name provided (first sign-in) - store it
                    UserDefaults.standard.set(fullName, forKey: "user_full_name")
                    vm.userName = fullName
                } else if let existingName = existingStoredName {
                    // No new name, but we have one stored from previous sign-in - use it
                    vm.userName = existingName
                } else {
                    // No name available at all - use default
                    let defaultName = "Era User"
                    vm.userName = defaultName
                }
                
                // Clear screen cache to rebuild onboarding flow with correct name input requirement
                vm.clearScreenCache()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isLoading = false
                    self.isAuthenticated = true
                }
            }
            
        case .failure(let error):
            print("🍎 Apple Sign-In failed: \(error.localizedDescription)")
            isLoading = false
            errorMessage = "Sign in failed: \(error.localizedDescription)"
            showError = true
        }
    }
}


