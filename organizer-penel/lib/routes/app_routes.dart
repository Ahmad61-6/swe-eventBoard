import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/reset_password/reset_password_screen.dart';
import 'package:yt_ecommerce_admin_panel/features/dashboard/dashboard_screen.dart';
import 'package:yt_ecommerce_admin_panel/routes/route_middle_ware.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';

import '../features/authentication/screens/login/login_screen.dart';

class TAppRoutes {
  static List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => const LoginScreen()),
    GetPage(
        name: TRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
        name: TRoutes.resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(
        name: TRoutes.dashboard,
        page: () => const DashboardScreen(),
        middlewares: [TRouteMiddleware()]),
  ];
}
