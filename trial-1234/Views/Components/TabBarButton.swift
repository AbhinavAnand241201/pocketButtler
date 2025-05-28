import SwiftUI

struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? Theme.Colors.primaryButton : Theme.Colors.textSecondary)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? Theme.Colors.primaryButton : Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        HStack {
            TabBarButton(icon: "house.fill", text: "Home", isSelected: true)
            TabBarButton(icon: "map.fill", text: "Map", isSelected: false)
        }
    }
}
