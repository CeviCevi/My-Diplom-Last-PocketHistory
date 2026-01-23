import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';

class ArImageService {
  Future<ArImageModel?> getImageByObjectId(int objectId) async {
    var data = arImageList.where((e) => e.objectId == objectId).toList();
    return data.isNotEmpty ? data.first : arImageList.first;
  }
}
