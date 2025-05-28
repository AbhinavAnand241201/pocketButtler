import SwiftUI

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(configuration.isPressed ? .black : Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Group {
                    if isEnabled {
                        configuration.isPressed ? 
                            Theme.Colors.primaryButtonActive : 
                            Theme.Colors.primaryButton
                    } else {
                        Theme.Colors.primaryButton.opacity(0.6)
                    }
                }
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.Colors.textPrimary.opacity(0.5), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.Colors.cardBackground.opacity(configuration.isPressed ? 0.5 : 0))
                    )
            )
            .opacity(isEnabled ? 1.0 : 0.6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Text Button Style
struct TextButtonStyle: ButtonStyle {
    let isUnderlined: Bool
    
    init(underlined: Bool = true) {
        self.isUnderlined = underlined
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Theme.Colors.textSecondary)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .overlay(
                isUnderlined ? 
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .offset(y: 8) :
                    nil,
                alignment: .bottom
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Toggle Style
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(Theme.Colors.textPrimary)
                .font(.system(size: 16))
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    configuration.isOn ? 
                        Theme.Colors.toggleTrackOn : 
                        Theme.Colors.toggleTrackOff
                )
                .frame(width: 50, height: 32)
                .overlay(
                    Circle()
                        .fill(
                            configuration.isOn ? 
                                Theme.Colors.toggleThumbOn : 
                                Theme.Colors.toggleThumbOff
                        )
                        .padding(4)
                        .offset(x: configuration.isOn ? 10 : -10),
                    alignment: .leading
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
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
    let backgroundColor: Color = Theme.Colors.primaryButton
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(backgroundColor)
            .foregroundColor(.black) // Black text on the white button
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)
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
        .background(Constants.Colors.darkBackground)
        .previewLayout(.sizeThatFits)
    }
}
