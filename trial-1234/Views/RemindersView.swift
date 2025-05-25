import SwiftUI
import UserNotifications

struct RemindersView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = RemindersViewModel()
    @State private var showAddReminderSheet = false
    @State private var isFirstAppear = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                if viewModel.reminders.isEmpty {
                    // Empty state
                    VStack(spacing: Constants.Dimensions.standardPadding * 2) {
                        Spacer()
                        
                        Image(systemName: "bell.badge")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(Constants.Colors.primaryPurple.opacity(0.7))
                        
                        Text("No Reminders")
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        Text("Create reminders to help you remember important items")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            showAddReminderSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Reminder")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .standardButtonStyle()
                        .padding(.bottom, 30)
                    }
                    .padding()
                } else {
                    // List of reminders
                    VStack {
                        List {
                            ForEach(viewModel.reminders.indices, id: \.self) { index in
                                ReminderCell(reminder: $viewModel.reminders[index]) {
                                    viewModel.toggleReminder(viewModel.reminders[index])
                                }
                            }
                            .onDelete(perform: viewModel.deleteReminder)
                        }
                        .listStyle(PlainListStyle())
                        .background(Constants.Colors.darkBackground)
                        
                        // Add button
                        Button(action: {
                            showAddReminderSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Reminder")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .standardButtonStyle()
                        .padding()
                    }
                }
            }
            .navigationTitle("Reminders")
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
            .sheet(isPresented: $showAddReminderSheet) {
                AddReminderView { newReminder in
                    viewModel.addReminder(newReminder)
                }
            }
            .onAppear {
                if isFirstAppear {
                    requestNotificationPermission()
                    isFirstAppear = false
                }
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}

struct ReminderCell: View {
    @Binding var reminder: Reminder
    let onToggle: () -> Void
    
    private var isEnabledBinding: Binding<Bool> {
        Binding(
            get: { reminder.isEnabled },
            set: { newValue in
                var updatedReminder = reminder
                updatedReminder.isEnabled = newValue
                reminder = updatedReminder
                onToggle()
            }
        )
    }
    
    var body: some View {
        HStack(spacing: Constants.Dimensions.standardPadding) {
            // Icon
            ZStack {
                Circle()
                    .fill(Constants.Colors.primaryPurple.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: reminder.isLocationBased ? "location.fill" : "clock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Constants.Colors.primaryPurple)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.system(size: Constants.FontSizes.body, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Item: \(reminder.itemName)")
                    .font(.system(size: Constants.FontSizes.caption))
                    .foregroundColor(.white.opacity(0.7))
                
                if reminder.isLocationBased {
                    Text(reminder.location ?? "")
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(Constants.Colors.teal)
                } else {
                    Text(formatTime(reminder.time))
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(Constants.Colors.orange)
                }
                
                if reminder.isRepeating {
                    Text(formatRepeatDays(reminder.repeatDays))
                        .font(.system(size: Constants.FontSizes.caption))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: isEnabledBinding)
                .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
        }
        .padding()
        .background(Constants.Colors.lightBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
        .listRowBackground(Constants.Colors.darkBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatRepeatDays(_ days: [Int]) -> String {
        if days.count == 7 {
            return "Every day"
        } else if days.count == 5 && days.contains(1) && days.contains(2) && days.contains(3) && days.contains(4) && days.contains(5) {
            return "Weekdays"
        } else if days.count == 2 && days.contains(6) && days.contains(7) {
            return "Weekends"
        } else {
            let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            let selectedDays = days.map { dayNames[$0 - 1] }
            return selectedDays.joined(separator: ", ")
        }
    }
}

struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var selectedItem = ""
    @State private var isLocationBased = false
    @State private var selectedLocation = "When leaving home"
    @State private var reminderTime = Date()
    @State private var isRepeating = false
    @State private var selectedDays: [Int] = []
    
    let onSave: (Reminder) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Constants.Dimensions.standardPadding) {
                        // Reminder title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reminder Title")
                                .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("e.g. Take Keys", text: $title)
                                .standardTextFieldStyle()
                        }
                        
                        // Item selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("For Item")
                                .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                .foregroundColor(.white)
                            
                            // In a real app, this would be a picker with actual items
                            Menu {
                                Button("House Keys", action: { selectedItem = "House Keys" })
                                Button("MacBook Pro", action: { selectedItem = "MacBook Pro" })
                                Button("Wallet", action: { selectedItem = "Wallet" })
                                Button("Headphones", action: { selectedItem = "Headphones" })
                            } label: {
                                HStack {
                                    Text(selectedItem.isEmpty ? "Select an item" : selectedItem)
                                        .foregroundColor(selectedItem.isEmpty ? .gray : .white)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(Constants.Dimensions.cornerRadius)
                            }
                        }
                        
                        // Reminder type
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reminder Type")
                                .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                .foregroundColor(.white)
                            
                            Picker("", selection: $isLocationBased) {
                                Text("Time-based").tag(false)
                                Text("Location-based").tag(true)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical, 8)
                        }
                        
                        // Time or location based on selection
                        if isLocationBased {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location Trigger")
                                    .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Menu {
                                    Button("When leaving home", action: { selectedLocation = "When leaving home" })
                                    Button("When arriving home", action: { selectedLocation = "When arriving home" })
                                    Button("When leaving work", action: { selectedLocation = "When leaving work" })
                                    Button("When arriving at work", action: { selectedLocation = "When arriving at work" })
                                } label: {
                                    HStack {
                                        Text(selectedLocation)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Constants.Colors.lightBackground)
                                    .cornerRadius(Constants.Dimensions.cornerRadius)
                                }
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reminder Time")
                                    .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                    .foregroundColor(.white)
                                
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .background(Constants.Colors.lightBackground)
                                    .cornerRadius(Constants.Dimensions.cornerRadius)
                            }
                        }
                        
                        // Repeat options
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Repeat", isOn: $isRepeating)
                                .foregroundColor(.white)
                                .padding()
                                .background(Constants.Colors.lightBackground)
                                .cornerRadius(Constants.Dimensions.cornerRadius)
                            
                            if isRepeating {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Repeat Days")
                                        .font(.system(size: Constants.FontSizes.body, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    HStack {
                                        ForEach(1...7, id: \.self) { day in
                                            let dayName = ["M", "T", "W", "T", "F", "S", "S"][day - 1]
                                            let isSelected = selectedDays.contains(day)
                                            
                                            Button(action: {
                                                if isSelected {
                                                    selectedDays.removeAll { $0 == day }
                                                } else {
                                                    selectedDays.append(day)
                                                }
                                            }) {
                                                Text(dayName)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .frame(width: 36, height: 36)
                                                    .background(isSelected ? Constants.Colors.primaryPurple : Constants.Colors.lightBackground)
                                                    .foregroundColor(isSelected ? .white : .gray)
                                                    .cornerRadius(18)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Save button
                        Button(action: {
                            saveReminder()
                        }) {
                            Text("Save Reminder")
                                .frame(maxWidth: .infinity)
                        }
                        .standardButtonStyle()
                        .disabled(title.isEmpty || selectedItem.isEmpty)
                        .opacity((title.isEmpty || selectedItem.isEmpty) ? 0.7 : 1)
                    }
                    .padding()
                }
                .navigationTitle("Add Reminder")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
    private func saveReminder() {
        let newReminder = Reminder(
            id: UUID().uuidString,
            title: title,
            itemName: selectedItem,
            time: reminderTime,
            isLocationBased: isLocationBased,
            location: isLocationBased ? selectedLocation : nil,
            isRepeating: isRepeating,
            repeatDays: isRepeating ? selectedDays : []
        )
        
        onSave(newReminder)
        presentationMode.wrappedValue.dismiss()
    }
}

// Note: Using the standardTextFieldStyle and standardButtonStyle from Extensions.swift

#Preview {
    RemindersView()
}
