import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization.dart';
import '../database/tables.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  void changeLanguage(Locale locale) {
    QNowLocalizations().setLocale(locale);
    emit(LanguageChanged(locale: locale));
  }

  void toggleTheme() {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(
        isDarkMode: !currentState.isDarkMode,
      ));
    } else {
      emit(AppLoaded(isDarkMode: true));
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