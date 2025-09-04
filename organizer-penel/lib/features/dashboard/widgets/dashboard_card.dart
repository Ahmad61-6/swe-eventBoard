import 'package:flutter/material.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color cardColor;

  const TDashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding:
          const EdgeInsets.all(TSizes.md), // Adjust width for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TSectionHeading(
            title: title,
            textColor: TColors.textSecondary,
            rightSideWidget: Icon(
              icon,
              size: 28,
              color: cardColor,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: cardColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: TColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
