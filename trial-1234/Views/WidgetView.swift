import SwiftUI

// This is a placeholder for the actual widget implementation
// In a real app, we would create a proper widget extension
struct WidgetView: View {
    @State private var itemName = "Keys"
    @State private var location = "Living Room"
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background for entire screen
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Title
                Text("Quick Log")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 16)
                
                // Item name field
                TextField("Item Name", text: $itemName)
                    .font(.system(size: 18))
                    .padding(16)
                    .background(Theme.Colors.cardBackground)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                
                // Location field
                TextField("Location", text: $location)
                    .font(.system(size: 18))
                    .padding(16)
                    .background(Theme.Colors.cardBackground)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                
                // Log Item button
                Button(action: {
                    // Log item logic would go here
                    print("Logging item: \(itemName) at \(location)")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Log Item")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Theme.Colors.primaryButton)
                        .cornerRadius(Constants.Dimensions.buttonCornerRadius)
                }
                
                // Note text
                Text("Note: In a real app, this would be implemented as a proper widget extension using WidgetKit")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .padding(.top, 8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
    }
}

#Preview {
    WidgetView()
}
