class UserModel {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String? image;

  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    this.image,
  });
}
