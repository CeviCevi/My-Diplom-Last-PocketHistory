import 'package:history/const/fish/img/i1.dart';
import 'package:history/const/fish/img/i2.dart';
import 'package:history/const/fish/img/i3.dart';
import 'package:history/const/fish/img/i4.dart';
import 'package:history/domain/model/object_model/object_model.dart';

final ObjectModel nesvizhCastle = ObjectModel(
  id: 3,
  creatorId: 999999,
  label: "Несвижский замок",
  address: "г. Несвиж, Минская область",
  oX: 53.2225,
  oY: 26.6914,
  about:
      "Несвижский замок — бывшая резиденция князей Радзивиллов, архитектурный ансамбль XVI–XVIII веков. Один из главных туристических объектов Беларуси.",
  typeName: "Дворец",
  imageBit: i4,
);

final ObjectModel mirCastle = ObjectModel(
  id: 2,
  creatorId: 999999,
  label: "Мирский замок",
  address: "г. Мир, Гродненская область",
  oX: 53.4513,
  oY: 26.4729,
  about:
      "Мирский замок — выдающийся памятник архитектуры XVI века, включённый в список Всемирного наследия ЮНЕСКО. Замок сочетает элементы готики, ренессанса и барокко.",
  typeName: "Замок",
  imageBit: i3,
);

final ObjectModel belovezhskayaPushcha = ObjectModel(
  id: 4,
  creatorId: 999999,
  label: "Беловежская пуща",
  address: "Брестская и Гродненская области",
  oX: 52.7056,
  oY: 23.8343,
  about:
      "Беловежская пуща — национальный парк и объект ЮНЕСКО. Один из последних и крупнейших сохранившихся участков первобытного леса в Европе.",
  typeName: "Национальный парк",
  imageBit: i2,
);

final ObjectModel victorySquare = ObjectModel(
  id: 1,
  creatorId: 999999,
  label: "Площадь Победы",
  address: "г. Минск, проспект Независимости",
  oX: 53.9176,
  oY: 27.5489,
  about:
      "Площадь Победы — мемориальный комплекс в центре Минска, посвящённый подвигу советских солдат в годы Великой Отечественной войны. В центре площади установлен 38-метровый обелиск Победы и Вечный огонь.",
  typeName: "Площадь",
  imageBit: i1,
);

final List<ObjectModel> modelsList = [
  victorySquare,
  belovezhskayaPushcha,
  mirCastle,
  nesvizhCastle,
];
