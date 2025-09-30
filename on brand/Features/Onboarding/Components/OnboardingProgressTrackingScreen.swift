//
//  OnboardingProgressTrackingScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingProgressTrackingScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        switch model.content {
        case let .progressTracking(title, description),
             let .habitTracking(title, description),
             let .dailyCheckin(title, description):
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: title,
                    subtitle: nil,
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    // Dynamic illustration based on screen type
                    VStack(spacing: 16) {
                        Image(systemName: iconForContent(model.content))
                            .font(.system(size: 60))
                            .foregroundColor(themeManager.primary)
                        
                        Text(titleForContent(model.content))
                            .font(.headline)
                            .foregroundColor(themeManager.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(themeManager.primary.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(themeManager.primary.opacity(0.1), lineWidth: 1)
                            )
                    )
                    
                    EraSurfaceCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(description)
                                .font(.body)
                                .foregroundColor(themeManager.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(featuresForContent(model.content), id: \.icon) { feature in
                                    HStack(spacing: 12) {
                                        Image(systemName: feature.icon)
                                            .foregroundColor(feature.color)
                                        Text(feature.text)
                                            .font(.subheadline)
                                            .foregroundColor(themeManager.textPrimary)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                Button(buttonTextForContent(model.content)) {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        default:
            // This screen should only handle progressTracking, habitTracking, and dailyCheckin
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
    
    // Helper functions for dynamic content
    private func iconForContent(_ content: OnboardingScreen.Content) -> String {
        switch content {
        case .progressTracking:
            return "chart.line.uptrend.xyaxis"
        case .habitTracking:
            return "checkmark.circle.fill"
        case .dailyCheckin:
            return "calendar.circle.fill"
        default:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    private func titleForContent(_ content: OnboardingScreen.Content) -> String {
        switch content {
        case .progressTracking:
            return "Style Evolution"
        case .habitTracking:
            return "Style Habits"
        case .dailyCheckin:
            return "Daily Check-ins"
        default:
            return "Style Evolution"
        }
    }
    
    private func featuresForContent(_ content: OnboardingScreen.Content) -> [Feature] {
        switch content {
        case .progressTracking:
            return [
                Feature(icon: "photo.stack", color: .blue, text: "Photo analysis and curation"),
                Feature(icon: "paintpalette", color: .purple, text: "Aesthetic consistency scoring"),
                Feature(icon: "calendar", color: .green, text: "Daily style check-ins")
            ]
        case .habitTracking:
            return [
                Feature(icon: "checkmark.circle", color: .green, text: "Consistent photo posting"),
                Feature(icon: "paintpalette", color: .purple, text: "Color palette adherence"),
                Feature(icon: "star.fill", color: .orange, text: "Quality over quantity")
            ]
        case .dailyCheckin:
            return [
                Feature(icon: "sun.max", color: .yellow, text: "Morning style inspiration"),
                Feature(icon: "heart.fill", color: .red, text: "Motivation and encouragement"),
                Feature(icon: "target", color: .blue, text: "Goal tracking and reminders")
            ]
        default:
            return []
        }
    }
    
    private func buttonTextForContent(_ content: OnboardingScreen.Content) -> String {
        switch content {
        case .progressTracking:
            return "Sounds great!"
        case .habitTracking:
            return "Let's build habits!"
        case .dailyCheckin:
            return "I'm ready!"
        default:
            return "Continue"
        }
    }
}

struct Feature {
    let icon: String
    let color: Color
    let text: String
}

