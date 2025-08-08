import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find();
  final StorageService _storageService = Get.find();

  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));

    try {
      // Check if we have a stored session
      final hasSession = await _storageService.isLoggedIn();

      if (hasSession && _authService.isAuthenticated) {
        Get.offNamed('/home');
      } else {
        Get.offNamed('/login');
      }
    } catch (e) {
      Get.offNamed('/login');
    }
  }
}
