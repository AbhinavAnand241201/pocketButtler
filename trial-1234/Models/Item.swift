import Foundation
import CoreLocation
import MapKit

struct Item: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var location: String
    var ownerId: String
    var timestamp: Date
    var photoUrl: String?
    var isFavorite: Bool
    var latitude: Double?
    var longitude: Double?
    
    var coordinates: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    init(id: String = UUID().uuidString, name: String, location: String, ownerId: String = "", timestamp: Date = Date(), photoUrl: String? = nil, isFavorite: Bool = false, coordinates: CLLocationCoordinate2D? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.ownerId = ownerId
        self.timestamp = timestamp
        self.photoUrl = photoUrl
        self.isFavorite = isFavorite
        self.latitude = coordinates?.latitude
        self.longitude = coordinates?.longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, location, ownerId, timestamp, photoUrl, isFavorite, latitude, longitude
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
