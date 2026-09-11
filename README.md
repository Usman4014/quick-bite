# 🍔 Quick Bite

> A modern Flutter food delivery application built with Flutter, GetX, Firebase, and location-based delivery support.

Quick Bite is a full-featured food delivery application designed for a single restaurant. The project demonstrates a production-style Flutter architecture with authentication, product management, cart and checkout flows, order tracking, promotions, reviews, notifications, rider information, and location-based delivery validation.

The project was built with a focus on **clean UI, scalable architecture, reusable components, real-time data, and a smooth customer experience**.

---

## 📱 Features

### 🔐 Authentication

* Phone number authentication with OTP
* Email & password authentication
* Google Sign-In
* Facebook authentication
* Forgot password
* Change password
* User profile management

### 🏠 Home & Discovery

* Promotional banners
* Food categories
* Popular items
* Chef's Special
* Special Deals
* Product search
* Featured products
* Why Quick Bite section

### 🍕 Products

* Product listing
* Product details
* Product variants/sizes
* Quantity selection
* Product reviews and ratings
* Add to cart
* Favorite products

### 🛒 Cart & Checkout

* Dynamic cart management
* Product quantity updates
* Special offers
* Promo codes
* Delivery address selection
* Delivery instructions
* Payment method selection
* Order price summary
* Tax and discount calculation
* Order confirmation

### 📦 Orders

* Order creation
* Order history
* Order details
* Order status tracking
* Order timeline
* Order cancellation
* Reorder functionality
* Rider information
* Delivery information

### 🎁 Offers & Promotions

* Special deals
* Promotional offers
* Promo codes
* Discount calculations
* Offer details
* Offer expiration handling

### ⭐ Reviews & Ratings

* Product reviews
* Special deal reviews
* App reviews
* Rating summaries
* Customer feedback

### 🔔 Notifications

* Firebase Cloud Messaging
* Order-related notifications
* Promotional notifications
* Notification history
* Read/unread notification handling

### 📍 Location & Delivery

* OpenStreetMap integration
* Interactive map
* Location selection
* Reverse geocoding
* Address management
* Delivery radius validation
* 10 KM delivery coverage

---

## 🛠️ Tech Stack

| Technology                   | Usage                                            |
| ---------------------------- | ------------------------------------------------ |
| **Flutter**                  | Cross-platform mobile application                |
| **Dart**                     | Application development                          |
| **GetX**                     | State management, dependency injection & routing |
| **Firebase Authentication**  | User authentication                              |
| **Cloud Firestore**          | Application data & real-time updates             |
| **Firebase Cloud Messaging** | Push notifications                               |
| **Firebase Cloud Functions** | Backend/server-side logic                        |
| **OpenStreetMap**            | Maps & location visualization                    |
| **flutter_map**              | Flutter map integration                          |
| **Geolocator**               | Device location                                  |
| **Geocoding**                | Address/location conversion                      |
| **Google Sign-In**           | Social authentication                            |
| **Facebook Auth**            | Social authentication                            |
| **Cloudinary**               | Image management                                 |
| **REST APIs**                | API-based integrations                           |

---

## 🏗️ Architecture

The application follows a structured Flutter architecture with separation between:

```text
lib/
├── bindings/
├── controllers/
├── enums/
├── helpers/
├── models/
├── routes/
├── services/
├── shimmers/
├── theme/
├── views/
└── widgets/
```

### Main architectural layers

**Models**

* Represent application data and Firestore entities.

**Controllers**

* Handle state management and application logic using GetX.

**Services**

* Handle Firebase, authentication, Firestore, notifications, orders, products, reviews, and other backend operations.

**Views**

* Contain the application's screens and UI components.

**Widgets**

* Reusable UI components shared across multiple screens.

**Bindings**

* Manage GetX dependency injection and controller initialization.

---

## 🔥 Firebase Integration

Quick Bite uses Firebase for several core backend capabilities:

* Firebase Authentication
* Cloud Firestore
* Firebase Cloud Messaging
* Firebase Cloud Functions
* Firebase project configuration

The application communicates with Firebase through dedicated service classes rather than placing backend operations directly inside UI screens.

---

## 📍 Delivery System

Quick Bite includes a location-based delivery system.

The application uses:

* OpenStreetMap
* `flutter_map`
* `latlong2`
* `geolocator`
* `geocoding`

Customer addresses are associated with latitude and longitude coordinates, allowing the application to validate whether an address falls within the restaurant's delivery coverage.

**Configured delivery radius: 10 KM**

---

## 🎨 UI & UX

The application uses a modern food-delivery focused interface with:

* Poppins typography
* Custom theme system
* Reusable UI components
* Loading shimmer effects
* Responsive layouts
* Empty states
* Custom cards and bottom sheets
* Product-focused layouts
* Consistent colors and spacing

The UI was designed to provide a clean and intuitive ordering experience.

---

## 📂 Major Application Modules

```text
Authentication
    ↓
Home
    ├── Categories
    ├── Popular Items
    ├── Chef's Special
    ├── Special Deals
    └── Offers

Products
    ↓
Product Details
    ↓
Cart
    ↓
Checkout
    ├── Address
    ├── Promo Code
    ├── Payment Method
    └── Order Confirmation

Orders
    ├── Order History
    ├── Order Details
    ├── Order Timeline
    └── Rider Information

Profile
    ├── Personal Information
    ├── Addresses
    ├── Favorites
    ├── Payment Methods
    └── Ratings & Feedback
```

---

## 🔐 Security

Sensitive development and platform-specific configuration files are intentionally excluded from the public repository.

For example:

```text
.env
google-services.json
node_modules/
build/
.firebase/
```

Firebase security rules are maintained through:

```text
firestore.rules
```

When configuring the project locally, Firebase should be configured using your own Firebase project credentials.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio
* Android SDK
* Git
* Firebase CLI
* FlutterFire CLI

### Clone the repository

```bash
git clone https://github.com/Usman4014/quick-bite.git
```

### Navigate to the project

```bash
cd quick-bite
```

### Install dependencies

```bash
flutter pub get
```

### Configure Firebase

Configure the project with your own Firebase project using FlutterFire:

```bash
flutterfire configure
```

Then configure the required Firebase services for your environment.

### Run the application

```bash
flutter run
```

---

## ⚠️ Firebase Configuration

This repository intentionally does not include platform-specific Firebase configuration files such as:

```text
android/app/google-services.json
```

You should configure Firebase with your own Firebase project before running the application in a new environment.

---

## 🧪 Project Status

**Status: Active Development**

The core customer ordering workflow and backend integration have been implemented, including authentication, products, cart, checkout, orders, promotions, reviews, notifications, riders, and location-based delivery support.

---

## 🎯 What This Project Demonstrates

This project demonstrates practical experience with:

* Flutter application development
* Dart
* GetX state management
* Firebase integration
* Firestore data modeling
* Authentication systems
* Cloud Functions
* Push notifications
* REST API integration
* Location-based services
* Maps integration
* E-commerce/food ordering workflows
* Payment workflows
* Reusable UI architecture
* MVC-style separation of responsibilities
* Form validation
* Error handling
* Loading and empty states
* Git & GitHub

---

## 👨‍💻 Developer

**Usman Shabbir**

Flutter Developer focused on building modern, scalable and user-friendly mobile applications.

### Technologies

`Flutter` `Dart` `Firebase` `Supabase` `GetX` `REST APIs` `OpenStreetMap`

---

## ⭐ Support

If you find this project useful or interesting, consider giving the repository a ⭐ on GitHub.

---

**Built with Flutter ❤️**
