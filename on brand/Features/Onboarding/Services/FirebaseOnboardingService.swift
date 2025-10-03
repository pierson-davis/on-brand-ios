import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Combine

// MARK: - Firebase Onboarding Service
// This service manages onboarding data storage and retrieval in Firebase
class FirebaseOnboardingService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var onboardingData: FirebaseOnboardingData?
    @Published var isLoading = false
    @Published var error: String?
    @Published var isConnected = false
    
    // MARK: - Private Properties
    
    private let firestore: Firestore?
    private var onboardingListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Collection Path
    
    private var collectionPath: String {
        "users/{userId}/onboarding"
    }
    
    // MARK: - Initialization
    
    init() {
        if FirebaseApp.app() != nil {
            self.firestore = Firestore.firestore()
            isConnected = true
            
            // Listen for auth state changes
            Auth.auth().addStateDidChangeListener { [weak self] _, user in
                if let user = user {
                    self?.startListening(for: user.uid)
                } else {
                    self?.stopListening()
                }
            }
        } else {
            self.firestore = nil
            print("⚠️ Firebase not configured, onboarding service disabled")
        }
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Public Methods
    
    /// Saves onboarding data to Firebase
    func saveOnboardingData(_ data: FirebaseOnboardingData) {
        guard let firestore = firestore,
              let userId = Auth.auth().currentUser?.uid else {
            print("❌ Cannot save onboarding data: Firebase not available or user not authenticated")
            return
        }
        
        isLoading = true
        error = nil
        
        let documentPath = "users/\(userId)/onboarding/data"
        let documentRef = firestore.document(documentPath)
        
        documentRef.setData(data.toDictionary()) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = "Failed to save onboarding data: \(error.localizedDescription)"
                    print("❌ Error saving onboarding data: \(error)")
                } else {
                    self?.error = nil
                    print("✅ Onboarding data saved successfully")
                }
            }
        }
    }
    
    /// Loads onboarding data from Firebase
    func loadOnboardingData() {
        guard let firestore = firestore,
              let userId = Auth.auth().currentUser?.uid else {
            print("❌ Cannot load onboarding data: Firebase not available or user not authenticated")
            return
        }
        
        isLoading = true
        error = nil
        
        let documentPath = "users/\(userId)/onboarding/data"
        let documentRef = firestore.document(documentPath)
        
        documentRef.getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = "Failed to load onboarding data: \(error.localizedDescription)"
                    print("❌ Error loading onboarding data: \(error)")
                    self?.onboardingData = nil
                } else if let document = document, document.exists {
                    if let data = FirebaseOnboardingData.from(document: document) {
                        self?.onboardingData = data
                        self?.error = nil
                        print("✅ Onboarding data loaded successfully")
                    } else {
                        self?.error = "Failed to parse onboarding data"
                        self?.onboardingData = nil
                    }
                } else {
                    // Document doesn't exist - user hasn't completed onboarding
                    self?.onboardingData = nil
                    self?.error = nil
                    print("ℹ️ No onboarding data found - user hasn't completed onboarding")
                }
            }
        }
    }
    
    /// Checks if user has completed onboarding
    func hasCompletedOnboarding() -> Bool {
        return onboardingData != nil
    }
    
    /// Deletes onboarding data (for testing or reset)
    func deleteOnboardingData() {
        guard let firestore = firestore,
              let userId = Auth.auth().currentUser?.uid else {
            print("❌ Cannot delete onboarding data: Firebase not available or user not authenticated")
            return
        }
        
        isLoading = true
        error = nil
        
        let documentPath = "users/\(userId)/onboarding/data"
        let documentRef = firestore.document(documentPath)
        
        documentRef.delete { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = "Failed to delete onboarding data: \(error.localizedDescription)"
                    print("❌ Error deleting onboarding data: \(error)")
                } else {
                    self?.onboardingData = nil
                    self?.error = nil
                    print("✅ Onboarding data deleted successfully")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Starts listening for real-time updates to onboarding data
    private func startListening(for userId: String) {
        guard let firestore = firestore else { return }
        
        stopListening() // Stop any existing listener
        
        let documentPath = "users/\(userId)/onboarding/data"
        let documentRef = firestore.document(documentPath)
        
        onboardingListener = documentRef.addSnapshotListener { [weak self] document, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = "Real-time update error: \(error.localizedDescription)"
                    print("❌ Real-time onboarding data error: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    if let data = FirebaseOnboardingData.from(document: document) {
                        self?.onboardingData = data
                        self?.error = nil
                        print("🔄 Onboarding data updated in real-time")
                    } else {
                        self?.error = "Failed to parse real-time onboarding data"
                        self?.onboardingData = nil
                    }
                } else {
                    // Document doesn't exist
                    self?.onboardingData = nil
                    self?.error = nil
                }
            }
        }
    }
    
    /// Stops listening for real-time updates
    private func stopListening() {
        onboardingListener?.remove()
        onboardingListener = nil
        onboardingData = nil
    }
}

// MARK: - Convenience Extensions

extension FirebaseOnboardingService {
    
    /// Creates onboarding data from OnboardingViewModel
    func createOnboardingData(from viewModel: OnboardingViewModel, userId: String) -> FirebaseOnboardingData {
        let vibeResult = viewModel.makeVibeResult()
        
        // Convert answers from [QuizQuestion.ID: Int] to [String: String]
        let answersDict = viewModel.answers.reduce(into: [String: String]()) { dict, pair in
            dict[pair.key] = String(pair.value)
        }
        
        return FirebaseOnboardingData.from(
            userId: userId,
            userName: viewModel.userName,
            selectedGender: viewModel.selectedGender,
            answers: answersDict,
            primaryArchetype: vibeResult.primary,
            secondaryArchetype: vibeResult.secondary,
            vibeResultDescription: vibeResult.description
        )
    }
    
    /// Gets the user's archetype results
    func getArchetypeResults() -> (primary: Archetype?, secondary: Archetype?) {
        guard let data = onboardingData else { return (nil, nil) }
        
        let primary = Archetype.allCases.first(where: { $0.id == data.primaryArchetype })
        let secondary = data.secondaryArchetype.flatMap { archetypeId in
            Archetype.allCases.first(where: { $0.id == archetypeId })
        }
        
        return (primary, secondary)
    }
    
    /// Gets the user's quiz answers
    func getQuizAnswers() -> [String: String] {
        return onboardingData?.answers ?? [:]
    }
}
