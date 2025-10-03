//
//  FirebaseDealService.swift
//  on brand
//
//  Firebase service for managing influencer deals
//  with real-time synchronization and cloud storage.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Combine

/// Service for managing deals with Firebase backend
class FirebaseDealService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var deals: [CreatorRequirement] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var isConnected = false
    
    // MARK: - Private Properties
    
    private var firestore: Firestore?
    private var storage: Storage?
    private var dealsListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        // Only initialize Firebase services if Firebase is configured
        if FirebaseApp.app() != nil {
            self.firestore = Firestore.firestore()
            self.storage = Storage.storage()
            isConnected = true
            
            // Monitor authentication state
            Auth.auth().addStateDidChangeListener { [weak self] _, user in
                if let user = user {
                    self?.startListening(for: user.uid)
                } else {
                    self?.stopListening()
                }
            }
            
            print("✅ FirebaseDealService initialized successfully")
        } else {
            self.firestore = nil
            self.storage = nil
            print("⚠️ Firebase not configured, deal service disabled")
        }
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Public Methods
    
    /// Add a new deal to Firebase
    func addDeal(_ deal: CreatorRequirement) {
        guard let firestore = firestore else {
            error = "Firebase not configured"
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        let firebaseDeal = FirebaseDeal.from(deal, userId: user.uid)
        
        firestore.collection("users")
            .document(user.uid)
            .collection("deals")
            .document(firebaseDeal.id)
            .setData(firebaseDeal.toDictionary()) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.error = "Failed to save deal: \(error.localizedDescription)"
                    } else {
                        print("✅ Deal saved successfully")
                    }
                }
            }
    }
    
    /// Update an existing deal
    func updateDeal(_ deal: CreatorRequirement) {
        guard let firestore = firestore else {
            error = "Firebase not configured"
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        let firebaseDeal = FirebaseDeal.from(deal, userId: user.uid)
        
        firestore.collection("users")
            .document(user.uid)
            .collection("deals")
            .document(firebaseDeal.id)
            .updateData(firebaseDeal.toDictionary()) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.error = "Failed to update deal: \(error.localizedDescription)"
                    } else {
                        print("✅ Deal updated successfully")
                    }
                }
            }
    }
    
    /// Delete a deal
    func deleteDeal(_ dealId: String) {
        guard let firestore = firestore else {
            error = "Firebase not configured"
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        firestore.collection("users")
            .document(user.uid)
            .collection("deals")
            .document(dealId)
            .delete() { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.error = "Failed to delete deal: \(error.localizedDescription)"
                    } else {
                        print("✅ Deal deleted successfully")
                    }
                }
            }
    }
    
    /// Upload image for a deal
    func uploadImage(_ imageData: Data, for dealId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(NSError(domain: "FirebaseDisabled", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])))
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let imageName = "\(dealId)_\(UUID().uuidString).jpg"
        let imageRef = storage.reference().child("users/\(user.uid)/deals/\(dealId)/images/\(imageName)")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    
    /// Download image for a deal
    func downloadImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(NSError(domain: "FirebaseDisabled", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase not configured"])))
            return
        }
        
        let imageRef = storage.reference(forURL: url)
        
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
    }
    
    /// Delete multiple deals
    func deleteDeals(_ dealIds: [String]) {
        guard let firestore = firestore else {
            error = "Firebase not configured"
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            error = "User not authenticated"
            return
        }
        
        isLoading = true
        error = nil
        
        let batch = firestore.batch()
        let dealsRef = firestore.collection("users").document(user.uid).collection("deals")
        
        for dealId in dealIds {
            batch.deleteDocument(dealsRef.document(dealId))
        }
        
        batch.commit { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.error = "Failed to delete deals: \(error.localizedDescription)"
                } else {
                    print("✅ \(dealIds.count) deals deleted successfully")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func startListening(for userId: String) {
        guard let firestore = firestore else { return }
        
        dealsListener = firestore.collection("users")
            .document(userId)
            .collection("deals")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.error = "Failed to load deals: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.deals = documents.compactMap { document in
                        do {
                            let firebaseDeal = try document.data(as: FirebaseDeal.self)
                            return firebaseDeal.toCreatorRequirement()
                        } catch {
                            print("❌ Failed to decode deal: \(error)")
                            return nil
                        }
                    }
                    
                    print("📊 Loaded \(self?.deals.count ?? 0) deals from Firebase")
                }
            }
    }
    
    private func stopListening() {
        dealsListener?.remove()
        dealsListener = nil
    }
}