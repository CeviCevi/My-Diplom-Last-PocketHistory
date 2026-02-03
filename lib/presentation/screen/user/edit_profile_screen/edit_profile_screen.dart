import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/security/user.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/toast/success_toast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final GestureTapCallback? fuction;
  const EditProfileScreen({super.key, this.fuction});

  @override
  State<EditProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _surname;
  late TextEditingController _email;
  late TextEditingController _password;

  String? avatarBase64;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: user.name);
    _surname = TextEditingController(text: user.surname);
    _email = TextEditingController(text: user.email);
    _password = TextEditingController(text: user.password);
    avatarBase64 = user.image;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      avatarBase64 = base64Encode(bytes);
    });
  }

  void saveProfile() {
    debugPrint("Name: ${_name.text}");
    debugPrint("Surname: ${_surname.text}");
    debugPrint("Email: ${_email.text}");
    debugPrint("Password: ${_password.text}");
    debugPrint("Avatar: ${avatarBase64 != null ? "YES" : "NO"}");

    final updatedUser = user.copyWith(
      name: _name.text,
      surname: _surname.text,
      image: avatarBase64,
    );

    UserService().update(updatedUser);

    // ⚠️ ОБЯЗАТЕЛЬНО
    user = updatedUser;

    successToast(context, message: "Данные успешно сохранены");
  }

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      appBar: AppBar(
        title: Text(
          "Редактирование профиля",
          style: AppStyle.main.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            RouterService.back(context);
            widget.fuction?.call();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        surfaceTintColor: AppColor.lightGrey,
        animateColor: false,
        shadowColor: AppColor.grey,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Аватар
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (_) => _imagePickerSheet(),
                backgroundColor: AppColor.lightGrey,
                isScrollControlled: true,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: avatarBase64 != null
                        ? [AppColor.red, AppColor.red.withOpacity(0.6)]
                        : [Colors.grey.shade300, Colors.grey.shade200],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: avatarBase64 != null
                      ? MemoryImage(base64Decode(avatarBase64!))
                      : null,
                  child: avatarBase64 == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Имя
            _field(_name, "Имя", Icons.person_outline),

            const SizedBox(height: 16),

            // Фамилия
            _field(_surname, "Фамилия", Icons.person_outline),

            const SizedBox(height: 16),

            // Email (readonly)
            _field(_email, "Email", Icons.email_outlined, readOnly: true),

            const SizedBox(height: 30),

            RedBorderButton(function: saveProfile, text: "Сохранить"),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isMultiline = false,
    bool readOnly = false,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        maxLines: isMultiline ? 4 : 1,
        minLines: isMultiline ? 3 : 1,
        cursorColor: AppColor.red,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColor.red),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _imagePickerSheet() {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Камера"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Галерея"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
