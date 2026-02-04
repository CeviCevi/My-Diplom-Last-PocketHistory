import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/create_object/widget/create_interactive/create_interactive.dart';
import 'package:history/presentation/screen/app/object/create_object/widget/search_chord_map.dart';
import 'package:history/presentation/widget/app/button/mopdern_icon_button.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/text_field/app_text_field/app_text_field.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class CreateObject extends StatefulWidget {
  const CreateObject({super.key});

  @override
  State<CreateObject> createState() => _CreateObjectState();
}

class _CreateObjectState extends State<CreateObject> {
  final _label = TextEditingController();
  final _address = TextEditingController();
  final _about = TextEditingController();
  final _typeName = TextEditingController();
  final _ox = TextEditingController();
  final _oy = TextEditingController();

  String? imageBase64;
  int screenIndex = 0;

  final picker = ImagePicker();

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

  bool? getLastFunction() {
    return (_label.text != "" &&
        _address.text != "" &&
        _about.text != "" &&
        _typeName.text != "" &&
        _ox.text != "" &&
        _oy.text != "" &&
        imageBase64 != "");
    //: () => errorToast(context, message: "Не все поля заполнены");
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorToast(context, message: "Геолокация выключена");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _ox.text = position.latitude.toString();
      _oy.text = position.longitude.toString();
    });
  }

  ObjectModel createObject() {
    final object = ObjectModel(
      id: DateTime.now().millisecondsSinceEpoch,
      creatorId: CacheService.instance.getInt(AppKey.userInSystem) ?? 0,
      status: 101,
      label: _label.text,
      address: _address.text,
      oX: double.tryParse(_ox.text) ?? 0,
      oY: double.tryParse(_oy.text) ?? 0,
      about: _about.text,
      typeName: _typeName.text,
      imageBit: imageBase64,
    );

    // ObjectService().offerObject(object);
    // RouterService.back(context);
    // successToast(context, message: "Отправлено на модерацию");
    return object;
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
          "Предложить новый объект",
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
      body: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  buildImagePreview(),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: .spaceAround,
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
                    mainAxisAlignment: .spaceAround,
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
                      getLastFunction() ?? false
                          ? setState(() => screenIndex = 0)
                          : errorToast(
                              context,
                              message: "Не все поля заполнены",
                            );
                    },
                    text: "Продолжить",
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          if (screenIndex != 0)
            MonumentCreatorScreen(
              back: () {
                setState(() => screenIndex = 1);
              },
              savePart1: createObject(),
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
            : Center(
                child: Text(
                  'Фото не выбрано',
                  style: GoogleFonts.manrope(
                    color: AppColor.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
