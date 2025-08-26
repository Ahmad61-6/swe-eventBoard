import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layout/tamplates/login_template.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/widgets/login_header.dart';

import '../widgets/login_form.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TLoginHeader(),
          ),
          TLoginForm()
        ],
      ),
    );
  }
}
