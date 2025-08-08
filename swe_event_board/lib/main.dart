import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/config/app_theme.dart';
import 'app/config/routes.dart';
import 'app/core/controllers/theme_controller.dart';
import 'init_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // const String _supabaseUrl = String.fromEnvironment(
  //   'SUPABASE_URL',
  //   defaultValue: '',
  // );
  // if (_supabaseUrl.isEmpty) {
  //   throw Exception(
  //     'SUPABASE_URL is not set. Please provide it in your environment variables.',
  //   );
  // }
  // // Load environment variables
  // const String _anonKey = String.fromEnvironment(
  //   'SUPABASE_ANON_KEY',
  //   defaultValue: '',
  // );
  // if (_anonKey.isEmpty) {
  //   throw Exception(
  //     'SUPABASE_ANON_KEY is not set. Please provide it in your environment variables.',
  //   );
  // }
  //
  // await Supabase.initialize(url: _supabaseUrl, anonKey: _anonKey);

  // Initialize services
  await initServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      return GetMaterialApp(
        title: 'SWE Event Board',
        theme: themeController.currentTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: '/',
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        unknownRoute: AppPages.routes[0],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      );
    });
  }
}
