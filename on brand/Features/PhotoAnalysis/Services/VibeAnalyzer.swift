//
//  VibeAnalyzer.swift
//  era
//
//  Refactored to be fully dynamic based on Archetype with AI integration
//

import Foundation
import UIKit

// MARK: - Temporary Response Models (until AIPromptModels is added to project)
// Note: AIImageAnalysisResponse is now defined in AIPromptModels.swift

@MainActor
class VibeAnalyzer: ObservableObject {
    // TODO: Re-enable when AIService is added to Xcode project
    // private let aiService = AIService()
    
    /// Analyze quiz results and return the most likely archetype + optional secondary.
    static func analyzeQuizResults(_ results: [Archetype: Int]) -> VibeResult {
        // Optimized: Use max(by:) instead of full sort for better performance
        guard let primary = results.max(by: { $0.value < $1.value })?.key else {
            // Default fallback
            return VibeResult(
                primary: .mainCharacter,
                secondary: nil,
                description: Archetype.mainCharacter.analysis
            )
        }
        
        // Find secondary archetype more efficiently
        let secondary = results.filter { $0.key != primary }.max(by: { $0.value < $1.value })?.key
        
        return VibeResult(
            primary: primary,
            secondary: secondary,
            description: primary.analysis // pulled dynamically from Archetype extension
        )
    }
    
    /// Analyze a single image for vibe matching
    func analyzeImage(_ image: UIImage, for archetype: Archetype) async -> AIImageAnalysisResponse? {
        // TODO: Implement with AIService when added to project
        // For now, return a mock response with minimal delay for performance
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second delay
        
        return AIImageAnalysisResponse(
            confidenceScore: Int.random(in: 60...95),
            analysis: "Mock analysis for \(archetype.title) vibe",
            suggestions: "Mock suggestions for improvement"
        )
    }
    
    /// Select the best images from a collection based on vibe matching
    func selectBestImages(_ images: [UIImage], for archetype: Archetype, maxCount: Int = 5) async -> [UIImage] {
        // TODO: Implement with AIService when added to project
        // For now, return random selection with minimal delay
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 second delay
        return Array(images.shuffled().prefix(maxCount))
    }
    
    /// Get confidence score for a single image
    func getImageConfidence(_ image: UIImage, for archetype: Archetype) async -> Int {
        // TODO: Implement with AIService when added to project
        // For now, return random score
        return Int.random(in: 60...95)
    }
    
    /// Analyze vibe consistency across multiple images
    func analyzeVibeConsistency(_ images: [UIImage], for archetype: Archetype) async -> String? {
        // TODO: Implement with AIService when added to project
        // For now, return mock analysis
        return "Mock vibe consistency analysis for \(archetype.title)"
    }
    
    /// Generate content suggestions for the archetype
    func generateContentSuggestions(for archetype: Archetype) async -> String? {
        // TODO: Implement with AIService when added to project
        // For now, return mock suggestions
        return "Mock content suggestions for \(archetype.title) vibe"
    }
}
