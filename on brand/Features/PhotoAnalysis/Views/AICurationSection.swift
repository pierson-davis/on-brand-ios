//
//  AICurationSection.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct AICurationSection: View {
    let isAnalyzing: Bool
    let aiChosen: [UIImage]
    let analysisResults: [AIImageAnalysisResponse]
    let result: VibeResult
    let onRefresh: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        EraSurfaceCard {
            VStack(alignment: .leading, spacing: 18) {
                EraSectionHeader(title: "AI curation", subtitle: caption)
                
                if isAnalyzing {
                    ProgressView("Analyzing your vibe…")
                        .tint(Color(red: 0.20, green: 0.22, blue: 0.75))
                        .padding(.top, 12)
                } else if aiChosen.isEmpty {
                    Text("Add a few photos and I'll choose the ones that match your vibe the best.")
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    aiSelectedPhotos
                }
                
                refreshButton
            }
        }
    }
    
    private var aiSelectedPhotos: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(aiChosen, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color(red: 0.20, green: 0.22, blue: 0.75).opacity(0.2), lineWidth: 2)
                        )
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var refreshButton: some View {
        Button(action: onRefresh) {
            Label("Refresh selection", systemImage: "wand.and.stars")
                .font(.subheadline.bold())
        }
        .buttonStyle(EraSecondaryButtonStyle())
        .disabled(aiChosen.isEmpty || isAnalyzing)
    }
    
    private var caption: String {
        if isAnalyzing { return "Analyzing your vibe..." }
        if aiChosen.isEmpty { return "Waiting for inspiration" }
        if !analysisResults.isEmpty {
            let avgScore = analysisResults.map(\.confidenceScore).reduce(0, +) / analysisResults.count
            return "Selected \(aiChosen.count) photos (avg. \(avgScore)% match)"
        }
        return "Chosen shots matched to \(result.primary.title.lowercased())"
    }
}
