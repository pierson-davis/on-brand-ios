//
//  OnboardingWelcomeScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingWelcomeScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .welcome(name) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: "Welcome, \(name)!",
                    subtitle: "Let's discover your authentic style",
                    progressLabel: model.progressLabel
                )
                
                EraSurfaceCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "hand.wave.fill")
                                .font(.title)
                                .foregroundColor(themeManager.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ready to find your vibe?")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textPrimary)
                                Text("We'll ask you a few questions to understand your style preferences and create a personalized experience just for you.")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.textSecondary)
                            }
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .foregroundColor(themeManager.accent)
                            Text("This will take about 3-4 minutes")
                                .font(.caption)
                                .foregroundColor(themeManager.textSecondary)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                }
                
                Spacer(minLength: 0)
                
                Button("Let's get started") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
}

