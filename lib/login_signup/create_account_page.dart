import 'package:flutter/material.dart';
import 'login_page.dart';
import '../welcome_page.dart';
import '../models/user_database.dart';
import '../business_owner/queues_page.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart'; // Import the template

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessLocationController = TextEditingController();
  bool isBusinessOwner = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool signed = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    businessLocationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    if (value.length != 10 ||
        value[0] != '0' ||
        (value[1] != '5' && value[1] != '6' && value[1] != '7')) {
      return 'Phone must start with 05/06/07 and be 10 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Email is required';
    }
    return null;
  }

  String? _validateBusinessName(String? value) {
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Business name is required';
    }
    return null;
  }

  String? _validateBusinessLocation(String? value) {
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Location is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      userDatabase.add(
        User(
          name: name,
          phone: phone,
          password: password,
          isBusiness: isBusinessOwner,
          email: isBusinessOwner ? emailController.text.trim() : null,
          businessName: isBusinessOwner
              ? businessNameController.text.trim()
              : null,
          businessLocation: isBusinessOwner
              ? businessLocationController.text.trim()
              : null,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Account created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isBusinessOwner
              ? QueuesPage(
                  userPhone: phone,
                  businessName: businessNameController.text.trim(),
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
              title: "Create an Account",
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

                      // Logo Header
                      const LogoHeader(title: "QNow"),
                      const SizedBox(height: 24),

                      // Role Toggle
                      RoleToggle(
                        initialValue: isBusinessOwner,
                        onChanged: (isBusiness) {
                          setState(() {
                            isBusinessOwner = isBusiness;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      AppLabels.label("Full Name"),
                      const SizedBox(height: 6),
                      AppTextFields.textField(
                        hintText: "Enter your full name",
                        controller: nameController,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 14),

                      // Phone Number
                      AppLabels.label("Phone Number"),
                      const SizedBox(height: 6),
                      AppTextFields.textField(
                        hintText: "Enter your phone number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 14),

                      // Business fields (only if selected)
                      if (isBusinessOwner) ...[
                        AppLabels.label("Email Address"),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          hintText: "Enter your email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 14),

                        AppLabels.label("Business Name"),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          hintText: "Enter your business name",
                          controller: businessNameController,
                          validator: _validateBusinessName,
                        ),
                        const SizedBox(height: 14),

                        AppLabels.label("Business Location"),
                        const SizedBox(height: 6),
                        AppTextFields.textField(
                          hintText: "Enter your business location",
                          controller: businessLocationController,
                          validator: _validateBusinessLocation,
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Password
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
                      const SizedBox(height: 14),

                      // Confirm Password
                      AppLabels.label("Confirm Password"),
                      const SizedBox(height: 6),
                      AppTextFields.passwordField(
                        hintText: "Confirm your password",
                        controller: confirmPasswordController,
                        isVisible: showConfirmPassword,
                        onToggleVisibility: () => setState(
                          () => showConfirmPassword = !showConfirmPassword,
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      AppButtons.primaryButton(
                        text: "Sign Up",
                        onPressed: _createAccount,
                      ),
                      const SizedBox(height: 18),

                      // Already have account
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                            AppButtons.textButton(
                              text: "Log In",
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),
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
