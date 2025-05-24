import Foundation
import Combine
import SwiftUI
import MapKit

// A preview-friendly version of ItemViewModel that uses mock data
class PreviewItemViewModel: ItemViewModel {
    // No need to redeclare published properties as they're inherited from ItemViewModel
    
    // Override the isPreview property
    override var isPreview: Bool {
        return true
    }
    
    override init() {
        super.init()
        // Initialize with mock data
        self.items = MockAPIService.shared.mockItems
        self.favoriteItems = MockAPIService.shared.mockItems.filter { $0.isFavorite }
    }
    
    // Override add item method
    override func addItem(item: Item) {
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
    
    // Override delete item method
    override func deleteItem(_ item: Item) {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.items.removeAll { $0.id == item.id }
            self.favoriteItems.removeAll { $0.id == item.id }
            self.isLoading = false
        }
    }
    
    // Override toggle favorite method
    override func toggleFavorite(for item: Item) {
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
