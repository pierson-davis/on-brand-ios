//
//  AnalysisCard.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI

struct AnalysisCard: View {
    let result: AIImageAnalysisResponse
    let index: Int
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Photo \(index + 1)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                confidenceBadge(result.confidenceScore)
            }
            
            Text(result.analysis)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let suggestions = result.suggestions {
                Text("💡 \(suggestions)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal, 16)
    }
    
    private func confidenceBadge(_ score: Int) -> some View {
        Text("\(score)%")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(scoreColor(score).opacity(0.9))
            )
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 60...79: return .orange
        default: return .red
        }
    }
}
