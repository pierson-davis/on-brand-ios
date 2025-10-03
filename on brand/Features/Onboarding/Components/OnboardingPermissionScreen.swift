//
//  OnboardingPermissionScreen.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct OnboardingPermissionScreen: View {
    let model: OnboardingScreen
    let action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    @ViewBuilder
    var body: some View {
        if case let .permissionRequest(title, description, permission) = model.content {
            VStack(alignment: .leading, spacing: 28) {
                OnboardingProgressHeader(
                    index: model.progressIndex,
                    total: model.total,
                    title: title,
                    subtitle: nil,
                    progressLabel: model.progressLabel
                )
                
                VStack(spacing: 24) {
                    // Permission illustration
                    VStack(spacing: 16) {
                        Image(systemName: iconForPermission(permission))
                            .font(.system(size: 60))
                            .foregroundColor(themeManager.primary)
                        
                        Text(permissionTitleForPermission(permission))
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
                                HStack(spacing: 12) {
                                    Image(systemName: "photo.stack")
                                        .foregroundColor(themeManager.primary)
                                    Text("Analyze your photo library")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(themeManager.accent)
                                    Text("Create personalized recommendations")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(themeManager.secondary)
                                    Text("Track your style evolution")
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textPrimary)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    // Privacy note
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.shield")
                                .foregroundColor(themeManager.secondary)
                                .font(.caption)
                            Text("Your photos stay private")
                                .font(.caption)
                                .foregroundColor(themeManager.secondary)
                        }
                        
                            Text("We only analyze photos you specifically select. Your privacy is our priority.")
                                .font(.caption2)
                                .foregroundColor(themeManager.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeManager.colorScheme == .dark ? themeManager.secondary.opacity(0.15) : themeManager.secondary.opacity(0.1))
                    )
                }
                
                Spacer(minLength: 0)
                
                Button("Allow Access") {
                    action()
                }
                .buttonStyle(EraPrimaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
    
    private func iconForPermission(_ permission: PermissionType) -> String {
        switch permission {
        case .photoAccess:
            return "photo.on.rectangle"
        case .notifications:
            return "bell"
        case .analytics:
            return "chart.bar"
        case .location:
            return "location"
        }
    }
    
    private func permissionTitleForPermission(_ permission: PermissionType) -> String {
        switch permission {
        case .photoAccess:
            return "Photo Access"
        case .notifications:
            return "Notifications"
        case .analytics:
            return "Analytics"
        case .location:
            return "Location"
        }
    }
}

