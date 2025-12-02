part of 'app_cubit.dart';

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final bool isLoggedIn;
  final User? user;
  final bool isDarkMode;

  const AppLoaded({
    this.isLoggedIn = false,
    this.user,
    this.isDarkMode = false,
  });

  AppLoaded copyWith({
    bool? isLoggedIn,
    User? user,
    bool? isDarkMode,
  }) {
    return AppLoaded(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isDarkMode: isDarkMode ?? this.isDarkMode,
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