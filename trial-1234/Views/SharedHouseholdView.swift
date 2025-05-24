import SwiftUI

struct SharedHouseholdView: View {
    @State private var showAddMemberSheet = false
    
    // Sample data for preview
    let members = [
        (name: "Dad", image: "person.fill"),
        (name: "Mom", image: "person.fill"),
        (name: "Son", image: "person.fill"),
        (name: "Daughter", image: "person.fill")
    ]
    
    let activityLogs = [
        (name: "Dad", action: "logged 'Remote'", location: "Living Room", time: "6:30 PM", image: "person.fill"),
        (name: "Mom", action: "logged 'Keys'", location: "Kitchen", time: "5:45 PM", image: "person.fill"),
        (name: "Son", action: "logged 'Laptop'", location: "Bedroom", time: "5:00 PM", image: "person.fill"),
        (name: "Daughter", action: "logged 'Bike'", location: "Garage", time: "4:45 PM", image: "person.fill")
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
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(members, id: \.name) { member in
                                VStack {
                                    Image(systemName: member.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(Constants.Colors.lightBackground)
                                        )
                                        .foregroundColor(.white)
                                    
                                    Text(member.name)
                                        .font(.system(size: Constants.FontSizes.caption))
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
                                        .frame(width: 25, height: 25)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                        .foregroundColor(.white)
                                }
                                
                                Text("Add")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                
                // Activity Feed section
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Activity Feed")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(activityLogs, id: \.name) { log in
                        HStack(spacing: 12) {
                            // Avatar
                            Image(systemName: log.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Constants.Colors.lightBackground)
                                )
                                .foregroundColor(.white)
                            
                            // Activity details
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(log.name) \(log.action)")
                                    .font(.system(size: Constants.FontSizes.body))
                                    .foregroundColor(.white)
                                
                                Text("\(log.location) • \(log.time)")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(Constants.Colors.lightPurple)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
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
                        Text("Add Member")
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: Constants.Dimensions.buttonHeight)
                .background(Constants.Colors.lightPurple)
                .cornerRadius(Constants.Dimensions.buttonCornerRadius)
                .foregroundColor(.white)
                .padding()
                
                // Tab bar
                HStack {
                    TabBarButton(
                        icon: "house.fill",
                        text: "Home"
                    )
                    
                    TabBarButton(
                        icon: "person.2.fill",
                        text: "Shared",
                        isSelected: true
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
                        text: "Settings"
                    )
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
