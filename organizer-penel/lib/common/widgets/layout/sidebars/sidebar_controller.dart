import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';
import 'package:yt_ecommerce_admin_panel/utils/device/device_utility.dart';

class SideBarController extends GetxController {
  final activeItem = TRoutes.dashboard.obs; // Active route
  final hoverItem = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set initial route when controller is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activeItem.value =
          Get.currentRoute.isEmpty ? TRoutes.dashboard : Get.currentRoute;
    });
  }

  void changeActiveItem(String route) {
    debugPrint('---->Changing active item to $route');
    activeItem.value = route; // Update the active route
  }

  void changeHoverItem(String route) {
    if (!isActive(route)) {
      hoverItem.value = route;
    }
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  // OnTap, navigate and change the active item
  void menuOnTap(String route) {
    if (!isActive(route)) {
      changeActiveItem(route);
      if (TDeviceUtils.isMobileScreen(Get.context!)) {
        Get.back(); // Close drawer on mobile
      }
      Get.toNamed(route); // Navigate to the selected route
    } else {
      // If same route, just close drawer on mobile
      if (TDeviceUtils.isMobileScreen(Get.context!)) {
        Get.back();
      }
    }
  }

  // Method to set active item based on current route
  void updateActiveItemFromRoute() {
    final currentRoute = Get.currentRoute;
    if (currentRoute.isNotEmpty) {
      activeItem.value = currentRoute;
    }
  }
}
