import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/presentation/screen/auth/auth_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            spacing: 10,
            children: [
              Spacer(),
              Container(
                padding: .all(20),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: .circular(16),
                  boxShadow: [AppShadow.boxMainShadow],
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 20,
                  children: [
                    Text(
                      "Пользователь!",
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: 24,
                        fontWeight: .bold,
                      ),
                    ),
                    Text(
                      "Чтобы получить доступ ко всем функциям приложения, сначала нужно войти в аккаунт",
                      textAlign: .justify,
                      style: TextStyle(
                        color: AppColor.red,
                        fontSize: 16,
                        fontWeight: .w400,
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),
              Center(
                child: CupertinoButton(
                  onPressed: () =>
                      RouterService.routeCloseAll(context, RegisterScreen()),
                  padding: .all(0),
                  alignment: .center,
                  child: Text(
                    "Войти",
                    style: GoogleFonts.manrope(
                      color: AppColor.black,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
