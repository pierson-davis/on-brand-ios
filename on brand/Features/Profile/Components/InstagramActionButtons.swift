//
//  InstagramActionButtons.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct InstagramActionButtons: View {
    let onAddPhoto: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 8) {
            // Edit Profile button (Instagram style)
            Button(action: {
                // Edit profile action
            }) {
                Text("Edit profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
            
            // Share Profile button
            Button(action: {
                // Share profile action
            }) {
                Text("Share profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
            
            // Add Photo button (Instagram style)
            Button(action: onAddPhoto) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeManager.separator, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(themeManager.backgroundTop)
                            )
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
