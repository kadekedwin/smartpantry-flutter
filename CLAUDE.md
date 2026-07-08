# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install dependencies
flutter run              # run on connected device/emulator
flutter analyze          # static analysis / lint
flutter test             # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter build apk        # build Android APK
flutter build ios        # build iOS (requires macOS + Xcode)
```

## Architecture

**Smart Pantry** is a Flutter app for kitchen/pantry management targeting Indonesian users (all UI text is in Bahasa Indonesia). It talks to a REST API defined in [`API.md`](./API.md).

### Environment

- `.env` file at the project root holds `API_BASE_URL` (default `http://localhost:3000/v1`).
- Loaded in `main()` via `flutter_dotenv` and read through `lib/config/env.dart`.
- Android emulator note: use `http://10.0.2.2:3000/v1` instead of `localhost`.

### Navigation flow

```
OnboardingScreen → LoginScreen → DashboardScreen
```

Navigation uses `Navigator.push` / `Navigator.pushReplacement` directly — no named routes. The auth token is persisted with `shared_preferences` via `TokenStorage` and injected as `Authorization: Bearer <token>` by `ApiClient`.

### Dashboard structure

`DashboardScreen` uses `IndexedStack` to preserve state across five tabs:

| Index | Tab | File |
|-------|-----|------|
| 0 | Home | `tabs/home_tab.dart` |
| 1 | Inventory | `tabs/inventory_tab.dart` |
| 2 | Add item | `tabs/add_tab.dart` |
| 3 | Notifications | `tabs/notification_tab.dart` |
| 4 | Profile | `tabs/profile_tab.dart` |

Home tab still renders hardcoded content (carousel, quick actions, expiring section) — it does not yet call the API.

### Data layer

Data classes live in `lib/models/`. Each has a `fromJson` factory matching the API contract:

- `inventory_item.dart` — `InventoryItem` with `expiredAt` (`DateTime`) and a computed `expiredInfo` getter that returns Indonesian relative-time strings ("3 Hari Lagi", "6 Bulan Lagi"). Category is `'kulkas'` | `'freezer'` | `'rak_dapur'`.
- `notification_item.dart` — `NotificationItem` with `NotificationType` enum (`cooking`, `stock`, `warning`, `expired`); `group` and `time` getters derive display strings from `createdAt`.
- `shopping_item.dart` — `ShoppingItem` with `isBought`.
- `user.dart` — `User`.

### Service layer

Every network call goes through `lib/services/`:

- `api_client.dart` — thin static wrapper over `http` package. Injects the bearer token, encodes/decodes JSON, and unwraps the `{ data, message }` envelope. Non-2xx responses throw `ApiException`.
- `token_storage.dart` — reads/writes the JWT via `shared_preferences`.
- `auth_service.dart`, `profile_service.dart`, `inventory_service.dart`, `shopping_service.dart`, `notification_service.dart` — domain-specific service classes with only static methods.

Screens consume services via `FutureBuilder` (loading spinner + retry button on `ApiException`). No `Provider` / `Riverpod` / `Bloc` — plain `setState` and `Future`s.

### Theming

No centralized theme file. The primary green color `Color(0xFF059669)` / `Color(0xFF0F9F68)` is redeclared as a local constant in each screen. Common semantic colors used across the app:

| Role | Hex |
|------|-----|
| Primary green | `#059669` / `#0F9F68` |
| Foreground | `#111827` / `#1F2937` |
| Muted text | `#6B7280` / `#9CA3AF` |
| Danger/expired | `#EF4444` |
| Background | `#F9FAFB` |

### Widget conventions

- Private helper widgets within a screen file use the `_PrivateClass` naming convention and are defined at the bottom of the same file.
- Tab-level sub-widgets (cards, selectors) live in `lib/screens/dashboard/tabs/widgets/`.
- Shared dashboard widgets (header, search bar, bottom nav) live in `lib/screens/dashboard/widgets/`.

### Dependencies

- `http` — REST client used by `ApiClient`
- `flutter_dotenv` — loads `.env` at startup
- `shared_preferences` — persists the JWT
- `flutter_svg` — Apple sign-in icon on the login screen
