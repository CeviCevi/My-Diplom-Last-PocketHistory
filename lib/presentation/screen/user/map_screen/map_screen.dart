import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:history/data/state_managment/gui_manager/gui_manager_cubit.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen.dart/detail_object_screen.dart';
import 'package:history/presentation/widget/app/button/tik_tak_button.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/castle_text_field.dart';
import 'package:history/presentation/widget/map_widget/map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _castleController = TextEditingController();

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
              Positioned.fill(child: MapWidget()),
              if (state.objectScreenState)
                Positioned.fill(child: DetailObjectScreen()),
              Padding(
                padding: const .only(top: 40),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CastleTextField(
                      controller: _castleController,
                      searchNewObj: () =>
                          context.read<GuiManagerCubit>().toggle(),
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
                        itemCount: 10,
                        itemBuilder: (context, index) => Padding(
                          padding: .fromLTRB(
                            index == 0 ? 20 : 10,
                            8,
                            index == 10 - 1 ? 20 : 0,
                            8,
                          ),
                          child: TikTakButton(
                            function: () {},
                            text: "Текст $index",
                            colorIndex: index,
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
