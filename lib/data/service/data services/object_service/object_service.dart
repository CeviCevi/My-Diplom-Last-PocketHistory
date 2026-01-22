import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/fish/fish.dart';
import 'package:history/const/fish/obj_fish.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:latlong2/latlong.dart';

class ObjectService {
  static List<LatLng> modelToChords(List<ObjectModel> objects) {
    return objects.map((o) => LatLng(o.oX, o.oY)).toList();
  }

  Future<ObjectModel?> getObjectById(int objectId) async {
    final data = modelsList.where((e) => e.id == objectId).toList();
    return data.isNotEmpty ? data.first : null;
  }

  Future<List<ObjectModel>> getMyObject(int userId) async {
    return modelsList.where((e) => e.creatorId == userId).toList();
  }

  Future<List<ObjectModel>> getMyOffer(int userId) async {
    return offerList.where((e) => e.creatorId == userId).toList();
  }

  Future<List<ObjectModel>> getObjects() async {
    return modelsList;
  }

  Future<List<LatLng>> getChords({List<ObjectModel>? objects}) async {
    if (objects != null) return objects.map((o) => LatLng(o.oX, o.oY)).toList();
    return modelsList.map((o) => LatLng(o.oX, o.oY)).toList();
  }

  Future<void> offerObject(ObjectModel model) async {
    offerList.add(model);
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

  Future<List<ObjectModel>> findObjectsByLabel({required String query}) async {
    if (query.isEmpty) return modelsList;

    final q = query.toLowerCase().trim();

    return modelsList.where((e) {
      final label = e.label.toLowerCase();

      final score = partialRatio(label, q);

      return score >= 60;
    }).toList();
  }

  Future<List<ObjectModel>> findObjectsByTypes({
    required List<String> types,
  }) async {
    if (types.isEmpty) return modelsList;

    final lowerTypes = types.map((t) => t.toLowerCase().trim()).toList();

    final filtered = modelsList.where((e) {
      final typeName = e.typeName.toLowerCase().trim();
      return lowerTypes.any((t) => partialRatio(typeName, t) >= 60);
    }).toList();

    return filtered;
  }

  Future<List<ObjectModel>> findObjectsByLabelInFav({
    required String query,
  }) async {
    if (query.isEmpty) return userFav;

    final q = query.toLowerCase().trim();

    return userFav.where((e) {
      final label = e.label.toLowerCase();

      final score = partialRatio(label, q);

      return score >= 60;
    }).toList();
  }
}
