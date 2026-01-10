import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/notification_service.dart';
import '../core/localization.dart';
import '../database/models/user_model.dart';
import '../database/repositories/user_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthInitial());

  Future<void> login(String phone, String password, bool isBusiness) async {
    emit(AuthLoading());

    try {
      final user = await _userRepository.getUserByPhone(phone);

      if (user == null) {
        emit(const AuthFailure(error: 'User not found'));
        return;
      }

      if (user.password != password) {
        emit(const AuthFailure(error: 'Invalid password or number'));
        return;
      }

      if (user.isBusiness != isBusiness) {
        emit(const AuthFailure(error: 'Invalid password or number'));
        return;
      }

      emit(AuthSuccess(user: user));
      await NotificationService.registerTokenForUser(user.id!);
    } catch (e) {
      emit(const AuthFailure(error: 'Login failed'));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required bool isBusiness,
    String? businessName,
    String? businessAddress,
    double? latitude,
    double? longitude,
    String? area,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
  }) async {
    emit(AuthLoading());

    try {
      final phoneExists = await _userRepository.isPhoneRegistered(phone);
      if (phoneExists) {
        emit(const AuthFailure(error: 'Phone number already registered'));
        return;
      }

      final user = User(
        id: null,
        name: name,
        email: email,
        phone: phone,
        password: password,
        isBusiness: isBusiness,
        createdAt: DateTime.now(),
        businessName: businessName,
        businessAddress: businessAddress,
        latitude: latitude,
        longitude: longitude,
        area: area,
        city: city,
        state: state,
        pincode: pincode,
        landmark: landmark,
      );

      final userId = await _userRepository.insertUser(user);

      final createdUser = User(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        password: password,
        isBusiness: isBusiness,
        createdAt: DateTime.now(),
        businessName: businessName,
        businessAddress: businessAddress,
        latitude: latitude,
        longitude: longitude,
        area: area,
        city: city,
        state: state,
        pincode: pincode,
        landmark: landmark,
      );

      emit(AuthSuccess(user: createdUser));
      await NotificationService.registerTokenForUser(userId);
    } catch (e) {
      emit(AuthFailure(error: 'Signup failed: $e'));
    }
  }

  Future<void> updateProfile({
    required User user,
    String? name,
    String? email,
    String? businessName,
    String? businessAddress,
  }) async {
    emit(AuthLoading());

    try {
      final updatedUser = User(
        id: user.id,
        name: name ?? user.name,
        email: email ?? user.email,
        phone: user.phone,
        password: user.password,
        isBusiness: user.isBusiness,
        createdAt: user.createdAt,
        businessName: businessName ?? user.businessName,
        businessAddress: businessAddress ?? user.businessAddress,
      );

      await _userRepository.updateUser(updatedUser);
      emit(ProfileUpdated(user: updatedUser));
    } catch (e) {
      emit(AuthFailure(error: 'Update failed: $e'));
    }
  }

  Future<void> changePassword({
    required int? userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());

    try {
      final user = await _userRepository.getUserById(userId);
      if (user == null) {
        emit(const AuthFailure(error: 'User not found'));
        return;
      }

      if (user.password != currentPassword) {
        emit(const AuthFailure(error: 'Current password is incorrect'));
        return;
      }

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: newPassword,
        isBusiness: user.isBusiness,
        createdAt: user.createdAt,
        businessName: user.businessName,
        businessAddress: user.businessAddress,
      );

      await _userRepository.updateUser(updatedUser);
      emit(PasswordChanged());
    } catch (e) {
      emit(AuthFailure(error: 'Password change failed: $e'));
    }
  }

  String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.loc('required_field');
    }
    if (value.length != 10 || !value.startsWith(RegExp(r'0[567]'))) {
      return context.loc('invalid_phone');
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.loc('required_field');
    }
    if (value.length < 6) {
      return context.loc('password_too_short');
    }
    return null;
  }

  String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.loc('required_field');
    }
    if (value.length < 3) {
      return context.loc('invalid_name');
    }
    return null;
  }

  String? validateEmail(String? value, BuildContext context, bool isBusiness) {
    if (isBusiness && (value == null || value.isEmpty)) {
      return context.loc('required_field');
    }
    if (value != null && value.isNotEmpty && !value.contains('@')) {
      return context.loc('invalid_email');
    }
    return null;
  }

  String? validateConfirmPassword(
      String? value, BuildContext context, String password) {
    if (value == null || value.isEmpty) {
      return context.loc('required_field');
    }
    if (value != password) {
      return context.loc('passwords_not_match');
    }
    return null;
  }

  String? validateBusinessName(
      String? value, BuildContext context, bool isBusiness) {
    if (isBusiness && (value == null || value.isEmpty)) {
      return context.loc('required_field');
    }
    return null;
  }

  String? validateBusinessAddress(
      String? value, BuildContext context, bool isBusiness) {
    if (isBusiness && (value == null || value.isEmpty)) {
      return context.loc('required_field');
    }
    return null;
  }

  void logout() {
    emit(AuthInitial());
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mobdevproject-5qvu.onrender.com/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Failed to send reset email'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<void> deleteAccountWithPassword(int? userId, String password) async {
    if (userId == null) {
      emit(const AuthFailure(error: 'User not found'));
      return;
    }
    emit(AuthLoading());
    try {
      final user = await _userRepository.getUserById(userId);
      if (user == null) {
        emit(const AuthFailure(error: 'User not found'));
        return;
      }

      if (user.password != password) {
        emit(const AuthFailure(error: 'Current password is incorrect'));
        return;
      }

      await _userRepository.deleteUser(userId);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(error: 'Delete failed: $e'));
    }
  }
}
