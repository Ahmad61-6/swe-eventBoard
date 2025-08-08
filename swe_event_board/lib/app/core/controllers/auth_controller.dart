import 'package:get/get.dart';

import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    isLoggedIn.value = await _authService.isAuthenticated;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      isLoading(true);
      error('');

      await _authService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading(true);
      error('');

      await _authService.signInWithEmail(email, password);
      isLoggedIn(true);

      Get.offAllNamed('/home');
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      isLoading(true);
      await _authService.signOut();
      isLoggedIn(false);
      Get.offAllNamed('/login');
    } catch (e) {
      error('Logout failed: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading(true);
      error('');
      await _authService.sendPasswordResetEmail(email);
      Get.snackbar(
        'Email Sent',
        'Password reset instructions sent to $email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
