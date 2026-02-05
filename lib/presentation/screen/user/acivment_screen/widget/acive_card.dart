import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/data%20services/achive_service/achive_service.dart';
import 'package:history/data/service/text_service/date_formatter_service.dart';
import 'package:history/domain/model/achive_model/user_achive_model.dart';
import 'package:history/presentation/screen/user/acivment_screen/function/find_icon.dart';

class AciveCard extends StatefulWidget {
  const AciveCard({super.key, required this.model});

  final UserAchiveModel model;

  @override
  State<AciveCard> createState() => _AciveCardState();
}

class _AciveCardState extends State<AciveCard> {
  IconData icon = Icons.numbers_outlined;
  String title = "";
  String description = "";
  late String date = widget.model.date;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    var data = await AchiveService().getAchiveById(widget.model.achiveId);
    data != null
        ? setState(() {
            title = data.title;
            description = data.text;
            icon = getIconDataFromName(data.iconName);
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFfbc02d), Color(0xFFffa000)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withAlpha(220),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              DateFormatterService.getGreatDate(date),
              style: TextStyle(color: AppColor.lightGrey, fontWeight: .w500),
            ),
          ],
        ),
      ),
    );
  }
}
