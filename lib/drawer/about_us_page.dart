// about_us_page.dart
import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          AppAppBar.sliverAppBar(
            title: 'About Us',
            onBackPressed: () => Navigator.pop(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const LogoHeader(
                    title: 'QNow',
                    subtitle: 'Version 1.0.0',
                    icon: Icons.access_time_filled,
                  ),
                  const SizedBox(height: 32),
                  
                  AppLabels.sectionTitle('About The Project'),
                  const SizedBox(height: 16),
                  Text(
                    'Queue Management System is an innovative mobile application designed to revolutionize the way people manage their time in queues. Our solution eliminates the frustration of physical waiting by providing a smart, digital alternative.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  _buildInfoCard(
                    icon: Icons.school_rounded,
                    title: 'Educational Institution',
                    content: 'National Higher School of Artificial Intelligence (ENSIA) - Algeria',
                  ),
                  const SizedBox(height: 24),

                  AppLabels.sectionTitle('Development Team'),
                  const SizedBox(height: 16),
                  _buildTeamMember(
                    name: 'Abderrahmane Hababela',
                    role: 'Team Leader' ,
                  ),
                  const SizedBox(height: 12),
                  _buildTeamMember(
                    name: 'Mohamed Sahnoune Toubal',
                    role: 'Developer',
                  ),
                  const SizedBox(height: 12),
                  _buildTeamMember(
                    name: 'Ahmed Ouassim Kacher',
                    role: 'Developer',
                  ),
                  const SizedBox(height: 12),
                  _buildTeamMember(
                    name: 'Hassane Ait Ahmad Lamara',
                    role: 'Developer',
                  ),
                  const SizedBox(height: 32),

                  AppContainers.card(
                    backgroundColor: AppColors.primary,
                    child: Column(
                      children: [
                        Icon(
                          Icons.contact_mail_rounded,
                          color: AppColors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Contact Us',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildContactInfo(
                          icon: Icons.email,
                          text: 'abderahmane.hababela@ensia.edu.dz',
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(
                          icon: Icons.phone,
                          text: '0555555555',
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return AppContainers.card(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
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
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
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
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}