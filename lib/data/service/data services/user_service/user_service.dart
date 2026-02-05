import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/security/user.dart' as global_user;
import 'package:history/const/text/app_key.dart';
import 'package:history/data/repository/user_repository.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/domain/model/user_model/user_model.dart';

class UserService {
  final UserRepository _repository = UserRepository();

  Future<List<UserModel>> getUserList() async {
    return userList;
  }

  // Удаление: сначала из статики, потом с сервера
  Future<void> delete(UserModel userModel) async {
    userList.remove(userModel);

    // Отправляем на сервер без await, чтобы не ждать ответа
    _repository.deleteUser(userModel.id).catchError((e) {
      print("Ошибка фонового удаления: $e");
      // Тут можно вернуть пользователя в список, если критично
    });
  }

  Future<UserModel?> getUserById(int id) async {
    var data = userList.where((element) => element.id == id);
    return data.isNotEmpty ? data.first : null;
  }

  // Обновление: мгновенно в статику и глобальный объект, затем на сервер
  Future<void> update(UserModel model) async {
    final index = userList.indexWhere((u) => u.id == model.id);
    if (index != -1) {
      userList[index] = model;

      // Обновляем текущего юзера в системе (синхронно)
      global_user.user = global_user.user.copyWith(
        name: model.name,
        image: model.image,
        surname: model.surname,
      );

      // Отправляем в Supabase в фоне
      _repository.updateUser(model).catchError((e) {
        print("Ошибка фонового обновления: $e");
      });
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

    // Генерируем ID (в идеале лучше дождаться ID от БД, но для статики делаем так)
    int id = DateTime.now().microsecondsSinceEpoch;

    final newUser = UserModel(
      id: id,
      name: name,
      surname: surname,
      email: email,
      password: password,
    );

    // 1. Мгновенно в статику
    userList.add(newUser);

    // 2. В кэш
    await CacheService.instance.setBool(AppKey.userAuth, true);
    await CacheService.instance.setInt(AppKey.userInSystem, id);

    // 3. На сервер (невидимка)
    _repository.createUser(newUser).catchError((e) {
      print("Ошибка фоновой регистрации: $e");
    });

    return true;
  }

  Future<void> initUsers() async {
    try {
      // Получаем всех пользователей из репозитория
      final allUsers = await _repository.getAllUsers();

      if (allUsers.isNotEmpty) {
        userList.clear(); // Очищаем дефолтную "рыбу"
        userList.addAll(allUsers); // Заполняем реальными данными
        print("Пользователи синхронизированы: ${userList.length}");
      }
    } catch (e) {
      print("Ошибка инициализации пользователей: $e");
    }
  }
}
