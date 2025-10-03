import Foundation
import FirebaseFirestore

// MARK: - Firebase Onboarding Data Model
// This model stores onboarding quiz answers and archetype results in Firebase
struct FirebaseOnboardingData: Codable, Identifiable {
    let id: String // Firebase document ID
    let userId: String // Firebase user ID
    let userName: String
    let selectedGender: String?
    let answers: [String: String] // Question ID -> Answer mapping
    let primaryArchetype: String
    let secondaryArchetype: String?
    let vibeResultDescription: String
    let completedAt: Date
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Initialization
    
    init(
        userId: String,
        userName: String,
        selectedGender: String?,
        answers: [String: String],
        primaryArchetype: String,
        secondaryArchetype: String?,
        vibeResultDescription: String
    ) {
        self.id = UUID().uuidString
        self.userId = userId
        self.userName = userName
        self.selectedGender = selectedGender
        self.answers = answers
        self.primaryArchetype = primaryArchetype
        self.secondaryArchetype = secondaryArchetype
        self.vibeResultDescription = vibeResultDescription
        self.completedAt = Date()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // MARK: - Conversion Methods
    
    /// Converts from OnboardingViewModel data
    static func from(
        userId: String,
        userName: String,
        selectedGender: Gender?,
        answers: [String: String],
        primaryArchetype: Archetype,
        secondaryArchetype: Archetype?,
        vibeResultDescription: String
    ) -> FirebaseOnboardingData {
        return FirebaseOnboardingData(
            userId: userId,
            userName: userName,
            selectedGender: selectedGender?.rawValue,
            answers: answers,
            primaryArchetype: primaryArchetype.id,
            secondaryArchetype: secondaryArchetype?.id,
            vibeResultDescription: vibeResultDescription
        )
    }
    
    /// Converts to VibeResult for app usage
    func toVibeResult() -> VibeResult? {
        guard let primary = Archetype.allCases.first(where: { $0.id == primaryArchetype }) else {
            return nil
        }
        
        let secondary = secondaryArchetype.flatMap { archetypeId in
            Archetype.allCases.first(where: { $0.id == archetypeId })
        }
        
        return VibeResult(
            primary: primary,
            secondary: secondary,
            description: vibeResultDescription
        )
    }
    
    /// Converts to UserProfile for app usage
    func toUserProfile() -> UserProfile? {
        guard let vibeResult = toVibeResult() else { return nil }
        
        return UserProfile.from(
            vibeResult: vibeResult,
            userId: userId,
            name: userName
        )
    }
}

// MARK: - Firebase Timestamp Support
extension FirebaseOnboardingData {
    /// Converts to Firestore-compatible dictionary
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        
        // Convert Date objects to Firestore Timestamps
        var firestoreDict = dictionary
        firestoreDict["completedAt"] = Timestamp(date: completedAt)
        firestoreDict["createdAt"] = Timestamp(date: createdAt)
        firestoreDict["updatedAt"] = Timestamp(date: updatedAt)
        
        return firestoreDict
    }
    
    /// Creates from Firestore document
    static func from(document: DocumentSnapshot) -> FirebaseOnboardingData? {
        guard let data = document.data() else { return nil }
        
        // Convert Firestore Timestamps back to Date objects
        var jsonData = data
        if let completedAt = data["completedAt"] as? Timestamp {
            jsonData["completedAt"] = completedAt.dateValue()
        }
        if let createdAt = data["createdAt"] as? Timestamp {
            jsonData["createdAt"] = createdAt.dateValue()
        }
        if let updatedAt = data["updatedAt"] as? Timestamp {
            jsonData["updatedAt"] = updatedAt.dateValue()
        }
        
        guard let json = try? JSONSerialization.data(withJSONObject: jsonData),
              let onboardingData = try? JSONDecoder().decode(FirebaseOnboardingData.self, from: json) else {
            return nil
        }
        
        return onboardingData
    }
}

// MARK: - Sample Data for Testing
extension FirebaseOnboardingData {
    static let sampleData = FirebaseOnboardingData(
        userId: "sample-user-id",
        userName: "Sample User",
        selectedGender: "female",
        answers: [
            "question_1": "answer_a",
            "question_2": "answer_b",
            "question_3": "answer_c"
        ],
        primaryArchetype: "minimalist",
        secondaryArchetype: "bohemian",
        vibeResultDescription: "A minimalist with bohemian influences"
    )
}
