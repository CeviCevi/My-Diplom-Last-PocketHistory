import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/data/repository/ar_repository.dart';
import 'package:history/data/service/image_service/compressor.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';

class ArImageService {
  final ArImageRepository _repository = ArImageRepository();

  // --- ИНИЦИАЛИЗАЦИЯ ---
  Future<void> initArImages() async {
    try {
      final allImages = await _repository.getAllArImages();
      arImageList.clear();
      arImageList.addAll(allImages);
      debugPrint("AR-изображения загружены: ${arImageList.length}");
    } catch (e) {
      debugPrint("Ошибка инициализации AR: $e");
    }
  }

  // --- ЧТЕНИЕ ---
  Future<ArImageModel?> getImageByObjectId(int objectId) async {
    var data = arImageList.where((e) => e.objectId == objectId).toList();
    // Если по ID не нашли, возвращаем первый попавшийся или null (убрал debugPrint для чистоты)
    return data.isNotEmpty
        ? data.first
        : (arImageList.isNotEmpty ? arImageList.first : null);
  }

  Future<List<ArImageModel>> getImageList() async {
    return arImageList;
  }

  // --- ЗАПИСЬ (Оптимистичный UI) ---

  Future<void> setAr(ArImageModel model) async {
    // 1. Мгновенно в статику (оригинал для скорости UI)
    arImageList.add(model);

    // 2. В фоне сжимаем и отправляем
    Future(() async {
      try {
        // Предположим, твоя строка base64 хранится в model.image
        // Декодируем строку в байты
        Uint8List originalBytes = base64Decode(model.image);

        // Сжимаем
        Uint8List compressedBytes = await ImageCompressor.compressBytes(
          originalBytes,
        );

        // Кодируем обратно в base64 для сохранения
        String compressedBase64 = base64Encode(compressedBytes);

        // Создаем новую модель со сжатой картинкой
        final compressedModel = model.copyWith(image: compressedBase64);

        // Отправляем на сервер
        await _repository.addArImage(compressedModel);
      } catch (e) {
        print("Ошибка при сжатии или отправке: $e");
      }
    });
  }

  Future<void> delete(ArImageModel model) async {
    // 1. Мгновенно из статики
    arImageList.removeWhere((e) => e.id == model.id);

    // 2. В фоне с сервера
    _repository.deleteArImage(model.id).catchError((e) {
      debugPrint("Ошибка фонового удаления AR: $e");
    });
  }

  Future<void> update(ArImageModel model) async {
    // 1. Локальное обновление
    int index = arImageList.indexWhere((element) => element.id == model.id);

    if (index != -1) {
      arImageList[index] = model;
    } else {
      arImageList.add(model);
    }

    // 2. Синхронизация (update в репозитории)
    // Добавь метод updateArImage в репозиторий по аналогии с другими
    _repository.addArImage(model).catchError((e) {
      debugPrint("Ошибка фонового обновления AR: $e");
    });
  }
}
