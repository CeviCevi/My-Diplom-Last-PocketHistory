import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';

Future<dynamic> errorToast(BuildContext context, {String? message}) async {
  return Flushbar(
    title: 'Ошибка!',
    message: message ?? 'Произошла непредвиденная ошибка',
    duration: const Duration(seconds: 4),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: AppColor.red,
    icon: const Icon(Icons.error_outline, color: AppColor.white, size: 28),
    forwardAnimationCurve: Curves.easeOutCubic,
    reverseAnimationCurve: Curves.easeInCubic,
    animationDuration: const Duration(milliseconds: 500),
    titleColor: AppColor.white,
    messageColor: AppColor.white.withAlpha((255 * 0.9).toInt()),
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
