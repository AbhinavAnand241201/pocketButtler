import Foundation
import Combine
import UserNotifications
import CoreLocation
import CoreData

class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService: APIService
    private var cancellables = Set<AnyCancellable>()
    private var syncTimer: Timer?
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
        
        // Load reminders from CoreData
        loadRemindersFromCache()
        
        // Start sync timer
        startSyncTimer()
        
        // Observe network status
        NotificationCenter.default.publisher(for: .networkStatusChanged)
            .sink { [weak self] notification in
                if let isConnected = notification.userInfo?["isConnected"] as? Bool {
                    if isConnected {
                        self?.syncWithServer()
                    }
                }
            }
            .store(in: &cancellables)
        
        // Request notification permissions
        requestNotificationPermissions()
    }
    
    deinit {
        syncTimer?.invalidate()
    }
    
    private func startSyncTimer() {
        syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.syncWithServer()
        }
    }
    
    private func loadRemindersFromCache() {
        reminders = CoreDataManager.shared.fetchReminders()
    }
    
    private func syncWithServer() {
        // First, try to sync any local changes
        let unsyncedReminders = CoreDataManager.shared.getUnsyncedReminders()
        for reminder in unsyncedReminders {
            updateReminderOnServer(reminder)
        }
        
        // Then fetch latest reminders from server
        fetchReminders()
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    func fetchReminders() {
        isLoading = true
        error = nil
        
        apiService.request(endpoint: "/reminders", method: "GET")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] (reminders: [Reminder]) in
                // Update CoreData with new reminders
                for reminder in reminders {
                    CoreDataManager.shared.saveReminder(reminder)
                }
                self?.loadRemindersFromCache()
            }
            .store(in: &cancellables)
    }
    
    func addReminder(_ reminder: Reminder) {
        // First save to CoreData with unsynced status
        var unsyncedReminder = reminder
        CoreDataManager.shared.saveReminder(unsyncedReminder)
        loadRemindersFromCache()
        
        // Schedule local notification
        scheduleNotification(for: reminder)
        
        // Then try to sync with server
        let reminderDict: [String: Any] = [
            "id": reminder.id,
            "title": reminder.title,
            "itemName": reminder.itemName,
            "time": ISO8601DateFormatter().string(from: reminder.time),
            "isLocationBased": reminder.isLocationBased,
            "location": reminder.location as Any,
            "isRepeating": reminder.isRepeating,
            "repeatDays": reminder.repeatDays,
            "isEnabled": reminder.isEnabled
        ]
        apiService.request(endpoint: "/reminders", method: "POST", body: reminderDict)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] (savedReminder: Reminder) in
                // Update CoreData with synced reminder
                CoreDataManager.shared.updateReminder(savedReminder)
                self?.loadRemindersFromCache()
            }
            .store(in: &cancellables)
    }
    
    func updateReminder(_ reminder: Reminder) {
        // First update in CoreData
        CoreDataManager.shared.updateReminder(reminder)
        loadRemindersFromCache()
        
        // Update local notification
        updateNotification(for: reminder)
        
        // Then try to sync with server
        let reminderDict: [String: Any] = [
            "id": reminder.id,
            "title": reminder.title,
            "itemName": reminder.itemName,
            "time": ISO8601DateFormatter().string(from: reminder.time),
            "isLocationBased": reminder.isLocationBased,
            "location": reminder.location as Any,
            "isRepeating": reminder.isRepeating,
            "repeatDays": reminder.repeatDays,
            "isEnabled": reminder.isEnabled
        ]
        apiService.request(endpoint: "/reminders", method: "PUT", body: reminderDict)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] (updatedReminder: Reminder) in
                // Update CoreData with synced reminder
                CoreDataManager.shared.updateReminder(updatedReminder)
                self?.loadRemindersFromCache()
            }
            .store(in: &cancellables)
    }
    
    private func updateReminderOnServer(_ reminder: Reminder) {
        let reminderDict: [String: Any] = [
            "id": reminder.id,
            "title": reminder.title,
            "itemName": reminder.itemName,
            "time": ISO8601DateFormatter().string(from: reminder.time),
            "isLocationBased": reminder.isLocationBased,
            "location": reminder.location as Any,
            "isRepeating": reminder.isRepeating,
            "repeatDays": reminder.repeatDays,
            "isEnabled": reminder.isEnabled
        ]
        apiService.request(endpoint: "/reminders", method: "PUT", body: reminderDict)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] (updatedReminder: Reminder) in
                // Update CoreData with synced reminder
                CoreDataManager.shared.updateReminder(updatedReminder)
                self?.loadRemindersFromCache()
            }
            .store(in: &cancellables)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        // First delete from CoreData
        CoreDataManager.shared.deleteReminder(id: reminder.id)
        loadRemindersFromCache()
        
        // Remove local notification
        removeNotification(for: reminder)
        
        // Then try to sync with server
        let reminderDict: [String: Any] = [
            "id": reminder.id
        ]
        apiService.request(endpoint: "/reminders", method: "DELETE", body: reminderDict)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                    // If delete failed on server, restore the reminder in CoreData
                    CoreDataManager.shared.saveReminder(reminder)
                    self?.loadRemindersFromCache()
                    // Reschedule notification
                    self?.scheduleNotification(for: reminder)
                }
            } receiveValue: { (_: EmptyResponse) in
                // Delete successful on server, no need to do anything
            }
            .store(in: &cancellables)
    }
    
    func toggleReminder(_ reminder: Reminder) {
        var updatedReminder = reminder
        updatedReminder.isEnabled.toggle()
        
        if updatedReminder.isEnabled {
            scheduleNotification(for: updatedReminder)
        } else {
            removeNotification(for: updatedReminder)
        }
        
        updateReminder(updatedReminder)
    }
    
    // MARK: - Notification Management
    
    private func scheduleNotification(for reminder: Reminder) {
        guard reminder.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = "Time to check your \(reminder.itemName)"
        content.sound = .default
        
        var trigger: UNNotificationTrigger?
        
        if reminder.isLocationBased, let location = reminder.location {
            // TODO: Convert location string to coordinates using geocoding or a lookup table
            // For now, skip geofence trigger if coordinates are not available
            // let region = CLCircularRegion(center: location.coordinate, ...)
            // trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        } else {
            // Create a time-based trigger
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: reminder.isRepeating)
        }
        
        let request = UNNotificationRequest(
            identifier: reminder.id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func updateNotification(for reminder: Reminder) {
        // Remove existing notification
        removeNotification(for: reminder)
        
        // Schedule new notification if enabled
        if reminder.isEnabled {
            scheduleNotification(for: reminder)
        }
    }
    
    private func removeNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [reminder.id])
    }
} 