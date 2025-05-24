import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: Constants.Dimensions.standardPadding * 2) {
                // Illustration
                Image(systemName: "lock.open.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Constants.Colors.primaryPurple)
                    .background(
                        Circle()
                            .fill(Constants.Colors.peach)
                            .frame(width: 150, height: 150)
                    )
                    .padding(.bottom, Constants.Dimensions.standardPadding)
                
                // Instructions
                if showSuccessMessage {
                    Text("Password Reset Email Sent")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Check your email for instructions to reset your password")
                        .font(.system(size: Constants.FontSizes.body))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                } else {
                    Text("Forgot Password")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Enter your email to receive a password reset link")
                        .font(.system(size: Constants.FontSizes.body))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    
                    // Email field
                    TextField("Enter your email", text: $email)
                        .standardTextFieldStyle()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.top, Constants.Dimensions.standardPadding)
                    
                    // Submit button
                    Button(action: {
                        authViewModel.resetPassword(email: email)
                        showSuccessMessage = true
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(email.isEmpty || authViewModel.isLoading)
                    .opacity((email.isEmpty || authViewModel.isLoading) ? 0.7 : 1)
                    
                    // Error message
                    if let error = authViewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: Constants.FontSizes.caption))
                    }
                }
                
                // Back to login button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to Login")
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.top, Constants.Dimensions.standardPadding)
            }
            .padding()
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
