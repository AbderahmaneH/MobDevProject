// lib/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF333333); // Dark Charcoal

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF5F5F3); // Soft Beige
  static const Color backgroundDark = Color(0xFF1C1C1E); // Almost Black

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF333333); // Dark Charcoal
  static const Color textSecondaryLight = Color(0xFF6B7280); // Muted Gray

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFE5E5E7); // Light Gray
  static const Color textSecondaryDark = Color(0xFF9CA3AF); // Lighter Gray

  // Button Colors
  static const Color buttonSecondaryLight = Color(0xFFE5E5E7);
  static const Color buttonSecondaryDark = Color(0xFF2C2C2E);

  // Additional useful colors
  static const Color white = Colors.white;
  static const Color red = Colors.red;
}

class AppFonts {
  static const String display = 'Lora'; // serif
  static const String body = 'Poppins'; // sans-serif
}
