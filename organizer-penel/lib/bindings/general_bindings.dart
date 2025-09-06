import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar_controller.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/events/create_event_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart';

import '../features/authentication/controllers/user_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => UserRepository(), fenix: true);
    Get.lazyPut(() => SideBarController(), fenix: true);
    Get.lazyPut(() => EventRepository(), fenix: true);
  }
}
