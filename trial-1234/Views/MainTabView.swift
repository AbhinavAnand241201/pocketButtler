import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showAddItemSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                SharedHouseholdView()
                    .tag(1)
                
                // Placeholder for center tab
                Color.clear
                    .tag(2)
                
                MapView()
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom tab bar
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
            .padding(.bottom, 4)
            .background(Constants.Colors.darkBackground)
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
