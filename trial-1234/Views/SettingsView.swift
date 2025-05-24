import SwiftUI

struct SettingsView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isDarkMode = true
    @State private var notificationsEnabled = true
    @State private var locationPermission = true
    @State private var showUpgradeSheet = false
    @State private var showProfileView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Account section
                        SettingsSectionView(title: "Account") {
                            // Profile button
                            Button(action: {
                                showProfileView = true
                            }) {
                                HStack {
                                    // Avatar
                                    Image("shh3")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    
                                    // User info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Maya Johnson")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text("Free Account")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                            }
                            
                            // Upgrade button
                            Button(action: {
                                showUpgradeSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    
                                    Text("Upgrade to Premium")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("$2/month")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        // App Settings section
                        SettingsSectionView(title: "App Settings") {
                            // Dark mode toggle
                            SettingsToggleRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                isOn: $isDarkMode
                            )
                            
                            // Notifications toggle
                            SettingsToggleRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                isOn: $notificationsEnabled
                            )
                            
                            // Location toggle
                            SettingsToggleRow(
                                icon: "location.fill",
                                title: "Location Services",
                                isOn: $locationPermission
                            )
                        }
                        
                        // About section
                        SettingsSectionView(title: "About") {
                            // App version
                            HStack {
                                Label("Version", systemImage: "info.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("1.0.0")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(12)
                            
                            // Privacy Policy
                            SettingsLinkRow(
                                icon: "lock.fill",
                                title: "Privacy Policy",
                                action: {}
                            )
                            
                            // Terms of Service
                            SettingsLinkRow(
                                icon: "doc.text.fill",
                                title: "Terms of Service",
                                action: {}
                            )
                            
                            // Help & Support
                            SettingsLinkRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                action: {}
                            )
                            
                            // Logout button
                            Button(action: {
                                authViewModel.logout()
                            }) {
                                Text("Log Out")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Constants.Colors.lightBackground)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 20)
                        }
                        
                        // Bottom padding
                        Spacer().frame(height: 80)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showUpgradeSheet) {
            PremiumView()
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
        }
    }
}

// Helper Views for Settings

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            content
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
        }
        .padding()
        .background(Constants.Colors.lightBackground)
        .cornerRadius(12)
    }
}

struct SettingsLinkRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Constants.Colors.lightBackground)
            .cornerRadius(12)
        }
    }
}

struct PremiumView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Premium icon
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.yellow)
                        .padding(.top)
                    
                    Text("Upgrade to Premium")
                        .font(.system(size: 28, weight: .bold))
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
                    .cornerRadius(12)
                    
                    // Price
                    Text("Just $2/month")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Cancel anytime")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    // Subscribe button
                    Button(action: {
                        // Subscription logic would go here
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Subscribe Now")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.primaryPurple)
                            .cornerRadius(12)
                    }
                    
                    // No thanks button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("No Thanks")
                            .font(.system(size: 16))
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
                .font(.system(size: 18))
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
