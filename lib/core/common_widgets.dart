import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'localization.dart';

// ==============================
// BUTTONS - Enhanced with more options
// ==============================

class AppButtons {
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    double? width,
    double? height,
    bool isFullWidth = true,
    bool isLoading = false,
    Color? backgroundColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required BuildContext context,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? (AppColors.primary),
          disabledBackgroundColor: (backgroundColor ?? AppColors.primary)
              .withAlpha((0.5 * 255).round()),
          foregroundColor: textColor ?? AppColors.white,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.white,
                  ),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  lightColor: textColor ?? AppColors.white,
                ),
              ),
      ),
    );
  }

  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    double? width,
    double? height,
    bool isFullWidth = true,
    bool isLoading = false,
    Color? borderColor,
    Color? textColor,
    required BuildContext context,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.primary,
                  ),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  lightColor: textColor ?? AppColors.primary,
                ),
              ),
      ),
    );
  }

  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    Color? textColor,
    bool underline = false,
    required BuildContext context,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          lightColor: textColor ?? AppColors.primary,
        ).copyWith(
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  static Widget iconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
    double size = 40,
    double iconSize = 24,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        padding: padding ?? const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
      iconSize: size,
      color: iconColor ?? AppColors.white,
    );
  }

  static Widget floatingActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
    required BuildContext context,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      icon: Icon(icon, color: iconColor ?? AppColors.white),
      label: Text(
        label,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          lightColor: iconColor ?? AppColors.white,
        ),
      ),
    );
  }
}

// ==============================
// TEXT FIELDS - Enhanced with more options
// ==============================

class AppTextFields {
  static Widget textField({
    required String hintText,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    bool enabled = true,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      style: AppTextStyles.getAdaptiveStyle(
        context,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 14,
          lightColor: AppColors.textSecondaryLight,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: enabled
            ? (AppColors.inputBackgroundLight)
            : AppColors.buttonDisabledLight,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: _inputBorder(context),
        enabledBorder: _inputBorder(context, isEnabled: true),
        focusedBorder: _inputBorder(context, isFocused: true),
        errorBorder: _inputBorder(context, hasError: true),
        focusedErrorBorder:
            _inputBorder(context, isFocused: true, hasError: true),
        disabledBorder: _inputBorder(context, isEnabled: false),
      ),
    );
  }

  static Widget passwordField({
    required String hintText,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    required BuildContext context,
  }) {
    return textField(
      context: context,
      hintText: hintText,
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      textInputAction: textInputAction,
      onChanged: onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondaryLight,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  static Widget searchField({
    required String hintText,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return textField(
      context: context,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onChanged,
      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondaryLight),
    );
  }

  static InputBorder _inputBorder(
    BuildContext context, {
    bool isEnabled = true,
    bool isFocused = false,
    bool hasError = false,
  }) {
    Color borderColor;
    double borderWidth = 1.0;

    if (hasError) {
      borderColor = AppColors.error;
      borderWidth = isFocused ? 2.0 : 1.0;
    } else if (isFocused) {
      borderColor = AppColors.primary;
      borderWidth = 2.0;
    } else if (!isEnabled) {
      borderColor = AppColors.inputBorderLight;
    } else {
      borderColor = AppColors.inputBorderLight;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

// ==============================
// LABELS - Enhanced with more variants
// ==============================

class AppLabels {
  static Widget label(
    BuildContext context,
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Text(
      text,
      style: style ??
          AppTextStyles.getAdaptiveStyle(
            context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  static Widget sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.getAdaptiveStyle(
        context,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget sectionSubtitle(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.getAdaptiveStyle(
        context,
        fontSize: 12,
        lightColor: AppColors.textSecondaryLight,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget errorLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.getAdaptiveStyle(
        context,
        fontSize: 12,
        lightColor: AppColors.error,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget chipLabel(
    BuildContext context,
    String text, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (AppColors.primary.withAlpha((0.1 * 255).round())),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          lightColor: textColor ?? AppColors.primary,
        ),
      ),
    );
  }
}

// ==============================
// CARDS & CONTAINERS - Enhanced with more variants
// ==============================

class AppContainers {
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    VoidCallback? onTap,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? shadow,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor ?? (AppColors.cardLight),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: shadow ??
              [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: child,
      ),
    );
  }

  static Widget statCard({
    required String title,
    required String value,
    Color? backgroundColor,
    Color? textColor,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? (AppColors.primary),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              lightColor: textColor ?? AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 12,
              lightColor: textColor?.withAlpha((0.8 * 255).round()) ??
                  AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  static Widget listTileCard({
    required String title,
    required String subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    Color? backgroundColor,
    required BuildContext context,
  }) {
    return card(
      context: context,
      onTap: onTap,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (leading != null) ...[
            leading,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    lightColor: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing,
          ],
        ],
      ),
    );
  }
}

// ==============================
// ROLE TOGGLE - Enhanced with animations
// ==============================

class RoleToggle extends StatelessWidget {
  final bool isBusinessOwner;
  final ValueChanged<bool> onChanged;
  final Duration animationDuration;

  const RoleToggle({
    super.key,
    required this.isBusinessOwner,
    required this.onChanged,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildToggleOption(
            text: context.loc('customer'),
            isSelected: !isBusinessOwner,
            onTap: () => onChanged(false),
          ),
          _buildToggleOption(
            text: context.loc('business_owner'),
            isSelected: isBusinessOwner,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: animationDuration,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected
                    ? AppColors.white
                    : (AppColors.textSecondaryLight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==============================
// LOGO HEADER - Enhanced with more customization
// ==============================

class LogoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double iconSize;
  final double iconContainerSize;

  const LogoHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconSize = 48,
    this.iconContainerSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(iconContainerSize),
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.2 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon ?? Icons.access_time_filled,
              color: iconColor ?? AppColors.white,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.getAdaptiveStyle(
                context,
                fontSize: 14,
                lightColor: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ==============================
// NEW: LOADING & EMPTY STATES
// ==============================

class AppStates {
  static Widget loadingState({
    String message = 'Loading...',
    required BuildContext context,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyState({
    required String message,
    String? subtitle,
    IconData icon = Icons.inbox,
    required BuildContext context,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.getAdaptiveStyle(
                context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 14,
                  lightColor: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget errorState({
    required String message,
    String? subtitle,
    VoidCallback? onRetry,
    required BuildContext context,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.getAdaptiveStyle(
                context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 14,
                  lightColor: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              AppButtons.primaryButton(
                text: context.loc('try_again'),
                onPressed: onRetry,
                isFullWidth: false,
                context: context,
              ),
            ],
          ],
        ),
      ),
    );
  }
}