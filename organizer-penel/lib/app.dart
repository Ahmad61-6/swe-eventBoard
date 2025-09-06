// app.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yt_ecommerce_admin_panel/bindings/general_bindings.dart';
import 'package:yt_ecommerce_admin_panel/routes/app_routes.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/device/web_material_scroll.dart';
import 'package:yt_ecommerce_admin_panel/utils/theme/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Future to determine the initial route based on auth state
  late Future<String> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = _determineInitialRoute();
  }

  /// Determines the initial route by checking Firebase Auth and GetStorage
  Future<String> _determineInitialRoute() async {
    debugPrint("App Start - Determining Initial Route...");

    // 1. Check Firebase Authentication State First (Most Reliable Persistent State)
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    debugPrint(
        "App Start - Firebase Auth User Present: ${firebaseUser != null}");

    if (firebaseUser != null) {
      // User is logged in according to Firebase
      debugPrint(
          "App Start - Firebase Auth indicates user is logged in (${firebaseUser.uid}). Redirecting to Dashboard.");
      // Ensure GetStorage flag is also set for consistency (in case it was cleared)
      if (!(GetStorage().read('user_logged_in') ?? false)) {
        GetStorage().write('user_logged_in', true);
        debugPrint(
            "App Start - Synced 'user_logged_in' flag in GetStorage based on Firebase state.");
      }
      return TRoutes.dashboard;
    }

    // 2. If Firebase says no user, check the GetStorage flag (Fallback/Secondary Check)
    final bool? storageLoggedInFlag = GetStorage().read('user_logged_in');
    debugPrint(
        "App Start - Firebase Auth User NOT present. Checking GetStorage flag: $storageLoggedInFlag");

    if (storageLoggedInFlag == true) {
      // GetStorage says user was logged in, but Firebase doesn't.
      // This could happen if they manually signed out via Firebase, or data inconsistency.
      // For robustness, let's prioritize Firebase state. If Firebase says logged out,
      // we should probably treat them as logged out, even if the flag says otherwise.
      // However, if you want to be extra lenient, you could redirect to dashboard here.
      // Let's be strict and redirect to login if Firebase doesn't confirm the user.
      debugPrint(
          "App Start - GetStorage flag is true, but Firebase Auth is false. Prioritizing Firebase. Redirecting to Login.");
      // Optional: Clear the potentially stale flag
      // GetStorage().remove('user_logged_in');
      // GetStorage().remove('REMEMBER_ME_EMAIL');
      // GetStorage().remove('REMEMBER_ME_PASSWORD');
    } else {
      debugPrint(
          "App Start - GetStorage flag is false or null. Redirecting to Login.");
    }

    // Default to login if neither source confirms a logged-in user
    return TRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRouteFuture, // The future that determines the route
      builder: (context, snapshot) {
        // Handle loading state while determining the route
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a simple loading screen while checking auth state
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child:
                    CircularProgressIndicator(), // Or any loading widget you prefer
              ),
            ),
          );
        }

        // Handle potential errors during the check (unlikely, but good practice)
        if (snapshot.hasError) {
          debugPrint(
              "App Start - Error determining initial route: ${snapshot.error}");
          // Fallback to login on error
          return GetMaterialApp(
            title: TTexts.appName,
            themeMode: ThemeMode.light,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            scrollBehavior: MyCustomScrollBehavior(),
            getPages: TAppRoutes.pages,
            initialRoute: TRoutes.login, // Fallback to login
            initialBinding: GeneralBindings(),
            unknownRoute: GetPage(
              name: '/page-not-found',
              page: () => const Scaffold(
                body: Center(child: Text('Error loading app')),
              ),
            ),
          );
        }

        // Once the future completes successfully, build the main GetMaterialApp
        final String initialRoute =
            snapshot.data ?? TRoutes.login; // Use result or default to login

        return GetMaterialApp(
          title: TTexts.appName,
          themeMode: ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          getPages: TAppRoutes.pages,
          initialRoute: initialRoute, // Use the determined route
          initialBinding: GeneralBindings(),
          unknownRoute: GetPage(
            name: '/page-not-found',
            page: () => const Scaffold(
              body: Center(child: Text('Page not found')),
            ),
          ),
        );
      },
    );
  }
}
