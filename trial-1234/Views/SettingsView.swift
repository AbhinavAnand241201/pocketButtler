import SwiftUI

// MARK: - Main Settings View
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
                        // Account Section
                        AccountSectionView(
                            showUpgradeSheet: $showUpgradeSheet,
                            showProfileView: $showProfileView
                        )
                        
                        // App Settings Section
                        AppSettingsSectionView(
                            isDarkMode: $isDarkMode,
                            notificationsEnabled: $notificationsEnabled,
                            locationPermission: $locationPermission
                        )
                        
                        // About Section
                        AboutSectionView()
                        
                        // Logout Button
                        LogoutSectionView {
                            authViewModel.logout()
                        }
                        
                        // Bottom padding
                        Spacer().frame(height: 80)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.Colors.textPrimary)
                }
            }
            .background(Constants.Colors.darkBackground.ignoresSafeArea())
        }
        .sheet(isPresented: $showUpgradeSheet) {
            PremiumView()
                .preferredColorScheme(.dark)
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
                .preferredColorScheme(.dark)
        }
        .accentColor(Theme.Colors.iconActive)
    }
}

// MARK: - Account Section View
private struct AccountSectionView: View {
    @Binding var showUpgradeSheet: Bool
    @Binding var showProfileView: Bool
    
    var body: some View {
        SettingsSectionView(title: "ACCOUNT") {
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
                        .overlay(
                            Circle()
                                .stroke(Theme.Colors.iconActive, lineWidth: 1.5)
                        )
                    
                    // User info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Abhinav Anand")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("Free Account")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.iconDefault)
                }
                .padding(16)
                .background(Theme.Colors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.Colors.divider, lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Upgrade button
            Button(action: {
                showUpgradeSheet = true
            }) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.Colors.iconActive)
                    
                    Text("Upgrade to Premium")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text("$2/month")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Theme.Colors.cardBackground.opacity(0.5))
                        .cornerRadius(12)
                }
                .padding(16)
                .background(Theme.Colors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.Colors.divider, lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - App Settings Section View
private struct AppSettingsSectionView: View {
    @Binding var isDarkMode: Bool
    @Binding var notificationsEnabled: Bool
    @Binding var locationPermission: Bool
    
    var body: some View {
        SettingsSectionView(title: "APP SETTINGS") {
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
    }
}

// MARK: - About Section View
private struct AboutSectionView: View {
    var body: some View {
        SettingsSectionView(title: "ABOUT") {
            // App version
            HStack {
                Image(systemName: "info.circle")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.Colors.iconDefault)
                    .frame(width: 32, height: 32)
                    .background(Theme.Colors.cardBackground.opacity(0.5))
                    .clipShape(Circle())
                
                Text("Version")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("1.0.0")
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding(16)
            
            // Divider
            Divider()
                .background(Theme.Colors.divider)
                .padding(.horizontal, 16)
            
            // Privacy Policy
            NavigationLink(destination: Text("Privacy Policy")) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.Colors.iconDefault)
                        .frame(width: 32, height: 32)
                        .background(Theme.Colors.cardBackground.opacity(0.5))
                        .clipShape(Circle())
                    
                    Text("Privacy Policy")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.iconDefault)
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Divider
            Divider()
                .background(Theme.Colors.divider)
                .padding(.horizontal, 16)
            
            // Terms of Service
            NavigationLink(destination: Text("Terms of Service")) {
                HStack {
                    Image(systemName: "doc.text")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.Colors.iconDefault)
                        .frame(width: 32, height: 32)
                        .background(Theme.Colors.cardBackground.opacity(0.5))
                        .clipShape(Circle())
                    
                    Text("Terms of Service")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.Colors.iconDefault)
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Logout Section View
private struct LogoutSectionView: View {
    let onSignOut: () -> Void
    
    var body: some View {
        SettingsSectionView(title: "") {
            Button(action: {
                onSignOut()
            }) {
                HStack {
                    Spacer()
                    Text("Log Out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.Colors.error)
                    Spacer()
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Settings Section View
struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !title.isEmpty {
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .kerning(1.0)
                    .foregroundColor(Theme.Colors.textTertiary)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 0) {
                content
            }
            .background(Theme.Colors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.Colors.divider, lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Theme.Colors.iconDefault)
                .frame(width: 32, height: 32)
                .background(Theme.Colors.cardBackground.opacity(0.5))
                .clipShape(Circle())
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.Colors.textPrimary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(CustomToggleStyle())
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                isOn.toggle()
            }
        }
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
