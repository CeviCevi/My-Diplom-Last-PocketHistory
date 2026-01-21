import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';

class MonumentInteractiveScreen extends StatefulWidget {
  const MonumentInteractiveScreen({super.key});

  @override
  State<MonumentInteractiveScreen> createState() =>
      _MonumentInteractiveScreenState();
}

class _MonumentInteractiveScreenState extends State<MonumentInteractiveScreen>
    with SingleTickerProviderStateMixin {
  final List<_MarkerInfo> markers = [
    _MarkerInfo(
      title: "Барельефы",
      description:
          "На Минской площади Победы, вокруг 38-метрового обелиска, расположены бронзовые горельефы, изображающие сцены героизма и воинской славы, в том числе орден Победы и меч, а также мемориальный зал под площадью с именами Героев Советского Союза, что создает два «огня» — настоящий и символический, увековечивая подвиг народа в Великой Отечественной войне",
      xPercent: 0.5,
      yPercent: 0.55,
    ),
    _MarkerInfo(
      title: "Вечный огонь",
      description:
          "На площади Победы в Минске с 1961 года горит первый в истории Беларуси Вечный огонь. Молодое поколение белорусов вряд ли знает, что архитектурное окружение величественного монумента Победы в центре столицы еще полвека назад было иным: свой нынешний вид площадь приобрела в 1984‑м. Раскрываем уникальные подробности этого преображения.",
      xPercent: 0.65,
      yPercent: .75,
    ),
    _MarkerInfo(
      title: "Обелиск",
      description:
          "Это 38-метровый гранитный обелиск, увенчанный трехметровым изображением ордена Победы.",
      xPercent: 0.5,
      yPercent: 0.30,
    ),
  ];

  _MarkerInfo? selectedMarker;

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
  }

  @override
  void dispose() {
    _markerController.dispose();
    super.dispose();
  }

  void onMarkerTap(_MarkerInfo marker) async {
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
                child: Image.asset("assets/app/pp.jpg", fit: BoxFit.cover),
              ),

              // Маркеры
              ...markers.map((m) {
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
                      child: const Icon(
                        Icons.flag_rounded,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ),
                );
              }),

              // Текстовый блок с анимацией
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: selectedMarker != null
                    ? Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: AnimatedOpacity(
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

class _MarkerInfo {
  final String title;
  final String description;
  final double xPercent;
  final double yPercent;

  _MarkerInfo({
    required this.title,
    required this.description,
    required this.xPercent,
    required this.yPercent,
  });
}
