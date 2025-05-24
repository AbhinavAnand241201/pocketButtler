import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initialize with sample data for now
        self.categories = [
            Category(id: "1", name: "Electronics", icon: "laptopcomputer", color: .blue),
            Category(id: "2", name: "Documents", icon: "doc.fill", color: .green),
            Category(id: "3", name: "Keys", icon: "key.fill", color: .yellow),
            Category(id: "4", name: "Accessories", icon: "eyeglasses", color: .purple),
            Category(id: "5", name: "Clothing", icon: "tshirt.fill", color: .red),
            Category(id: "6", name: "Wallet", icon: "creditcard.fill", color: .orange)
        ]
    }
    
    func fetchCategories() {
        // In a real app, this would fetch from an API
        isLoading = true
        error = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            // Data is already loaded in init for demo purposes
        }
    }
    
    func addCategory(category: Category) {
        // In a real app, this would call an API
        isLoading = true
        error = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.categories.append(category)
            self.isLoading = false
        }
    }
    
    func updateCategory(category: Category) {
        // In a real app, this would call an API
        isLoading = true
        error = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if let index = self.categories.firstIndex(where: { $0.id == category.id }) {
                self.categories[index] = category
            }
            self.isLoading = false
        }
    }
    
    func deleteCategory(id: String) {
        // In a real app, this would call an API
        isLoading = true
        error = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.categories.removeAll { $0.id == id }
            self.isLoading = false
        }
    }
}
