// lib/app/core/utils/animations.dart
import 'package:flutter/material.dart';

class AppAnimations {
  // Fade and slide animation
  static Widget fadeSlideAnimation({
    required Widget child,
    required double delay,
    Offset? offset = const Offset(0, 30),
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: (500 * delay).round()),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset!.dx * (1 - value), offset.dy * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Scale animation
  static Widget scaleAnimation({required Widget child, required double delay}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: (500 * delay).round()),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }

  // Staggered list item animation
  static Widget listItemAnimation({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    return AnimatedBuilder(
      animation: PageController(),
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: AlwaysStoppedAnimation(1.0),
                  curve: Interval(0.0, 0.8, curve: Curves.easeOut),
                ),
              ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: AlwaysStoppedAnimation(1.0),
                curve: Interval(0.0, 0.8, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Pulse animation for buttons
  static Widget pulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.05),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }
}
