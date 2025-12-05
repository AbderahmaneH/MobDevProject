import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization.dart';
import '../database/models/user_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  void changeLanguage(Locale locale) {
    QNowLocalizations().setLocale(locale);
    emit(LanguageChanged(locale: locale));
  }

  void changeTheme(AppThemeMode themeMode) {
    final currentState = state;
    final isDarkMode = themeMode != AppThemeMode.light;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(
        themeMode: themeMode,
        isDarkMode: isDarkMode,
      ));
    } else {
      emit(AppLoaded(
        isDarkMode: isDarkMode,
        themeMode: themeMode,
      ));
    }
  }

  void toggleTheme() {
    final currentState = state;
    if (currentState is AppLoaded) {
      final nextTheme = currentState.isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
      changeTheme(nextTheme);
    } else {
      changeTheme(AppThemeMode.dark);
    }
  }

  void setUserLoggedIn(bool isLoggedIn, {User? user}) {
    emit(AppLoaded(
      isLoggedIn: isLoggedIn,
      user: user,
      isDarkMode: state is AppLoaded ? (state as AppLoaded).isDarkMode : false,
    ));
  }

  void updateUser(User user) {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(user: user));
    }
  }
}