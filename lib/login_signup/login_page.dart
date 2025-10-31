import 'package:flutter/material.dart';
import 'create_account_page.dart';
<<<<<<< Updated upstream
import '../login_signup/welcome_page.dart';
import '../models/user_database.dart';
import '../business_owner/queues_page.dart';
import '../colors/app_colors.dart';
=======
import '../welcome_page.dart';
import '../models/user_database.dart';
import '../business_owner/queues_page.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart'; // Import the template
>>>>>>> Stashed changes

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
    if (value.length != 10 || value[0] != '0' || 
        (value[1] != '5' && value[1] != '6' && value[1] != '7')) {
      return 'Phone must start with 05/06/07 and be 10 digits';
    }
<<<<<<< Updated upstream
=======
    
    // Check if user exists in database
    final userExists = userDatabase.any(
      (user) => user.phone == value.trim() && user.isBusiness == isBusinessOwner,
    );
    if (!userExists) {
      return 'No account found with this phone number';
    }
    
>>>>>>> Stashed changes
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
        orElse: () => User(name: '', phone: '', password: '', isBusiness: false),
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
        orElse: () => User(name: '', phone: '', password: '', isBusiness: false),
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
<<<<<<< Updated upstream
            backgroundColor: AppColors.buttonSecondaryDark,
=======
            backgroundColor: Colors.red,
>>>>>>> Stashed changes
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Welcome back, ${matchedUser.name}!'),
            ],
          ),
<<<<<<< Updated upstream
          backgroundColor: AppColors.buttonSecondaryDark,
=======
          backgroundColor: Colors.green,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            SliverAppBar(
              backgroundColor: AppColors.backgroundLight,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              floating: true,
              snap: true,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                ),
              ),
              title: Text(
                "Login To Your Account",
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
=======
            AppAppBar.sliverAppBar(
              title: "Login To Your Account",
              onBackPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
>>>>>>> Stashed changes
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
<<<<<<< Updated upstream
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),

                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.access_time_filled,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "QNow",
                              style: TextStyle(
                                fontFamily: AppFonts.display,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.buttonSecondaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBusinessOwner = false;
                                    loginAttempted = false;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _formKey.currentState?.validate();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isBusinessOwner
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Customer",
                                      style: TextStyle(
                                        fontFamily: AppFonts.body,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: !isBusinessOwner
                                            ? Colors.white
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBusinessOwner = true;
                                    loginAttempted = false;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _formKey.currentState?.validate();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isBusinessOwner
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Business Owner",
                                      style: TextStyle(
                                        fontFamily: AppFonts.body,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: isBusinessOwner
                                            ? Colors.white
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
=======
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      
                      // Logo Header
                      const LogoHeader(
                        title: "QNow",
                        subtitle: "Login to your account",
>>>>>>> Stashed changes
                      ),
                      const SizedBox(height: 24),

                      // Role Toggle
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

<<<<<<< Updated upstream
                      _buildLabel("Phone Number"),
                      _buildTextField(
                        "Enter your phone number",
=======
                      // Phone Field
                      AppLabels.label("Phone Number"),
                      const SizedBox(height: 6),
                      AppTextFields.textField(
                        hintText: "Enter your phone number",
>>>>>>> Stashed changes
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 16),

<<<<<<< Updated upstream
                      _buildLabel("Password"),
                      _buildPasswordField(
                        hint: "Enter your password",
                        visible: showPassword,
                        controller: passwordController,
                        validator: _validatePassword,
                        onToggle: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _tryLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontFamily: AppFonts.body,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: AppFonts.body,
                            color: AppColors.textSecondaryLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountPage(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontFamily: AppFonts.body,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontFamily: AppFonts.body,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
=======
                      // Password Field
                      AppLabels.label("Password"),
                      const SizedBox(height: 6),
                      AppTextFields.passwordField(
                        hintText: "Enter your password",
                        controller: passwordController,
                        isVisible: showPassword,
                        onToggleVisibility: () => setState(() => showPassword = !showPassword),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Login Button
                      AppButtons.primaryButton(
                        text: "Log In",
                        onPressed: _tryLogin,
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password
                      Center(
                        child: AppButtons.textButton(
                          text: "Forgot Password?",
                          onPressed: () {},
                          textColor: AppColors.textSecondaryLight,
                        ),
                      ),
                      
                      // Sign Up Link
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
                                    builder: (context) => const CreateAccountPage(),
                                  ),
                                );
                              },
                            ),
                          ],
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: AppFonts.body,
          color: AppColors.textSecondaryDark,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryDark, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryDark, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool visible,
    required TextEditingController? controller,
    required String? Function(String?)? validator,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: AppFonts.body,
          color: AppColors.textSecondaryDark,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondaryLight,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryDark, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.buttonSecondaryDark, width: 1.5),
        ),
      ),
    );
  }
=======
>>>>>>> Stashed changes
}