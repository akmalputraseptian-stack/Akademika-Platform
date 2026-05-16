import 'package:flutter/material.dart';

class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.05); // Bergeser sedikit dari bawah (5% layar)
            const end = Offset.zero;
            const curve = Curves.easeOutCubic; // Kurva yang sangat mulus (elegan)

            var slideAnimation = animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: curve)));
            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600), // Durasi sedikit lebih lama untuk kesan premium
          reverseTransitionDuration: const Duration(milliseconds: 500),
        );
}
