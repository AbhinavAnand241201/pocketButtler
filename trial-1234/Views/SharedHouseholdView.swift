import SwiftUI

struct SharedHouseholdView: View {
    @State private var showAddMemberSheet = false
    @State private var selectedTab = 1
    
    // Sample data for preview with proper image names
    let members = [
        (name: "Dad", image: "shh1"),
        (name: "Mom", image: "shh2"),
        (name: "Son", image: "shh3"),
        (name: "Daughter", image: "shh4")
    ]
    
    let activityLogs = [
        (name: "Dad", action: "logged 'Remote'", location: "Living Room", time: "6:30 PM", image: "shh1"),
        (name: "Mom", action: "logged 'Keys'", location: "Kitchen", time: "5:45 PM", image: "shh2"),
        (name: "Son", action: "logged 'Laptop'", location: "Bedroom", time: "5:00 PM", image: "shh3"),
        (name: "Daughter", action: "logged 'Bike'", location: "Garage", time: "4:45 PM", image: "shh4")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Members section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Members")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(members, id: \.name) { member in
                                VStack {
                                    Image(member.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Constants.Colors.lightPurple, lineWidth: 2)
                                        )
                                    
                                    Text(member.name)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Add member button
                            VStack {
                                Button(action: {
                                    showAddMemberSheet = true
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                        .foregroundColor(.white)
                                }
                                
                                Text("Add")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
                
                // Activity Feed section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Activity Feed")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(activityLogs, id: \.name) { log in
                        HStack(spacing: 12) {
                            // Avatar
                            Image(log.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            // Activity details
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(log.name) \(log.action)")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                
                                Text("\(log.location) • \(log.time)")
                                    .font(.system(size: 16))
                                    .foregroundColor(Constants.Colors.lightPurple)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(Constants.Colors.lightBackground)
                        .cornerRadius(Constants.Dimensions.cornerRadius)
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                
                Spacer()
                
                // Add Member button
                Button(action: {
                    showAddMemberSheet = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18))
                        Text("Add Member")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                }
                .background(Constants.Colors.lightPurple)
                .cornerRadius(Constants.Dimensions.buttonCornerRadius)
                .foregroundColor(.white)
                .padding()
                
                // Tab bar
                HStack {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        TabBarButton(
                            icon: "house.fill",
                            text: "Home",
                            isSelected: selectedTab == 0
                        )
                    }
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        TabBarButton(
                            icon: "person.2.fill",
                            text: "Shared",
                            isSelected: selectedTab == 1
                        )
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
                    
                    Button(action: {
                        selectedTab = 3
                    }) {
                        TabBarButton(
                            icon: "map.fill",
                            text: "Map",
                            isSelected: selectedTab == 3
                        )
                    }
                    
                    Button(action: {
                        selectedTab = 4
                    }) {
                        TabBarButton(
                            icon: "gearshape.fill",
                            text: "Settings",
                            isSelected: selectedTab == 4
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background(Constants.Colors.darkBackground)
            }
        }
        .navigationTitle("Shared Household")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddMemberSheet) {
            AddMemberView()
        }
        .fullScreenCover(isPresented: .constant(selectedTab != 1)) {
            if selectedTab == 0 {
                HomeView()
            } else if selectedTab == 3 {
                MapView()
            } else if selectedTab == 4 {
                SettingsView()
            }
        }
    }
}

struct AddMemberView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    Text("Invite a household member")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Text("Enter their email to send an invitation")
                        .font(.system(size: Constants.FontSizes.body))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    TextField("Email address", text: $email)
                        .standardTextFieldStyle()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.top)
                    
                    Button(action: {
                        // Send invitation logic would go here
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Send Invitation")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(email.isEmpty)
                    .opacity(email.isEmpty ? 0.7 : 1)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Add Member")
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

#Preview {
    SharedHouseholdView()
}
