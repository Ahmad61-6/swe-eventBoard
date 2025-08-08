import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/signup_screen.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/profile/view/profile_screen.dart';
import '../modules/splash/views/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/signup', page: () => SignupScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
  ];
}
