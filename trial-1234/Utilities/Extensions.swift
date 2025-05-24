import Foundation
import SwiftUI

// Color extension to support hex color codes
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// View extension for reusable modifiers
extension View {
    // Standard text field style
    func standardTextFieldStyle() -> some View {
        self
            .padding()
            .background(Constants.Colors.lightBackground)
            .cornerRadius(Constants.Dimensions.cornerRadius)
            .foregroundColor(.white)
    }
    
    // Standard button style
    func standardButtonStyle() -> some View {
        self
            .frame(height: Constants.Dimensions.buttonHeight)
            .background(Constants.Colors.primaryPurple)
            .cornerRadius(Constants.Dimensions.buttonCornerRadius)
            .foregroundColor(.white)
            .font(.system(size: Constants.FontSizes.button, weight: .bold))
    }
    
    // Secondary button style
    func secondaryButtonStyle() -> some View {
        self
            .frame(height: Constants.Dimensions.buttonHeight)
            .background(Constants.Colors.lightBackground)
            .cornerRadius(Constants.Dimensions.cornerRadius)
            .foregroundColor(.white)
            .font(.system(size: Constants.FontSizes.body, weight: .regular))
    }
}

// Date extension for relative time formatting
extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
