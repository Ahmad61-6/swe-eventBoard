import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar.dart';

import '../../layout/headers/header.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key, this.body});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: TSideBar(),
      appBar: THeader(
        scaffoldKey: scaffoldKey,
      ),
      body: body ?? const SizedBox(),
    );
  }
}
