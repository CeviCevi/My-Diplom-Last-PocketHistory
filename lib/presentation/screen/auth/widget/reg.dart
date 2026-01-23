import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/presentation/screen/user/navigation/navigation_screen/navigation_screen.dart';
import 'package:history/presentation/widget/app/text_field/auth_text_field/auth_text_field.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';

class RegistrationScreen extends StatefulWidget {
  final GestureTapCallback? onRegister;
  final GestureTapCallback? onBack;

  const RegistrationScreen({super.key, this.onRegister, this.onBack});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // чтобы клавиатура не двигала экран
      backgroundColor: AppColor.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                const Text(
                  "Регистрация",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.red,
                  ),
                ),
                const SizedBox(height: 40),

                // Имя
                AuthTextField(
                  controller: nameController,
                  hintText: "Имя",
                  icon: Icons.person_outline,
                  isPassword: false,
                ),
                const SizedBox(height: 20),

                // Фамилия
                AuthTextField(
                  controller: surnameController,
                  hintText: "Фамилия",
                  icon: Icons.person_outline,
                  isPassword: false,
                ),
                const SizedBox(height: 20),

                // Email
                AuthTextField(
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.email_outlined,
                  isPassword: false,
                ),
                const SizedBox(height: 20),

                // Пароль
                AuthTextField(
                  controller: passwordController,
                  hintText: "Пароль",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                // Кнопка Зарегистрироваться
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          surnameController.text.isNotEmpty) {
                        setState(() => isLoading = true);
                        if (await UserService().registration(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          surnameController.text,
                        )) {
                          RouterService.routeCloseAll(
                            context,
                            NavigationScreen(),
                          );
                          return;
                        } else {
                          errorToast(context, message: "Неверные данные");
                        }
                        setState(() => isLoading = false);
                      } else {
                        errorToast(
                          context,
                          message: "Все поля должны быть заполнены",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Зарегистрироваться",
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Кнопка Назад
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Назад",
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
