import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../logic/app_cubit.dart';
import '../../core/localization.dart';
import '../../core/common_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppAppBar.sliverAppBar(
              title: context.loc('settings'),
              onBackPressed: () => Navigator.pop(context),
              context: context,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Language Settings
                    AppContainers.card(
                      context: context,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.language,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  context.loc('language'),
                                  style: AppTextStyles.getAdaptiveStyle(
                                    context,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // In the theme toggle section:
                          BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) {
                              final isDarkMode = state is AppLoaded
                                  ? state.isDarkMode
                                  : false;

                              return Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isDarkMode) {
                                          context
                                              .read<AppCubit>()
                                              .toggleTheme();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !isDarkMode
                                              ? AppColors.primary
                                              : AppColors.buttonSecondaryLight,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: !isDarkMode
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.light_mode,
                                              color: !isDarkMode
                                                  ? AppColors.white
                                                  : AppColors.textPrimaryLight,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Light',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? AppColors.white
                                                    : AppColors
                                                          .textPrimaryLight,
                                                fontWeight: !isDarkMode
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isDarkMode) {
                                          context
                                              .read<AppCubit>()
                                              .toggleTheme();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? AppColors.primary
                                              : AppColors.buttonSecondaryLight,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: isDarkMode
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.dark_mode,
                                              color: isDarkMode
                                                  ? AppColors.white
                                                  : AppColors.textPrimaryLight,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Dark',
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? AppColors.white
                                                    : AppColors
                                                          .textPrimaryLight,
                                                fontWeight: isDarkMode
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Theme Settings
                    AppContainers.card(
                      context: context,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.dark_mode_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Theme',
                                  style: AppTextStyles.getAdaptiveStyle(
                                    context,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) {
                              final isDarkMode = state is AppLoaded
                                  ? state.isDarkMode
                                  : false;

                              return Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isDarkMode) {
                                          context
                                              .read<AppCubit>()
                                              .toggleTheme();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !isDarkMode
                                              ? AppColors.primary
                                              : AppColors.buttonSecondaryLight,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: !isDarkMode
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.light_mode,
                                              color: !isDarkMode
                                                  ? AppColors.white
                                                  : AppColors.textPrimaryLight,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Light',
                                              style: TextStyle(
                                                color: !isDarkMode
                                                    ? AppColors.white
                                                    : AppColors
                                                          .textPrimaryLight,
                                                fontWeight: !isDarkMode
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isDarkMode) {
                                          context
                                              .read<AppCubit>()
                                              .toggleTheme();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? AppColors.primary
                                              : AppColors.buttonSecondaryLight,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: isDarkMode
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.dark_mode,
                                              color: isDarkMode
                                                  ? AppColors.white
                                                  : AppColors.textPrimaryLight,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Dark',
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? AppColors.white
                                                    : AppColors
                                                          .textPrimaryLight,
                                                fontWeight: isDarkMode
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notifications Settings
                    AppContainers.card(
                      context: context,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Notifications',
                                  style: AppTextStyles.getAdaptiveStyle(
                                    context,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSwitchSetting(
                            context: context,
                            title: 'Queue Notifications',
                            subtitle: 'Get notified when your turn is near',
                            value: true,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 12),
                          _buildSwitchSetting(
                            context: context,
                            title: 'Promotional Notifications',
                            subtitle: 'Receive offers and updates',
                            value: false,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 12),
                          _buildSwitchSetting(
                            context: context,
                            title: 'Sound Alerts',
                            subtitle: 'Play sound for notifications',
                            value: true,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Privacy Settings
                    AppContainers.card(
                      context: context,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.security_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Privacy & Security',
                                  style: AppTextStyles.getAdaptiveStyle(
                                    context,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildListTile(
                            context: context,
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            onTap: () {
                              // TODO: Show privacy policy
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildListTile(
                            context: context,
                            icon: Icons.description_outlined,
                            title: 'Terms of Service',
                            onTap: () {
                              // TODO: Show terms of service
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildListTile(
                            context: context,
                            icon: Icons.delete_outline,
                            title: 'Delete Account',
                            onTap: () {
                              // TODO: Show delete account confirmation
                            },
                            textColor: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 14,
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
                  darkColor: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: textColor ?? AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          lightColor: textColor ?? AppColors.textPrimaryLight,
          darkColor: textColor ?? AppColors.textPrimaryDark,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondaryLight,
      ),
      onTap: onTap,
    );
  }
}
