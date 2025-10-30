// lib/create_account_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../welcome_page.dart';
import '../user_database.dart';
import '../business_owner/queue_page.dart';

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

  @override
  void dispose() {
    // ✅ Dispose them here to free memory
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    businessLocationController.dispose();
    super.dispose();
  }

  bool validatePhone(String phone) {
    if (phone.isEmpty) return false;
    if (phone.length != 10) return false;
    if (phone[0] != '0') return false;
    if (phone[1] != '5' && phone[1] != '6' && phone[1] != '7') return false;
    return true;
  }

  bool validateName(String name) {
    return name.length >= 3;
  }

  String? _validateName(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (!validateName(value)) {
      return 'Full name must be at least 3 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!validatePhone(value)) {
      return 'Phone must start with 05/06/07 and be 10 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Email is required for business owners';
    }
    if (isBusinessOwner && value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  String? _validateBusinessName(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Business name is required';
    }
    return null;
  }

  String? _validateBusinessLocation(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (isBusinessOwner && (value == null || value.isEmpty)) {
      return 'Business location is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!signup) return null; // Don't validate until signup is pressed
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

      // Save user
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
        const SnackBar(
          content: Text('Account created successfully!'),
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
              : const WelcomePage(), // Replace with your actual home page
        ),
      );
    }
  }

  bool signup = false;

  @override
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
                child: Form(
                  key: _formKey,
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
                                onTap: () {
                                  setState(() {
                                    isBusinessOwner = false;
                                    signup = false;
                                  });
                                  // Trigger form validation to update business field requirements
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
                                onTap: () {
                                  setState(() {
                                    isBusinessOwner = true;
                                    signup = false;
                                  });
                                  // Trigger form validation to update business field requirements
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
                      _buildTextField(
                        "Enter your full name",
                        controller: nameController,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 14),

                      // Phone Number
                      _buildLabel("Phone Number"),
                      _buildTextField(
                        "Enter your phone number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 14),

                      // Business fields (only if selected)
                      if (isBusinessOwner) ...[
                        _buildLabel("Email Address"),
                        _buildTextField(
                          "Enter your email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 14),

                        _buildLabel("Business Name"),
                        _buildTextField(
                          "Enter your business name",
                          controller: businessNameController,
                          validator: _validateBusinessName,
                        ),
                        const SizedBox(height: 14),

                        _buildLabel("Business Location"),
                        _buildTextField(
                          "Enter your business location",
                          controller: businessLocationController,
                          validator: _validateBusinessLocation,
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Password
                      _buildLabel("Password"),
                      _buildPasswordField(
                        hint: "Enter your password",
                        visible: showPassword,
                        controller: passwordController,
                        validator: _validatePassword,
                        onToggle: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password
                      _buildLabel("Confirm Password"),
                      _buildPasswordField(
                        hint: "Confirm your password",
                        visible: showConfirmPassword,
                        controller: confirmPasswordController,
                        validator: _validateConfirmPassword,
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
                            setState(() {
                              signup = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _createAccount();
                            }
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
