import SwiftUI

struct SettingsView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isDarkMode = true
    @State private var notificationsEnabled = true
    @State private var locationPermission = true
    @State private var showUpgradeSheet = false
    @State private var showProfileView = false
    @State private var selectedTab = 4
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Account section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Account")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
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
                            .padding(.horizontal)
                            
                            // App Settings section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("App Settings")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                // Dark Mode toggle
                                HStack {
                                    Label("Dark Mode", systemImage: "moon.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $isDarkMode)
                                        .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                                
                                // Notifications toggle
                                HStack {
                                    Label("Notifications", systemImage: "bell.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $notificationsEnabled)
                                        .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                                
                                // Location Services toggle
                                HStack {
                                    Label("Location Services", systemImage: "location.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $locationPermission)
                                        .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            // About section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("About")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    // Navigate to help & support
                                }) {
                                    HStack {
                                        Label("Help & Support", systemImage: "questionmark.circle.fill")
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
                                
                                Button(action: {
                                    // Navigate to privacy policy
                                }) {
                                    HStack {
                                        Label("Privacy Policy", systemImage: "lock.fill")
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
                                
                                Button(action: {
                                    // Navigate to terms of service
                                }) {
                                    HStack {
                                        Label("Terms of Service", systemImage: "doc.text.fill")
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
                                
                                // Version
                                HStack {
                                    Text("Version")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("1.0.0")
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            // Logout button
                            Button(action: {
                                authViewModel.logout()
                            }) {
                                Text("Logout")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Constants.Colors.lightBackground)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .padding(.vertical, 20)
                        .padding(.bottom, 100) // Extra padding to prevent content from being cut off
                    }
                    
                    // Tab bar
                    HStack {
                        Button(action: {
                            selectedTab = 0
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 0 ? Constants.Colors.primaryPurple : .gray)
                                
                                Text("Home")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 0 ? Constants.Colors.primaryPurple : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            selectedTab = 1
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 1 ? Constants.Colors.primaryPurple : .gray)
                                
                                Text("Shared")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 1 ? Constants.Colors.primaryPurple : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
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
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            selectedTab = 3
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 3 ? Constants.Colors.primaryPurple : .gray)
                                
                                Text("Map")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 3 ? Constants.Colors.primaryPurple : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            selectedTab = 4
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 4 ? Constants.Colors.primaryPurple : .gray)
                                
                                Text("Settings")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 4 ? Constants.Colors.primaryPurple : .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .background(Constants.Colors.darkBackground)
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .fullScreenCover(isPresented: $showUpgradeSheet) {
            UpgradeToPremiumView()
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
        }
        .fullScreenCover(isPresented: .constant(selectedTab != 4)) {
            if selectedTab == 0 {
                HomeView()
            } else if selectedTab == 1 {
                SharedHouseholdView()
            } else if selectedTab == 3 {
                MapView()
            }
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
                .navigationBarTitle("Premium", displayMode: .inline)
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
