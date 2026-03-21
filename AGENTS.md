# AGENTS.md - Inventory App

## Project Overview
This is a Flutter-based inventory management application for tracking freezer inventory. It uses Appwrite as a backend database with real-time synchronization.

## Tech Stack
- **Framework**: Flutter (SDK ^3.5.1)
- **State Management**: Riverpod 2.5.1
- **Backend**: Appwrite 13.0.0
- **Local Storage**: SharedPreferencesWithCache
- **Code Generation**: build_runner with copy_with_extension
- **Theming**: animated_theme_switcher

## Project Structure

```
lib/
├── core/
│   ├── constants/        # App titles, messages, keys, env
│   ├── providers/        # Riverpod providers (settings, appwrite deps)
│   ├── repositories/     # Data layer (DatabasesRepository)
│   ├── services/         # LocalStorage, platform utilities
│   ├── themes/           # App theme definitions
│   └── utils/            # Helper utilities
├── data/
│   └── models/           # Item, AppwriteConfig, ErrorInfo
├── presentation/
│   ├── screens/          # HomePage, SettingsPage, Add/Edit Item pages
│   └── widgets/          # Reusable UI components
└── main.dart             # App entry point
```

## Key Models

### Item
```dart
class Item {
  final String id;
  final String name;
  final String category;
  final String location;
  final int quantity;
}
```
- Uses `@CopyWith()` for immutable updates
- Extends `Equatable` for value comparison
- Serialized to/from JSON for Appwrite storage

### AppwriteConfig
```dart
class AppwriteConfig {
  final String endpoint;
  final String projectId;
  final String databaseId;
  final String collectionId;
}
```

## State Management (Riverpod)

### Settings Providers
- `themeProvider` - App theme (light/dark/system)
- `safeDeleteProvider` - Safe delete warning toggle
- `appwriteConfigProvider` - Database configuration

### Dependency Providers
- `Dependency.client` - Appwrite Client
- `Dependency.databases` - Appwrite Databases API
- `Dependency.realtime` - Appwrite Realtime for live updates

### Repository Providers
- `Repository.databases` - DatabasesRepository instance

## Core Architecture

### Data Flow
1. **HomePage** watches `_itemsProvider` (FutureProvider)
2. **DatabasesRepository** fetches items from Appwrite with pagination
3. Realtime subscription via `listenToItems()` for live updates
4. Optimistic UI updates with rollback on error

### Repository Pattern
```dart
DatabasesRepository {
  - getItems()        // Fetch all items (paginated)
  - addItem()         // Create new item
  - updateItem()      // Update existing item
  - removeItem()      // Delete item
  - listenToItems()   // Realtime subscription
}
```

## Key Features

### Item Management
- **Add**: Optimistic UI update, merges if duplicate (same name/category/location)
- **Edit**: Merges quantity if collision occurs
- **Move**: Splits quantity to new location
- **Delete**: Safe delete option with confirmation

### Search & Filter
- Text search by item name
- Advanced filters: category, location (multi-select)
- Auto-update filter options based on existing items

### Real-time Sync
- Appwrite realtime subscription
- Fallback polling (10s interval) on connection loss
- Exponential backoff retry (10s → 20s → 40s...)

### Local Storage
- SharedPreferencesWithCache for:
  - App theme preference
  - Safe delete setting
  - Appwrite config (endpoint, projectId, databaseId, collectionId)
- Falls back to `.env` file on first run

## Configuration

### Environment (.env)
```env
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
DATABASE_ID=your_database_id
COLLECTION_ID=your_collection_id
```

### Appwrite Setup
1. Create database and collection in Appwrite
2. Collection schema: name (string), category (string), location (string), quantity (integer)
3. Run `docker compose up` in `/appwrite` directory

## Development Workflow

### Prerequisites
```bash
# Generate code
dart run build_runner build

# Run Appwrite server (optional, for local development)
cd appwrite && docker compose up --remove-orphans
```

### Running the App
```bash
flutter run
```

## Important Files & Patterns

### Constants Location
- `lib/core/constants/keys.dart` - SharedPreferences keys
- `lib/core/constants/strings.dart` - UI strings, messages, tooltips
- `lib/core/constants/env.dart` - Environment variable names

### Error Handling
- `RepositoryExceptionMixin` wraps repo methods
- `exceptionHandler()` helper for try/catch with callbacks
- `instantExceptionHandler()` for synchronous errors

### UI Patterns
- **Optimistic Updates**: All mutations update UI first, then DB
- **Error Rollback**: On error, revert UI to previous state
- **Focus Management**: Track FocusNode + GlobalKey for each item
- **Theme Support**: System/Light/Dark with smooth transitions

## Common Tasks

### Adding a New Screen
1. Create screen in `lib/presentation/screens/`
2. Add export to `screens.dart`
3. Navigate via `Navigator.push()` with `MaterialPageRoute`

### Adding a New Widget
1. Create widget in `lib/presentation/widgets/`
2. Add export to `widgets.dart`
3. Import via `widgets.dart` for consistency

### Adding a New Model
1. Create in `lib/data/models/`
2. Add `@CopyWith()` annotation
3. Extend `Equatable`
4. Export from `models.dart`
5. Run `dart run build_runner build`

### Updating Appwrite Config
1. Update `appwriteConfigProvider` StateNotifier
2. Call `LocalStorage.updateAppwriteConfig()`
3. Restart app (uses `restart_app` package)

## Known Issues & TODOs
- TODO: Fix "Concurrent modification during iteration" error in realtime stream
- TODO: Lazy build of item focus nodes (performance lag when switching themes)

## Build & Release
- Android keystore signing requires `key.properties` in `/android`
- Keystore file not in repo for security reasons
