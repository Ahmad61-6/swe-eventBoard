import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print('.......................Middleware Called..........................');
    bool isAuthenticated = false; // Replace with your auth logic
    return isAuthenticated ? null : RouteSettings(name: TRoutes.login);
  }
}
