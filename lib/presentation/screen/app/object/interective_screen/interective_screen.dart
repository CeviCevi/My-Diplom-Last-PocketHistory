import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:history/const/fish/img/i.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/data%20services/marker_service/marker_service.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/presentation/widget/app/item/marker_item.dart';

class MonumentInteractiveScreen extends StatefulWidget {
  final int objectId;
  const MonumentInteractiveScreen({super.key, required this.objectId});

  @override
  State<MonumentInteractiveScreen> createState() =>
      _MonumentInteractiveScreenState();
}

class _MonumentInteractiveScreenState extends State<MonumentInteractiveScreen>
    with SingleTickerProviderStateMixin {
  MarkerModel? selectedMarker;
  String image = i;
  late Uint8List? _cachedImageBytes = base64Decode(image);

  /// Контроллер для "прыжка" маркеров
  late AnimationController _markerController;
  late Animation<double> _markerAnimation;

  @override
  void initState() {
    super.initState();
    _markerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _markerAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _markerController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageData = await ArImageService().getImageByObjectId(
      widget.objectId,
    );
    if (imageData != null) {
      setState(() {
        image = imageData.image;
        _cachedImageBytes = base64Decode(image);
      });
    }
  }

  @override
  void dispose() {
    _markerController.dispose();
    super.dispose();
  }

  void onMarkerTap(MarkerModel marker) async {
    setState(() {
      selectedMarker = marker;
    });
    await _markerController.forward();
    await _markerController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Интерактивный просмотр",
          style: AppStyle.main.copyWith(fontWeight: .bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => RouterService.back(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        surfaceTintColor: AppColor.lightGrey,
        animateColor: false,
        shadowColor: AppColor.grey,
        elevation: 1,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Фоновое изображение памятника
              SizedBox(
                width: width,
                height: height,
                child: Image.memory(_cachedImageBytes!, fit: BoxFit.cover),
              ),

              // Маркеры
              FutureBuilder(
                future: MarkerService().getMarkerListByObjectId(
                  widget.objectId,
                ),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      ...snapshot.data?.map((m) {
                            final isSelected = selectedMarker == m;
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              left: m.xPercent * width - 12,
                              top: m.yPercent * height - 12,
                              child: GestureDetector(
                                onTap: () => onMarkerTap(m),
                                child: ScaleTransition(
                                  scale: isSelected
                                      ? _markerAnimation
                                      : const AlwaysStoppedAnimation(1.0),
                                  child: Column(
                                    children: [
                                      MarkerItem(),
                                      Container(
                                        height: 30,
                                        width: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: .circular(8),
                                          border: .all(
                                            width: .5,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }) ??
                          List.empty(),
                    ],
                  );
                },
              ),

              // Текстовый блок с анимацией
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: selectedMarker != null
                    ? AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: selectedMarker != null ? 1.0 : 0.0,
                        child: Container(
                          key: ValueKey(selectedMarker),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(200),
                            //borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedMarker!.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedMarker!.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedMarker = null;
                                    });
                                  },
                                  child: const Text(
                                    "Закрыть",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
