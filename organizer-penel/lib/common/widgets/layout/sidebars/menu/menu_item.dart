// In TMenuItem widget, replace the onTap method:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar_controller.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TMenuItem extends StatelessWidget {
  const TMenuItem({
    super.key,
    required this.route,
    required this.itemName,
    required this.icon,
  });
  final String route;
  final String itemName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SideBarController());
    return InkWell(
      onTap: () => menuController
          .menuOnTap(route), // Use menuOnTap instead of changeActiveItem
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(''),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(
                color: menuController.isHovering(route) ||
                        menuController.isActive(route)
                    ? TColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: TSizes.lg,
                      top: TSizes.md,
                      bottom: TSizes.md,
                      right: TSizes.md),
                  child: menuController.isActive(route)
                      ? Icon(
                          icon,
                          size: 22,
                          color: TColors.white,
                        )
                      : Icon(icon,
                          size: 22,
                          color: menuController.isHovering(route)
                              ? TColors.white
                              : TColors.darkerGrey),
                ),
                if (menuController.isActive(route) ||
                    menuController.isHovering(route))
                  Text(
                    itemName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.white),
                  )
                else
                  Text(
                    itemName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.darkerGrey),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
