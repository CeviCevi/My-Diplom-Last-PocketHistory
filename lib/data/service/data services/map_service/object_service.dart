import 'package:history/const/fish/obj_fish.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:latlong2/latlong.dart';

class ObjectService {
  Future<List<ObjectModel>> getObjects() async {
    return modelsList;
  }

  Future<List<LatLng>> getChords({List<ObjectModel>? objects}) async {
    if (objects != null) return objects.map((o) => LatLng(o.oX, o.oY)).toList();
    return modelsList.map((o) => LatLng(o.oX, o.oY)).toList();
  }

  Future<ObjectModel?> findByLatLng(
    double lat,
    double lng, {
    List<ObjectModel>? list,
  }) async {
    const tolerance = 0.00001;
    final List<ObjectModel> data = list ?? modelsList;

    return data
        .where(
          (o) =>
              (o.oX - lat).abs() < tolerance && (o.oY - lng).abs() < tolerance,
        )
        .cast<ObjectModel?>()
        .firstOrNull;
  }
}
