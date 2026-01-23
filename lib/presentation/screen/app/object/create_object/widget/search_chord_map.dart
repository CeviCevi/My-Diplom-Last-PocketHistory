import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:latlong2/latlong.dart';

class PickLocationMap extends StatefulWidget {
  const PickLocationMap({super.key});

  @override
  State<PickLocationMap> createState() => _PickLocationMapState();
}

class _PickLocationMapState extends State<PickLocationMap> {
  LatLng selected = const LatLng(55.751244, 37.618423);
  final MapController controller = MapController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Выберите точку",
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
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(53.9045, 27.5615), // Минск
          initialZoom: 7,
          minZoom: 5,
          maxZoom: 25,
          initialRotation: 0,
          interactionOptions: InteractionOptions(
            rotationWinGestures: 0,
            rotationThreshold: 0,
          ),
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              LatLng(48.0, 20.0), // Юго-запад
              LatLng(60.0, 36.0), // Северо-восток
            ),
          ),
          onTap: (tapPosition, point) {
            setState(() => selected = point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://a.tile.openstreetmap.de/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.history',
            maxNativeZoom: 19,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: selected,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.lightGrey,
        child: const Icon(
          Icons.check_outlined,
          color: AppColor.black,
          weight: 2,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context, selected);
        },
      ),
    );
  }
}
