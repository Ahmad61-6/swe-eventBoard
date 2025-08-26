import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/tamplates/login_template.dart';

import '../widgets/header_form.dart';

class ForgotPasswordDesktopTablet extends StatelessWidget {
  const ForgotPasswordDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(child: HeaderAndForm());
  }
}
