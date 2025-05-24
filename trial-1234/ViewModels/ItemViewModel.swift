import Foundation
import Combine
import CoreLocation
import MapKit

// Empty response for DELETE operations
fileprivate struct ItemEmptyResponse: Decodable {}

class ItemViewModel: ObservableObject {
    // Flag to determine if we're in preview mode
    private let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    @Published var items: [Item] = []
    @Published var favoriteItems: [Item] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    init() {
        // If in preview mode, load sample data immediately
        if isPreview {
            loadSampleData()
        }
    }
    
    // Load sample data for previews
    private func loadSampleData() {
        let sampleItems = [
            Item(
                id: "1",
                name: "House Keys",
                location: "Kitchen Counter",
                ownerId: "user123",
                timestamp: Date().addingTimeInterval(-3600),
                photoUrl: nil,
                isFavorite: true,
                coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            ),
            Item(
                id: "2",
                name: "Wallet",
                location: "Bedroom Drawer",
                ownerId: "user123",
                timestamp: Date().addingTimeInterval(-7200),
                photoUrl: nil,
                isFavorite: false,
                coordinates: CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4180)
            ),
            Item(
                id: "3",
                name: "Headphones",
                location: "Office Desk",
                ownerId: "user123",
                timestamp: Date().addingTimeInterval(-10800),
                photoUrl: nil,
                isFavorite: true,
                coordinates: CLLocationCoordinate2D(latitude: 37.7752, longitude: -122.4170)
            )
        ]
        
        self.items = sampleItems
        self.favoriteItems = sampleItems.filter { $0.isFavorite }
    }
    
    // Fetch all items for the current user
    func fetchItems() {
        isLoading = true
        error = nil
        
        if isPreview {
            // Use mock data for previews
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.loadSampleData()
                self?.isLoading = false
            }
        } else {
            // Use real API for the actual app
            apiService.request(endpoint: Constants.API.itemsEndpoint)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.error = "Failed to fetch items: \(error.localizedDescription)"
                        
                        // Load cached items if available
                        self?.loadCachedItems()
                    }
                } receiveValue: { [weak self] (fetchedItems: [Item]) in
                    self?.items = fetchedItems
                    self?.favoriteItems = fetchedItems.filter { $0.isFavorite }
                    
                    // Cache items for offline use
                    self?.cacheItems(fetchedItems)
                }
                .store(in: &cancellables)
        }
    }
    
    // Add a new item
    func addItem(item: Item) {
        isLoading = true
        error = nil
        
        if isPreview {
            // For preview mode, just add the item directly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.items.append(item)
                
                if item.isFavorite {
                    self?.favoriteItems.append(item)
                }
                
                self?.isLoading = false
            }
        } else {
            // For the real app, use the API
            let itemData: [String: Any] = [
                "name": item.name,
                "location": item.location,
                "ownerId": item.ownerId,
                "timestamp": ISO8601DateFormatter().string(from: item.timestamp),
                "photoUrl": item.photoUrl as Any,
                "isFavorite": item.isFavorite
            ]
            
            apiService.request(
                endpoint: Constants.API.itemsEndpoint,
                method: "POST",
                body: itemData
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.error = "Failed to add item: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] (newItem: Item) in
                self?.items.append(newItem)
                
                // Update cached items
                var cachedItems = self?.items ?? []
                cachedItems.append(newItem)
                self?.cacheItems(cachedItems)
                
                // Schedule a reminder notification
                NotificationService.shared.scheduleItemReminder(item: newItem)
            }
            .store(in: &cancellables)
        }
    }
    
    // Add a new item with individual parameters
    func addItem(name: String, location: String, photoUrl: String? = nil) {
        isLoading = true
        error = nil
        
        guard let currentUserId = UserDefaults.standard.string(forKey: "userId") else {
            error = "User not authenticated"
            isLoading = false
            return
        }
        
        let itemData: [String: Any] = [
            "name": name,
            "location": location,
            "ownerId": currentUserId,
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "photoUrl": photoUrl as Any,
            "isFavorite": false
        ]
        
        apiService.request(
            endpoint: Constants.API.itemsEndpoint,
            method: "POST",
            body: itemData
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            if case .failure(let error) = completion {
                self?.error = "Failed to add item: \(error.localizedDescription)"
            }
        } receiveValue: { [weak self] (newItem: Item) in
            self?.items.append(newItem)
            
            // Update cached items
            var cachedItems = self?.items ?? []
            cachedItems.append(newItem)
            self?.cacheItems(cachedItems)
            
            // Schedule a reminder notification
            NotificationService.shared.scheduleItemReminder(item: newItem)
        }
        .store(in: &cancellables)
    }
    
    // Search for items
    func searchItems(query: String) {
        isLoading = true
        error = nil
        
        let endpoint = Constants.API.itemsEndpoint + "?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        apiService.request(endpoint: endpoint)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.error = "Search failed: \(error.localizedDescription)"
                    
                    // Search in cached items if offline
                    if let cachedItems = self?.loadCachedItems() {
                        let filteredItems = cachedItems.filter { 
                            $0.name.lowercased().contains(query.lowercased()) || 
                            $0.location.lowercased().contains(query.lowercased())
                        }
                        self?.items = filteredItems
                    }
                }
            } receiveValue: { [weak self] (searchResults: [Item]) in
                self?.items = searchResults
            }
            .store(in: &cancellables)
    }
    
    // Delete an item
    func deleteItem(_ item: Item) {
        isLoading = true
        error = nil
        
        if isPreview {
            // For preview mode, just remove the item directly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                // Remove the item from the local array
                self?.items.removeAll { $0.id == item.id }
                self?.favoriteItems.removeAll { $0.id == item.id }
                self?.isLoading = false
            }
        } else {
            // For the real app, use the API
            apiService.request(
                endpoint: Constants.API.itemsEndpoint + "/\(item.id)",
                method: "DELETE",
                body: nil
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.error = "Failed to delete item: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] (_: ItemEmptyResponse) in
                // Remove the item from the local array
                self?.items.removeAll { $0.id == item.id }
                self?.favoriteItems.removeAll { $0.id == item.id }
                
                // Update cached items
                self?.cacheItems(self?.items ?? [])
            }
            .store(in: &cancellables)
        }
    }
    
    // Toggle favorite status
    func toggleFavorite(for item: Item) {
        isLoading = true
        error = nil
        
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
        
        if isPreview {
            // For preview mode, just update the item directly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                // Update local items
                if let index = self?.items.firstIndex(where: { $0.id == item.id }) {
                    self?.items[index] = updatedItem
                }
                
                // Update favorites
                self?.favoriteItems = self?.items.filter { $0.isFavorite } ?? []
                self?.isLoading = false
            }
        } else {
            // For the real app, use the API
            let itemData: [String: Any] = [
                "isFavorite": !item.isFavorite
            ]
            
            apiService.request(
                endpoint: Constants.API.itemsEndpoint + "/\(item.id)",
                method: "PATCH",
                body: itemData
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.error = "Failed to update favorite status: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] (updatedItem: Item) in
                // Update local items
                if let index = self?.items.firstIndex(where: { $0.id == item.id }) {
                    self?.items[index] = updatedItem
                }
                
                // Update favorites
                self?.favoriteItems = self?.items.filter { $0.isFavorite } ?? []
                
                // Update cached items
                self?.cacheItems(self?.items ?? [])
            }
            .store(in: &cancellables)
        }
    }
    
    // MARK: - Caching Methods
    
    private func cacheItems(_ items: [Item]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "cachedItems")
        } catch {
            print("Failed to cache items: \(error.localizedDescription)")
        }
    }
    
    private func loadCachedItems() -> [Item]? {
        guard let data = UserDefaults.standard.data(forKey: "cachedItems") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([Item].self, from: data)
            self.items = items
            return items
        } catch {
            print("Failed to load cached items: \(error.localizedDescription)")
            return nil
        }
    }
}
