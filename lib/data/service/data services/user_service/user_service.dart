import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/user_model/user_model.dart';

class UserService {
  Future<UserModel?> getUserById(int id) async {
    return userList.where((element) => element.id == id).first;
  }
}
