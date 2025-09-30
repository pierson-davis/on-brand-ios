//
//  ProfileHeaderSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct ProfileHeaderSection: View {
    let userArchetype: Archetype
    let selectedContentTab: ContentTab
    let uiImages: [UIImage]
    let analysisResults: [AIImageAnalysisResponse]
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var averageConfidenceScore: Int {
        guard !analysisResults.isEmpty else { return 0 }
        let total = analysisResults.map { $0.confidenceScore }.reduce(0, +)
        return total / analysisResults.count
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Profile picture - always use ZStack for consistent layout
            ZStack {
                if selectedContentTab == .hashtag {
                    // Instagram style profile picture
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                } else {
                    // Vibe profile picture
                    Circle()
                        .fill(LinearGradient(
                            colors: [userArchetype.primaryColor, userArchetype.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 90, height: 90)
                }
                
                // Only show sparkle for vibe profile
                if selectedContentTab == .profile {
                    Text("✨")
                        .font(.system(size: 36))
                }
            }
            .frame(width: 90, height: 90) // Fixed frame to prevent movement
            
            // Stats - use fixed width to prevent movement
            HStack(spacing: 40) {
                if selectedContentTab == .hashtag {
                    // Instagram style stats
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("posts")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("followers")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("0")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("following")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                } else {
                    // Vibe profile stats
                    VStack {
                        Text("\(uiImages.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("posts")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("\(averageConfidenceScore)%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("match")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                    
                    VStack {
                        Text("\(analysisResults.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("analyzed")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 50) // Fixed minimum width
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
