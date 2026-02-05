import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/data/repository/marker_repository.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkerService {
  final MarkerRepository _repository = MarkerRepository();

  // Инициализация при старте: подтягиваем ВСЕ маркеры из БД в статику
  Future<void> initMarkers() async {
    try {
      // Здесь предполагается, что в репозитории есть метод getAllMarkers
      // Если его нет, можно сделать выборку по всем ID или создать новый метод в Repo
      final response = await Supabase.instance.client.from('markers').select();
      final allMarkers = (response as List)
          .map((json) => MarkerModel.fromJson(json))
          .toList();

      markerList.clear();
      markerList.addAll(allMarkers);
      print("Маркеры синхронизированы: ${markerList.length} штук");
    } catch (e) {
      print("Ошибка инициализации маркеров: $e");
    }
  }

  Future<List<MarkerModel>> getMarkerListByObjectId(int objectId) async {
    return markerList.where((element) => element.objectId == objectId).toList();
  }

  // Оптимистичное добавление списка
  Future<void> setMarkerList(List<MarkerModel> markers) async {
    // 1. В статику мгновенно
    markerList.addAll(markers);

    // 2. В фоне на сервер каждый маркер
    for (var marker in markers) {
      _repository
          .addMarker(marker)
          .catchError((e) => print("Ошибка синхронизации маркера: $e"));
    }
  }

  // Оптимистичное обновление списка
  Future<void> updateList(List<MarkerModel> markers) async {
    if (markers.isEmpty) return;

    final int targetObjectId = markers.first.objectId;

    // 1. Мгновенно обновляем локальную "рыбу"
    markerList.removeWhere((element) => element.objectId == targetObjectId);
    markerList.addAll(markers);

    // 2. Синхронизируем с сервером
    // Обычно обновление списка — это удаление старых в базе и запись новых,
    // либо поштучный update. В данном случае идем по списку:
    for (var marker in markers) {
      _repository.updateMarker(marker).catchError((e) {
        // Если маркера нет в БД (ошибка обновления), пробуем создать
        _repository.addMarker(marker);
      });
    }
  }

  // Добавим одиночное удаление для полноты CRUD
  Future<void> deleteMarker(MarkerModel marker) async {
    markerList.removeWhere((e) => e.id == marker.id);
    _repository
        .deleteMarker(marker.id)
        .catchError((e) => print("Ошибка удаления маркера: $e"));
  }
}
