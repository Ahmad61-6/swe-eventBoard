import 'package:flutter/material.dart';
import 'package:swe_event_board/app/modules/widgets/theme_toggol.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showThemeToggle;

  CustomAppBar({required this.title, this.showThemeToggle = true});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.displayLarge),
      centerTitle: true,
      actions: [if (showThemeToggle) ThemeToggle()],
    );
  }
}
