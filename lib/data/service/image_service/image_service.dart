import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  // Проверка и запрос разрешений
  Future<bool> _checkPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }

      if (Platform.isAndroid) {
        var cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          cameraStatus = await Permission.camera.request();
        }
        return status.isGranted && cameraStatus.isGranted;
      }

      return status.isGranted;
    }
    return true; // Для Windows всегда true
  }

  // Сжатие изображения
  Future<File?> _compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Ошибка сжатия: $e');
      return file;
    }
  }

  // Выбор изображения из галереи
  Future<String?> pickImageFromGallery() async {
    if (!await _checkPermissions()) {
      return null;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        File? compressedFile = await _compressImage(File(image.path));
        if (compressedFile != null) {
          return await _convertToBase64(compressedFile);
        }
      }
    } catch (e) {
      print('Ошибка выбора из галереи: $e');
    }
    return null;
  }

  // Сделать фото с камеры
  Future<String?> takePhotoFromCamera() async {
    if (!await _checkPermissions()) {
      return null;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        File? compressedFile = await _compressImage(File(image.path));
        if (compressedFile != null) {
          return await _convertToBase64(compressedFile);
        }
      }
    } catch (e) {
      print('Ошибка камеры: $e');
    }
    return null;
  }

  // Конвертация в Base64
  Future<String?> _convertToBase64(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();

      // Проверка размера файла (максимум 5MB)
      if (imageBytes.length > 5 * 1024 * 1024) {
        throw Exception('Изображение слишком большое (максимум 5MB)');
      }

      String base64Image = base64Encode(imageBytes);

      // Определяем MIME тип
      String extension = path.extension(file.path).toLowerCase();
      String mimeType;

      switch (extension) {
        case '.jpg':
        case '.jpeg':
          mimeType = 'image/jpeg';
          break;
        case '.png':
          mimeType = 'image/png';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        case '.webp':
          mimeType = 'image/webp';
          break;
        default:
          mimeType = 'image/jpeg';
      }

      return 'data:$mimeType;base64,$base64Image';
    } catch (e) {
      print('Ошибка конвертации: $e');
      return null;
    }
  }

  // Декодирование Base64 в изображение
  static Image? base64ToImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    try {
      // Удаляем префикс data:image/...;base64, если он есть
      final String base64Data = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      return Image.memory(base64Decode(base64Data), fit: BoxFit.cover);
    } catch (e) {
      print('Ошибка декодирования: $e');
      return null;
    }
  }
}
