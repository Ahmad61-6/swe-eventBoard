import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

import '../widgets/create_event_form.dart';

class CreateEventMobileScreen extends StatelessWidget {
  const CreateEventMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: TCreateEventForm(), // Full width on mobile
      ),
    );
  }
}
