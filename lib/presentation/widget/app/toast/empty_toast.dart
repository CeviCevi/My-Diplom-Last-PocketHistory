import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<dynamic> emptyToast(
  BuildContext context, {
  String label = 'Ничего не найдено',
  String text = 'Попробуйте изменить запрос поиска',
  IconData icon = Icons.search_off_rounded,
}) async {
  return Flushbar(
    title: label,
    message: text,
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: Colors.grey.shade800,

    icon: Icon(icon, color: Colors.white, size: 28),

    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    animationDuration: const Duration(milliseconds: 450),

    titleColor: Colors.white,
    messageColor: Colors.white70,
    titleSize: 16,
    messageSize: 14,
  ).show(context);
}
