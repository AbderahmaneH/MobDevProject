import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/app_colors.dart';
import '../core/localization.dart';
import '../logic/app_cubit.dart';
import '../presentation/login_signup/login_page.dart';
import '../core/common_widgets.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language selector
              _buildLanguageSelector(context),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    LogoHeader(
                      title: context.loc('app_title'),
                      subtitle: context.loc('welcome'),
                      icon: Icons.access_time_filled,
                      iconSize: 60,
                      iconContainerSize: 30,
                    ),

                    const SizedBox(height: 40),

                    // App description
                    Text(
                      context.loc('manage_your_queues'),
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 60),

                    // Buttons
                    Column(
                      children: [
                        AppButtons.primaryButton(
                          text: context.loc('get_started'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          context: context,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentLocale = QNowLocalizations().currentLocale;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton<Locale>(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      QNowLocalizations().getLanguageFlag(
                        currentLocale.languageCode,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_drop_down, color: AppColors.primary),
                  ],
                ),
              ),
              onSelected: (locale) {
                context.read<AppCubit>().changeLanguage(locale);
              },
              itemBuilder: (context) {
                return QNowLocalizations().supportedLocalesList.map((locale) {
                  return PopupMenuItem<Locale>(
                    value: locale,
                    child: Row(
                      children: [
                        Text(
                          QNowLocalizations().getLanguageFlag(
                            locale.languageCode,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          QNowLocalizations().getLanguageName(
                            locale.languageCode,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        );
      },
    );
  }
}
