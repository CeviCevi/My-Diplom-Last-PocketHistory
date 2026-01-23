import 'dart:core';

import 'package:history/const/fish/img/i.dart';
import 'package:history/domain/model/achive_model/achive_model.dart';
import 'package:history/domain/model/achive_model/user_achive_model.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/domain/model/user_model/user_model.dart';

List<UserModel> userList = [
  UserModel(
    id: 0,
    name: "good",
    surname: "man",
    email: "test@mail.com",
    password: "1111",
  ),
  UserModel(
    id: 1,
    name: "bad",
    surname: "man",
    email: "user@mail.com",
    password: "1111",
  ),
  UserModel(
    id: 2,
    name: "god",
    surname: "god",
    email: "man@mail.com",
    password: "1111",
  ),
];

List<MarkerModel> markerList = [
  MarkerModel(
    id: 0,
    objectId: 1,
    title: "Барельефы",
    description:
        "На Минской площади Победы, вокруг 38-метрового обелиска, расположены бронзовые горельефы, изображающие сцены героизма и воинской славы, в том числе орден Победы и меч, а также мемориальный зал под площадью с именами Героев Советского Союза, что создает два «огня» — настоящий и символический, увековечивая подвиг народа в Великой Отечественной войне",
    xPercent: 0.5,
    yPercent: 0.55,
  ),
  MarkerModel(
    id: 1,
    objectId: 1,
    title: "Вечный огонь",
    description:
        "На площади Победы в Минске с 1961 года горит первый в истории Беларуси Вечный огонь. Молодое поколение белорусов вряд ли знает, что архитектурное окружение величественного монумента Победы в центре столицы еще полвека назад было иным: свой нынешний вид площадь приобрела в 1984‑м. Раскрываем уникальные подробности этого преображения.",
    xPercent: 0.65,
    yPercent: .75,
  ),
  MarkerModel(
    id: 2,
    objectId: 1,
    title: "Обелиск",
    description:
        "Это 38-метровый гранитный обелиск, увенчанный трехметровым изображением ордена Победы.",
    xPercent: 0.5,
    yPercent: 0.30,
  ),
];

List<ArImageModel> arImageList = [ArImageModel(id: 0, objectId: 1, image: i)];

//все ачивки пользователей
List<UserAchiveModel> achiveList = [
  UserAchiveModel(
    id: 0,
    userId: 0,
    achiveId: 0,
    date: DateTime.now().toIso8601String(),
  ),
];

//все ачивки приложения
List<AchiveModel> appAchiveList = [
  AchiveModel(
    id: 0,
    title: "Тестовая Ачивка",
    text: "Успешно загрузить сервис получения ачивок",
    iconName: "home",
  ),
  AchiveModel(
    id: 1,
    title: "Исследователь",
    text: "Изучить первый объект",
    iconName: "map",
  ),
];

List<CommentModel> commentList = [];
List<ObjectModel> offerList = [];
