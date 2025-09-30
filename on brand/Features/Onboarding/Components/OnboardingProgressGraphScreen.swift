//
//  OnboardingProgressGraphScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingProgressGraphScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .progressGraph(title, _) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: title,
                    subtitle: nil,
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    // Progress graph visualization
                    EraSurfaceCard {
                        VStack(spacing: 20) {
                            Text("Style Evolution")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            // Simple line graph representation
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Week 1")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textSecondary)
                                    Spacer()
                                    Text("Week 2")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textSecondary)
                                    Spacer()
                                    Text("Week 3")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textSecondary)
                                    Spacer()
                                    Text("Week 4")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textSecondary)
                                }
                                
                                // Simple progress bar representation
                                VStack(spacing: 8) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(themeManager.primary)
                                            .frame(width: 12, height: 12)
                                        
                                        Circle()
                                            .fill(themeManager.primary.opacity(0.8))
                                            .frame(width: 12, height: 12)
                                        
                                        Circle()
                                            .fill(themeManager.primary.opacity(0.6))
                                            .frame(width: 12, height: 12)
                                        
                                        Circle()
                                            .fill(themeManager.primary.opacity(0.4))
                                            .frame(width: 12, height: 12)
                                        
                                        Spacer()
                                    }
                                    
                                    Text("Your aesthetic consistency improves over time")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    }
                    
                    EraSurfaceCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("What you'll track:")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "photo.stack")
                                        .foregroundColor(themeManager.primary)
                                    Text("Photo quality consistency")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "paintpalette")
                                        .foregroundColor(themeManager.accent)
                                    Text("Color palette adherence")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(themeManager.secondary)
                                    Text("Engagement improvement")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button("Continue") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
}

