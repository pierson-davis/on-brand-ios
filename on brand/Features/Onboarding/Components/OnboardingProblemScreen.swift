//
//  OnboardingProblemScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingProblemScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .problemStatement(title, description, image) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: title,
                    subtitle: nil,
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    // Problem illustration
                    VStack(spacing: 16) {
                        Image(systemName: image)
                            .font(.system(size: 60))
                            .foregroundColor(themeManager.colorScheme == .dark ? Color.red.opacity(0.9) : Color.red.opacity(0.7))
                        
                        Text("The Problem")
                            .font(.headline)
                            .foregroundColor(themeManager.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(themeManager.colorScheme == .dark ? Color.red.opacity(0.15) : Color.red.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(themeManager.colorScheme == .dark ? Color.red.opacity(0.3) : Color.red.opacity(0.1), lineWidth: 1)
                            )
                    )
                    
                    EraSurfaceCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(description)
                                .font(.body)
                                .foregroundColor(themeManager.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(themeManager.colorScheme == .dark ? Color.orange.opacity(0.9) : Color.orange)
                                Text("Sound familiar? You're not alone.")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textSecondary)
                                Spacer()
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button("I need help with this") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
}

