import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';

class MarkerService {
  Future<List<MarkerModel>> getMarkerListByObjectId(int objectId) async {
    return markerList.where((element) => element.objectId == objectId).toList();
  }

  Future<void> setMarkerList(List<MarkerModel> markers) async {
    markerList.addAll(markers);
  }

  Future<void> updateList(List<MarkerModel> markers) async {
    if (markers.isEmpty) return;

    final int targetObjectId = markers.first.objectId;

    markerList.removeWhere((element) => element.objectId == targetObjectId);

    markerList.addAll(markers);
  }
}
