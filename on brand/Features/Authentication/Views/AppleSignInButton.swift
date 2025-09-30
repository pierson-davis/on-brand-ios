//
//  AppleSignInButton.swift
//  era
//
//  Created by Pierson Davis on 9/26/25.
//

import SwiftUI
import AuthenticationServices

class ContentViewAppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    private let completion: (Result<ASAuthorization, Error>) -> Void
    
    init(completion: @escaping (Result<ASAuthorization, Error>) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        completion(.success(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }
}

struct AppleSignInButton: View {
    let onSignIn: (Result<ASAuthorization, Error>) -> Void
    let isLoading: Bool
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: onSignIn
        )
        .signInWithAppleButtonStyle(themeManager.colorScheme == .dark ? .white : .black)
        .frame(height: 50)
        .cornerRadius(12)
        .disabled(isLoading)
        .padding(.horizontal, 24)
        .id("apple-signin-\(themeManager.colorScheme)")
    }
}
