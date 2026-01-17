import 'dart:developer';

import 'package:flutter/material.dart';

class RouterService {
  static void route(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => widget,
        transitionsBuilder: (_, animation, _, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
    log("void route", name: "RouterService");
  }

  static void routeFade(
    BuildContext context,
    Widget widget, {
    Duration? duration,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: duration ?? Duration(milliseconds: 100),
        reverseTransitionDuration: duration ?? Duration(milliseconds: 100),
        pageBuilder: (_, _, _) => widget,
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    log("void routeFade", name: "RouterService");
  }

  static void routeCloseAll(
    BuildContext context,
    Widget widget, {
    Duration? duration,
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: duration ?? Duration(milliseconds: 100),
        reverseTransitionDuration: duration ?? Duration(milliseconds: 100),
        pageBuilder: (_, _, _) => widget,
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    log("void routeCloseAll", name: "RouterService");
  }

  static void back(BuildContext context) {
    Navigator.pop(context);
    log("void back", name: "RouterService");
  }
}
