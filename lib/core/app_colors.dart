import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Blue
  static const Color primary = Color(0xFF333333); // Deep Blue
  static const Color primaryLight = Color(0xFF6B8BC8);

  // Secondary Colors - Teal/Green
  static const Color secondary = Color(0xFF4ECDC4); // Teal
  static const Color secondaryLight = Color(0xFF7BEFE8);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA); // Very Light Gray
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212529); // Almost Black
  static const Color textSecondaryLight = Color(0xFF6C757D); // Gray
  static const Color textTertiaryLight = Color(0xFFADB5BD); // Light Gray

  // Button Colors
  static const Color buttonPrimaryLight = primary;
  static const Color buttonSecondaryLight = Color(0xFFE9ECEF);
  static const Color buttonDisabledLight = Color(0xFFDEE2E6);

  // Status Colors
  static const Color success = Color(0xFF28A745); // Green
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color warning = Color(0xFFFFC107); // Amber yellow
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color error = Color(0xFFDC3545); // Red
  static const Color errorLight = Color(0xFFF8D7DA);
  static const Color info = Color(0xFF17A2B8); // Cyan/Blue
  static const Color infoLight = Color(0xFFD1ECF1);

  // Queue Status Colors
  static const Color queueActive = success;
  static const Color queueInactive = Color(0xFF6C757D);
  static const Color queuePaused = warning;
  static const Color queueFull = error;
  static const Color queueAlmostFull = Color(0xFFFF6B35); // Orange

  // Customer Status Colors
  static const Color customerWaiting = primary;
  static const Color customerNotified = warning;
  static const Color customerServed = success;
  static const Color customerCancelled = error;
  static const Color customerMissed = Color(0xFF6C757D);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);

  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);

  // Input Field Colors
  static const Color inputBackgroundLight = Color(0xFFFFFFFF);
  static const Color inputBorderLight = Color(0xFFCED4DA);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary],
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary],
  );

  static const Gradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF1E7E34)],
  );

  static Color adaptiveTextColor(BuildContext context) {
    return textPrimaryLight;
  }

  static Color adaptiveBackgroundColor(BuildContext context) {
    return backgroundLight;
  }

  static Color adaptiveCardColor(BuildContext context) {
    return cardLight;
  }

  static Color adaptiveBorderColor(BuildContext context) {
    return borderLight;
  }

  // Material Color for primary color
  static MaterialColor get primarySwatch =>
      const MaterialColor(0xFF333333, <int, Color>{
        50: Color(0xFFE8EAF6),
        100: Color(0xFFC5CAE9),
        200: Color(0xFF9FA8DA),
        300: Color(0xFF7986CB),
        400: Color(0xFF5C6BC0),
        500: primary,
        600: Color(0xFF3949AB),
        700: Color(0xFF303F9F),
        800: Color(0xFF283593),
        900: Color(0xFF1A237E),
      });

  // Material Color for secondary color
  static MaterialColor get secondarySwatch =>
      const MaterialColor(0xFF4ECDC4, <int, Color>{
        50: Color(0xFFE0F2F1),
        100: Color(0xFFB2DFDB),
        200: Color(0xFF80CBC4),
        300: Color(0xFF4DB6AC),
        400: Color(0xFF26A69A),
        500: secondary,
        600: Color(0xFF00897B),
        700: Color(0xFF00796B),
        800: Color(0xFF00695C),
        900: Color(0xFF004D40),
      });
}

class AppFonts {
  static const String heading = 'Inter'; // Modern sans-serif for headings
  static const String body = 'Roboto'; // Clean sans-serif for body
  static const String mono = 'RobotoMono'; // Monospace for code/numbers

  // Font weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

class AppTextStyles {
  static TextStyle getAdaptiveStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? lightColor,
    double? height,
    String? fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? (AppFonts.body),
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: (lightColor ?? AppColors.textPrimaryLight),
      height: height,
    );
  }

  static TextStyle getButtonText(BuildContext context) {
    return getAdaptiveStyle(
      context,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      lightColor: AppColors.white,
    );
  }

  // Text styles
  static TextStyle displayLargeLight = const TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 32,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
  );

  static TextStyle displayMediumLight = const TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 28,
    fontWeight: AppFonts.bold,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
  );

  static TextStyle titleLargeLight = const TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 22,
    fontWeight: AppFonts.semiBold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle titleMediumLight = const TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 18,
    fontWeight: AppFonts.semiBold,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyLargeLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    fontWeight: AppFonts.regular,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyMediumLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: AppFonts.regular,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle bodySmallLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: AppFonts.regular,
    color: AppColors.textTertiaryLight,
  );

  static TextStyle buttonLargeLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    fontWeight: AppFonts.semiBold,
    color: AppColors.white,
  );

  static TextStyle buttonMediumLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: AppFonts.medium,
    color: AppColors.white,
  );

  static TextStyle captionLight = const TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: AppFonts.regular,
    color: AppColors.textTertiaryLight,
  );

  static TextStyle displayLarge(BuildContext context) {
    return displayLargeLight;
  }

  static TextStyle displayMedium(BuildContext context) {
    return displayMediumLight;
  }

  static TextStyle titleLarge(BuildContext context) {
    return titleLargeLight;
  }

  static TextStyle titleMedium(BuildContext context) {
    return titleMediumLight;
  }

  static TextStyle bodyLarge(BuildContext context) {
    return bodyLargeLight;
  }

  static TextStyle bodyMedium(BuildContext context) {
    return bodyMediumLight;
  }

  static TextStyle bodySmall(BuildContext context) {
    return bodySmallLight;
  }

  static TextStyle buttonLarge(BuildContext context) {
    return buttonLargeLight;
  }

  static TextStyle buttonMedium(BuildContext context) {
    return buttonMediumLight;
  }

  static TextStyle caption(BuildContext context) {
    return captionLight;
  }
}