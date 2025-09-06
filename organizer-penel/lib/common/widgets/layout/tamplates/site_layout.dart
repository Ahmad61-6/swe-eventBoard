import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/responsive/responsive_design.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/responsive/screens/tablet_layout.dart';

import '../sidebars/sidebar_controller.dart';

class TSiteTemplate extends StatelessWidget {
  const TSiteTemplate({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = true,
  });

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SideBarController>(
        // Add GetBuilder to rebuild on controller changes
        init: Get.find<SideBarController>()..changeActiveItem(Get.currentRoute),
        builder: (controller) {
          return TResponsiveWidget(
            desktop: useLayout
                ? DesktopLayout(
                    body: desktop,
                  )
                : desktop ?? Container(),
            tablet: useLayout
                ? TabletLayout(
                    body: tablet ?? desktop,
                  )
                : tablet ?? desktop ?? Container(),
            mobile: useLayout
                ? MobileLayout(
                    body: mobile ?? desktop,
                  )
                : mobile ?? desktop ?? Container(),
          );
        },
      ),
    );
  }
}
