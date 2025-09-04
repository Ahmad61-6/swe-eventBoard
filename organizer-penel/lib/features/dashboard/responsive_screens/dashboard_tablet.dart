import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../widgets/dashboard_card.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TDashboardCard(
                      title: 'Total Events',
                      value: '3',
                      subtitle: 'Events created',
                      icon: Iconsax.calendar,
                      cardColor: Colors.blue.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TDashboardCard(
                      title: 'Pending Approvals',
                      value: '1',
                      subtitle: 'Awaiting review',
                      icon: Iconsax.clock,
                      cardColor: Colors.deepOrangeAccent.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TDashboardCard(
                      title: 'Approved Events',
                      value: '2',
                      subtitle: 'Ready to go',
                      icon: Iconsax.add_circle,
                      cardColor: TColors.success.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TDashboardCard(
                      title: 'Total Participants',
                      value: '75',
                      subtitle: 'Across all events',
                      icon: Iconsax.user,
                      cardColor: TColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recent Events',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          // Event List
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: TColors.borderSecondary, width: 0.5),
                                borderRadius: BorderRadius.circular(8)),
                            child: const ListTile(
                              title: Text('Web Development Workshop'),
                              subtitle: Text('Computer Lab 1 • 2024-12-20'),
                              trailing: Chip(
                                  backgroundColor: TColors.success,
                                  label: Text('Seminar')),
                            ),
                          ),
                          // More events...
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Events by Type',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(TColors.primary),
                              value: 0.33,
                              backgroundColor: Colors.grey),
                          const Text('Seminar 1 event'),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(TColors.primary),
                              value: 0.33,
                              backgroundColor: Colors.grey),
                          const Text('Recruitment 1 event'),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(TColors.primary),
                              value: 0.33,
                              backgroundColor: Colors.grey),
                          const Text('Entertainment 1 event'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
