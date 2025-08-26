import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart';

import '../../../utils/constants/image_strings.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final emailTEController = TextEditingController();
  final passwordTEController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // handle email and password signin process
  Future<void> emailAndPasswordSignIn() async {
    // Add your sign-in logic here
  }

  //handle registration of admin user

  Future<void> registerAdminUser() async {
    TFullScreenLoader.openLoadingDialog(
        'Registering Admin Account.....', TImages.docerAnimation);

    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading();
      return;
    }
  }
}
