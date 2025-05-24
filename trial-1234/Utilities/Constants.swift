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
    
    // Colors
    struct Colors {
        static let darkBackground = Color(hex: "1A1A2E")
        static let lightBackground = Color(hex: "2E2E4A")
        static let primaryPurple = Color(hex: "6A5ACD")
        static let lightPurple = Color(hex: "A8A8FF")
        static let peach = Color(hex: "FFE5D9")
        static let teal = Color(hex: "20B2AA")
        static let orange = Color(hex: "FFA500")
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
