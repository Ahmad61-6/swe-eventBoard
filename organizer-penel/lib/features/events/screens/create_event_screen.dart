import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/tamplates/site_layout.dart';
import 'package:yt_ecommerce_admin_panel/features/events/screens/resposive_screens/create_event_desktop.dart';
import 'package:yt_ecommerce_admin_panel/features/events/screens/resposive_screens/create_event_mobile.dart';
import 'package:yt_ecommerce_admin_panel/features/events/screens/resposive_screens/create_event_tablet.dart';

import '../controllers/create_event_controller.dart';

class CreateEventScreen extends StatefulWidget {
  // Change to StatefulWidget
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late CreateEventController controller; // Declare controller instance

  @override
  void initState() {
    super.initState();
    // Initialize and put the controller when the screen is created
    controller =
        Get.put(CreateEventController()); // Use Get.put for screen lifecycle
  }

  @override
  void dispose() {
    // Remove the controller when the screen is disposed to prevent memory leaks
    // Only do this if you are sure this screen is the sole owner.
    // If other parts might use it, consider Get.lazyPut or managing it globally.
    // Get.delete<CreateEventController>(); // Uncomment if appropriate
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The controller is now guaranteed to exist for TCreateEventForm
    return const TSiteTemplate(
      desktop: CreateEventDesktopScreen(),
      tablet: CreateEventTabletScreen(),
      mobile: CreateEventMobileScreen(),
    );
  }
}
