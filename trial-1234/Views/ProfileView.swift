import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = "Maya Johnson"
    @State private var email = "maya@example.com"
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Profile header
                    VStack(spacing: Constants.Dimensions.standardPadding) {
                        // Avatar
                        Image("shh3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Constants.Colors.primaryPurple, lineWidth: 3)
                            )
                        
                        // Name
                        if isEditing {
                            TextField("Name", text: $name)
                                .standardTextFieldStyle()
                                .multilineTextAlignment(.center)
                        } else {
                            Text(name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, Constants.Dimensions.standardPadding * 2)
                    
                    // Stats section
                    HStack(spacing: 8) {
                        // Items Tracked
                        StatBox(title: "Items Tracked", value: "12")
                        
                        // Alerts Received
                        StatBox(title: "Alerts Received", value: "5")
                        
                        // Shared Items
                        StatBox(title: "Shared Items", value: "8")
                    }
                    .padding(.horizontal)
                    
                    // Profile details
                    VStack(spacing: Constants.Dimensions.standardPadding) {
                        if isEditing {
                            // Email field
                            TextField("Email", text: $email)
                                .standardTextFieldStyle()
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.top, Constants.Dimensions.standardPadding * 2)
                            
                            // Save button
                            Button(action: {
                                // Save profile changes
                                isEditing = false
                            }) {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                            .standardButtonStyle()
                            .padding(.top)
                        } else {
                            // Email display
                            HStack {
                                Text("Email")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text(email)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                            .padding(.top, Constants.Dimensions.standardPadding * 2)
                            
                            // Account type display
                            HStack {
                                Text("Account Type")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text("Free")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                            
                            // Member since display
                            HStack {
                                Text("Member Since")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text("May 2025")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                            
                            // Edit profile button
                            Button(action: {
                                isEditing = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18))
                                    Text("Edit Profile")
                                        .font(.system(size: 18, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .standardButtonStyle()
                            .padding(.top, Constants.Dimensions.standardPadding * 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
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

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.system(size: Constants.FontSizes.body, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Constants.Colors.lightBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
    }
}

#Preview {
    ProfileView()
}
