# Digify HR System

A comprehensive Human Resources management system built with Flutter for web.

## Architecture

**Clean Architecture** with Riverpod state management:

- **Presentation**: UI widgets, screens, providers
- **Domain**: Business logic, use cases, repository interfaces
- **Data**: API clients, DTOs, repository implementations

## Tech Stack

- Flutter (SDK 3.35.0)
- Riverpod (v2.6.1) - State management
- GoRouter (v14.6.2) - Routing
- Dio (v5.4.0) - Networking
- ScreenUtil - Responsive design
- Localization (English + Arabic RTL)

## Project Structure

```
lib/
├── core/              # Shared infrastructure
│   ├── constants/    # Colors, constants
│   ├── localization/ # i18n (EN/AR)
│   ├── navigation/   # Layout, sidebar
│   ├── network/      # API client, endpoints
│   ├── router/       # GoRouter config
│   ├── theme/        # Light/Dark themes
│   └── widgets/      # Reusable components
│
└── features/         # Feature modules
    ├── auth/
    ├── dashboard/
    ├── enterprise_structure/
    └── workforce_structure/

    Each feature:
    ├── presentation/  # screens/, widgets/, providers/
    ├── domain/        # models/, repositories/, usecases/
    └── data/          # datasources/, dto/, repositories/
```

## Setup

```bash
# Install dependencies
flutter pub get

# Generate localizations
flutter gen-l10n

# Run web app
flutter run -d chrome
```

## Configuration

Update API URL in `lib/core/network/api_config.dart`:

## Features

- Enterprise Structure Management (Companies, Divisions, Business Units, etc.)
- Workforce Structure Management (Positions, Job Families, Job Levels, etc.)
- Multi-language support (English/Arabic RTL)
- Responsive design
- Dark mode

---

**Built with Flutter** 🚀
