# vitec_assessment

A Flutter application built for a coding challenge from Vitec.

## About

This app fetches and displays interesting travel routes, showing details like location, duration, cost, and distance. Users can browse routes and load more as needed. All data is cached locally and refreshes every minute to ensure up-to-date information while minimizing server load.

## Architecture

The app follows MVVM + Repository pattern with BLoC for state management. Here's how it's structured:

lib/
├── data/              # Data layer
│   ├── models/        # Data models
│   ├── repositories/  # Repository implementations  
│   └── services/      # API service
├── presentation/      # UI layer
│   ├── screens/       # App screens
│   ├── widgets/       # Reusable widgets
│   └── blocs/         # Business Logic Components
└── core/              # Core utilities & configs
   └── error/         # Error handling

## Features
- View travel routes with details
- Load more routes on demand  
- Data caching
- Error handling

## Dependencies
- flutter_bloc: State management
- equatable: Value comparison
- dio: HTTP client
- flutter_secure_storage: Local storage
- cached_network_image: Image loading and caching

