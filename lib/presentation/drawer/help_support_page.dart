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
                    // Contact Support Section
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
                            onTap: () => {}
                          ),
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

                    // FAQ Section
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
                            question: 'How do I join a queue?',
                            answer: 'To join a queue, navigate to the business you want to visit, find the queue, and tap "Join Queue". You will receive notifications when your turn is approaching.',
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: 'Can I leave a queue?',
                            answer: 'Yes, you can leave a queue at any time by going to your active queues and tapping the "Leave" button. Your position will be freed up for other customers.',
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: 'How do I manage notifications?',
                            answer: 'Go to Settings > Notifications to manage all notification preferences. You can enable or disable queue notifications, promotional messages, and sound alerts.',
                          ),
                          const SizedBox(height: 12),
                          _buildFAQItem(
                            context: context,
                            question: 'Is my data secure?',
                            answer: 'Yes, we use industry-standard encryption to protect your personal data. See our Privacy Policy for more details on how we handle your information.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional Resources
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
                                  Icons.info_outline,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Additional Resources',
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
                          _buildResourceLink(
                            context: context,
                            icon: Icons.description,
                            title: 'User Guide',
                            subtitle: 'Learn how to use QNow effectively',
                          ),
                          const SizedBox(height: 12),
                          _buildResourceLink(
                            context: context,
                            icon: Icons.bug_report,
                            title: 'Report a Bug',
                            subtitle: 'Help us improve by reporting issues',
                          ),
                          const SizedBox(height: 12),
                          _buildResourceLink(
                            context: context,
                            icon: Icons.feedback,
                            title: 'Send Feedback',
                            subtitle: 'Share your thoughts and suggestions',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
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

  Widget _buildResourceLink({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secondary.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.secondary, size: 20),
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.secondary,
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
