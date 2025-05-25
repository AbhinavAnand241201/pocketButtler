import Foundation
import Combine
import UserNotifications

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
        
        apiService.request(endpoint: .reminders, method: .get)
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
        apiService.request(endpoint: .reminders, method: .post, body: reminder)
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
        updateReminderOnServer(reminder)
    }
    
    private func updateReminderOnServer(_ reminder: Reminder) {
        apiService.request(endpoint: .reminders, method: .put, body: reminder)
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
        apiService.request(endpoint: .reminders, method: .delete, body: reminder)
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
            } receiveValue: { _ in
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
            // Create a geofence trigger
            let region = CLCircularRegion(
                center: location.coordinate,
                radius: 100, // 100 meters radius
                identifier: reminder.id
            )
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            trigger = UNLocationNotificationTrigger(region: region, repeats: false)
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

// MARK: - CoreDataManager Extension
extension CoreDataManager {
    func getUnsyncedReminders() -> [Reminder] {
        let fetchRequest: NSFetchRequest<CachedReminder> = CachedReminder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "syncStatus != %@", "synced")
        
        do {
            let cachedReminders = try viewContext.fetch(fetchRequest)
            return cachedReminders.map { cachedReminder in
                Reminder(
                    id: cachedReminder.id ?? "",
                    title: cachedReminder.title ?? "",
                    itemName: cachedReminder.itemName ?? "",
                    time: cachedReminder.time ?? Date(),
                    isLocationBased: cachedReminder.isLocationBased,
                    location: cachedReminder.location,
                    isRepeating: cachedReminder.isRepeating,
                    repeatDays: (cachedReminder.repeatDays as? [Int]) ?? [],
                    isEnabled: cachedReminder.isEnabled
                )
            }
        } catch {
            print("Error fetching unsynced reminders: \(error)")
            return []
        }
    }
    
    func markReminderAsSynced(id: String) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedReminder> = CachedReminder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedReminder = results.first {
                    cachedReminder.syncStatus = "synced"
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error marking reminder as synced: \(error)")
            }
        }
    }
} 