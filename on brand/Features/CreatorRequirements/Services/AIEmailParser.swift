//
//  AIEmailParser.swift
//  on brand
//
//  This file defines the AI email parser service for extracting deal information
//  from influencer partnership emails using OpenAI's API.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import UIKit

/// Service for parsing influencer deal emails using AI
class AIEmailParser: ObservableObject {
    
    // MARK: - Properties
    
    /// AI Configuration for secure API key management
    private let aiConfiguration = AIConfiguration.shared
    
    /// Base URL for OpenAI API
    private let baseURL = "https://api.openai.com/v1"
    
    /// Current parsing status
    @Published var isParsing = false
    
    /// Last parsing error
    @Published var lastError: String?
    
    /// Debug logging closure
    private let addDebugLog: (String) -> Void
    
    // MARK: - Initialization
    
    init(addDebugLog: @escaping (String) -> Void) {
        self.addDebugLog = addDebugLog
    }
    
    // MARK: - Public Methods
    
    /// Parse a deal email from a screenshot image
    /// - Parameter image: Screenshot of the deal email
    /// - Returns: Parsed deal information or nil if parsing failed
    func parseDealEmail(from image: UIImage) async -> ParsedDealInfo? {
        // Check if AI is configured and ready
        guard aiConfiguration.isReady() else {
            let errorMessage = "AI services not configured. Status: \(aiConfiguration.configurationStatus.displayName)"
            addDebugLog("AI Configuration Error: \(errorMessage)")
            await MainActor.run {
                isParsing = false
                lastError = errorMessage
            }
            return nil
        }
        
        // Check if API key is available
        guard let apiKey = aiConfiguration.getAPIKey() else {
            let errorMessage = "API key not available"
            addDebugLog("API Key Error: \(errorMessage)")
            await MainActor.run {
                isParsing = false
                lastError = errorMessage
            }
            return nil
        }
        
        addDebugLog("API Key found: \(String(apiKey.prefix(10)))...")
        
        await MainActor.run {
            isParsing = true
            lastError = nil
        }
        
        addDebugLog("Starting AI email parsing...")
        
        do {
            // Convert image to base64
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw AIEmailParserError.invalidImage
            }
            
            let base64Image = imageData.base64EncodedString()
            
            // Create the API request
            let request = try createVisionRequest(with: base64Image)
            
            // Make the API call
            let response = try await makeAPIRequest(request)
            
            // Parse the response
            let parsedDeal = try parseResponse(response)
            
            await MainActor.run {
                isParsing = false
            }
            
            addDebugLog("AI email parsing completed successfully")
            return parsedDeal
            
        } catch {
            await MainActor.run {
                isParsing = false
                lastError = error.localizedDescription
            }
            
            addDebugLog("AI email parsing failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    /// Create the vision API request
    private func createVisionRequest(with base64Image: String) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            throw AIEmailParserError.invalidURL
        }
        
        guard let apiKey = aiConfiguration.getAPIKey() else {
            throw AIEmailParserError.apiError(401, "API key not configured")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = VisionRequest(
            model: "gpt-4o",
            messages: [
                VisionMessage(
                    role: "user",
                    content: [
                        VisionContent(
                            type: "text",
                            text: createPrompt(),
                            imageURL: nil
                        ),
                        VisionContent(
                            type: "image_url",
                            text: nil,
                            imageURL: VisionImageURL(url: "data:image/jpeg;base64,\(base64Image)")
                        )
                    ]
                )
            ],
            maxTokens: 2000,
            temperature: 0.1
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        return request
    }
    
    /// Create the prompt for the AI
    private func createPrompt() -> String {
        return """
        Analyze this influencer partnership email and extract the following information in JSON format:
        
        {
            "title": "Deal title or campaign name",
            "description": "Brief description of the deal",
            "brand": "Brand or company name",
            "campaign": "Campaign name if mentioned",
            "dueDate": "Due date in YYYY-MM-DD format",
            "compensation": "Payment amount or compensation details",
            "requirements": {
                "contentTypes": ["instagram_post", "instagram_story", "instagram_reel", "tiktok_video", "youtube_video", "twitter_post", "facebook_post", "linkedin_post"],
                "minCount": 1,
                "specificInstructions": "Any specific content requirements"
            },
            "tagging": {
                "accountsToTag": ["@brandhandle", "@companyhandle"],
                "locationsToTag": ["Location Name"]
            },
            "hashtags": {
                "requiredHashtags": ["#brand", "#campaign"],
                "optionalHashtags": ["#influencer", "#partnership"]
            },
            "links": {
                "url": "https://brand.com/campaign",
                "callToAction": "Visit our website",
                "placement": "bio_link"
            },
            "assets": {
                "assetType": "image_assets",
                "quantity": 1,
                "deliveryMethod": "email",
                "resolution": "high_resolution"
            }
        }
        
        Only return the JSON, no additional text. If information is not available, use null or empty arrays/strings.
        """
    }
    
    /// Make the API request
    private func makeAPIRequest(_ request: URLRequest) async throws -> VisionResponse {
        addDebugLog("Making API request to: \(request.url?.absoluteString ?? "unknown")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            addDebugLog("Invalid response type")
            throw AIEmailParserError.invalidResponse
        }
        
        addDebugLog("API Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            addDebugLog("API Error \(httpResponse.statusCode): \(errorMessage)")
            throw AIEmailParserError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        addDebugLog("API Response received, parsing JSON...")
        let visionResponse = try JSONDecoder().decode(VisionResponse.self, from: data)
        addDebugLog("JSON parsing successful")
        return visionResponse
    }
    
    /// Parse the API response into deal information
    private func parseResponse(_ response: VisionResponse) throws -> ParsedDealInfo {
        guard let content = response.choices.first?.message.content else {
            addDebugLog("Empty response from API")
            throw AIEmailParserError.emptyResponse
        }
        
        addDebugLog("Raw API response: \(content)")
        
        // Clean the response (remove markdown formatting if present)
        let cleanContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        addDebugLog("Cleaned response: \(cleanContent)")
        
        guard let data = cleanContent.data(using: .utf8) else {
            addDebugLog("Failed to convert response to data")
            throw AIEmailParserError.invalidResponseData
        }
        
        do {
            let parsedData = try JSONDecoder().decode(ParsedDealData.self, from: data)
            addDebugLog("Successfully parsed deal data")
            return ParsedDealInfo(from: parsedData)
        } catch {
            addDebugLog("JSON parsing failed: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Data Models

/// Parsed deal information from AI
struct ParsedDealInfo {
    let title: String
    let description: String
    let brand: String
    let campaign: String?
    let dueDate: Date?
    let compensation: String?
    let requirements: ContentRequirements?
    let tagging: TaggingRequirements?
    let hashtags: HashtagRequirements?
    let links: LinkRequirements?
    let assets: AssetRequirements?
    
    fileprivate init(from data: ParsedDealData) {
        self.title = data.title ?? "Untitled Deal"
        self.description = data.description ?? ""
        self.brand = data.brand ?? ""
        self.campaign = data.campaign
        self.dueDate = data.parsedDueDate
        self.compensation = data.compensation
        
        // Parse requirements - simplified for now
        self.requirements = nil
        
        // Parse tagging
        if let tagData = data.tagging {
            self.tagging = TaggingRequirements(
                accountsToTag: tagData.accountsToTag ?? [],
                locationsToTag: tagData.locationsToTag ?? [],
                placementRules: nil,
                formatRequirements: nil,
                verificationSettings: nil,
                trackingSettings: nil
            )
        } else {
            self.tagging = nil
        }
        
        // Parse hashtags
        if let hashData = data.hashtags {
            self.hashtags = HashtagRequirements(
                requiredHashtags: hashData.requiredHashtags ?? [],
                optionalHashtags: hashData.optionalHashtags ?? [],
                placementRules: nil,
                formatRequirements: nil,
                trackingSettings: nil
            )
        } else {
            self.hashtags = nil
        }
        
        // Parse links
        if let linkData = data.links {
            self.links = LinkRequirements(
                url: linkData.url ?? "",
                callToAction: linkData.callToAction,
                placement: nil,
                trackingSettings: nil
            )
        } else {
            self.links = nil
        }
        
        // Parse assets
        if let assetData = data.assets {
            self.assets = AssetRequirements(
                assetType: .photo,
                quantity: assetData.quantity ?? 1,
                deliveryMethod: .email,
                resolution: AssetResolution(width: 1080, height: 1080, minWidth: nil, minHeight: nil, maxWidth: nil, maxHeight: nil),
                format: nil,
                trackingSettings: nil
            )
        } else {
            self.assets = nil
        }
    }
}

/// Raw parsed data from AI response
private struct ParsedDealData: Codable {
    let title: String?
    let description: String?
    let brand: String?
    let campaign: String?
    let dueDateString: String?
    let compensation: String?
    let requirements: RequirementsData?
    let tagging: TaggingData?
    let hashtags: HashtagsData?
    let links: LinksData?
    let assets: AssetsData?
    
    var parsedDueDate: Date? {
        guard let dateString = dueDateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}

private struct RequirementsData: Codable {
    let contentTypes: [String]?
    let minCount: Int?
    let specificInstructions: String?
}

private struct TaggingData: Codable {
    let accountsToTag: [String]?
    let locationsToTag: [String]?
}

private struct HashtagsData: Codable {
    let requiredHashtags: [String]?
    let optionalHashtags: [String]?
}

private struct LinksData: Codable {
    let url: String?
    let callToAction: String?
    let placement: String?
}

private struct AssetsData: Codable {
    let assetType: String?
    let quantity: Int?
    let deliveryMethod: String?
    let resolution: String?
}

// MARK: - API Request Models

private struct VisionRequest: Codable {
    let model: String
    let messages: [VisionMessage]
    let maxTokens: Int
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

private struct VisionMessage: Codable {
    let role: String
    let content: [VisionContent]
}

private struct VisionContent: Codable {
    let type: String
    let text: String?
    let imageURL: VisionImageURL?
    
    enum CodingKeys: String, CodingKey {
        case type, text
        case imageURL = "image_url"
    }
}

private struct VisionImageURL: Codable {
    let url: String
}

private struct VisionResponse: Codable {
    let choices: [VisionChoice]
}

private struct VisionChoice: Codable {
    let message: VisionMessageResponse
}

private struct VisionMessageResponse: Codable {
    let content: String
}

// MARK: - Errors

enum AIEmailParserError: LocalizedError {
    case invalidImage
    case invalidURL
    case invalidResponse
    case emptyResponse
    case invalidResponseData
    case apiError(Int, String)
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image provided"
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid API response"
        case .emptyResponse:
            return "Empty response from API"
        case .invalidResponseData:
            return "Invalid response data format"
        case .apiError(let code, let message):
            return "API Error \(code): \(message)"
        }
    }
}
