import SwiftUI
import MapKit

struct ItemDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var itemViewModel: ItemViewModel
    @State private var showEditSheet = false
    @State private var showShareSheet = false
    @State private var showDeleteConfirmation = false
    @State private var selectedMapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    let item: Item
    
    init(item: Item, itemViewModel: ItemViewModel = ItemViewModel()) {
        self.item = item
        self.itemViewModel = itemViewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                // Item image or placeholder
                if let photoUrl = item.photoUrl, !photoUrl.isEmpty {
                    // In a real app, we would load the image from the URL
                    // For now, we'll use a placeholder
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                } else {
                    // Placeholder with icon
                    ZStack {
                        Rectangle()
                            .fill(Constants.Colors.lightBackground)
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "tag.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Constants.Colors.primaryPurple)
                            
                            Text(item.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                // Item details
                VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
                    // Name and favorite status
                    HStack {
                        Text(item.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if item.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // Location with icon
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Constants.Colors.teal)
                        
                        Text(item.location)
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                    }
                    
                    // Last updated with icon
                    HStack(spacing: 12) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Constants.Colors.orange)
                        
                        Text("Last updated \(timeAgo(item.timestamp))")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                    }
                    
                    // Map view (removed, as Item no longer has coordinates)
                    
                    // Action buttons
                    HStack(spacing: Constants.Dimensions.standardPadding) {
                        // Edit button
                        Button(action: {
                            showEditSheet = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .secondaryButtonStyle()
                        
                        // Share button
                        Button(action: {
                            showShareSheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .secondaryButtonStyle()
                    }
                    
                    // History section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location History")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        ForEach(sampleHistory) { historyItem in
                            HistoryEntryRow(historyItem: historyItem)
                        }
                        
                        Button(action: {
                            // Navigate to full history
                        }) {
                            Text("View Full History")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(Constants.Colors.primaryPurple)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    // Delete button
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Item")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    .padding(.top, Constants.Dimensions.standardPadding)
                }
                .padding()
            }
        }
        .background(Constants.Colors.darkBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Toggle favorite
                    itemViewModel.toggleFavorite(for: item)
                }) {
                    Image(systemName: item.isFavorite ? "star.fill" : "star")
                        .foregroundColor(item.isFavorite ? .yellow : .white)
                }
            }
        }
        .alert("Delete Item", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                // Delete the item
                itemViewModel.deleteItem(item)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            EditItemView(item: item, viewModel: itemViewModel)
        }
    }
    
    private var sampleHistory: [ItemHistoryEntry] {
        let now = Date()
        return [
            ItemHistoryEntry(id: "1", action: "Placed", location: "Kitchen Counter", timestamp: now.addingTimeInterval(-3600)),
            ItemHistoryEntry(id: "2", action: "Moved", location: "Living Room", timestamp: now.addingTimeInterval(-86400)),
            ItemHistoryEntry(id: "3", action: "Found", location: "Bedroom", timestamp: now.addingTimeInterval(-172800))
        ]
    }
    
    private func timeAgo(_ date: Date) -> String {
        return date.timeAgo()
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ItemHistoryEntry: Identifiable {
    let id: String
    let action: String
    let location: String
    let timestamp: Date
}

struct HistoryEntryRow: View {
    let historyItem: ItemHistoryEntry
    
    var body: some View {
        HStack {
            // Action
            Text(historyItem.action)
                .font(.system(size: Constants.FontSizes.caption, weight: .medium))
                .foregroundColor(actionColor(historyItem.action))
                .frame(width: 60, alignment: .leading)
            
            // Location
            Text(historyItem.location)
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(.white)
            
            Spacer()
            
            // Time
            Text(timeAgo(historyItem.timestamp))
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func actionColor(_ action: String) -> Color {
        switch action {
        case "Placed": return Constants.Colors.teal
        case "Moved": return Constants.Colors.orange
        case "Found": return Constants.Colors.lightPurple
        default: return Constants.Colors.primaryPurple
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        return date.timeAgo()
    }
}

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName: String
    @State private var itemLocation: String
    @State private var isFavorite: Bool
    
    let item: Item
    @ObservedObject var viewModel: ItemViewModel
    
    init(item: Item, viewModel: ItemViewModel) {
        self.item = item
        self.viewModel = viewModel
        _itemName = State(initialValue: item.name)
        _itemLocation = State(initialValue: item.location)
        _isFavorite = State(initialValue: item.isFavorite)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Item name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Item Name")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("Item Name", text: $itemName)
                            .standardTextFieldStyle()
                    }
                    
                    // Item location field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("Location", text: $itemLocation)
                            .standardTextFieldStyle()
                    }
                    
                    // Favorite toggle
                    HStack {
                        Text("Add to Favorites")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isFavorite)
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        // Save changes
                        // In a real app, we would update the item in the database
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(itemName.isEmpty || itemLocation.isEmpty)
                    .opacity((itemName.isEmpty || itemLocation.isEmpty) ? 0.7 : 1)
                }
                .padding()
                .navigationTitle("Edit Item")
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
    let sampleItem = Item(
        id: "123",
        name: "House Keys",
        location: "Kitchen Counter",
        ownerId: "owner-1",
        timestamp: Date().addingTimeInterval(-3600),
        photoUrl: nil,
        isFavorite: true
    )
    return NavigationView {
        ItemDetailsView(item: sampleItem, itemViewModel: ItemViewModel())
    }
}

#Preview {
    let sampleItem = Item(
        id: "123",
        name: "House Keys",
        location: "Kitchen Counter",
        ownerId: "owner-1",
        timestamp: Date().addingTimeInterval(-3600),
        photoUrl: nil,
        isFavorite: true
    )
    return NavigationView {
        EditItemView(item: sampleItem, viewModel: ItemViewModel())
    }
}
