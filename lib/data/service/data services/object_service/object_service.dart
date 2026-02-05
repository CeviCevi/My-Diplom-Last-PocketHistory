import 'dart:developer';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/fish/fish.dart';
import 'package:history/const/fish/obj_fish.dart';
import 'package:history/data/repository/object_repository.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:latlong2/latlong.dart';

class ObjectService {
  final ObjectRepository _repository = ObjectRepository();

  static List<LatLng> modelToChords(List<ObjectModel> objects) {
    return objects.map((o) => LatLng(o.oX, o.oY)).toList();
  }

  Future<void> initDatabase() async {
    final allData = await _repository.getAllObjects();

    if (allData.isNotEmpty) {
      modelsList.clear();
      offerList.clear();

      for (var item in allData) {
        if (item.status == 102) {
          modelsList.add(item);
        } else if (item.status == 101) {
          offerList.add(item);
        }
      }
      log(
        "Данные синхронизированы: ${modelsList.length} объектов, ${offerList.length} заявок",
      );
    }
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

  Future<List<ObjectModel>> getOffer() async {
    return offerList;
  }

  Future<List<LatLng>> getChords({List<ObjectModel>? objects}) async {
    if (objects != null) return objects.map((o) => LatLng(o.oX, o.oY)).toList();
    return modelsList.map((o) => LatLng(o.oX, o.oY)).toList();
  }

  // Мгновенное предложение объекта (статус 101)
  Future<void> offerObject(ObjectModel model) async {
    final newModel = model.copyWith(status: 101);
    offerList.add(newModel);

    // Фоновая отправка
    _repository
        .addObject(newModel)
        .catchError((e) => print("Background error: $e"));
  }

  // Обновление и перевод в статус модерации
  Future<void> updateOffer(ObjectModel model) async {
    modelsList.removeWhere((element) => element.id == model.id);
    offerList.removeWhere((element) => element.id == model.id);

    final updatedModel = model.copyWith(status: 101);
    offerList.add(updatedModel);

    // Фоновая отправка
    _repository
        .updateObject(updatedModel)
        .catchError((e) => print("Background error: $e"));
  }

  // Одобрение объекта (статус 102)
  Future<void> addOfferToModels(ObjectModel object) async {
    offerList.removeWhere((e) => e.id == object.id);

    final approvedObject = object.copyWith(status: 102);
    modelsList.add(approvedObject);

    // Фоновая отправка
    _repository
        .updateObject(approvedObject)
        .catchError((e) => print("Background error: $e"));
  }

  Future<void> delete(ObjectModel object) async {
    modelsList.remove(object);
    _repository
        .deleteObject(object.id)
        .catchError((e) => print("Background error: $e"));
  }

  Future<void> deleteOffer(ObjectModel object) async {
    offerList.remove(object);
    _repository
        .deleteObject(object.id)
        .catchError((e) => print("Background error: $e"));
  }

  // --- ПОИСКОВЫЕ ФУНКЦИИ (Работают по статике для мгновенного отклика) ---

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
      return partialRatio(label, q) >= 60;
    }).toList();
  }

  Future<List<ObjectModel>> findObjectsByTypes({
    required List<String> types,
  }) async {
    if (types.isEmpty) return modelsList;
    final lowerTypes = types.map((t) => t.toLowerCase().trim()).toList();

    return modelsList.where((e) {
      final typeName = e.typeName.toLowerCase().trim();
      return lowerTypes.any((t) => partialRatio(typeName, t) >= 60);
    }).toList();
  }

  Future<List<ObjectModel>> findObjectsByLabelInFav({
    required String query,
  }) async {
    if (query.isEmpty) return userFav;
    final q = query.toLowerCase().trim();

    return userFav.where((e) {
      final label = e.label.toLowerCase();
      return partialRatio(label, q) >= 60;
    }).toList();
  }
}
