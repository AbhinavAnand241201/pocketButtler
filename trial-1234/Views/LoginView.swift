import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showVoiceLogin = false
    @State private var isAnimating = false
    @State private var showPassword = false
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                Theme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.xlarge) {
                        // App Logo and Welcome
                        VStack(spacing: Theme.Spacing.medium) {
                            // Animated App Icon
                            ZStack {
                                Circle()
                                    .fill(Theme.Colors.primary.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                                    .opacity(isAnimating ? 1 : 0.8)
                                    .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Theme.Colors.primary, Theme.Colors.accent],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .padding(.top, Theme.Spacing.xxlarge)
                            .onAppear { isAnimating = true }
                            
                            Text("Welcome Back!")
                                .font(Theme.Typography.title1)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.top, Theme.Spacing.medium)
                            
                            Text("Sign in to continue")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        
                        // Form Fields
                        VStack(spacing: Theme.Spacing.large) {
                            // Email Field
                            VStack(alignment: .leading, spacing: Theme.Spacing.xsmall) {
                                Text("Email")
                                    .font(Theme.Typography.subheadline)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                        .frame(width: 20)
                                    
                                    TextField("your@email.com", text: $email)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .focused($focusedField, equals: .email)
                                        .submitLabel(.next)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                .padding(Theme.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .fill(Theme.Colors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(focusedField == .email ? Theme.Colors.primary : Color.clear, lineWidth: 1.5)
                                )
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: Theme.Spacing.xsmall) {
                                HStack {
                                    Text("Password")
                                        .font(Theme.Typography.subheadline)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showForgotPassword = true
                                    }) {
                                        Text("Forgot Password?")
                                            .font(Theme.Typography.caption2)
                                            .foregroundColor(Theme.Colors.primary)
                                            .underline()
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                        .frame(width: 20)
                                    
                                    if showPassword {
                                        TextField("••••••••", text: $password)
                                            .font(Theme.Typography.body)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .focused($focusedField, equals: .password)
                                            .submitLabel(.go)
                                            .textContentType(.password)
                                    } else {
                                        SecureField("••••••••", text: $password)
                                            .font(Theme.Typography.body)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .focused($focusedField, equals: .password)
                                            .submitLabel(.go)
                                            .textContentType(.password)
                                    }
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                    }
                                    .buttonStyle(.borderless)
                                }
                                .padding(Theme.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .fill(Theme.Colors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(focusedField == .password ? Theme.Colors.primary : Color.clear, lineWidth: 1.5)
                                )
                            }
                            
                            // Login Button
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                authViewModel.login(email: email, password: password)
                            }) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign In")
                                        .font(Theme.Typography.headline)
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(authViewModel.isLoading || email.isEmpty || password.count < 6)
                            .opacity((email.isEmpty || password.count < 6) ? 0.6 : 1.0)
                            .padding(.top, Theme.Spacing.medium)
                            .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 4)
                            
                            // Divider with "or"
                            HStack {
                                Rectangle()
                                    .fill(Theme.Colors.divider)
                                    .frame(height: 1)
                                
                                Text("or continue with")
                                    .font(Theme.Typography.footnote)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                    .padding(.horizontal, Theme.Spacing.small)
                                
                                Rectangle()
                                    .fill(Theme.Colors.divider)
                                    .frame(height: 1)
                            }
                            .padding(.vertical, Theme.Spacing.medium)
                            
                            // Social Login Buttons
                            HStack(spacing: Theme.Spacing.medium) {
                                // Face ID Button
                                Button(action: {
                                    // Face ID login logic
                                }) {
                                    HStack(spacing: Theme.Spacing.xsmall) {
                                        Image(systemName: "faceid")
                                            .font(.system(size: 20))
                                        Text("Face ID")
                                            .font(Theme.Typography.subheadline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                }
                                .buttonStyle(SecondaryButtonStyle())
                                
                                // Touch ID Button
                                Button(action: {
                                    // Touch ID login logic
                                }) {
                                    HStack(spacing: Theme.Spacing.xsmall) {
                                        Image(systemName: "touchid")
                                            .font(.system(size: 20))
                                        Text("Touch ID")
                                            .font(Theme.Typography.subheadline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                            
                            // Voice Login Button
                            Button(action: {
                                showVoiceLogin = true
                            }) {
                                HStack(spacing: Theme.Spacing.small) {
                                    Image(systemName: "mic.fill")
                                    Text("Voice Login")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .padding(.top, Theme.Spacing.small)
                            
                            // Error Message
                            if let error = authViewModel.error {
                                HStack(spacing: Theme.Spacing.xsmall) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(Theme.Colors.error)
                                    Text(error)
                                        .font(Theme.Typography.caption2)
                                        .foregroundColor(Theme.Colors.error)
                                }
                                .padding(.top, Theme.Spacing.small)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.large)
                        
                        Spacer()
                        
                        // Sign Up Prompt
                        HStack(spacing: Theme.Spacing.xsmall) {
                            Text("Don't have an account?")
                                .font(Theme.Typography.footnote)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .font(Theme.Typography.subheadline.bold())
                                    .foregroundColor(Theme.Colors.primary)
                            }
                        }
                        .padding(.bottom, Theme.Spacing.large)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Sign In")
                            .font(Theme.Typography.title3.bold())
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
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
