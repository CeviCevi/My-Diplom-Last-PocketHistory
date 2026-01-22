// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:history/domain/model/object_model/object_model.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'gui_manager_state.dart';

class GuiManagerCubit extends Cubit<GuiManagerState> {
  GuiManagerCubit() : super(GuiManagerState(objectScreenState: false));

  void toggle({ObjectModel? model, bool lookDetail = false}) {
    emit(GuiManagerState(objectScreenState: lookDetail, model: model));
  }
}
