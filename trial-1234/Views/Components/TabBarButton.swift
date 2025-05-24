import SwiftUI

struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(isSelected ? Constants.Colors.primaryPurple : .white.opacity(0.7))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? Constants.Colors.primaryPurple : .white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Constants.Colors.darkBackground
            .ignoresSafeArea()
        
        HStack {
            TabBarButton(icon: "house.fill", text: "Home", isSelected: true)
            TabBarButton(icon: "map.fill", text: "Map", isSelected: false)
        }
    }
}
