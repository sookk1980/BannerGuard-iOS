import SwiftUI
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var errorMessage: String?
    
    init() {
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            checkAdminStatus(user.uid)
        }
    }
    
    private func checkAdminStatus(_ uid: String) {
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, _ in
            if let data = snapshot?.data(), let isAdmin = data["isAdmin"] as? Bool {
                self?.isAdmin = isAdmin
            }
        }
    }
    
    /* signIn, signUp, SSO methods... */
    func signOut() {
        try? Auth.auth().signOut()
        isAuthenticated = false
        isAdmin = false
    }
}