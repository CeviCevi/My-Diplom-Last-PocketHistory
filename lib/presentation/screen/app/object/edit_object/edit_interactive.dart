import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/data%20services/marker_service/marker_service.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/widget/app/item/marker_item.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';
import 'package:history/presentation/widget/app/toast/success_toast.dart';
import 'package:image_picker/image_picker.dart';

class MonumentEditorScreen extends StatefulWidget {
  final GestureTapCallback? back;
  final ObjectModel initialObject; // Весь объект с данными
  final ArImageModel initialArImage; // Данные изображения
  final List<MarkerModel> initialMarkers; // Существующие маркеры

  const MonumentEditorScreen({
    super.key,
    this.back,
    required this.initialObject,
    required this.initialArImage,
    required this.initialMarkers,
  });

  @override
  State<MonumentEditorScreen> createState() => _MonumentEditorScreenState();
}

class _MonumentEditorScreenState extends State<MonumentEditorScreen> {
  Uint8List? _selectedImageBytes;
  List<MarkerModel> _markers = [];
  bool _isMenuOpen = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Инициализируем данные извне
    _selectedImageBytes = base64Decode(widget.initialArImage.image);
    _markers = List.from(widget.initialMarkers); // Копируем список
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _isMenuOpen = false;
      });
    }
  }

  void _addNewMarker(Offset localOffset, BoxConstraints constraints) {
    if (_selectedImageBytes == null) {
      errorToast(context, message: "Изображение отсутствует");
      return;
    }
    double xPercent = localOffset.dx / constraints.maxWidth;
    double yPercent = localOffset.dy / constraints.maxHeight;
    _editMarkerDialog(xPercent, yPercent);
  }

  void _editMarkerDialog(double x, double y, {MarkerModel? existing}) {
    final titleController = TextEditingController(text: existing?.title);
    final descController = TextEditingController(text: existing?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? "Новая точка" : "Редактировать"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Название"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Описание"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () {
                setState(
                  () => _markers.removeWhere((m) => m.id == existing.id),
                );
                Navigator.pop(context);
              },
              child: const Text(
                "Удалить",
                style: TextStyle(color: AppColor.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty) return;
              setState(() {
                if (existing != null) {
                  int idx = _markers.indexWhere((m) => m.id == existing.id);
                  if (idx != -1) {
                    _markers[idx] = MarkerModel(
                      id: existing.id,
                      objectId: widget.initialObject.id,
                      title: titleController.text,
                      description: descController.text,
                      xPercent: x,
                      yPercent: y,
                    );
                  }
                } else {
                  _markers.add(
                    MarkerModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      objectId: widget.initialObject.id,
                      title: titleController.text,
                      description: descController.text,
                      xPercent: x,
                      yPercent: y,
                    ),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Готово"),
          ),
        ],
      ),
    );
  }

  Widget _buildFabMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isMenuOpen) ...[
          FloatingActionButton.small(
            heroTag: "save_btn",
            backgroundColor: Colors.green,
            onPressed: () async {
              if (_selectedImageBytes == null) return;

              RouterService.back(context);
              successToast(context, message: "Изменения сохранены");

              await ArImageService().update(
                ArImageModel(
                  id: widget.initialArImage.id,
                  objectId: widget.initialObject.id,
                  image: base64Encode(_selectedImageBytes!),
                ),
              );

              await MarkerService().updateList(_markers);
              await ObjectService().updateOffer(widget.initialObject);
            },
            child: const Icon(Icons.check, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.small(
            heroTag: "exit_btn",
            backgroundColor: Colors.orange,
            onPressed: widget.back,
            child: const RotatedBox(
              quarterTurns: 2,
              child: Icon(Icons.exit_to_app_outlined, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_isMenuOpen) ...[
              FloatingActionButton.small(
                heroTag: "photo_btn",
                backgroundColor: Colors.blue,
                onPressed: _pickImage,
                child: const Icon(Icons.add_a_photo, color: Colors.white),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                heroTag: "clear_btn",
                backgroundColor: AppColor.grey,
                onPressed: () {
                  setState(() {
                    _markers.clear();
                    _isMenuOpen = false;
                  });
                },
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              const SizedBox(width: 12),
            ],
            FloatingActionButton(
              heroTag: "main_btn",
              backgroundColor: AppColor.red,
              onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
              child: Icon(
                _isMenuOpen ? Icons.edit_outlined : Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFabMenu(),
      backgroundColor: AppColor.lightGrey,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapUp: (details) =>
                          _addNewMarker(details.localPosition, constraints),
                      child: Stack(
                        children: [
                          if (_selectedImageBytes != null)
                            Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.cover,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                            ),
                          ..._markers.map((m) {
                            return Positioned(
                              key: ValueKey(m.id),
                              left: m.xPercent * constraints.maxWidth - 20,
                              top: m.yPercent * constraints.maxHeight - 20,
                              child: Draggable(
                                feedback: MarkerItem(),
                                childWhenDragging: const SizedBox.shrink(),
                                onDragEnd: (details) {
                                  final RenderBox box =
                                      context.findRenderObject() as RenderBox;
                                  final local = box.globalToLocal(
                                    details.offset,
                                  );
                                  setState(() {
                                    int idx = _markers.indexWhere(
                                      (element) => element.id == m.id,
                                    );
                                    if (idx != -1) {
                                      _markers[idx] = MarkerModel(
                                        id: m.id,
                                        objectId: m.objectId,
                                        title: m.title,
                                        description: m.description,
                                        xPercent:
                                            ((local.dx + 20) /
                                                    constraints.maxWidth)
                                                .clamp(0, 1),
                                        yPercent:
                                            ((local.dy + 20) /
                                                    constraints.maxHeight)
                                                .clamp(0, 1),
                                      );
                                    }
                                  });
                                },
                                child: GestureDetector(
                                  onTap: () => _editMarkerDialog(
                                    m.xPercent,
                                    m.yPercent,
                                    existing: m,
                                  ),
                                  child: MarkerItem(),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
