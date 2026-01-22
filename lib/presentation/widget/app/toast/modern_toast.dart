import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<dynamic> modernToast(BuildContext context) async {
  return Flushbar(
    title: 'Удалено!',
    message: 'Объект был удален из вашего списка избранного',
    duration: Duration(seconds: 4),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const .all(10),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: Colors.green,
    icon: Icon(Icons.check_circle, color: Colors.white, size: 28),

    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    animationDuration: Duration(milliseconds: 500),

    titleColor: Colors.white,
    messageColor: Colors.white.withAlpha((255 * 0.9).toInt()),
    titleSize: 16,
    messageSize: 14,

    onTap: (flushbar) {},

    // Когда плашка исчезает
    onStatusChanged: (status) {
      if (status == FlushbarStatus.DISMISSED) {
        // Действие после закрытия плашки
      }
    },
  ).show(context);
}
