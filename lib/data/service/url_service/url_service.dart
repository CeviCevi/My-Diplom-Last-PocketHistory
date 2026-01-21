import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> openMapsRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng, {
    BuildContext? context,
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      log('Не удалось открыть Google Maps');
      context != null
          // ignore: use_build_context_synchronously
          ? errorToast(context, message: "Не удалось открыть карту")
          : null;
    }
  }

  static Future<void> shareImageWithText(
    String base64Image,
    String text, {
    BuildContext? context,
  }) async {
    try {
      final bytes = base64Decode(base64Image);

      final tempDir = await getTemporaryDirectory();

      final filePath = '${tempDir.path}/История_В_Кармане.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      final params = ShareParams(text: text, files: [XFile(file.path)]);

      await SharePlus.instance.share(params);
      await file.delete();
    } catch (e) {
      log('Ошибка при шаринге: $e');
      context != null
          // ignore: use_build_context_synchronously
          ? errorToast(context, message: "Неизвестная ошибка шарринга")
          : null;
    }
  }
}
