//
//  AIPromptModels.swift
//  era
//
//  Created by Pierson Davis on 9/23/25.
//

import Foundation

// MARK: - AI Service Configuration

struct AIServiceConfig {
    let apiKey: String
    let model: String
    let temperature: Double
    let maxTokens: Int?
    
    static let `default` = AIServiceConfig(
        apiKey: ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "",
        model: "gpt-4o-mini",
        temperature: 0.7,
        maxTokens: nil
    )
}

// MARK: - Prompt Templates

struct AIPromptTemplates {
    
    // MARK: - Single Image Analysis
    
    static func singleImageAnalysisPrompt(archetype: Archetype) -> String {
        return """
        You are a fun vibe analyst specializing in social media aesthetics. 
        
        Analyze this image and determine if it matches the "\(archetype.title)" vibe archetype.
        
        Vibe Description: \(archetype.blurb)
        
        Consider these elements:
        - Color palette and mood
        - Composition and framing
        - Lighting and atmosphere
        - Overall aesthetic energy
        - Social media appeal
        
        Respond with:
        1. A confidence score (0-100) for how well this image matches the \(archetype.title) vibe
        2. A brief explanation (1-2 sentences) of why it does or doesn't match
        3. Any suggestions for improvement if the score is below 70
        
        Format your response as:
        Score: [number]
        Analysis: [explanation]
        """
    }
    
    // MARK: - Batch Image Selection
    
    static func batchImageSelectionPrompt(archetype: Archetype, imageCount: Int) -> String {
        return """
        You are a professional vibe curator for social media content.
        
        I'm showing you \(imageCount) photos. Select the 3-5 BEST ones that match the "\(archetype.title)" vibe.
        
        Vibe Description: \(archetype.blurb)
        
        Selection Criteria:
        - Strong visual appeal and composition
        - Matches the \(archetype.title) aesthetic
        - High social media engagement potential
        - Cohesive with the overall vibe
        - Professional quality
        
        Respond with:
        1. A list of the selected image numbers (e.g., "Selected: 1, 3, 5, 7")
        2. A brief explanation for each selection
        3. Overall vibe assessment
        
        Format your response as:
        Selected: [image numbers]
        Selections: [brief explanations]
        Overall: [vibe assessment]
        """
    }
    
    // MARK: - Vibe Matching
    
    static func vibeMatchingPrompt(archetype: Archetype) -> String {
        return """
        You are an expert in social media aesthetics and personal branding.
        
        Analyze these photos to determine how well they match the "\(archetype.title)" vibe.
        
        Vibe Profile:
        - Title: \(archetype.title)
        - Description: \(archetype.blurb)
        - Color Palette: \(archetype.tint.description)
        
        Evaluate each photo for:
        - Visual consistency with the vibe
        - Color harmony
        - Composition quality
        - Mood and atmosphere
        - Social media appeal
        
        Provide a detailed analysis and ranking.
        """
    }
    
    // MARK: - Content Suggestions
    
    static func contentSuggestionPrompt(archetype: Archetype) -> String {
        return """
        You are a creative social media strategist.
        
        Based on the "\(archetype.title)" vibe, suggest:
        
        1. Caption ideas that match this aesthetic
        2. Hashtag recommendations
        3. Posting schedule suggestions
        4. Content themes to explore
        
        Vibe: \(archetype.title)
        Description: \(archetype.blurb)
        
        Keep suggestions authentic, engaging, and true to the \(archetype.title) personality.
        """
    }
}

// MARK: - Response Models

struct AIImageAnalysisResponse: Codable {
    let confidenceScore: Int
    let analysis: String
    let suggestions: String?
    
    init(confidenceScore: Int, analysis: String, suggestions: String? = nil) {
        self.confidenceScore = confidenceScore
        self.analysis = analysis
        self.suggestions = suggestions
    }
    
    init?(from response: String) {
        let lines = response.components(separatedBy: .newlines)
        
        var score: Int?
        var analysis: String?
        var suggestions: String?
        
        for line in lines {
            if line.hasPrefix("Score:") {
                let scoreString = line.replacingOccurrences(of: "Score:", with: "").trimmingCharacters(in: .whitespaces)
                score = Int(scoreString)
            } else if line.hasPrefix("Analysis:") {
                analysis = line.replacingOccurrences(of: "Analysis:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("Suggestions:") {
                suggestions = line.replacingOccurrences(of: "Suggestions:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        
        guard let confidenceScore = score, let analysis = analysis else { return nil }
        
        self.confidenceScore = confidenceScore
        self.analysis = analysis
        self.suggestions = suggestions
    }
}

struct AIBatchSelectionResponse {
    let selectedIndices: [Int]
    let explanations: [String]
    let overallAssessment: String
    
    init?(from response: String) {
        let lines = response.components(separatedBy: .newlines)
        
        var selectedIndices: [Int] = []
        var explanations: [String] = []
        var overallAssessment: String?
        
        for line in lines {
            if line.hasPrefix("Selected:") {
                let indicesString = line.replacingOccurrences(of: "Selected:", with: "").trimmingCharacters(in: .whitespaces)
                selectedIndices = indicesString.components(separatedBy: ",")
                    .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            } else if line.hasPrefix("Selections:") {
                let explanationsString = line.replacingOccurrences(of: "Selections:", with: "").trimmingCharacters(in: .whitespaces)
                explanations = explanationsString.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
            } else if line.hasPrefix("Overall:") {
                overallAssessment = line.replacingOccurrences(of: "Overall:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        
        guard !selectedIndices.isEmpty else { return nil }
        
        self.selectedIndices = selectedIndices
        self.explanations = explanations
        self.overallAssessment = overallAssessment ?? "Analysis complete"
    }
}

// MARK: - Error Types

enum AIServiceError: LocalizedError {
    case missingAPIKey
    case imageEncodingFailed
    case networkError(String)
    case decodingError(String)
    case invalidResponse(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key not found. Please set OPENAI_API_KEY environment variable."
        case .imageEncodingFailed:
            return "Failed to encode image for analysis."
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .invalidResponse(let message):
            return "Invalid response format: \(message)"
        }
    }
}
