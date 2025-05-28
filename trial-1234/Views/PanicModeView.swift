import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    func playSound() {
        // In a real app, we would load a sound file
        // For now, we'll just simulate the sound playing
        print("Playing quacking sound")
        
        // Code to actually play sound would look like this:
        /*
        guard let soundURL = Bundle.main.url(forResource: "quack", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = 5 // Play 5 times
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
        */
    }
    
    func stopSound() {
        // Stop the sound
        print("Stopping sound")
        audioPlayer?.stop()
    }
}

struct PanicModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var soundManager = SoundManager.shared
    @State private var isPlaying = false
    @State private var animationAmount = 1.0
    @State private var navigateToHome = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: Constants.Dimensions.standardPadding * 2) {
                // Title
                Text("Panic Mode")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.Colors.textPrimary)
                
                // Illustration
                ZStack {
                    Circle()
                        .fill(Theme.Colors.primaryButton.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: animationAmount
                        )
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Theme.Colors.primaryButton)
                }
                .padding(.vertical, Constants.Dimensions.standardPadding * 2)
                .onAppear {
                    animationAmount = 1.2
                }
                
                // Description
                Text("Plays a loud sound to help you locate nearby items")
                    .font(.system(size: 18))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Play/Stop button
                Button(action: {
                    if isPlaying {
                        soundManager.stopSound()
                    } else {
                        soundManager.playSound()
                    }
                    isPlaying.toggle()
                }) {
                    Text(isPlaying ? "Stop Sound" : "Play Sound")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
                .standardButtonStyle()
                .padding(.bottom)
                
                // Close button
                Button(action: {
                    if isPlaying {
                        soundManager.stopSound()
                    }
                    navigateToHome = true
                }) {
                    Text("Back to Home")
                        .font(.system(size: 18))
                        .foregroundColor(Theme.Colors.textPrimary)
                        .underline()
                }
            }
            .padding()
            .navigationTitle("Panic Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if isPlaying {
                            soundManager.stopSound()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView(showTabBar: true)
        }
    }
}

#Preview {
    PanicModeView()
}
