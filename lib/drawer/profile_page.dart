// profile_page.dart
import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';
import 'about_us_page.dart';
import 'help_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final TextEditingController _nameController = TextEditingController(
    text: 'John Doe',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john.doe@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0500000000',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text('Change Password', style: AppTextStyles.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextFields.passwordField(
                hintText: 'Current Password',
                controller: TextEditingController(),
                isVisible: false,
                onToggleVisibility: () {},
              ),
              const SizedBox(height: 16),
              AppTextFields.passwordField(
                hintText: 'New Password',
                controller: TextEditingController(),
                isVisible: false,
                onToggleVisibility: () {},
              ),
            ],
          ),
          actions: [
            AppButtons.textButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            AppButtons.primaryButton(
              text: 'Change Password',
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Password changed successfully!');
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          AppAppBar.sliverAppBar(
            title: 'Profile',
            onBackPressed: () => Navigator.pop(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Header
                  AppContainers.card(
                    backgroundColor: AppColors.primary,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _nameController.text,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'QM-2024-001',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics
                  Row(
                    children: [
                      Expanded(
                        child: AppContainers.statCard(
                          title: 'Total Queues',
                          value: '24',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppContainers.statCard(
                          title: 'Active Now',
                          value: '2',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Personal Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLabels.sectionTitle('Personal Information'),
                      AppButtons.iconButton(
                        icon: isEditing ? Icons.save : Icons.edit,
                        onPressed: _toggleEditMode,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        iconColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildInfoField(
                    label: 'Full Name',
                    value: _nameController.text,
                    icon: Icons.person_outline,
                    isEditing: isEditing,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    label: 'Email Address',
                    value: _emailController.text,
                    icon: Icons.email_outlined,
                    isEditing: isEditing,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    label: 'Phone Number',
                    value: _phoneController.text,
                    icon: Icons.phone_outlined,
                    isEditing: isEditing,
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 24),

                  // Settings Options
                  _buildOptionTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: _showChangePasswordDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOptionTile(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsPage(),
                      ),
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

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    required bool isEditing,
    required TextEditingController controller,
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? TextField(
                        controller: controller,
                        style: AppTextStyles.bodyLarge,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      )
                    : Text(value, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondaryLight,
      ),
      onTap: onTap,
    );
  }
}
