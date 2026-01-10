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
              backgroundColor: AppColors.backgroundLight,
              surfaceTintColor: AppColors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                context.loc('about'),
                style: AppTextStyles.titleLarge(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    LogoHeader(
                      title: context.loc('app_title'),
                      subtitle: context.loc('version'),
                      icon: Icons.access_time_filled,
                      iconSize: 60,
                      iconContainerSize: 30,
                    ),
                    const SizedBox(height: 32),
                    AppLabels.sectionTitle(
                        context, context.loc('about_project')),
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
                            context.loc('smart_queue_title'),
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.loc('smart_queue_description'),
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 14,
                              lightColor: AppColors.textSecondaryLight,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppLabels.sectionTitle(
                        context, context.loc('key_features')),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.access_time,
                          title: context.loc('feature_realtime'),
                          description: context.loc('feature_realtime_desc'),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.notifications_active,
                          title: context.loc('feature_notifications'),
                          description:
                              context.loc('feature_notifications_desc'),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.business,
                          title: context.loc('feature_business_management'),
                          description:
                              context.loc('feature_business_management_desc'),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context: context,
                          icon: Icons.language,
                          title: context.loc('feature_multilanguage'),
                          description:
                              context.loc('feature_multilanguage_desc'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AppLabels.sectionTitle(context, context.loc('dev_team')),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildTeamMember(
                          name: 'Abderrahmane Hababela',
                          role: '0553 72 90 19',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Mohamed Sahnoune Toubal',
                          role: '0794 32 40 12',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Ahmed Ouassim Kacher',
                          role: '0770 10 56 28',
                          context: context,
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember(
                          name: 'Hassane Ait Ahmad Lamara',
                          role: '+33 7 51 31 72 65',
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                            context.loc('contact_us'),
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              lightColor: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildContactInfo(
                            icon: Icons.email,
                            text: 'teamqnow@gmail.com',
                            context: context,
                          ),
                          const SizedBox(height: 8),
                          _buildContactInfo(
                            icon: Icons.phone,
                            text: '+213 553 72 90 19',
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
                    Text(
                      context.loc('version'),
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 12,
                        lightColor: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.loc('copyright_text'),
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 12,
                        lightColor: AppColors.textSecondaryLight,
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
            ),
          ),
        ),
      ],
    );
  }
}
