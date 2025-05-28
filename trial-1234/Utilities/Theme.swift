import SwiftUI

struct Theme {
    // MARK: - Colors
    struct Colors {
        // Background Colors
        static let backgroundStart = Color.black      // Pure black at the top
        static let backgroundEnd = Color(hex: "#2D2D2D")  // Dark gray at the bottom
        
        // Text Colors
        static let textPrimary = Color(hex: "#E5E5E5")  // Bright white-grey for primary text
        static let textSecondary = Color(hex: "#A0A0A0") // Medium-light grey for secondary text
        static let textTertiary = Color(hex: "#666666")  // Medium grey for tertiary text
        
        // UI Elements
        static let cardBackground = Color(hex: "#1F1F1F")  // Slightly lighter than background
        static let divider = Color.white.opacity(0.15)
        
        // Interactive Elements
        static let primaryButton = Color(hex: "#333333")  // Dark grey for buttons
        static let primaryButtonHighlight = Color(hex: "#4A4A4A")  // Lighter grey for button hover
        static let primaryButtonActive = Color.white      // White for button active state
        
        // Icons
        static let iconDefault = Color(hex: "#B0B0B0")    // Light grey for icons
        static let iconActive = Color.white               // White for active icons
        
        // Toggles
        static let toggleTrackOff = Color(hex: "#333333")
        static let toggleThumbOff = Color(hex: "#666666")
        static let toggleTrackOn = Color.white
        static let toggleThumbOn = Color.black
        
        // Status
        static let error = Color(hex: "#808080")         // Medium grey for errors
        static let success = Color(hex: "#A0A0A0")       // Light grey for success
        static let warning = Color(hex: "#8C8C8C")       // Slightly darker grey for warnings
        
        // Map
        static let mapPin = Color(hex: "#B0B0B0")
        static let mapPinSelected = Color.white
        static let clusterBackground = Color(hex: "#666666")
        
        // Graph Elements
        static let graphBar = Color(hex: "#666666")
        static let graphBarActive = Color.white
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        static let footnote = Font.system(size: 13, weight: .regular, design: .rounded)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .rounded)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
        static let xxlarge: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
        static let circle: CGFloat = .infinity
    }
    
    // MARK: - Shadow
    enum Shadow {
        case small
        case medium
        case large
        
        var radius: CGFloat {
            switch self {
            case .small: return 2
            case .medium: return 6
            case .large: return 12
            }
        }
        
        var offset: CGSize {
            switch self {
            case .small: return CGSize(width: 0, height: 1)
            case .medium: return CGSize(width: 0, height: 4)
            case .large: return CGSize(width: 0, height: 8)
            }
        }
        
        var opacity: Double {
            switch self {
            case .small: return 0.1
            case .medium: return 0.15
            case .large: return 0.2
            }
        }
    }
}

// MARK: - Shadow Extension
extension View {
    func shadow(_ shadow: Theme.Shadow) -> some View {
        self.shadow(
            color: Color.black.opacity(shadow.opacity),
            radius: shadow.radius,
            x: shadow.offset.width,
            y: shadow.offset.height
        )
    }
}

