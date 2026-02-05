class AchiveModel {
  final int id;
  final String title;
  final String text;
  final String iconName;

  const AchiveModel({
    required this.id,
    required this.title,
    required this.text,
    required this.iconName,
  });

  factory AchiveModel.fromJson(Map<String, dynamic> json) {
    return AchiveModel(
      id: json['id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
      iconName: json['icon_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'text': text, 'icon_name': iconName};
  }
}
