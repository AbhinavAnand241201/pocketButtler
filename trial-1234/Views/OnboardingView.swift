import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showLoginView = false
    @State private var animateContent = false
    
    // Onboarding pages content
    let pages = [
        OnboardingPage(
            title: "Never Lose Your Items Again",
            description: "Quickly log where you placed your everyday items and find them in seconds when you need them.",
            imageName: "magnifyingglass.circle.fill"
        ),
        OnboardingPage(
            title: "Voice or One-Tap Logging",
            description: "Use Siri or our widget to log items without even opening the app.",
            imageName: "mic.fill"
        ),
        OnboardingPage(
            title: "Smart Reminders",
            description: "Get notified when you leave home: 'Did you forget your wallet? Last seen on your desk!'",
            imageName: "bell.badge.fill"
        ),
        OnboardingPage(
            title: "Share With Household",
            description: "Family and roommates can collaborate to keep track of shared items.",
            imageName: "person.2.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient
            Theme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                if currentPage < pages.count - 1 {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage = pages.count - 1
                            }
                        }) {
                            Text("Skip")
                                .font(Theme.Typography.callout)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .padding()
                        }
                    }
                }
                
                // Page View
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Theme.Colors.primary : Theme.Colors.textSecondary.opacity(0.3))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, Theme.Spacing.large)
                
                // Navigation Buttons
                HStack(spacing: Theme.Spacing.medium) {
                    // Back button with animation
                    if currentPage > 0 {
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            withAnimation(.spring()) {
                                currentPage -= 1
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(Theme.Typography.subheadline)
                            .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .frame(width: 120, height: 50)
                        .background(Theme.Colors.cardBackground.opacity(0.5))
                        .cornerRadius(Theme.CornerRadius.medium)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    } else {
                        Spacer()
                            .frame(width: 120, height: 50)
                    }
                    
                    Spacer()
                    
                    // Next/Get Started button
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring()) {
                                currentPage += 1
                            }
                        } else {
                            showLoginView = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            if currentPage < pages.count - 1 {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(Theme.Typography.subheadline.bold())
                        .foregroundColor(.white)
                    }
                    .frame(width: 160, height: 50)
                    .background(Theme.Colors.primary)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 4)
                }
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.bottom, Theme.Spacing.xlarge)
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
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xxlarge) {
            // Animated illustration with gradient
            ZStack {
                // Background glow
                Circle()
                    .fill(Theme.Colors.primary.opacity(0.1))
                    .frame(width: 220, height: 220)
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
                
                // Main icon with gradient
                Image(systemName: page.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.Colors.primary, Theme.Colors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .frame(height: 220)
            .onAppear {
                animate = true
            }
            
            // Content
            VStack(spacing: Theme.Spacing.medium) {
                // Title with animation
                Text(page.title)
                    .font(Theme.Typography.title1)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xlarge)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description with animation
                Text(page.description)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Theme.Spacing.xlarge)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, Theme.Spacing.xxlarge)
        }
        .padding(.top, Theme.Spacing.xxlarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OnboardingView()
}
