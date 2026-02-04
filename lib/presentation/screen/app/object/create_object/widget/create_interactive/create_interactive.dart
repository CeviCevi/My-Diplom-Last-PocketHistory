import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/cache_service/router_service.dart';
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

class MonumentCreatorScreen extends StatefulWidget {
  final GestureTapCallback? back;
  final ObjectModel savePart1;
  const MonumentCreatorScreen({super.key, this.back, required this.savePart1});

  @override
  State<MonumentCreatorScreen> createState() => _MonumentCreatorScreenState();
}

class _MonumentCreatorScreenState extends State<MonumentCreatorScreen> {
  Uint8List? _selectedImageBytes;
  List<MarkerModel> _markers = [];
  bool _isMenuOpen = false;
  final ImagePicker _picker = ImagePicker();

  // Выбор изображения
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

  // Добавление нового маркера
  void _addNewMarker(Offset localOffset, BoxConstraints constraints) {
    if (_selectedImageBytes == null) {
      errorToast(context, message: "Сначала выберите изображение");
      return;
    }
    double xPercent = localOffset.dx / constraints.maxWidth;
    double yPercent = localOffset.dy / constraints.maxHeight;
    _editMarkerDialog(xPercent, yPercent);
  }

  // Диалог редактирования/создания
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
                setState(() => _markers.remove(existing));
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
            // Внутри ElevatedButton (кнопка "Готово")
            onPressed: () {
              if (titleController.text.isEmpty) return;
              setState(() {
                if (existing != null) {
                  // Ищем индекс старого маркера по ID и заменяем его на месте
                  int idx = _markers.indexWhere((m) => m.id == existing.id);
                  if (idx != -1) {
                    _markers[idx] = MarkerModel(
                      id: existing.id,
                      objectId: widget.savePart1.id,
                      title: titleController.text,
                      description: descController.text,
                      xPercent: x,
                      yPercent: y,
                    );
                  }
                } else {
                  // Если это новый маркер — просто добавляем
                  _markers.add(
                    MarkerModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      objectId: widget.savePart1.id,
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

  // Сборка Floating Action Button Меню
  Widget _buildFabMenu() {
    return Column(
      mainAxisAlignment: .end,
      crossAxisAlignment: .end,
      children: [
        if (_isMenuOpen) ...[
          FloatingActionButton.small(
            heroTag: "save_btn",
            backgroundColor: Colors.green,
            onPressed: () async {
              if (_selectedImageBytes == null) return;
              RouterService.back(context);
              successToast(context, message: "Объект успешно сохранен");
              await ArImageService().setAr(
                ArImageModel(
                  id: DateTime.now().microsecondsSinceEpoch,
                  objectId: widget.savePart1.id,
                  image: base64Encode(_selectedImageBytes!),
                ),
              );
              await MarkerService().setMarkerList(_markers);
              await ObjectService().offerObject(widget.savePart1);
            },
            child: const Icon(Icons.check, color: Colors.white),
          ),
          const SizedBox(height: 12, width: 12),
          FloatingActionButton.small(
            heroTag: "exit_btn",
            backgroundColor: Colors.orange,
            onPressed: widget.back,
            child: RotatedBox(
              quarterTurns: 2,
              child: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12, width: 12),
        ],
        Row(
          mainAxisAlignment: .end,
          crossAxisAlignment: .end,
          children: [
            if (_isMenuOpen) ...[
              FloatingActionButton.small(
                heroTag: "photo_btn",
                backgroundColor: Colors.blue,
                onPressed: _pickImage,
                child: const Icon(Icons.add_a_photo, color: Colors.white),
              ),
              const SizedBox(height: 12, width: 12),
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
              const SizedBox(height: 12, width: 12),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
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
                            // 1. Подложка (Фото)
                            if (_selectedImageBytes != null)
                              Image.memory(
                                _selectedImageBytes!,
                                fit: BoxFit.cover,
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                              )
                            else
                              const Center(
                                child: Text(
                                  "Добавьте фото и точки",
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // 2. Слой маркеров
                            ..._markers.map((m) {
                              return Positioned(
                                left: m.xPercent * constraints.maxWidth - 20,
                                top: m.yPercent * constraints.maxHeight - 20,
                                child: Draggable(
                                  feedback: MarkerItem(),
                                  childWhenDragging: const SizedBox.shrink(),
                                  onDragEnd: (details) {
                                    final RenderBox renderBox =
                                        context.findRenderObject() as RenderBox;
                                    final localOffset = renderBox.globalToLocal(
                                      details.offset,
                                    );
                                    setState(() {
                                      int idx = _markers.indexOf(m);
                                      _markers[idx] = MarkerModel(
                                        id: m.id,
                                        objectId: m.objectId,
                                        title: m.title,
                                        description: m.description,
                                        xPercent:
                                            ((localOffset.dx + 20) /
                                                    constraints.maxWidth)
                                                .clamp(0, 1),
                                        yPercent:
                                            ((localOffset.dy + 20) /
                                                    constraints.maxHeight)
                                                .clamp(0, 1),
                                      );
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
          ),
        ],
      ),
    );
  }
}
