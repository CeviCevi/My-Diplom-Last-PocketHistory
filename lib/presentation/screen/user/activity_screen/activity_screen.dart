import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/user/activity_screen/screen/my_comment_screen.dart';
import 'package:history/presentation/screen/user/activity_screen/screen/my_object_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void goToPage(int page) {
    setState(() => currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _tabButton(String title, int index) {
    final bool isActive = currentPage == index;

    return GestureDetector(
      onTap: () => goToPage(index),
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width / 2,
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isActive ? AppColor.red : AppColor.lightGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: .circular(index == 0 ? 16 : 0),
            bottomRight: .circular(index == 1 ? 16 : 0),
          ),
          boxShadow: !isActive ? [AppShadow.boxMainShadow] : null,
        ),
        child: Center(
          child: Text(
            title,
            style: AppStyle.main.copyWith(
              color: isActive ? AppColor.white : AppColor.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Моя активность",
          style: AppStyle.main.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => RouterService.back(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        surfaceTintColor: AppColor.lightGrey,
        shadowColor: AppColor.grey,
        elevation: 1,
      ),
      body: Column(
        children: [
          /// КНОПКИ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabButton("Мои комментарии", 0),
              _tabButton("Мои объекты", 1),
            ],
          ),

          const SizedBox(height: 20),

          /// PAGE VIEW
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              children: const [MyCommentScreen(), MyObjectScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
