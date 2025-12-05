import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../logic/auth_cubit.dart';
import '../../database/db_helper.dart';
import '../../database/repositories/user_repository.dart';
import '../../core/common_widgets.dart';
import '../../database/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        userRepository: UserRepository(databaseHelper: DatabaseHelper()),
      ),
      child: ProfileView(user: user),
    );
  }
}

class ProfileView extends StatefulWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email ?? '';
    _phoneController.text = widget.user.phone;
    _businessNameController.text = widget.user.businessName ?? '';
    _businessAddressController.text = widget.user.businessAddress ?? '';
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Cancel editing - reload original data
        _loadUserData();
      }
    });
  }

  void _saveProfile() {
    if (_isEditing) {
      context.read<AuthCubit>().updateProfile(
        user: widget.user,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        businessName: widget.user.isBusiness
            ? _businessNameController.text.trim()
            : null,
        businessAddress: widget.user.isBusiness
            ? _businessAddressController.text.trim()
            : null,
      );
    }
    _toggleEditMode();
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
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
                  isVisible: false,
                  onToggleVisibility: () {},
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
                  isVisible: false,
                  onToggleVisibility: () {},
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
                  isVisible: false,
                  onToggleVisibility: () {},
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.loc('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthCubit>().changePassword(
                    userId: widget.user.id,
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(context.loc('change')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    bool isEditable = true,
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
              color: AppColors.primary.withAlpha((0.1 * 255).round()),
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
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    lightColor: AppColors.textSecondaryLight,
                    darkColor: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                _isEditing && isEditable
                    ? TextField(
                        controller: _getControllerForField(label),
                        style: AppTextStyles.getAdaptiveStyle(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      )
                    : Text(
                        value,
                        style: AppTextStyles.getAdaptiveStyle(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController _getControllerForField(String label) {
    switch (label) {
      case 'Name':
        return _nameController;
      case 'Email':
        return _emailController;
      case 'Phone':
        return _phoneController;
      case 'Business Name':
        return _businessNameController;
      case 'Business Address':
        return _businessAddressController;
      default:
        return TextEditingController(text: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('profile_updated')),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is PasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('password_changed')),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppAppBar.sliverAppBar(
                title: context.loc('profile'),
                onBackPressed: () => Navigator.pop(context),
                context: context,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Profile Header
                      AppContainers.card(
                        context: context,
                        backgroundColor: AppColors.primary,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.white,
                              child: Icon(
                                widget.user.isBusiness
                                    ? Icons.business
                                    : Icons.person,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.user.name,
                              style: AppTextStyles.getAdaptiveStyle(
                                context,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                lightColor: AppColors.white,
                                darkColor: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.user.isBusiness
                                  ? (widget.user.businessName ?? 'Business Owner')
                                  : 'Customer',
                              style: AppTextStyles.getAdaptiveStyle(
                                context,
                                fontSize: 14,
                                lightColor: AppColors.white.withAlpha((0.8 * 255).round()),
                                darkColor: AppColors.white.withAlpha((0.8 * 255).round()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Edit Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButtons.iconButton(
                            icon: _isEditing ? Icons.save : Icons.edit,
                            onPressed: _saveProfile,
                            backgroundColor: AppColors.primary.withAlpha((0.1 * 255).round()),
                            iconColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Personal Information
                      AppLabels.sectionTitle(
                        context,
                        context.loc('personal_info'),
                      ),
                      const SizedBox(height: 16),

                      _buildInfoField(
                        label: context.loc('name'),
                        value: _nameController.text,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoField(
                        label: context.loc('email'),
                        value: _emailController.text,
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoField(
                        label: context.loc('phone'),
                        value: _phoneController.text,
                        icon: Icons.phone_outlined,
                        isEditable: false, // Phone shouldn't be editable
                      ),
                      const SizedBox(height: 24),

                      // Business Information (if business user)
                      if (widget.user.isBusiness) ...[
                        AppLabels.sectionTitle(
                          context,
                          context.loc('business_info'),
                        ),
                        const SizedBox(height: 16),

                        _buildInfoField(
                          label: context.loc('business_name'),
                          value: _businessNameController.text,
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoField(
                          label: context.loc('address'),
                          value: _businessAddressController.text,
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Change Password
                      AppContainers.card(
                        context: context,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha((0.1 * 255).round()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.lock_outline,
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
                                    context.loc('change_pass'),
                                    style: AppTextStyles.getAdaptiveStyle(
                                      context,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: _showChangePasswordDialog,
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
      ),
    );
  }
}