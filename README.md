# VerifiedMarket

VerifiedMarket is a Flutter-based halal marketplace application that leverages blockchain technology to track product supply chains and assign halal certification tags. The app automates the verification and transparency of halal products from source to consumer, providing a trustworthy e-commerce experience with immutable supply chain records.

## Overview

VerifiedMarket is an innovative e-commerce automation platform designed to empower halal consumers by providing transparent, blockchain-verified product supply chain information. Users can browse products, verify their halal status through blockchain records, manage purchases, and track order history—all within a secure, transparent ecosystem.

## Key Features

- **Blockchain Supply Chain Tracking**: Monitor product origin, processing, and distribution through an immutable blockchain ledger
- **Halal Certification Tags**: Automated assignment and verification of halal status based on supply chain data
- **User Authentication**: Secure login and registration system
- **Product Catalog**: Browse products with halal certification details and supply chain information
- **Category Filtering**: Filter products by category for easier navigation
- **Product Detail View**: Access detailed product information, including supply chain history and halal certification status
- **Shopping Cart**: Add and manage products before checkout
- **Wallet Management**: Handle digital payments and wallet balances
- **Purchase History**: Track completed orders and verify halal status of purchased items
- **Profile Settings**: Manage user account details and preferences
- **Firebase Integration**: Real-time data synchronization and secure authentication
- **Responsive Material Design**: Optimized user interface across all devices

## Tech Stack

- **Frontend**: Flutter, Dart
- **Backend Services**: Firebase (Auth, Firestore, Storage, Messaging)
- **Blockchain Integration**: Blockchain-based supply chain verification
- **Local Storage**: SharedPreferences for session management
- **API Communication**: HTTP client for backend and blockchain API interaction
- **UI Framework**: Material Design

## Project Structure

```text
VerifiedMarket/
├── android/                 # Android platform code
├── ios/                     # iOS platform code
├── lib/
│   ├── auth/               # Authentication (login, register)
│   ├── profile/            # User profile settings
│   ├── screens/            # Main application screens
│   │   ├── mainScreen.dart
│   │   ├── cart_screen.dart
│   │   ├── wallet_screen.dart
│   │   └── purchase_history_screen.dart
│   ├── utils/              # Utility functions and services
│   │   ├── models/         # Data models (Product, etc.)
│   │   └── services/       # API, Firebase, Cart services
│   ├── main.dart           # App entry point
│   ├── navigator.dart      # Navigation logic
│   └── product_details.dart
├── linux/                  # Linux platform code
├── macos/                  # macOS platform code
├── web/                    # Web platform code
├── windows/                # Windows platform code
├── analysis_options.yaml
├── firebase.json
├── pubspec.yaml
└── README.md
```

## Application Flow

1. **Authentication**: Users start at `LoginPage` or register for a new account
2. **Main Marketplace**: `MarketApp` displays products in a grid with category filtering via navigation drawer
3. **Product Details**: Tap any product to view full details, including blockchain supply chain verification
4. **Shopping**: Add products to cart via `CartPage`
5. **Wallet & Orders**: Manage wallet balance and track purchase history
6. **Profile**: Update user settings and view account information

### Key Screens

- `lib/auth/login_page.dart` - Authentication entry point
- `lib/screens/mainScreen.dart` - Product marketplace with category navigation
- `lib/product_details.dart` - Product details and supply chain information
- `lib/screens/cart_screen.dart` - Shopping cart management
- `lib/screens/wallet_screen.dart` - Wallet and payment tracking
- `lib/screens/purchase_history_screen.dart` - Order history and verification
- `lib/profile/profile_settings_page.dart` - User account settings

## Getting Started

### Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Dart SDK
- Firebase project configured
- IDE (VS Code, Android Studio, or Xcode for iOS development)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aguCompbbky/VerifiedMarket.git
   cd VerifiedMarket
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   ```bash
   flutterfire configure
   ```
   Ensure your Firebase project is set up and the configuration matches your target platforms.

4. **Run the app**:
   ```bash
   flutter run
   ```

### Build for Production

- **Android**: `flutter build apk` or `flutter build appbundle`
- **iOS**: `flutter build ios`
- **Web**: `flutter build web`

## Firebase Setup

The application requires Firebase to be initialized with the following services:

- **Firebase Auth**: User authentication
- **Cloud Firestore**: Real-time product and order data
- **Firebase Storage**: Product images and supply chain documentation
- **Firebase Messaging**: Push notifications for orders and updates

Ensure your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly configured in your Firebase console.

## Blockchain Integration

VerifiedMarket uses blockchain technology to:

- **Record Product Origin**: Immutably log where products originate
- **Track Processing & Handling**: Document every step in the supply chain
- **Verify Halal Compliance**: Store certification records on-chain
- **Assign Halal Tags**: Automatically categorize products based on verified supply chain data

The blockchain integration communicates with backend APIs (`https://agumobile.site/`) to verify supply chain data and assign halal certification status.

## Dependencies

Key Flutter packages used:

- `firebase_core: ^3.12.1` - Firebase initialization
- `firebase_auth: ^5.5.1` - User authentication
- `cloud_firestore: ^5.6.5` - Real-time database
- `firebase_storage: ^12.4.4` - File storage
- `firebase_messaging: ^15.2.4` - Push notifications
- `http: ^1.1.0` - HTTP client for API calls
- `shared_preferences: ^2.2.1` - Local data persistence
- `intl: ^0.20.2` - Internationalization support

## Status

VerifiedMarket is a functional Flutter marketplace prototype with:
- Complete mobile UI and app flow
- Blockchain supply chain integration
- Halal certification automation
- Production-ready architecture for iOS, Android, Web, and Desktop

## Deployment Notes

- Update Firebase configuration for your project environment
- Verify blockchain API endpoints and credentials in backend services
- Test the supply chain tracking workflow before production release
- Ensure halal certification rules are correctly configured in your blockchain contract or backend logic
