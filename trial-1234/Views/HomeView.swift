import SwiftUI

struct HomeView: View {
    @StateObject private var itemViewModel = ItemViewModel()
    @State private var searchText = ""
    @State private var showAddItemSheet = false
    @State private var showPanicMode = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with greeting and avatar
                HStack {
                    // Avatar
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Constants.Colors.primaryPurple)
                    
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
                        .onChange(of: searchText) { newValue in
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
                            Text("No items found")
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            // Grid of items
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                // Sample items for preview
                                ItemGridCell(
                                    name: "Wallet",
                                    location: "Bedroom",
                                    timeAgo: "2 hours ago",
                                    backgroundColor: Constants.Colors.peach
                                )
                                
                                ItemGridCell(
                                    name: "Keys",
                                    location: "Kitchen",
                                    timeAgo: "5 hours ago",
                                    backgroundColor: Constants.Colors.lightPurple.opacity(0.3)
                                )
                                
                                ItemGridCell(
                                    name: "Phone",
                                    location: "Office",
                                    timeAgo: "3 days ago",
                                    backgroundColor: Constants.Colors.peach
                                )
                                
                                ItemGridCell(
                                    name: "Laptop",
                                    location: "Cafe",
                                    timeAgo: "1 day ago",
                                    backgroundColor: Constants.Colors.peach
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
                            HStack(spacing: 16) {
                                FavoriteItemCell(
                                    name: "Glasses",
                                    location: "Desk"
                                )
                                
                                FavoriteItemCell(
                                    name: "Passport",
                                    location: "Safe"
                                )
                                
                                FavoriteItemCell(
                                    name: "AirPods",
                                    location: "Backpack"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, Constants.Dimensions.standardPadding * 2)
                }
                
                // Tab bar
                HStack {
                    TabBarButton(
                        icon: "house.fill",
                        text: "Home",
                        isSelected: true
                    )
                    
                    TabBarButton(
                        icon: "person.2.fill",
                        text: "Shared"
                    )
                    
                    // Center button (add)
                    Button(action: {
                        showAddItemSheet = true
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

struct ItemGridCell: View {
    let name: String
    let location: String
    let timeAgo: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white.opacity(0.7))
                        .padding(24)
                )
            
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
    
    var body: some View {
        VStack(alignment: .center) {
            // Icon
            ZStack {
                Circle()
                    .fill(Constants.Colors.lightBackground)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Constants.Colors.primaryPurple)
            }
            
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

struct TabBarButton: View {
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? Constants.Colors.primaryPurple : .white.opacity(0.7))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? Constants.Colors.primaryPurple : .white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}
