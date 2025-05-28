import Foundation
import SwiftUI

struct Constants {
    // API URLs
    struct API {
        static let baseURL = "http://localhost:3000/api"
        static let authEndpoint = "\(baseURL)/auth"
        static let itemsEndpoint = "\(baseURL)/items"
        static let householdEndpoint = "\(baseURL)/household"
    }
    
    // MARK: - Colors
    struct Colors {
        // Background views
        static var darkBackground: some View {
            LinearGradient(
                gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        // Light background (deprecated, use cardBackground instead)
        static var lightBackground: some View {
            Theme.Colors.cardBackground
                .cornerRadius(Constants.Dimensions.cornerRadius)
        }
        
        // Card background
        static var cardBackground: some View {
            Theme.Colors.cardBackground
                .cornerRadius(Constants.Dimensions.cornerRadius)
        }
        
        // Text styles
        static let primaryText = Theme.Colors.textPrimary
        static let secondaryText = Theme.Colors.textSecondary
        static let tertiaryText = Theme.Colors.textTertiary
        
        // Buttons
        static let primaryButton = Theme.Colors.primaryButton
        static let primaryButtonHighlight = Theme.Colors.primaryButtonHighlight
        static let primaryButtonActive = Theme.Colors.primaryButtonActive
        
        // Legacy color properties for backward compatibility
        static let primaryPurple = Theme.Colors.primaryButton
        static let lightPurple = Theme.Colors.iconDefault
        static let lightBackgroundColor = Theme.Colors.cardBackground
        
        // Icons
        static let iconDefault = Theme.Colors.iconDefault
        static let iconActive = Theme.Colors.iconActive
        
        // Status
        static let error = Theme.Colors.error
        static let success = Theme.Colors.success
        static let warning = Theme.Colors.warning
        
        // Helper function to get background based on light/dark mode
        static func background(isLight: Bool = false) -> some View {
            isLight ? AnyView(lightBackground) : AnyView(darkBackground)
        }
        
        // Background View
        struct BackgroundView: View {
            var body: some View {
                darkBackground
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // Dimensions
    struct Dimensions {
        static let cornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 24
        static let standardPadding: CGFloat = 16
        static let buttonHeight: CGFloat = 50
    }
    
    // Font Sizes
    struct FontSizes {
        static let title: CGFloat = 24
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let button: CGFloat = 18
    }
}
