//
//  ShakeFeedbackView.swift
//  on brand
//
//  This view provides visual feedback when a shake gesture is detected.
//  It shows a brief animation to confirm the shake was recognized.
//
//  Created by Pierson Davis on January 2025.
//

import SwiftUI

/// View that provides visual feedback for shake gesture detection
struct ShakeFeedbackView: View {
    
    // MARK: - Properties
    
    /// Whether the shake feedback should be visible
    @Binding var isVisible: Bool
    
    /// Theme manager for consistent styling
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Animation state for the feedback
    @State private var animationScale: CGFloat = 0.5
    @State private var animationOpacity: Double = 0.0
    @State private var animationRotation: Double = 0.0
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if isVisible {
                // Background blur
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                // Feedback card
                VStack(spacing: 16) {
                    // Shake icon with animation
                    ZStack {
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
                            .frame(width: 80, height: 80)
                            .scaleEffect(animationScale)
                            .rotationEffect(.degrees(animationRotation))
                        
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(animationScale)
                    }
                    
                    // Feedback text
                    VStack(spacing: 8) {
                        Text("Shake Detected!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.textPrimary)
                        
                        Text("Developer Console Toggled")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(themeManager.textSecondary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.surface)
                        .shadow(
                            color: Color.black.opacity(0.2),
                            radius: 20,
                            x: 0,
                            y: 10
                        )
                )
                .scaleEffect(animationScale)
                .opacity(animationOpacity)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onChange(of: isVisible) { _, newValue in
            if newValue {
                showFeedback()
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Show the shake feedback animation
    private func showFeedback() {
        // Reset animation state
        animationScale = 0.5
        animationOpacity = 0.0
        animationRotation = 0.0
        
        // Animate in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
            animationScale = 1.0
            animationOpacity = 1.0
        }
        
        // Add rotation animation
        withAnimation(.easeInOut(duration: 0.3)) {
            animationRotation = 360.0
        }
        
        // Auto-hide after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            hideFeedback()
        }
    }
    
    /// Hide the shake feedback animation
    private func hideFeedback() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animationScale = 0.8
            animationOpacity = 0.0
        }
        
        // Reset visibility after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isVisible = false
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()
        
        ShakeFeedbackView(isVisible: .constant(true))
    }
    .environmentObject(ThemeManager.shared)
}
