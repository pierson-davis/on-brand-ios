//
//  OnboardingPlanScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingPlanScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        switch model.content {
        case let .personalizedPlan(name, daysCount):
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: "Good news, \(name)!",
                    subtitle: "We've built your profile. Your style evolution will be tracked here.",
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    // Days counter card
                    EraSurfaceCard {
                        VStack(spacing: 16) {
                            Text("\(daysCount) days")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.primary)
                            
                            Text("in your style journey")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            Text("Your aesthetic evolution starts now")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    }
                    
                    EraSurfaceCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("What's next?")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Personalized style analysis")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Custom aesthetic recommendations")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Progress tracking system")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button("Let's find out your vibe") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            
        case let .customPlan(name, planDetails):
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: "Your custom plan, \(name)",
                    subtitle: nil,
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    EraSurfaceCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Personalized Style Roadmap")
                                .font(.headline)
                                .foregroundColor(themeManager.textPrimary)
                            
                            Text(planDetails)
                                .font(.body)
                                .foregroundColor(themeManager.textSecondary)
                                .multilineTextAlignment(.leading)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "target")
                                        .foregroundColor(.blue)
                                    Text("Daily style consistency goals")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                    Text("Weekly progress milestones")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                    Text("Monthly aesthetic reviews")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button("I'm ready to start") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            
        default:
            // This screen should only handle personalizedPlan and customPlan
            VStack {
                Text("Error: Unexpected content type")
                    .foregroundColor(themeManager.textPrimary)
                Button("Continue") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
        }
    }
}

