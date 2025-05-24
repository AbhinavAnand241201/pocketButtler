import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var name: String
    var householdId: String?
    var isPremium: Bool
    
    init(id: String = UUID().uuidString, email: String, name: String, householdId: String? = nil, isPremium: Bool = false) {
        self.id = id
        self.email = email
        self.name = name
        self.householdId = householdId
        self.isPremium = isPremium
    }
}
