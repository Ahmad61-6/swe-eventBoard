import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/tamplates/site_layout.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/forgot_password/responsive_screens/forgot_password_desktop_tablet.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/forgot_password/responsive_screens/forgot_password_mobile.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ForgotPasswordDesktopTablet(),
      mobile: ForgotPasswordMobile(),
    );
  }
}
