import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.itemName == rhs.itemName &&
        lhs.time == rhs.time &&
        lhs.isLocationBased == rhs.isLocationBased &&
        lhs.location == rhs.location &&
        lhs.isRepeating == rhs.isRepeating &&
        lhs.repeatDays == rhs.repeatDays &&
        lhs.isEnabled == rhs.isEnabled
    }
    var id: String
    var title: String
    var itemName: String
    var time: Date
    var isLocationBased: Bool
    var location: String?
    var isRepeating: Bool
    var repeatDays: [Int] // 1-7 for days of week
    var isEnabled: Bool
    
    init(id: String = UUID().uuidString, 
         title: String, 
         itemName: String, 
         time: Date, 
         isLocationBased: Bool, 
         location: String?, 
         isRepeating: Bool, 
         repeatDays: [Int], 
         isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.itemName = itemName
        self.time = time
        self.isLocationBased = isLocationBased
        self.location = location
        self.isRepeating = isRepeating
        self.repeatDays = repeatDays
        self.isEnabled = isEnabled
    }
    
    mutating func toggleEnabled() {
        isEnabled.toggle()
    }
} 