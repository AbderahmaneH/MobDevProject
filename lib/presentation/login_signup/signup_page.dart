import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../logic/auth_cubit.dart';
import '../../database/db_helper.dart';
import '../../core/common_widgets.dart';
import '../../presentation/login_signup/login_page.dart';
import '../../presentation/business/business_owner_page.dart';
import '../../presentation/customer/customer_page.dart';
import '../../database/models/user_model.dart';
import '../../database/repositories/user_repository.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        userRepository: UserRepository(databaseHelper: DatabaseHelper()),
      ),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();

  bool _isBusiness = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _navigateToHome(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user.isBusiness
            ? BusinessOwnerPage(user: user)
            : CustomerPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account created successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
              _navigateToHome(state.user);
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
                automaticallyImplyLeading: true,
                backgroundColor: AppColors.backgroundLight,
                surfaceTintColor: AppColors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  context.loc('signup'),
                  style: AppTextStyles.titleLarge(context),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimaryLight),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        LogoHeader(
                          title: context.loc('app_title'),
                          subtitle: context.loc('signup'),
                        ),
                        const SizedBox(height: 24),
                        RoleToggle(
                          isBusinessOwner: _isBusiness,
                          onChanged: (isBusiness) {
                            setState(() {
                              _isBusiness = isBusiness;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        AppLabels.label(context, context.loc('name')),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          context: context,
                          hintText: context.loc('name'),
                          controller: _nameController,
                          validator: (value) => context
                              .read<AuthCubit>()
                              .validateName(value, context),
                        ),
                        const SizedBox(height: 14),
                        AppLabels.label(context, context.loc('phone')),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          context: context,
                          hintText: context.loc('phone'),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) => context
                              .read<AuthCubit>()
                              .validatePhone(value, context),
                        ),
                        const SizedBox(height: 14),
                        if (_isBusiness) ...[
                          AppLabels.label(context, context.loc('email')),
                          const SizedBox(height: 6),
                          AppTextFields.textField(
                            context: context,
                            hintText: context.loc('email'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => context
                                .read<AuthCubit>()
                                .validateEmail(value, context, _isBusiness),
                          ),
                          const SizedBox(height: 14),
                          AppLabels.label(
                              context, context.loc('business_name')),
                          const SizedBox(height: 6),
                          AppTextFields.textField(
                            context: context,
                            hintText: context.loc('business_name'),
                            controller: _businessNameController,
                            validator: (value) => context
                                .read<AuthCubit>()
                                .validateBusinessName(
                                    value, context, _isBusiness),
                          ),
                          const SizedBox(height: 14),
                          AppLabels.label(context, context.loc('address')),
                          const SizedBox(height: 6),
                          AppTextFields.textField(
                            context: context,
                            hintText: context.loc('address'),
                            controller: _businessAddressController,
                            validator: (value) => context
                                .read<AuthCubit>()
                                .validateBusinessAddress(
                                    value, context, _isBusiness),
                          ),
                          const SizedBox(height: 14),
                        ],
                        AppLabels.label(context, context.loc('password')),
                        const SizedBox(height: 6),
                        AppTextFields.passwordField(
                          context: context,
                          hintText: context.loc('password'),
                          controller: _passwordController,
                          isVisible: _showPassword,
                          onToggleVisibility: () =>
                              setState(() => _showPassword = !_showPassword),
                          validator: (value) => context
                              .read<AuthCubit>()
                              .validatePassword(value, context),
                        ),
                        const SizedBox(height: 14),
                        AppLabels.label(
                            context, context.loc('confirm_password')),
                        const SizedBox(height: 6),
                        AppTextFields.passwordField(
                          context: context,
                          hintText: context.loc('confirm_password'),
                          controller: _confirmPasswordController,
                          isVisible: _showConfirmPassword,
                          onToggleVisibility: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          ),
                          validator: (value) =>
                              context.read<AuthCubit>().validateConfirmPassword(
                                    value,
                                    context,
                                    _passwordController.text.trim(),
                                  ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return AppButtons.primaryButton(
                              text: context.loc('signup'),
                              onPressed: isLoading
                                  ? () {}
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().signup(
                                              name: _nameController.text.trim(),
                                              phone:
                                                  _phoneController.text.trim(),
                                              email:
                                                  _emailController.text.trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                              isBusiness: _isBusiness,
                                              businessName:
                                                  _businessNameController.text
                                                      .trim(),
                                              businessAddress:
                                                  _businessAddressController
                                                      .text
                                                      .trim(),
                                            );
                                      }
                                    },
                              isLoading: isLoading,
                              context: context,
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.loc('already_have_account'),
                                style: AppTextStyles.getAdaptiveStyle(
                                  context,
                                  fontSize: 14,
                                  lightColor: AppColors.textSecondaryLight,
                                ),
                              ),
                              AppButtons.textButton(
                                text: context.loc('login'),
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                                context: context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
