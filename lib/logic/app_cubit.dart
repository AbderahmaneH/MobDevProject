import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization.dart';
import '../database/models/user_model.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  void changeLanguage(Locale locale) {
    QNowLocalizations().setLocale(locale);
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith());
    } else {
      emit(const AppLoaded());
    }
  }

  void setUserLoggedIn(bool isLoggedIn, {User? user}) {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(
        isLoggedIn: isLoggedIn,
        user: user,
      ));
    } else {
      emit(AppLoaded(
        isLoggedIn: isLoggedIn,
        user: user,
      ));
    }
  }

  void updateUser(User user) {
    final currentState = state;
    if (currentState is AppLoaded) {
      emit(currentState.copyWith(user: user));
    }
  }
}
