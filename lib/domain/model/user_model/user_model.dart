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

  UserModel copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? password,
    String? image,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
    );
  }
}
