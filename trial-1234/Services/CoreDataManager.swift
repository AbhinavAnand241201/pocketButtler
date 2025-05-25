import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "PocketButler")
        
        // Configure persistent store
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        // Create background context for async operations
        backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Context Management
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving view context: \(error)")
            }
        }
    }
    
    func saveBackgroundContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving background context: \(error)")
            }
        }
    }
    
    // MARK: - Item Operations
    
    func saveItem(_ item: Item) {
        backgroundContext.perform {
            let cachedItem = CachedItem(context: self.backgroundContext)
            cachedItem.id = item.id
            cachedItem.name = item.name
            cachedItem.location = item.location
            cachedItem.ownerId = item.ownerId
            cachedItem.timestamp = item.timestamp
            cachedItem.photoUrl = item.photoUrl
            cachedItem.isFavorite = item.isFavorite
            cachedItem.syncStatus = "synced"
            
            self.saveBackgroundContext()
        }
    }
    
    func updateItem(_ item: Item) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedItem = results.first {
                    cachedItem.name = item.name
                    cachedItem.location = item.location
                    cachedItem.ownerId = item.ownerId
                    cachedItem.timestamp = item.timestamp
                    cachedItem.photoUrl = item.photoUrl
                    cachedItem.isFavorite = item.isFavorite
                    cachedItem.syncStatus = "synced"
                    
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
    }
    
    func deleteItem(id: String) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedItem = results.first {
                    self.backgroundContext.delete(cachedItem)
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    func fetchItems() -> [Item] {
        let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CachedItem.timestamp, ascending: false)]
        
        do {
            let cachedItems = try viewContext.fetch(fetchRequest)
            return cachedItems.map { cachedItem in
                Item(
                    id: cachedItem.id ?? "",
                    name: cachedItem.name ?? "",
                    location: cachedItem.location ?? "",
                    ownerId: cachedItem.ownerId ?? "",
                    timestamp: cachedItem.timestamp ?? Date(),
                    photoUrl: cachedItem.photoUrl,
                    isFavorite: cachedItem.isFavorite
                )
            }
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    // MARK: - Reminder Operations
    
    func saveReminder(_ reminder: Reminder) {
        backgroundContext.perform {
            let cachedReminder = CachedReminder(context: self.backgroundContext)
            cachedReminder.id = reminder.id
            cachedReminder.title = reminder.title
            cachedReminder.itemName = reminder.itemName
            cachedReminder.time = reminder.time
            cachedReminder.isLocationBased = reminder.isLocationBased
            cachedReminder.location = reminder.location
            cachedReminder.isRepeating = reminder.isRepeating
            cachedReminder.repeatDays = reminder.repeatDays
            cachedReminder.isEnabled = reminder.isEnabled
            cachedReminder.syncStatus = "synced"
            
            self.saveBackgroundContext()
        }
    }
    
    func updateReminder(_ reminder: Reminder) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedReminder> = CachedReminder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", reminder.id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedReminder = results.first {
                    cachedReminder.title = reminder.title
                    cachedReminder.itemName = reminder.itemName
                    cachedReminder.time = reminder.time
                    cachedReminder.isLocationBased = reminder.isLocationBased
                    cachedReminder.location = reminder.location
                    cachedReminder.isRepeating = reminder.isRepeating
                    cachedReminder.repeatDays = reminder.repeatDays
                    cachedReminder.isEnabled = reminder.isEnabled
                    cachedReminder.syncStatus = "synced"
                    
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error updating reminder: \(error)")
            }
        }
    }
    
    func deleteReminder(id: String) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedReminder> = CachedReminder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedReminder = results.first {
                    self.backgroundContext.delete(cachedReminder)
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error deleting reminder: \(error)")
            }
        }
    }
    
    func fetchReminders() -> [Reminder] {
        let fetchRequest: NSFetchRequest<CachedReminder> = CachedReminder.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CachedReminder.time, ascending: true)]
        
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
                    repeatDays: cachedReminder.repeatDays ?? [],
                    isEnabled: cachedReminder.isEnabled
                )
            }
        } catch {
            print("Error fetching reminders: \(error)")
            return []
        }
    }
    
    // MARK: - User Operations
    
    func saveUser(_ user: User) {
        backgroundContext.perform {
            let cachedUser = CachedUser(context: self.backgroundContext)
            cachedUser.id = user.id
            cachedUser.name = user.name
            cachedUser.email = user.email
            cachedUser.isPremium = user.isPremium
            cachedUser.syncStatus = "synced"
            
            self.saveBackgroundContext()
        }
    }
    
    func updateUser(_ user: User) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", user.id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedUser = results.first {
                    cachedUser.name = user.name
                    cachedUser.email = user.email
                    cachedUser.isPremium = user.isPremium
                    cachedUser.syncStatus = "synced"
                    
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error updating user: \(error)")
            }
        }
    }
    
    func fetchUser(id: String) -> User? {
        let fetchRequest: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let cachedUser = results.first {
                return User(
                    id: cachedUser.id ?? "",
                    email: cachedUser.email ?? "",
                    name: cachedUser.name ?? "",
                    isPremium: cachedUser.isPremium
                )
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return nil
    }
    
    // MARK: - Sync Operations
    
    func getUnsyncedItems() -> [Item] {
        let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "syncStatus != %@", "synced")
        
        do {
            let cachedItems = try viewContext.fetch(fetchRequest)
            return cachedItems.map { cachedItem in
                Item(
                    id: cachedItem.id ?? "",
                    name: cachedItem.name ?? "",
                    location: cachedItem.location ?? "",
                    ownerId: cachedItem.ownerId ?? "",
                    timestamp: cachedItem.timestamp ?? Date(),
                    photoUrl: cachedItem.photoUrl,
                    isFavorite: cachedItem.isFavorite
                )
            }
        } catch {
            print("Error fetching unsynced items: \(error)")
            return []
        }
    }
    
    func markItemAsSynced(id: String) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try self.backgroundContext.fetch(fetchRequest)
                if let cachedItem = results.first {
                    cachedItem.syncStatus = "synced"
                    self.saveBackgroundContext()
                }
            } catch {
                print("Error marking item as synced: \(error)")
            }
        }
    }
    
    // MARK: - Reminder Sync Operations
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
                    repeatDays: cachedReminder.repeatDays ?? [],
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