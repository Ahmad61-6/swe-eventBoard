import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/app.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';

class TAppRoutes {
  static List<GetPage> pages = [
    GetPage(
        name: TRoutes.dashboard, page: () => const ResponsiveDesignScreen()),
  ];
}
