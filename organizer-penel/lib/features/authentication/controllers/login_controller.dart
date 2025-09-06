import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/models/user_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final emailTEController = TextEditingController();
  final passwordTEController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    if (savedEmail != null && savedPassword != null) {
      emailTEController.text = savedEmail;
      passwordTEController.text = savedPassword;
      rememberMe.value = true;
    }
    super.onInit();
  }

  // handle email and password signin process
  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'logging in you', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', emailTEController.text.trim());
        localStorage.write(
            'REMEMBER_ME_PASSWORD', passwordTEController.text.trim());
      }

      await AuthenticationRepository.instance.loginWithEmailAndPassword(
          emailTEController.text.trim(), passwordTEController.text.trim());

      final user = await UserRepository.instance.fetchAdminDetails();
      TFullScreenLoader.stopLoading();

      if (user.role != AppRole.admin) {
        TLoaders.errorSnackBar(
            title: 'Access Denied',
            message: 'You do not have admin privileges. contact Admin');
        await AuthenticationRepository.instance.logout();
      } else {
        // Save session to local storage after successful login
        GetStorage().write('user_logged_in', true); // <-- This is correct
        debugPrint(
            "Login Successful: 'user_logged_in' flag set to true in GetStorage");
        AuthenticationRepository.instance.screenRedirect();
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'oh snap', message: e.toString());
      debugPrint(e.toString());
    }
  }

  //handle registration of admin user

  Future<void> registerAdminUser() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Registering Admin Account.....', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // register user using email password authentication
      await AuthenticationRepository.instance
          .registerWithEmailAndPassword('ahmadmizan210@gmail.com', 'admin1234');
      debugPrint('User ID: ${AuthenticationRepository.instance.authUser!.uid}');

      // create admin record in the firestore database
      final userRepository = Get.put(UserRepository());

      await userRepository.createUser(UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        orgName: 'Data Science Club',
        email: 'ahmadmizan210@gmail.com',
        role: AppRole.admin,
        createdAt: DateTime.now(),
      ));

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'oh snap', message: e.toString());
    }
  }
}
