import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../logic/auth_cubit.dart';
import '../../core/common_widgets.dart';
import '../../presentation/login_signup/signup_page.dart';
import '../../presentation/business/business_owner_page.dart';
import '../../presentation/customer/customer_page.dart';
import '../../database/models/user_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        userRepository: RepositoryProvider.of(context),
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
  final _identifierController = TextEditingController();  // Changed from _phoneController
  final _passwordController = TextEditingController();
  bool _isBusiness = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _identifierController.dispose();  // Changed from _phoneController
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

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(
            context.loc('forgot_password'),
            style: AppTextStyles.titleMedium(context),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc('enter_email_reset'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 14,
                    lightColor: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextFields.textField(
                  context: context,
                  hintText: context.loc('email'),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc('email_required');
                    }
                    if (!value.contains('@')) {
                      return context.loc('invalid_email');
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            AppButtons.textButton(
              text: context.loc('cancel'),
              onPressed: () => Navigator.pop(dialogContext),
              context: context,
            ),
            AppButtons.primaryButton(
              text: context.loc('send_reset_link'),
              isLoading: isLoading,
              onPressed: isLoading
                  ? () {}
                  : () async {
                      if (formKey.currentState!.validate()) {
                        setDialogState(() => isLoading = true);
                        await _sendPasswordResetEmail(
                          emailController.text.trim(),
                          dialogContext,
                        );
                        setDialogState(() => isLoading = false);
                      }
                    },
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail(
      String email, BuildContext dialogContext) async {
    try {
      final response =
          await context.read<AuthCubit>().requestPasswordReset(email);

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc('reset_email_sent')),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (dialogContext.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc('reset_email_error')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.backgroundLight,
                surfaceTintColor: AppColors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  context.loc('login'),
                  style: AppTextStyles.titleLarge(context),
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
                          subtitle: context.loc('login'),
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
                        const SizedBox(height: 24),
                        AppLabels.label(context, 'Email or Phone'),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          context: context,
                          hintText: 'Enter email or phone',
                          controller: _identifierController,
                          keyboardType: TextInputType.text,
                          validator: (value) => context
                              .read<AuthCubit>()
                              .validateEmailOrPhone(value, context),
                        ),
                        const SizedBox(height: 16),
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
                                              _identifierController.text.trim(),
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
                        const SizedBox(height: 12),
                        Center(
                          child: AppButtons.textButton(
                            text: context.loc('forgot_password'),
                            onPressed: () {
                              _showForgotPasswordDialog(context);
                            },
                            context: context,
                          ),
                        ),
                        const SizedBox(height: 16),
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
