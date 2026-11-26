# Southsea Cinema

A Flutter mobile app for browsing Southsea Cinema screenings, choosing tickets, managing a basket, and saving bookings locally.

## Features

- Browse movies and screening details loaded from `assets/data/movies.json`.
- View a film synopsis, age rating, screening time, poster, and ticket price.
- Select between zero and five tickets for a film.
- Add ticket selections to an in-memory basket.
- Remove items from the basket and review the subtotal and total.
- Checkout to save a booking in a local SQLite database.
- View previously saved and sample bookings in the basket screen.
- Save patron number, address, email address, and newsletter preference with `shared_preferences`.
- Switch between light and dark themes.

## Screenshots

> Replace each placeholder with a screenshot of the app. Suggested filenames are included below.

### Home

<!-- Screenshot: add an image at images/home_screenshot.png -->

### Movie details

<!-- Screenshot: add an image at images/movie_details_screenshot.png -->

### Basket and past bookings

<!-- Screenshot: add an image at images/basket_screenshot.png -->

### Settings

<!-- Screenshot: add an image at images/settings_screenshot.png -->

## Platform support

The app is configured to run on Android only. An unsupported-platform message is displayed when attempting to run the app on web or desktop.

Use an Android emulator or a physical Android device.

## Getting started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) with the Android toolchain configured
- Android Studio, an Android emulator, or a physical Android device
- Git

### Clone

```bash
git clone https://github.com/onlinejoash/southsea_cinema.git
cd southsea_cinema
```

### Install dependencies

```bash
flutter pub get
```

### Run

Start an Android emulator or connect an Android device, then run:

```bash
flutter run
```

## Tests

Run the automated test suite with:

```bash
flutter test
```

To collect a coverage report:

```bash
flutter test --coverage
```

The coverage report is written to `coverage/lcov.info`.

### Test Coverage

- Starting Coverage: 86.3%
- Final Coverage: TBA

## Project structure

```text
lib/
├── constants.dart                 # App title and shared theme colours
├── main.dart                      # App setup, themes, routes, and platform guard
├── database/
│   └── cinema_db.dart             # SQLite booking database
├── models/
│   ├── booking.dart               # Saved booking model
│   ├── cart_item.dart             # Basket item model
│   ├── movie.dart                 # Movie model
│   └── user_settings.dart         # User settings model
├── repositories/
│   ├── cart_repository.dart       # In-memory basket
│   └── movie_repository.dart      # Bundled movie data and asset loading
├── views/
│   ├── home_view.dart             # Movie list
│   ├── movie_listing.dart         # Movie details and ticket selection
│   ├── basket_view.dart           # Basket, checkout, and booking history
│   └── settings_screen.dart       # Patron and theme settings
└── widgets/
    ├── movie_card.dart
    ├── nav_drawer.dart
    └── primary_button.dart
assets/
├── data/
│   └── movies.json
└── images/
    ├── EEAAO_Poster.png
    └── Wicked_Poster.png
test/                              # Model, repository, database, and widget tests
```
