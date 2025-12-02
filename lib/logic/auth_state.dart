part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});
}

class ProfileUpdated extends AuthState {
  final User user;

  const ProfileUpdated({required this.user});
}

class PasswordChanged extends AuthState {}
