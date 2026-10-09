# VerifiedMarket

VerifiedMarket is a Flutter-based marketplace application for browsing and purchasing products from a digital storefront. The app includes user authentication, category-based product browsing, cart management, wallet functionality, and purchase history, with Firebase support for app services.

## Overview

This repository contains a cross-platform Flutter app designed to provide a mobile shopping experience similar to a grocery or marketplace application. It is structured around a central market dashboard, product detail views, and user account screens, with services for authentication and product data fetching.

## Key Features

- User login and registration flow
- Product catalog with category filtering
- Product detail view
- Shopping cart functionality
- Wallet screen and payment-related tracking
- Purchase history screen
- Profile settings
- Firebase initialization and integration
- Responsive Material Design UI

## Tech Stack

- Flutter
- Dart
- Firebase Auth
- Firebase Firestore / Storage / Messaging
- SharedPreferences
- HTTP client for backend interaction

## Project Structure

```text
VerifiedMarket/
├── android/
├── ios/
├── lib/
│   ├── auth/
│   ├── profile/
│   ├── screens/
│   ├── utils/
│   ├── main.dart
│   ├── navigator.dart
│   ├── product_details.dart
│   └── ...
├── linux/
├── macos/
├── web/
├── windows/
├── .metadata
├── .gitignore
├── analysis_options.yaml
├── firebase.json
├── pubspec.yaml
├── README.md
└── ...
```

## Main App Flow

- `lib/main.dart` initializes Firebase and launches the application.
- `lib/auth/login_page.dart` handles login and account access.
- `lib/screens/mainScreen.dart` displays the marketplace grid and category navigation.
- `lib/product_details.dart` provides product-specific details.
- `lib/screens/cart_screen.dart` manages shopping cart actions.
- `lib/screens/wallet_screen.dart` and `lib/screens/purchase_history_screen.dart` handle wallet and order tracking.

## Getting Started

### Prerequisites

- Flutter SDK installed
- A Firebase project configured for the app
- An IDE such as VS Code or Android Studio

### Installation

1. Clone the repository:

```bash
git clone https://github.com/aguCompbbky/VerifiedMarket.git
cd VerifiedMarket
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

```bash
flutterfire configure
```

If the project already contains Firebase configuration files, ensure they match your project setup and environment.

4. Run the app:

```bash
flutter run
```

## Firebase Notes

The application initializes Firebase in `lib/main.dart` using generated platform options. If you are setting up the project from scratch, make sure the Firebase configuration is regenerated and committed in the appropriate Flutter-generated files.

## Backend / Data Notes

This app uses remote HTTP requests and Firebase-backed services for login, product data, and user-specific operations. If you are modifying or extending the app, verify the corresponding API endpoints and backend availability before deployment.

## Status

The repository is a working Flutter marketplace prototype with a complete mobile interface and app-flow structure for product browsing and ordering.

## Contributing

Contributions are welcome. If you want to improve functionality, UI, or backend integration, open a pull request with a clear description of the changes.

## License

This repository does not currently include a license file. If you plan to distribute or publish the project, add an appropriate open-source license before release.
