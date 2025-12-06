part of 'app_cubit.dart';

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final bool isLoggedIn;
  final User? user;

  const AppLoaded({
    this.isLoggedIn = false,
    this.user,
  });

  AppLoaded copyWith({
    bool? isLoggedIn,
    User? user,
  }) {
    return AppLoaded(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}

class LanguageChanged extends AppState {
  final Locale locale;

  const LanguageChanged({required this.locale});
}
