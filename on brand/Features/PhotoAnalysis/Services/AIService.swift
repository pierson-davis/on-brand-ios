//
//  AIService.swift
//  era
//
//  Created by Pierson Davis on 9/23/25.
//

import Foundation
import UIKit

// MARK: - OpenAI API Models

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

struct OpenAIError: Decodable {
    struct ErrorDetail: Decodable {
        let message: String
        let type: String?
    }
    let error: ErrorDetail
}

// MARK: - AI Service

@MainActor
class AIService: ObservableObject {
    private let config: AIServiceConfig
    
    init(config: AIServiceConfig = .default) {
        self.config = config
    }
    
    // MARK: - Single Image Analysis
    
    func analyzeImage(_ image: UIImage, for archetype: Archetype) async throws -> AIImageAnalysisResponse {
        guard !config.apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AIServiceError.imageEncodingFailed
        }
        
        let base64Image = imageData.base64EncodedString()
        let prompt = AIPromptTemplates.singleImageAnalysisPrompt(archetype: archetype)
        
        let response = try await makeOpenAIRequest(
            messages: [
                ["role": "system", "content": prompt],
                ["role": "user", "content": [
                    ["type": "text", "text": "Analyze this image for the \(archetype.title) vibe."],
                    ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                ]]
            ]
        )
        
        guard let analysisResponse = AIImageAnalysisResponse(from: response) else {
            throw AIServiceError.invalidResponse("Could not parse analysis response")
        }
        
        return analysisResponse
    }
    
    // MARK: - Batch Image Selection
    
    func selectBestImages(_ images: [UIImage], for archetype: Archetype) async throws -> AIBatchSelectionResponse {
        guard !config.apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        guard !images.isEmpty else {
            throw AIServiceError.invalidResponse("No images provided for analysis")
        }
        
        // Convert images to base64
        let imagePayloads: [[String: Any]] = images.compactMap { image in
            guard let data = image.jpegData(compressionQuality: 0.6) else { return nil }
            let base64 = data.base64EncodedString()
            return [
                "type": "image_url",
                "image_url": ["url": "data:image/jpeg;base64,\(base64)"]
            ]
        }
        
        let prompt = AIPromptTemplates.batchImageSelectionPrompt(archetype: archetype, imageCount: images.count)
        
        let response = try await makeOpenAIRequest(
            messages: [
                ["role": "system", "content": prompt],
                ["role": "user", "content": [["type": "text", "text": "Select the best images for the \(archetype.title) vibe."]] + imagePayloads]
            ]
        )
        
        guard let selectionResponse = AIBatchSelectionResponse(from: response) else {
            throw AIServiceError.invalidResponse("Could not parse selection response")
        }
        
        return selectionResponse
    }
    
    // MARK: - Vibe Matching Analysis
    
    func analyzeVibeMatch(_ images: [UIImage], for archetype: Archetype) async throws -> String {
        guard !config.apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        let imagePayloads: [[String: Any]] = images.compactMap { image in
            guard let data = image.jpegData(compressionQuality: 0.6) else { return nil }
            let base64 = data.base64EncodedString()
            return [
                "type": "image_url",
                "image_url": ["url": "data:image/jpeg;base64,\(base64)"]
            ]
        }
        
        let prompt = AIPromptTemplates.vibeMatchingPrompt(archetype: archetype)
        
        return try await makeOpenAIRequest(
            messages: [
                ["role": "system", "content": prompt],
                ["role": "user", "content": [["type": "text", "text": "Analyze these photos for \(archetype.title) vibe consistency."]] + imagePayloads]
            ]
        )
    }
    
    // MARK: - Content Suggestions
    
    func generateContentSuggestions(for archetype: Archetype) async throws -> String {
        guard !config.apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        let prompt = AIPromptTemplates.contentSuggestionPrompt(archetype: archetype)
        
        return try await makeOpenAIRequest(
            messages: [
                ["role": "system", "content": prompt],
                ["role": "user", "content": [["type": "text", "text": "Generate content suggestions for \(archetype.title) vibe."]]]
            ]
        )
    }
    
    // MARK: - Private Methods
    
    private func makeOpenAIRequest(messages: [[String: Any]]) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [
            "model": config.model,
            "messages": messages,
            "temperature": config.temperature
        ]
        
        if let maxTokens = config.maxTokens {
            body["max_tokens"] = maxTokens
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.networkError("Invalid response type")
        }
        
        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(OpenAIError.self, from: data) {
                throw AIServiceError.networkError(errorResponse.error.message)
            } else {
                throw AIServiceError.networkError("HTTP \(httpResponse.statusCode)")
            }
        }
        
        do {
            let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            guard let content = decoded.choices.first?.message.content else {
                throw AIServiceError.invalidResponse("Empty response from OpenAI")
            }
            return content
        } catch {
            let rawResponse = String(data: data, encoding: .utf8) ?? "nil"
            throw AIServiceError.decodingError("Raw response: \(rawResponse)")
        }
    }
}

// MARK: - Convenience Extensions

extension AIService {
    /// Analyze a single image and return a simple confidence score
    func getImageConfidence(_ image: UIImage, for archetype: Archetype) async -> Int {
        do {
            let response = try await analyzeImage(image, for: archetype)
            return response.confidenceScore
        } catch {
            print("AI analysis failed: \(error.localizedDescription)")
            return 0
        }
    }
    
    /// Select the best images from a collection based on vibe matching
    func selectBestImages(from images: [UIImage], for archetype: Archetype, maxCount: Int = 5) async -> [UIImage] {
        do {
            let response = try await selectBestImages(images, for: archetype)
            let selectedImages = response.selectedIndices.compactMap { index in
                images.indices.contains(index) ? images[index] : nil
            }
            return Array(selectedImages.prefix(maxCount))
        } catch {
            print("Batch selection failed: \(error.localizedDescription)")
            // Fallback to random selection
            return Array(images.shuffled().prefix(maxCount))
        }
    }
}
