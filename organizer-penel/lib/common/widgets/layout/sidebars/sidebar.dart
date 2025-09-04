import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'menu/menu_item.dart';

class TSideBar extends StatelessWidget {
  const TSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section - Logo and Title
              Container(
                decoration: const BoxDecoration(
                  color: TColors.primary,
                  border: Border(
                    bottom: BorderSide(color: TColors.grey, width: 1),
                  ),
                ),
                width: double.infinity,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon and Title Section
                      Container(
                        padding: const EdgeInsets.only(left: TSizes.md),
                        child: const Icon(
                          Iconsax.flash, // Using Thunder Icon (flash)
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SWE EventBoard',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(
                                  color: Colors.white,
                                  fontWeightDelta: 2,
                                ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          Text(
                            'Organizer Panel',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Menu Section
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menu',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    const TMenuItem(
                      route: TRoutes.dashboard,
                      itemName: 'DashBoard',
                      icon: Iconsax.status,
                    ),
                    const TMenuItem(
                      route: TRoutes.createEvent,
                      itemName: 'Create Event',
                      icon: Iconsax.add,
                    ),
                    const TMenuItem(
                      route: TRoutes.manageEvents,
                      itemName: 'Manage Events',
                      icon: Iconsax.task,
                    ),
                    const TMenuItem(
                      route: TRoutes.participants,
                      itemName: 'Participants',
                      icon: Iconsax.profile_2user,
                    ),
                    const TMenuItem(
                      route: TRoutes.notification,
                      itemName: 'Notification',
                      icon: Iconsax.notification,
                    ),
                    const TMenuItem(
                      route: TRoutes.profile,
                      itemName: 'Profile',
                      icon: Iconsax.user,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
