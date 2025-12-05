import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../core/common_widgets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(context.loc('about')),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // App Logo and Info
                    LogoHeader(
                      title: context.loc('app_title'),
                      subtitle: context.loc('version'),
                      icon: Icons.access_time_filled,
                      iconSize: 60,
                      iconContainerSize: 30,
                    ),
                    const SizedBox(height: 32),

                    // About The Project
                    AppLabels.sectionTitle(context, context.loc('about_project')),
                    const SizedBox(height: 16),
                    AppContainers.card(
                      context: context,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.groups_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Smart Queue Management System',
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'QNow revolutionizes the way people wait in queues. '
                            'Our digital solution eliminates physical waiting, '
                            'saving time and improving customer experience.',
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 14,
                              lightColor: AppColors.textSecondaryLight,
                              darkColor: AppColors.textSecondaryDark,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Features
                    AppLabels.sectionTitle(context, 'Key Features'),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.access_time,
                          title: 'Real-time Queue Tracking',
                          description: 'Monitor your position in real-time',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.notifications_active,
                          title: 'Smart Notifications',
                          description: 'Get notified when your turn is near',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.business,
                          title: 'Business Management',
                          description: 'Manage multiple queues efficiently',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.language,
                          title: 'Multi-language Support',
                          description: 'Available in English, French, and Arabic',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Development Team
                    AppLabels.sectionTitle(context, context.loc('dev_team')),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildTeamMember(
                          name: 'Abderrahmane Hababela',
                          role: 'Team Leader',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Mohamed Sahnoune Toubal',
                          role: 'Lead Developer',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Ahmed Ouassim Kacher',
                          role: 'UI/UX Designer',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Hassane Ait Ahmad Lamara',
                          role: 'Backend Developer',
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Contact Information
                    AppContainers.card(
                      context: context,
                      backgroundColor: AppColors.primary,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.contact_mail_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Contact Us',
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              lightColor: AppColors.white,
                              darkColor: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildContactInfo(
                            icon: Icons.email,
                            text: 'qnowteam@gmail.com',
                            context: context,
                          ),
                          const SizedBox(height: 8),
                          _buildContactInfo(
                            icon: Icons.phone,
                            text: '+213 555 555 555',
                            context: context,
                          ),
                          const SizedBox(height: 8),
                          _buildContactInfo(
                            icon: Icons.location_on,
                            text: 'ENSIA, Algiers, Algeria',
                            context: context,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Version and Copyright
                    Text(
                      'Version 1.0.0',
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 12,
                        lightColor: AppColors.textSecondaryLight,
                        darkColor: AppColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2024 QNow. All rights reserved.',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return AppContainers.card(
      context: context,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.buttonSecondaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.1 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role,
                    style: AppTextStyles.getAdaptiveStyle(
                      context,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      lightColor: AppColors.primary,
                      darkColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 14,
              lightColor: AppColors.white,
              darkColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}