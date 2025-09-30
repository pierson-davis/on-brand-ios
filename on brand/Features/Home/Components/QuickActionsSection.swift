//
//  QuickActionsSection.swift
//  era
//
//  Created by Pierson Davis on 9/28/25.
//

import SwiftUI

struct QuickActionsSection: View {
    let onAnalyzePhoto: () -> Void
    let onViewProfile: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Analyze Photo",
                    icon: "camera.fill",
                    action: onAnalyzePhoto
                )
                
                QuickActionButton(
                    title: "View Profile",
                    icon: "person.circle.fill",
                    action: onViewProfile
                )
            }
            .padding(.horizontal, 24)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(themeManager.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(themeManager.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(themeManager.surfaceOutline)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
