part of 'gui_manager_cubit.dart';

@immutable
class GuiManagerState {
  final bool objectScreenState;
  final ObjectModel? model;
  const GuiManagerState({required this.objectScreenState, this.model});
}
