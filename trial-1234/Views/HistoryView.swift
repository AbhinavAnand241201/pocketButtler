import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var historyItems: [HistoryItem] = []
    @State private var searchText = ""
    @State private var selectedFilter: HistoryFilter = .all
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.BackgroundView()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search history", text: $searchText)
                            .foregroundColor(.white)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Filter options
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(HistoryFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.title,
                                    isSelected: selectedFilter == filter,
                                    action: {
                                        selectedFilter = filter
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    
                    if filteredItems.isEmpty {
                        // Empty state
                        VStack(spacing: Constants.Dimensions.standardPadding * 2) {
                            Spacer()
                            
                            Image(systemName: "clock.arrow.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .foregroundColor(Constants.Colors.primaryPurple.opacity(0.7))
                            
                            Text("No History Found")
                                .font(.system(size: Constants.FontSizes.title, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top)
                            
                            Text(emptyStateMessage)
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                        .padding()
                    } else {
                        // History list
                        List {
                            ForEach(filteredItems) { item in
                                HistoryItemRow(item: item)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Constants.Colors.darkBackground)
                    }
                }
                .navigationTitle("History")
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
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                // Sort by newest
                                historyItems.sort { $0.timestamp > $1.timestamp }
                            }) {
                                Label("Newest First", systemImage: "arrow.down")
                            }
                            
                            Button(action: {
                                // Sort by oldest
                                historyItems.sort { $0.timestamp < $1.timestamp }
                            }) {
                                Label("Oldest First", systemImage: "arrow.up")
                            }
                            
                            Divider()
                            
                            Button(role: .destructive, action: {
                                // Clear history
                                withAnimation {
                                    historyItems.removeAll()
                                }
                            }) {
                                Label("Clear History", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                loadSampleHistory()
            }
        }
    }
    
    private var filteredItems: [HistoryItem] {
        var items = historyItems
        
        // Apply filter
        if selectedFilter != .all {
            items = items.filter { $0.type == selectedFilter }
        }
        
        // Apply search
        if !searchText.isEmpty {
            items = items.filter {
                $0.itemName.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return items
    }
    
    private var emptyStateMessage: String {
        if !searchText.isEmpty {
            return "No items match your search criteria"
        } else if selectedFilter != .all {
            return "No \(selectedFilter.title.lowercased()) actions found"
        } else {
            return "Your history will appear here once you start tracking items"
        }
    }
    
    private func loadSampleHistory() {
        // Sample data for preview
        let now = Date()
        historyItems = [
            HistoryItem(id: "1", itemName: "House Keys", location: "Kitchen Counter", timestamp: now.addingTimeInterval(-3600), type: .placed),
            HistoryItem(id: "2", itemName: "Wallet", location: "Bedroom Drawer", timestamp: now.addingTimeInterval(-7200), type: .placed),
            HistoryItem(id: "3", itemName: "House Keys", location: "Kitchen Counter", timestamp: now.addingTimeInterval(-1800), type: .found),
            HistoryItem(id: "4", itemName: "Headphones", location: "Living Room", timestamp: now.addingTimeInterval(-86400), type: .placed),
            HistoryItem(id: "5", itemName: "Laptop", location: "Office Desk", timestamp: now.addingTimeInterval(-43200), type: .moved, previousLocation: "Living Room Couch"),
            HistoryItem(id: "6", itemName: "Glasses", location: "Bathroom", timestamp: now.addingTimeInterval(-129600), type: .found)
        ]
    }
}

struct HistoryItem: Identifiable {
    let id: String
    let itemName: String
    let location: String
    let timestamp: Date
    let type: HistoryFilter
    var previousLocation: String? = nil
}

enum HistoryFilter: CaseIterable {
    case all, placed, moved, found
    
    var title: String {
        switch self {
        case .all: return "All"
        case .placed: return "Placed"
        case .moved: return "Moved"
        case .found: return "Found"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .placed: return "arrow.down.to.line"
        case .moved: return "arrow.left.arrow.right"
        case .found: return "magnifyingglass"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return Theme.Colors.primaryButton
        case .placed: return Theme.Colors.primaryButtonHighlight
        case .moved: return Theme.Colors.iconDefault
        case .found: return Theme.Colors.primaryButton.opacity(0.8)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Constants.Colors.primaryPurple : Constants.Colors.lightBackgroundColor)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
}

struct HistoryItemRow: View {
    let item: HistoryItem
    
    var body: some View {
        HStack(spacing: Constants.Dimensions.standardPadding) {
            // Icon
            ZStack {
                Circle()
                    .fill(item.type.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: item.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(item.type.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.system(size: Constants.FontSizes.body, weight: .medium))
                    .foregroundColor(.white)
                
                if item.type == .moved, let previousLocation = item.previousLocation {
                    Text("\(previousLocation) → \(item.location)")
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text(item.location)
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text(timeAgo(item.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(item.type.color)
            }
            
            Spacer()
        }
        .padding()
        .background(Constants.Colors.lightBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
        .listRowBackground(Constants.Colors.darkBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private func timeAgo(_ date: Date) -> String {
        return date.timeAgo()
    }
}

#Preview {
    HistoryView()
}
