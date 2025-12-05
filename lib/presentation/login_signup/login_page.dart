import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../logic/auth_cubit.dart';
import '../../database/db_helper.dart';
import '../../core/common_widgets.dart';
import '../../presentation/login_signup/signup_page.dart';
import '../../presentation/business/business_owner_page.dart';
import '../../presentation/customer/customer_page.dart';
import '../../database/models/user_model.dart';
import '../../database/repositories/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        userRepository: UserRepository(databaseHelper: DatabaseHelper()),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isBusiness = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
                SnackBar(
                  content: Text('Welcome back, ${state.user.name}!'),
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
              AppAppBar.sliverAppBar(
                title: context.loc('login'),
                onBackPressed: () => Navigator.pop(context),
                context: context,
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

                        // Logo Header
                        LogoHeader(
                          title: context.loc('app_title'),
                          subtitle: context.loc('login'),
                        ),
                        const SizedBox(height: 24),

                        // Role Toggle
                        RoleToggle(
                          isBusinessOwner: _isBusiness,
                          onChanged: (isBusiness) {
                            setState(() {
                              _isBusiness = isBusiness;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Phone Field
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
                        const SizedBox(height: 16),

                        // Password Field
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
                        const SizedBox(height: 20),

                        // Login Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return AppButtons.primaryButton(
                              text: context.loc('login'),
                              onPressed: isLoading
                                  ? () {}
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().login(
                                          _phoneController.text.trim(),
                                          _passwordController.text.trim(),
                                          _isBusiness,
                                        );
                                      }
                                    },
                              isLoading: isLoading,
                              context: context,
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Sign Up Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.loc('dont_have_account'),
                                style: AppTextStyles.getAdaptiveStyle(
                                  context,
                                  fontSize: 14,
                                  lightColor: AppColors.textSecondaryLight,
                                  darkColor: AppColors.textSecondaryDark,
                                ),
                              ),
                              AppButtons.textButton(
                                text: context.loc('signup'),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
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
