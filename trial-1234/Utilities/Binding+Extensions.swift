import SwiftUI

extension Binding {
    func map<T>(get: @escaping (Value) -> T, set: @escaping (T) -> Value) -> Binding<T> {
        Binding<T>(
            get: { get(wrappedValue) },
            set: { wrappedValue = set($0) }
        )
    }
}

extension Binding where Value == Reminder {
    var isEnabled: Binding<Bool> {
        map(
            get: { $0.isEnabled },
            set: { value in
                var reminder = self.wrappedValue
                reminder.isEnabled = value
                return reminder
            }
        )
    }
}
