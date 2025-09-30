//
//  InstagramPhotoGrid.swift
//  era
//
//  Created by Pierson Davis on 9/22/25.
//

import SwiftUI

struct InstagramPhotoGrid: View {
    let uiImages: [UIImage]
    let isAnalyzing: Bool
    let analysisResults: [AIImageAnalysisResponse]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
            if uiImages.isEmpty {
                // Show placeholder grid
                ForEach(0..<9) { index in
                    Rectangle()
                        .fill(themeManager.buttonBackground)
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(themeManager.subtleText)
                        )
                }
            } else {
                // Show actual photos
                ForEach(Array(uiImages.enumerated()), id: \.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .overlay(
                            // Loading indicator for analyzing photos
                            Group {
                                if isAnalyzing && index < analysisResults.count {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                            }
                        )
                }
            }
        }
        .background(themeManager.backgroundTop)
    }
}
