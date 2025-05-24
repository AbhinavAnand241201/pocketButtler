import Foundation
import Combine

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var favoriteItems: [Item] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    // Fetch all items for the current user
    func fetchItems() {
        isLoading = true
        error = nil
        
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
    
    // Add a new item
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
            isFavorite: !item.isFavorite
        )
        
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
