import SwiftUI

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        if authVM.isAuthenticated {
            MainTabView()
        } else {
            AuthView()
        }
    }
}