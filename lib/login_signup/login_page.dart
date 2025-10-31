import 'package:flutter/material.dart';
import 'create_account_page.dart';
import '../login_signup/welcome_page.dart';
import '../models/user_database.dart';
import '../business_owner/queues_page.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isBusinessOwner = false;
  bool showPassword = false;
  bool loginAttempted = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (!loginAttempted) return null;
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10 ||
        value[0] != '0' ||
        (value[1] != '5' && value[1] != '6' && value[1] != '7')) {
      return 'Phone must start with 05/06/07 and be 10 digits';
    }

    final userExists = userDatabase.any(
      (user) =>
          user.phone == value.trim() && user.isBusiness == isBusinessOwner,
    );
    if (!userExists) {
      return 'No account found with this phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (!loginAttempted) return null;
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final phone = phoneController.text.trim();
    if (phone.isNotEmpty) {
      final user = userDatabase.firstWhere(
        (u) => u.phone == phone && u.isBusiness == isBusinessOwner,
        orElse: () =>
            User(name: '', phone: '', password: '', isBusiness: false),
      );
      if (user.phone.isNotEmpty && user.password != value) {
        return 'Incorrect password';
      }
    }

    return null;
  }

  void _tryLogin() {
    setState(() {
      loginAttempted = true;
    });

    if (_formKey.currentState!.validate()) {
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      final matchedUser = userDatabase.firstWhere(
        (u) =>
            u.phone == phone &&
            u.password == password &&
            u.isBusiness == isBusinessOwner,
        orElse: () =>
            User(name: '', phone: '', password: '', isBusiness: false),
      );

      if (matchedUser.phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Invalid credentials'),
              ],
            ),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.white),
              SizedBox(width: 8),
              Text('Welcome back, ${matchedUser.name}!'),
            ],
          ),
          backgroundColor: AppColors.buttonSecondaryDark,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isBusinessOwner
              ? QueuesPage(
                  userPhone: phone,
                  businessName: matchedUser.businessName ?? 'Business Owner',
                )
              : const WelcomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppAppBar.sliverAppBar(
              title: "Login To Your Account",
              onBackPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
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

                      const LogoHeader(
                        title: "QNow",
                        subtitle: "Login to your account",
                      ),
                      const SizedBox(height: 24),

                      RoleToggle(
                        initialValue: isBusinessOwner,
                        onChanged: (isBusiness) {
                          setState(() {
                            isBusinessOwner = isBusiness;
                            loginAttempted = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _formKey.currentState?.validate();
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      AppLabels.label("Phone Number"),
                      const SizedBox(height: 6),
                      AppTextFields.textField(
                        hintText: "Enter your phone number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 16),

                      AppLabels.label("Password"),
                      const SizedBox(height: 6),
                      AppTextFields.passwordField(
                        hintText: "Enter your password",
                        controller: passwordController,
                        isVisible: showPassword,
                        onToggleVisibility: () =>
                            setState(() => showPassword = !showPassword),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      AppButtons.primaryButton(
                        text: "Log In",
                        onPressed: _tryLogin,
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: AppButtons.textButton(
                          text: "Forgot Password?",
                          onPressed: () {},
                          textColor: AppColors.textSecondaryLight,
                        ),
                      ),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                            AppButtons.textButton(
                              text: "Sign Up",
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccountPage(),
                                  ),
                                );
                              },
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
    );
  }
}
