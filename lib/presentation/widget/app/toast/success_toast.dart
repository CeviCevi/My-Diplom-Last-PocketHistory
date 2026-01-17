import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<dynamic> successToast(BuildContext context, {String? message}) async {
  return Flushbar(
    title: 'Успех!',
    message: message ?? 'Объект успешно создан',
    duration: const Duration(seconds: 4),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: Colors.green,
    icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    animationDuration: const Duration(milliseconds: 500),
    titleColor: Colors.white,
    messageColor: Colors.white.withAlpha((255 * 0.9).toInt()),
    titleSize: 16,
    messageSize: 14,
    onTap: (flushbar) {},
    onStatusChanged: (status) {
      if (status == FlushbarStatus.DISMISSED) {
        // Действие после закрытия плашки (опционально)
      }
    },
  ).show(context);
}
