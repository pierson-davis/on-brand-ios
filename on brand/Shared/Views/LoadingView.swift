//
//  LoadingView.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var currentMessageIndex = 0
    @State private var displayedText = ""
    @State private var showStars = false
    @State private var starAnimationDelay = 0.0
    
    let onLoadingComplete: () -> Void
    
    private let loadingMessages = [
        "Setting up your vibe profile...",
        "Preparing AI stylist...",
        "Loading your personalized experience...",
        "Almost ready to glow...",
        "Finalizing your era..."
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color(red: 0.1, green: 0.1, blue: 0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App logo/icon area
                VStack(spacing: 20) {
                    // Animated logo placeholder
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.4, blue: 1.0),
                                        Color(red: 0.6, green: 0.2, blue: 1.0)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Text("ERA")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    // App name
                    Text("era")
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                
                // Loading indicator - moved up
                VStack(spacing: 24) {
                    if showStars {
                        // App Store style 5-star rating
                        VStack(spacing: 16) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.yellow)
                                        .scaleEffect(starAnimationDelay > Double(index) * 0.2 ? 1.0 : 0.0)
                                        .animation(
                                            Animation.spring(response: 0.6, dampingFraction: 0.8)
                                                .delay(Double(index) * 0.2),
                                            value: starAnimationDelay
                                        )
                                }
                            }
                            
                            Text("Welcome to Era!")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(starAnimationDelay > 1.0 ? 1.0 : 0.0)
                                .animation(
                                    Animation.easeInOut(duration: 0.5)
                                        .delay(1.0),
                                    value: starAnimationDelay
                                )
                        }
                    } else {
                        // Typing text only
                        Text(displayedText)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .frame(minHeight: 24)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            isAnimating = true
            startTypingAnimation()
            simulateLoading()
        }
    }
    
    private func startTypingAnimation() {
        typeNextMessage()
    }
    
    private func typeNextMessage() {
        guard currentMessageIndex < loadingMessages.count else {
            // All messages typed, show stars
            showStars = true
            startStarAnimation()
            return
        }
        
        let message = loadingMessages[currentMessageIndex]
        displayedText = ""
        
        // Type each character
        for (index, character) in message.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                displayedText += String(character)
            }
        }
        
        // Move to next message after typing is complete
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(message.count) * 0.05 + 0.8) {
            currentMessageIndex += 1
            typeNextMessage()
        }
    }
    
    private func startStarAnimation() {
        starAnimationDelay = 0.0
        withAnimation(.easeInOut(duration: 1.5)) {
            starAnimationDelay = 2.0
        }
    }
    
    private func simulateLoading() {
        // Total loading time: ~3.5 seconds (5 messages + stars)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            onLoadingComplete()
        }
    }
}

