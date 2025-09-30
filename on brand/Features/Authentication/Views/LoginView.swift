//
//  LoginView.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @EnvironmentObject private var themeManager: ThemeManager
    
    let onSignIn: (Result<ASAuthorization, Error>) -> Void
    
    var body: some View {
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
                    AppleSignInButton(onSignIn: handleAppleSignIn, isLoading: isLoading)
                    
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
            LoginLoadingOverlay(isLoading: isLoading)
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
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        isLoading = true
        onSignIn(result)
    }
}
