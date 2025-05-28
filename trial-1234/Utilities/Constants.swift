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
    
    // Colors - Using Theme.Colors instead of redefining
    struct Colors {
        static let darkBackground = Theme.Colors.cardBackground
        static let lightBackground = Theme.Colors.cardBackground.opacity(0.7)
        static let primaryPurple = Theme.Colors.primary
        static let lightPurple = Theme.Colors.primaryLight
        static let peach = Theme.Colors.accentLight
        static let teal = Theme.Colors.accent
        static let orange = Theme.Colors.accent
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
