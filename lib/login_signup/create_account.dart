// lib/create_account_page.dart
import 'package:flutter/material.dart';
import 'package:lab3c1/login/signup/login_page.dart';
import 'package:lab3c1/login/signup/welcome_page.dart';
import '../user_database.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessLocationController = TextEditingController();
  bool isBusinessOwner = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? _phoneErrorText;

  @override
  void dispose() {
    // ✅ Dispose them here to free memory
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    businessLocationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3), // background-light
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFFF5F5F3),
              surfaceTintColor: Colors.transparent, // prevents tint flicker
              elevation: 0,
              floating: true,
              snap: true,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                ),
              ),
              title: const Text(
                "Create an Account",
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    // Short subtitle
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333), // primary
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
                          const Text(
                            "QNow",
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role toggle
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBusinessOwner = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: !isBusinessOwner
                                      ? const Color(0xFF333333)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "I'm a Customer",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: !isBusinessOwner
                                          ? Colors.white
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBusinessOwner = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isBusinessOwner
                                      ? const Color(0xFF333333)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "I'm a Business Owner",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isBusinessOwner
                                          ? Colors.white
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Full Name
                    _buildLabel("Full Name"),
                    _buildTextField("Enter your full name"),
                    const SizedBox(height: 14),

                    // Phone Number
                    _buildLabel("Phone Number"),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF9CA3AF),
                        ),
                        errorText:
                            _phoneErrorText, // shows validation error under the field
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
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E5E7),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF333333),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _phoneErrorText = 'Phone number is required';
                          } else if (!RegExp(
                            r'^(05|06|07)\d{8}$',
                          ).hasMatch(value)) {
                            _phoneErrorText =
                                'Enter a valid 10-digit number starting with 05, 06, or 07';
                          } else {
                            _phoneErrorText = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Business fields (only if selected)
                    if (isBusinessOwner) ...[
                      _buildLabel("Email Address"),
                      _buildTextField(
                        "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),

                      _buildLabel("Business Name"),
                      _buildTextField("Enter your business name"),
                      const SizedBox(height: 14),

                      _buildLabel("Business Location"),
                      _buildTextField("Enter your business location"),
                      const SizedBox(height: 14),
                    ],

                    // Password
                    _buildLabel("Password"),
                    _buildPasswordField(
                      hint: "Enter your password",
                      visible: showPassword,
                      onToggle: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                    const SizedBox(height: 14),

                    // Confirm Password
                    _buildLabel("Confirm Password"),
                    _buildPasswordField(
                      hint: "Confirm your password",
                      visible: showConfirmPassword,
                      onToggle: () => setState(
                        () => showConfirmPassword = !showConfirmPassword,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String phone = phoneController.text.trim();
                          String password = passwordController.text.trim();

                          // Save user
                          userDatabase.add(
                            User(
                              phone: phone,
                              password: password,
                              isBusiness: isBusinessOwner,
                              email: isBusinessOwner
                                  ? emailController.text.trim()
                                  : null,
                              businessName: isBusinessOwner
                                  ? businessNameController.text.trim()
                                  : null,
                              businessLocation: isBusinessOwner
                                  ? businessLocationController.text.trim()
                                  : null,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account created successfully!'),
                            ),
                          );

                          Navigator.pop(context); // go back to welcome or login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF333333),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF9CA3AF),
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
          borderSide: const BorderSide(color: Color(0xFFE5E5E7), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      obscureText: !visible,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF9CA3AF),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF6B7280),
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
          borderSide: const BorderSide(color: Color(0xFFE5E5E7), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1.5),
        ),
      ),
    );
  }
}
