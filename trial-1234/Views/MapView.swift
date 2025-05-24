import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Sample locations for preview
    let itemLocations = [
        ItemLocation(id: "1", name: "Keys", location: "Living Room", imageName: "keys", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        ItemLocation(id: "2", name: "Wallet", location: "Bedroom", imageName: "wallet", coordinate: CLLocationCoordinate2D(latitude: 37.7746, longitude: -122.4172)),
        ItemLocation(id: "3", name: "Phone", location: "Office", imageName: "phone", coordinate: CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4217)),
        ItemLocation(id: "4", name: "Passport", location: "Safe", imageName: "passport", coordinate: CLLocationCoordinate2D(latitude: 37.7775, longitude: -122.4183))
    ]
    
    @State private var selectedItem: ItemLocation?
    @State private var showItemDetails = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Map
                Map(coordinateRegion: $region, annotationItems: itemLocations) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        Button(action: {
                            selectedItem = item
                            showItemDetails = true
                        }) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Constants.Colors.primaryPurple)
                                        .frame(width: 45, height: 45)
                                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    
                                    Image(item.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }
                                
                                Text(item.name)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Constants.Colors.darkBackground.opacity(0.8))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                // Item list
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Nearby Items")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(itemLocations) { item in
                                Button(action: {
                                    selectedItem = item
                                    showItemDetails = true
                                    
                                    // Center map on selected item
                                    withAnimation {
                                        region = MKCoordinateRegion(
                                            center: item.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        )
                                    }
                                }) {
                                    VStack(alignment: .leading) {
                                        // Actual image
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        Text(item.name)
                                            .font(.system(size: Constants.FontSizes.body, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text(item.location)
                                            .font(.system(size: Constants.FontSizes.caption))
                                            .foregroundColor(Constants.Colors.lightPurple)
                                    }
                                    .frame(width: 120)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Constants.Colors.darkBackground)
                
                // Tab bar
                HStack {
                    TabBarButton(
                        icon: "house.fill",
                        text: "Home"
                    )
                    .onTapGesture {
                        // Navigate to Home View
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: MainTabView(selectedTab: 0))
                        }
                    }
                    
                    TabBarButton(
                        icon: "person.2.fill",
                        text: "Shared"
                    )
                    .onTapGesture {
                        // Navigate to Shared Household View
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: MainTabView(selectedTab: 1))
                        }
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
                    
                    TabBarButton(
                        icon: "map.fill",
                        text: "Map",
                        isSelected: true
                    )
                    
                    TabBarButton(
                        icon: "gearshape.fill",
                        text: "Settings"
                    )
                    .onTapGesture {
                        // Navigate to Settings View
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: MainTabView(selectedTab: 4))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background(Constants.Colors.darkBackground)
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showItemDetails) {
            if let selectedItem = selectedItem {
                ItemDetailsView(item: selectedItem)
            }
        }
    }
}

struct ItemLocation: Identifiable {
    let id: String
    let name: String
    let location: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D
}

struct ItemDetailsView: View {
    let item: ItemLocation
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Item image
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                            .fill(Constants.Colors.peach)
                            .aspectRatio(1.5, contentMode: .fit)
                        
                        Image(systemName: "bag.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.7))
                            .padding(40)
                    }
                    
                    // Item details
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Constants.Colors.lightPurple)
                            
                            Text(item.location)
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(Constants.Colors.lightPurple)
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Constants.Colors.lightPurple)
                            
                            Text("Last updated 2 hours ago")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(Constants.Colors.lightPurple)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    // Actions
                    HStack(spacing: 16) {
                        // Edit button
                        Button(action: {
                            // Edit item logic
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                Text("Edit")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                        }
                        
                        // Share button
                        Button(action: {
                            // Share item logic
                        }) {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                Text("Share")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                        }
                        
                        // Delete button
                        Button(action: {
                            // Delete item logic
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                Text("Delete")
                                    .font(.system(size: Constants.FontSizes.caption))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle(item.name)
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
    MapView()
}
