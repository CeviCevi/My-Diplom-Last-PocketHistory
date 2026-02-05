import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/data%20services/achive_service/achive_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/user/navigation/navigation_screen/navigation_screen.dart';
import 'package:history/presentation/widget/app/text_field/auth_text_field/auth_text_field.dart';
import 'package:history/presentation/widget/app/toast/achive_toast.dart';
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
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
                  textAlign: .center,
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
                      final name = nameController.text.trim();
                      final surname = surnameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      // Проверка на пустые поля
                      if (name.isEmpty ||
                          surname.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty) {
                        errorToast(
                          context,
                          position: .TOP,
                          message: "Все поля должны быть заполнены",
                        );
                        return;
                      }

                      // Проверка email
                      if (!_isValidEmail(email)) {
                        errorToast(
                          context,
                          position: .TOP,
                          message: "Введите корректный Email",
                        );
                        return;
                      }

                      // Проверка пароля
                      if (!_isValidPassword(password)) {
                        errorToast(
                          context,
                          position: .TOP,
                          message: "Пароль должен быть не менее 6 символов",
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      final success = await UserService().registration(
                        email,
                        password,
                        name,
                        surname,
                      );

                      if (success) {
                        RouterService.routeCloseAll(
                          context,
                          NavigationScreen(),
                        );
                        AchiveService().setUserAchiveById(
                          userId:
                              CacheService.instance.getInt(
                                AppKey.userInSystem,
                              ) ??
                              0,
                          achiveId: 3,
                        );
                        achievementToast(context);
                        return;
                      } else {
                        errorToast(
                          context,
                          message: "Неверные данные",
                          position: .TOP,
                        );
                      }

                      setState(() => isLoading = false);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Продолжить",
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
