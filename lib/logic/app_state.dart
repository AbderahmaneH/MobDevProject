part of 'app_cubit.dart';

enum AppThemeMode { light, dark, ocean }

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final bool isLoggedIn;
  final User? user;
  final bool isDarkMode;
  final AppThemeMode themeMode;

  const AppLoaded({
    this.isLoggedIn = false,
    this.user,
    this.isDarkMode = false,
    this.themeMode = AppThemeMode.light,
  });

  AppLoaded copyWith({
    bool? isLoggedIn,
    User? user,
    bool? isDarkMode,
    AppThemeMode? themeMode,
  }) {
    return AppLoaded(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class LanguageChanged extends AppState {
  final Locale locale;

  const LanguageChanged({required this.locale});
}

class ThemeChanged extends AppState {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});
}