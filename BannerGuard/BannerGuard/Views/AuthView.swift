import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isLogin = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "flag.slash.circle.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(.blue)
                    
                    Text("BannerGuard")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                }
                
                VStack(spacing: 20) {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(isLogin ? "Sign In" : "Sign Up") {
                        if isLogin {
                            viewModel.signIn()
                        } else {
                            viewModel.signUp()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
                    
                    if let error = viewModel.errorMessage {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }
                .padding(.horizontal, 32)
                
                Button(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In") {
                    isLogin.toggle()
                }
                
                Divider()
                    .padding(.horizontal, 40)
                
                VStack(spacing: 12) {
                    Button(action: viewModel.signInWithGoogle) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .foregroundStyle(.red)
                            Text("Continue with Google")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in },
                        onCompletion: { result in
                            viewModel.handleAppleSignIn(result)
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}