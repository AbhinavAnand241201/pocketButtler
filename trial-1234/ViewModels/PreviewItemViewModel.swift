import Foundation
import Combine
import SwiftUI
import MapKit

// A preview-friendly version of ItemViewModel that uses mock data
class PreviewItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var favoriteItems: [Item] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initialize with mock data
        self.items = MockAPIService.shared.mockItems
        self.favoriteItems = MockAPIService.shared.mockItems.filter { $0.isFavorite }
    }
    
    // Add a new item
    func addItem(item: Item) {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.items.append(item)
            if item.isFavorite {
                self.favoriteItems.append(item)
            }
            self.isLoading = false
        }
    }
    
    // Delete an item
    func deleteItem(_ item: Item) {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.items.removeAll { $0.id == item.id }
            self.favoriteItems.removeAll { $0.id == item.id }
            self.isLoading = false
        }
    }
    
    // Toggle favorite status
    func toggleFavorite(for item: Item) {
        isLoading = true
        
        // Create updated item with toggled favorite status
        let updatedItem = Item(
            id: item.id,
            name: item.name,
            location: item.location,
            ownerId: item.ownerId,
            timestamp: item.timestamp,
            photoUrl: item.photoUrl,
            isFavorite: !item.isFavorite,
            coordinates: item.coordinates
        )
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = self.items.firstIndex(where: { $0.id == item.id }) {
                self.items[index] = updatedItem
            }
            
            // Update favorites
            self.favoriteItems = self.items.filter { $0.isFavorite }
            self.isLoading = false
        }
    }
}
