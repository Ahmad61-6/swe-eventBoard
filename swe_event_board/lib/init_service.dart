// lib/app/initialization.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swe_event_board/app/core/controllers/home_controller.dart';

import 'app/core/controllers/auth_controller.dart';
import 'app/core/controllers/profile_controller.dart';
import 'app/core/controllers/splash_controller.dart';
import 'app/core/controllers/theme_controller.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/connectivity_service.dart';
import 'app/core/services/profile_service.dart';
import 'app/core/services/storage_service.dart';
import 'app/data/repositories/profile_repository.dart';

Future<void> initServices() async {
  try {
    // Initialize GetX bindings
    WidgetsFlutterBinding.ensureInitialized();
    final supabase = await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      debug: true, // Set to false in production
    );

    // Register SupabaseClient instance
    Get.put<SupabaseClient>(supabase.client, permanent: true);

    // Initialize SharedPreferences
    await Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
      permanent: true,
    );

    // Initialize Storage Service
    await Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    }, permanent: true);

    // Initialize remaining services
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ProfileRepository>(ProfileRepository(), permanent: true);
    Get.put<ProfileService>(ProfileService(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<SplashController>(SplashController(), permanent: false);
    Get.put(HomeController(), permanent: true);
  } catch (e) {
    debugPrint('Error initializing services: $e');
    rethrow;
  }
}
