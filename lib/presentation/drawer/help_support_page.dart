import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../core/common_widgets.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
                context.loc('help'),
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
                                  Icons.contact_support,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  context.loc('contact_support'),
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
                          _buildContactTile(
                              context: context,
                              icon: Icons.email,
                              title: context.loc('email_support'),
                              subtitle: 'support@qnow.com',
                              onTap: () => {}),
                          const SizedBox(height: 12),
                          _buildContactTile(
                            context: context,
                            icon: Icons.phone,
                            title: context.loc('call_support'),
                            subtitle: '0553 72 90 19',
                            onTap: () => _launchPhone('0553729019'),
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
                                  Icons.help_outline,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  context.loc('faq'),
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
                          _buildFAQItem(
                            context: context,
                            question: context.loc('how_do_i_join_queue'),
                            answer: context.loc('join_queue_answer'),
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: context.loc('can_i_leave_queue'),
                            answer: context.loc('leave_queue_answer'),
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: context.loc('manage_notifications'),
                            answer: context.loc('manage_notifications_answer'),
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: context.loc('data_security'),
                            answer: context.loc('data_security_answer'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 12,
          lightColor: AppColors.textSecondaryLight,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha((0.05 * 255).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withAlpha((0.1 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.help_outline,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 12,
              lightColor: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
