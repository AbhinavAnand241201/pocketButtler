//
//  ContentView.swift
//  trial-1234
//
//  Created by ABHINAV ANAND  on 24/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            // App flow
            if !hasCompletedOnboarding {
                OnboardingView()
                    .onDisappear {
                        hasCompletedOnboarding = true
                    }
            } else if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Check if user is already logged in
            authViewModel.checkAuthStatus()
        }
    }
}

#Preview {
    ContentView()
}
