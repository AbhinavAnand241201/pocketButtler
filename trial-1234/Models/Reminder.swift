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
    let id: String
    let title: String
    let itemName: String
    let time: Date
    let isLocationBased: Bool
    let location: String?
    let isRepeating: Bool
    let repeatDays: [Int] // 1-7 for days of week
    var isEnabled: Bool = true
} 