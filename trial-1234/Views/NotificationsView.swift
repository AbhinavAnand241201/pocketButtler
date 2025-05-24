import SwiftUI

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Sample notifications for preview
    let notifications = [
        NotificationItem(
            id: "1",
            title: "Did you forget your wallet?",
            description: "Last seen in the bedroom",
            time: "10 minutes ago",
            isRead: false,
            type: .reminder
        ),
        NotificationItem(
            id: "2",
            title: "Dad logged 'TV Remote'",
            description: "Location: Living Room",
            time: "2 hours ago",
            isRead: true,
            type: .activity
        ),
        NotificationItem(
            id: "3",
            title: "Mom shared an item with you",
            description: "Shared item: Family Photo Album",
            time: "Yesterday",
            isRead: true,
            type: .share
        ),
        NotificationItem(
            id: "4",
            title: "Welcome to Premium!",
            description: "You now have access to all premium features",
            time: "2 days ago",
            isRead: true,
            type: .system
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter tabs
                    HStack {
                        Text("All")
                            .font(.system(size: Constants.FontSizes.body, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Constants.Colors.primaryPurple)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                        
                        Text("Reminders")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                        
                        Text("Activity")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Notifications list
                    if notifications.isEmpty {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "bell.slash.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white.opacity(0.5))
                                .padding()
                            
                            Text("No Notifications")
                                .font(.system(size: Constants.FontSizes.title, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("You don't have any notifications yet")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(notifications) { notification in
                                NotificationRow(notification: notification)
                                    .listRowBackground(Constants.Colors.lightBackground)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Constants.Colors.darkBackground)
                    }
                }
                .navigationTitle("Notifications")
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
                        Button(action: {
                            // Mark all as read
                        }) {
                            Text("Mark All")
                                .font(.system(size: Constants.FontSizes.caption))
                                .foregroundColor(Constants.Colors.primaryPurple)
                        }
                    }
                }
            }
        }
    }
}

enum NotificationType {
    case reminder
    case activity
    case share
    case system
    
    var icon: String {
        switch self {
        case .reminder:
            return "bell.fill"
        case .activity:
            return "person.fill"
        case .share:
            return "square.and.arrow.up.fill"
        case .system:
            return "gear.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .reminder:
            return .orange
        case .activity:
            return Constants.Colors.lightPurple
        case .share:
            return .green
        case .system:
            return .blue
        }
    }
}

struct NotificationItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let time: String
    let isRead: Bool
    let type: NotificationType
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: notification.type.icon)
                    .foregroundColor(notification.type.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: Constants.FontSizes.body, weight: notification.isRead ? .regular : .bold))
                        .foregroundColor(.white)
                    
                    if !notification.isRead {
                        Circle()
                            .fill(Constants.Colors.primaryPurple)
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                }
                
                Text(notification.description)
                    .font(.system(size: Constants.FontSizes.caption))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(notification.time)
                    .font(.system(size: Constants.FontSizes.caption))
                    .foregroundColor(Constants.Colors.lightPurple)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(notification.isRead ? Constants.Colors.lightBackground : Constants.Colors.lightBackground.opacity(0.7))
        .cornerRadius(Constants.Dimensions.cornerRadius)
    }
}

#Preview {
    NotificationsView()
}
