import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showLoginView = false
    
    // Onboarding pages content
    let pages = [
        OnboardingPage(
            title: "Never Lose Your Items Again",
            description: "Quickly log where you placed your everyday items and find them in seconds when you need them.",
            imageName: "archivebox.fill"
        ),
        OnboardingPage(
            title: "Voice or One-Tap Logging",
            description: "Use Siri or our widget to log items without even opening the app.",
            imageName: "mic.fill"
        ),
        OnboardingPage(
            title: "Smart Reminders",
            description: "Get notified when you leave home: 'Did you forget your wallet? Last seen on your desk!'",
            imageName: "bell.fill"
        ),
        OnboardingPage(
            title: "Share With Household",
            description: "Family and roommates can collaborate to keep track of shared items.",
            imageName: "person.2.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Constants.Colors.darkBackground
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                if currentPage < pages.count - 1 {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            currentPage = pages.count - 1
                        }) {
                            Text("Skip")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white)
                                .underline()
                        }
                        .padding()
                    }
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Constants.Colors.primaryPurple : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom)
                
                // Navigation buttons
                HStack {
                    // Back button
                    if currentPage > 0 {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .frame(width: 100)
                        }
                        .secondaryButtonStyle()
                    } else {
                        Spacer()
                            .frame(width: 100)
                    }
                    
                    Spacer()
                    
                    // Next/Get Started button
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            showLoginView = true
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .frame(width: 100)
                    }
                    .standardButtonStyle()
                }
                .padding(.horizontal)
                .padding(.bottom, Constants.Dimensions.standardPadding * 2)
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: Constants.Dimensions.standardPadding * 2) {
            // Illustration
            Image(systemName: page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(Constants.Colors.primaryPurple)
                .padding(.bottom, Constants.Dimensions.standardPadding)
            
            // Title
            Text(page.title)
                .font(.system(size: Constants.FontSizes.title, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Description
            Text(page.description)
                .font(.system(size: Constants.FontSizes.body))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.Dimensions.standardPadding * 2)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
