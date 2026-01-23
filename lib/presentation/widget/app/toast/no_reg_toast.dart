import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> notRegisteredToast(
  BuildContext context, {
  String title = "Требуется регистрация",
  String message = "Сначала войдите в аккаунт",
  IconData icon = Icons.lock_outline,
}) async {
  return Flushbar(
    title: title,
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(14),

    backgroundGradient: const LinearGradient(
      colors: [Color(0xFFef5350), Color(0xFFd32f2f)],
    ),

    icon: Icon(icon, color: Colors.white, size: 30),

    titleColor: Colors.white,
    messageColor: Colors.white.withAlpha(230),
    titleSize: 16,
    messageSize: 14,

    boxShadows: [
      BoxShadow(
        color: Colors.black.withAlpha(60),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],

    forwardAnimationCurve: Curves.elasticOut,
    reverseAnimationCurve: Curves.easeIn,
    animationDuration: const Duration(milliseconds: 600),
  ).show(context);
}
