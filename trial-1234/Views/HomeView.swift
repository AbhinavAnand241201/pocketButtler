import SwiftUI

struct HomeView: View {
    @StateObject private var itemViewModel = ItemViewModel()
    @State private var searchText = ""
    @State private var showAddItemSheet = false
    @State private var showPanicMode = false
    
    var showTabBar: Bool = true
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with greeting and avatar
                HStack {
                    // Maya's profile picture
                    Image("shh1") // Using one of the profile images from assets
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Constants.Colors.primaryPurple, lineWidth: 2))
                    
                    // Greeting
                    VStack(alignment: .leading) {
                        Text("Good morning, Maya!")
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Notifications and Panic Mode buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            showPanicMode = true
                        }) {
                            Image(systemName: "speaker.wave.3.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // Navigate to notifications
                        }) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("Search for items...", text: $searchText)
                        .foregroundColor(.white)
                        .onChange(of: searchText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                itemViewModel.searchItems(query: newValue)
                            } else {
                                itemViewModel.fetchItems()
                            }
                        }
                }
                .padding()
                .background(Constants.Colors.lightBackground)
                .cornerRadius(Constants.Dimensions.cornerRadius)
                .padding(.horizontal)
                
                ScrollView {
                    // Recent Items section
                    VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                        Text("Recent Items")
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        if itemViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else if itemViewModel.items.isEmpty {
                            // Show car keys as a recent item
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                RecentItemCell(
                                    name: "Car Keys",
                                    location: "Living Room",
                                    timeAgo: "5 min ago",
                                    image: "keys"
                                )
                            }
                            .padding(.horizontal)
                        } else {
                            // Grid of items
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                // Sample items for preview
                                RecentItemCell(
                                    name: "Wallet",
                                    location: "Bedroom",
                                    timeAgo: "2 hours ago",
                                    image: "wallet"
                                )
                                
                                RecentItemCell(
                                    name: "Keys",
                                    location: "Kitchen",
                                    timeAgo: "5 hours ago",
                                    image: "keys"
                                )
                                
                                RecentItemCell(
                                    name: "Phone",
                                    location: "Office",
                                    timeAgo: "3 days ago",
                                    image: "phone"
                                )
                                
                                RecentItemCell(
                                    name: "Passport",
                                    location: "Safe",
                                    timeAgo: "1 day ago",
                                    image: "passport"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    
                    // Favorites section
                    VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                        Text("Favorites")
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                FavoriteItemCell(
                                    name: "Glasses",
                                    location: "Desk",
                                    image: "glasses"
                                )
                                
                                FavoriteItemCell(
                                    name: "Passport",
                                    location: "Safe",
                                    image: "passport"
                                )
                                
                                FavoriteItemCell(
                                    name: "AirPods",
                                    location: "Backpack",
                                    image: "earpods"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, Constants.Dimensions.standardPadding * 2)
                    
                    // Quick Actions section with animations
                    VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                        Text("Quick Actions")
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        // Animated quick action cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                QuickActionCard(
                                    title: "Find Nearby",
                                    description: "Locate items around you",
                                    icon: "location.fill",
                                    color: Constants.Colors.teal
                                )
                                
                                QuickActionCard(
                                    title: "Last Seen",
                                    description: "View item history",
                                    icon: "clock.fill",
                                    color: Constants.Colors.peach
                                )
                                
                                QuickActionCard(
                                    title: "Share Item",
                                    description: "With household members",
                                    icon: "person.2.fill",
                                    color: Constants.Colors.primaryPurple
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, Constants.Dimensions.standardPadding * 2)
                }
                
                // Only show tab bar if needed (not when used in MainTabView)
                if showTabBar {
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView()
        }
        .sheet(isPresented: $showPanicMode) {
            PanicModeView()
        }
        .onAppear {
            itemViewModel.fetchItems()
        }
    }
}

// MARK: - Supporting Views

struct RecentItemCell: View {
    let name: String
    let location: String
    let timeAgo: String
    let image: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Actual image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Item details
            Text(name)
                .font(.system(size: Constants.FontSizes.body, weight: .bold))
                .foregroundColor(.white)
            
            Text("\(location) • \(timeAgo)")
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(Constants.Colors.lightPurple)
        }
        .padding(.bottom, 8)
    }
}

struct FavoriteItemCell: View {
    let name: String
    let location: String
    let image: String
    
    var body: some View {
        VStack(alignment: .center) {
            // Actual image
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Constants.Colors.primaryPurple, lineWidth: 2))
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Text
            Text(name)
                .font(.system(size: Constants.FontSizes.body, weight: .medium))
                .foregroundColor(.white)
            
            Text(location)
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(width: 100)
    }
}

// TabBarButton moved to Components/TabBarButton.swift

struct QuickActionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    @State private var isHovering = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            // Text
            Text(title)
                .font(.system(size: Constants.FontSizes.body, weight: .bold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
        }
        .padding(16)
        .frame(width: 160, height: 160)
        .background(Constants.Colors.lightBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(isHovering ? 0.8 : 0.3), lineWidth: 2)
        )
        .shadow(color: color.opacity(isHovering ? 0.4 : 0.1), radius: isHovering ? 8 : 4, x: 0, y: isHovering ? 4 : 2)
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .onTapGesture {
            withAnimation(.spring()) {
                isHovering.toggle()
                
                // Reset after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring()) {
                        isHovering = false
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
