import SwiftUI

struct VoiceLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isListening = false
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: Constants.Dimensions.standardPadding * 2) {
                // Illustration
                Image(systemName: "waveform.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(Constants.Colors.primaryPurple)
                    .padding(.bottom, Constants.Dimensions.standardPadding)
                
                // Instructions
                Text("Speak your passphrase")
                    .font(.system(size: Constants.FontSizes.title, weight: .bold))
                    .foregroundColor(.white)
                
                // Voice visualization
                HStack(spacing: 4) {
                    ForEach(0..<7) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 4, height: isListening ? CGFloat.random(in: 10...50) : 15)
                            .foregroundColor(.white)
                            .animation(
                                Animation.easeInOut(duration: 0.2)
                                    .repeatForever()
                                    .delay(Double(i) * 0.05),
                                value: isListening
                            )
                    }
                }
                .padding(.vertical, Constants.Dimensions.standardPadding)
                
                // Continue button
                Button(action: {
                    // Voice login logic would go here
                    // For now, just dismiss the view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .standardButtonStyle()
                
                // Cancel button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.top, Constants.Dimensions.standardPadding)
            }
            .padding()
            .navigationTitle("Log In Seconds")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            // Start the animation when the view appears
            isListening = true
        }
    }
}

#Preview {
    VoiceLoginView()
}
