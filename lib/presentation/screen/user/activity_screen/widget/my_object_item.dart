import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/data%20services/marker_service/marker_service.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/edit_object/edit_object.dart';

class MiniObjectCard extends StatefulWidget {
  final ObjectModel model;
  final VoidCallback onTap;
  final bool isRelease;

  const MiniObjectCard({
    super.key,
    required this.model,
    required this.onTap,
    this.isRelease = false,
  });

  @override
  State<MiniObjectCard> createState() => _MiniObjectCardState();
}

class _MiniObjectCardState extends State<MiniObjectCard> {
  List<MarkerModel> markers = [];
  late ArImageModel ar;

  @override
  void initState() {
    super.initState();
    getAr();
  }

  Future<void> getAr() async {
    ar =
        await ArImageService().getImageByObjectId(widget.model.id) ??
        arImageList.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Картинка
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.model.imageBit != null
                  ? Image.memory(
                      base64Decode(widget.model.imageBit!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),

            const SizedBox(width: 12),

            /// Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.model.typeName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.model.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.isRelease)
              Center(
                child: IconButton(
                  onPressed: () => RouterService.routeFade(
                    context,
                    FutureBuilder(
                      future: MarkerService().getMarkerListByObjectId(
                        widget.model.id,
                      ),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.data?.isNotEmpty ?? false) {
                          return EditObjectScreen(
                            initialObject: widget.model,
                            initialArImage: ar,
                            initialMarkers: asyncSnapshot.data!,
                          );
                        } else {
                          return Center();
                        }
                      },
                    ),
                  ),
                  icon: Icon(Icons.edit, color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
