import Foundation
import AuthenticationServices
import Combine

class AuthenticationService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    
    struct User {
        let id: String
        let email: String?
        let fullName: String?
        let provider: String
    }
    
    override init() {
        super.init()
        checkAuthenticationStatus()
    }
    
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signInWithGoogle() {
        print("Google Sign In not implemented yet")
    }
    
    func signInWithInstagram() {
        print("Instagram Sign In not implemented yet")
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        clearStoredData()
    }
    
    private func checkAuthenticationStatus() {
        if let userId = UserDefaults.standard.string(forKey: "user_id") {
            let email = UserDefaults.standard.string(forKey: "user_email")
            let fullName = UserDefaults.standard.string(forKey: "user_full_name")
            let provider = UserDefaults.standard.string(forKey: "auth_provider") ?? "apple"
            
            currentUser = User(
                id: userId,
                email: email,
                fullName: fullName,
                provider: provider
            )
            isAuthenticated = true
        }
    }
    
    func saveUserData(_ user: User) {
        UserDefaults.standard.set(user.id, forKey: "user_id")
        UserDefaults.standard.set(user.email, forKey: "user_email")
        UserDefaults.standard.set(user.fullName, forKey: "user_full_name")
        UserDefaults.standard.set(user.provider, forKey: "auth_provider")
    }
    
    private func clearStoredData() {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_full_name")
        UserDefaults.standard.removeObject(forKey: "auth_provider")
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let fullNameString: String?
            if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                fullNameString = "\(givenName) \(familyName)"
            } else {
                fullNameString = fullName?.givenName ?? fullName?.familyName
            }
            
            let user = User(
                id: userIdentifier,
                email: email,
                fullName: fullNameString,
                provider: "apple"
            )
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.saveUserData(user)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}
