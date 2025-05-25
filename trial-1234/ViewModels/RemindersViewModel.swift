import Foundation

class RemindersViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    private let remindersKey = "savedReminders"
    
    init() {
        loadReminders()
    }
    
    func addReminder(_ reminder: Reminder) {
        var newReminder = reminder
        if newReminder.id.isEmpty {
            newReminder.id = UUID().uuidString
        }
        reminders.append(newReminder)
        saveReminders()
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        saveReminders()
    }
    
    func toggleReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            var updatedReminder = reminder
            updatedReminder.isEnabled.toggle()
            reminders[index] = updatedReminder
            saveReminders()
        }
    }
    
    // MARK: - Persistence
    
    private func saveReminders() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            UserDefaults.standard.set(data, forKey: remindersKey)
        } catch {
            print("Failed to save reminders: \(error)")
        }
    }
    
    private func loadReminders() {
        guard let data = UserDefaults.standard.data(forKey: remindersKey) else {
            #if DEBUG
            loadSampleReminders()
            #endif
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let savedReminders = try decoder.decode([Reminder].self, from: data)
            self.reminders = savedReminders
        } catch {
            print("Failed to load reminders: \(error)")
            #if DEBUG
            loadSampleReminders()
            #endif
        }
    }
    
    private func loadSampleReminders() {
        // Sample data for preview
        reminders = [
            Reminder(id: "1", 
                    title: "Take Keys", 
                    itemName: "House Keys", 
                    time: Date().addingTimeInterval(3600), 
                    isLocationBased: false, 
                    location: nil, 
                    isRepeating: false, 
                    repeatDays: []),
            
            Reminder(id: "2", 
                    title: "Grab Laptop", 
                    itemName: "MacBook Pro", 
                    time: Date().addingTimeInterval(7200), 
                    isLocationBased: true, 
                    location: "When leaving home", 
                    isRepeating: true, 
                    repeatDays: [1, 2, 3, 4, 5])
        ]
        saveReminders()
    }
}
