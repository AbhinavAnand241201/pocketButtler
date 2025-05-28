import SwiftUI

struct Theme {
    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primary = Color(hex: "#7C3AED")  // Rich Violet
        static let primaryLight = Color(hex: "#A78BFA")
        static let primaryDark = Color(hex: "#5B21B6")
        
        // Accent Colors
        static let accent = Color(hex: "#FBBF24")  // Bright Amber
        static let accentLight = Color(hex: "#FCD34D")
        
        // Background Colors
        static let background = LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#2A2A4A"),  // Dark purplish navy
                Color(hex: "#4B3A7A")   // Muted purple with warmth
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Text Colors
        static let textPrimary = Color.white
        static let textSecondary = Color(hex: "#D1D5DB")  // Light Gray
        static let textTertiary = Color(hex: "#9CA3AF")   // Lighter Gray
        
        // UI Elements
        static let cardBackground = Color(hex: "#1F2937").opacity(0.8)
        static let divider = Color.white.opacity(0.2)
        static let error = Color(hex: "#EF4444")  // Soft Red
        static let success = Color(hex: "#10B981")  // Emerald
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

