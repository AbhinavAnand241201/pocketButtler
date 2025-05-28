import SwiftUI

struct StatisticsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPeriod: TimePeriod = .week
    @State private var topItems: [ItemStat] = []
    @State private var mostSearched: [ItemStat] = []
    @State private var frequentLocations: [LocationStat] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Constants.Dimensions.standardPadding * 1.5) {
                        // Time period selector
                        Picker("Time Period", selection: $selectedPeriod) {
                            Text("Week").tag(TimePeriod.week)
                            Text("Month").tag(TimePeriod.month)
                            Text("Year").tag(TimePeriod.year)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .onChange(of: selectedPeriod) { _ in
                            loadStatistics()
                        }
                        
                        // Usage summary
                        StatSummaryCard(
                            title: "Usage Summary",
                            icon: "chart.bar.fill",
                            color: Theme.Colors.primaryButton,
                            content: {
                                HStack(spacing: Constants.Dimensions.standardPadding * 2) {
                                    StatNumberView(
                                        number: "42",
                                        label: "Items Tracked",
                                        icon: "tag.fill",
                                        color: Theme.Colors.primaryButton
                                    )
                                    
                                    StatNumberView(
                                        number: "18",
                                        label: "Searches",
                                        icon: "magnifyingglass",
                                        color: Theme.Colors.primaryButton
                                    )
                                    
                                    StatNumberView(
                                        number: "7",
                                        label: "Categories",
                                        icon: "folder.fill",
                                        color: Theme.Colors.primaryButtonHighlight
                                    )
                                }
                            }
                        )
                        
                        // Top items
                        StatSummaryCard(
                            title: "Most Used Items",
                            icon: "star.fill",
                            color: Theme.Colors.primaryButtonHighlight,
                            content: {
                                VStack(spacing: Constants.Dimensions.standardPadding) {
                                    ForEach(topItems) { item in
                                        StatItemRow(
                                            name: item.name,
                                            value: "\(item.count)",
                                            icon: item.icon,
                                            color: item.color
                                        )
                                    }
                                }
                            }
                        )
                        
                        // Most searched
                        StatSummaryCard(
                            title: "Most Searched",
                            icon: "magnifyingglass",
                            color: Theme.Colors.primaryButtonHighlight,
                            content: {
                                VStack(spacing: Constants.Dimensions.standardPadding) {
                                    ForEach(mostSearched) { item in
                                        StatItemRow(
                                            name: item.name,
                                            value: "\(item.count)",
                                            icon: item.icon,
                                            color: item.color
                                        )
                                    }
                                }
                            }
                        )
                        
                        // Frequent locations
                        StatSummaryCard(
                            title: "Frequent Locations",
                            icon: "location.fill",
                            color: Theme.Colors.primaryButton.opacity(0.8),
                            content: {
                                VStack(spacing: Constants.Dimensions.standardPadding) {
                                    ForEach(frequentLocations) { location in
                                        StatItemRow(
                                            name: location.name,
                                            value: "\(location.count)",
                                            icon: "mappin",
                                            color: .red
                                        )
                                    }
                                }
                            }
                        )
                        
                        // Activity chart
                        StatSummaryCard(
                            title: "Activity Over Time",
                            icon: "chart.line.uptrend.xyaxis",
                            color: Theme.Colors.primaryButtonHighlight.opacity(0.7),
                            content: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Item Tracking Activity")
                                        .font(.system(size: Constants.FontSizes.caption))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    // Simple bar chart
                                    HStack(alignment: .bottom, spacing: 8) {
                                        ForEach(0..<7, id: \.self) { index in
                                            let height = [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.9][index]
                                            
                                            VStack {
                                                Rectangle()
                                                    .fill(Theme.Colors.primaryButton)
                                                    .frame(height: 120 * height)
                                                    .cornerRadius(4)
                                                
                                                Text(dayLabel(for: index))
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                            }
                        )
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
            }
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    private func loadStatistics() {
        // This would fetch real data in a production app
        // For now, we'll use sample data
        
        // Top items
        topItems = [
            ItemStat(id: "1", name: "Keys", count: 28, icon: "key.fill", color: Theme.Colors.primaryButton),
            ItemStat(id: "2", name: "Wallet", count: 23, icon: "creditcard.fill", color: Theme.Colors.primaryButtonHighlight),
            ItemStat(id: "3", name: "Phone", count: 19, icon: "iphone", color: Theme.Colors.iconDefault)
        ]
        
        // Most searched
        mostSearched = [
            ItemStat(id: "1", name: "Keys", count: 15, icon: "key.fill", color: Theme.Colors.primaryButton),
            ItemStat(id: "2", name: "Headphones", count: 12, icon: "headphones", color: Theme.Colors.iconDefault),
            ItemStat(id: "3", name: "Glasses", count: 8, icon: "eyeglasses", color: Theme.Colors.primaryButtonHighlight)
        ]
        
        // Frequent locations
        frequentLocations = [
            LocationStat(id: "1", name: "Living Room", count: 42),
            LocationStat(id: "2", name: "Bedroom", count: 27),
            LocationStat(id: "3", name: "Kitchen", count: 18)
        ]
    }
    
    private func dayLabel(for index: Int) -> String {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days[index]
    }
}

enum TimePeriod {
    case week, month, year
}

struct ItemStat: Identifiable {
    let id: String
    let name: String
    let count: Int
    let icon: String
    let color: Color
}

struct LocationStat: Identifiable {
    let id: String
    let name: String
    let count: Int
}

struct StatSummaryCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Dimensions.standardPadding) {
            // Header
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: Constants.FontSizes.body, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Content
            content
        }
        .padding()
        .background(Constants.Colors.lightBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
        .padding(.horizontal)
    }
}

struct StatNumberView: View {
    let number: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            Text(number)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
}

struct StatItemRow: View {
    let name: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            // Name
            Text(name)
                .font(.system(size: Constants.FontSizes.body))
                .foregroundColor(.white)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(size: Constants.FontSizes.body, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    StatisticsView()
}
