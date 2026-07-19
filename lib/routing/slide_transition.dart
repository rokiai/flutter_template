import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SlideDirection {
  right,
  left,
  up,
  down,
}

extension GoRouterStateSlide on GoRouterState {
  SlideRouteTransition slidePage(
    Widget child, {
    SlideDirection direction = SlideDirection.left,
  }) {
    return SlideRouteTransition(
      key: pageKey,
      child: child,
      direction: direction,
    );
  }
}

class SlideRouteTransition extends CustomTransitionPage<void> {
  SlideRouteTransition({
    required super.key,
    required super.child,
    SlideDirection direction = SlideDirection.left,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final Offset begin = switch (direction) {
              SlideDirection.right => const Offset(-1.0, 0.0),
              SlideDirection.left => const Offset(1.0, 0.0),
              SlideDirection.up => const Offset(0.0, 1.0),
              SlideDirection.down => const Offset(0.0, -1.0),
            };

            final offsetAnimation =
                Tween(begin: begin, end: Offset.zero).animate(curve);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
