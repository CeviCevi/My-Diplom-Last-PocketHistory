import 'package:flutter/material.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/presentation/screen/user/navigation/favorite_screen/widget/favorite_item.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/castle_text_field.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController controller = TextEditingController(text: "");
  bool seeBorder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => seeBorder = true);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          CastleTextField(
            controller: controller,
            lookBorder: seeBorder,
            searchNewObj: () => setState(() {}),
            whenClearTap: () => setState(() {}),
          ),
          FutureBuilder(
            future: ObjectService().findObjectsByLabelInFav(
              query: controller.text,
            ),
            builder: (context, snapshot) {
              return Expanded(
                child: snapshot.data?.isNotEmpty ?? false
                    ? ListView.builder(
                        padding: const .all(0),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) => Padding(
                          padding: .symmetric(horizontal: 20, vertical: 10),
                          child: FavoriteItem(
                            model: snapshot.data![index],
                            isDimissed: () => setState(() {}),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        spacing: 5,
                        children: [
                          Icon(Icons.account_balance_rounded),
                          Text("Нет избранных мест", style: AppStyle.main),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
