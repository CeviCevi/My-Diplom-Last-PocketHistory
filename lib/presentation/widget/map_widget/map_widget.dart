import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/state_managment/gui_manager/gui_manager_cubit.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapWidget> {
  late final MapController _mapController;

  List<LatLng> get _mapPoints => const [
    LatLng(53.902284, 27.561831),
    LatLng(53.917085, 27.557222),
    LatLng(53.904592, 27.554183),
    LatLng(53.925848, 27.601126),
    LatLng(52.082500, 23.655556),
    LatLng(53.451389, 26.472778),
    LatLng(53.223056, 26.691944),
    LatLng(52.572222, 23.798056),
    LatLng(53.677500, 23.829722),
    LatLng(53.678056, 23.826389),
    LatLng(55.190556, 30.205000),
    LatLng(55.192500, 30.207222),
    LatLng(52.423056, 31.015278),
    LatLng(53.896389, 30.331944),
    LatLng(55.485556, 28.758333),
    LatLng(53.887500, 25.299722),
  ];

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(53.9045, 27.5615), // Минск
          initialZoom: 7,
          minZoom: 5,
          maxZoom: 25,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              LatLng(48.0, 20.0), // Юго-запад
              LatLng(60.0, 36.0), // Северо-восток
            ),
          ),
        ),
        children: [
          TileLayer(
            maxNativeZoom: 25,
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_example',
          ),
          BlocBuilder<GuiManagerCubit, GuiManagerState>(
            builder: (context, state) {
              return MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  size: const Size(40, 40),
                  maxClusterRadius: 50,
                  markers: _getMarkers(_mapPoints),
                  builder: (_, markers) {
                    return _ClusterMarker(
                      markersLength: markers.length.toString(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Метод генерации маркеров
  List<Marker> _getMarkers(List<LatLng> mapPoints) {
    return List.generate(
      mapPoints.length,
      (index) => Marker(
        point: mapPoints[index],
        child: GestureDetector(
          onTap: () => context.read<GuiManagerCubit>().toggle(),
          child: Icon(Icons.place_sharp, color: Colors.red, size: 30),
        ),
        width: 50,
        height: 50,
        alignment: Alignment.center,
      ),
    );
  }
}

/// Виджет для отображения кластера
class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({required this.markersLength});

  /// Количество маркеров, объединенных в кластер
  final String markersLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFFF8F8),
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.red, width: 3),
      ),
      child: Center(
        child: Text(
          markersLength,
          style: GoogleFonts.manrope(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
