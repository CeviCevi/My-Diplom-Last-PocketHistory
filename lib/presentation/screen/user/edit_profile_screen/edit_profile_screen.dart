import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/toast/success_toast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController(text: "Free Pizza");
  final _email = TextEditingController(text: "nikitapytliak@gmail.com");
  final _about = TextEditingController();

  String? avatarBase64;

  final picker = ImagePicker();

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
    debugPrint("Email: ${_email.text}");
    debugPrint("About: ${_about.text}");
    debugPrint("Avatar: ${avatarBase64 != null ? "YES" : "NO"}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Редактирование профиля",
          style: AppStyle.main.copyWith(fontWeight: .bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => RouterService.back(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        surfaceTintColor: AppColor.lightGrey,
        animateColor: false,
        shadowColor: AppColor.grey,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Аватар
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (_) => _imagePickerSheet(),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: avatarBase64 != null
                    ? MemoryImage(base64Decode(avatarBase64!))
                    : null,
                child: avatarBase64 == null
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            _field(_name, "Имя", Icons.person),
            const SizedBox(height: 12),

            _field(_email, "Email", Icons.email),
            const SizedBox(height: 12),

            const SizedBox(height: 30),

            RedBorderButton(
              function: () =>
                  successToast(context, message: "Данные успешно сохранены"),
            ),
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
  }) {
    return TextField(
      controller: controller,
      maxLines: isMultiline ? 4 : 1,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
