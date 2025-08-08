import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_theme.dart';

class ThemeController extends GetxController {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  final RxBool isDarkMode = false.obs;
  final String _themeKey = 'isDarkMode';

  ThemeData get currentTheme => isDarkMode.value ? _darkTheme : _lightTheme;

  @override
  void onInit() {
    super.onInit();
    _initializeThemes();
    _loadTheme();
  }

  void _initializeThemes() {
    _lightTheme = AppThemes.lightTheme;
    _darkTheme = AppThemes.darkTheme;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode.value);
  }
}
