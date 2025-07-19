# 🍽️ Tasty and Easy
![tastyandeasy-ezgif com-resize](https://github.com/user-attachments/assets/9c65489a-00a4-412d-947b-94f6836fea54)

## 📌 Application Description
Tasty and Easy is a modern mobile application built with Flutter for discovering and cooking a variety of recipes.
The app allows users to easily search for recipes, save them, use filters, and upload their own recipes with images.
The project uses Firebase for data storage and authentication.

# ✨ Key Features

## 🔐 Authentication & Onboarding

Sign up and log in with email/password

Google Sign-In via Firebase Authentication

Email validation using email_validator

Persistent user session

Ability to log out anytime

## 📖 Recipes

Browse recipes with images

Comment on recipes

Recipe categories

Detailed recipe view: ingredients, description, and photos

## ⭐ UI & UX

Clean and intuitive user interface

Parallax effect in recipe lists

Responsive design for various screen sizes

Beautiful typography (auto_size_text + font_awesome_flutter)

## ⚙️ Functionalities

Save user data and preferences with shared_preferences

Manage recipes using Cloud Firestore and Firebase Realtime Database

Upload recipe images to Firebase Storage

## 🚀 App Flow

New user → Sign up or log in

Navigate to the main screen with recipe listings

Browse or add new recipes

Users can log out at any time

## 🧱 Technical Stack

### ✅ Technologies

Frontend: Flutter

Backend & Auth: Firebase (Authentication, Firestore, Storage, Realtime Database)

State Management: setState (option to integrate Provider/Cubit in the future)

Routing: Navigator 2.0

Storage: shared_preferences

UI Enhancements: auto_size_text, parallax, font_awesome_flutter

Validation: email_validator

Icons & Design: flutter_launcher_icons

### 📦 pubspec.yaml – excerpt

yaml
Kopiuj
Edytuj
dependencies:
  flutter: sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.7.1
  cloud_firestore: ^4.9.3
  firebase_storage: ^11.2.8
  firebase_database: ^10.2.7
  google_sign_in: ^6.2.2
  email_validator: ^2.1.17
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  parallax: ^1.0.3
  auto_size_text: ^3.0.0
  intl: ^0.19.0
  font_awesome_flutter: ^10.4.0
  uuid: ^4.2.1
  

