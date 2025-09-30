//
//  LoginLoadingOverlay.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct LoginLoadingOverlay: View {
    let isLoading: Bool
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if isLoading {
                ZStack {
                    // Blur background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    // Native iOS style loading card
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primary))
                            .scaleEffect(1.1)
                        
                        Text("Signing you in...")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(themeManager.textPrimary)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(themeManager.surface)
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 40)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
    }
}
