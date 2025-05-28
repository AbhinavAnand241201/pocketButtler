import SwiftUI

struct SignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isAnimating = false
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    
    private enum Field: Hashable {
        case name, email, password, confirmPassword
    }
    
    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && 
        !email.isEmpty && 
        email.contains("@") && 
        password.count >= 6 && 
        passwordsMatch
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            Theme.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.xlarge) {
                    // Back Button and Title
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.Colors.primary)
                                .frame(width: 44, height: 44)
                                .background(Theme.Colors.cardBackground)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Back to login")
                        
                        Spacer()
                        
                        Text("Create Account")
                            .font(Theme.Typography.title2.bold())
                            .foregroundColor(Theme.Colors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.trailing, 44) // Balance the back button
                    }
                    .padding(.top, Theme.Spacing.medium)
                    .padding(.horizontal, Theme.Spacing.medium)
                    
                    // Illustration
                    ZStack {
                        Circle()
                            .fill(Theme.Colors.primary.opacity(0.1))
                            .frame(width: 180, height: 180)
                            .scaleEffect(isAnimating ? 1.0 : 0.9)
                            .opacity(isAnimating ? 1.0 : 0.7)
                            .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.Colors.primary, Theme.Colors.accent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .padding(.vertical, Theme.Spacing.medium)
                    .onAppear { isAnimating = true }
                    
                    // Form Fields
                    VStack(spacing: Theme.Spacing.large) {
                        // Name Field
                        VStack(alignment: .leading, spacing: Theme.Spacing.xsmall) {
                            Text("Full Name")
                                .font(Theme.Typography.subheadline)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                    .frame(width: 20)
                                
                                TextField("John Doe", text: $name)
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .focused($focusedField, equals: .name)
                                    .submitLabel(.next)
                                    .textContentType(.name)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                            }
                            .padding(Theme.Spacing.medium)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .fill(Theme.Colors.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .stroke(focusedField == .name ? Theme.Colors.primary : Color.clear, lineWidth: 1.5)
                            )
                        }
                        
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
                            Text("Password")
                                .font(Theme.Typography.subheadline)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                    .frame(width: 20)
                                
                                if showPassword {
                                    TextField("••••••••", text: $password)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .focused($focusedField, equals: .password)
                                        .submitLabel(.next)
                                        .textContentType(.newPassword)
                                } else {
                                    SecureField("••••••••", text: $password)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .focused($focusedField, equals: .password)
                                        .submitLabel(.next)
                                        .textContentType(.newPassword)
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
                                    .stroke(focusedField == .password ? Theme.Colors.primary : Color.clear, lineWidth: 1.5)
                            )
                            
                            if !password.isEmpty && password.count < 6 {
                                Text("Password must be at least 6 characters")
                                    .font(Theme.Typography.caption2)
                                    .foregroundColor(Theme.Colors.error)
                                    .transition(.opacity)
                            }
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: Theme.Spacing.xsmall) {
                            Text("Confirm Password")
                                .font(Theme.Typography.subheadline)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
                                    .frame(width: 20)
                                
                                if showConfirmPassword {
                                    TextField("••••••••", text: $confirmPassword)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .focused($focusedField, equals: .confirmPassword)
                                        .submitLabel(.go)
                                        .textContentType(.newPassword)
                                } else {
                                    SecureField("••••••••", text: $confirmPassword)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .focused($focusedField, equals: .confirmPassword)
                                        .submitLabel(.go)
                                        .textContentType(.newPassword)
                                }
                                
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
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
                                    .stroke(focusedField == .confirmPassword ? Theme.Colors.primary : Color.clear, lineWidth: 1.5)
                            )
                            
                            if !confirmPassword.isEmpty && !passwordsMatch {
                                Text("Passwords don't match")
                                    .font(Theme.Typography.caption2)
                                    .foregroundColor(Theme.Colors.error)
                                    .transition(.opacity)
                            }
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            // Handle sign up
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Create Account")
                                    .font(Theme.Typography.headline)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .padding(.top, Theme.Spacing.medium)
                        .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 4)
                        
                        // Terms and Conditions
                        VStack(spacing: Theme.Spacing.small) {
                            Text("By signing up, you agree to our")
                                .font(Theme.Typography.caption2)
                                .foregroundColor(Theme.Colors.textSecondary)
                            
                            HStack(spacing: Theme.Spacing.medium) {
                                Button("Terms of Service") {
                                    // Show terms of service
                                }
                                .font(Theme.Typography.caption2.bold())
                                .foregroundColor(Theme.Colors.primary)
                                
                                Circle()
                                    .fill(Theme.Colors.textSecondary.opacity(0.5))
                                    .frame(width: 4, height: 4)
                                
                                Button("Privacy Policy") {
                                    // Show privacy policy
                                }
                                .font(Theme.Typography.caption2.bold())
                                .foregroundColor(Theme.Colors.primary)
                            }
                        }
                        .padding(.top, Theme.Spacing.medium)
                        
                        // Error Message
                        if let error = authViewModel.error {
                            HStack(spacing: Theme.Spacing.xsmall) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(Theme.Colors.error)
                                Text(error)
                                    .font(Theme.Typography.caption2)
                                    .foregroundColor(Theme.Colors.error)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.error.opacity(0.1))
                            .cornerRadius(Theme.CornerRadius.medium)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    
                    Spacer()
                    
                    // Already have an account?
                    HStack(spacing: Theme.Spacing.xsmall) {
                        Text("Already have an account?")
                            .font(Theme.Typography.footnote)
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Button(action: { dismiss() }) {
                            Text("Sign In")
                                .font(Theme.Typography.subheadline.bold())
                                .foregroundColor(Theme.Colors.primary)
                        }
                    }
                    .padding(.bottom, Theme.Spacing.xlarge)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SignUpView()
}
