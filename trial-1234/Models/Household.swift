import Foundation

struct Household: Identifiable, Codable {
    var id: String
    var name: String
    var memberIds: [String]
    var sharedItemIds: [String]
    
    init(id: String = UUID().uuidString, name: String, memberIds: [String] = [], sharedItemIds: [String] = []) {
        self.id = id
        self.name = name
        self.memberIds = memberIds
        self.sharedItemIds = sharedItemIds
    }
}
