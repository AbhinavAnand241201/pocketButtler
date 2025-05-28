import SwiftUI
import MapKit

struct ItemLocation: Identifiable {
    let id: String
    let name: String
    let location: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var showTabBar: Bool = true
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
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
            LinearGradient(
                gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Map
                Map(position: $position) {
                    ForEach(itemLocations) { item in
                        Annotation(item.name, coordinate: item.coordinate) {
                            Button(action: {
                                selectedItem = item
                                showItemDetails = true
                            }) {
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(Theme.Colors.primaryButton)
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
                                        .background(Theme.Colors.cardBackground.opacity(0.9))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .mapStyle(.standard)
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .ignoresSafeArea(edges: .top)
                
                // Item list
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    Text("Nearby Items")
                        .font(.system(size: Constants.FontSizes.title, weight: .bold))
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(itemLocations) { item in
                                Button(action: {
                                    selectedItem = item
                                    showItemDetails = true
                                    
                                    // Center map on selected item
                                    withAnimation {
                                        position = .region(
                                            MKCoordinateRegion(
                                                center: item.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            )
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
                
                // Only show tab bar if needed (not when used in MainTabView)
                if showTabBar {
                    Spacer()
                }
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showItemDetails) {
            if let selectedItem = selectedItem {
                // Create a dummy Item from ItemLocation for preview
                let dummyItem = Item(
                    id: selectedItem.id,
                    name: selectedItem.name,
                    location: selectedItem.location,
                    ownerId: "preview-owner",
                    timestamp: Date(),
                    photoUrl: nil,
                    isFavorite: false
                )
                ItemDetailsView(item: dummyItem, itemViewModel: ItemViewModel())
            }
        }
    }
}

#Preview {
    let sampleItem = ItemLocation(
        id: "1",
        name: "Keys",
        location: "Living Room",
        imageName: "keys",
        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    )
    return MapView()
}
