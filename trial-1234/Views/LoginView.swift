import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showVoiceLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Email field
                    TextField("Email", text: $email)
                        .standardTextFieldStyle()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Password field
                    SecureField("Password", text: $password)
                        .standardTextFieldStyle()
                    
                    // Forgot password link
                    HStack {
                        Spacer()
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: Constants.FontSizes.caption))
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    
                    // Login button
                    Button(action: {
                        authViewModel.login(email: email, password: password)
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(authViewModel.isLoading)
                    .opacity(authViewModel.isLoading ? 0.7 : 1)
                    
                    // Alternative login options
                    VStack(spacing: Constants.Dimensions.standardPadding) {
                        Text("Or login with")
                            .font(.system(size: Constants.FontSizes.caption))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            // Face ID button
                            Button(action: {
                                // Face ID login logic would go here
                            }) {
                                Text("FACE ID")
                                    .frame(maxWidth: .infinity)
                            }
                            .secondaryButtonStyle()
                            
                            // Touch ID button
                            Button(action: {
                                // Touch ID login logic would go here
                            }) {
                                Text("TOUCH ID")
                                    .frame(maxWidth: .infinity)
                            }
                            .secondaryButtonStyle()
                        }
                        
                        // Voice login button
                        Button(action: {
                            showVoiceLogin = true
                        }) {
                            HStack {
                                Image(systemName: "mic.fill")
                                Text("Voice Login")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .secondaryButtonStyle()
                    }
                    
                    // Error message
                    if let error = authViewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: Constants.FontSizes.caption))
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .sheet(isPresented: $showVoiceLogin) {
                VoiceLoginView()
            }
        }
    }
}

#Preview {
    LoginView()
}
