import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';
import 'package:history/presentation/screen/user/cab_screen/widget/profile_button.dart';

class SettingsBlock extends StatelessWidget {
  final List<ProfileButton> buttons;
  final double spacing;
  const SettingsBlock({
    super.key,
    this.spacing = .0,
    this.buttons = const [
      ProfileButton(text: "Редактировать профиль", icon: Icons.edit),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      padding: .symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: .circular(16),
        boxShadow: [
          AppShadow.boxMainShadow.copyWith(color: AppColor.grey.withAlpha(50)),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: spacing,
        children: buttons,
      ),
    );
  }
}
