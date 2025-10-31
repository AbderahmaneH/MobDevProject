// help_page.dart
import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, String>> _faqList = [
    {
      'question': 'How do I join a queue?',
      'answer': 'Browse nearby services, select the service you need, and tap "Join Queue". You\'ll receive a queue number and estimated waiting time.',
    },
    {
      'question': 'How do I leave a queue?',
      'answer': 'Go to "My Queues" section, select the active queue, and tap "Leave Queue".',
    },
    {
      'question': 'How will I know when it\'s my turn?',
      'answer': 'You\'ll receive notifications when you\'re 5 people away, next in line, and when it\'s your turn.',
    },
    {
      'question': 'What happens if I miss my turn?',
      'answer': 'You may be moved to the end of the queue or need to rejoin, depending on the service provider\'s policy.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          AppAppBar.sliverAppBar(
            title: 'Help & Support',
            onBackPressed: () => Navigator.pop(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const LogoHeader(
                    title: 'Help Center',
                    subtitle: 'We\'re here to help you!',
                    icon: Icons.help_outline_rounded,
                  ),
                  const SizedBox(height: 32),

                  AppTextFields.textField(
                    hintText: 'Search for help...',
                  ),
                  const SizedBox(height: 32),

                  AppLabels.sectionTitle('Quick Actions'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.phone_outlined,
                          title: 'Call Support',
                          onTap: _showContactDialog,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.email_outlined,
                          title: 'Email Support',
                          onTap: _showEmailDialog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  AppLabels.sectionTitle('Frequently Asked Questions'),
                  const SizedBox(height: 16),
                  ..._faqList.map((faq) => _buildFAQItem(
                    question: faq['question']!,
                    answer: faq['answer']!,
                  )).toList(),
                  const SizedBox(height: 32),

                  AppContainers.card(
                    backgroundColor: AppColors.primary,
                    child: Column(
                      children: [
                        Icon(
                          Icons.support_agent,
                          color: AppColors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Still Need Help?',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Our support team is ready to assist you',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        AppButtons.secondaryButton(
                          text: 'Contact Support',
                          onPressed: _showContactDialog,
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
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainers.card(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.help_outline,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          question,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            answer,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(
            'Contact Support',
            style: AppTextStyles.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactRow(Icons.email, 'qnowteam@gmail.com'),
              const SizedBox(height: 12),
              _buildContactRow(Icons.phone, '0555555555'),
            ],
          ),
          actions: [
            AppButtons.textButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(
            'Email Support',
            style: AppTextStyles.titleLarge,
          ),
          content: Text(
            'Send us an email at qnowteam@gmail.com and we\'ll get back to you within 24 hours.',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            AppButtons.textButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}