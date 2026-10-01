# QuickCart

A simple e-commerce mobile app built with Flutter. Products are loaded from the public [FakeStore API](https://fakestoreapi.com).

## Features

- Browse products in a 2-column grid
- Filter by category (loaded from the API)
- Search products by title
- Product details screen with description and rating
- Favorites (heart icon)
- Shopping cart with quantity controls, remove, and total price
- Loading state, error state with Retry, and pull-to-refresh

## Tech Stack

- Flutter (Material 3)
- Provider (state management)
- http (API requests)

## Project Structure

```
lib/
├── main.dart
├── models/        # Product model
├── services/      # API service
├── providers/     # Product and cart state
└── screens/       # Home, Details, Cart
```

## Getting Started

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install) and an emulator or a physical device.

```bash
git clone https://github.com/USERNAME/quickcart.git
cd quickcart
flutter pub get
flutter run
```

> An internet connection is required to load products.

## API Endpoints

- `GET /products`
- `GET /products/categories`
- `GET /products/category/{name}`

## Screenshots

_Add screenshots here._

## License

This project is for learning purposes.
