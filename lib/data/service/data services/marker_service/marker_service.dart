import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';

class MarkerService {
  Future<List<MarkerModel>> getMarkerListByObjectId(int objectId) async {
    return markerList.where((element) => element.objectId == objectId).toList();
  }
}
