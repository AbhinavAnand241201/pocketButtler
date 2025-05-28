import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundView()
}
