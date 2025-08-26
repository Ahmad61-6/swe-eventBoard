import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/forgot_password/widgets/header_form.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class ForgotPasswordMobile extends StatelessWidget {
  const ForgotPasswordMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: HeaderAndForm(),
        ),
      ),
    );
  }
}
