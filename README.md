# Recipe Finder App

A Flutter recipe discovery app with onboarding, authentication, recipe browsing, search, favorites, and profile screens.

The app is built with Riverpod for state management, GoRouter for navigation, and Supabase for optional backend-backed authentication and recipe data. If Supabase is unavailable or not configured, the recipe repository falls back to local seed data.

## Features

- Onboarding, login, and registration flows
- Supabase authentication when credentials are configured
- Local fallback authentication repository for offline/demo usage
- Home screen with featured recipe content
- Recipe categories and searchable recipe list
- Recipe detail pages with ingredients and instructions
- Favorite recipe toggling
- Profile screen
- Light Material theme with shared UI widgets

## Tech Stack

- Flutter SDK
- Dart 3
- flutter_riverpod
- go_router
- supabase_flutter
- cached_network_image
- google_fonts

## Project Structure

```text
lib/
  config/
    supabase_config.dart
  core/
    constants/
    theme/
    utils/
  features/
    auth/
      data/
      domain/
      presentation/
    profile/
      presentation/
    recipes/
      data/
      domain/
      presentation/
    shell/
      presentation/
  routes/
    app_router.dart
  shared/
    widgets/
  main.dart
test/
  widget_test.dart
```

## Prerequisites

Install the following before running the project:

- Flutter SDK 3.x
- Dart SDK included with Flutter
- Android Studio or VS Code with Flutter extensions
- Android emulator, iOS simulator, Chrome, or a connected device

Check your Flutter setup:

```bash
flutter doctor
```

## Getting Started

Clone or open the project, then install dependencies:

```bash
flutter pub get
```

Run the app on the default available device:

```bash
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

Common examples:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

## Supabase Configuration

Supabase credentials are stored in:

```text
lib/config/supabase_config.dart
```

Current behavior:

- If `SupabaseConfig.isConfigured` returns `true`, the app initializes Supabase and uses Supabase-backed repositories.
- If Supabase is not configured, recipes fall back to local seed data from `lib/core/utils/recipe_seed_data.dart`.
- Local authentication is available through `LocalAuthRepository` when Supabase is disabled.

To disable Supabase for local demo mode, clear the anon key:

```dart
class SupabaseConfig {
  static const url = '';
  static const anonKey = '';

  static bool get isConfigured => anonKey.isNotEmpty;
}
```

To use your own Supabase project, update:

```dart
static const url = 'YOUR_SUPABASE_PROJECT_URL';
static const anonKey = 'YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY';
```

## Expected Supabase Tables

The app reads from these tables:

### `categories`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | text | Primary category id |
| `name` | text | Display name |
| `icon` | text | Optional icon label |

### `recipes`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | text | Primary recipe id |
| `title` | text | Recipe title |
| `image_url` | text | Remote image URL |
| `rating` | numeric | Recipe rating |
| `cook_time_minutes` | integer | Cooking time |
| `category_id` | text | Category reference |
| `description` | text | Short recipe summary |
| `calories` | integer | Calorie count |
| `ingredients` | text[] or json array | Ingredient list |
| `instructions` | text[] or json array | Instruction list |
| `is_featured` | boolean | Featured recipe flag |
| `is_favorite` | boolean | Optional favorite flag used by the model |

### `favorites`

| Column | Type | Notes |
| --- | --- | --- |
| `recipe_id` | text | Recipe id |
| `user_id` | uuid/text | Supabase user id |

The app writes favorite changes to the `favorites` table.

## Useful Commands

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Analyze the project:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Format Dart files:

```bash
dart format .
```

Clean generated build files:

```bash
flutter clean
flutter pub get
```

## Testing

The project includes a basic widget test:

```text
test/widget_test.dart
```

Run it with:

```bash
flutter test
```

## Main Routes

Routes are defined in `lib/routes/app_router.dart`.

| Route | Screen |
| --- | --- |
| `/` | Splash screen |
| `/onboarding` | Onboarding screen |
| `/login` | Login screen |
| `/register` | Register screen |
| `/app` | Main app shell |
| `/search` | Search screen |
| `/recipe/:id` | Recipe details screen |

## Troubleshooting

If dependencies fail to resolve:

```bash
flutter clean
flutter pub get
```

If no devices are available:

```bash
flutter devices
flutter doctor
```

If Supabase requests fail, verify:

- The project URL and anon key in `SupabaseConfig`
- Supabase Auth email/password settings
- Table names and column names match the expected schema
- Row Level Security policies allow the required read/write operations

If network images do not load, confirm that your device or emulator has internet access.

## Notes

- The app currently stores Supabase configuration directly in Dart code.
- For production, avoid committing private keys or service-role keys.
- Only use public Supabase anon or publishable keys in client apps.
