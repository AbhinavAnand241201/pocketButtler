import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int
    @State private var showAddItemSheet = false
    
    init(selectedTab: Int = 0) {
        _selectedTab = State(initialValue: selectedTab)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Main content area
                TabView(selection: $selectedTab) {
                    // Wrap each view in a NavigationView to ensure proper layout
                    NavigationView {
                        HomeView(showTabBar: false)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tag(0)
                    
                    NavigationView {
                        SharedHouseholdView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tag(1)
                    
                    // Placeholder for center tab
                    Color.clear
                        .tag(2)
                    
                    NavigationView {
                        MapView(showTabBar: false)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tag(3)
                    
                    NavigationView {
                        SettingsView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea(edges: [.top, .horizontal])
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Custom tab bar
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Constants.Colors.lightBackground)
                    
                    HStack {
                        TabBarButton(
                            icon: "house.fill",
                            text: "Home",
                            isSelected: selectedTab == 0
                        )
                        .onTapGesture {
                            selectedTab = 0
                        }
                        
                        TabBarButton(
                            icon: "person.2.fill",
                            text: "Shared",
                            isSelected: selectedTab == 1
                        )
                        .onTapGesture {
                            selectedTab = 1
                        }
                        
                        // Center button (add)
                        ZStack {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 56, height: 56)
                            
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
                        }
                        
                        TabBarButton(
                            icon: "map.fill",
                            text: "Map",
                            isSelected: selectedTab == 3
                        )
                        .onTapGesture {
                            selectedTab = 3
                        }
                        
                        TabBarButton(
                            icon: "gearshape.fill",
                            text: "Settings",
                            isSelected: selectedTab == 4
                        )
                        .onTapGesture {
                            selectedTab = 4
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 16 : 8)
                    .background(Constants.Colors.darkBackground)
                }
                .frame(width: geometry.size.width)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView()
        }
    }
}

#Preview {
    MainTabView()
}
