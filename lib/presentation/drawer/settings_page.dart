import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/models/user_model.dart';
import '../../core/app_colors.dart';
import '../../logic/app_cubit.dart';
import '../../logic/auth_cubit.dart';
import '../../core/localization.dart';
import '../../core/common_widgets.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';
import '../welcome_page.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool queueNotifications = true;
  bool promotionalNotifications = false;
  bool soundAlerts = true;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomePage()),
                    (route) => false,
                  );
                });
              }
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.backgroundLight,
                  surfaceTintColor: AppColors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    context.loc('settings'),
                    style: AppTextStyles.titleLarge(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
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
                                      color: AppColors.primary
                                          .withAlpha((0.1 * 255).round()),
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
                                      color: AppColors.primary
                                          .withAlpha((0.1 * 255).round()),
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
                                subtitle:
                                    context.loc('queue_notifications_subtitle'),
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
                                subtitle: context
                                    .loc('promotional_notifications_subtitle'),
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
                                      color: AppColors.primary
                                          .withAlpha((0.1 * 255).round()),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const PrivacyPolicyPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildListTile(
                                context: context,
                                icon: Icons.description_outlined,
                                title: context.loc('terms_of_service'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const TermsOfServicePage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildListTile(
                                context: context,
                                icon: Icons.lock_outline,
                                title: context.loc('change_pass'),
                                onTap: _showChangePasswordDialog,
                              ),
                              const SizedBox(height: 12),
                              _buildListTile(
                                context: context,
                                icon: Icons.delete_outline,
                                title: context.loc('delete_account'),
                                onTap: _showDeleteAccountDialog,
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
        ));
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool showPassword1 = false;
        bool showPassword2 = false;
        bool showPassword3 = false;

        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is PasswordChanged) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('password_changed')),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is AuthFailure) {
              // Don't close dialog on failure, just show error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: AppColors.adaptiveCardColor(context),
                  title: Text(context.loc('change_pass')),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextFields.passwordField(
                          context: context,
                          hintText: context.loc('current_password'),
                          controller: currentPasswordController,
                          isVisible: showPassword1,
                          onToggleVisibility: () =>
                              setState(() => showPassword1 = !showPassword1),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.loc('required_field');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextFields.passwordField(
                          context: context,
                          hintText: context.loc('new_password'),
                          controller: newPasswordController,
                          isVisible: showPassword2,
                          onToggleVisibility: () =>
                              setState(() => showPassword2 = !showPassword2),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.loc('required_field');
                            }
                            if (value.length < 6) {
                              return context.loc('password_too_short');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextFields.passwordField(
                          context: context,
                          hintText: context.loc('confirm_new_password'),
                          controller: confirmPasswordController,
                          isVisible: showPassword3,
                          onToggleVisibility: () =>
                              setState(() => showPassword3 = !showPassword3),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.loc('required_field');
                            }
                            if (value != newPasswordController.text) {
                              return context.loc('passwords_not_match');
                            }
                            return null;
                          },
                        ),
                        if (isLoading) ...[
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                      child: Text(context.loc('cancel')),
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().changePassword(
                                      userId: widget.user.id,
                                      currentPassword: currentPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    );
                              }
                            },
                      child: Text(context.loc('change')),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool showPassword = false;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(context.loc('delete_account')),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'This will permanently delete your account and data.\nPlease re-enter your password to confirm.',
                    ),
                    const SizedBox(height: 12),
                    AppTextFields.passwordField(
                      context: context,
                      hintText: context.loc('password'),
                      controller: passwordController,
                      isVisible: showPassword,
                      onToggleVisibility: () =>
                          setState(() => showPassword = !showPassword),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc('required_field');
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(context.loc('cancel')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    await context.read<AuthCubit>().deleteAccountWithPassword(
                          widget.user.id,
                          passwordController.text,
                        );

                    Navigator.pop(ctx);
                  },
                  child: Text(context.loc('delete')),
                ),
              ],
            );
          },
        );
      },
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
      {'code': 'ar', 'name': 'العربية', 'flag': '🇩🇿'},
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
                    context
                        .read<AppCubit>()
                        .changeLanguage(Locale(lang['code']!));
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
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
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
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
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
