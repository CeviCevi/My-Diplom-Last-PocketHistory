import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  // Сжатие Uint8List (байтов) — удобно, если картинка уже в памяти
  static Future<Uint8List> compressBytes(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1024, // Ограничиваем размер по высоте
      minWidth: 1024, // Ограничиваем размер по ширине
      quality: 80, // Качество (от 0 до 100). 80 — золотая середина
      format: CompressFormat.jpeg, // JPEG сжимает лучше всего
    );
    return Uint8List.fromList(result);
  }

  // Сжатие файла (если есть путь к файлу)
  static Future<XFile?> compressFile(String path, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 80,
    );
    return result;
  }
}
