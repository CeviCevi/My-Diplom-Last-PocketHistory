import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/state_managment/gui_manager/gui_manager_cubit.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen/detail_object_screen.dart';
import 'package:history/presentation/widget/app/button/tik_tak_button.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/castle_text_field.dart';
import 'package:history/presentation/widget/app/toast/empty_toast.dart';
import 'package:history/presentation/widget/map_widget/map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _castleController = TextEditingController();
  final List<IconData?> icons = [
    Icons.flag,
    Icons.theaters,
    Icons.account_balance,
    null,
  ];

  final List<String> types = ["Замки", "Театры", "Парки"];
  List<bool?> isActive = [false, false, false, null];
  late final List<GestureTapCallback?> functions = [
    () => getActivity(0),
    () => getActivity(1),
    () => getActivity(2),
  ];

  bool seeBorder = true;
  void getActivity(int index) {
    setState(() => isActive[index] = !isActive[index]!);
  }

  Future<ObjectModel?> searchByText(BuildContext context) async {
    final query = _castleController.text.trim().toLowerCase();

    final data = await ObjectService().findObjectsByLabel(query: query);

    log('Query: "$query"');
    log('Result: $data');

    if (data.isEmpty) {
      if (context.mounted) emptyToast(context);
      return null;
    }

    if (context.mounted) {
      context.read<GuiManagerCubit>().toggle(lookDetail: false);
      context.read<GuiManagerCubit>().toggle(
        model: data.first,
        lookDetail: true,
      );
    }

    return data.first;
  }

  TextEditingController getController(GuiManagerState state) {
    if (state.objectScreenState &&
        (_castleController.text == "" || _castleController.text.isEmpty)) {
      _castleController.text = state.model?.label ?? "";
    }

    return _castleController;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => seeBorder = false);
    });
  }

  @override
  void dispose() {
    _castleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GuiManagerCubit, GuiManagerState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: FutureBuilder<List<ObjectModel>>(
                  future: ObjectService().findObjectsByTypes(
                    types: [
                      for (int i = 0; i < types.length; i++)
                        if (isActive[i] == true) types[i],
                    ],
                  ),
                  builder: (context, snapshot) {
                    final chords = ObjectService.modelToChords(
                      snapshot.data ?? [],
                    );
                    log(chords.toString());
                    return MapWidget(chords: chords);
                  },
                ),
              ),
              if (state.objectScreenState) // <--
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state.objectScreenState
                        ? DetailObjectScreen(model: state.model)
                        : const SizedBox.shrink(),
                  ),
                ),
              Padding(
                padding: const .only(top: 40),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CastleTextField(
                      controller: getController(state),
                      lookBorder: seeBorder,
                      searchNewObj: () => searchByText(context),
                      backToMainMenu: () =>
                          context.read<GuiManagerCubit>().toggle(),
                      searhObj: state.objectScreenState,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: MediaQuery.of(context).size.width,
                      height: state.objectScreenState ? 0 : 51,
                      child: ListView.builder(
                        scrollDirection: .horizontal,
                        itemCount: types.length,
                        itemBuilder: (context, index) => Padding(
                          padding: .fromLTRB(
                            index == 0 ? 20 : 10,
                            8,
                            index == types.length - 1 ? 20 : 0,
                            8,
                          ),
                          child: TikTakButton(
                            function: functions[index],
                            icon: icons[index],
                            text: types[index],
                            colorIndex: index,
                            isActive: isActive[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
