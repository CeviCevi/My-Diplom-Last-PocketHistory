import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'gui_manager_state.dart';

class GuiManagerCubit extends Cubit<GuiManagerState> {
  GuiManagerCubit() : super(GuiManagerState(objectScreenState: false));

  void toggle() {
    emit(GuiManagerState(objectScreenState: !(state.objectScreenState)));
  }
}
