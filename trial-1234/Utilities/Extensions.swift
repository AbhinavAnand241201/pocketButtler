import Foundation
import SwiftUI

// Color extension to support hex color codes
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: 1.0)
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
