import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/security/user.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/domain/model/user_model/user_model.dart';

class UserService {
  Future<UserModel?> getUserById(int id) async {
    var data = userList.where((element) => element.id == id);
    return data.isNotEmpty ? data.first : null;
  }

  Future<void> update(UserModel model) async {
    final index = userList.indexWhere((u) => u.id == model.id);
    if (index != -1) {
      userList[index] = model;

      user.copyWith(
        name: model.name,
        image: model.image,
        surname: model.surname,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    var data = userList.where(
      (e) =>
          (e.email.toLowerCase() == email.toLowerCase() &&
          e.password.toLowerCase() == password.toLowerCase()),
    );
    if (data.isNotEmpty) {
      await CacheService.instance.setBool(AppKey.userAuth, true);
      await CacheService.instance.setInt(AppKey.userInSystem, data.first.id);
      return true;
    }

    return false;
  }

  Future<bool> registration(
    String email,
    String password,
    String name,
    String surname,
  ) async {
    if (userList
        .where((e) => (e.email.toLowerCase() == email.toLowerCase()))
        .isNotEmpty) {
      return false;
    }

    int id = DateTime.now().microsecondsSinceEpoch;

    userList.add(
      UserModel(
        id: id,
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    );

    await CacheService.instance.setBool(AppKey.userAuth, true);
    await CacheService.instance.setInt(AppKey.userInSystem, id);

    return true;
  }
}
