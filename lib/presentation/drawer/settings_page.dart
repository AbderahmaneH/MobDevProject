import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../logic/app_cubit.dart';
import '../../core/localization.dart';
import '../../core/common_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool queueNotifications = true;
  bool promotionalNotifications = false;
  bool soundAlerts = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.backgroundLight,
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
                                  color: AppColors.primary.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
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
                          _buildLanguageSelector(context),
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
                                  color: AppColors.primary.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  context.loc('notifications'),
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
                            title: context.loc('queue_notifications'),
                            subtitle: context.loc('queue_notifications_subtitle'),
                            value: queueNotifications,
                            onChanged: (value) {
                              setState(() {
                                queueNotifications = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSwitchSetting(
                            context: context,
                            title: context.loc('promotional_notifications'),
                            subtitle: context.loc('promotional_notifications_subtitle'),
                            value: promotionalNotifications,
                            onChanged: (value) {
                              setState(() {
                                promotionalNotifications = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSwitchSetting(
                            context: context,
                            title: context.loc('sound_alerts'),
                            subtitle: context.loc('sound_alerts_subtitle'),
                            value: soundAlerts,
                            onChanged: (value) {
                              setState(() {
                                soundAlerts = value;
                              });
                            },
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
                                  color: AppColors.primary.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.security_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  context.loc('privacy_security'),
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
                            title: context.loc('privacy_policy'),
                            onTap: () {
                              // TODO: Show privacy policy
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildListTile(
                            context: context,
                            icon: Icons.description_outlined,
                            title: context.loc('terms_of_service'),
                            onTap: () {
                              // TODO: Show terms of service
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildListTile(
                            context: context,
                            icon: Icons.delete_outline,
                            title: context.loc('delete_account'),
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
          activeThumbColor: AppColors.primary,
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
          color: AppColors.primary.withAlpha((0.1 * 255).round()),
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

  Widget _buildLanguageSelector(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    ];

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentLanguage = QNowLocalizations().currentLocale.languageCode;

        return Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: languages.map((lang) {
                final isSelected = currentLanguage == lang['code'];
                return GestureDetector(
                  onTap: () {
                    context.read<AppCubit>().changeLanguage(Locale(lang['code']!));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.buttonSecondaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lang['name']!,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textPrimaryLight,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
