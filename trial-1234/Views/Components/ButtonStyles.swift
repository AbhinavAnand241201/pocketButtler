import SwiftUI

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Theme.Colors.textPrimary)
            .background(Theme.Colors.primary)
            .cornerRadius(Theme.CornerRadius.medium)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Theme.Colors.primary)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Theme.Colors.primary, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Text Button Style
struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Theme.Colors.primary)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style
struct IconButtonStyle: ButtonStyle {
    let size: CGFloat
    let backgroundColor: Color
    
    init(size: CGFloat = 44, backgroundColor: Color = Theme.Colors.cardBackground) {
        self.size = size
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Floating Action Button Style
struct FABStyle: ButtonStyle {
    let size: CGFloat = 56
    let backgroundColor: Color = Theme.Colors.primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: backgroundColor.opacity(0.3), radius: 10, x: 0, y: 6)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview Provider
struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 200, height: 44)
            
            Button("Secondary Button") {}
                .buttonStyle(SecondaryButtonStyle())
                .frame(width: 200, height: 44)
            
            Button("Text Button") {}
                .buttonStyle(TextButtonStyle())
            
            Button {
                // Action
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
            }
            .buttonStyle(IconButtonStyle())
            
            Button {
                // Action
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
            }
            .buttonStyle(FABStyle())
        }
        .padding()
        .background(Theme.Colors.background)
        .previewLayout(.sizeThatFits)
    }
}
