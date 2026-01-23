import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/presentation/screen/auth/widget/base_auth.dart';
import 'package:history/presentation/screen/auth/widget/login.dart';
import 'package:history/presentation/screen/auth/widget/reg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double del = 2.3;
  int _currentIndex = 0;

  late List<Widget> widgetsList = [
    BaseAuth(
      login: () {
        del = 1.2;
        setState(() => _currentIndex = 1);
      },
      register: () {
        del = 1.2;
        setState(() => _currentIndex = 2);
      },
    ),
    LoginScreen(
      onBack: () {
        del = 2.3;
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    RegistrationScreen(
      onBack: () {
        del = 2.3;
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColor.black,
              image: DecorationImage(
                image: AssetImage(AppPath.imageBg),
                fit: .cover,
                opacity: 0.7,
              ),
            ),
          ),

          ClipRRect(
            child: BackdropFilter(
              filter: .blur(sigmaX: 20, sigmaY: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        opacity: _currentIndex == 0 ? 1.0 : 0.0,
                        child: const Icon(
                          Icons.map_outlined,
                          size: 50,
                          color: AppColor.white,
                        ),
                      ),
                      Text(
                        "ИСТОРИЯ В КАРМАНЕ",
                        textAlign: .start,
                        style: GoogleFonts.manrope(
                          fontSize: 30,
                          fontWeight: .bold,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInSine,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / del,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: .vertical(top: .elliptical(100, 40)),
                ),
                child: Padding(
                  padding: const .all(40.0),
                  child: widgetsList[_currentIndex],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
