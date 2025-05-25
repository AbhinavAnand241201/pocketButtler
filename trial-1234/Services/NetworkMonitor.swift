import Network
import Foundation

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected = false
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            
            // Notify observers of network status change
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .networkStatusChanged,
                    object: nil,
                    userInfo: ["isConnected": isConnected]
                )
            }
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
} 