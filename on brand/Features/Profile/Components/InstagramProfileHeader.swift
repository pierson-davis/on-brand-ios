//
//  InstagramProfileHeader.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct InstagramProfileHeader: View {
    let userArchetype: Archetype
    let selectedContentTab: ContentTab
    let uiImages: [UIImage]
    let analysisResults: [AIImageAnalysisResponse]
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Computed properties
    private var averageConfidenceScore: Int {
        guard !analysisResults.isEmpty else { return 0 }
        let total = analysisResults.reduce(0) { $0 + $1.confidenceScore }
        return total / analysisResults.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Profile info row - Instagram style
            HStack(spacing: 0) {
                // Profile picture
                Circle()
                    .fill(LinearGradient(
                        colors: selectedContentTab == .profile ? 
                            [userArchetype.primaryColor, userArchetype.secondaryColor] :
                            [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 86, height: 86)
                    .overlay(
                        Group {
                            if selectedContentTab == .profile {
                                Text("✨")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            } else {
                                // Blank profile picture for Instagram mode
                                Circle()
                                    .fill(themeManager.buttonBackground)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(themeManager.subtleText)
                                    )
                            }
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(themeManager.separator, lineWidth: 1)
                    )
                
                Spacer()
                
                // Stats row - Dynamic based on selected tab
                HStack(spacing: 0) {
                    if selectedContentTab == .profile {
                        // Vibe Profile stats
                        VStack(spacing: 2) {
                            Text("\(uiImages.count)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("posts")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("\(averageConfidenceScore)%")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("match")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("\(analysisResults.count)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("analyzed")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        // Instagram style stats
                        VStack(spacing: 2) {
                            Text("15")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("posts")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("944")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("followers")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 2) {
                            Text("888")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(themeManager.textPrimary)
                            Text("following")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Name and bio section
            VStack(alignment: .leading, spacing: 6) {
                Text("Pierson Davis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("NYC")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
