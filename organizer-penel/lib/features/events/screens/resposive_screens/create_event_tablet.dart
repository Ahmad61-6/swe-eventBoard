import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

import '../widgets/create_event_form.dart';

class CreateEventTabletScreen extends StatelessWidget {
  const CreateEventTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
                maxWidth: 500), // Slightly smaller than desktop
            child: const TCreateEventForm(),
          ),
        ),
      ),
    );
  }
}
