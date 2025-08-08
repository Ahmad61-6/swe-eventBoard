// lib/app/modules/auth/views/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/utils/animations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppAnimations.fadeSlideAnimation(
          delay: 0.3,
          child: const Text('Password Recovery'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              AppAnimations.scaleAnimation(
                delay: 0.4,
                child: Image.asset(
                  'assets/images/forgot_password_illustration.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 30),
              AppAnimations.fadeSlideAnimation(
                delay: 0.5,
                child: const Text(
                  'Enter your email to receive password reset instructions',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              AppAnimations.fadeSlideAnimation(
                delay: 0.6,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 30),
              AppAnimations.fadeSlideAnimation(
                delay: 0.7,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return AppAnimations.pulseAnimation(
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Send Instructions'),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              AppAnimations.fadeSlideAnimation(
                delay: 0.8,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back to Login'),
                ),
              ),
              Obx(() {
                if (controller.error.value.isNotEmpty) {
                  return AppAnimations.fadeSlideAnimation(
                    delay: 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        controller.error.value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      controller.error('Please enter your email');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      controller.error('Please enter a valid email');
      return;
    }

    try {
      await controller.resetPassword(email);
      Get.snackbar(
        'Email Sent',
        'Password reset instructions sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      // Error is handled in controller
    }
  }
}
