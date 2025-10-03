//
//  FirebaseAuthService.swift
//  on brand
//
//  This file provides Firebase Authentication integration
//  with Apple Sign-In for seamless user management.
//
//  Created by Pierson Davis on January 2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import AuthenticationServices
import Combine

/// Firebase Authentication service with Apple Sign-In integration
class FirebaseAuthService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isAuthenticated = false
    @Published var currentUser: FirebaseUser?
    @Published var isLoading = false
    @Published var error: String?
    
    // MARK: - Private Properties
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        // Only setup auth listener if Firebase is available
        if FirebaseApp.app() != nil {
            setupAuthStateListener()
        } else {
            print("⚠️ Firebase not configured, auth service disabled")
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Public Methods
    
    /// Sign in with Apple ID
    func signInWithApple() {
        isLoading = true
        error = nil
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// Sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
            error = nil
        } catch {
            self.error = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    /// Delete the current user account
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            error = "No user to delete"
            return
        }
        
        isLoading = true
        error = nil
        
        user.delete { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.error = "Failed to delete account: \(error.localizedDescription)"
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    /// Get the current user's UID
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// Check if user is authenticated
    var isUserAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Private Methods
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.currentUser = FirebaseUser(from: user)
                    self?.isAuthenticated = true
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
                self?.isLoading = false
            }
        }
    }
    
    func handleAppleSignInResult(_ credential: ASAuthorizationAppleIDCredential) {
        guard let nonce = generateNonce() else {
            error = "Failed to generate nonce"
            isLoading = false
            return
        }
        
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            error = "Failed to get Apple ID token"
            isLoading = false
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: firebaseCredential) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = "Apple Sign-In failed: \(error.localizedDescription)"
                    return
                }
                
                // Update user profile with Apple ID information
                if let user = result?.user {
                    self?.updateUserProfile(with: credential, user: user)
                }
            }
        }
    }
    
    private func updateUserProfile(with credential: ASAuthorizationAppleIDCredential, user: User) {
        let changeRequest = user.createProfileChangeRequest()
        
        if let fullName = credential.fullName {
            let displayName = [fullName.givenName, fullName.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            
            if !displayName.isEmpty {
                changeRequest.displayName = displayName
            }
        }
        
        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                self?.error = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }
    
    private func generateNonce() -> String? {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = 32
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    return 0
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension FirebaseAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleSignInResult(appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.error = "Apple Sign-In failed: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension FirebaseAuthService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}

// MARK: - FirebaseUser Model

struct FirebaseUser: Identifiable, Codable {
    let id: String
    let email: String?
    let displayName: String?
    let photoURL: String?
    let isEmailVerified: Bool
    let creationDate: Date
    let lastSignInDate: Date?
    
    init(from user: User) {
        self.id = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
        self.isEmailVerified = user.isEmailVerified
        self.creationDate = user.metadata.creationDate ?? Date()
        self.lastSignInDate = user.metadata.lastSignInDate
    }
}

// MARK: - Error Types

enum FirebaseAuthError: LocalizedError {
    case notAuthenticated
    case signInFailed
    case signOutFailed
    case deleteAccountFailed
    case profileUpdateFailed
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User not authenticated"
        case .signInFailed:
            return "Sign in failed"
        case .signOutFailed:
            return "Sign out failed"
        case .deleteAccountFailed:
            return "Failed to delete account"
        case .profileUpdateFailed:
            return "Failed to update profile"
        case .networkError:
            return "Network error occurred"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
