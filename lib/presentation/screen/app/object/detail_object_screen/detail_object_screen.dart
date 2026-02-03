import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/fish/fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/url_service/url_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/interective_screen/interective_screen.dart';
import 'package:history/presentation/widget/app/button/action_button_menu.dart';
import 'package:history/presentation/widget/app/button/comment_button.dart';
import 'package:history/presentation/widget/app/toast/empty_toast.dart';
import 'package:history/presentation/widget/app/toast/no_reg_toast.dart';
import 'package:history/presentation/widget/test/simple_chat.dart';
import 'package:history/presentation/widget/text_field/expanded_text.dart';
import 'package:history/presentation/widget/text_field/object_label_text.dart';

class DetailObjectScreen extends StatefulWidget {
  final bool seeBackButton;
  final ObjectModel? model;
  final bool lookComments;
  final bool lookAr;

  const DetailObjectScreen({
    super.key,
    this.seeBackButton = false,
    this.model,
    this.lookComments = true,
    this.lookAr = true,
  });

  @override
  State<DetailObjectScreen> createState() => _DetailObjectScreenState();
}

class _DetailObjectScreenState extends State<DetailObjectScreen> {
  late final model = widget.model;
  bool userAuth = false;
  late bool isSave;

  @override
  void initState() {
    isSave = userFav.any((obj) => obj.id == widget.model?.id);
    userAuth = CacheService.instance.getBool(AppKey.userAuth) ?? false;

    super.initState();
  }

  //! - UI -
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              widget.seeBackButton
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        color: AppColor.white,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    )
                  : Center(),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha((255 * 0.3).toInt()),
                          image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(model?.imageBit ?? ""),
                            ),
                            fit: .cover,
                          ),
                        ),
                        child: model == null
                            ? Center(
                                child: (Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                )),
                              )
                            : Center(),
                      ),
                      Positioned(
                        top: 220,
                        child: ObjectLabelText(
                          label: model?.label ?? "widget.place.label",
                          address: model?.address ?? "widget.place.address",
                        ),
                      ),
                      if (widget.seeBackButton)
                        Positioned(
                          top: 40,
                          left: 0,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColor.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(
                                    (255 * 0.5).toInt(),
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_outlined,
                                color: AppColor.red,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // --- Обновленный ActionsMenu с логикой избранного ---
                  ActionsMenu(
                    onQuizPressed: widget.lookAr && widget.model?.id == 1
                        ? () => RouterService.routeFade(
                            context,
                            MonumentInteractiveScreen(
                              objectId: widget.model?.id ?? 0,
                            ),
                          )
                        : () => emptyToast(
                            context,
                            label: "Временно недоступно",
                            text: "Интерактивный просмотр временно отсутствует",
                          ),
                    onRoutePressed: () {
                      UrlService.openMapsRoute(
                        53.893009,
                        27.567444,
                        model?.oX ?? 55.751244,
                        model?.oY ?? 37.618423,
                        context: context,
                      );
                    },
                    onSavePressed: () {
                      if (userAuth) {
                        isSave
                            ? userFav.removeWhere((obj) => obj.id == model?.id)
                            : (model != null ? userFav.add(model!) : null);
                        setState(() => isSave = !isSave);
                      } else {
                        notRegisteredToast(context);
                      }
                    },
                    onSharePressed: () => UrlService.shareImageWithText(
                      model?.imageBit ?? "",
                      getGreatText(),
                      context: context,
                    ),
                    isSaved: isSave,
                  ),

                  ExpandableFactsMenu(factsText: model?.about ?? "text"),

                  widget.lookComments
                      ? CommentsButton(
                          onPressed: () => userAuth
                              ? showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: AppColor.white,
                                  builder: (context) => ChatBottomSheet(
                                    currentUserId:
                                        CacheService.instance.getInt(
                                          AppKey.userInSystem,
                                        ) ??
                                        0,
                                    objectId: model?.id ?? 0,
                                  ),
                                )
                              : notRegisteredToast(context),
                        )
                      : Center(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height),
            ],
          ),
        ),
      ),
    );
  }

  String getGreatText() {
    return """
${model?.label}
${model?.address}
""";
  }
}
