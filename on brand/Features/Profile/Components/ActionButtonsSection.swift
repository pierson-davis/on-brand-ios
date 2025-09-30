//
//  ActionButtonsSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct ActionButtonsSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 8) {
            // Left button - Vibe Profile
            Button(action: {
                // TODO: Navigate to vibe profile
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "number")
                        .font(.system(size: 14, weight: .medium))
                    Text("Your Vibe Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(8)
            }
            
            // Right button - Instagram
            Button(action: {
                // TODO: Open Instagram profile
                if let url = URL(string: "https://instagram.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 14, weight: .medium))
                    Text("Instagram")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.0, blue: 0.8),
                            Color(red: 0.8, green: 0.2, blue: 0.4),
                            Color(red: 1.0, green: 0.6, blue: 0.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
