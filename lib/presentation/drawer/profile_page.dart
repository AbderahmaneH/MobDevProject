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
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
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
    _nameController.text = _currentUser.name;
    _emailController.text = _currentUser.email ?? '';
    _phoneController.text = _currentUser.phone;
    _businessNameController.text = _currentUser.businessName ?? '';
    _businessAddressController.text = _currentUser.businessAddress ?? '';
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
        user: _currentUser,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        businessName: _currentUser.isBusiness
            ? _businessNameController.text.trim()
            : null,
        businessAddress: _currentUser.isBusiness
            ? _businessAddressController.text.trim()
            : null,
      );
    }
    _toggleEditMode();
  }


  Widget _buildInfoField({
    required String displayLabel,
    required String fieldKey,
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
                  displayLabel,
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    lightColor: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                _isEditing && isEditable
                    ? TextField(
                        controller: _getControllerForField(fieldKey),
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
    final key = label.toLowerCase();
    switch (key) {
      case 'name':
        return _nameController;
      case 'email':
        return _emailController;
      case 'phone':
        return _phoneController;
      case 'business_name':
      case 'businessname':
        return _businessNameController;
      case 'business_address':
      case 'businessaddress':
      case 'address':
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
              // Update local user and controllers so UI reflects DB changes
              setState(() {
                _currentUser = state.user;
                _loadUserData();
              });
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
              SliverAppBar(
                backgroundColor: AppColors.backgroundLight,
                surfaceTintColor: AppColors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  context.loc('profile'),
                  style: AppTextStyles.titleLarge(context),
                ),
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
                                _currentUser.isBusiness
                                  ? Icons.business
                                  : Icons.person,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _currentUser.name,
                              style: AppTextStyles.getAdaptiveStyle(
                                context,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                lightColor: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentUser.isBusiness
                                  ? (_currentUser.businessName ?? 'Business Owner')
                                  : 'Customer',
                              style: AppTextStyles.getAdaptiveStyle(
                                context,
                                fontSize: 14,
                                lightColor: AppColors.white.withAlpha((0.8 * 255).round()),
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
                        displayLabel: context.loc('name'),
                        fieldKey: 'name',
                        value: _nameController.text,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoField(
                        displayLabel: context.loc('email'),
                        fieldKey: 'email',
                        value: _emailController.text,
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoField(
                        displayLabel: context.loc('phone'),
                        fieldKey: 'phone',
                        value: _phoneController.text,
                        icon: Icons.phone_outlined,
                        isEditable: false, // Phone shouldn't be editable
                      ),
                      const SizedBox(height: 24),

                      // Business Information (if business user)
                      if (_currentUser.isBusiness) ...[
                        AppLabels.sectionTitle(
                          context,
                          context.loc('business_info'),
                        ),
                        const SizedBox(height: 16),

                        _buildInfoField(
                          displayLabel: context.loc('business_name'),
                          fieldKey: 'business_name',
                          value: _businessNameController.text,
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoField(
                          displayLabel: context.loc('address'),
                          fieldKey: 'business_address',
                          value: _businessAddressController.text,
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Change Password moved to Settings Page
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