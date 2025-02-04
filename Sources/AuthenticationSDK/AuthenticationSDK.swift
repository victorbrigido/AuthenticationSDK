// The Swift Programming Language
// https://docs.swift.org/swift-book
// AuthenticationSDK
// SDK para autenticação com Firebase, Apple ID e Google

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

public protocol AuthenticationDelegate {
    func didAuthenticate(user: User?)
    func didFailWithError(_ error: Error)
}

@MainActor
public class AuthenticationManager: NSObject {
    public static let shared = AuthenticationManager()
    public var delegate: AuthenticationDelegate?
    
    private override init() {}
    
    // MARK: - Firebase Email/Password Authentication
    public func loginWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            self.delegate?.didAuthenticate(user: result?.user)
        }
    }
    
    // MARK: - Apple Sign In
    public func loginWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // MARK: - Google Sign In
    public func loginWithGoogle(presenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            guard let result = signInResult,
                  let idToken = result.user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                self.delegate?.didAuthenticate(user: authResult?.user)
            }
        }
    }
    
    // MARK: - Logout
    public func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            self.delegate?.didFailWithError(signOutError)
        }
    }
}

// MARK: - Apple Sign In Delegate
extension AuthenticationManager: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8) {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nil)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                self.delegate?.didAuthenticate(user: authResult?.user)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate?.didFailWithError(error)
    }
}
