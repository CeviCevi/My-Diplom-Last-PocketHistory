import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/presentation/screen/user/navigation/navigation_screen/navigation_screen.dart';
import 'package:history/presentation/widget/app/text_field/auth_text_field/auth_text_field.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';

class LoginScreen extends StatefulWidget {
  final GestureTapCallback? onLogin;
  final GestureTapCallback? onBack;

  const LoginScreen({super.key, this.onLogin, this.onBack});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(
    text: "",
  );
  bool isLoading = false;

  @override
  void dispose() {
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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: .start,
              children: [
                // Заголовок
                const Text(
                  "Вход",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.red,
                  ),
                ),
                const SizedBox(height: 40),
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

                // Кнопка Войти
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      // Проверка email
                      if (!_isValidEmail(email)) {
                        errorToast(
                          position: .TOP,
                          context,
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

                      final success = await UserService().login(
                        password,
                        email,
                      );

                      if (success) {
                        RouterService.routeCloseAll(
                          context,
                          NavigationScreen(),
                        );
                        return;
                      } else {
                        errorToast(
                          context,
                          position: .TOP,
                          message: "Неверные логин или пароль",
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
                  width: double.infinity,
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
