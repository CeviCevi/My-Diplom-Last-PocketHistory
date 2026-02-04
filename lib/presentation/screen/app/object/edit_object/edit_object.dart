import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/create_object/widget/search_chord_map.dart';
import 'package:history/presentation/screen/app/object/edit_object/edit_interactive.dart';
import 'package:history/presentation/widget/app/button/mopdern_icon_button.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/text_field/app_text_field/app_text_field.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class EditObjectScreen extends StatefulWidget {
  final ObjectModel initialObject;
  final ArImageModel initialArImage;
  final List<MarkerModel> initialMarkers;

  const EditObjectScreen({
    super.key,
    required this.initialObject,
    required this.initialArImage,
    required this.initialMarkers,
  });

  @override
  State<EditObjectScreen> createState() => _EditObjectScreenState();
}

class _EditObjectScreenState extends State<EditObjectScreen> {
  late TextEditingController _label;
  late TextEditingController _address;
  late TextEditingController _about;
  late TextEditingController _typeName;
  late TextEditingController _ox;
  late TextEditingController _oy;

  String? imageBase64;
  int screenIndex = 0;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Заполняем контроллеры существующими данными
    _label = TextEditingController(text: widget.initialObject.label);
    _address = TextEditingController(text: widget.initialObject.address);
    _about = TextEditingController(text: widget.initialObject.about);
    _typeName = TextEditingController(text: widget.initialObject.typeName);
    _ox = TextEditingController(text: widget.initialObject.oX.toString());
    _oy = TextEditingController(text: widget.initialObject.oY.toString());
    imageBase64 = widget.initialObject.imageBit;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (file != null) {
      final bytes = await File(file.path).readAsBytes();
      setState(() {
        imageBase64 = base64Encode(bytes);
      });
    }
  }

  // Создаем обновленную модель объекта для передачи на 2-й экран
  ObjectModel getUpdatedObject() {
    return widget.initialObject.copyWith(
      label: _label.text,
      address: _address.text,
      oX: double.tryParse(_ox.text) ?? 0,
      oY: double.tryParse(_oy.text) ?? 0,
      about: _about.text,
      typeName: _typeName.text,
      imageBit: imageBase64,
    );
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _ox.text = position.latitude.toString();
      _oy.text = position.longitude.toString();
    });
  }

  Future<void> openMap() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickLocationMap()),
    );
    if (result != null) {
      setState(() {
        _ox.text = result.latitude.toString();
        _oy.text = result.longitude.toString();
      });
    }
  }

  @override
  void dispose() {
    _label.dispose();
    _address.dispose();
    _about.dispose();
    _typeName.dispose();
    _ox.dispose();
    _oy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Редактировать объект",
          style: AppStyle.main.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => RouterService.back(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        elevation: 1,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 15),
                buildImagePreview(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MopdernIconButton(
                      text: "Камера",
                      icon: Icons.photo_camera,
                      function: () => pickImage(ImageSource.camera),
                    ),
                    MopdernIconButton(
                      text: "Галерея",
                      icon: Icons.photo,
                      function: () => pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                AppTextField(
                  controller: _label,
                  hintText: "Название",
                  icon: Icons.castle_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _address,
                  hintText: "Адрес",
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _typeName,
                  hintText: "Тип",
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _about,
                  hintText: "Описание",
                  icon: Icons.description_outlined,
                  isMultiline: true,
                ),
                const SizedBox(height: 30),
                AppTextField(
                  controller: _ox,
                  hintText: "X координата",
                  icon: Icons.my_location,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _oy,
                  hintText: "Y координата",
                  icon: Icons.my_location,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MopdernIconButton(
                      text: "Моя геолокация",
                      icon: Icons.location_pin,
                      function: getLocation,
                    ),
                    MopdernIconButton(
                      text: "Найти на карте",
                      icon: Icons.map_outlined,
                      function: openMap,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                RedBorderButton(
                  function: () {
                    if (_label.text.isEmpty || imageBase64 == null) {
                      errorToast(context, message: "Заполните основные поля");
                    } else {
                      setState(() => screenIndex = 1);
                    }
                  },
                  text: "Перейти к меткам",
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Если переходим на второй этап редактирования (метки)
          if (screenIndex != 0)
            MonumentEditorScreen(
              back: () => setState(() => screenIndex = 0),
              initialObject: getUpdatedObject(),
              initialArImage: widget.initialArImage,
              initialMarkers: widget.initialMarkers,
            ),
        ],
      ),
    );
  }

  Widget buildImagePreview() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.grey),
        borderRadius: BorderRadius.circular(12),
        color: AppColor.lightGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageBase64 != null
            ? Image.memory(base64Decode(imageBase64!), fit: BoxFit.cover)
            : const Center(child: Text('Фото отсутствует')),
      ),
    );
  }
}
