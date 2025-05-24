import Foundation
import UserNotifications
import CoreLocation

class NotificationService {
    static let shared = NotificationService()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let locationManager = CLLocationManager()
    
    private init() {
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // meters
    }
    
    func requestPermissions() {
        // Request notification permissions
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
        
        // Request location permissions
        locationManager.requestAlwaysAuthorization()
    }
    
    func scheduleItemReminder(item: Item) {
        let content = UNMutableNotificationContent()
        content.title = "Don't forget your \(item.name)"
        content.body = "Last seen at: \(item.location)"
        content.sound = .default
        
        // Schedule for 1 minute from now (for testing)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "item-reminder-\(item.id)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func setupGeofencingForHome(latitude: Double, longitude: Double) {
        // Create a region centered on "home"
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: 100, identifier: "home")
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
    }
    
    func sendGeofencingAlert(itemName: String, location: String) {
        let content = UNMutableNotificationContent()
        content.title = "Did you forget your \(itemName)?"
        content.body = "Last seen at: \(location)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "geofence-alert-\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error sending geofencing alert: \(error.localizedDescription)")
            }
        }
    }
}
