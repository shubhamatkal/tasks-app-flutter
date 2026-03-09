# DayTask — Personal Task Tracker

A Flutter app for managing personal tasks with Supabase authentication and storage. Built to match the DayTask Figma design.

---

## Features

- Email/password authentication (Sign Up, Log In, Log Out) via Supabase
- Create, toggle complete, and delete tasks stored in Supabase
- Weekly calendar strip on the dashboard
- Smooth fade/slide animations on screen transitions
- Dark theme matching the Figma design (`#212832` background, `#FED36A` accent)
- GoRouter navigation with auth guard (unauthenticated users redirected to Login)
- Provider state management for auth state

---

## Setup Instructions

### 1. Prerequisites

- Flutter 3.41+ installed (`flutter --version`)
- A Supabase account and project

### 2. Clone and install

```bash
git clone <repo-url>
cd tasks-app-flutter
flutter pub get
```

### 3. Supabase Setup

1. Create a free project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** and run:

```sql
create table tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  title text not null,
  is_completed boolean default false,
  created_at timestamp with time zone default now()
);

alter table tasks enable row level security;

create policy "Users can manage their own tasks"
on tasks for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
```

3. Go to **Authentication → Settings** and disable **Confirm email** for easier local testing.
4. Copy your **Project URL** and **anon key** from **Settings → API**.
5. Update `lib/main.dart`:

```dart
const _supabaseUrl = 'YOUR_PROJECT_URL';
const _supabaseAnonKey = 'YOUR_ANON_KEY';
```

### 4. Run the app

```bash
flutter run
```

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, Supabase init, Provider setup
├── app/
│   ├── theme.dart             # DayTask color tokens and ThemeData
│   └── router.dart            # GoRouter config with auth redirect guard
├── auth/
│   ├── login_screen.dart      # Login form
│   ├── signup_screen.dart     # Sign up form
│   └── auth_service.dart      # ChangeNotifier wrapping Supabase auth
├── dashboard/
│   ├── dashboard_screen.dart  # Schedule screen: week strip + task list
│   ├── task_tile.dart         # Reusable TaskTile widget (toggle + delete)
│   └── task_model.dart        # Task data class with fromJson/toJson
├── create_task/
│   └── create_task_screen.dart # New task form
├── profile/
│   └── profile_screen.dart    # User profile + logout
├── services/
│   └── supabase_service.dart  # Singleton: all Supabase DB + auth calls
└── utils/
    └── validators.dart        # Form field validators
```

---

## Running Tests

```bash
flutter test test/task_model_test.dart
```

The test covers `Task` model serialization, `fromJson`, `toJson`, `copyWith`, equality, and default field values.

---

## Hot Reload vs Hot Restart

| | Hot Reload | Hot Restart |
|---|---|---|
| **What it does** | Injects updated Dart code into the running VM and rebuilds the widget tree | Fully restarts the Dart VM and re-runs `main()` |
| **State preserved?** | Yes — widget state, variables, and navigation stack are kept | No — all state is reset to initial values |
| **When to use** | UI tweaks, style changes, adding widgets | Changing `initState`, `main()`, global variables, or Provider setup |
| **How to trigger** | Save file in IDE / press `r` in terminal | Press `R` in terminal or use IDE restart button |
| **Speed** | Very fast (~1s) | Slower (~3–5s) |

---

## State Management

Uses **Provider** (`ChangeNotifierProvider`). `AuthService` extends `ChangeNotifier` and listens to Supabase's `onAuthStateChange` stream — GoRouter's `refreshListenable` reacts to every auth change and redirects automatically.

---

## Bonus Features Implemented

- Swipe-to-delete on task tiles (Dismissible)
- Pull-to-refresh on task list
- Logout confirmation dialog
- Animated transitions (fade + slide) on all screens
