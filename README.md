# DayTask — Personal Task Tracker

A Flutter task management app, weekly calendar view, and Supabase backend. as a part of assignment.

**Figma Design:** [ui](https://www.figma.com/design/SCNpmEbYR6Iu8a1Zl2Xh6z/techstax_assignment_ui?node-id=0-1&t=hReihGwONCSOUj8p-1)

**Demo:** [link](https://drive.google.com/file/d/1LWgNw7C1j8y31d1xmELypdkDra3ny-Bk/view?usp=sharing)

---

## Features

- Email/password sign up & login (custom `users` table, no Supabase Auth)
- Persistent login session via SharedPreferences (stays logged in until logout)
- Create, toggle complete, and delete tasks stored in Supabase
- Weekly calendar strip — tap any day to see its tasks
- Smooth fade/slide animations on screen transitions
- Dark theme (`#212832` background, `#FED36A` accent)
- GoRouter with auth guard (unauthenticated users redirected to Login)
- Provider state management

---

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter | 3.41.4+ |
| Dart | 3.11.1+ |
| Android Studio / VS Code | Latest stable |
| Supabase account | [supabase.com](https://supabase.com) |

Check your setup:
```bash
flutter doctor
```

---

## Supabase Setup

1. Create a free project at [supabase.com](https://supabase.com).
2. Go to **SQL Editor** and run:

```sql
CREATE TABLE users (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE tasks (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  is_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

3. Copy your **Project URL** and **anon public key** from **Project Settings → API**.
4. Paste them into `lib/main.dart`:

```dart
const _supabaseUrl = 'YOUR_PROJECT_URL';
const _supabaseAnonKey = 'YOUR_ANON_KEY';
```

> Row Level Security is disabled for this demo app.

---

## Running the App

```bash
# Install dependencies
flutter pub get

# List connected devices
flutter devices

# Run on a connected device or emulator
flutter run

# Run on a specific device
flutter run -d <device_id>
```

---

## Running Tests

```bash
flutter test
```

---

## Building an Android APK

### Debug APK (quick install for testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

Transfer this file to an Android device and install it directly.

### Release APK (optimised, for distribution)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

> The release APK is unsigned by default. To sign it for Play Store upload, configure a keystore — see the [Flutter Android deployment guide](https://docs.flutter.dev/deployment/android#signing-the-app).

### Split APKs by ABI (smaller size per device)

```bash
flutter build apk --split-per-abi
```

Generates separate APKs for `arm64-v8a`, `armeabi-v7a`, and `x86_64`. Use `arm64-v8a` for most modern Android phones.

### App Bundle for Play Store

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Project Structure

```
lib/
├── main.dart                    # Entry point: Supabase init, session restore, Provider
├── app/
│   ├── theme.dart               # Color tokens and ThemeData
│   └── router.dart              # GoRouter with auth redirect guard
├── auth/
│   ├── auth_service.dart        # ChangeNotifier + SharedPreferences session
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── user_model.dart          # Custom UserModel (id, fullName, email)
├── dashboard/
│   ├── dashboard_screen.dart    # Weekly strip + per-day task list
│   ├── task_tile.dart           # Swipe-to-delete tile with toggle
│   └── task_model.dart          # Task data class (date only, no time)
├── create_task/
│   └── create_task_screen.dart  # Task title + date picker form
├── main_shell/
│   └── main_shell.dart          # Persistent bottom nav (Home / Profile tabs)
├── profile/
│   └── profile_screen.dart      # User info + logout
├── services/
│   └── supabase_service.dart    # All Supabase DB calls (no Auth)
├── splash/
│   └── splash_screen.dart       # Shown only when not logged in
└── utils/
    └── validators.dart          # Form validators
```

---

## State Management

Uses **Provider** (`ChangeNotifierProvider`). `AuthService` extends `ChangeNotifier` — GoRouter's `refreshListenable` reacts to every auth state change and redirects automatically.

---

## Bonus Features

- Swipe-to-delete on task tiles (`Dismissible`)
- Pull-to-refresh on task list
- Logout confirmation dialog
- Animated transitions (fade + slide) on all screens
- Sliding indicator on bottom navigation bar
