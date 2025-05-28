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
                LinearGradient(
                    gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter tabs
                    HStack {
                        FilterTabButton(title: "All", isSelected: true)
                        
                        FilterTabButton(title: "Reminders", isSelected: false)
                        
                        FilterTabButton(title: "Activity", isSelected: false)
                        
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
                                .foregroundColor(Theme.Colors.textSecondary)
                                .padding()
                            
                            Text("No Notifications")
                                .font(.system(size: Constants.FontSizes.title, weight: .bold))
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            Text("You don't have any notifications yet")
                                .font(.system(size: Constants.FontSizes.body))
                                .foregroundColor(Theme.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(notifications) { notification in
                                NotificationRow(notification: notification)
                                    .listRowBackground(Theme.Colors.cardBackground)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Theme.Colors.backgroundStart)
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
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Mark all as read
                        }) {
                            Text("Mark All")
                                .font(.system(size: Constants.FontSizes.caption))
                                .foregroundColor(Theme.Colors.primaryButton)
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
            return Theme.Colors.primaryButtonHighlight
        case .activity:
            return Theme.Colors.primaryButton.opacity(0.8)
        case .share:
            return Theme.Colors.primaryButton
        case .system:
            return Theme.Colors.primaryButton.opacity(0.6)
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
                    .fill(notification.type.color.opacity(0.3))
                    .frame(width: 45, height: 45)
                    .shadow(color: notification.type.color.opacity(0.4), radius: 4, x: 0, y: 2)
                
                Image(systemName: notification.type.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(notification.type.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: Constants.FontSizes.body + 2, weight: notification.isRead ? .semibold : .bold))
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    if !notification.isRead {
                        Circle()
                            .fill(Theme.Colors.primaryButton)
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                }
                
                Text(notification.description)
                    .font(.system(size: Constants.FontSizes.caption + 1, weight: .medium))
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text(notification.time)
                    .font(.system(size: Constants.FontSizes.caption))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.primaryButton.opacity(0.8))
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(
            ZStack {
                if notification.isRead {
                    Theme.Colors.cardBackground
                } else {
                    Theme.Colors.cardBackground.opacity(0.7)
                }
            }
        )
        .cornerRadius(Constants.Dimensions.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                .stroke(notification.type.color.opacity(notification.isRead ? 0.1 : 0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(), value: notification.isRead)
    }
}

struct FilterTabButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: Constants.FontSizes.body, weight: isSelected ? .bold : .medium))
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(isSelected ? Theme.Colors.primaryButton : Color.clear)
            .cornerRadius(Constants.Dimensions.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                    .stroke(isSelected ? Color.clear : Theme.Colors.primaryButton.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    NotificationsView()
}
