import 'package:flutter/foundation.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';

class ArImageService {
  Future<ArImageModel?> getImageByObjectId(int objectId) async {
    var data = arImageList.where((e) {
      debugPrint(objectId.toString());
      return e.objectId == objectId;
    }).toList();
    return data.isNotEmpty ? data.first : arImageList.first;
  }

  Future<void> setAr(ArImageModel model) async {
    arImageList.add(model);
  }

  Future<void> delete(ArImageModel model) async {
    arImageList.remove(model);
  }

  Future<List<ArImageModel>> getImageList() async {
    return arImageList;
  }

  Future<void> update(ArImageModel model) async {
    int index = arImageList.indexWhere((element) => element.id == model.id);

    if (index != -1) {
      arImageList[index] = model;
    } else {
      arImageList.add(model);
    }
  }
}
