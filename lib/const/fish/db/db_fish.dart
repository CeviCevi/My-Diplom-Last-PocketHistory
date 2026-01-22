import 'package:history/domain/model/comment_model/comment_model.dart';
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

List<CommentModel> commentList = [];
List<ObjectModel> offerList = [];
