import SwiftUI

// This is a placeholder for the actual widget implementation
// In a real app, we would create a proper widget extension
struct WidgetView: View {
    @State private var itemName = "Keys"
    @State private var location = "Living Room"
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Quick Log")
                .font(.system(size: Constants.FontSizes.title, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 8)
            
            // Item name field
            TextField("Item Name", text: $itemName)
                .padding()
                .background(Color(hex: "2E2E4A"))
                .foregroundColor(.white)
                .cornerRadius(Constants.Dimensions.cornerRadius)
            
            // Location field
            TextField("Location", text: $location)
                .padding()
                .background(Color(hex: "2E2E4A"))
                .foregroundColor(.white)
                .cornerRadius(Constants.Dimensions.cornerRadius)
            
            // Log Item button
            Button(action: {
                // Log item logic would go here
                print("Logging item: \(itemName) at \(location)")
            }) {
                Text("Log Item")
                    .font(.system(size: Constants.FontSizes.button, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.Colors.primaryPurple)
                    .cornerRadius(Constants.Dimensions.buttonCornerRadius)
            }
            
            // Note text
            Text("Note: In a real app, this would be implemented as a proper widget extension using WidgetKit")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Constants.Colors.darkBackground)
        .cornerRadius(16)
        .frame(height: 300)
    }
}

#Preview {
    WidgetView()
}
