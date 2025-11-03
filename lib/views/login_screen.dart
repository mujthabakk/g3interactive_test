import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:g3interactive_test/utils/app_constants.dart';
import 'package:g3interactive_test/utils/validators.dart';
import 'package:g3interactive_test/utils/error_handler.dart';
import 'package:g3interactive_test/widgets/custom_text_fields.dart';
import 'package:g3interactive_test/widgets/custom_buttons.dart';
import 'package:g3interactive_test/widgets/custom_header.dart';
import 'package:g3interactive_test/widgets/loading_overlay.dart';
import 'package:g3interactive_test/controllers/login_controller.dart';
import 'package:g3interactive_test/routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
 State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, loginController, child) {
        return LoadingOverlay(
          isLoading: loginController.isLoading,
          message: 'Logging in...',
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // ==================== FULL WIDTH HEADER ====================
                  const LoginHeader(),

                  const SizedBox(height: 40),

                  // ==================== WELCOME BACK ====================
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Login to your account',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ==================== CUSTOM TEXT FIELDS (WITH EYE) ====================
                  Padding(
                    padding: AppDimensions.paddingHorizontal,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          hint: 'Email address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          isPassword: true,
                          onToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          validator: Validators.validatePassword,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================== REMEMBER ME + FORGOT ====================
                  Padding(
                    padding: AppDimensions.paddingHorizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primaryYellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Remember me',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'FORGOT PASSWORD?',
                            style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ==================== LOGIN BUTTON ====================
                  Padding(
                    padding: AppDimensions.paddingHorizontal,
                    child: PrimaryButton(
                      text: loginController.isLoading ? 'LOGGING IN...' : 'LOGIN',
                      onPressed: _handleLogin,
                      enabled: !loginController.isLoading,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // OR Divider
                  Padding(
                    padding: AppDimensions.paddingHorizontal,
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register Link
                  Padding(
                    padding: AppDimensions.paddingHorizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() async {
    // Validate email
    final emailError = Validators.validateEmail(_emailController.text);
    if (emailError != null) {
      ErrorHandler.showError(context, emailError);
      return;
    }

    // Validate password
    final passwordError = Validators.validatePassword(_passwordController.text);
    if (passwordError != null) {
      ErrorHandler.showError(context, passwordError);
      return;
    }

    // Get the login controller
    final loginController = context.read<LoginController>();

    // Attempt login
    final success = await loginController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      isWebUser: false,
      isMobUser: true,
    );

    if (!mounted) return;

    if (success) {
      // Show success message
      ErrorHandler.showSuccess(context, 'Login Successful!');
      
      // Wait a bit to ensure token is fully saved

      
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (!mounted) return;
      
      // Navigate to personnel list screen

      context.go(AppRouter.personnelList);
    } else {
      // Show error message
      final error = loginController.errorMessage ?? 'Login failed. Please try again.';
      ErrorHandler.showError(context, error);
    }
  }
}