import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => IconButton(
        icon: Icon(
          themeController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
          size: 26,
        ),
        onPressed: () => themeController.toggleTheme(),
      ),
    );
  }
}
