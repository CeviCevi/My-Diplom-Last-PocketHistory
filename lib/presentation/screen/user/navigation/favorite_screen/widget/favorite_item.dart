import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/fish/fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen/detail_object_screen.dart';
import 'package:history/presentation/widget/app/toast/modern_toast.dart';

class FavoriteItem extends StatelessWidget {
  final ObjectModel? model;
  final Function? isDimissed;

  const FavoriteItem({super.key, this.model, this.isDimissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // Показываем диалог подтверждения
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Удалить из избранного?"),
            content: Text(
              "Вы уверены, что хотите удалить этот объект из избранного?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Отмена"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Удалить", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        userFav.removeWhere((obj) => obj.id == model?.id);
        isDimissed?.call();
        modernToast(context);
      },

      child: Material(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: InkWell(
          onTap: () => RouterService.routeFade(
            context,
            DetailObjectScreen(seeBackButton: true, model: model),
          ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        AppShadow.boxMainShadow.copyWith(
                          offset: Offset(0, 0),
                          blurRadius: 1,
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: model == null
                            ? NetworkImage(
                                "https://images.pexels.com/photos/13982312/pexels-photo-13982312.jpeg",
                              )
                            : MemoryImage(base64Decode(model!.imageBit!)),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          model?.label ?? "Какойто замок",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: AppStyle.main.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          model?.address ?? "Какойто адрес",
                          style: AppStyle.main.copyWith(
                            letterSpacing: .5,
                            fontSize: 12,
                            color: AppColor.grey,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    size: 15,
                                    color: AppColor.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    model?.typeName ?? "Какойто тип",
                                    style: AppStyle.main.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColor.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
