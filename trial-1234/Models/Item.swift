import Foundation

struct Item: Identifiable, Codable {
    var id: String
    var name: String
    var location: String
    var ownerId: String
    var timestamp: Date
    var photoUrl: String?
    var isFavorite: Bool
    
    init(id: String = UUID().uuidString, name: String, location: String, ownerId: String, timestamp: Date = Date(), photoUrl: String? = nil, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.location = location
        self.ownerId = ownerId
        self.timestamp = timestamp
        self.photoUrl = photoUrl
        self.isFavorite = isFavorite
    }
}
