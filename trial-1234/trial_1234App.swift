import SwiftUI

@main
struct trial_1234App: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var itemViewModel = ItemViewModel()
    @StateObject private var reminderViewModel = ReminderViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(itemViewModel)
                    .environmentObject(reminderViewModel)
            } else {
                OnboardingView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
