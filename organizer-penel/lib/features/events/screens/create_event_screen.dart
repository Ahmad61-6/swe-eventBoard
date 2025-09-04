import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/tamplates/site_layout.dart';
import 'package:yt_ecommerce_admin_panel/features/events/screens/resposive_screens/create_event_desktop.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateEventDesktop(),
    );
  }
}
