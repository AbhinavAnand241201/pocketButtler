# Pocket Butler - Never Lose Your Everyday Items Again

## Overview

Pocket Butler is an iOS app that helps you keep track of your everyday items. It allows you to quickly log where you placed items and retrieve that information in seconds when you need them. No Bluetooth trackers, no complex setup—just quick logging and smart reminders.
## Features

- **Voice or One-Tap Logging**: Quickly log where you placed items using voice commands or a simple tap.
- **Search in 2 Seconds**: Find your items instantly by searching for them in the app.
- **Smart Alerts**: Get notifications when you leave home to remind you about items you might have forgotten.
- **Shared Household Log**: Collaborate with family members or roommates to keep track of shared items.
- **Favorites & History**: Save frequently used items and view a log of past locations.
- **Panic Mode**: Play a loud sound to help locate nearby items.

## Tech Stack

- **Frontend**: Swift + SwiftUI (iOS)
- **Backend**: Node.js + Express.js (to be implemented)
- **Database**: MongoDB (to be implemented)
- **Auth**: JWT Tokens
- **Notifications**: APNs (Apple Push Notification Service) + Geofencing

## Project Structure

```
PocketButler/
├── Models/
│   ├── Item.swift          // Data model for tracked items
│   ├── User.swift          // User auth/profile data
│   └── Household.swift     // Shared household data
├── Views/
│   ├── LoginView.swift     // Login screen
│   ├── HomeView.swift      // Main screen with search/favorites
│   ├── AddItemView.swift   // Item logging interface
│   └── ...                 // Other view files
├── ViewModels/
│   ├── ItemViewModel.swift // Business logic for items
│   └── AuthViewModel.swift // Handles login/JWT tokens
├── Services/
│   ├── APIService.swift    // API calls to backend
│   └── NotificationService.swift // Handles smart alerts
└── Utilities/
    ├── Extensions.swift    // SwiftUI helpers
    └── Constants.swift     // API URLs, keys
```

## Setup Instructions

1. Clone the repository
2. Open the project in Xcode
3. Build and run the app on an iOS simulator or device

## Backend Setup (Coming Soon)

The backend for this app will be implemented using Node.js, Express.js, and MongoDB. Instructions for setting up the backend will be provided in a future update.

## Current Status

This is the initial implementation of the frontend for the Pocket Butler app. The app currently includes the UI for all the screens as specified in the design documents. The backend integration will be implemented in the next phase.

## Next Steps

1. Implement the backend API using Node.js and Express.js
2. Connect the frontend to the backend API
3. Implement user authentication
4. Implement geofencing for smart alerts
5. Add support for shared households
6. Implement the premium subscription features

## License

This project is licensed under the MIT License - see the LICENSE file for details.
