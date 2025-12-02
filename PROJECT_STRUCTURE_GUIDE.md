# QNow - Improved Project Structure Guide

## 📋 Executive Summary

This document proposes a **Clean Architecture-based project structure** that improves scalability, maintainability, and team collaboration. The new structure separates concerns clearly, makes the codebase easier to navigate, and follows Flutter best practices.

---

## 🏗️ Current vs Proposed Structure

### Current Structure
```
lib/
├── main.dart
├── business_logic/
│   ├── cubits/          (5 cubits with states)
│   └── states/          (empty, but confusing)
├── core/
│   ├── colors.dart
│   └── database/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── pages/           (9 pages, mixed concerns)
    └── widgets/         (1 massive 857-line file)
```

**Problems with current structure:**
- ❌ `states/` folder exists but is empty (confusing)
- ❌ Single massive `widgets.dart` file (857 lines, hard to maintain)
- ❌ No clear separation of features/modules
- ❌ Database logic scattered
- ❌ No localization structure
- ❌ No routing/navigation abstraction
- ❌ No settings/preferences management

---

## ✨ Proposed Structure

```
lib/
├── main.dart
│
├── config/                          # ← NEW: Configuration
│   ├── app_config.dart              # App constants, feature flags
│   ├── routes.dart                  # Route definitions
│   ├── theme.dart                   # App theme (colors, fonts, etc.)
│   └── localization/                # ← NEW: Language support
│       ├── localization.dart        # Main localization class
│       ├── strings_en.dart          # English strings
│       ├── strings_fr.dart          # French strings
│       ├── strings_ar.dart          # Arabic strings
│       └── app_localizations.dart   # Flutter localization delegate
│
├── core/                            # ← IMPROVED: Core utilities
│   ├── constants/
│   │   ├── colors.dart              # Color palette
│   │   ├── fonts.dart               # Font definitions
│   │   ├── dimens.dart              # ← NEW: Spacing, sizes
│   │   └── strings.dart             # ← NEW: Static strings
│   ├── database/
│   │   ├── database_helper.dart
│   │   ├── tables.dart              # Table schema definitions
│   │   └── dummy_data.dart          # Dummy data
│   ├── extensions/                  # ← NEW: Dart extensions
│   │   ├── context_extensions.dart  # BuildContext helpers
│   │   ├── date_time_extensions.dart
│   │   └── string_extensions.dart
│   └── utils/                       # ← NEW: Utility functions
│       ├── validators.dart
│       ├── formatters.dart
│       └── logger.dart              # Simple logging
│
├── data/                            # ← IMPROVED: Data layer
│   ├── datasources/
│   │   ├── user/
│   │   │   ├── user_local_data_source.dart
│   │   │   └── user_remote_data_source.dart  # ← NEW: For future API
│   │   ├── queue/
│   │   │   ├── queue_local_data_source.dart
│   │   │   └── queue_remote_data_source.dart # ← NEW
│   │   └── settings/                         # ← NEW
│   │       └── settings_local_data_source.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── queue_model.dart
│   │   ├── business_owner_model.dart         # ← NEW: Separate model
│   │   └── settings_model.dart               # ← NEW
│   └── repositories/
│       ├── user/
│       │   └── user_repository.dart
│       ├── queue/
│       │   └── queue_repository.dart
│       └── settings/                         # ← NEW
│           └── settings_repository.dart
│
├── business_logic/                  # ← IMPROVED: State management
│   └── cubits/                      # Only cubits, NO states
│       ├── auth/                    # Feature folder
│       │   └── auth_cubit.dart
│       ├── user/
│       │   └── user_cubit.dart
│       ├── queue/
│       │   └── queue_cubit.dart
│       ├── queue_list/              # ← NEW: Customer browsing queues
│       │   └── queue_list_cubit.dart
│       ├── waiting_list/
│       │   └── waiting_list_cubit.dart
│       ├── theme/                   # ← NEW: Theme switching
│       │   └── theme_cubit.dart
│       └── language/                # ← NEW: Language switching
│           └── language_cubit.dart
│
├── presentation/                    # ← IMPROVED: UI layer
│   ├── pages/                       # Full-screen pages
│   │   ├── auth/                    # Feature folder
│   │   │   ├── welcome_page.dart
│   │   │   ├── login_page.dart
│   │   │   └── signup_page.dart
│   │   ├── customer/
│   │   │   ├── customer_home_page.dart
│   │   │   ├── queue_list_page.dart # ← NEW: Separate from home
│   │   │   ├── queue_detail_page.dart
│   │   │   └── waiting_list_page.dart
│   │   ├── business/
│   │   │   ├── business_home_page.dart
│   │   │   ├── queues_page.dart
│   │   │   └── manage_queue_page.dart
│   │   ├── drawer/
│   │   │   ├── profile_page.dart
│   │   │   ├── settings_page.dart   # ← NEW: Settings with language/theme
│   │   │   ├── about_us_page.dart
│   │   │   └── help_page.dart
│   │   └── splash_page.dart         # ← NEW: Splash/Loading screen
│   │
│   └── widgets/                     # ← IMPROVED: Component library
│       ├── common/                  # Shared across all features
│       │   ├── app_button.dart
│       │   ├── app_app_bar.dart
│       │   └── app_drawer.dart      # ← NEW: Improved drawer
│       ├── inputs/                  # ← NEW: Input components
│       │   ├── app_text_field.dart
│       │   ├── app_password_field.dart
│       │   ├── app_search_field.dart
│       │   ├── app_dropdown.dart    # ← NEW
│       │   └── app_toggle.dart      # ← NEW: For language/theme toggle
│       ├── typography/              # ← NEW: Text components
│       │   ├── app_text_styles.dart
│       │   ├── app_heading.dart
│       │   └── app_label.dart
│       ├── containers/              # ← NEW: Layout components
│       │   ├── app_container.dart
│       │   ├── app_card.dart
│       │   └── app_list_item.dart
│       ├── indicators/              # ← NEW: Status/progress indicators
│       │   ├── app_queue_status.dart
│       │   ├── app_user_status.dart
│       │   └── app_loading.dart
│       └── widgets_library.dart     # ← NEW: Central export file
│
└── README.md
```

---

## 📊 Detailed Changes by Section

### 1. **Config Folder** (NEW)
**Purpose:** Application-level configuration and routing

```dart
// config/app_config.dart
class AppConfig {
  static const String appName = 'QNow';
  static const String appVersion = '1.0.0';
  static const bool enableLogging = true;
}

// config/routes.dart
abstract class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  // ... more routes
}

// config/theme.dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryBlue,
        // ...
      ),
      // ... more theme properties
    );
  }
}
```

### 2. **Localization** (NEW)
**Purpose:** Simple multi-language support

```dart
// config/localization/app_localizations.dart
class AppLocalizations {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'app_title': 'QNow',
      'welcome': 'Welcome',
      'login': 'Login',
      'password': 'Password',
      'language': 'Language',
      'settings': 'Settings',
      // ... more strings
    },
    'fr': {
      'app_title': 'QNow',
      'welcome': 'Bienvenue',
      'login': 'Connexion',
      'password': 'Mot de passe',
      'language': 'Langue',
      'settings': 'Paramètres',
    },
    'ar': {
      'app_title': 'كيونو',
      'welcome': 'أهلا',
      'login': 'تسجيل الدخول',
      'password': 'كلمة السر',
      'language': 'اللغة',
      'settings': 'الإعدادات',
    },
  };

  static String translate(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? key;
  }
}
```

### 3. **Core Improvements**
**Purpose:** Centralized utilities and constants

```dart
// core/constants/dimens.dart - NEW: All spacings and sizes
class AppDimens {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
}

// core/extensions/context_extensions.dart - NEW
extension BuildContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  String translate(String key) => 
    AppLocalizations.translate(key, /* get current language */);
}

// core/extensions/string_extensions.dart - NEW
extension StringExtension on String {
  bool get isValidPhone => RegExp(r'^\+?[\d\s]{10,}$').hasMatch(this);
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  String get toTitleCase => 
    split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
}
```

### 4. **Data Layer Improvements**
**Purpose:** Better organization by feature/resource

```
data/
├── datasources/
│   ├── user/
│   │   └── user_local_data_source.dart    # User operations
│   ├── queue/
│   │   └── queue_local_data_source.dart   # Queue operations
│   └── settings/
│       └── settings_local_data_source.dart # SharedPreferences for app settings
├── models/
│   ├── user_model.dart
│   ├── business_owner_model.dart          # NEW: Separate from User
│   ├── queue_model.dart
│   └── settings_model.dart                # NEW: App settings (language, theme)
└── repositories/
    ├── user/
    ├── queue/
    └── settings/                          # NEW: Manage app settings
```

**Benefits:**
- ✅ Each resource has its own datasource/repository
- ✅ Easier to add features (e.g., remote data source later)
- ✅ Clear separation of concerns
- ✅ Scales well as app grows

### 5. **Business Logic Improvements**
**Purpose:** Simplify state management by removing States

**From this:**
```dart
// OLD: Cubit with separate state classes
class AuthCubit extends Cubit<AuthState> {
  // ...
}

abstract class AuthState extends Equatable {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthError extends AuthState {}
```

**To this:**
```dart
// NEW: Cubit with only one state object
class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final User? user;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.user,
  });

  // copyWith for immutability
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, isAuthenticated, errorMessage, user];
}

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;

  AuthCubit({required this.userRepository}) : super(const AuthState());

  Future<void> login(String phone, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await userRepository.login(phone, password);
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
```

**Benefits:**
- ✅ Much simpler to understand (one state object, not multiple classes)
- ✅ Easier to read UI code (check `state.isLoading` instead of `is AuthLoading`)
- ✅ Eliminates the empty `states/` folder confusion
- ✅ Uses `copyWith` pattern for immutability
- ✅ All state variations in ONE place

### 6. **Presentation Layer Improvements**
**Purpose:** Better organization by feature

```
pages/
├── auth/                    # Feature folder
│   ├── welcome_page.dart
│   ├── login_page.dart
│   └── signup_page.dart
├── customer/
│   ├── customer_home_page.dart
│   ├── queue_list_page.dart
│   ├── queue_detail_page.dart
│   └── waiting_list_page.dart
├── business/
│   ├── business_home_page.dart
│   ├── queues_page.dart
│   └── manage_queue_page.dart
└── drawer/
    ├── profile_page.dart
    ├── settings_page.dart   # NEW: Handle language & theme changes
    ├── about_us_page.dart
    └── help_page.dart
```

### 7. **Widgets Reorganization** (MAJOR IMPROVEMENT)

**From:** 1 massive 857-line file
**To:** Organized by component category

```
widgets/
├── common/
│   ├── app_button.dart              # Buttons (primary, secondary, text, etc.)
│   ├── app_app_bar.dart             # AppBar variants
│   └── app_drawer.dart              # Drawer with profile section
├── inputs/
│   ├── app_text_field.dart          # Text input
│   ├── app_password_field.dart      # Password input
│   ├── app_search_field.dart        # Search with debounce
│   ├── app_dropdown.dart            # Dropdown/select
│   └── app_toggle.dart              # Toggle for language/theme
├── typography/
│   ├── app_text_styles.dart         # All text styles
│   ├── app_heading.dart             # Heading component
│   └── app_label.dart               # Label component
├── containers/
│   ├── app_container.dart           # General container
│   ├── app_card.dart                # Card container
│   └── app_list_item.dart           # List item
├── indicators/
│   ├── app_queue_status.dart        # Queue status display
│   ├── app_user_status.dart         # User/member status
│   └── app_loading.dart             # Loading indicator
└── widgets_library.dart             # Central export file
```

**Each widget file example:**

```dart
// widgets/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:QNow/core/constants/colors.dart';
import 'package:QNow/core/constants/dimens.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? placeholder;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final int maxLines;

  const AppTextField({
    required this.label,
    this.placeholder,
    required this.onChanged,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.titleMedium),
        SizedBox(height: AppDimens.paddingS),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
          ),
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**Central export file:**

```dart
// widgets/widgets_library.dart
export 'common/app_button.dart';
export 'common/app_app_bar.dart';
export 'common/app_drawer.dart';
export 'inputs/app_text_field.dart';
export 'inputs/app_password_field.dart';
export 'inputs/app_search_field.dart';
export 'inputs/app_dropdown.dart';
export 'inputs/app_toggle.dart';
export 'typography/app_text_styles.dart';
export 'typography/app_heading.dart';
export 'typography/app_label.dart';
export 'containers/app_container.dart';
export 'containers/app_card.dart';
export 'containers/app_list_item.dart';
export 'indicators/app_queue_status.dart';
export 'indicators/app_user_status.dart';
export 'indicators/app_loading.dart';
```

**Usage becomes simple:**

```dart
// Instead of:
import 'package:QNow/presentation/widgets/widgets.dart';

// You do:
import 'package:QNow/presentation/widgets/widgets_library.dart';
// Then use: AppTextField, AppButton, AppToggle, etc.

// Or even more specific:
import 'package:QNow/presentation/widgets/inputs/app_text_field.dart';
import 'package:QNow/presentation/widgets/common/app_button.dart';
```

---

## 🗄️ Database Schema (Simplified & Better)

### Current Issues:
- Over-complex with many unused fields
- Lacks clear relationships
- Dummy data not realistic

### Proposed Simplified Schema:

```sql
-- USERS TABLE
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  is_business INTEGER NOT NULL DEFAULT 0,  -- 0 = customer, 1 = business owner
  created_at TEXT NOT NULL,
  updated_at TEXT
);

-- BUSINESS_OWNERS TABLE (Profile info for business users)
CREATE TABLE business_owners (
  id INTEGER PRIMARY KEY,
  user_id INTEGER UNIQUE NOT NULL,
  business_name TEXT NOT NULL,
  business_phone TEXT,
  average_wait_time INTEGER DEFAULT 0,  -- in minutes
  created_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- QUEUES TABLE
CREATE TABLE queues (
  id INTEGER PRIMARY KEY,
  business_owner_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  max_size INTEGER DEFAULT 100,
  estimated_wait_time INTEGER DEFAULT 0,  -- minutes
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL,
  FOREIGN KEY (business_owner_id) REFERENCES business_owners(id) ON DELETE CASCADE
);

-- QUEUE_MEMBERS TABLE (Customers in a queue)
CREATE TABLE queue_members (
  id INTEGER PRIMARY KEY,
  queue_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  position INTEGER NOT NULL,  -- Current position in queue
  status TEXT DEFAULT 'waiting',  -- waiting, notified, served, cancelled
  joined_at TEXT NOT NULL,
  served_at TEXT,
  FOREIGN KEY (queue_id) REFERENCES queues(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- APP_SETTINGS TABLE (NEW - for language, theme, etc.)
CREATE TABLE app_settings (
  id INTEGER PRIMARY KEY,
  user_id INTEGER UNIQUE,
  language TEXT DEFAULT 'en',  -- en, fr, ar
  theme TEXT DEFAULT 'light',  -- light, dark
  notifications_enabled INTEGER DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

**Dummy Data:**

```dart
// core/database/dummy_data.dart - Simplified and realistic

Future<void> insertDummyData(Database db) async {
  // Sample users
  const users = [
    {
      'name': 'Ahmed Hassan',
      'email': 'ahmed@example.com',
      'phone': '+212612345678',
      'password': 'hashed_password_123',
      'is_business': 0,
      'created_at': '2024-01-15T10:00:00Z'
    },
    {
      'name': 'Fatima Zahra',
      'email': 'fatima@example.com',
      'phone': '+212612345679',
      'password': 'hashed_password_456',
      'is_business': 1,  // Business owner
      'created_at': '2024-01-10T10:00:00Z'
    },
    // ... more sample customers
  ];

  for (var user in users) {
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Business profile for business owner (user_id = 2)
  await db.insert('business_owners', {
    'user_id': 2,
    'business_name': 'Dr. Hassan Clinic',
    'business_phone': '+212612345679',
    'average_wait_time': 15,
    'created_at': '2024-01-10T10:00:00Z'
  });

  // Queues
  await db.insert('queues', {
    'business_owner_id': 1,
    'name': 'General Consultation',
    'description': 'Regular appointments',
    'max_size': 50,
    'estimated_wait_time': 20,
    'is_active': 1,
    'created_at': '2024-01-15T10:00:00Z'
  });

  // Queue members
  await db.insert('queue_members', {
    'queue_id': 1,
    'user_id': 1,
    'position': 1,
    'status': 'waiting',
    'joined_at': '2024-01-15T10:30:00Z'
  });

  // Settings
  await db.insert('app_settings', {
    'user_id': 1,
    'language': 'en',
    'theme': 'light',
    'notifications_enabled': 1,
    'created_at': '2024-01-15T10:00:00Z'
  });
}
```

---

## 🎯 New Cubits (Cubit-Only Approach)

### 1. **AuthCubit** - Simplified
- State: `AuthState` with `isLoading`, `isAuthenticated`, `user`, `error`
- Methods: `login()`, `signup()`, `logout()`, `checkAuth()`

### 2. **UserCubit** (NEW)
- Manages user profile data
- State: `UserState` with `user`, `isLoading`, `error`
- Methods: `getProfile()`, `updateProfile()`, `changePassword()`

### 3. **QueueCubit** (Business owner)
- Manages queues for business owner
- State: `QueueState` with `queues`, `isLoading`, `error`
- Methods: `getQueues()`, `createQueue()`, `updateQueue()`, `deleteQueue()`

### 4. **QueueListCubit** (NEW - Customer)
- Browse available queues
- State: `QueueListState` with `queues`, `searchQuery`, `isLoading`
- Methods: `searchQueues()`, `filterByDistance()`, `joinQueue()`

### 5. **WaitingListCubit**
- Manage customer's position in queue
- State: `WaitingListState` with `queueMembers`, `currentPosition`, `estimatedTime`
- Methods: `getWaitingList()`, `leaveQueue()`, `notifyCustomer()`

### 6. **LanguageCubit** (NEW)
- Handle language switching
- State: `LanguageState` with `currentLanguage`, `supportedLanguages`
- Methods: `changeLanguage()`, `getTranslation()`

### 7. **ThemeCubit** (NEW)
- Handle theme switching
- State: `ThemeState` with `isDarkMode`
- Methods: `toggleTheme()`, `setTheme()`

### 8. **SettingsCubit** (NEW)
- Manage user settings
- State: `SettingsState` with `language`, `theme`, `notificationsEnabled`
- Methods: `getSettings()`, `updateSettings()`

---

## 🔄 Navigation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Welcome Page                              │
│  (Choose Login or Signup, or continue as guest)             │
└────────────┬────────────────────────────┬───────────────────┘
             │                            │
      ┌──────▼────────┐           ┌───────▼──────────┐
      │   Login Page  │           │   Signup Page    │
      └────────┬──────┘           └───────┬──────────┘
               │                          │
      ┌────────▼──────────────────────────▼──────────┐
      │                                               │
      ▼                                               ▼
┌──────────────────┐                      ┌──────────────────┐
│  Customer Home   │                      │  Business Home   │
│  - Browse Queue  │                      │  - My Queues     │
│  - My Position   │                      │  - Analytics     │
│  - My History    │                      │  - Settings      │
└────────┬─────────┘                      └────────┬─────────┘
         │                                        │
    ┌────▼───────┬──────────┬───────────┐        │
    │             │          │           │        │
    ▼             ▼          ▼           ▼        ▼
┌────────┐ ┌──────────┐ ┌────────┐ ┌────────┐ ┌───────┐
│ Queue  │ │ Waiting  │ │Profile │ │Settings│ │Manage │
│ List   │ │  List    │ │        │ │        │ │Queues │
└────────┘ └──────────┘ └────────┘ └────────┘ └───────┘

From anywhere: ← Drawer (Profile, Settings, About, Help, Logout)
```

---

## 🎨 UI/UX Improvements

### 1. **Drawer Improvements**
- Profile section at top with user avatar, name, and role
- Menu items with icons
- Settings option that opens language/theme selector
- Logout at bottom with confirmation dialog

### 2. **Settings Page (NEW)**
- Language selector (EN, FR, AR) with preview
- Dark/Light theme toggle
- Notification preferences
- About/Help links

### 3. **Text & Spacing**
- Use `AppDimens` for consistent spacing
- Use `AppTextStyles` for consistent typography
- Use `AppColors` for consistent colors

### 4. **Loading States**
- Show loading indicators for async operations
- Disable buttons while loading
- Show error messages clearly

### 5. **Queue Display**
- Color-coded status (waiting: orange, notified: green, served: blue)
- Position/number badge
- Average wait time display
- Queue capacity percentage

---

## 📋 Migration Checklist

- [ ] Create `config/` folder with routes, theme, localization
- [ ] Create localization files (EN, FR, AR)
- [ ] Add `AppDimens` and `AppLocalizations` to core
- [ ] Split `widgets.dart` into 14+ individual files with categories
- [ ] Create `widgets_library.dart` export file
- [ ] Add extensions to `core/extensions/`
- [ ] Reorganize datasources by feature (user/, queue/, settings/)
- [ ] Reorganize repositories by feature (user/, queue/, settings/)
- [ ] Create `SettingsRepository` and `SettingsLocalDataSource`
- [ ] Add `SettingsModel` for app settings
- [ ] Create `LanguageCubit` and `ThemeCubit`
- [ ] Update all cubits to use single `State` object (remove multiple state classes)
- [ ] Create `BusinessOwnerModel` separate from `User`
- [ ] Simplify database schema (remove unused tables/fields)
- [ ] Create new dummy data
- [ ] Reorganize pages by feature (auth/, customer/, business/, drawer/)
- [ ] Create `SettingsPage` with language/theme toggles
- [ ] Create better `AppDrawer` component
- [ ] Update navigation logic and routing
- [ ] Update `main.dart` to provide new cubits
- [ ] Test all features and pages

---

## 📚 Key Benefits

✅ **Scalability:** Easy to add new features and modules
✅ **Maintainability:** Clear folder structure, no massive files
✅ **Reusability:** Small, focused widgets and components
✅ **Testing:** Each component is independently testable
✅ **Performance:** Lazy-loading and feature-based organization
✅ **Team Collaboration:** Clear responsibilities and code ownership
✅ **Localization:** Built-in multi-language support from start
✅ **State Management:** Simpler cubit-only approach is easier to understand

---

## 🚀 Next Steps

1. **Review this structure** - Confirm you agree with the proposed organization
2. **Approve database changes** - Verify the simplified schema works for your needs
3. **Choose language support** - Confirm English, French, Arabic are correct
4. **Start implementation** - I'll begin creating the new structure step-by-step

Would you like me to proceed with implementing this structure? I can start with:
- **Step 1:** Config and localization files
- **Step 2:** Widget reorganization
- **Step 3:** Database improvements
- **Step 4:** Cubit improvements
- **Step 5:** Page reorganization
- **Step 6:** Navigation and routing

---

**End of Structure Guide**
