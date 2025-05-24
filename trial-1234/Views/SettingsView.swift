import SwiftUI

struct SettingsView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isDarkMode = true
    @State private var notificationsEnabled = true
    @State private var locationPermission = true
    @State private var showUpgradeSheet = false
    @State private var showProfileView = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Account section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Account")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        showProfileView = true
                    }) {
                        HStack {
                            // Avatar
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Constants.Colors.primaryPurple)
                            
                            // User info
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Maya Johnson")
                                    .font(.system(size: Constants.FontSizes.body, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Free Account")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(Constants.Colors.lightPurple)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                    }
                    
                    // Upgrade button
                    Button(action: {
                        showUpgradeSheet = true
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            Text("Upgrade to Premium")
                                .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("$2/month")
                                .font(.system(size: Constants.FontSizes.caption, weight: .bold))
                                .foregroundColor(Constants.Colors.lightPurple)
                        }
                        .padding()
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                    }
                }
                .padding()
                
                // App Settings section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("App Settings")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Dark Mode toggle
                    HStack {
                        Label("Dark Mode", systemImage: "moon.fill")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isDarkMode)
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    // Notifications toggle
                    HStack {
                        Label("Notifications", systemImage: "bell.fill")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $notificationsEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    // Location Services toggle
                    HStack {
                        Label("Location Services", systemImage: "location.fill")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $locationPermission)
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                }
                .padding()
                
                // About section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("About")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        // Navigate to help & support
                    }) {
                        HStack {
                            Label("Help & Support", systemImage: "questionmark.circle.fill")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                    }
                    
                    Button(action: {
                        // Navigate to privacy policy
                    }) {
                        HStack {
                            Label("Privacy Policy", systemImage: "lock.fill")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                    }
                    
                    Button(action: {
                        // Navigate to terms of service
                    }) {
                        HStack {
                            Label("Terms of Service", systemImage: "doc.text.fill")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                    }
                }
                .padding()
                
                Spacer()
                
                // Logout button
                Button(action: {
                    authViewModel.logout()
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                }
                .frame(height: Constants.Dimensions.buttonHeight)
                .background(Color.red.opacity(0.8))
                .cornerRadius(Constants.Dimensions.buttonCornerRadius)
                .foregroundColor(.white)
                .font(.system(size: Constants.FontSizes.button, weight: .bold))
                .padding()
                
                // Tab bar
                HStack {
                    TabBarButton(
                        icon: "house.fill",
                        text: "Home"
                    )
                    
                    TabBarButton(
                        icon: "person.2.fill",
                        text: "Shared"
                    )
                    
                    // Center button (add)
                    Button(action: {
                        // Show add item sheet
                    }) {
                        ZStack {
                            Circle()
                                .fill(Constants.Colors.primaryPurple)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .offset(y: -20)
                    
                    TabBarButton(
                        icon: "map.fill",
                        text: "Map"
                    )
                    
                    TabBarButton(
                        icon: "gearshape.fill",
                        text: "Settings",
                        isSelected: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background(Constants.Colors.darkBackground)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showUpgradeSheet) {
            UpgradeToPremiumView()
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
    }
}

struct UpgradeToPremiumView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding * 1.5) {
                    // Premium icon
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.yellow)
                        .padding(.top)
                    
                    Text("Upgrade to Premium")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Features list
                    VStack(alignment: .leading, spacing: 16) {
                        PremiumFeatureRow(icon: "bell.badge.fill", text: "Unlimited Smart Alerts")
                        PremiumFeatureRow(icon: "person.2.fill", text: "Shared Households")
                        PremiumFeatureRow(icon: "camera.fill", text: "Photo Logging")
                        PremiumFeatureRow(icon: "moon.fill", text: "Dark Mode")
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    // Price
                    Text("Just $2/month")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Cancel anytime")
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    // Subscribe button
                    Button(action: {
                        // Subscription logic would go here
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Subscribe Now")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    
                    // No thanks button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("No Thanks")
                            .foregroundColor(.white)
                            .underline()
                    }
                    .padding(.bottom)
                }
                .padding()
                .navigationTitle("Premium")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.yellow)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: Constants.FontSizes.body))
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "checkmark")
                .foregroundColor(.green)
        }
    }
}

#Preview {
    SettingsView()
}
