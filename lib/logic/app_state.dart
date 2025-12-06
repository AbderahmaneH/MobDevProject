part of 'app_cubit.dart';

enum AppThemeMode { light }

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final bool isLoggedIn;
  final User? user;
  final AppThemeMode themeMode;

  const AppLoaded({
    this.isLoggedIn = false,
    this.user,
    this.themeMode = AppThemeMode.light,
  });

  AppLoaded copyWith({
    bool? isLoggedIn,
    User? user,
    AppThemeMode? themeMode,
  }) {
    return AppLoaded(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class LanguageChanged extends AppState {
  final Locale locale;

  const LanguageChanged({required this.locale});
}

// ThemeChanged removed: app uses only light theme