import SwiftUI

// MARK: - Field Enum for text field focus management
enum LoginField: Hashable {
    case email, password
}

// MARK: - Login View
struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showVoiceLogin = false
    @State private var isAnimating = false
    @State private var showPassword = false
    @FocusState private var focusedField: LoginField?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.BackgroundView()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.xlarge) {
                        // Header with logo and welcome
                        HeaderView(isAnimating: $isAnimating)
                        
                        // Form Fields
                        LoginFormView(
                            email: $email,
                            password: $password,
                            showPassword: $showPassword,
                            showForgotPassword: $showForgotPassword,
                            showVoiceLogin: $showVoiceLogin,
                            focusedField: $focusedField,
                            authViewModel: authViewModel
                        )
                        
                        Spacer()
                        
                        // Sign Up Prompt
                        HStack(spacing: Theme.Spacing.xsmall) {
                            Text("Don't have an account?")
                                .font(Theme.Typography.footnote)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .font(Theme.Typography.subheadline.bold())
                                    .foregroundColor(Theme.Colors.primaryButton)
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

// MARK: - Login Form View
private struct LoginFormView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var showPassword: Bool
    @Binding var showForgotPassword: Bool
    @Binding var showVoiceLogin: Bool
    @FocusState.Binding var focusedField: LoginField?
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            // Email Field
            EmailField(email: $email, focusedField: $focusedField)
            
            // Password Field
            PasswordField(
                password: $password,
                showPassword: $showPassword,
                focusedField: $focusedField,
                showForgotPassword: $showForgotPassword
            )
            
            // Login Button
            LoginButton(
                email: $email,
                password: $password,
                authViewModel: authViewModel
            )
            
            // Divider with "or"
            DividerWithText(text: "or continue with")
            
            // Social Login Buttons
            SocialLoginButtons(showVoiceLogin: $showVoiceLogin)
            
            // Error Message
            if let error = authViewModel.error {
                ErrorMessageView(error: error)
            }
        }
    }
}

// MARK: - Email Field
private struct EmailField: View {
    @Binding var email: String
    @FocusState.Binding var focusedField: LoginField?
    
    var body: some View {
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
                    .stroke(focusedField == .email ? Theme.Colors.primaryButton : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Password Field
private struct PasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    @FocusState.Binding var focusedField: LoginField?
    @Binding var showForgotPassword: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xsmall) {
            HStack {
                Text("Password")
                    .font(Theme.Typography.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Spacer()
                
                Button(action: { showForgotPassword = true }) {
                    Text("Forgot Password?")
                        .font(Theme.Typography.caption2)
                        .foregroundColor(Theme.Colors.primaryButton)
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
                
                Button(action: { showPassword.toggle() }) {
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
                    .stroke(focusedField == .password ? Theme.Colors.primaryButton : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Login Button
private struct LoginButton: View {
    @Binding var email: String
    @Binding var password: String
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        Button(action: login) {
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
        .shadow(color: Theme.Colors.primaryButton.opacity(0.3), radius: 10, x: 0, y: 4)
    }
    
    private func login() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        authViewModel.login(email: email, password: password)
    }
}

// MARK: - Divider with Text
private struct DividerWithText: View {
    let text: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Theme.Colors.divider)
                .frame(height: 1)
            
            Text(text)
                .font(Theme.Typography.footnote)
                .foregroundColor(Theme.Colors.textSecondary)
                .padding(.horizontal, Theme.Spacing.small)
            
            Rectangle()
                .fill(Theme.Colors.divider)
                .frame(height: 1)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }
}

// MARK: - Social Login Buttons
private struct SocialLoginButtons: View {
    @Binding var showVoiceLogin: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Face ID and Touch ID Buttons
            HStack(spacing: Theme.Spacing.medium) {
                BiometricButton(
                    systemImage: "faceid",
                    title: "Face ID",
                    action: { /* Face ID logic */ }
                )
                
                BiometricButton(
                    systemImage: "touchid",
                    title: "Touch ID",
                    action: { /* Touch ID logic */ }
                )
            }
            
            // Voice Login Button
            Button(action: { showVoiceLogin = true }) {
                HStack(spacing: Theme.Spacing.small) {
                    Image(systemName: "mic.fill")
                    Text("Voice Login")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
}

// MARK: - Biometric Button
private struct BiometricButton: View {
    let systemImage: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.xsmall) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                Text(title)
                    .font(Theme.Typography.subheadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}

// MARK: - Error Message View
private struct ErrorMessageView: View {
    let error: String
    
    var body: some View {
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

// MARK: - Header View
private struct HeaderView: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Animated App Icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryButton.opacity(0.1))
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
                            colors: [Theme.Colors.primaryButton, Theme.Colors.iconActive],
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
    }
}

#Preview {
    LoginView()
}
